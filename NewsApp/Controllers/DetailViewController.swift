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
    
    var spinner: UIActivityIndicatorView? {
        didSet {
            spinner?.color = .lightGray
            spinner?.style = .large
            
            view.addSubview(spinner ?? UIView())
        }
    }
    
    private var webView: WKWebView!
    
    override func loadView() {
        
        webView = WKWebView()
        
        webView.navigationDelegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        spinner = UIActivityIndicatorView(frame: CGRect(x: screenWidth * 0.5, y: screenHeight * 0.5, width: 0.0, height: 0.0))
        
        if let urlString = articleURL {
            let url = URL(string: urlString)!
            
            webView.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinner?.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        spinner?.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
}
