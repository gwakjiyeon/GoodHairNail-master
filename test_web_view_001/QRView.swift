//
//  QRView.swift
//  sai001Beautyofthesample2
//
//  Created by 곽지연 on 2017/01/23.
//  Copyright © 2017年 sai. All rights reserved.
//

import UIKit
import AVFoundation

class QRView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var captureBase: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var appDelegate:AppDelegate!
    
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
        let nib:    UINib               = UINib(nibName: "QRView", bundle: bundle)
        let view:   UIView              = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame                      = frame
        self.addSubview(view)
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.

        let input: AnyObject! = try! AVCaptureDeviceInput(device: captureDevice)

        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = CGRect(x:0, y:0, width: frame.width * 0.8, height:frame.width * 0.8)
        captureBase.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        captureSession?.startRunning()

    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            messageLabel.text = "検知されたQRコードがありません"
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            let content = metadataObj.stringValue as String?
            
            if content != nil {
                if content!.hasPrefix("http") {
                    self.appDelegate.rootVC.tab1Container.isHidden = false
                    self.appDelegate.tab1VC.load(urlStr: content!)
                    self.removeFromSuperview()
                }
                else {
                    messageLabel.text = "正しくないQRコードです"
                }
                
            }
        }
    }
    
    // MARK: - on click
    
    @IBAction func onClickClose(_ sender: UIButton) {
        self.appDelegate.rootVC.tab1Container.isHidden = false
        self.removeFromSuperview()
    }
    
}

