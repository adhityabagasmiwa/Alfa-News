//
//  WebviewViewController.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 18/09/23.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .all
        webView.configuration.allowsInlineMediaPlayback = false
        webView.configuration.upgradeKnownHostsToHTTPS = true
        
        mainView = webView
        webView.load(URLRequest(url: url))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension WebviewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showHideCircluarLoading(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title ?? ""
        showHideCircluarLoading(false)
    }
}
