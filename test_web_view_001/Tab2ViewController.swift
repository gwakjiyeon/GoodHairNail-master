//
//  Tab2ViewController.swift
//  sai001Beautyofthesample2
//
//  Created by 곽지연 on 2017/01/20.
//  Copyright © 2017年 sai. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class Tab2ViewController: UIViewController, WKNavigationDelegate {
    
    var wkWebView:WKWebView!
    var appDelegate:AppDelegate!
    var indicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tab2VC = self
        //WebKitのインスタンス作成
        wkWebView = WKWebView(frame: CGRect(x:0, y:0, width: view.frame.width , height: view.frame.height))
        
        //デリゲートを設定します。
        //以下を設定することで、読み込み開始〜読み込み完了のタイミングのイベントを取得することができるようになります。
        wkWebView.navigationDelegate = self
        wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
        self.view  = wkWebView
        self.load(urlStr: URL_TAB2)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - open url
    
    func load(urlStr:String) {
        if let currentURL  = wkWebView.url?.absoluteString {
            if( urlStr != currentURL){
                let url = URL(string: urlStr)!
                wkWebView.load(URLRequest(url: url) as URLRequest)
            }
        }else{
            let url = URL(string: urlStr)!
            wkWebView.load(URLRequest(url: url) as URLRequest)
        }
    }
    
    // MARK: - url/action check
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // イメージファイルチェック、別のビュー表示
        let mediaExtensions = ["png", "gif", "jpeg", "jpg"]
        let url = navigationAction.request.url?.description
        
        for mediaEx in mediaExtensions {
            if url?.range(of: mediaEx) != nil {
                appDelegate.rootVC.showPreviewWithURLString(url: url!)
                decisionHandler(.cancel)
                
            }
        }
        decisionHandler(.allow)
        
        //back button hide/show
        if navigationAction.navigationType == .linkActivated {
            if A0_Prefix().show_back_tab2 {
                self.appDelegate.rootVC.backButton.isHidden = false
            }
        } else {
            if url == URL_TAB2 {
                self.appDelegate.rootVC.backButton.isHidden = true
            }
        }
    }
    
    // MARK: - indicator(root)
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if self.appDelegate.rootVC.indicatorView.isAnimating {
            self.appDelegate.rootVC.indicatorView.stopAnimating()
        }
        self.appDelegate.rootVC.indicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.appDelegate.rootVC.indicatorView.stopAnimating()
    }
    
    // MARK: - on click
    
    func goBack(){
        if wkWebView.canGoBack {
            wkWebView.goBack()
        }
    }
    
}
