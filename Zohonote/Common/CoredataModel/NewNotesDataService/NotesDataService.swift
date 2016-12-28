//
//  NotesDataService.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation
import CoreData
import UIKit
public class NotesDataService
{
    
    var entityName = {
        return "Notes"
    }
    lazy var appdelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func addNewNotes(_ newNoteModel: NewNoteModel, callBack: @escaping (ServiceResponseStatus) -> Void) {
        
            let context = self.appdelegate().persistentContainer.viewContext
            let notes = Notes(context: context)
            
            notes.created_date = newNoteModel.date as NSDate?
            notes.updated_date = newNoteModel.date as NSDate?
            notes.latitude = Utility.unwrap(newNoteModel.latitude, 0)
            notes.longitude = Utility.unwrap(newNoteModel.longitude, 0)
            notes.notebooks_Id = newNoteModel.notebooks_Id!
            notes.notes_id = newNoteModel.notes_id!
            notes.notes_attribute = newNoteModel.notes_attribute
            notes.notes_name = newNoteModel.notes_name

        
            var responseStatus = ServiceResponseStatus.Unknown;
            
            do {
                try context.save()
                responseStatus = .Success
                
            } catch  {
                responseStatus = .failure
            }
            callBack(responseStatus)
            
            
            

}
    func getNotesList(forNoteBookId notebookId:Int?, callBack: @escaping (_ status:ServiceResponseStatus,_ list : [NoteListModel]?) -> Void)
    {
        
        let context = appdelegate().persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        
        let resultPredicate = NSPredicate(format: "notebooks_Id = %d", notebookId!)

        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        
        var serviceStatus = ServiceResponseStatus.Unknown;
        
        var modelArray:[NoteListModel]?
        
        do {
            let result = try context.fetch(request)
            serviceStatus = .NoRecordsFound
            
            if result.count > 0 {
                serviceStatus = .Success
                modelArray = [NoteListModel]()
                
                for results in result as! [NSManagedObject]
                {
                    let model = NoteListModel()
                    model.deserialize(fromManagedObject: results)
                    modelArray?.append(model)
                }
            }
            
        } catch  {
            serviceStatus = .failure
            
        }
        callBack(serviceStatus, modelArray)
        
    }
   
    func updateNoteDetails(forNotesId NotesId:Int, _ notebookId:Int?,_ newNoteModel: NewNoteModel, callBack: @escaping (ServiceResponseStatus) -> Void) {
        
        let context = appdelegate().persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        
        let resultPredicate = NSPredicate(format: "notebooks_Id = %d AND notes_id = %d", notebookId!,NotesId)
        
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        
        var responseStatus = ServiceResponseStatus.Unknown;
        
        
        do {
            let result = try context.fetch(request) as? [Notes]
            responseStatus = .Success
            if result?.count != 0 {
                 if let setting = result {
                let notes = setting[0]
                notes.latitude = newNoteModel.latitude!
                notes.longitude = newNoteModel.longitude!
         
                notes.notes_attribute = newNoteModel.notes_attribute
                notes.notes_name = newNoteModel.notes_name
                notes.updated_date = newNoteModel.date as NSDate?

                    do {
                        try context.save()
                        responseStatus = .Success
                        
                    } catch  {
                        responseStatus = .failure
                    }
                    callBack(responseStatus)
                }

            }
            
            
        } catch  {
            responseStatus = .failure
            
        }
        callBack(responseStatus)
        
    }
    
    func deleteNote(forNoteId noteId:Int?,notebookId:Int,callBack: @escaping (ServiceResponseStatus,_ list : [NoteListModel]?) -> Void)
    {
        let context = appdelegate().persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        let resultPredicate = NSPredicate(format: "notebooks_Id = %d AND notes_id = %d", notebookId,noteId!)
        
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        
        var serviceStatus = ServiceResponseStatus.Unknown;
        
        
        do {
            let result = try context.fetch(request)
            
            if result.count > 0 {
                serviceStatus = .Success
                
                for results in result as! [NSManagedObject]
                {
                    context.delete(results)
                    appdelegate().saveContext()
                    
                }
                self.getNotesList(forNoteBookId: notebookId, callBack: { (status, list) in
                    callBack(serviceStatus,list)

                })
            }
            
        } catch  {
            serviceStatus = .failure
            callBack(serviceStatus,[NoteListModel]())
            
            
        }
    }
}
