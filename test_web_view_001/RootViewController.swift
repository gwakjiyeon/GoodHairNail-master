//
//  RootViewController.swift
//  sai001Beautyofthesample2
//
//  Created by 곽지연 on 2017/01/20.
//  Copyright © 2017年 sai. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import FirebaseMessaging

class RootViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var tab1Container: UIView!
    @IBOutlet weak var tab2Container: UIView!
    @IBOutlet weak var tab3Container: UIView!
    @IBOutlet weak var tab4Container: UIView!
    @IBOutlet weak var tab1Image: UIImageView!
    @IBOutlet weak var tab2Image: UIImageView!
    @IBOutlet weak var tab3Image: UIImageView!
    @IBOutlet weak var tab4Image: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    var wkWebView:WKWebView!
    var appDelegate:AppDelegate!
    var enquete:EnqueteView!
    var indicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootVC = self
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.tab1Image.isUserInteractionEnabled = true
        self.tab2Image.isUserInteractionEnabled = true
        self.tab3Image.isUserInteractionEnabled = true
        self.tab4Image.isUserInteractionEnabled = true
        self.tab1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab1)))
        self.tab2Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab2)))
        self.tab3Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab3)))
        self.tab4Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab4)))
        
        self.headerImage.isUserInteractionEnabled = true
        self.headerImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickHeader)))
        
        self.enquete = EnqueteView(frame: self.view.frame)
        self.enquete.rootVC = self
        self.view.addSubview(enquete)
        self.enquete.isHidden = true
        // donwload tabs url
        downloadTabsUrl();


    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //WebKitのインスタンス作成
        wkWebView = WKWebView(frame: CGRect(x:0, y:0, width: self.enquete.webViewBase.frame.width , height: self.enquete.webViewBase.frame.height))
        //デリゲートを設定します。
        //以下を設定することで、読み込み開始〜読み込み完了のタイミングのイベントを取得することができるようになります。
        wkWebView.navigationDelegate = self
        wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
        self.enquete.webViewBase.addSubview(wkWebView)
        self.openEnquete()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - open enquete
    
    func openEnquete(){
        let url = URL(string:URL_ENQUETE)!
        self.wkWebView.load(URLRequest(url: url) as URLRequest)
    }
    
    // MARK: - open QR reader
    
    func openQR(){
        self.tab1Container.isHidden = true
        let qrView = QRView(frame: self.view.frame)
        self.view.addSubview(qrView)
    }
    
    // MARK: - on click
    
    @IBAction func onClickPhone(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: nil, message: A0_Prefix().phone_number, preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "通話", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            if let url = NSURL(string: "tel://\(A0_Prefix().phone_number)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in

        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)

    }
    
    func defaultTab(){
        self.backButton.isHidden = true
        self.tab1Container.isHidden = true
        self.tab2Container.isHidden = true
        self.tab3Container.isHidden = true
        self.tab4Container.isHidden = true
        self.tab1Image.image = UIImage(named: "stamp_icon")
        self.tab2Image.image = UIImage(named: "hair_icon")
        self.tab3Image.image = UIImage(named: "list_icon")
        self.tab4Image.image = UIImage(named: "reservation_icon")

    }
    
    func tab1(){
        self.defaultTab()
        self.tab1Container.isHidden = false
        self.tab1Image.image = UIImage(named: "stamp_icon_on")
        if self.appDelegate.tab1VC != nil {
            self.appDelegate.tab1VC.load(urlStr: URL_TAB1)
        }
        DispatchQueue.main.async(){
            if(POPUP_STATE == "always"){
                self.enquete.isHidden = false
                self.openEnquete();
            }
        }
    }
    
    func tab2(){
        defaultTab()
        self.tab2Container.isHidden = false
        self.tab2Image.image = UIImage(named: "hair_icon_on")
        if self.appDelegate.tab2VC != nil {
            self.appDelegate.tab2VC.load(urlStr: URL_TAB2)
        }
    }
    
    func tab3(){
        defaultTab()
        self.tab3Container.isHidden = false
        self.tab3Image.image = UIImage(named: "list_icon_on")
        if self.appDelegate.tab3VC != nil {
            self.appDelegate.tab3VC.load(urlStr: URL_TAB3)
        }
    }
    
    func tab4(){
        defaultTab()
        self.tab4Container.isHidden = false
        self.tab4Image.image = UIImage(named: "reservation_icon_on")
        if self.appDelegate.tab4VC != nil {
            self.appDelegate.tab4VC.load(urlStr: URL_TAB4)
        }
    }
    
    func onClickHeader() {

    }
    
    @IBAction func onClickBackButton(_ sender: UIButton) {
        if !tab1Container.isHidden {
            self.appDelegate.tab1VC.goBack()
        } else if !tab2Container.isHidden {
            self.appDelegate.tab2VC.goBack()
        } else if !tab3Container.isHidden {
            self.appDelegate.tab3VC.goBack()
        } else if !tab4Container.isHidden {
            self.appDelegate.tab4VC.goBack()
        }
    }
    
    // MARK: - open image view
    
    func openImageView(getImg:UIImage){
        let setImgView = ImageView(frame: self.view.frame)
        setImgView.imageView.image = getImg
        self.view.addSubview(setImgView)
    }

    func showPreviewWithURLString(url:String){        
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: URL(string: url)!)
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.openImageView(getImg:image!)
            }
        }
    }
    
    // MARK: - indicator(enquete)
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopIndicator()
    }
    
    func startIndicator(){
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = self.enquete.view.center
        indicator.startAnimating()
        
        self.enquete.view.addSubview(indicator)
    }
    
    func stopIndicator(){
        indicator.stopAnimating()
    }
    
    func downloadTabsUrl(){
        //show indicator
        let alertController = UIAlertController(title: nil, message: "更新データ確認中です\nしばらく\nおまちください\n\n\n", preferredStyle: .alert)
        
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 125.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        
        //request。
        var request = URLRequest(url: URL(string: URL_JSON)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 60.0 // TimeoutInterval in Second
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data,response,error) in
            
            alertController.dismiss(animated: true, completion: nil)
            print("error: \(error)  response: \(response)  data: \(data)")
            if error != nil{
                return
            }
            do {
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                print("Result",resultJson)
                if let tabl1 = resultJson["tab1"] as? String {
                    URL_TAB1 = tabl1
                    self.appDelegate.tab1VC.load(urlStr: URL_TAB1)
                    print("tab1: \(tabl1) ")
                }
                if let tabl2 = resultJson["tab2"] as? String {
                    print("tab2: \(tabl2) ")
                    URL_TAB2 = tabl2
                    self.appDelegate.tab2VC.load(urlStr: URL_TAB2)

                }

                if let tabl3 = resultJson["tab3"] as? String {
                    print("tab3: \(tabl3) ")
                    URL_TAB3 = tabl3
                    self.appDelegate.tab3VC.load(urlStr: URL_TAB3)

                }

                if let tabl4 = resultJson["tab4"] as? String {
                    print("tab4: \(tabl4) ")
                    URL_TAB4 = tabl4
                    self.appDelegate.tab4VC.load(urlStr: URL_TAB4)

                }
                
                if let urlEnquete = resultJson["urlEnquete"] as? String{
                    print("urlEnquete: \(urlEnquete)")
                    URL_ENQUETE = urlEnquete
                }
                
                if let popup = resultJson["popup"] as? String {
                    print("popup: \(popup) ")
                    POPUP_STATE = popup
                    DispatchQueue.main.async(){
                        if(POPUP_STATE != "none"){
                            self.enquete.isHidden = false
                            self.openEnquete();
                        }
                    }
                    
                }
                
                if let stamp = resultJson["stamp"] as? Bool {
                    print("stamp: \(stamp) ")
                    STAMP_SHOW = stamp
                    self.appDelegate.tab1VC.hideOrShowStampAndEnquete(show: STAMP_SHOW)
                }

                
               

            } catch {
                print("Error -> \(error)")
            }
        }
        
        dataTask.resume()
    }
}
