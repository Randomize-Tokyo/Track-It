//
//  BarcodeScnnerViewContoller.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/18/22.
//

import AVFoundation
import UIKit
import Vision

//MARK: - Main Class
class BarcodeScnnerViewContoller: UIViewController
{
    //IBOUTLETS and Variable
    static var storyBoardID = "BarcodeScannerStoryBoard"
    
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var warningTextLabel: UILabel!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var stackViewNavigator: UIView!
    
    //Varaibles
    var currentFlashLightState = StringLiteral.cameraOff
    var captureSession: AVCaptureSession! = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    let metadataOutput = AVCaptureMetadataOutput()
    let imagePicker = UIImagePickerController()
        
    @IBAction func imagePickerButtonPressed(_ sender: UIButton)
    {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func backButtonPressed(_ sender: UIButton)
    {
        dismissCurrentView()
    }
    @IBAction func toggleFlashButtonPressed(_ sender: UIButton)
    {
        //Flash Light is Origniall and currenty Off
        AppUtility.toggleFlash()
        if currentFlashLightState == StringLiteral.cameraOff
        {
            //Camera Flash Enalabed
            currentFlashLightState = StringLiteral.cameraOn
            flashButton.setImage(UIImage(systemName:StringLiteral.boltCircleFill), for: .normal)
        }
        else
        {
            currentFlashLightState = StringLiteral.cameraOff
            flashButton.setImage(UIImage(systemName: StringLiteral.boltSlashCircleFill), for: .normal)
        }
    }
}
//MARK: - "View Did" Functions - Responding to View Events Function
extension BarcodeScnnerViewContoller
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppUtility.toggleHapticSuccessSoft()
        requestCameraPermission() //Ensures App has Access to Use the Camera Functionality
        configureCamera() //Configures the Camera
        enableandUnhideAllUIElements()
        addViewLayers()
        settupImagePicker()
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        //print("In the View Will Appear Function")
        super.viewDidAppear(animated)
        startCaptureSession() //Starts the Capture Session
        AppUtility.lockOrientation(.portrait) //Locks the Orientation for theis View to portrait Mode Only
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        stopCaptureSession()
        
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        AppUtility.lockOrientation(.portrait) //Unlocks the Views Orientation
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       
    }

}
//MARK: - UI Manipulates Elements Functions
extension BarcodeScnnerViewContoller
{
    
    func enableandUnhideAllUIElements()
    {
        pickImageButton.isHidden = false
        //MARK: -cameraFrameImage.isHidden = false //Keep hidden until alternative is found
        warningTextLabel.isHidden = false
        BackButton.isHidden = false
        flashButton.isHidden = false
        pickImageButton.tintColor = UIColor.init(named: StringLiteral.greenTheme)
        warningTextLabel.textColor = .white
        BackButton.tintColor = UIColor.init(named: StringLiteral.greenTheme)
        flashButton.tintColor = UIColor.init(named: StringLiteral.greenTheme)
    }
    
    func dismissCurrentView()
    {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func addViewLayers()
    {
        //Configure the Video Preview Layer and add it to the View. ie Makes the Camera input Visible. with certian parameters.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)
        
        //Displaying UI Elements
        view.bringSubviewToFront(pickImageButton)
        view.bringSubviewToFront(warningTextLabel)
        view.bringSubviewToFront(BackButton)
        view.bringSubviewToFront(flashButton)
        view.bringSubviewToFront(stackViewNavigator)
     
    }

}

//MARK: - Camera Configuration Functions
extension BarcodeScnnerViewContoller: AVCaptureMetadataOutputObjectsDelegate
{
    //Request Permission from the User to Enable the Camera Application.
    func requestCameraPermission()
    {
        
        AVCaptureDevice.requestAccess(for: .video)
        { accessGranted in
            guard accessGranted == true
            else
            {
                self.alertCameraAccessNeeded() //Camera Access Not Granted. Redirects User to Settings app to Enable The Camera
                return
            }
           
        }
        
    }
        
    //Displays an Alert Box informing the User to enable the Camera inorder to use the Barcode version of the app
    //Redirects the User or Dismiss the current view depending on the users selection.
    func alertCameraAccessNeeded()
    {
       DispatchQueue.main.async
        {
            let settingAppURL = URL(string: UIApplication.openSettingsURLString)!
            
            let alert = UIAlertController(title: StringLiteral.cameraAccessRequestTitle, message: StringLiteral.cameraAccessRequestMessage, preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:
            { UIAlertAction in
                self.dismissCurrentView()//Redirects user to last screen
            }))
        
            
              alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler:
            { (alert) -> Void in
                self.dismissCurrentView()//Redirects user to last screen
                UIApplication.shared.open(settingAppURL, options: [:], completionHandler: nil)//Directs user to the Apps Setting to enable Camera
             }))
        
