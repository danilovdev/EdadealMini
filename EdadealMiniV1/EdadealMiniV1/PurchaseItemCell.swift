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
    
    func configure(item: Item, ranges: [Range<String.Index>]? = nil) {
        
        textLabel?.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(
            attributedString: NSAttributedString(string: item.description!,
                                                 attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)]))
        
        if let ranges = ranges {
            for range in ranges {
                attributedText.addAttributes([
                    NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),
                    NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue],
                                             range: NSRange(range, in: attributedText.string))
            }
        }
        
        textLabel?.attributedText = attributedText
        
    }
    
}
