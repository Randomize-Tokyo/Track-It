//
//  File.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/23/22.
//

import UIKit
import Firebase
import CoreData

class SideMenuViewController: UIViewController
{
 
    
    //MARK: - Variables and Constants
    var packages = [PackageObject]()
    var filteredPackages: [PackageObject] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var welcomeTExt: UILabel!
    @IBOutlet weak var accountStatusButton: UIButton!
    @IBOutlet weak var instagramImage: UIImageView!
    @IBOutlet weak var currentVersion: UIButton!
    
    @IBAction func checkBackLater(_ sender: Any)
    {
        let alert = UIAlertController(title: "⚙️ Work in Progress ⚙️", message: "Please check back soon. More features and carriers are coming soon. We cant wait for you to see them! Donations are highly appretiated and will assist in speeding this process up. Follow us on instagram to keep up!!", preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
        { UIAlertAction in

            self.hideSideMenu()
        }))
        
      
        
      
        self.present(alert, animated: true, completion: nil)//Displays the Alert Box
    }
    

    @IBAction func donationButtonPressed(_ sender: Any)
    {
       
        if let url = URL(string: "https://www.buymeacoffee.com/adebayosotannde")
        {
            UIApplication.shared.open(url)
        }
        hideSideMenu()
    }
    @IBAction func signonandLogoutPressed(_ sender: Any)
    {
        loginOrSignout()
    }
    
   
    
    
    
    func hideSideMenu()
    {
        postBarcodeNotification(code: StringLiteral.hideSideMenu) //Hide the side menu
    }
   
}

//MARK: - View Did Functions
extension SideMenuViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
       
        //TODO: - Check if user is signed in
      
    }
}

//MARK: - Setup Function
extension SideMenuViewController
{
    func setup()
    {
        //UIVIEW
        loadTrackingNumber()
        addTargetforImage()
        updateAccountButton()
        updateWelcomeText()
        currentVersion.setTitle("v "  + "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)", for: .normal) //Gets the current version
        
       
    }
}

//MARK: - Target and other functions
extension SideMenuViewController
{
    func addTargetforImage()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SideMenuViewController.imageTapped))
        instagramImage.addGestureRecognizer(tapGesture)
        instagramImage.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped()
    {
        
           print("Image Tapped")
        
        hideSideMenu()
           //WebSiteRequest(packageDetail: passedPAckage!)
        let Username =  "trackit.official" // Your Instagram Username here
           let appURL = URL(string: "instagram://user?username=\(Username)")!
           let application = UIApplication.shared

           if application.canOpenURL(appURL)
        {
               application.open(appURL)
        }
        else
        {
               // if Instagram app is not installed, open URL inside Safari
               let webURL = URL(string: "https://instagram.com/\(Username)")!
               application.open(webURL)
        }
    }
    
}

//MARK: - Notification Canter
extension SideMenuViewController
{
    func registerNotificationCenter()
    {
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
 
    }
    
}

//MARK: - Firebase Functions
extension SideMenuViewController
{
    
    func updateAccountButton()
    {
        //-if signed in change Log in/ sign up to ---> Sign out
        
        if Auth.auth().currentUser != nil
        {
            accountStatusButton.setTitle("Sign Out", for: .normal)
        } else
        {
           //User Not logged in
            accountStatusButton.setTitle("Log in / Sign up", for: .normal)

        }
    }
    
    func  updateWelcomeText()
    {
        if Auth.auth().currentUser != nil
        {
            welcomeTExt.text = Auth.auth().currentUser?.email?.description
        
        } else
        {
           //User Not logged in
            welcomeTExt.text = "Welcome"

        }
    }
    
    func loginOrSignout()
    {
        //Sign User Out if User is Currently Logged in
                if Auth.auth().currentUser != nil
                {
                    do
                       {
                           try Auth.auth().signOut()
                         //  hideSideMenu()
                               // your code here
                               let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                                 let ViewController = storyBoard.instantiateViewController(withIdentifier: HomeViewController.storyBoardID) as! HomeViewController
        
                            
                               self.navigationController?.modalPresentationStyle = .popover
                               self.navigationController?.pushViewController(ViewController, animated: false)
                           
                       }
                       catch let error as NSError
                       {
                           print(error.localizedDescription)
                       }
                    
                    
                }
        
      deleteAllObjectsCoreData()
      

         let storyBoard: UIStoryboard = UIStoryboard(name: "LoginViewController", bundle: nil)
         let addBarcodeViewController = storyBoard.instantiateViewController(withIdentifier: LoginViewController.storyBoardID) as! LoginViewController

            self.navigationController?.modalPresentationStyle = .popover
            self.navigationController?.pushViewController(addBarcodeViewController, animated: true)
        
        
        
        
}
    
}


//MARK: - CoreData
extension SideMenuViewController
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
            packages = try context.fetch(request)
        }
         catch
         {
            print("Error Loading Context \(error)")
        }
    }
    
    
    func deleteAllObjectsCoreData()
    {
        
        let fetchRequest: NSFetchRequest<PackageObject> = PackageObject.fetchRequest()
        
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }

        do {
            try context.save()
        } catch {
            //Handle error
        }
        
        
       
    }
    
    
}
