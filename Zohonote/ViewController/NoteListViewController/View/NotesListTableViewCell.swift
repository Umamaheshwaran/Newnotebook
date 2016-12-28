//
//  NotesListTableViewCell.swift
//  Zohonote
//
//  Created by Uma Maheshwaran on 26/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import UIKit

class NotesListTableViewCell: UITableViewCell {

    @IBOutlet weak var noteNameLbl: UILabel?
    @IBOutlet weak var cellBackgroundView: UIView?
    @IBOutlet weak var noteDateLbl: UILabel?
    @IBOutlet weak var imgView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgView?.layer.cornerRadius = 3.0
        imgView?.layer.masksToBounds = true
        
        cellBackgroundView?.layer.cornerRadius = 4.0
        cellBackgroundView?.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadCell(_ dataModel: NoteListModel)   {
        self.noteNameLbl?.text = Utility.unwrap(dataModel.notes_name, "Note")
        self.noteDateLbl?.text = dataModel.date?.toString()
        let (image , isStatus) = NSAttributedString().getImage(dataModel.notes_attribute!)
        if isStatus == true
        {
            
            self.imgView?.image = image
        }
    }
}
