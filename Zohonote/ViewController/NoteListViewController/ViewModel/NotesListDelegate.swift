//
//  NotesListDelegate.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation

public protocol NotesListDelegate{
    
    func didBeginNotesListLoadingContent()
    func didEndNotesListLoadingContent(_ status:ServiceResponseStatus)
}
