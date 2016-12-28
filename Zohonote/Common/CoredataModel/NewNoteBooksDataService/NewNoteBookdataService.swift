//
//  NewNoteBookdataService.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation
import CoreData
import UIKit
public class NewNoteBookdataService
{
    
    var entityName = {
        return "NotebooksList"
    }
   lazy var appdelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func addNewNotes(_ newNoteModel: NewNotebooksModel, callBack: @escaping (ServiceResponseStatus) -> Void) {
        
            let context = self.appdelegate().persistentContainer.viewContext
            let add = NSEntityDescription.insertNewObject(forEntityName: self.entityName(), into: context)
            
            add.setValue(newNoteModel.notesBookName, forKey: "notebooks_title")
            add.setValue(newNoteModel.notebookId, forKey: "notebooks_Id")
            add.setValue(newNoteModel.date, forKey: "created_date")
            add.setValue(newNoteModel.date, forKey: "updated_date")
        
            var responseStatus = ServiceResponseStatus.Unknown;

            do {
                try context.save()
                responseStatus = .Success

            } catch  {
                responseStatus = .failure
            }
            callBack(responseStatus)
        
    }
    
    func getNoteBooks(_ callBack: @escaping (_ status:ServiceResponseStatus,_ list : [NotebooksDashboardModel]?) -> Void)
    {
        
                let context = appdelegate().persistentContainer.viewContext

                let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
                request.returnsObjectsAsFaults = false
        
        var serviceStatus = ServiceResponseStatus.Unknown;

                var modelArray:[NotebooksDashboardModel]?

                do {
                   let result = try context.fetch(request)
                    serviceStatus = .NoRecordsFound

                    if result.count > 0 {
                        serviceStatus = .Success
                        modelArray = [NotebooksDashboardModel]()

                        for results in result as! [NSManagedObject]
                            {
                                
                                let model = NotebooksDashboardModel()
                                model.deserialize(fromManagedObject: results)
                                modelArray?.append(model)
                            }
                    }

                } catch  {
                    serviceStatus = .failure

                }
        callBack(serviceStatus, modelArray)

    }
    func getSuggestions(forKeyword keywordStr:String?,_ callBack: @escaping (_ status:ServiceResponseStatus,_ list : [NotebooksDashboardModel]?) -> Void)
    {
        
        let context = appdelegate().persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        let resultPredicate = NSPredicate(format: "notebooks_title CONTAINS[c] %@", keywordStr!)
        
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        
        var serviceStatus = ServiceResponseStatus.Unknown;
        
        var modelArray:[NotebooksDashboardModel]?
        
        do {
            let result = try context.fetch(request)
            serviceStatus = .NoRecordsFound
            
            if result.count > 0 {
                serviceStatus = .Success
                modelArray = [NotebooksDashboardModel]()
                
                for results in result as! [NSManagedObject]
                {
                    
                    let model = NotebooksDashboardModel()
                    model.deserialize(fromManagedObject: results)
                    modelArray?.append(model)
                }
            }
            
        } catch  {
            serviceStatus = .failure
            
        }
        callBack(serviceStatus, modelArray)
        
    }
    func deleteNotebooks(forNotebooksIs notebookId:Int?,callBack: @escaping (ServiceResponseStatus,_ list : [NotebooksDashboardModel]?) -> Void)
    {
        let context = appdelegate().persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        let resultPredicate = NSPredicate(format: "notebooks_Id = %d ", notebookId!)
        
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
                deleteNote(forNoteBooksId: notebookId!)

                self.getNoteBooks({ (status, list) in
                    callBack(serviceStatus,list)

                })
            }
            
        } catch  {
            serviceStatus = .failure
            callBack(serviceStatus,[NotebooksDashboardModel]())

            
        }
    }
    
    //Delete all notes 
    func deleteNote(forNoteBooksId notebookId:Int)
    {
        let context = appdelegate().persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Notes")
        let resultPredicate = NSPredicate(format: "notebooks_Id = %d", notebookId)
        
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                for results in result as! [NSManagedObject]
                {
                    context.delete(results)
                    appdelegate().saveContext()
                    
                }
               
            }
            
        } catch  {
            
            
        }
    }

}
