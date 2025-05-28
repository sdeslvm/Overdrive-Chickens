import WebKit
import SwiftUI

final class ChickenRaceViewModel: ObservableObject {
    @Published var chickenRaceStatus: ChickenRaceState = .idle
    let url: URL
    private var webView: WKWebView?
    private var progressObserver: NSKeyValueObservation?
    private var lastProgress: Double = 0

    init(url: URL) {
        self.url = url
    }

    func attachWebView(_ webView: WKWebView) {
        self.webView = webView
        observeWebViewProgress(webView)
        reload()
    }

    func setConnection(online: Bool) {
        if online, chickenRaceStatus == .offline {
            reload()
        } else if !online {
            setOffline()
        }
    }

    private func reload() {
        guard let webView else { return }
        let req = URLRequest(url: url, timeoutInterval: 15)
        resetProgress()
        webView.load(req)
    }

    private func resetProgress() {
        DispatchQueue.main.async { [weak self] in
            self?.chickenRaceStatus = .loading(progress: 0)
            self?.lastProgress = 0
        }
    }

    private func setOffline() {
        DispatchQueue.main.async { [weak self] in
            self?.chickenRaceStatus = .offline
        }
    }

    private func observeWebViewProgress(_ webView: WKWebView) {
        progressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.handleProgress(webView.estimatedProgress)
        }
    }

    private func handleProgress(_ progress: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if progress > lastProgress {
                lastProgress = progress
                chickenRaceStatus = .loading(progress: lastProgress)
            }
            if progress >= 1 {
                chickenRaceStatus = .completed
            }
        }
    }
}
