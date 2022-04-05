//
//  EditTrackingNumberViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/22/22.
//

import UIKit
import CoreData

//MARK: - Main View
class EditTrackingNumberViewController: UIViewController
{
    //MARK: - Variables and Constants
    var passedPAckage:PackageObject?
    var pacakges = [PackageObject]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var launchBarcodeViewController = false
    static var storyBoardID = "EditTrackingNumberViewController"
    
    //IBOUTLETS
    @IBOutlet weak var barcodeButton: UIButton!
    
    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var carrierImage: UIImageView!
    //UITextFileds
    @IBOutlet weak var carrierNameLabel: UITextField!
    @IBOutlet weak var packageDescriptionLabel: UITextField!
    @IBOutlet weak var trackingNumberLabel: UITextField!
    
    @IBAction func saveTrackingButtonPressed(_ sender: Any)
    {
        //Update the tracking number
        passedPAckage?.trackingNumber = ""
        passedPAckage?.packageCarrier = ""
        passedPAckage!.packageDescription = ""
        saveTrackingNumber()
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: - View Did Functions
extension EditTrackingNumberViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setDataInTextLabel()
        setup()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    


}

//MARK: - Setup Function
extension EditTrackingNumberViewController
{
    func setup()
    {
        //UIVIEW
        registerTargetForLabel()
        registerDelgateForLabel()
        barcodeButton.blink()//Makes the Barcode Button Blink to grab users attention
        registerNotificationCenter()
    }
}

//MARK: - User Input Validation and Textfiled Fundtion
extension EditTrackingNumberViewController: UITextFieldDelegate
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
    
    func setDataInTextLabel()
    {
        trackingNumberLabel.text = passedPAckage?.trackingNumber
        carrierNameLabel.text = passedPAckage?.packageCarrier
        packageDescriptionLabel.text = passedPAckage?.packageDescription
    }
    
    func registerTargetForLabel()
    {
        trackingNumberLabel.addTarget(self, action: #selector(AddTrakingNumberViewController.textFieldDidChange(_:)), for: .editingChanged)
        packageDescriptionLabel.addTarget(self, action: #selector(AddTrakingNumberViewController.textFieldDidChange(_:)), for: .editingChanged)
        carrierNameLabel.addTarget(self, action: #selector(AddTrakingNumberViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        
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
                self.present(newViewController, animated: true, completion: nil)
        
        
           return false
       }
    
}


//MARK: - Notification Canter
extension EditTrackingNumberViewController
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
          //Do something
              carrierNameLabel.text = carrier
                 carrierImage.image = UIImage(named: carrier.lowercased())
                
              
        }
      
      }
 
    }
}


//MARK: - CoreData
extension EditTrackingNumberViewController
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
