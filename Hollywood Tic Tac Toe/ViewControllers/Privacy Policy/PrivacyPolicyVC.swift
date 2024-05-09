//
//  PrivacyPolicyVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 07/05/24.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class PrivacyPolicyVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupBaseAppearance()
    }
}

// MARK: - Private
private extension PrivacyPolicyVC {
    
    func setupBaseAppearance() {
        self.navigationController?.isNavigationBarHidden = true
        let url = URL(string: "https://heropulseu.com/privacy-policy-hollywood-tic-tac-toe/")!
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        Helper().addActivityIndicator()
        DispatchQueue.main.async {
            Helper.startLoader()
        }
    }
}

// MARK: - WKNavigationDelegate
extension PrivacyPolicyVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            Helper.stopLoader()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            Helper.stopLoader()
        }
    }
}

// MARK: - Action
private extension PrivacyPolicyVC {
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
