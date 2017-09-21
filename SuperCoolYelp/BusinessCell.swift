//
//  BusinessCell.swift
//  SuperCoolYelp
//
//  Created by Eden on 9/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceAwayLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
    var resultNumber: Int!
    var business: Business! {
        didSet {
            addressLabel.text = business.address
            if let url = business.imageURL {
                businessImageView.setImageWith(url)
            } else {
                businessImageView.image = nil
            }
            businessNameLabel.text = "\(resultNumber!). \(business.name!)"
            distanceAwayLabel.text = business.distance
            if let count = business.reviewCount {
                numberOfReviewsLabel.text = "\(count) Reviews"
            }
            if let ratingImageUrl = business.ratingImageURL {
                ratingImageView.setImageWith(ratingImageUrl)
            } else {
                ratingImageView.image = nil
            }
            categoriesLabel.text = business.categories
//            priceLabel.text = business.

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        businessImageView.layer.cornerRadius = 3
        businessImageView.clipsToBounds = true
        businessNameLabel.preferredMaxLayoutWidth = businessNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        businessNameLabel.preferredMaxLayoutWidth = businessNameLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
