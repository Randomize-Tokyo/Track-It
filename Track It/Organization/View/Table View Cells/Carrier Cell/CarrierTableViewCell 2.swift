//
//  CarrierTableViewCell.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/17/22.
//

import UIKit

class CarrierTableViewCell: UITableViewCell
{
    static let classIdentifier = String(describing: CarrierTableViewCell.self)
    static let cellIdentifier = String(describing: CarrierTableViewCell.self)

    @IBOutlet weak var carrierName: UILabel!
    @IBOutlet weak var carrierImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //Autp Adjust All fonts for diffrent screen sizes
        carrierName.adjustsFontSizeToFitWidth = true
    }

    
}
