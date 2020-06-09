//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Shagara F Nasution on 08/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    
    var articleURL: String?
    
    var webView: WKWebView!

    override func loadView() {
        
        webView = WKWebView()
        
        webView.navigationDelegate = self
        
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = articleURL {
            
            let url = URL(string: urlString)!
            
            webView.load(URLRequest(url: url))
            
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

}
