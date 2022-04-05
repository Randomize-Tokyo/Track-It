//
//  LoginViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 2/14/22.
//

import UIKit
import Firebase

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate
{
    static var storyBoardID = "ForgetPasswordViewController"
    
    @IBOutlet weak var emailTextFieldPressed: UITextField!
   
    @IBOutlet weak var trackitText: UILabel!
    @IBAction func backButtonPresssed(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func exitButtonPressedn(_ sender: Any)
    {
        UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
        
       //Go to the Home Screen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: HomeViewController.storyBoardID) as! HomeViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    @IBAction func resetButtonPressed(_ sender: Any)
    {
        resetPassword()
    }
    
}


//MARK: - View Did Functions and setup functions
extension ForgetPasswordViewController
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
extension ForgetPasswordViewController
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
extension ForgetPasswordViewController
{
    func setuptextfieldDelgate()
    {
        self.emailTextFieldPressed.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        switch textField
        {
           case self.emailTextFieldPressed:
              print("Doing Something")
           default:
            self.view.endEditing(true)
           
            
           }
        
        
            
            return false
        }
        
    
    
}

//MARK: - Forget Password Functions
extension ForgetPasswordViewController
{
    func resetPassword()
    {
        
            let emailRecived  =  emailTextFieldPressed.text
            
            Auth.auth().sendPasswordReset(withEmail: emailTextFieldPressed.text!)
            { error in
                
                
                let alert = UIAlertController(title: "Email Sent", message: "An email will be sent out if the email provided exisits in the system. Please allow up to 5 minutes to recive the email.", preferredStyle: UIAlertController.Style.alert)
            
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler:
                { UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
            
                self.present(alert, animated: true, completion: nil)//Displays the Alert Box
            }
    }
}
