import SwiftUI

public struct Fan<Items: RandomAccessCollection,
                  ItemContent: View>: View where Items.Element: Hashable & Identifiable {
    public typealias ContentProvider = (Items.Element) -> ItemContent

    private let items: Items

    /// `true` if the fan is open (like a hand of cards) and `false` if not (like a deck of cards).
    ///
    /// This Binding can be animated to get a nice opening-effect like fanning up a deck of cards.
    ///
    @Binding var isOpen: Bool
    /// Leftmost card has this angle (if there is more than one card)
    public let leftAngle: Angle
    /// Rightmost card has this angle (if there is more than one card)
    public let rightAngle: Angle
    /// Higher spread means that the cards are further apart. A spread of 0 has all cards centered
    /// on the same point.
    public let cardSpread: Double
    private let content: ContentProvider

    public init(items: Items,
                opened: Binding<Bool>,
                leftAngle: Angle = .degrees(-30),
                rightAngle: Angle = .degrees(30),
                cardSpread: Double = 1.5,
                content: @escaping ContentProvider) {
        self.items = items
        self._isOpen = opened
        self.leftAngle = leftAngle
        self.rightAngle = rightAngle
        self.cardSpread = cardSpread
        self.content = content
    }

    @State private var fanSize: CGSize = .zero

    public var body: some View {
        HStack {
            ZStack {
                ForEach(cards) { card in
                    content(card.item)
                        .offset(y: -fanSize.height*cardSpread)
                        .rotationEffect(isOpen
                                        ? card.angle
                                        : Angle(degrees: 0))
                        .offset(y: fanSize.height*cardSpread)
                }
            }
            .readSize { fanSize = $0 }
        }
    }

    private var cards: [Card<Items.Element>] {
        guard items.count > 1 else {
            if let onlyCard = items.first {
                return [Card(item: onlyCard, angle: .degrees(0))]
            } else {
                return []
            }
        }

        var angle = leftAngle
        let increaseDeg = (rightAngle.degrees - leftAngle.degrees) / Double(items.count - 1)

        return items.map { item in
            let item = Card(item: item, angle: angle)
            angle += Angle(degrees: increaseDeg)
            return item
        }
    }

    private struct Card<Item: Identifiable>: Identifiable {
        let item: Item
        let angle: Angle

        var id: Item.ID { item.id }
    }
}

struct Fan_Previews: PreviewProvider {
    static var previews: some View {
        FanAdjustablePreview()
    }
}
