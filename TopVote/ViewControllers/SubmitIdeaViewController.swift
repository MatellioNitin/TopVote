//
//  SubmitIdeaViewController.swift
//  TopVote
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import UIKit

class SubmitIdeaViewController: UIViewController {

    @IBOutlet weak var ideaTextView: UITextView!

    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ideaTextView.dropShadow(nil, CGSize(width: -1, height: 1), 2, 0.1, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        lblTitle.text =  "Have an idea or feedback for a competition?\nWe'd love to hear from you!"
        
        let backButton = UIBarButtonItem(image: UIImage(named:"icon_back"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        if(ideaTextView.text == ""){
            self.showErrorAlert(errorMessage: "Please enter your feedback.")

        }
        else
        {
        
        let params = [
            "text": ideaTextView.text
        ]
        Idea.create(params: params, error: { (errorMessage) in
            DispatchQueue.main.async {
                self.showErrorAlert(errorMessage: errorMessage)
            }
        }) { (idea) in
            DispatchQueue.main.async {
                let alertController = TVAlertController(title: "", message: "Thanks for your feedback! Your voice matters!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
      }
    }
}
