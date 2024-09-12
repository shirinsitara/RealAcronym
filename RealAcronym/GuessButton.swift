import SwiftUI

struct GuessButton : View {

    @ObservedObject var viewModel: ViewModel

    var guess: Bool = false
    var cardTitle: String
    let buttonText: String
    var body: some View {
        Button(buttonText) {
            viewModel.removeWord()
            viewModel.scoreCalculate(cardTitle, guess)
            viewModel.checkProgress()
            print(viewModel.playerScore)
        }
        .foregroundColor(.white)
        .padding()
        .font(.title)
    }
}

struct GuessButtonPanel: View {

    @ObservedObject var viewModel: ViewModel

    var cardTitle: String

    var body: some View {
        HStack {
            GuessButton(viewModel: viewModel, guess: false, cardTitle: cardTitle, buttonText: "no")
                .background(Color(hex: "#A73A48"),
                            in: RoundedRectangle(cornerRadius: 8))
            GuessButton(viewModel: viewModel, guess: true, cardTitle: cardTitle, buttonText: "yes")
                .background(Color(hex: "#22533E"),
                        in: RoundedRectangle(cornerRadius: 8))
        }
    }
}

