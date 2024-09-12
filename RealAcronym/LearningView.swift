import SwiftUI

struct LearningView: View {

    @ObservedObject var viewModel: ViewModel
    @Binding var showLearningView: Bool
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.black)
                .padding()
                .shadow(radius: 10)

            VStack(spacing: 10) {
                ForEach(viewModel.wordResult.keys.sorted(), id: \.self) { word in
                    HStack{
                        Text(word)
                            .font(.headline)
                            .foregroundColor(viewModel.wordResult[word]! ? .green : .red)
                        Text(getMeaning(word))
                            .font(.headline)
                            .foregroundColor(viewModel.wordResult[word]! ? .green : .red)
                    }
                }
                .padding(.bottom)

                Text("Go back >>>")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding([.bottom, .leading])
            }
            .padding()
        }
        .offset(x: dragOffset.width)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if showLearningView {
                        dragOffset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if dragOffset.width > 100 {
                        withAnimation {
                            showLearningView = false
                        }
                    } else {
                        withAnimation {
                            dragOffset = .zero
                        }
                    }
                }
        )
    }

    func getMeaning (_ word: String)->String {
        if viewModel.realAcronyms.contains(word) {
            return "- " + viewModel.realAcronymsDictionary[word]!
        } else {
            return "- not real"
        }

    }
}
