//
//  NewNotebookViewController.swift
//  Zohonote
//
//  Created by Rajesh on 23/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import UIKit
import CoreData

class NewNotebookViewController: UIBaseViewController,UITextFieldDelegate, NewNoteBooksVMDelegate {
    @IBOutlet weak var nameTxtfld : UITextField?
    
    lazy var viewModel : NewNoteBooksVM =
        {
            return NewNoteBooksVM()
    }()
    
    lazy var model : NewNotebooksModel =
        {
            return NewNotebooksModel()
    }()
    
    var noteBookId : Int? = 1
    
    private var addedSuccessCallBack: ((_ isSuccessfully: ServiceResponseStatus) -> Void)? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        

        viewModel.delegate = self
        
        // Do any additional setup after loading the view.
    }
   
    func setParameter(_ noteBookId:Int?)
    {
        if noteBookId != -1
        {
            self.noteBookId = noteBookId! + 1
        }
    }
    //MARK : - newnotebooksVM delegate

    func didBeginLoadingContent() {
        
    }
    func didEndLoadingContent() {
        
    }
    
    func invalidNotebookName() {
        alert("Alert", message: "Enter Notebook Name", okTitle: "Ok", okCallBack: nil, cancelTitle: nil, cancelCallBack: nil)
    }
    //UIResponder delegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK : - textfield delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK : - calling callback method after add newnotebook
    func callBackOnSuccess(callBack: @escaping (_ isSuccess:ServiceResponseStatus) -> Void) {
        self.addedSuccessCallBack = callBack;
    }
    
    //MARK : - Barbutton action

    @IBAction func doneClicked(_ sender: Any) {
        
        model.notebookId = self.noteBookId
        model.notesBookName = nameTxtfld?.text
        model.date = Date()
        viewModel.addNewNotes(model, callBack: { (status) in
            if status == ServiceResponseStatus.Success
            {
                self.addedSuccessCallBack!(status)
            }
        
        })
//

    }
    @IBAction func cacelClicked(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

    }
    func dismiss() {
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
