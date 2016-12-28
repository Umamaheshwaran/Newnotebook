//
//  ExtensionFile.swift
//  Zohonote
//
//  Created by Rajesh on 26/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation
import UIKit
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " dd/MM/yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
}
extension NSAttributedString
{
    func getImage(_ attributeStr:NSAttributedString) -> (UIImage,Bool) {
        
        //Retrive image from nsattribute string
        let range = NSRange(location: 0, length: attributeStr.length)
        if (attributeStr.containsAttachments(in: range)) {
            let attrString = attributeStr
            var location = 0
            while location < range.length {
                var r = NSRange()
                let attrDictionary = attrString.attributes(at: location, effectiveRange: &r)
                
                let attachment = attrDictionary[NSAttachmentAttributeName] as? NSTextAttachment
                if attachment != nil {
                    if attachment!.image != nil {
                        // your code to use attachment!.image as appropriate
                        return ((attachment?.image)!,true)
                        
                    }
                }
                location += r.length
            }
        }
        return (UIImage(),false)
    }
}

