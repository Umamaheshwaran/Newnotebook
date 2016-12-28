//
//  NewNoteBooksVM.swift
//  Zohonote
//
//  Created by Rajesh on 25/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import Foundation


class NewNoteBooksVM {
    
    var delegate:NewNoteBooksVMDelegate?

    let dataService =  NewNoteBookdataService()
    
    func addNewNotes(_ newNoteModel: NewNotebooksModel, callBack: @escaping (ServiceResponseStatus) -> Void) {
        OperationQueue.main.addOperation({
            self.delegate?.didBeginLoadingContent()
            if self.validate(newNoteModel.notesBookName) {
            self.dataService.addNewNotes(newNoteModel, callBack: { (status) in
                
                callBack(ServiceResponseStatus.Success)


            })
            }
            self.delegate?.didEndLoadingContent()

        })

    }
    func validate(_ nameStr:String?) -> Bool {
        if Utility.unwrap(nameStr, "").characters.count == 0 {
            self.delegate?.invalidNotebookName();
            return false;
        }
        return true
    }
}
