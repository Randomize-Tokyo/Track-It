//
//  DataManager.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/18/22.
//
import Foundation
import UIKit


class DataManager
{
    var passedPAckage:PackageObject?
    
    init(package: PackageObject)
    {
        passedPAckage = package
        
    }
        
    
   
    
    
}

//MARK: - Get the most Recent Package Status
extension DataManager
{
    
    
    func getBestImage()->String
    {
        
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            switch getMostRecentActivityValueAsLetter()
            {
            case "D":
                return "checkmark.circle.fill"
            case "I":
                return "airplane"
            case "M":
                return "dollarsign.circle"
            case "MV":
                return "exclamationmark.octagon.fill"
            case "P":
                return "figure.walk"
            case "X":
                return "phone.fill.arrow.up.right"
            case "RS":
                return "Returned to Shipper"
            case "DO":
                return "checkmark.circle.fill"
            case "DD":
                return "checkmark.circle.fill"
            case "W":
                return "Warehousing (Freight Only)"
            case "NA":
                return "building.fill"
            case "O":
                return "car.fill"
            default:
                return "error"
        }
        default:
            return "error"
    }
        
    }
    
    func getDescriptionBackgroundColor()->UIColor
    {
        
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            switch getMostRecentActivityValueAsLetter()
            {
            case "D":
                return .systemGreen
            default:
                return .systemYellow
        }
        default:
            return .systemRed
    }
        
    }
    

   
}

//MARK: - Populates the Table View Data
extension DataManager
{
    func getDescriptionLabelForCell(indexPath: IndexPath) -> String
    {
        
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
            let status = trackingData?.trackResponse.shipment[0].package[0].activity![indexPath.row].status.statusDescription
            return status!
        default:
            return "error"
            
        
        }
    }
    
    func getLocationLabelForCel(indexPath: IndexPath) -> String
    {
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            
            //let location = city! + "," + state! + " " + postalCode! + ""  + country!
            
            let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
            var location = ""
            
            //Get City
            let city = trackingData?.trackResponse.shipment[0].package[0].activity![indexPath.row].location?.address?.city
            if city != ""
            {
                location = location + city! + ", "
            }
            //Get State
            let state = trackingData?.trackResponse.shipment[0].package[0].activity![indexPath.row].location?.address?.stateProvince
            if state != ""
            {
                location = location + state! + ", "
            }

            //Get Countrt
            let country = trackingData?.trackResponse.shipment[0].package[0].activity![indexPath.row].location?.address?.country
            if country != ""
            {
                location = location + country!
            }
            return location
        default:
            return "error"
        }
    }
    
    func getDateForCell(indexPath: IndexPath) -> String
    {
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
            let date = trackingData?.trackResponse.shipment[0].package[0].activity![indexPath.row].date
            let _ = trackingData?.trackResponse.shipment[0].package[0].activity![indexPath.row].time
            
            let dateToString = date!
    
            return   getMonthFromDate(value:  dateToString) +  " " + getdDayFromDate(value: dateToString) + ", " + getYeaFromDate(value: dateToString)
        default:
            return "error"
        }
    }
    
    func getTimeForCell(indexPath: IndexPath)->String
    {
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
            let time = trackingData?.trackResponse.shipment[0].package[0].activity![indexPath.row].time
            
            let timeToString = time!
    
            return getHours(value: timeToString) + ":"  + getMinutes(value: timeToString) + " "  + getAmPm(value: timeToString)
        default:
            return "error"
        }
    }
}

//MARK: - Manages the Date and Time
extension DataManager
{
    
    func getMinutesASDoublDigits(value: String)-> String
    {
        switch value
        {
        case "0":
          return "00"
        case "1":
          return "01"
        case "2":
          return "02"
        case "3":
          return "03"
        case "4":
          return "04"
        case "5":
          return "05"
        case "6":
          return "06"
        case "7":
          return "07"
        case "8":
          return "08"
        case "9":
          return "09"
        default:
           return value
            
        }
            
      
    }
    
    func getAmPMLAstUpdated(value: Int)->String
    {
        switch value
        {
        case 00:
            return "AM"
        case 01:
          return "AM"
        case 02:
          return "AM"
        case 03:
          return "AM"
        case 04:
          return "AM"
        case 05:
          return "AM"
        case 06:
          return "AM"
        case 07:
          return "AM"
        case 8:
          return "AM"
        case 9:
          return "AM"
        case 10:
          return "AM"
        case 11:
          return "AM"
        case 12:
          return "PM"
        case 13:
          return "PM"
        case 14:
          return "PM"
        case 15:
          return "PM"
        case 16:
          return "PM"
        case 17:
          return "PM"
        case 18:
          return "PM"
        case 19:
          return "PM"
        case 20:
          return "PM"
        case 21:
          return "PM"
        case 22:
          return "PM"
        case 23:
          return "PM"
        case 24:
          return "PM"
        default:
           return "Error "
        }
    }
    
