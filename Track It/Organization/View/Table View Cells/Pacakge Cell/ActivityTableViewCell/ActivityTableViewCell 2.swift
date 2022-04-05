//
//  ActivityTableViewCell.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/18/22.
//
import UIKit

class ActivityTableViewCell: UITableViewCell
{
    static let classIdentifier = String(describing: ActivityTableViewCell.self)
    static let cellIdentifier = String(describing: ActivityTableViewCell.self)
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
   
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        descriptionLabel.adjustsFontSizeToFitWidth = true
       descriptionLabel.minimumScaleFactor = 1
    }
    
    
}
