import Foundation
import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var text: String
}

enum DraggingState {
    case normal
    case left
    case right
}

struct CardView: View {

    @State private var isDragging = false
    @State private var dragOffset = CGSize.zero
    @State private var draggingState: DraggingState = .normal

    @ObservedObject var viewModel: ViewModel

    var card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .strokeBorder(Color(hex: "#FABC3C"), lineWidth: 5)
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(cardColor())
                        .animation(.easeInOut, value: draggingState)
                )
                .shadow(radius: isDragging ? 10 : 5)
                .rotationEffect(.degrees(Double(dragOffset.width / 20)))
                .overlay {
                    Text(card.text)
                        .font(.largeTitle)
                }
                .frame(width:300, height: 450)
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            isDragging = true
                            dragOffset = gesture.translation
                        }
                        .onEnded { _ in
                            dragResult()
                        }
                )
                .animation(.easeIn, value: dragOffset)
        }
        .onChange(of: dragOffset) { previous, current in
            if current.width > 100 {
                draggingState = .right
            } else if current.width < -100 {
                draggingState = .left
            } else {
                draggingState = .normal
            }
        }
    }

    private func cardColor() -> Color {
        switch draggingState {
        case .normal:
            return .white
        case .left:
            return Color(hex: "#A73A48")
        case .right:
            return Color(hex: "#22533E")
        }
    }

    private func dragResult() {
        switch draggingState {
        case .normal:
            dragOffset = .zero
        case .left:
            viewModel.removeWord()
            viewModel.scoreCalculate(card.text, false)
            viewModel.checkProgress()
        case .right:
            viewModel.removeWord()
            viewModel.scoreCalculate(card.text, true)
            viewModel.checkProgress()
        }
        dragOffset = .zero
        isDragging = false
    }
}

struct SetOfCards: View {

    @ObservedObject var viewModel: ViewModel

    var cards: [Card]

    var body: some View {
        ZStack {
            ForEach(cards.indices, id: \.self) { index in
                CardView(viewModel: viewModel, card: cards[index])
                    .offset(x: CGFloat(index), y: CGFloat(index) * -20)
                    .scaleEffect(1-(CGFloat(index)*0.05))
                    .zIndex(Double(cards.count - index)) // correct stacking order
            }
        }
        .frame(width: 300, height: 450)
    }
}
