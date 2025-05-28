import Foundation
import SwiftUI
import WebKit

/// Состояние загрузки ChickenRace WebView
enum ChickenRaceState: Equatable {
    case idle
    case loading(progress: Double)
    case completed
    case failed(Error)
    case offline

    static func == (lhs: ChickenRaceState, rhs: ChickenRaceState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.completed, .completed), (.offline, .offline):
            return true
        case let (.loading(a), .loading(b)):
            return a == b
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

