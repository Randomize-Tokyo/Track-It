//
//  AddTrakingNumberViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/17/22.
//
import UIKit
import CoreData

//MARK: - Main Class
class AddTrakingNumberViewController: UIViewController
{
    //MARK: - Variables and Constants
    var pacakges = [PackageObject]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var launchBarcodeViewController = false
    static var storyBoardID = "AddTrakingNumberViewController"
    
    //IBOUTLETS
    @IBOutlet weak var barcodeButton: UIButton!
    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var carrierImage: UIImageView!
    //UITextFileds
    @IBOutlet weak var carrierNameLabel: UITextField!
    @IBOutlet weak var packageDescriptionLabel: UITextField!
    @IBOutlet weak var trackingNumberLabel: UITextField!
    
    @IBAction func startTrackingButtonPressed(_ sender: Any)
    {
        //Checking if Tracking Number Exist Already
        let  temp = DataValidation()
        let pacakgeExist = temp.checkForDuplicaterTrackingNumber(trackingNumber: trackingNumberLabel.text!)
        
        if pacakgeExist
        {
            //Do Nothing. Inform the User that the package already exists.
           
            //Alert View Controller
            let alert = UIAlertController(title: "Duplicate Pacakge", message: "Pacakge exists already in the system. You cannot add it again.", preferredStyle: UIAlertController.Style.alert)
        
            //Alert Action
            alert.addAction(UIAlertAction(title: "Got it!", style: .destructive, handler:
            { UIAlertAction in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
        
        
           self.present(alert, animated: true, completion: nil)//Displays the Alert Box
        }
        else
        {
            let newPackage = PackageObject(context: self.context)
            
            //Set Package properties
            newPackage.trackingNumber = trackingNumberLabel.text!
            newPackage.packageDescription = packageDescriptionLabel.text
            newPackage.packageCarrier = carrierNameLabel.text!
            newPackage.circleIndicatorColor = StringLiteral.redColor
            newPackage.currentDescription =  StringLiteral.defaultDescription
            newPackage.carrierLogoName = carrierNameLabel.text!
            
        
            //Add and Save Tracking nNumber
            pacakges.append(newPackage)//add the package to the packages array
            saveTrackingNumber() //save the packge in the core data model
            
            //Post Notification that a new barcode has been scanned
            postBarcodeNotification(code: StringLiteral.updateHomeViewData)
            
            
            
            DispatchQueue.main.async
            {
                _ = NetWorkManager(packageDetail: newPackage) //get data
            }
          
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
}

//MARK: - View Did Functions
extension AddTrakingNumberViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if (launchBarcodeViewController == true)
        {
            self.performSegue(withIdentifier: StringLiteral.barcodeScanner, sender: self)
            launchBarcodeViewController = false
        }
    }

}

//MARK: - Setup Function
extension AddTrakingNumberViewController
{
    func setup()
    {
        //UIVIEW
        registerTargetForLabel()
        registerDelgateForLabel()
        barcodeButton.blink()//Makes the Barcode Button Blink to grab users attention
        registerNotificationCenter()
        self.dismissKeyboard() //Dismiss keyboard when not inside the UITextfield
    }
}

//MARK: - User Input Validation and Textfiled Fundtion
extension AddTrakingNumberViewController: UITextFieldDelegate
{
    func enableButton()
    {
        startTrackingButton.isEnabled = true
        startTrackingButton.alpha = 1.0
    }
    
    func disableButton()
    {
        startTrackingButton.isEnabled = false
        startTrackingButton.alpha = 0.5
    }
    
    func registerTargetForLabel()
    {
        trackingNumberLabel.addTarget(self, action: #selector(AddTrakingNumberViewController.textFieldDidChange(_:)), for: .editingChanged)
        packageDescriptionLabel.addTarget(self, action: #selector(AddTrakingNumberViewController.textFieldDidChange(_:)), for: .editingChanged)
        carrierNameLabel.addTarget(self, action: #selector(AddTrakingNumberViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        disableButton() //disables the button to prevent blank data from being entered
        
    }
    
    func registerDelgateForLabel()
    {
        self.carrierNameLabel.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if (trackingNumberLabel.text!.count == 0) || (packageDescriptionLabel.text!.count == 0) ||  (carrierNameLabel.text!.count == 0)
        {
            disableButton()
        }
        else
        {
            enableButton()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SelectCarrierViewController") as! SelectCarrierViewController
        navigationController?.pushViewController(newViewController, animated: true)
                //self.present(newViewController, animated: true, completion: nil)
        
        
           return false
       }
   
}

//MARK: - Notification Canter
extension AddTrakingNumberViewController
{
    func registerNotificationCenter()
    {
    //Obsereves the Notification
    NotificationCenter.default.addObserver(self, selector: #selector(doWhenNotified(_:)), name: Notification.Name(StringLiteral.notificationKey), object: nil)
    }
    
    func postBarcodeNotification(code: String)
    {
        var info = [String: String]()
        info[code.description] = code.description //post the notification with the key.
        NotificationCenter.default.post(name: Notification.Name(rawValue: StringLiteral.notificationKey), object: nil, userInfo: info)
    }

    @objc func doWhenNotified(_ notiofication: NSNotification)
    {
        
      if let dict = notiofication.userInfo as NSDictionary?
      {
          if let carrier = dict[StringLiteral.postCarrier] as? String
        {
           carrierNameLabel.text = carrier
              carrierImage.image = UIImage(named: carrier.lowercased())
             
              
        }
          if let barcode = dict[StringLiteral.barcodeScannedNotification] as? String
        {
              trackingNumberLabel.text = barcode
              
        }
      }
 
    }
}

//MARK: - CoreData
extension AddTrakingNumberViewController
{
    func saveTrackingNumber()
    {
        do
        {
            try context.save()
        } catch
        {
            print("Error Saving Context \(error)")
        }
    }
    
     func loadTrackingNumber()
     {
        let request : NSFetchRequest<PackageObject> = PackageObject.fetchRequest()
        do
        {
            pacakges = try context.fetch(request)
        }
         catch
         {
            print("Error Loading Context \(error)")
        }
    }
}

