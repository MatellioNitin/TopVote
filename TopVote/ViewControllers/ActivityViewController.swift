//
//  ActivityViewController.swift
//  Super
//
//  Created by Matthew Arkin on 12/24/14.
//  Copyright (c) 2014 Super. All rights reserved.
//

import UIKit
import MediaPlayer
//import Parse
//import FPPicker

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    enum SearchType : Int {
        case following = 0
        case mine
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedButtonSorter: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!

    var followingActivities = Activities()
    var myActivities = Activities()
    var filteredActivities = Activities()
    var searchType = SearchType.following

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
        
        tableView.estimatedRowHeight = 61
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor(patternImage: UIImage(named: "horizontal-divide-activity")!)
        tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadParseData(true)
    }

    @IBAction func refreshAndSort(_ sender: UISegmentedControl) {
        searchType = SearchType(rawValue: sender.selectedSegmentIndex) ?? SearchType.following
        loadParseData(false)
    }
    
    @IBAction func searchTapped(_ sender: AnyObject) {
        if (searchTextField.isFirstResponder) {
            searchTextField.resignFirstResponder()
        } else {
            searchTextField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loadParseData(_ forceLoad: Bool) {
        if (searchType == .following) {
            if (forceLoad || followingActivities.count == 0) {
                UtilityManager.ShowHUD(text: "Please wait...")

                AccountManager.session?.account?.followingActivities(error: { (errorMessage) in
                    UtilityManager.RemoveHUD()

                    
                }, completion: { [weak self] (activities) in
                    self?.followingActivities = activities
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()
                        self?.filter()
                    }
                })
//                let query = PFActivity.queryFollowingActions()
//                query?.findObjectsInBackground(block: { (activities, error) -> Void in
//                    if (error == nil), let activities = activities as? [PFActivity] {
//                        self.followingActivities = activities
//                        self.filter()
//                    }
//                })
            } else {
                filter()
            }

        } else if (searchType == .mine) {
            if (forceLoad || myActivities.count == 0) {
                UtilityManager.ShowHUD(text: "Please wait...")

                AccountManager.session?.account?.activities(error: { (errorMessage) in
                    UtilityManager.RemoveHUD()

                    
                }, completion: { [weak self] (activities) in
                    self?.myActivities = activities
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()

                        self?.filter()
                    }
                })
                
//                let query = PFActivity.queryMyActions()
//                query?.findObjectsInBackground(block: { (activities, error) -> Void in
//                    if (error == nil), let activities = activities as? [PFActivity] {
//                        self.myActivities = activities
//                        self.filter()
//                    }
//                })
            } else {
                filter()
            }
        }
    }
    
    @IBAction func searchTextFieldChanged(_ sender: AnyObject) {
        filter()
    }
    
    func filter() {
        if let text = searchTextField.text?.lowercased(), searchTextField.isHidden == false && text.count > 0 {
            switch (searchType) {
            case .following:
                filteredActivities = followingActivities.filter({ (activity) -> Bool in
                    let userName = activity.account?.username?.lowercased().contains(text) ?? activity.account?.name?.contains(text) ?? false
                    let entryUserName = activity.entry?.account?.username?.lowercased().contains(text) ?? activity.account?.name?.contains(text) ?? false
                    let competitionName = activity.entry?.competition?.title?.lowercased().contains(text) ?? false
                    return (userName || entryUserName || competitionName)
                })
                break
            case .mine:
                filteredActivities = myActivities.filter({ (activity) -> Bool in
                    let userName = activity.account?.username?.lowercased().contains(text) ?? activity.account?.name?.contains(text) ?? false
                    let entryUserName = activity.entry?.account?.username?.lowercased().contains(text) ?? activity.account?.name?.contains(text) ?? false
                    let competitionName = activity.entry?.competition?.title?.lowercased().contains(text) ?? false
                    return (userName || entryUserName || competitionName)
                })
                break
            }
        } else {
            switch (searchType) {
            case .following:
                filteredActivities = followingActivities
                break
            case .mine:
                filteredActivities = myActivities
                break
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredActivities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
        let activity = filteredActivities[indexPath.row]
        cell.configureWithActivity(activity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activity = filteredActivities[indexPath.row]
        if let nc = storyboard?.instantiateViewController(withIdentifier: "YourProfileNC") as? UINavigationController {
            if let vc = nc.childViewControllers.first as? YourProfileViewController {
                vc.user = activity.account
                self.present(nc, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
