//
//  NotebooksDashboardVM.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation
import CoreData
public class NotebooksDashboardModel  {
    
    var notebooks_Id:Int?
    var notebooks_title: String?
     func deserialize(fromManagedObject managedObject: NSManagedObject) {
        
        self.notebooks_Id = managedObject.value(forKey: "notebooks_Id") as? Int
        
        self.notebooks_title = managedObject.value(forKey: "notebooks_title") as? String

    }
    
    
}
