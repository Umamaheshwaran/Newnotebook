//
//  NewNoteViewController.swift
//  Zohonote
//
//  Created by Rajesh on 24/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import UIKit



class NewNoteViewController: UIBaseViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var nameTxtfld : UITextField?
    private var addedSuccessCallBack: ((_ isSuccessfully: ServiceResponseStatus) -> Void)? = nil;
    var save : UIBarButtonItem?
    @IBOutlet weak var txtView: UITextView!
    var attributedString : NSAttributedString?
    var dataModel : NoteListModel?
    var noteNameStr : String?
    var canEdit : Bool?
    var noteBookId : Int? = 1
    var notesId : Int? = 1
    var scale : CGFloat? = 2
    
    var lat:Double?
    
    var longt:Double?
    lazy var viewModel : NewNoteVM =
        {
            return NewNoteVM()
    }()
    
    lazy var modelClass : NewNoteModel =
        {
            return NewNoteModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        bottomConstraint.constant = 4
        
        initUI()
    }
    
    func initUI() {
        
        noteNameStr = dataModel?.notes_name
        attributedString = dataModel?.notes_attribute
        lat = dataModel?.latitude
        longt = dataModel?.longitude
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(self.cameraBtnClicked(_:)))
        setBarTintColor(cameraBtn)

        navigationItem.rightBarButtonItem = cameraBtn
        
        if canEdit == false{
            let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveBtnClicked(_:)))

            setBarTintColor(saveBtn)

            navigationItem.rightBarButtonItems = [saveBtn,cameraBtn]
         
        }
        else
        {
            txtView.attributedText = attributedString
            if txtView.text == ""
            {
                txtView.text = "Tap to edit"
            }
            nameTxtfld?.text = noteNameStr
        }

    }
    func setBarTintColor(_ barBtn:UIBarButtonItem) {
        barBtn.tintColor =  UIColor(red: 59.0/255.0, green: 181.0/255.0, blue: 58.0/255.0, alpha: 1)

    }
    override func viewWillAppear(_ animated: Bool) {
        
         if canEdit == false{
        txtView.becomeFirstResponder()
        }
    }
    
  
    func setParameter(_ noteBookId:Int?,notesId:Int?,_ titleStr:String?,_ canEdit:Bool?)
    {
        self.notesId = notesId
        if notesId != -1 && canEdit == false
        {
            self.notesId = notesId! + 1
        }
        self.noteBookId = noteBookId!
        self.title = titleStr
        
       self.canEdit = canEdit


    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)

    }
    //Textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tap to edit"
        {
            txtView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtView.text == ""
        {
            txtView.text = "Tap to edit"
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        update()
    }
    func update()
    {
        if canEdit == true
        {
            viewModel.updateNoteDetails(forNotesId: notesId!, noteBookId, addValueIntoModelClass(), callBack: { (status) in
                
                //self.addedSuccessCallBack!(status)
                
            })
        }
    }
    //MARK: -Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        update()
    }
    //Keyboard delegate
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
                self.bottomConstraint.constant = keyboardSize.height
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {

            self.bottomConstraint.constant = 4
        


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - Barbutton action
    
    @IBAction func mapClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "mapNav");
        if let manualVC = (nextViewController as? UINavigationController)?.topViewController as? MapViewViewController {
            
            manualVC.setParaMeter(lat, longt , dataModel?.notes_name)
           
            manualVC.callBackOnSuccess(callBack: { (lati, longt) in
                
                self.longt = longt
                self.lat = lati
                
self.update()
                
            })
            
        }
        self.present(nextViewController, animated: true, completion: nil)
    }
    @IBAction func saveBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
           viewModel.addNewNotes(addValueIntoModelClass()) { (status) in
           
                self.addedSuccessCallBack!(status)
                
            }
    }
    func addValueIntoModelClass() -> NewNoteModel {
        modelClass.date = Date()
        modelClass.latitude = lat
        modelClass.longitude = longt
        modelClass.notebooks_Id = Int16(noteBookId!)
        modelClass.notes_id = Int16(notesId!)
        modelClass.notes_attribute = txtView.attributedText
        
        modelClass.notes_name = nameTxtfld?.text
        
        if modelClass.notes_name == ""
        {
            modelClass.notes_name = "Note"
        }
        
        return modelClass
        
    }
    @IBAction func cancelClicked(_ sender: Any) {
        self.view.endEditing(true)
        if canEdit == false{
            if txtView.text == "" ||  txtView.text == "Tap to edit"
            {
                dismiss(animated: true, completion: nil)

            }
            else {
                
                actionSheetAlert(nil, message: nil, btn1Title: "Discard", btn1CallBack: {
                    
                    self.dismiss(animated: true, completion: nil)
                
            }, btn2Title: "Save", btn2CallBack: {
                //self.openLibraryCamera(.OpenCamera)
                self.saveBtnClicked(UIButton())
            }, cancelTitle: nil, cancelCallBack: nil,SelectedActionSheetOption.Other)
            }
        }
        else{
           // guard  let nonNilNooteId = notesId else {
//                return
//            }
//            viewModel.updateNoteDetails(forNotesId: nonNilNooteId, noteBookId, addValueIntoModelClass(), callBack: { (status) in
            
            self.addedSuccessCallBack!(ServiceResponseStatus.Success)

         //   })
        }
       }
    
    @IBAction func cameraBtnClicked(_ sender: Any) {
        
       
actionSheetAlert(nil, message: nil, btn1Title: "Photo Library", btn1CallBack: { 
    self.openLibraryCamera(.Photo)

}, btn2Title: "Take Photo", btn2CallBack: {
    self.openLibraryCamera(.OpenCamera)

}, cancelTitle: "Cancel", cancelCallBack: nil,SelectedActionSheetOption.OpenCamera)

    }
    
    
    func dismiss() {
        
        if canEdit == false{
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        else{
             _ =  self.navigationController?.popViewController(animated: true)
        }
       
    }
    //MARK : - calling callback method after add newnotebook
    func callBackOnSuccess(callBack: @escaping (_ isSuccess:ServiceResponseStatus) -> Void) {
        self.addedSuccessCallBack = callBack;
    }
    // MARK: - Imagepicker controller delegate
    func openLibraryCamera(_ option:SelectedActionSheetOption) -> Void {
        
        
        imagePicker.allowsEditing = false
        
        if option == .OpenCamera &&  UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera
            ) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            
        }
        else  if option == .Photo &&  UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary
            ) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        }
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // orginal image convert into png
            let pngRepresentation = UIImagePNGRepresentation(pickedImage)
            
            // png data convert into image

            let finalImage = UIImage(data: pngRepresentation!)

       
            //save to textview
            pasteImage(finalImage!)

        }
        dismiss(animated: true, completion: nil)
    }

    var attributedString1 = NSMutableAttributedString(string: "")
    
    func pasteImage(_ image:UIImage) -> Void {
        
        let imageAttach = NSTextAttachment()

            txtView.insertText("\n")
        
         imageAttach.image = image
         let oldWidth = imageAttach.image!.size.width;
        
        //calculate scale factor
         scale = oldWidth / (txtView.frame.size.width - 10);
        imageAttach.image = UIImage(cgImage: imageAttach.image!.cgImage!, scale: scale!, orientation: .up)
        
            let mutableAttString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttach))
        
            let attrString = txtView.attributedText ?? NSAttributedString(string: txtView.text)
            
            let attributedString = NSMutableAttributedString(attributedString: attrString)
            attributedString.insert(mutableAttString, at: txtView.selectedRange.location)
            txtView.attributedText = attributedString
            txtView.selectedRange.location += 1
        
            txtView.insertText("\n")
        

    }

 }
