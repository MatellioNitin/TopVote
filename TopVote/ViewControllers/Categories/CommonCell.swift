//
//  CommonCell.swift
//  Topvote
//
//  Created by CGT on 24/08/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import UIKit

class CommonCell: UITableViewCell {
    
    // CategoryVC
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    // CreateCompitionVC
    
    @IBOutlet weak var btnCompition: UIButton!
    
    @IBOutlet weak var lblCompition: UILabel!
    
    @IBOutlet weak var txtField: CustomUITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtDate: CustomUITextField!
    
    @IBOutlet weak var txtTime: CustomUITextField!

    
    
    
    
    // SUBMIT POLL
    
    @IBOutlet weak var lblQuestion: UILabel! // QuestionCell
    @IBOutlet weak var imgRadio: UIImageView! //AnswerRadioCell
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var btnSubmit: UIButton! // SubmitCell
    
    
    // SURVEY
    @IBOutlet weak var lblSurveyTitle1: UILabel!
    @IBOutlet weak var lblSurveyTitle2: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

