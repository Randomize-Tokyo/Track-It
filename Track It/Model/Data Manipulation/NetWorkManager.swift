//
//  NetWorkManager.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/18/22.
//

import Foundation
import UIKit

class NetWorkManager
{
    
    
    init (packageDetail: PackageObject)
    {
        //Performing Network Call Depending on the Carrier Selected and the Tracking Number Provided.
        switch packageDetail.packageCarrier?.lowercased()
        {
        case "ups":
           UPSREQUEST(package: packageDetail) //Quiery the UPS API Against the tracking Number
            
            
        default:
            print("Something Happened")
        }
        
    }
}


