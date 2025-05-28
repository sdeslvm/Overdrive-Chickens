import Foundation
import SwiftUI

extension UIColor {
    static func chickenRaceColor(hex: String) -> UIColor {
        let clean = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&value)
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

struct ChickenRaceEntry: View {
    var body: some View {
        ChickenRaceRootView()
    }
}

struct ChickenRaceRootView: View {
    var body: some View {
        ChickenRaceScreen(viewModel: .init(url: Self.chickenRaceURL))
            .background(Color(UIColor.chickenRaceColor(hex: "#000000")))
        // #FEC42F
    }

    private static var chickenRaceURL: URL {
        URL(string: "https://overdrivchicke.run/get")!
    }
}

#Preview {
    ChickenRaceEntry()
}
