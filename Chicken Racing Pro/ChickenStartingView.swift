import WebKit

final class ChickenRaceNavigator: NSObject, WKNavigationDelegate {
    let stage: ChickenRaceWebStage
    private var didNavigate = false

    init(stage: ChickenRaceWebStage) {
        self.stage = stage
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        beginNavigation()
    }

    func webView(_ webView: WKWebView, didCommit _: WKNavigation!) {
        didNavigate = false
    }

    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        setStatus(.completed)
    }

    func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        setStatus(.failed(error))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        setStatus(.failed(error))
    }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if action.navigationType == .other, webView.url != nil {
            didNavigate = true
        }
        decisionHandler(.allow)
    }

    private func beginNavigation() {
        if !didNavigate {
            setStatus(.loading(progress: 0.0))
        }
    }

    private func setStatus(_ state: ChickenRaceState) {
        DispatchQueue.main.async {
            self.stage.viewModel.chickenRaceStatus = state
        }
    }
}
