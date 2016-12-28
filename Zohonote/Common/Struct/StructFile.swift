//
//  StructFile.swift
//  Zohonote
//
//  Created by Uma Maheshwaran on 27/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation

public struct selectedShortCutItemConfig {

public enum selectedItemIntex : Int {
    case notebooksList = 0, search = 1, newNote = 2
    
    static var defaultPage: selectedShortCutItemConfig.selectedItemIntex {
        get {
            return selectedItemIntex.notebooksList;
        }
    }
}

fileprivate init() { }

public static var requiresReload: Bool? = nil;

public static var selectedPage: selectedItemIntex = selectedShortCutItemConfig.selectedItemIntex.notebooksList {
didSet {
    selectedShortCutItemConfig.requiresReload = true;
}
}
}
