//
//  FiltersCell.swift
//  SuperCoolYelp
//
//  Created by Eden on 9/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersCellDelegate: class {
    func filtersCellDidToggle(cell: FiltersCell, newValue: Bool)
}

class FiltersCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!

    @IBOutlet weak var selectionImageView: UIImageView!
    
    weak var delegate: FiltersCellDelegate?

    var filter: Filter! {
        didSet {
            if filter.parentGroup == 0 || filter.parentGroup == 1 || filter.parentGroup == 4 {
                descriptionLabel?.text = filter.name
                onOffSwitch.isHidden = false
                onOffSwitch.isOn = filter.value
                selectionImageView.isHidden = true
            } else {
                selectionImageView.isHidden = false
                onOffSwitch.isHidden = true
                if filter.expanded {
                    descriptionLabel?.text = filter.name
                    if filter.value {
                        self.selectionImageView.image = UIImage(named: "checked")
                    } else {
                        self.selectionImageView.image = UIImage(named: "unchecked")
                    }
                } else {
                    self.selectionImageView.image = UIImage(named: "dropdown")
                    descriptionLabel?.text = filter.name
                }

            }
            
        }
    }
    

    @IBAction func didToggleSwitch(sender: AnyObject) {
        delegate?.filtersCellDidToggle(cell: self, newValue: onOffSwitch.isOn)
    }

}


