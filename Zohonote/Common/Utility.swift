//
//  Utility.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation


open class Utility {
    
    open static func unwrap<T>(_ value: T?,_ defaultValue: T) -> T {
        guard let nonNilValue = value else {
            return defaultValue;
        }
        return nonNilValue;
}
}
