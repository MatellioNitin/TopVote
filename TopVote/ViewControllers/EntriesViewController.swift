//
//  competitionTableViewController.swift
//  Super
//
//  Created by Matthew Arkin on 10/12/14.
//  Copyright (c) 2014 Super. All rights reserved.
//

import UIKit
import MediaPlayer
//import Parse
//import SDWebImage

class UserCompetitionEntriesViewController: EntriesViewController {
    
    var user : Account?
    var competition : Competition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let competition = competition {
            navigationItem.title = competition.title?.uppercased()
            textLabel?.text = competition.text
        }
    }
    
    override func entriesQuery() {
//        if let user = user {
//            return PFEntry.entriesForUserCompetionQuery(user, competition: competition)
//        }
    }
    
}

class UserEntriesViewController: EntriesViewController {
    
    var user : Account?

    override func entriesQuery() {
        if let user = user {
            let queryParams = [
                "account": user._id ?? ""
            ]
            user.entries(queryParams: queryParams, error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: { [weak self] (entries) in
                DispatchQueue.main.async {
                    self?.entries = entries
                    self?.tableView.reloadData()
                    //refreshControl?.endRefreshing()
                }
            })
        }
    }

}

class CompetitionEntriesViewController: EntriesViewController {
    
    var competition : Competition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = competition?.title?.uppercased()
        textLabel?.text = competition?.text
        textLabel?.sizeToFit()
        textLabel?.layoutIfNeeded()

        if let competition = competition {
            if (!competition.hasEnded()) {
                let competeButton = UIBarButtonItem(title: "Compete", style:UIBarButtonItemStyle.plain, target: self, action: #selector(CompetitionEntriesViewController.toNewEntry))
                navigationItem.rightBarButtonItem = competeButton
            }
        }
    }
    
    @objc func toNewEntry() {
        if let competition = competition {
            if (!competition.hasEnded()) {
                performSegue(withIdentifier: "toNewEntry", sender: nil)
            } else {
                self.showErrorAlert(errorMessage: "The competition has ended")
            }
        }
    }
    
