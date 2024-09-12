import SwiftUI
import SwiftData

struct Leaderboard: View {

//    @Environment (\.modelContext) private var modelContext

    @Query var players: [Player] 

//    init() {
//        self.players = modelContext.
//    }

    var body: some View {
        List(players.sorted {$0.score > $1.score}) { player in
            HStack {
                Text(player.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("\(player.score)")
            }
        }
    }
}
