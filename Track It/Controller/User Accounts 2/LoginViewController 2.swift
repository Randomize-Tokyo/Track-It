//
//  LoginViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 2/14/22.

import UIKit
import Firebase
import CoreData
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
    var currentNonce:String?
    
    
    
    
    //MARK: - Variables and Constants
    var pacakges = [PackageObject]()
    let refreshControl = UIRefreshControl()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    static var storyBoardID = "LoginViewController"
    
    @IBOutlet weak var trackitText: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
  
    
    
    @IBAction func signInButtonPressed(_ sender: Any)
    {
        LoginUser()
    }
    
    @IBAction func signInGoogle(_ sender: Any)
    {
        let alert = UIAlertController(title: "Not Available", message: "This feature is currently not available", preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:
        { UIAlertAction in
            
        }))
        self.present(alert, animated: true, completion: nil)//Displays the Alert Box
    }
    
    @IBAction func signInApple(_ sender: Any)
    {
        
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)

        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    
    }
    
    @IBAction func signInFacebook(_ sender: Any)
    {
        let alert = UIAlertController(title: "Not Available", message: "This feature is currently not available", preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:
        { UIAlertAction in
           
        }))
        self.present(alert, animated: true, completion: nil)//Displays the Alert Box
    }
    @IBAction func exitButtonPressedn(_ sender: Any)
    {
        UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
        
       //Go to the Home Screen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: HomeViewController.storyBoardID) as! HomeViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
}


//MARK: - View Did Functions and setup functions
extension LoginViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool)
    {
    }

    override func viewDidAppear(_ animated: Bool)
    {
      
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
    }
    
    func setup()
    {
        
        
        //Hide the Back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        annimateTrackitText()
        setupDelgate()
        self.dismissKeyboard() //Dismiss keyboard when not inside the UITextfield
    }
    
}

//MARK: - Animations
extension LoginViewController
{
    func annimateTrackitText()
    {
        
            trackitText.text = ""
           var charIndex = 0.0
           let titleText = "Track it !"
           for letter in titleText
           {
              
               Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false)
               { (timer) in
                   self.trackitText.text?.append(letter)
               }
               charIndex += 1
           
           }
    }
}

//MARK: - UITextField
extension LoginViewController
{
    func setupDelgate()
    {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        switch textField
        {
           case self.emailTextField:
               self.passwordTextField.becomeFirstResponder()
           default:
            self.view.endEditing(true)
            LoginUser()
            
           }
        
        
            
            return false
        }
}

//MARK: - Login Functions
extension LoginViewController
{
    func LoginUser()
    {
        UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
        
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error
                {
                    print(e)
                    //AlertBox
                    let alert = UIAlertController(title: "error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:
                    { UIAlertAction in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)//Displays the Alert Box
                } else
                            
                {
                    //Go to the Home Screen
                    self.addSampleTrackingNumber()
                     let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                     let newViewController = storyBoard.instantiateViewController(withIdentifier: HomeViewController.storyBoardID) as! HomeViewController
                     self.navigationController?.pushViewController(newViewController, animated: true)
                   
                }
            }
        }
    }
    
    func addSampleTrackingNumber()
    {

        let newPackage = PackageObject(context: self.context)
       
        
        //Set Package properties
        newPackage.trackingNumber = "1Z4608V90331525897"
        newPackage.packageDescription = "cat toys"
        newPackage.packageCarrier = "UPS"
        newPackage.circleIndicatorColor = StringLiteral.redColor
        newPackage.currentDescription =  StringLiteral.defaultDescription
        newPackage.carrierLogoName = "UPS"
        
  
        //Add and Save Tracking nNumber
        pacakges.append(newPackage)//add the package to the packages array
       
        
        
        
        
        saveTrackingNumber() //save the packge in the core data model
        
        //Post Notification that a new barcode has been scanned
        postBarcodeNotification(code: StringLiteral.updateHomeViewData)
        
        
        
        DispatchQueue.main.async
        {
            _ = NetWorkManager(packageDetail: newPackage) //get data
        }
      
        
        //Post Notification that a new barcode has been scanned
        postBarcodeNotification(code: StringLiteral.updateHomeViewData)
       
    //}
    
}
    
}


extension LoginViewController
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


//MARK: - Notification Canter
extension LoginViewController
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
        
      
    }
}

extension LoginViewController
{
    private func randomNonceString(length: Int = 32) -> String
    {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    private func sha256(_ input: String) -> String
    {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate
{
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Save authorised user ID for future reference
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = self.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }

            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
                
            // Sign in with Firebase
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                // Mak a request to set user's display name on Firebase
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = appleIDCredential.fullName?.givenName
                changeRequest?.commitChanges(completion: { (error) in

                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Updated display name: \(Auth.auth().currentUser!.displayName)")
                    }
                })
            }
            
            
            //User is signed in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: HomeViewController.storyBoardID) as! HomeViewController
            
            self.navigationController?.popViewController(animated: true)
                self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding
{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
    {
        return self.view.window!
    }
}
