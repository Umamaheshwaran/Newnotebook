//
//  NewNoteModel.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation
import CoreData

public class NewNoteModel {
    /*notes.created_date = Date() as NSDate?
     notes.updated_date = Date() as NSDate?
     notes.latitude = 12.00
     notes.longitude = 12.00
     notes.notebooks_Id = 1
     notes.notes_id = 1
     notes.notes_attribute = "afaf" as NSObject?*/
    
    
    var notes_attribute:NSAttributedString? = nil
    var date:Date? = nil
    var notebooks_Id:Int16? = nil
    var notes_id:Int16? = nil
    var notes_name : String? = nil
    
    var latitude:Double? = nil

    var longitude:Double? = nil

}

public class NoteListModel  {
    
    var notes_attribute:NSAttributedString?
    var date:Date?
    var notebooks_Id:Int?
    var notes_id:Int?
    var notes_name : String?

    var latitude:Double?
    
    var longitude:Double?
    

    func deserialize(fromManagedObject managedObject: NSManagedObject) {
        //notes.updated_date
        self.notebooks_Id = managedObject.value(forKey: "notebooks_Id") as? Int
        
        self.notes_id = managedObject.value(forKey: "notes_id") as? Int
        
        self.latitude = managedObject.value(forKey: "latitude") as? Double
        
        self.longitude = managedObject.value(forKey: "longitude") as? Double
        
        self.notes_attribute = managedObject.value(forKey: "notes_attribute") as? NSAttributedString

        self.date = managedObject.value(forKey: "updated_date") as? Date

        self.notes_name = managedObject.value(forKey: "notes_name") as? String

    }
    
    
}
