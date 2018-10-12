//
//  CommentTableViewCell.swift
//  Topvote
//
//  Created by CGT on 19/09/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import UIKit
class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCommentTitle: UILabel!
    @IBOutlet weak var lblCommentDetail: UILabel!
    @IBOutlet weak var lblCommentName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
