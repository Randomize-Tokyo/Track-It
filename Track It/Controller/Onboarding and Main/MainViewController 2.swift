//
//  MainViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 2/14/22.
//
import UIKit
import Firebase

class MainViewController:UIViewController
{
    static var storyBoardID = "MainViewController"
    var hasAlreadyLaunched: Bool!
}

//MARK: - View Did Functions and other related functions
extension MainViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dismiss(animated: true, completion: nil) // Dismisss the View Controller to prefevent the user from assising this Controller again
        
        //Check for First Time Launch
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        
        
        decideNextVc()

    }
    
    func decideNextVc()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            
            if self.hasAlreadyLaunched == false || self.hasAlreadyLaunched == nil
            {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: OnboardingViewController.storyBoardID) as! OnboardingViewController
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
            
            if Auth.auth().currentUser != nil
            {
                //User is signed in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: HomeViewController.storyBoardID) as! HomeViewController
                
                self.navigationController?.popViewController(animated: true)
                    self.navigationController?.pushViewController(newViewController, animated: true)
              
                
            } else
            {
                //User is signed out
                let storyBoard: UIStoryboard = UIStoryboard(name: "LoginViewController", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: LoginViewController.storyBoardID) as! LoginViewController
                
                self.navigationController?.popViewController(animated: true)
                    self.navigationController?.pushViewController(newViewController, animated: true)
              
               

            }
           
            
        }
    }
    
  
    override func viewDidAppear(_ animated: Bool)
    {
        AppUtility.hideNavigationBar()
        //self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

