//
//  EnqueteView.swift
//  sai001Beautyofthesample2
//
//  Created by 곽지연 on 2017/01/20.
//  Copyright © 2017年 sai. All rights reserved.
//

import UIKit

class EnqueteView: UIView {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var webViewBase: UIView!
    @IBOutlet var view: UIView!
    
    var rootVC:RootViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit(frame: frame)
    }
    
    func commonInit(frame: CGRect) {
        
        // XIB読み込み
        let bundle: Bundle            = Bundle(for: type(of: self))
        let nib:    UINib               = UINib(nibName: "EnqueteView", bundle: bundle)
        let view:   UIView              = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame                      = frame
        self.addSubview(view)
        
        self.sendButton.layer.cornerRadius = 5
        
        self.sendButton.isHidden = true
    }
    
    // MARK: - on click
    
    @IBAction func onClickClose(_ sender: UIButton) {
        if let indicator = self.rootVC.indicator {
            if indicator.isAnimating {
                self.rootVC.stopIndicator()
            }
        }
        //self.removeFromSuperview()
        self.isHidden = true
    }
    
    @IBAction func onClickSend(_ sender: UIButton) {
        // submit action
        
    }
}