    func getHours(value: String)->String
    {
        var hours = value
        hours.removeLast()
        hours.removeLast()
        hours.removeLast()
        hours.removeLast()
        
        var hoursAsNumber = Int(hours)!
        
       return convertMinitaryTimeToStandard(value: hoursAsNumber)
    }
    
    func convertMinitaryTimeToStandard(value: Int)->String
    {
        switch value
        {
        case 00:
            return "12"
        case 01:
          return "1"
        case 02:
          return "2"
        case 03:
          return "3"
        case 04:
          return "4"
        case 05:
          return "5"
        case 06:
          return "6"
        case 07:
          return "7"
        case 8:
          return "8"
        case 9:
          return "9"
        case 10:
          return "10"
        case 11:
          return "11"
        case 12:
          return "12"
        case 13:
          return "1"
        case 14:
          return "2"
        case 15:
          return "3"
        case 16:
          return "4"
        case 17:
          return "5"
        case 18:
          return "6"
        case 19:
          return "7"
        case 20:
          return "8"
        case 21:
          return "9"
        case 22:
          return "10"
        case 23:
          return "11"
        case 24:
          return "12"
            
            
        default:
           return " "
        }
    }
    
    func getMinutes(value: String)->String
    {
        
        var minutes = value
        minutes.removeFirst()
        minutes.removeFirst()
        minutes.removeLast()
        minutes.removeLast()
    
    
        return minutes
    }

    func getAmPm(value: String)->String
    {
        
            var hours = value
            hours.removeLast()
            hours.removeLast()
            hours.removeLast()
            hours.removeLast()
            
            var hoursAsNumber = Int(hours)!
            
        switch hoursAsNumber
        {
        case 00:
            return "AM"
        case 01:
          return "AM"
        case 02:
          return "AM"
        case 03:
          return "AM"
        case 04:
          return "AM"
        case 05:
          return "AM"
        case 06:
          return "AM"
        case 07:
          return "AM"
        case 8:
          return "AM"
        case 9:
          return "AM"
        case 10:
          return "AM"
        case 11:
          return "AM"
        case 12:
          return "PM"
        case 13:
          return "PM"
        case 14:
          return "PM"
        case 15:
          return "PM"
        case 16:
          return "PM"
        case 17:
          return "PM"
        case 18:
          return "PM"
        case 19:
          return "PM"
        case 20:
          return "PM"
        case 21:
          return "PM"
        case 22:
          return "PM"
        case 23:
          return "PM"
        case 24:
          return "PM"
            
            
        default:
           return "Error"
        }

    }

    func convertMonthToSting(value: Int)->String
    {
        switch value
        {
        case 1:
          return "January"
        case 2:
          return "February"
        case 3:
          return "March"
        case 4:
          return "April"
        case 5:
          return "May"
        case 6:
          return "June"
        case 7:
          return "July"
        case 8:
          return "August"
        case 9:
          return "September"
        case 10:
          return "October"
        case 11:
          return "November"
        case 12:
          return "December"
            
            
        default:
           return "error"
        }
    }
    
    func getdDayFromDate(value: String)->String
    {
        var day = value
       day.removeFirst()
        day.removeFirst()
        day.removeFirst()
        day.removeFirst()
        day.removeFirst()
        day.removeFirst()

      return day
    }
    
    func getYeaFromDate(value: String)->String
    {
        var year = value
        year.removeLast()
        year.removeLast()
        year.removeLast()
        year.removeLast()

      return year
    }
    
    func getMonthFromDate(value: String)->String
    {
        var month = value
        month.removeFirst()
        month.removeFirst()
        month.removeFirst()
        month.removeFirst()
        month.removeLast()
        month.removeLast()
        
        var monthasNumber = Int(month)!
        
        switch monthasNumber
        {
        case 1:
          return "January"
        case 2:
          return "February"
        case 3:
          return "March"
        case 4:
          return "April"
        case 5:
          return "May"
        case 6:
          return "June"
        case 7:
          return "July"
        case 8:
          return "August"
        case 9:
          return "September"
        case 10:
          return "October"
        case 11:
          return "November"
        case 12:
          return "December"
            
            
        default:
           return "error"
        }
        
        
    }
    
}

//MARK: - Functions assisting to inform user of the most current status of a package.
extension DataManager
{
    func isThereAnDeliveryDateAvailabe()->String
    {
        if passedPAckage?.isValidTrackingNumber == false
        {
            return "No Data Available"
        }
        
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            
            let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
            let isValid  = (trackingData?.trackResponse.shipment[0].package[0].deliveryDate?[0].date)
            
            if isValid == nil || isValid == ""
                
            {
                return "No Delivery Date Available"
            }
            else
            {
                return  "Expected Delivery by: " + getMonthFromDate(value: isValid!) + " " + getdDayFromDate(value: isValid!) + ", " + getYeaFromDate(value: isValid!)
        }
          
        
            
        default:
            return "Contact Carrier for more Details "
            
        
        }
        
    }
    
    
    
    
 func getDeleveryDate()->String
    {
        if passedPAckage?.delivered == true
        {
            return (passedPAckage?.deliveredDate)!
        }
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
            let estimatedDeliveryDate = trackingData?.trackResponse.shipment[0].package[0].deliveryDate![0].date
            print("Estimated Date \(estimatedDeliveryDate)")
           return "Estimated Date \(estimatedDeliveryDate)"
            
        default:
            return "error"
            
        
        }
        
        
    }
    
    
        
    
    
   

   
}

