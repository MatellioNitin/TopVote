//
//  IdeasViewController.swift
//  TopVote
//  Created by Kurt Jensen on 4/11/16.
//  Copyright © 2016 TopVote. All rights reserved.

import UIKit

class IdeasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IdeaTableViewCellDelegate {

    enum SearchType : Int {
        case new = 0
        case top
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var ideas = Ideas()
    var searchType = SearchType.new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    @IBAction func refreshAndSort(_ sender: UISegmentedControl) {
        searchType = SearchType(rawValue: sender.selectedSegmentIndex) ?? SearchType.new
        loadData()
    }
    
    func loadData() {
        Idea.find(queryParams: nil, error: { (errorMessage) in
            DispatchQueue.main.async {
                self.showErrorAlert(errorMessage: errorMessage)
            }
        }) { (ideas) in
            DispatchQueue.main.async {
                self.ideas = ideas
                self.tableView.reloadData()
            }
        }
        
//        let query = PFIdea.query()
//        query?.whereKey("isHidden", notEqualTo: true)
//        if (searchType == .new) {
//            query?.order(byDescending: "createdAt")
//        } else if (searchType == .top) {
//            query?.order(byDescending: "valueVotes")
//        }
//        query?.findObjectsInBackground(block: { (ideas, error) -> Void in
//            if (error == nil), let ideas = ideas as? [PFIdea] {
//                self.ideas = ideas
//                self.tableView.reloadData()
//            }
//        })
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaCell", for: indexPath) as! IdeaTableViewCell
        let idea = ideas[indexPath.row]
        cell.configureWithIdea(idea, delegate: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor(hex: "#F5F5F7")
        }
    }
    
    func voteIdea(_ cell: IdeaTableViewCell, idea: Idea) {
        idea.vote(numberOfVotes: 1, error: { (errorMessage) in
            DispatchQueue.main.async {
                self.showErrorAlert(errorMessage: errorMessage)
            }
        }) {
            DispatchQueue.main.async {
                cell.refreshVotes()
            }
        }
    }
}
