//
//  PrivacyPolicyViewController.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/26/22.
//

import Foundation
import UIKit

class TermsOfService: UIViewController
{
    

    //MARK: - Variables and Constants
    static var storyBoardID = "TermsOfService"
    
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - View Did Functions
extension TermsOfService
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
}
