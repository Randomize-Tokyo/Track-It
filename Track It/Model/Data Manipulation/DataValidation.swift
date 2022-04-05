//
//  DataValidation.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/18/22.
//

import Foundation
import CoreData
import UIKit

class DataValidation
{
    //MARK: - Variables and Constants
    var pacakges = [PackageObject]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func checkForDuplicaterTrackingNumber(trackingNumber: String) -> Bool
    {
        loadTrackingNumber()
         
        for pacakge in pacakges
        {
            
            if (pacakge.trackingNumber!.description == trackingNumber)
            {
                print("Pacakge Exist already")
                return true
            }
           
        }
        
        saveTrackingNumber()
        return false
    }
}


//MARK: - CoreData
extension DataValidation
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

