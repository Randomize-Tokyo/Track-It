//
//  UPSREQUEST.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/18/22.
//
import Foundation
import CoreData
import UIKit

class UPSREQUEST
{
    //APi Key's
    let accessLicenseNumber = "ADA63D6F8AE82A95" //UPS Access Number
    
    //Core Cata
    
    var packages = [PackageObject]() //All the package Objects gotten from Core Data
    var passedPackage: PackageObject
    
    var index = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(package: PackageObject)
    {
      passedPackage = package//Set the package object
    retriveData(trackingNumber: passedPackage.trackingNumber!)
       
      
    }
    

  
    func retriveData(trackingNumber: String)
    {

        let url = URL(string: "https://onlinetools.ups.com//track/v1/details/" + trackingNumber + "?locale=en_US" )

        guard let requestUrl = url else
        {
            print("UPS: Error Parsing Data")
            return
        }

        var request = URLRequest(url: requestUrl) // Create URL Request
        request.httpMethod = "GET"  // Specify HTTP Method to use
        request.setValue(accessLicenseNumber, forHTTPHeaderField: "AccessLicenseNumber") // Set HTTP Request Header

        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in

        // Check if Error took place
        if let error = error
        {
                        print("Error took place \(error)")
                        return
        }

        //Read HTTP Response Status code
            if let response = response as? HTTPURLResponse
            {
           
            }
     
//        if let response = response as? HTTPURLResponse
//        {
//
//        }
//
        // Convert HTTP Response Data to a simple String
        if let data = data, let dataString = String(data: data, encoding: .utf8)
        {
    
            
           
            
            guard (try? JSONDecoder().decode(UPSJSONDATA.self, from: dataString.data(using: .utf8)!)) != nil else
            {
               
                print("Failed")
                self.passedPackage.isValidTrackingNumber = false
                
                self.saveTrackingNumber()
                
                return
            }
            
           
            let data = DataManager(package: self.passedPackage)
           
            self.passedPackage.isValidTrackingNumber = true // set tracking number
            self.passedPackage.testData = dataString.data(using: .utf8)
            self.passedPackage.currentDescription = data.getMostRecentActivityDescription()
            self.passedPackage.circleIndicatorColor = data.getMostRecentColorIndicatorStatus()
            self.passedPackage.lastUpdated = data.getWhenThePackageWasLastUpdated()
           // self.passedPackage.lastLocation = data.getMostRecentLocation() //Never used. Incoperate into next update?
            self.passedPackage.delivered = data.getIfPackageHasbeenDelivered()
            self.saveTrackingNumber()
            
            DispatchQueue.main.async
            {
                self.postBarcodeNotification(code: StringLiteral.updateHomeViewData)
                self.postBarcodeNotification(code: StringLiteral.updatePackageViewController)
               
            }
            
            
           
           
            
          
    
           

        }


        }
                task.resume()



}
    
    
    
}

//MARK: -CoreData Functions
extension UPSREQUEST
{
    func saveTrackingNumber()
    {
        do
        {
            try context.save()
        } catch
        {
            print("Error saving category \(error)")
        }
    }
    
    func loadTrackingNumber()
    {
        let request : NSFetchRequest<PackageObject> = PackageObject.fetchRequest()
        do
        {
            packages = try context.fetch(request)
        } catch
        {
            print("Error loading categories \(error)")
        }
        
    }
}

extension UPSREQUEST
{
    
    func postBarcodeNotification(code: String)
    {
        var info = [String: String]()
        info[code.description] = code.description
        NotificationCenter.default.post(name: Notification.Name(rawValue: StringLiteral.notificationKey), object: nil, userInfo: info)

    }
}

