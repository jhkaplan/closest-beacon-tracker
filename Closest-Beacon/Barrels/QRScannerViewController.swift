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
    
    var qrCodeFrameView: UIView?
    var video = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        
        // Define capture device
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
            
            
        }
        catch {
            print(error)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()

    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    // Extracting the data from QR code and presenting it as a string value
                    // Set value as input box text
                    self.mainViewController.setInputBox(text: object.stringValue!)
//                    let alert = UIAlertController(title: "Barrel Identified", message: object.stringValue, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { (nil) in
//                        self.dismiss(animated: true, completion: nil)
//                    }))
//                    self.present(alert, animated: true)
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
