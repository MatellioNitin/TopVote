//
//  FollowViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 4/11/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController {

    enum FollowType : Int {
        case followers = 0
        case following
    }
    
    @IBOutlet weak var tableView: UITableView!

    var followType : FollowType = .followers
    var user: Account!
    var users = Accounts() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "UserFollowTableViewCell", bundle: nil), forCellReuseIdentifier: "UserFollowCell")

        navigationItem.title = followType == .followers ? "Followers" : "Following"

        fetchUsersIfNeeded()
    }
    
    func fetchUsersIfNeeded() {
        if (users.count == 0) {
            Account.follows(error: { (errorMessage) in
                
            }) { [weak self] (following, followers) in
                if (self?.followType == .followers) {
                    if let followers = followers {
                        self?.users = followers
                    }
                } else {
                    if let following = following {
                        self?.users = following
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
//                if let user = user, let followerIds = user.followerIds, followerIds.count > 0 {
//                    let query = PFVoter.usersForIdsQuery(followerIds)
//                    query?.findObjectsInBackground(block: { [weak self] (users, error) -> Void in
//                        if let users = users as? [PFVoter] {
//                            self?.users = users
//                        }
//                    })
//                }
//            } else {
//                if let user = user, let followingIds = user.followingIds, followingIds.count > 0 {
//                    let query = PFVoter.usersForIdsQuery(followingIds)
//                    query?.findObjectsInBackground(block: { [weak self] (users, error) -> Void in
//                        if let users = users as? [PFVoter] {
//                            self?.users = users
//                        }
//                    })
//                }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension FollowViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFollowCell", for: indexPath) as! UserFollowTableViewCell
        let user = users[indexPath.row]
        cell.configureWithUser(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        if let nc = storyboard?.instantiateViewController(withIdentifier: "YourProfileNC") as? UINavigationController {
            if let vc = nc.childViewControllers.first as? YourProfileViewController {
                vc.user = user
                self.present(nc, animated: true, completion: nil)
            }
        }
    }
    
}
