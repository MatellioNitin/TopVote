//
//  EntryViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/2/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: KeyboardScrollViewController {
    @IBOutlet weak var mediaView: MediaView!

    override func viewDidLoad() {
      
        NotificationCenter.default.addObserver(self,
            selector: #selector(VideoPlayerViewController.playerItemDidReachEnd(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mediaView.stopPlaying()
    }
    
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        if let avPlayerItem = notification.object as? AVPlayerItem {
            if (avPlayerItem == mediaView.player?.currentItem) {
                mediaView.startPlaying()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

class EntryViewController: VideoPlayerViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var userImageView: RoundedImageView!
    @IBOutlet weak var entryImageView: RoundedImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var lblTextDescription: UILabel!
    @IBOutlet weak var imgViewHeightConstraint: NSLayoutConstraint?

    
    @IBOutlet weak var tableView: UITableView!
    var showComments = false

    var entryId: String?
    var entry: Entry? {
        didSet {
            refreshView()
            if let entry = entry {
                DispatchQueue.main.async {
                    self.loadComments(entry)
                }
            }
        }
    }

    var entryComments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadEntry()
        // self.navigationController?.navigationBar.topItem?.title = ""

        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.register(UINib(nibName: "AddCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "AddCommentCell")
    }
    
    func loadEntry() {
        if let entryId = entryId {
            Entry.findOne(entryId: entryId, error: { (errorMessage) in
                
            }, completion: { (entry) in
                self.entry = entry
            })
//            let query = PFEntry.queryWithIncludes()
//            query?.getObjectInBackground(withId: entryId, block: { (entry, error) -> Void in
//                if let entry = entry as? PFEntry {
//                    self.entry = entry
//                }
//            })
        }
    }
    
    func refreshView() {
        if let entry = entry {
            if let mediaUri = entry.mediaUri, let uri = URL(string: mediaUri) {
                imgViewHeightConstraint?.constant = 250
                mediaView.layoutIfNeeded()
                 if entry.mediaType == "IMAGE" {
                    entryImageView?.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                } else if entry.mediaType == "VIDEO" {
                    mediaView.addPlayer(uri)
                    mediaView.startPlaying()
                }
           
            }
            else if(entry.mediaType == "TEXT"){
                    mediaView.isHidden = true
                    lblTextDescription.text = self.entry?.text
                  let height = self.lblTextDescription?.heightForView(text: (self.lblTextDescription?.text)!, font: (self.lblTextDescription?.font)!, width: (self.lblTextDescription?.frame.width)!)
                
                imgViewHeightConstraint?.constant = height! - 10
                    mediaView.layoutIfNeeded()
                }
            
            
            if let profileImageUri = entry.account?.profileImageUri, let uri = URL(string: profileImageUri) {
                userImageView?.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
            }
            
            
//            if let imageURL = entry.imageURL {
//                entryImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "loading"))
//            } else if let videoURL = entry.videoURL, let url = URL(string: videoURL) {
//                mediaView.addPlayer(url)
//            }
//            if let imageURL = entry.account?.imageURL {
//                userImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "loading"))
//            }

            userNameLabel.text = entry.account?.username ?? entry.account?.name
            locationLabel.text = entry.locationName
            if let date = entry.createdAt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                timeLabel.text = dateFormatter.string(from: date)
            }
            subTitleLabel.text = entry.subTitle
            if let numberOfVotes = entry.numberOfVotes {
                votesLabel.text = "\(numberOfVotes) vote\(numberOfVotes == 0 || numberOfVotes > 1 ? "s" : "")"
            }

        } else {
            // TODO reset everything.
        }
    }
    
    func loadComments(_ entry: Entry) {
        if let entryId = entry._id {
            Account.comments(entryId: entryId, queryParams: nil, error: { (errorMessage) in
                
            }, completion: { [weak self] (comments) in
                DispatchQueue.main.async {
                    self?.entryComments = comments
                    self?.tableView.reloadData()
                }
            })
        }
//        let query = PFComment.queryWithIncludes()
//        query?.whereKey("entry", equalTo: entry)
//        query?.order(byDescending: "createdAt")
//        query?.findObjectsInBackground(block: { (comments, error) -> Void in
//            if (error == nil), let comments = comments as? [PFComment] {
//                self.entryComments = comments
//                self.tableView.reloadData()
//            }
//        })
    }

    func showProfile(){
        if let entry = entry, let account = entry.account {
            if let nc = storyboard?.instantiateViewController(withIdentifier: "YourProfileNC") as? UINavigationController {
                if let vc = nc.childViewControllers.first as? YourProfileViewController {
                    vc.user = account
                    self.present(nc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        if let entry = entry {
            shareEntry(entry)
        }
    }
    
    @IBAction func commentButtonPressed(_ sender: AnyObject) {
        showComments = !showComments
        tableView.reloadData()
        if showComments {
            let addCommentCellIndexPath = IndexPath(row: 0, section: 1)
            self.tableView.scrollToRow(at: addCommentCellIndexPath,
                                       at: UITableViewScrollPosition.bottom,
                                       animated: true)
        }
    }
    
    func commentEntry(_ entry: AnyObject) {
        self.performSegue(withIdentifier: "toComments", sender: entry)
    }

    func shareEntry(_ entry: Entry) {
        guard let url = entry.shareURL else {
            return
        }
        let textToShare = "Check out this awesome entry on TopVote!"
        let objectsToShare = [textToShare, url] as [Any]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            //print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            if (success) {
                //                entry.incrementKey("numberShares", byAmount: 1)
                //                entry.saveInBackground()
                //                let activity = PFActivity(competition: nil, entry: entry, type: ActivityType.entryShared)
                //                activity.saveInBackground()
                //                PFCloud.callFunction(inBackground: "incrementEntryShare", withParameters: ["entryId": entry.objectId ?? "", "userId": PFVoter.current()?.objectId ?? ""], block: { (result, error) in
                //                    //
                //                })
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toComments") {
            if let vc = segue.destination as? CommentsViewController {
                //vc.entry = sender as! PFEntry
            }
        }
        
    }

}

extension EntryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return showComments ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return entryComments.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let comment = entryComments[indexPath.row]
            return commentCell(indexPath, comment: comment)
        } else {
            return addCommentCell(indexPath)
        }
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
        let entry = self.entry
        cell.entry = entry
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
}

extension EntryViewController: AddCommentTableViewCellDelegate {
    
    func submitComment(_ cell: AddCommentTableViewCell, text: String, entry: Entry) {
        cell.textField.text = nil
        cell.textField.resignFirstResponder()
        
        if let entryId = entry._id {
            let params = [
                "text": text
            ]
            Account.createComment(entryId: entryId, params: params, error: { (errorMessage) in
                
            }, completion: { (comment) in
                DispatchQueue.main.async {
                    self.entryComments.append(comment)
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    let addCommentCellIndexPath = IndexPath(row: 0, section: 1)
                    self.tableView.scrollToRow(at: addCommentCellIndexPath,
                                               at: UITableViewScrollPosition.bottom,
                                               animated: true)
                }
            })
        }
    }
}
