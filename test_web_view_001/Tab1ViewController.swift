//
//  Tab1Controller.swift
//  sai001Beautyofthesample2
//
//  Created by 곽지연 on 2017/01/20.
//  Copyright © 2017年 sai. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class Tab1ViewController: UIViewController, WKNavigationDelegate  {
    
    @IBOutlet weak var stampImg: UIImageView!
    @IBOutlet weak var enqueteImg: UIImageView!
    @IBOutlet weak var webViewBase: UIView!
    @IBOutlet weak var stampImageHieghtConstrant: NSLayoutConstraint!
    var wkWebView:WKWebView!
    var appDelegate:AppDelegate!
    var indicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tab1VC = self
    
        self.stampImg.isUserInteractionEnabled = true
        self.enqueteImg.isUserInteractionEnabled = true
        self.stampImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickStamp)))
        self.enqueteImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEnquete)))
        
        //WebKitのインスタンス作成
        wkWebView = WKWebView()
        
        //デリゲートを設定します。
        //以下を設定することで、読み込み開始〜読み込み完了のタイミングのイベントを取得することができるようになります。
        wkWebView.navigationDelegate = self
        wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
        self.webViewBase.addSubview(wkWebView)
    
        self.hideOrShowStampAndEnquete(show: STAMP_SHOW)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        wkWebView.frame = CGRect(x:0, y:0, width: self.webViewBase.frame.width , height: self.webViewBase.frame.height)
        
        //
        self.stampImageHieghtConstrant.constant = (self.view.frame.width/2)*31/61
        
        self.load(urlStr: URL_TAB1)
        
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
            if A0_Prefix().show_back_tab1 {
                self.appDelegate.rootVC.backButton.isHidden = false
            }
        } else {
            if url == URL_TAB1 {
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
    
    func onClickStamp(){
        if self.appDelegate.rootVC != nil {
            let root = self.appDelegate.rootVC!
            root.openQR()
        }
    }
    
    func onClickEnquete(){
        if self.appDelegate.rootVC != nil {
            let root = self.appDelegate.rootVC!
            
            root.openEnquete()
           // root.view.addSubview(root.enquete)
            root.enquete.isHidden = false
        }
    }
    
    func goBack(){
        if wkWebView.canGoBack {
            wkWebView.goBack()
        }
    }
    
    // stamp and enquete hide or show
    func hideOrShowStampAndEnquete(show:Bool){
        if show {
            DispatchQueue.main.async(){
                self.stampImageHieghtConstrant.constant = (self.view.frame.width/2)*31/61
            }
        }else{
            print("stampImg hide")
            DispatchQueue.main.async(){
               self.stampImageHieghtConstrant.constant = 0
            }
           
        }
    }
    
}
