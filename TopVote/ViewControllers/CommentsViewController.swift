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
    
    func commentCell(_ indexPath: IndexPath, comment: Comment) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        cell.textLabel?.text = comment.text
        if let date = comment.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
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
//        let comment = PFComment(entry: entry, text: text)
//        comment.saveInBackground(block: { (success, error) -> Void in
//            if (success) {
//                self.comments.insert(comment, at: 0)
//                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//
//                let activity = PFActivity(competition: nil, entry: entry, type: ActivityType.entryCommentedOn)
//                activity.saveInBackground()
//            }
//        })
    }
}
