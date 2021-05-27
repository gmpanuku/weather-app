//
//  HelpViewController.swift
//  Weather
//
//  Created by Panuku Goutham on 23/05/21.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    var webview = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Help"
        let url = Bundle.main.url(forResource: "Help", withExtension: "html")!
        webViewShown(url: url)
    }
    

    func webViewShown(url: URL) {
        DispatchQueue.main.async {
            let source: String = "var meta = document.createElement('meta');" +
                "meta.name = 'viewport';" +
                "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
            let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            let userContentController: WKUserContentController = WKUserContentController()
            let conf = WKWebViewConfiguration()
            conf.userContentController = userContentController
            userContentController.addUserScript(script)
            let myRequest = URLRequest(url: url)
            if self.webview.isDescendant(of: self.view) {
                self.webview.removeFromSuperview()
            }
            self.webview = WKWebView(frame: .zero, configuration: conf)
            self.webview.backgroundColor = .clear
            self.webview.load(myRequest as URLRequest)
            self.view.addSubview(self.webview)
            
            self.webview.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint(item: self.webview, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: self.webview, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: self.webview, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: self.webview, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0))
        }
    }

}