    override func entriesQuery() {
//        let query = PFEntry.queryWithIncludes()
//        query?.whereKey("competition", equalTo: competition)
        guard let competition = competition, let competitionId = competition._id else {
            return
        }
        
        let queryParams = [
            "competition": competitionId
        ]

        Entry.find(queryParams: queryParams, error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (entries) in
            DispatchQueue.main.async {
                self?.entries = entries
                self?.tableView.reloadData()
                //refreshControl?.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toNewEntry") {
            if let vc = segue.destination as? NewEntryViewController {
                vc.competition = competition
                vc.delegate = self
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

class EntriesViewController: KeyboardScrollViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum SearchType : Int {
        case new = 0
        case top
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UILabel?
    @IBOutlet weak var segmentedControl: UISegmentedControl?

    var entries = Entries() {
        didSet {
            selectedEntry = nil
            comments.removeAll()
            tableView.reloadData()
        }
    }
    var searchType = SearchType.new
    var playingCell: EntryTableViewCell?
    var comments = [Entry:[Comment]]()
    var selectedEntry: Entry?
    var shouldAutoplay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "competitionItem")
        tableView.register(UINib(nibName: "MoreCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreCommentsCell")
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.register(UINib(nibName: "AddCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "AddCommentCell")
        tableView.estimatedRowHeight = 36
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadEntries()
    }
    
    @IBAction func refreshAndSort(_ sender: UISegmentedControl) {
        searchType = SearchType(rawValue: sender.selectedSegmentIndex) ?? SearchType.new
        loadEntries()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells {
            if let cell = cell as? EntryTableViewCell {
                cell.stopMedia()
            }
        }
    }
    
    func entriesQuery() {
        // subclassed
    }
    
    func loadEntries() {
        let currentSearchType = searchType
        if (currentSearchType == .new) {
            entriesQuery()
//            let query = entriesQuery()
//            query?.order(byDescending: "createdAt")
//            query?.findObjectsInBackground(block: { [weak self] (entries, error) -> Void in
//                if (error == nil), let entries = entries as? [PFEntry] {
//                    self?.entries = entries
//                }
//
//            })
        } else if (currentSearchType == .top) {
//            let query = entriesQuery()
//            query?.order(byDescending: "valueVotes")
//            query?.findObjectsInBackground(block: { [weak self] (entries, error) -> Void in
//                if (error == nil), let entries = entries as? [PFEntry] {
//                    self?.entries = entries
//                    //  refreshControl?.endRefreshing()
//                }
//            })
        }
        
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let entry = entries[section]
        if let selectedEntry = selectedEntry {
            if (entry == selectedEntry) {
                if let entryComments = comments[entry] {
                    return min(4,entryComments.count) + 2
                }
                return 2
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "competitionItem", for: indexPath) as! EntryTableViewCell
            let entry = entries[indexPath.section]
            cell.configureWithEntry(entry, compact: false)
            cell.delegate = self
            
            return cell
        } else {
            if (indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 ) {
                let entry = entries[indexPath.section]
                if let entryComments = comments[entry] {
                    let commentIndex = indexPath.row-1
                    if (entryComments.count > 0 && commentIndex < entryComments.count) {
                        if (commentIndex >= 3) {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCommentsCell", for: indexPath)
                            return cell
                        } else {
                            let comment = entryComments[commentIndex]
                            return commentCell(indexPath, comment: comment)
                        }
                    }
                }
            }

            return addCommentCell(indexPath)
        }
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
        let entry = entries[indexPath.section]
        cell.entry = entry
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 450
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 ) {
            let entry = entries[indexPath.section]
            if let entryComments = comments[entry] {
                let commentIndex = indexPath.row-1
                if (entryComments.count > 0 && commentIndex < entryComments.count) {
                    if (commentIndex >= 3) {
                        if let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as? CommentsViewController {
                            vc.entry = entry
                            vc.comments = entryComments
                            navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }

    func scrollViewDidScroll(_ aScrollView: UIScrollView) {
        for cell in tableView.visibleCells {
            if let cell = cell as? EntryTableViewCell {
                let cellRect = aScrollView.convert(cell.frame, to: aScrollView.superview)
                let intersectRect = aScrollView.frame.intersection(cellRect)
                if (intersectRect.height > cellRect.height*0.7) {
                    if (shouldAutoplay) {
                        cell.startMedia()
                        playingCell = cell
                    }
                } else {
                    cell.stopMedia()
                }
            }

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toComments") {
            if let vc = segue.destination as? CommentsViewController {
                vc.entry = sender as? Entry
            }
        }
    }
}

extension EntriesViewController: EntryTableViewCellDelegate {
    func showUser(_ user: Account) {
        if let accountId = user._id {
            Account.findOne(accountId: accountId, error: { (errorMessage) in
                DispatchQueue.main.async {
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: { [weak self] (profileAccount) in
                DispatchQueue.main.async {
                    if let nc = self?.storyboard?.instantiateViewController(withIdentifier: "YourProfileNC") as? UINavigationController {
                        if let vc = nc.childViewControllers.first as? YourProfileViewController {
                            vc.user = profileAccount
                            self?.present(nc, animated: true, completion: nil)
                        }
                    }
                }
            })
        }
    }
    
    func playMedia(_ cell: EntryTableViewCell) {
        cell.toggleMedia()
    }
    
    func commentEntry(_ entry: Entry) {
        //performSegue(withIdentifier: "toComments", sender: entry)
        loadComments(entry)
    }
    
    func loadComments(_ entry: Entry) {
        // TODO lol
        
        if (selectedEntry != entry) {
            if let selectedEntry = selectedEntry, let index = entries.index(of: selectedEntry) {
                self.selectedEntry = nil
                let numRows = tableView.numberOfRows(inSection: index)
                var indexPaths = [IndexPath]()
                for i in 1..<numRows {
                    indexPaths.append(IndexPath(row: i, section: index))
                }
                tableView.deleteRows(at: indexPaths, with: .automatic)
            }
            var shouldFetch = true
            if let index = entries.index(of: entry) {
                // prep for initial row insert
                let numRowsBefore = tableView.numberOfRows(inSection: index)
                selectedEntry = entry
                var fetchedCommentCount = 0
                if let entryComments = comments[entry] {
                    // dont fetch
                    shouldFetch = false
                    fetchedCommentCount = entryComments.count
                }
                var indexPaths = [IndexPath]()
                let numRowsAfter = 2+min(4,fetchedCommentCount)
                for i in numRowsBefore..<numRowsAfter {
                    indexPaths.append(IndexPath(row: i, section: index))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
            if (shouldFetch) {
                // fetch comments if not already fetched.
                if let entryId = entry._id {
                    Account.comments(entryId: entryId, queryParams: nil, error: { (errorMessage) in
                        
                    }, completion: { [weak self] (comments) in
                        DispatchQueue.main.async {
                            if (self?.selectedEntry == entry) {
                                if let index = self?.entries.index(of: entry) {
                                    let numRowsBefore = self?.tableView.numberOfRows(inSection: index) ?? 0
                                    self?.comments[entry] = comments
                                    var indexPaths: [IndexPath] = []
                                    let numRowsAfter = 2+min(4,comments.count)
                                    for i in numRowsBefore..<numRowsAfter {
                                        indexPaths.append(IndexPath(row: i, section: index))
                                    }
                                    self?.tableView.insertRows(at: indexPaths, with: .automatic)
                                    if (comments.count > 0) {
                                        // reload the first row (comment input) since it is now a comment
                                        self?.tableView.reloadRows(at: [IndexPath(row: 1, section: index)], with: .automatic)
                                    }
                                }
                            }
                        }
                    })
                }
                
//                let query = PFComment.queryWithIncludes()
//                query?.whereKey("entry", equalTo: entry)
//                query?.order(byDescending: "createdAt")
//                query?.findObjectsInBackground(block: { [weak self] (comments, error) -> Void in
//                    if (error == nil), let comments = comments as? [PFComment] {
//                        if (self?.selectedEntry == entry) {
//                            if let index = self?.entries.index(of: entry) {
//                                let numRowsBefore = self?.tableView.numberOfRows(inSection: index) ?? 0
//                                self?.comments[entry] = comments
//                                var indexPaths: [IndexPath] = []
//                                let numRowsAfter = 2+min(4,comments.count)
//                                for i in numRowsBefore..<numRowsAfter {
//                                    indexPaths.append(IndexPath(row: i, section: index))
//                                }
//                                self?.tableView.insertRows(at: indexPaths, with: .automatic)
//                                if (comments.count > 0) {
//                                    // reload the first row (comment input) since it is now a comment
//                                    self?.tableView.reloadRows(at: [IndexPath(row: 1, section: index)], with: .automatic)
//                                }
//                            }
//                        }
//                    }
//                })
            }
        }
    }
    
    func voteEntry(_ cell: EntryTableViewCell, entry: Entry) {
        let alertController = TVAlertController(title: "Vote", message: entry.subTitle, preferredStyle: .actionSheet)
        let voteAction = UIAlertAction(title: "Vote", style: .default, handler: { (action) -> Void in
            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    cell.refreshVotes()
                }
            })
        })
        let sVoteAction = UIAlertAction(title: "SuperVote (worth 2 votes)", style: .default, handler: { (action) -> Void in
            entry.vote(numberOfVotes: 2, error: { (errorMessage) in
                DispatchQueue.main.async {
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    cell.refreshVotes()
                }
            })
        })
        alertController.addAction(voteAction)
        alertController.addAction(sVoteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            cell.refreshVotes()
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
    
    func moreEntry(_ entry: Entry) {
        let alertController = TVAlertController(title: "More", message: entry.subTitle, preferredStyle: .actionSheet)
        if (entry.isAuthor()) {
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
                self.destroyEntry(entry)
            }
            alertController.addAction(deleteAction)
        } else {
            let reportAction = UIAlertAction(title: "Report", style: .destructive) { (action) -> Void in
                self.reportEntry(entry)
            }
            alertController.addAction(reportAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func reportEntry(_ entry: Entry) {
        entry.flag(status: 0, error: { (errorMessage) in
            self.showErrorAlert(errorMessage: errorMessage)
        }) { (flag) in
            DispatchQueue.main.async {
                let alertController = TVAlertController(title: "Reported", message: "Thanks for the info. We're looking into it.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func destroyEntry(_ entry: Entry) {
        let alertController = TVAlertController(title: "Are you sure?", message: "This cannot be undone.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) -> Void in
            entry.delete(error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    self?.loadEntries()
                }
            })
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

}

extension EntriesViewController: AddCommentTableViewCellDelegate {
    
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
                    if var entryComments = self?.comments[entry] {
                        entryComments.insert(comment, at: 0)
                        self?.comments[entry] = entryComments
                    } else {
                        self?.comments[entry] = [comment]
                    }
                    if self?.selectedEntry == entry {
                        if let index = self?.entries.index(of: entry) {
                            if ((self?.comments[entry]?.count)! > 3) {
                                let numRowsBefore = self?.tableView.numberOfRows(inSection: index) ?? 0
                                var indexPaths: [IndexPath] = []
                                let numRowsAfter = 2+min(4,self?.comments[entry]?.count ?? 0)
                                for i in numRowsBefore..<numRowsAfter {
                                    indexPaths.append(IndexPath(row: i, section: index))
                                }
                                self?.tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
                                indexPaths.removeAll()
                                for i in 1..<numRowsBefore {
                                    indexPaths.append(IndexPath(row: i, section: index))
                                }
                                self?.tableView.reloadRows(at: indexPaths as [IndexPath], with: .automatic)
                            } else {
                                self?.tableView.insertRows(at: [IndexPath(row: 1, section: index)], with: .automatic)
                            }
                        }
                    }
                }
            })
        }
        
//        let comment = PFComment(entry: entry, text: text)
//        comment.saveInBackground(block: { [weak self] (success, error) -> Void in
//            if (success) {
//                if var entryComments = self?.comments[entry] {
//                    entryComments.insert(comment, at: 0)
//                    self?.comments[entry] = entryComments
//                } else {
//                    self?.comments[entry] = [comment]
//                }
//                if self?.selectedEntry == entry {
//                    if let index = self?.entries.index(of: entry) {
//                        if ((self?.comments[entry]?.count)! > 3) {
//                            let numRowsBefore = self?.tableView.numberOfRows(inSection: index) ?? 0
//                            var indexPaths: [IndexPath] = []
//                            let numRowsAfter = 2+min(4,self?.comments[entry]?.count ?? 0)
//                            for i in numRowsBefore..<numRowsAfter {
//                                indexPaths.append(IndexPath(row: i, section: index))
//                            }
//                            self?.tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
//                            indexPaths.removeAll()
//                            for i in 1..<numRowsBefore {
//                                indexPaths.append(IndexPath(row: i, section: index))
//                            }
//                            self?.tableView.reloadRows(at: indexPaths as [IndexPath], with: .automatic)
//                        } else {
//                            self?.tableView.insertRows(at: [IndexPath(row: 1, section: index)], with: .automatic)
//                        }
//                    }
//                }
//                let activity = PFActivity(competition: nil, entry: entry, type: ActivityType.entryCommentedOn)
//                activity.saveInBackground()
//            }
//        })
    }
}

extension EntriesViewController: NewEntryViewControllerDelegate {
    
    func didSaveNewEntry(_ entry: Entry) {
        
        let alertController = TVAlertController(title: "Entry submitted!", message: "Good Luck! Would you like to share your entry?", preferredStyle: .alert)
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) -> Void in
            // Share my entry
            self.shareEntry(entry)
        }
        let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)

        loadEntries()
    }
}
