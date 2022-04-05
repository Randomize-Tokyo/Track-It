//
//  AppUtility.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/17/22.
//
import UIKit
import AVFoundation

struct AppUtility
{
    
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask)
    {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate
        {
            delegate.orientationLock = orientation
        }
    }
    
    //Locks the Current View Controller from Rotating.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation)
    {
   
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    static func toggleHapticSuccess()
    {
    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    static func toggleHapticSuccessSoft()
    {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func toggleFlash()
    {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if ((device?.hasTorch) != nil) {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        try device?.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }

    
}

