//
//  UIView.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/17/22.
//
import UIKit

extension UIView
{
    @IBInspectable var cornerRadius: CGFloat
    {
        get
        {
            return self.cornerRadius
            
        }
        set
        {
            self.layer.cornerRadius = newValue
        }
    }
    
  
         func blink() {
             self.alpha = 0.01
             UIView.animate(withDuration: 0.8, delay: 0, options: [.curveLinear, .repeat, .autoreverse, .allowUserInteraction], animations: {self.alpha = 1.0}, completion: nil)
         }
    
}


extension UIViewController
{
func dismissKeyboard() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}
