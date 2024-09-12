import Foundation
import SwiftData

@Model
class Player: Identifiable {
    let id: String
    let name: String
    var score: Int

    init(id: String = UUID().uuidString, name: String, score: Int) {
        self.id = id
        self.name = name
        self.score = score
    }
}
