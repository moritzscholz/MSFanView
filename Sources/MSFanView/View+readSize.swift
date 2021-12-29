import SwiftUI

extension View {
    /// A modifier that reads the size of the view its attached to.
    ///
    /// Can be used together with a @State, like this:
    /// ```
    /// @State private var textSize: CGSize = .zero
    /// // ...
    /// Text("Hi \(userName)!")
    ///     .readSize { size in
    ///         textSize = size
    ///     }
    /// ```
    ///
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geoProxy in
                Color.clear
                    .preference(key: ViewSizePreferenceKey.self, value: geoProxy.size)
            }
        )
            .onPreferenceChange(ViewSizePreferenceKey.self, perform: onChange)
    }
}

private struct ViewSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}
