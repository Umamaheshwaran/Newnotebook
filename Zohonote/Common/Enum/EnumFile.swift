//
//  EnumFile.swift
//  Zohonote
//
//  Created by Rajesh on 26/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation

public enum ServiceResponseStatus : String {
    
    case Success = "Success",
    NoRecordsFound = "NoRecordsFound",
    Unknown = "Unknown",
    failure = "Failure"
}

public enum SelectedActionSheetOption : String {
    
    case Photo = "Photo Library",
    OpenCamera = "Take Photo",
    Other = "Other"
}

enum ShortcutIdentifier: String {
    case First
    case Second
    case Third
    
    // MARK: Initializers
    
    init?(fullType: String) {
        guard let last = fullType.components(separatedBy: ".").last else { return nil }
        
        self.init(rawValue: last)
    }
    
    // MARK: Properties
    
    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    }
}
