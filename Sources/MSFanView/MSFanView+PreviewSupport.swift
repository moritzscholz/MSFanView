import SwiftUI

/// A card with a given color, for use in previews.
///
struct ColoredCard {
    let color: Color
    let id: UUID = UUID()
}
extension ColoredCard: Hashable, Identifiable {}
let colors: [Color] = [.red, .blue, .green, .gray]

/// Creates a preview with sliders to control the settings of the `Fan`-view.
///
struct FanAdjustablePreview: View {
    @State private var leftAngleDeg: Double = -30
    @State private var rightAngleDeg: Double = 30
    @State private var cardSpread: Double = 1.5
    @State private var numberOfCards: Double = 4

    var items: [ColoredCard] {
        repeatElement(colors, count: Int(ceil(numberOfCards/Double(colors.count))))
            .joined()
            .prefix(Int(numberOfCards))
            .compactMap(ColoredCard.init)
    }

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Slider(value: $leftAngleDeg, in: -360...360) {
                        Text("Left angle")
                    }
                    Text("Left: \(leftAngleDeg, specifier: "%.1f")°")
                }
                VStack {
                    Slider(value: $rightAngleDeg, in: -360...360) {
                        Text("Right angle")
                    }
                    Text("Right: \(rightAngleDeg, specifier: "%.1f")°")
                }
            }
            .padding()

            HStack {
                VStack {
                    Slider(value: $numberOfCards, in: 0...100, step: 1) {
                        Text("Number of cards")
                    }
                    Text("\(numberOfCards, specifier: "%.0f") cards")
                }

                VStack {
                    Slider(value: $cardSpread, in: -10...10) {
                        Text("Card spread")
                    }
                    Text("Spread: \(cardSpread, specifier: "%.1f")")
                }
            }
            .padding()

            Fan(items: items,
                leftAngle: Angle(degrees: leftAngleDeg),
                rightAngle: Angle(degrees: rightAngleDeg),
                cardSpread: cardSpread) { item in
                RoundedRectangle(cornerRadius: 3.0)
                    .foregroundColor(item.color)
                    .aspectRatio(155/230, contentMode: .fit)
            }
                .frame(width: 400, height: 120)
        }

    }
}
