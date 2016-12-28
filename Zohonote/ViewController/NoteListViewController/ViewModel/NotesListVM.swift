//
//  NotesListVM.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation

class NotesListVM {
    
    var delegate:NotesListDelegate?
    
    lazy var dataService: NotesDataService = {
        
        return NotesDataService()
    }()
    var notebooksList = [NoteListModel]();
    
    func getNotes(forNoteBookId noteBookId:Int?)
        
    {
        
        delegate?.didBeginNotesListLoadingContent()
        OperationQueue().addOperation {
            
            self.dataService.getNotesList(forNoteBookId: noteBookId, callBack: { (status, list) in
                if let nonNilList = list {
                    self.notebooksList = nonNilList

                }else {
                    self.notebooksList = [NoteListModel]()
                    
                }
                
                
                OperationQueue.main.addOperation({
                    
                    self.delegate?.didEndNotesListLoadingContent(status)
                    
                })
            })

            
            
        }
    }
    func deleteNoteBooks(forNoteId NoteId:Int?, notebooksId:Int?)
        
    {
        
        OperationQueue().addOperation {
            
            
            
            self.dataService.deleteNote(forNoteId: NoteId, notebookId: notebooksId!, callBack: { (status, list) in
                self.notebooksList = [NoteListModel]()
                
                if let nonNilList = list {
                    self.notebooksList = nonNilList
                    
                }else {
                    self.notebooksList = [NoteListModel]()
                    
                }
                OperationQueue.main.addOperation({
                    
                    self.delegate?.didEndNotesListLoadingContent(status)
                    
                })
            })

        }
    }
    func getNotesCount() -> Int {
        guard self.notebooksList.count > 0 else { return 0 }
        return self.notebooksList.count;
    }
    func getNotes(atIndex index: Int) -> NoteListModel? {
        
        
        return self.notebooksList[index];
        
    }
    func getNotesId() -> Int? {
        
        guard getNotesCount() > 0 else { return 1 }
        
        return self.notebooksList[getNotesCount()-1].notes_id;
        
    }
}
