//
//  AddCommentTableViewCell.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/10/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

protocol AddCommentTableViewCellDelegate {
    func submitComment(_ cell: AddCommentTableViewCell, text: String, entry: Entry)
}

class AddCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var delegate: AddCommentTableViewCellDelegate?
    var entry: Entry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func submitComment(_ sender: AnyObject) {
        if let text = textField.text, text.characters.count > 0, let entry = entry {
            delegate?.submitComment(self, text: text, entry: entry)
        }
    }
    
}
