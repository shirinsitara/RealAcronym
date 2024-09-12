import Foundation

class ViewModel: ObservableObject {

    var realAcronymsDictionary: [String: String] = [:]
    var realAcronyms: [String] = []
    private let dummyAcronyms = ["CAR", "POOK", "SEE", "PIZ", "LOL", "DOJO", "CARDS", "PPPPP"]

    var wordsPlayed:[String] = []
    var wordResult: [String: Bool] = [:]

    private (set) var players: [Player]
    @Published private (set) var cards: [Card]

    //private let realAcronynms: [String] = [] /*Set(["CARBS", "MPP", "CPP"])*/
    private (set) var playerScore = 0
    @Published private (set) var gameState: GameState
    private (set) var totalNumberOfCards = 0

    private (set) var currentPlayer: Player?

    init(players: [Player] = [], cards: [Card] = [], gameState: GameState = .inStart) {
        self.players = players
        self.cards = cards
        self.gameState = gameState
    }

    func loadJSON() -> [String: String] {
        var result = [String: String]()
        if let url = Bundle.main.url(forResource: "acronyms", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let acronyms = try decoder.decode([Acronym].self, from: data)
                result = Dictionary(uniqueKeysWithValues: acronyms.map {
                    ($0.word, $0.meaning)})
            } catch {
                print("Error loading or decoding JSON: \(error)")
            }
        } else {
            print("JSON file not found")
        }
        return result
    }

    func startGame() {
        cards = []
        gameState = .inStart
        players = []
        realAcronymsDictionary = loadJSON()
        realAcronyms = Array(realAcronymsDictionary.keys)
        defineWords()
        totalNumberOfCards = cards.count
        // fetch persisted data
    }

    func defineWords() {
        let totalNumber = 5
        let correctNumber: Int = Int.random(in: 0...totalNumber)
        let wrongNumber = totalNumber - correctNumber
        var wordsInPlay = Array(realAcronyms.shuffled().prefix(correctNumber))
        wordsInPlay.append(contentsOf:Array(dummyAcronyms.shuffled().prefix(wrongNumber)))

        for i in wordsInPlay.shuffled() {
            cards.append(Card(text: i))
            wordsPlayed.append(i)
        }
    }

    func createPlayer(_ name: String) {
        let new_player = Player(name: name, score: 0)
        //players.append(new_player)
        self.gameState = .inProgress
        currentPlayer = new_player
    }

    func removeWord() {
        if !cards.isEmpty {
            cards.removeFirst()
        } else {
            print("cards are done!")
        }
    }

    func scoreCalculate(_ cardTitle: String,_ guess: Bool) {
        let isValid: Bool = realAcronyms.contains(cardTitle)
        let guessedValid: Bool = guess
        if isValid == guessedValid {
            playerScore += 1
        }
        wordResult[cardTitle] = isValid == guessedValid
    }

    func checkProgress() {
        guard cards.count == 0 else { return }
        currentPlayer?.score = playerScore
        self.gameState = .isOver
        if currentPlayer != nil {
            players.append(currentPlayer!)
        }
        // persist
    }

    func shuffle() {
        cards.shuffle()
    }

    func restart() {
        //shuffle()  -> control this within shuffle
        playerScore = 0
        self.gameState = .inStart
        defineWords()
        wordResult = [:]
    }

    func retry(_ currentPlayer: Player) {
        playerScore = 0
        players.removeLast()
        self.gameState = .inProgress
        defineWords()
        wordResult = [:]
    }

    enum GameState {
        case inStart, inProgress, isOver
    }
}


