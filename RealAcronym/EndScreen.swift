import SwiftUI
import SwiftData

struct EndScreen: View {

    @ObservedObject var viewModel: ViewModel
    @State private var showLearningView: Bool = false
    @State private var dragOffset: CGSize = .zero

    @Environment (\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            VStack {
                Text("You got \(viewModel.playerScore)/\(viewModel.totalNumberOfCards) right!")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .transition(.scale)
                    .font(.title)

                Spacer().frame(height: 40)

                Button("Retry") {
                    viewModel.retry(viewModel.currentPlayer!)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.yellow)
                        .frame(width: 100, height: 50))
                .foregroundColor(.black)
                .padding(.top)
                .font(.title2)

                Button("Restart as new player") {
                    viewModel.restart()
                }
                .foregroundColor(.teal)
                .font(.title3)
                .underline()
                .padding()
            }

            if showLearningView {
                LearningView(viewModel: viewModel, showLearningView: $showLearningView)
                    .transition(.move(edge: .trailing))
            } else {
                VStack {
                    Spacer()
                    Text("<<<< Swipe here to see what you missed!")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .trailing])
                .offset(x: dragOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < -100 {
                                withAnimation {
                                    showLearningView = true
                                    dragOffset = .zero // Ensure offset resets when the view is shown
                                }
                            } else {
                                dragOffset = gesture.translation
                            }
                        }
                        .onEnded { _ in
                            if dragOffset.width < -100 {
                                withAnimation {
                                    showLearningView = true
                                }
                            } else {
                                withAnimation {
                                    dragOffset = .zero
                                }
                            }
                        }
                )
            }
        }
        .onAppear {
            if let player = viewModel.currentPlayer {
                modelContext.insert(player)
            }
        }
    }
}


#Preview {
    EndScreen(viewModel: ViewModel())
}
