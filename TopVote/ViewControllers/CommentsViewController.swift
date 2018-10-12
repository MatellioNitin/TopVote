//
//  CommentsViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/2/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var entry : Entry?
    var comments = Comments()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = entry?.title?.uppercased()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.register(UINib(nibName: "AddCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "AddCommentCell")
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentIndex = indexPath.row
        if (comments.count > 0 && commentIndex < comments.count) {
            let comment = comments[commentIndex]
            return commentCell(indexPath, comment: comment)
        }

        return addCommentCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
    }
    
    func commentCell(_ indexPath: IndexPath, comment: Comment) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.lblCommentTitle?.text = comment.text
        cell.lblCommentName?.text = comment.account?.displayUserName

        if let date = comment.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            cell.lblCommentDetail?.text = dateFormatter.string(from: date)
        }
        return cell
    }
    
    func addCommentCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath) as! AddCommentTableViewCell
        cell.delegate = self
        cell.entry = entry
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentsViewController: AddCommentTableViewCellDelegate {
    
    func submitComment(_ cell: AddCommentTableViewCell, text: String, entry: Entry) {
        cell.textField.text = nil
        cell.textField.resignFirstResponder()

        
        if let entryId = entry._id {
            let params = [
                "text": text
            ]
            Account.createComment(entryId: entryId, params: params, error: { (errorMessage) in
                
            }, completion: { [weak self] (comment) in
                DispatchQueue.main.async {
                    
                    
                    DispatchQueue.main.async {
                        self?.comments.append(comment)
                        self?.tableView.reloadData()
                        self?.tableView.layoutIfNeeded()
                        let addCommentCellIndexPath = IndexPath(row: (self?.comments.count)! - 1, section: 0)
                        self?.tableView.scrollToRow(at: addCommentCellIndexPath,  at: UITableViewScrollPosition.top, animated: true)
                    }
                    
                }
                
            })
        }

        
    }
}
