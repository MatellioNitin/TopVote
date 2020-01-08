//
//  SubmitIdeaViewController.swift
//  TopVote
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import UIKit

class ShareHOFVC: UIViewController {

    @IBOutlet weak var imgShare: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    var imageShareShow:UIImage?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let backButton = UIBarButtonItem(image: UIImage(named:"icon_back"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(self.close))
//        navigationItem.leftBarButtonItem = backButton
        imgShare.image = imageShareShow
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareTapped(_ sender: Any) {
//        if(competition.deepUrl != nil){
           // let text = competition.deepUrl!
        let textShare = [ imageShareShow!, "abc" ] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
//        }
        
    }
}
