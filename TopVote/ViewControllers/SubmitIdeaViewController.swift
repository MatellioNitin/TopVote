//
//  SubmitIdeaViewController.swift
//  TopVote
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import UIKit

class SubmitIdeaViewController: UIViewController {

    @IBOutlet weak var ideaTextView: UITextView!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ideaTextView.dropShadow(nil, CGSize(width: -1, height: 1), 2, 0.1, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        let params = [
            "text": ideaTextView.text
        ]
        Idea.create(params: params, error: { (errorMessage) in
            DispatchQueue.main.async {
                self.showErrorAlert(errorMessage: errorMessage)
            }
        }) { (idea) in
            DispatchQueue.main.async {
                let alertController = TVAlertController(title: "Thanks", message: "Thanks for your idea! Check back to see which one wins!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
