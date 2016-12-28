//
//  NotebooksDashboardVM.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation

class NotebooksDashboardVM {
    
    var delegate:NotebooksdashboardDelegate?
    
    lazy var dataService: NewNoteBookdataService = {
        
        return NewNoteBookdataService()
    }()
    var notebooksList = [NotebooksDashboardModel]();
    lazy var queue: OperationQueue = { OperationQueue() }();

    func getNoteBooks()

    {
        
        delegate?.didBeginLoadingContent()
        queue.addOperation {
            
            self.dataService.getNoteBooks({ (status, list) in
                
                self.notebooksList = [NotebooksDashboardModel]()

                if let nonNilList = list
                {
                self.notebooksList = nonNilList
                }
                OperationQueue.main.addOperation({
                    
                    self.delegate?.didEndLoadingContent(status)

                })
            })

            
        }
    }
    func getSuggestions(forKeyword keyword: String?) {
 queue.addOperation {
    
    self.dataService.getSuggestions(forKeyword: keyword, { (status, list) in
        
            OperationQueue.main.addOperation({
                [weak self] in
                
                    self?.notebooksList.removeAll();
                if let item = list {
                    self?.notebooksList = item;
                }
                self?.delegate?.serviceListDidEndLoading(forKeyword: keyword, withStatus: status);

            })
     
    })
        }
        
        }
    func deleteNoteBooks(forNotebooksId notebooksId:Int?)
        
    {
        
        delegate?.didBeginLoadingContent()
        queue.addOperation {
            
           self.dataService.deleteNotebooks(forNotebooksIs: notebooksId, callBack: { (status,list) in
            self.notebooksList = [NotebooksDashboardModel]()

            if let nonNilList = list {
                self.notebooksList = nonNilList
                
            }else {
                self.notebooksList = [NotebooksDashboardModel]()
                
            }
            OperationQueue.main.addOperation({
                    
                    self.delegate?.didEndLoadingContent(status)
                    
                })
            })
            
            
        }
    }
     func getNotBooksCount() -> Int {
        guard self.notebooksList.count > 0 else { return 0 }
        return self.notebooksList.count;
    }
     func getNoteBook(atIndex index: Int) -> NotebooksDashboardModel? {
        
        
        return self.notebooksList[index];
        
    }
    func getNoteBookId() -> Int? {
        
        guard getNotBooksCount() > 0 else { return -1 }

        return self.notebooksList[getNotBooksCount()-1].notebooks_Id;
        
    }
}
