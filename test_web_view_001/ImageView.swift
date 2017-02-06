//
//  ImageView.swift
//  sai001Beautyofthesample2
//
//  Created by 곽지연 on 2017/01/23.
//  Copyright © 2017年 sai. All rights reserved.
//

import Foundation
import UIKit

class ImageView: UIView, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
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
        let nib:    UINib               = UINib(nibName: "ImageView", bundle: bundle)
        let view:   UIView              = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame                      = frame
        self.addSubview(view)

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0

    }
    
    // MARK: - on click
    
    @IBAction func onClickClose(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    // MARK: - zoom
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.updateImageViewOrigin()
    }
    
    func updateImageViewOrigin() {
        var rect = imageView.frame
        let bounds = scrollView.bounds
        
        rect.origin = CGPoint()
        if rect.width < bounds.width {
            rect.origin.x =  (bounds.width - rect.width) * 0.5
        }
        if rect.height < bounds.height {
            rect.origin.x =  (bounds.height - rect.height) * 0.5
        }
        
        imageView.frame = rect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