            self.present(alert, animated: true, completion: nil)//Displays the Alert Box
        }
   
    }
    //Comfigure The Camera for Input and Output
    func configureCamera()
    {

        //Sets the Capture Device to Video. Note: Defualts to the Back Camera. Front Camera not reqired in this App.
        //ie -- Get Access to the Actual Camera Module
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else
        {
        failed()
            return
        }
        
        //Get the input from the videoCapture Device ie the Camera
        //ie What the Camera see's is input to the iPhone. That input is now stores in the VideoInput constant.
        let videoInput: AVCaptureDeviceInput
        do
        {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch
        {
            failed()
            return
        }
        
        //Checks if the Capture Session is Allowing input.
        //ie - Camera Stream is now input and is added to the capture session.
        if (captureSession.canAddInput(videoInput))
        {
            captureSession.addInput(videoInput)
        } else
        {
            failed()
            return
        }
        //Check to see if the Capture Session can add output. Output to us is the Cameras input. ie. what the camera sees.
        if (captureSession.canAddOutput(metadataOutput))
        {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.code39, .code128, .code93, .code39Mod43,.ean8]
                //[.ean8, .ean13, .pdf417, .qr, .face, .upce, .code128,.aztec,.catBody,.code39,.code39Mod43,.code93,.dataMatrix,.ean8,.itf14]
            
        } else
        {
           failed()
            return
        }
        //Configure the Video Preview Layer and add it to the View. ie Makes the Camera input Visible. with certian parameters.
       addViewLayers()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
   {
       captureSession.stopRunning()
       if let metadataObject = metadataObjects.first
       {
           print(metadataObjects.description)
           guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
           guard let stringValue = readableObject.stringValue else { return }
           
           DispatchQueue.main.async
           {
               self.postBarcodeNotification(code: stringValue)
           }
           
                       self.dismiss(animated: true, completion: nil)
           navigationController?.popViewController(animated: true)
           
           
       }

       //dismiss(animated: true)
   }

    //Starts the Capture Session
    func startCaptureSession()
    {

        if (captureSession?.isRunning == false)
        {
            captureSession.startRunning()
        }
    }

    //Stops the capture Session
    func stopCaptureSession()
    {
        if (captureSession?.isRunning == true)
        {
            captureSession.stopRunning()
        }
    }
    
    //Error Function.
    func failed()
    {
        print("Somethiong Wierd Happened")
    }
    
}

extension BarcodeScnnerViewContoller: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func settupImagePicker()
    {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    }
    
    //Informs delgate user has picked a image to pass. ie taken a photo or selected from library.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("Image Picked")
        if let userPickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage //gets image from UIImagePickerController
        {
           
            print("Creating detecBarcodeRequest Constant")
            let detectBarcodeRequest = VNDetectBarcodesRequest
            { request, error in
              guard error == nil else
              {
                return
              }
              self.processClassification(request)
            }
            
            print("Creating imageRequestHandler Constant")
            let imageRequestHandler = VNImageRequestHandler(cgImage: userPickerImage.cgImage!, options: [:])
                
            
            print("Performing Request")
            do {
              try imageRequestHandler.perform([detectBarcodeRequest])
                print("Dismissing imgepicker. Images has been selected. ")
                imagePicker.dismiss(animated: true, completion: nil)
               
            } catch {
                print("Erroe in Creating imageRequestHandler Constant")
              print(error)
            }
        }
    }
}

// MARK: - Data Manipulation
extension BarcodeScnnerViewContoller
{
    func processClassification(_ request: VNRequest)
    {
      guard let barcodes = request.results else { return }
        var detectedValues:[String] = []
       
                  for barcode in barcodes //For Loop for Codes Detected.
                  {
                    guard
                      // TODO: Check for QR Code symbology and confidence score
                      let potentialQRCode = barcode as? VNBarcodeObservation,
                        
                        //Specify Code you wish to support
          //            potentialQRCode.symbology == VNBarcodeSymbology.Code128,
          //          potentialQRCode.symbology == VNBarcodeSymbology.QR,
                        
                        potentialQRCode.confidence > 0.1
                      else { return }
                    detectedValues.append(potentialQRCode.payloadStringValue!)
                    //detectedBarcodes(payload: potentialQRCode.payloadStringValue)
                
                  }
       
        if (barcodes.count == 0)
        {
            print("No Barcode Detected") //No Barcode detected.
            alertNoBarCodeDetected()
        }
        else
        {
            DispatchQueue.main.async
            {
                //Removes Duplicates
                let uniquePosts = Array(Set(detectedValues))
                
                print("Uniques and NOn Duplicates are: " + uniquePosts.description)
                
                //Inform the user to pick a barcode
                let alert = UIAlertController(title: "Select a Barcode", message: "", preferredStyle: UIAlertController.Style.alert)
                
               for item in uniquePosts
               {
                alert.addAction(UIAlertAction(title: item.description, style: .default, handler:
                      { UIAlertAction in
                    
                    DispatchQueue.main.async
                    {
                        self.postBarcodeNotification(code: item.description) //notification using alertbox from scanned image
                        
                    }
                    
                        self.dismiss(animated: true, completion: nil) //Dismiss the Current View
                    self.navigationController?.popViewController(animated: true)
                      }))
               }
                
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:
                      { UIAlertAction in }))
                
                self.present(alert, animated: true, completion: nil)//Displays the Alert Box
            }
        }
        
      
        
                
    }

   func  alertNoBarCodeDetected()
   {
    DispatchQueue.main.async
     {
         //let settingAppURL = URL(string: UIApplication.openSettingsURLString)!
         
         let alert = UIAlertController(title: "No BarCode Detected", message: "Unable to Detect/Recongize BarCode", preferredStyle: UIAlertController.Style.alert)
         
         
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
         { UIAlertAction in
            
         }))
        
        alert.addAction(UIAlertAction(title: "RETRY", style: .default, handler:
                                        { [self] UIAlertAction in
            
            self.present(imagePicker, animated: true, completion: nil)
         }))
     
         self.present(alert, animated: true, completion: nil)//Displays the Alert Box
     }
   }

    func postBarcodeNotification(code: String)
    {
        var info = [String: String]()
        info[StringLiteral.barcodeScannedNotification] = code.description
        NotificationCenter.default.post(name: Notification.Name(rawValue: StringLiteral.notificationKey), object: nil, userInfo: info)
        AppUtility.toggleHapticSuccess() //Haptic Indicating Success
        
    }
}

