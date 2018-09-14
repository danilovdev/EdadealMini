//
//  PurchaseItemCell.swift
//  EdadealMiniV1
//
//  Created by Alexey Danilov on 02/09/2018.
//  Copyright © 2018 Alexey Danilov. All rights reserved.
//

import Foundation
import UIKit

enum PurchaseItemCellMode {
    
    case purchase
    
    case remove
    
    func getIconName() -> String {
        switch self {
        case .purchase:
            return "add_to_cart"
        case .remove:
            return "trash"
        }
    }
}

class PurchaseItemCell: UITableViewCell {
    
    var delegate: PurchaseItemCellDelegate?
    
    var item: Item?
    
    private var mode: PurchaseItemCellMode?
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var retailerLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var purchaseImageView: UIImageView! {
        didSet {
            purchaseImageView.clipsToBounds = true
            purchaseImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var actionButton: UIButton! {
        didSet {
            actionButton.backgroundColor = .lightGray
            actionButton.layer.cornerRadius = actionButton.frame.width / 2.0
            actionButton.clipsToBounds = true
            actionButton.tintColor = .darkGray
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        guard let mode = mode else { return }
        switch mode {
        case .purchase:
            GlobalValues.selectedItems.append(item!)
        case .remove:
            if let index = GlobalValues.selectedItems.index(where: { item -> Bool in
                return item == self.item
            }) {
                GlobalValues.selectedItems.remove(at: index)
                delegate?.didRemoveItem(for: self)
            }
        }
    }
    
    func configure(item: Item, mode: PurchaseItemCellMode, ranges: [Range<String.Index>]? = nil) {
        
        self.item = item
        self.mode = mode
        
        if let urlStr = item.image, let url = URL(string: urlStr) {
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.purchaseImageView.image = image
                    }
                }
            }
            task.resume()
            
            
        }
        
        
        
        
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
        
        descriptionLabel.attributedText = attributedText
        
    }
    
}
