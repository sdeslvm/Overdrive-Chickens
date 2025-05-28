import WebKit
import SwiftUI
import Foundation

struct ChickenRaceWebStage: UIViewRepresentable {
    @ObservedObject var viewModel: ChickenRaceViewModel

    func makeCoordinator() -> ChickenRaceNavigator {
        ChickenRaceNavigator(stage: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = createWebView(context: context)
        viewModel.attachWebView(webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        clearWebData()
    }

    private func createWebView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = UIColor.chickenRaceColor(hex: "#141f2b")
        clearWebData()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    private func clearWebData() {
        let types: Set<String> = [
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: .distantPast) {}
    }
}