//MARK: - Retrives the Most Recnt of an Item
extension DataManager
{
    //MARK: - Helper Functions
    func getMostRecentActivityValueAsLetter() -> String
    {
        
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
            let statusType = trackingData?.trackResponse.shipment[0].package[0].activity![0].status.type
            return statusType!
        default:
            return "error"
            
        
    }
        
       
    }
    
    //MARK: - Used Initially to Set Pacakge Data Object
    func getMostRecentActivityDescription()->String
    {
        let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
        let recentStatus = trackingData?.trackResponse.shipment[0].package[0].activity![0].status.statusDescription

        return recentStatus!
    }
    
    func getMostRecentColorIndicatorStatus()->String
    {


        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            switch getMostRecentActivityValueAsLetter()
            {
            case "D":
                return StringLiteral.greenColor
            case "I":
                return StringLiteral.yellowColor
            case "M":
                return StringLiteral.yellowColor
            case "MV":
                return StringLiteral.yellowColor
            case "P":
                return StringLiteral.yellowColor
            case "X":
                return StringLiteral.yellowColor
            case "RS":
                return StringLiteral.yellowColor
            case "DO":
                return StringLiteral.yellowColor
            case "DD":
                return StringLiteral.yellowColor
            case "W":
                return StringLiteral.yellowColor
            case "NA":
                return StringLiteral.yellowColor
            case "O":
                return StringLiteral.yellowColor
            default:
                return StringLiteral.redColor
        }
        default:
            return "error"
    }
        
    }
    
    func getWhenThePackageWasLastUpdated()->String
    {
        
                if passedPAckage?.isValidTrackingNumber == false
                {
                    return "No Data. Check Back later or Contact Carrier"
                }
                else
                {
        
                    let date = Date()
                    let calendar = Calendar.current
        
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date).description
                   // let seconds = calendar.component(.second, from: date).description
        
                    let month = calendar.component(.month, from: date)
                    let day = calendar.component(.day, from: date).description
                    let year = calendar.component(.year, from: date).description
        
                    return "Last updated: " + convertMonthToSting(value: month) +  " " +  day +  ", " + year + " at " + convertMinitaryTimeToStandard(value: hour) + ":" +  getMinutesASDoublDigits(value: minutes) + " " + getAmPMLAstUpdated(value: hour)
        
                }
    }
    
    func getIfPackageHasbeenDelivered()->Bool
    {
        
        if passedPAckage?.delivered ==  true
        {
            return true
        }
        
        //Dont Change status if pakage has already been delivered
        if passedPAckage?.delivered != true
        {
            switch passedPAckage?.packageCarrier?.lowercased()
            {
            case "ups":
                switch getMostRecentActivityValueAsLetter()
                {
                case "D":
                    return true
                default:
                    return false
            }
            default:
                return false
        }
            
        }
        
       
        return false
        
    }
    
   
    
    
    
    //MARK: - Not Used
    func getMostRecentStatusTypeDescriptionReadableText()->String
    {
    
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            
            
            switch getMostRecentActivityValueAsLetter()
            {
                
            case "D":
                return "Delivered"
            case "I":
                return "In Transit"
            case "M":
                return "Billing Information Received"
            case "MV":
                return "Billing Information Voided"
            case "P":
                return "Pickup"
            case "X":
                return "Exception"
            case "RS":
                return "Returned to Shipper"
            case "DO":
                return "Delivered Origin CFS (Freight Only)"
            case "DD":
                return "Delivered Destination CFS (Freight Only)"
            case "W":
                return "Warehousing (Freight Only)"
            case "NA":
                return "Not Available"
            case "O":
                return "Out for Delivery"
            default:
                return "error"
                
            
        }
        default:
            return "error"
            
        
    }
    
    }
    
    func getMostRecentLocation()->String
    {
        switch passedPAckage?.packageCarrier?.lowercased()
        {
        case "ups":
            
            //let location = city! + "," + state! + " " + postalCode! + ""  + country!
            
            let trackingData = try? JSONDecoder().decode(UPSJSONDATA.self, from: (passedPAckage?.testData)!)
            var location = ""
            
            //Get City
            let city = trackingData?.trackResponse.shipment[0].package[0].activity![0].location?.address?.city
            if city != ""
            {
                location = location + city! + ", "
            }
            //Get State
            let state = trackingData?.trackResponse.shipment[0].package[0].activity![0].location?.address?.stateProvince
            if state != ""
            {
                location = location + state! + ", "
            }

            //Get Countrt
            let country = trackingData?.trackResponse.shipment[0].package[0].activity![0].location?.address?.country
            if country != ""
            {
                location = location + country!
            }
            return location
        default:
            return "US"
    }
    }
  
   
    

}
