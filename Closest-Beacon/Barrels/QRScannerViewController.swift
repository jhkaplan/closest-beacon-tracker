//
//  ScanQRCodeViewController.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 4/3/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit
import AVFoundation


class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var mainViewController : MainVC!
    var qrInputBoxValue : String? = nil
    
    let greenBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Green Box")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    var myView: UIView = UIView()
    
    var session: AVCaptureSession!
    var device: AVCaptureDevice!
    var input: AVCaptureDeviceInput!
    var output: AVCaptureMetadataOutput!
    var prevLayer: AVCaptureVideoPreviewLayer!

    func setMyViewConstraints() {
        // centrer la container view dans la vue racine
        self.myView.translatesAutoresizingMaskIntoConstraints = false
        
        // set size bounds
        self.myView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.myView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.myView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.myView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        /*self.qrCodeFrameView.widthAnchor.constraint(equalToConstant: 500).isActive = true
         self.qrCodeFrameView.heightAnchor.constraint(equalToConstant: 500).isActive = true*/
//        self.myView.backgroundColor = UIColor.yellow
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // create session
        self.createSession()

        // add green square
        self.addGreenBox()

        // add my view to root view
        self.view.addSubview(self.myView)
        
        // add constraints
        self.setMyViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addObserverForAVCaptureSessionWasInterrupted()
        self.prevLayer.frame.size = self.myView.frame.size
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }

    func createSession() {

        // get the capture device
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        // try retrieve
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }

        self.session = AVCaptureSession()
        self.session?.addInput(input)
        self.device = captureDevice

        // add output
        self.addOutput()
    
        prevLayer = AVCaptureVideoPreviewLayer(session: session)
        prevLayer.frame.size = myView.frame.size
        prevLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        prevLayer.connection?.videoOrientation = transformOrientation(orientation: UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
        
        myView.layer.addSublayer(prevLayer)
        
        session.startRunning()
    }

    func addOutput() {
        let output = AVCaptureMetadataOutput()
        self.session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    }

    func addGreenBox() {
        self.myView.addSubview(self.greenBoxImageView)
        self.myView.bringSubview(toFront: self.greenBoxImageView)
        self.setupGreenBoxImageView()
    }

    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.prevLayer.connection?.videoOrientation = self.transformOrientation(orientation: UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
            self.prevLayer.frame.size = self.myView.frame.size
        }, completion: { (context) -> Void in
            
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func transformOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }


    func setupGreenBoxImageView() {
        greenBoxImageView.centerXAnchor.constraint(equalTo: self.myView.centerXAnchor).isActive = true
        greenBoxImageView.centerYAnchor.constraint(equalTo: self.myView.centerYAnchor).isActive = true
        greenBoxImageView.widthAnchor.constraint(equalToConstant: 333).isActive = true
        greenBoxImageView.heightAnchor.constraint(equalToConstant: 333).isActive = true
    }


    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    self.mainViewController.setInputBox(text: object.stringValue!)
                    _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func addObserverForAVCaptureSessionWasInterrupted()
    {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureSessionWasInterrupted,
                                                     object: nil,
                                                     queue: mainQueue)
        { (notification: Notification) -> Void in
            
            guard let userInfo = notification.userInfo else
            {
                return
            }
            
            // Check if the current system is iOS9+ because AVCaptureSessionInterruptionReasonKey is iOS9+ (relates to Split View / Slide Over)
            if #available(iOS 9.0, *)
            {
                if let interruptionReason = userInfo[AVCaptureSessionInterruptionReasonKey],
                    Int(interruptionReason as! NSNumber) == AVCaptureSession.InterruptionReason.videoDeviceNotAvailableWithMultipleForegroundApps.rawValue
                {
                    // Warn the user they need to get back to Full Screen Mode
                    let alert = UIAlertController(title: "Splitview Not Supported",
                                                  message: "Splitview is Not supported",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                // Fallback on earlier versions. From iOS8 and below Split View and Slide Over don't exist, no need to handle anything then.
            }
        }
    }

}
