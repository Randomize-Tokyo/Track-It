//
//  PackageTableViewCell.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/15/22.
//

import UIKit

class PackageTableViewCell: UITableViewCell
{
    static let classIdentifier = String(describing: PackageTableViewCell.self)
    static let cellIdentifier = String(describing: PackageTableViewCell.self)

    @IBOutlet weak var circleIndicator: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var packageDescription: UILabel!
    @IBOutlet weak var carrierNameAndTracking: UILabel!
    @IBOutlet weak var packageCurrentDescription: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //Autp Adjust All fonts for diffrent screen sizes
        packageDescription.adjustsFontSizeToFitWidth = true
        carrierNameAndTracking.adjustsFontSizeToFitWidth = true
        packageCurrentDescription.adjustsFontSizeToFitWidth = true
    }

    
}



