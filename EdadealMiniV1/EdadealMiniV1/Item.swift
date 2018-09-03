//
//  Item.swift
//  EdadealMiniV1
//
//  Created by Alexey Danilov on 02/09/2018.
//  Copyright © 2018 Alexey Danilov. All rights reserved.
//

import Foundation

struct Item {
    
    var description: String?
    
    var price: Double?
    
    var priceStr: String? {
        if let price = price {
            return String(price)
        }
        return nil
    }
    
    var discountStr: String? {
        if let discount = discount {
            return String(discount)
        }
        return nil
    }
    
    var discount: Int?
    
    var image: String?
    
    var retailer: String?
    
    init(dictionary: Dictionary<String, Any>) {
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        if let discount = dictionary["discount"] as? Int {
            self.discount = discount
        }
        if let image = dictionary["image"] as? String {
            self.image = image
        }
        if let price = dictionary["price"] as? Double {
            self.price = price
        }
        if let retailer = dictionary["retailer"] as? String {
            self.retailer = retailer
        }
    }
}
