//
//  StringExtensions.swift
//  EdadealMiniV1
//
//  Created by Alexey Danilov on 09/09/2018.
//  Copyright © 2018 Alexey Danilov. All rights reserved.
//

import Foundation

extension String {
    
    func removeExtraSpaces() -> String {
        return replacingOccurrences(of: " +",
                                    with: " ",
                                    options: .regularExpression,
                                    range: nil)
    }
    
    func calculateWeightForSubstring(substring: String) -> (index: Int, isStart: Bool)? {
        let nonAlphanumericChars = CharacterSet.alphanumerics.inverted
        // Get components from string
        let components = lowercased().split(separator: " ")
        let substring = substring.lowercased()
        var index: Int?
        var isStart = false
        for i in 0..<components.count {
            // Remove from string all non alphanumeric symbols
            let component = String(components[i])
                .components(separatedBy: nonAlphanumericChars)
                .joined(separator: "")
            if let rangeOfSubstring = component.range(of: substring) {
                if !isStart {
                    index = i
                }
                if rangeOfSubstring.lowerBound.encodedOffset == 0 {
                    isStart = true
                    break
                }
            }
        }
        if let index = index {
            return (index, isStart)
        }
        return nil
    }
    
    func getAllSubranges(substring: String) -> [Range<String.Index>]? {
        let components = lowercased().split(separator: " ")
        let substring = substring.lowercased()
        var ranges = [Range<String.Index>]()
        for component in components {
            if let rangeOfSubstring = component.range(of: substring) {
                ranges.append(rangeOfSubstring)
            }
        }
        return ranges.count > 0 ? ranges : nil
    }
}
