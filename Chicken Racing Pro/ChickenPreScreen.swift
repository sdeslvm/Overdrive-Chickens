import SwiftUI

struct ChickenRaceScreen: View {
    @StateObject var viewModel: ChickenRaceViewModel

    init(viewModel: ChickenRaceViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            ChickenRaceWebStage(viewModel: viewModel)
                .opacity(viewModel.chickenRaceStatus == .completed ? 1 : 0)
            ChickenRaceOverlay(status: viewModel.chickenRaceStatus)
        }
    }
}

private struct ChickenRaceOverlay: View {
    let status: ChickenRaceState

    var body: some View {
        Group {
            switch status {
            case .loading(let progress):
                ChickenRaceProgressBar(percent: progress)
            case .failed(let error):
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.pink)
            case .offline:
                Text("Offline")
                    .foregroundColor(.gray)
            default:
                EmptyView()
            }
        }
    }
}
