//
//  DashBoardViewController.swift
//  Zohonote
//
//  Created by Rajesh on 23/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import UIKit
class DashBoardViewController: UIBaseViewController,UITableViewDelegate,UITableViewDataSource,NotebooksdashboardDelegate,UISearchBarDelegate {
    lazy var viewModel : NotebooksDashboardVM =
        {
            return NotebooksDashboardVM()
    }()
    @IBOutlet weak var newBtn: UIButton!

    @IBOutlet weak var notebookSearchBar: UISearchBar?
    
    @IBOutlet weak var notesListTblView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()

        notesListTblView?.tableFooterView = UIView()
        notesListTblView?.estimatedRowHeight = 55;
        notesListTblView?.rowHeight = UITableViewAutomaticDimension

        viewModel.delegate = self
        // Do any additional setup after loading the view.
        print(selectedShortCutItemConfig.selectedPage)
        
        
        loadValueFromLocalDB()
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadValueFromLocalDB() -> Void
    {
        viewModel.getNoteBooks()
    }
    // MARK: -  Add button action
    
    @IBAction func addNotebooks(_ sender: Any) {
        
        presentNoteViewController()

    }
    
    // MARK: - Tableview delegate and datasource
    func didBeginLoadingContent() {
        notesListTblView?.isHidden = true
        newBtn.isHidden = true

    }
    func didEndLoadingContent(_ status: ServiceResponseStatus) {
        if status == .Success && viewModel.getNotBooksCount() > 0
        {
            notesListTblView?.isHidden = false
            if selectedShortCutItemConfig.selectedPage == .search
            {
                notebookSearchBar?.becomeFirstResponder()
                selectedShortCutItemConfig.selectedPage = .defaultPage
            }
            else if selectedShortCutItemConfig.selectedPage == .newNote
            {
                pushToNextViewController(at: 0)

            }
            else{
                
            self.view.endEditing(true)
            }
        }
        else{
            newBtn.isHidden = false

        }
        notesListTblView?.reloadData()
    }
    
   
    func serviceListDidEndLoading(forKeyword keyword: String?, withStatus status: ServiceResponseStatus) {
        if status == .Success && keyword != "" {
            notesListTblView?.reloadData()
            notebookSearchBar?.resignFirstResponder()
        }
        else if status == .NoRecordsFound
        {
            self.alert("Alert", message: "Sorry, no results found. Search with another keyword", okTitle: "Ok", okCallBack: nil, cancelTitle: nil, cancelCallBack: nil)

        }
    }
     // MARK: - searchbar delegate 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""
        {
            loadValueFromLocalDB()
        }
        else{
            viewModel.getSuggestions(forKeyword: searchBar.text)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""
        {
            loadValueFromLocalDB()
        }
        else{
            viewModel.getSuggestions(forKeyword: searchBar.text)
        }
    }
    
    // MARK: - Tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNotBooksCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.selectionStyle = .none
        
        if  let nonNilModel = viewModel.getNoteBook(atIndex: indexPath.row)
        {
            cell.textLabel?.text = nonNilModel.notebooks_title
        }
        //cell.detailTextLabel?.text = "5 notes"
        return cell
    }
    
    func pushToNextViewController(at selectedIndex:Int)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NoteListViewController") as! NoteListViewController;
        nextViewController.setParameter(viewModel.getNoteBook(atIndex: selectedIndex)?.notebooks_Id,
                                        viewModel.getNoteBook(atIndex: selectedIndex)?.notebooks_title)
        
        navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        pushToNextViewController(at: indexPath.row)


    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            viewModel.deleteNoteBooks(forNotebooksId: viewModel.getNoteBook(atIndex: indexPath.row)?.notebooks_Id)
        }
    }
    
    
    // MARK: - Rightbar button action
    
    @IBAction func addNewClicked(_ sender: UIBarButtonItem) {
        
       presentNoteViewController()
    }
    
    func presentNoteViewController(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewNoteBookNav");
        if let manualVC = (nextViewController as? UINavigationController)?.topViewController as? NewNotebookViewController {
            manualVC.setParameter(viewModel.getNoteBookId())
            manualVC.callBackOnSuccess(callBack: {  (status)  in
                if status == ServiceResponseStatus.Success
                {
                    
                    manualVC.dismiss()
                    self.loadValueFromLocalDB()
                }
            })
        }
        
        self.present(nextViewController, animated: true, completion: nil)
    }
}
