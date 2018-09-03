//
//  PurchaseItemCell.swift
//  EdadealMiniV1
//
//  Created by Alexey Danilov on 02/09/2018.
//  Copyright © 2018 Alexey Danilov. All rights reserved.
//

import Foundation
import UIKit

class PurchaseItemCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var retailerLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var purchaseImageView: UIImageView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
    }
    
    func configure(item: Item) {
        
        descriptionLabel.text = item.description
        retailerLabel.text = item.retailer
        priceLabel.text = item.priceStr
        discountLabel.text = item.discountStr
    }
    
}
