import SwiftUI

struct StartScreen: View {

    @ObservedObject var viewModel: ViewModel
    @State private var playerName: String = ""

    var body: some View {
        VStack{
            Text("Enter Name:")
                .font(.largeTitle)
                .foregroundColor(.white)

            TextField("Player Name", text: $playerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)

            Button(action: {
                viewModel.createPlayer(playerName)
            }) {
                Text("PLAY!")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding()
                    .background(
                        Rectangle()
                            .frame(width: 100, height: 50)
                            .cornerRadius(12)
                            .foregroundColor(.yellow)
                    )
                    .font(.title2)
            }
        }

    }
}

