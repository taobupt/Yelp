//
//  BusinessCell.swift
//  Yelp
//
//  Created by Tao Wang on 1/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var DistanceLabel: UILabel!
    
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text=business.name
            thumbImageView.setImageWith(business.imageURL!)
            categoriesLabel.text=business.categories
            addressLabel.text=business.address
            reviewCountLabel.text="\(business.reviewCount!) Reviews"
            ratingImageView.setImageWith(business.ratingImageURL!)
            DistanceLabel.text=business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius=3
        thumbImageView.clipsToBounds=true
        nameLabel.preferredMaxLayoutWidth=nameLabel.frame.size.width
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth=nameLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
