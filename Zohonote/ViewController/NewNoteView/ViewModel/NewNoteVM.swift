//
//  NewNoteVM.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation

class NewNoteVM {
    
    
    let dataService =  NotesDataService()
    
    func addNewNotes(_ newNoteModel: NewNoteModel, callBack: @escaping (ServiceResponseStatus) -> Void) {
        
        OperationQueue().addOperation {

            self.dataService.addNewNotes(newNoteModel, callBack: { (status) in
                
                callBack(ServiceResponseStatus.Success)
                
                
            })

        }
    }
    func updateNoteDetails(forNotesId NotesId:Int, _ notebookId:Int?,_ newNoteModel: NewNoteModel, callBack: @escaping (ServiceResponseStatus) -> Void) {

        OperationQueue().addOperation {
            
          
            self.dataService.updateNoteDetails(forNotesId: NotesId, notebookId, newNoteModel, callBack: { (status) in
                
                OperationQueue.main.addOperation {
                    
                    callBack(ServiceResponseStatus.Success)

                }

            })
            
        }
    }
}
