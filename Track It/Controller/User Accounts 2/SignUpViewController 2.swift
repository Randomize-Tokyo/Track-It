//
//  LoginViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 2/14/22.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    static var storyBoardID = "SignUpViewController"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    @IBOutlet weak var trackitText: UILabel!
    @IBAction func exitButtonPressedn(_ sender: Any)
    {
        UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
        
       //Go to the Home Screen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: HomeViewController.storyBoardID) as! HomeViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any)
    {
        SignUserUp()
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
        let alert = UIAlertController(title: "Not Available", message: "This feature is currently not available", preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:
        { UIAlertAction in
            
        }))
        self.present(alert, animated: true, completion: nil)//Displays the Alert Box
    }
    
    @IBAction func signInFacebook(_ sender: Any)
    {
        let alert = UIAlertController(title: "Not Available", message: "This feature is currently not available", preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:
        { UIAlertAction in
            
        }))
        self.present(alert, animated: true, completion: nil)//Displays the Alert Box
    }
   
    
    @IBAction func clickTermsAndConditions(_ sender: Any)
    {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "TermsOfService", bundle: nil)
        let packageView = storyBoard.instantiateViewController(withIdentifier: TermsOfService.storyBoardID) as! TermsOfService



        //Dismiss Navigation View Controller.
       navigationController?.pushViewController(packageView, animated: true)
        
    }
}


//MARK: - View Did Functions and setup functions
extension SignUpViewController
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
        
        annimateTrackitText()
        setuptextfieldDelgate()
        self.dismissKeyboard() //Dismiss keyboard when not inside the UITextfield
       
    }
    
}

//MARK: - Animations
extension SignUpViewController
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
extension SignUpViewController
{
    func setuptextfieldDelgate()
    {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.verifyPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        switch textField
        {
           case self.emailTextField:
               self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.verifyPasswordTextField.becomeFirstResponder()
           default:
            self.view.endEditing(true)
           
            
           }
        
        
            
            return false
        }
        
    
    
}
//MARK: - Sign up Functions
extension SignUpViewController
{
    func SignUserUp()
    {
        if passwordTextField.text! == verifyPasswordTextField.text!
        {
           if let email = emailTextField.text, let password = passwordTextField.text
           {
               Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
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
                       //AlertBox
                       let alert = UIAlertController(title: "Sucess", message: "Account Sucessfully Created. Press Ok to go Home", preferredStyle: UIAlertController.Style.alert)
                   
                       alert.addAction(UIAlertAction(title: "Go Home", style: .default, handler:
                    { action in
                           
                           
                           //Go to the Home Screen
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: HomeViewController.storyBoardID) as! HomeViewController
                            self.navigationController?.pushViewController(newViewController, animated: true)
                           
                           
                       }))
                       
                       
                       self.present(alert, animated: true, completion: nil)//Displays the Alert Box
                      
                   }
               }
           }
       }
        else
        {
            //AlertBox
            let alert = UIAlertController(title: "Password Error", message: "Passwords do not match. ", preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:
            { UIAlertAction in
                
            }))
            self.present(alert, animated: true, completion: nil)//Displays the Alert Box
        }
        
    }
    
}
