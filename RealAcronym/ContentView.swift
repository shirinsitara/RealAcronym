import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            Color(hex: "#381340").ignoresSafeArea()

            VStack {
                if viewModel.gameState == .inProgress {
                    //add text to present question
                    Text("\(viewModel.cards.count) cards left")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                        .transition(.move(edge: .top))
                        .animation(.easeIn, value: viewModel.cards.count)
                        .padding()
                    Spacer()
                    Text("Is this a real DOJO acronym?")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    SetOfCards(viewModel: viewModel, cards: viewModel.cards)
                    Spacer()
                    GuessButtonPanel(
                        viewModel: viewModel,
                        cardTitle: topCardTitle()
                    )
                } else if viewModel.gameState == .isOver {
                    VStack {
                        EndScreen(viewModel: viewModel)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                        Leaderboard(players: viewModel.players)
                        Leaderboard()
                    }
                } else {
                    StartScreen(viewModel: viewModel)
                }
            }
        }
        .animation(.easeIn, value: viewModel.gameState)
        .onAppear {
            viewModel.startGame()
        }
    }

    private func topCardTitle() -> String {
        viewModel.cards.first?.text ?? "N/A"
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}

