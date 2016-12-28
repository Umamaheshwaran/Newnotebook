//
//  NoteListViewController.swift
//  Zohonote
//
//  Created by Rajesh on 24/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import UIKit

class NoteListViewController: UIBaseViewController,NotesListDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var txtView: UITextView!

    @IBOutlet weak var notesListTblView: UITableView?
    var noteBookId : Int? = 1

    @IBOutlet weak var newBtn: UIButton!
    lazy var viewModel : NotesListVM =
        {
            return NotesListVM()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        notesListTblView?.tableFooterView = UIView()
        viewModel.delegate = self
        // Do any additional setup after loading the view.
        
        loadData()
    }
    func loadData() {
        viewModel.getNotes(forNoteBookId: noteBookId)

    }
    func didBeginNotesListLoadingContent() {
        notesListTblView?.isHidden = true
        newBtn.isHidden = false

    }
    
    func didEndNotesListLoadingContent(_ status: ServiceResponseStatus) {
        if status == .Success
        {
           // txtView.attributedText = viewModel.getNotes(atIndex: 0)?.notes_attribute
            notesListTblView?.isHidden = false

            notesListTblView?.reloadData()
        }
        if viewModel.getNotesCount() > 0
        {
            newBtn.isHidden = true

        }
        if selectedShortCutItemConfig.selectedPage == .newNote
        {
            selectedShortCutItemConfig.selectedPage = .defaultPage
            presentNoteViewController()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setParameter(_ noteBookId:Int?,_ titleStr:String?)
    {
        
        self.noteBookId = noteBookId!
        self.title = titleStr
    }
    // MARK: - Tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNotesCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesListTableViewCell", for: indexPath) as! NotesListTableViewCell
        
        cell.selectionStyle = .none
        
        if  let nonNilModel = viewModel.getNotes(atIndex: indexPath.row)
        {
            cell.loadCell(nonNilModel)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewNoteViewController") as! NewNoteViewController;
        
        
        //Pass parameter to nextviewcontroller
       
        nextViewController.dataModel = viewModel.getNotes(atIndex: indexPath.row)
        nextViewController.setParameter(noteBookId, notesId: viewModel.getNotes(atIndex: indexPath.row)?.notes_id, self.title, true)

        nextViewController.callBackOnSuccess { (status) in
            if status == .Success
            {
                nextViewController.dismiss()
                self.loadData()
            }
        }
        //Push
        navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {

        viewModel.deleteNoteBooks(forNoteId: viewModel.getNotes(atIndex: indexPath.row)?.notes_id, notebooksId: noteBookId)
        
        }
    }
    // MARK: -  Add button action

    @IBAction func createNoteClicked(_ sender: Any) {
        
        presentNoteViewController()
    }
    
    func presentNoteViewController() -> Void {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewNoteNav");
        if let manualVC = (nextViewController as? UINavigationController)?.topViewController as? NewNoteViewController {
            
            manualVC.setParameter(noteBookId, notesId: viewModel.getNotesId() ,self.title,false)
            manualVC.callBackOnSuccess(callBack: { (status) in
                if status == .Success
                {
                    manualVC.dismiss()
                     self.loadData()
                }

            })
            
        }
        
        self.present(nextViewController, animated: true, completion: nil)
        
    
    }
    
    // MARK: - Rightbar button action
    
    @IBAction func addNewClicked(_ sender: UIBarButtonItem) {
        presentNoteViewController()
    }
  
}


