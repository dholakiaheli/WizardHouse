//
//  WizardTableViewCell.swift
//  WizardHouse
//
//  Created by Heli Bavishi on 11/12/20.
//

import UIKit

protocol WizardCellDelegate: AnyObject {
    func houseButtonTapped(_ sender: WizardTableViewCell)
}

class WizardTableViewCell: UITableViewCell {

    @IBOutlet weak var wizardNameLabel: UILabel!
    @IBOutlet weak var wizardImageView: UIImageView!
    
    var wizard: Wizard? {
        didSet {
            //do something
            updateViews()
        }
    }
    
    weak var delegate: WizardCellDelegate?
    
    @IBAction func wizardCrestButtonTapped(_ sender: Any) {
        //tell viewcontroller that button was tapped...
        delegate?.houseButtonTapped(self)
    }
    
    func updateViews() {
        guard let wizard = wizard else { return }
        wizardNameLabel.text = wizard.name
        updateCrest(for: wizard)
    }
    
    func updateCrest(for wizard:Wizard) {
        if wizard.isVisible {
            if let house = wizard.house {
                wizardImageView.image = UIImage(named: "\(house.lowercased())")
            }
        } else {
            wizardImageView.image = UIImage(named: "hogwarts")
        }
    }
}
