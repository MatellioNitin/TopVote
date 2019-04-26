//  ProfileViewController.swift
//  Super
//  Created by Matthew Arkin on 10/16/14.
//  Copyright (c) 2014 Super. All rights reserved.
//

import UIKit
//import Parse
//import SDWebImage

class YourProfileViewController: ProfileViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //incrementProfileVisits()

        let backButton = UIBarButtonItem(image: UIImage(named:"icon_back"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(YourProfileViewController.close))
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func refreshProfile() {
        super.refreshProfile()
    }
    
//    func incrementProfileVisits() {
////        if let userId = user?.objectId {
////            PFCloud.callFunction(inBackground: "incrementProfileViews", withParameters: ["userId": userId], block: { (object, error) -> Void in
////                //
////            })
////        }
//    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func refreshFollowButton() {
//        if let currentUser = AccountManager.session?.account, let user = user, currentUser.id != user.id {
//            if let isFollowing = user.followingAccount {
//                let followButton = UIBarButtonItem(title: isFollowing ? "Unfollow" : "Follow", style:UIBarButtonItemStyle.plain, target: self, action: #selector(YourProfileViewController.toggleFollow))
//                navigationItem.rightBarButtonItem = followButton
//            }
//        }
//    }
    
    override func followTappped() {
        super.followTappped()
        toggleFollow()
    }
    
    func toggleFollow() {

        if let user = user, let userId = user._id {
            let followingAccount = user.followingAccount ?? false
            if (!followingAccount) {
                UtilityManager.ShowHUD(text: "Please wait...")
                Account.follow(accountId: userId, error: { (errorMessage) in
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(errorMessage: errorMessage)
                }, completion: { (followedAccount) in
                    DispatchQueue.main.async {
                        self.user = followedAccount
                        self.getProfileAPI()
                        //self.refreshFollowButton()
                        self.refreshProfile()
                       // UtilityManager.RemoveHUD()

                    }
                })
            } else {
                UtilityManager.ShowHUD(text: "Please wait...")

                Account.unfollow(accountId: userId, error: { (errorMessage) in
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(errorMessage: errorMessage)
                }, completion: { (unfollowedAccount) in
                    DispatchQueue.main.async {
                        self.getProfileAPI()
                        self.user = unfollowedAccount
                        //self.refreshFollowButton()
                        self.refreshProfile()
                      //  UtilityManager.RemoveHUD()

                    }
                })
            }
        }
    }
    
}

class MyProfileViewController: ProfileViewController {
    override func viewDidLoad() {
        user = AccountManager.session?.account
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50.0;
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let editButton = UIBarButtonItem(image: UIImage(named: "Settings-100"), style: .plain, target: self, action: #selector(MyProfileViewController.editProfile))
        navigationItem.rightBarButtonItem = editButton
        
     
        let categoryButton = UIBarButtonItem(title: "Category", style: .plain, target: self, action: #selector(MyProfileViewController.categoryVC))
        navigationItem.leftBarButtonItem = categoryButton
        
    }
    
    override func refreshProfile() {
        super.refreshProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UtilityManager.ShowHUD(text: "Please wait...")

        AccountManager.session?.account?.me(error: { (errorMessage) in
            self.showErrorAlert(errorMessage: errorMessage)
        }, completion: {
            DispatchQueue.main.async {
                self.user = AccountManager.session?.account
                self.refreshProfile()
                self.tableView.reloadData()
                UtilityManager.RemoveHUD()
            }
        })
    }

    @objc func editProfile() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func categoryVC() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

enum ProfileType : Int {
    case entries = 0
    case awards
    case stats
}

struct Stat {
    var name: String
    var value: String
}

class ProfileViewController: UserEntriesViewController, HeaderViewDelegate, ProfileHeaderViewDelegate {
    
    var awardedEntries: Entries = [] {
        didSet {
            if (profileType == .awards) {
                tableView.reloadData()
            }
             getProfileAPI()
        }
        
        //.///
    }
    
    override var entries: Entries {
        didSet {
            var topTenEntries: Entries = []
            for entry in entries {
                if let rank = entry.rank {
                    if (rank > 0 && rank <= 10) {
                        topTenEntries.append(entry)
                    }
                }
            }
            awardedEntries = topTenEntries
            if (profileType == .entries) {
                tableView.reloadData()
            }
        }
        
        
        
    }

    var profileType = ProfileType.entries {
        didSet {
            tableView.reloadData()
        }
    }
    var headerView: HeaderView!
    var profileHeaderView: ProfileHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CompactEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "CompactEntryCell")
        tableView.register(UINib(nibName: "AwardedEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "AwardedEntryCell")
        tableView.register(UINib(nibName: "StatTableViewCell", bundle: nil), forCellReuseIdentifier: "StatCell")
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = #colorLiteral(red: 0.9688993096, green: 0.9659650922, blue: 0.9719695449, alpha: 1)
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9688993096, green: 0.9659650922, blue: 0.9719695449, alpha: 1)
        shouldAutoplay = false
        headerView = Bundle.main.loadNibNamed("HeaderView", owner: 0, options: nil)?[0] as! HeaderView
        headerView.delegate = self
        profileHeaderView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: 0, options: nil)?[0] as! ProfileHeaderView
        profileHeaderView.delegate = self
        tableView.setParallaxHeader(profileHeaderView, mode: .topFill, height: 306)
        
        //setParallaxHeader(profileHeaderView, mode: .fill, height: 306)
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // getProfileAPI()
         }
    
    func getProfileAPI(){
        let currentUser = AccountManager.session?.account
        //, let user = user, currentUser._id != user._id {
        if self.tabBarController?.selectedIndex != 3
        {
            UtilityManager.ShowHUD(text: "Please wait...")
            
            Account.getOtherProfile(accountId: (user?._id)!, error: { (errorMessage) in
                UtilityManager.RemoveHUD()
                
                self.showErrorAlert(errorMessage: errorMessage)
            }, completion: { [weak self] (following, followers) in
                
                
                if let followers = followers {
                    self?.user?.userFollowers = followers
                }
                if let following = following {
                    
                    self?.user?.userFollowing = following
                }
                self?.user?.followingAccount = false
                
                for dict in followers! {
                    let dict1 = dict as Account
                    if(dict1._id == currentUser?._id){
                        self?.user?.followingAccount = true
                    }
                }
                self?.refreshProfile()
                self?.tableView.reloadData()
                UtilityManager.RemoveHUD()

                }
            )
        }
        else
        {
            
            self.tableView.reloadData()
            refreshProfile()

        }
        
    }
        
//        }   else{
            
            
           
//
//        if (followers?.contains(where: { $0["followingAccount"] as? Bool == true }))! {
//            print("Exist")
//
//
////        if let dict = followers?.(where: { $0["followingAccount"] as? Bool == true }) {
////            print(dict)
//            self?.user?.followingAccount = true
//
//        }
//        else
//        {
//            self?.user?.followingAccount = false
//        }
//
//        if following.filter.contains(where: { $0["followingAccount"] as? String == value }) {
//
//            self?.user?.followingAccount = true
//        }
//        else
//        {
//           self?.user?.followingAccount = false
//        }
        
        
        //self?.refreshProfile()

       // }

                            
   
          //  if((otherAccount.userFollowers) != nil){
                //let filtered =  otherAccount.userFollowers.filter { $0.contains("lo") }
//                            completion: { (following, followers) in
//            DispatchQueue.main.async {
            
            

    //)
    //}
//        refreshProfile()
//        self.tableView.reloadData()
// }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileHeaderView.bioView.dropShadow(nil, CGSize(width: -1, height: 1), 2, 0.1, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        headerView.innerContentView.dropShadow(nil, CGSize(width: -1, height: 1), 2, 0.1, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func refreshProfile() {
        //stats.removeAll()
        
        if let user = user {

 //navigationItem.title = user.username?.uppercased()

//            stats.append(Stat(name: "Followers", value: "\(user.followers ?? 0)"))
//            stats.append(Stat(name: "Competitions Entered", value: "\(user.competitionsEntered ?? 0)"))
//            stats.append(Stat(name: "Competitions Won", value: "\(user.competitionsWon ?? 0)"))
//            stats.append(Stat(name: "Votes Received", value: "\(user.votesReceived ?? 0)"))
//            stats.append(Stat(name: "Votes Given", value: "\(user.votesGiven ?? 0)"))
//            stats.append(Stat(name: "Shares Received", value: "\(user.sharesReceived ?? 0)"))
//            stats.append(Stat(name: "Shares Given", value: "\(user.sharesGiven ?? 0)"))
//            stats.append(Stat(name: "Profile Views", value: "\(user.profileViews ?? 0)"))


            headerView.refreshView(user)
            profileHeaderView.refreshView(user)
        }
        
        self.tableView.reloadData()
    }
    
    func showFollowers() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FollowVC") as? FollowViewController {
            vc.followType = FollowViewController.FollowType.followers
            let currentUser = AccountManager.session?.account
            let user1 = user
            if  currentUser?._id != user1?._id {
                vc.userId = user1?._id
                if(user1?.userFollowers != nil){
                    vc.usersTemp = (user1?.userFollowers)!
                }
                 vc.noDataString = "Sorry there are no any following users"
                    //(self.user?.userFollowers)!
                navigationController?.pushViewController(vc, animated: true)

            }
            else{
                vc.noDataString = "Sorry, you currently have no followers"
                navigationController?.pushViewController(vc, animated: true)

            }

        }
    }
    
    func showFollowing() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FollowVC") as? FollowViewController {
            vc.followType = FollowViewController.FollowType.following
            if let currentUser = AccountManager.session?.account, let user = user, currentUser._id != user._id {
               
                vc.userId = user._id
                 if(user.userFollowing != nil){
                    vc.usersTemp = user.userFollowing!
                }
                
                vc.noDataString = "Sorry there are no any followers users"
                navigationController?.pushViewController(vc, animated: true)

                //(self.user?.userFollowing)!
            }
            
            else
            {
                vc.noDataString = "Sorry you are not currently following anyone"
                navigationController?.pushViewController(vc, animated: true)


            }
        }
        
   
    
    }

    func followTappped() {
        
    }
    
    @IBAction func categoryAction(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func typeChanged(_ type: Int) {
        self.profileType = ProfileType(rawValue: type) ?? .entries
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            return headerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return headerView?.frame.height ?? 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (profileType == .entries) {
            return entries.count
        } else if (profileType == .awards) {
            return awardedEntries.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (profileType == .entries) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompactEntryCell", for: indexPath) as! EntryTableViewCell
            let entry = entries[indexPath.row]
            print(entry)

            cell.configureWithEntry(entry, compact: true, isComeFromProfile:true,selectedTab:4)
            cell.delegate = self
            
            return cell
        } else if (profileType == .awards) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AwardedEntryCell", for: indexPath) as! AwardedEntryTableViewCell
            let entry = awardedEntries[indexPath.row]
            cell.configureWithEntry(entry)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatTableViewCell
            if let user = user {
                cell.configure(withAccount: user)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if profileType == .entries {
            if let entryCell = cell as? EntryTableViewCell {
                if (indexPath.row % 2 == 0) {
                    entryCell.innerContentView?.backgroundColor = UIColor.white
                } else {
                    entryCell.innerContentView?.backgroundColor = UIColor(hex: "#F5F5F7")
                }
            }
        }
    }
    
 
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (profileType == .stats) {
            return 244
        }
        if (profileType == .awards) {
            return 80
        }
        return UITableViewAutomaticDimension
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //var entry: PFEntry?
        var entry: Entry?
       

        if (profileType == .entries) {
            //entry = entries[indexPath.row]
        } else if (profileType == .awards) {
            entry = awardedEntries[indexPath.row]
        }
        
        if let currentUser = AccountManager.session?.account, currentUser._id == entry?.account?._id {
        if let entry = entry {
            if let giftCardURL = entry.competition?.giftCardURL {
                if let link = URL(string: giftCardURL) {
                    UIApplication.shared.open(link)
                }
            }
        }
        
        }
        
//        if let entry = entry {
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "UserCompetitionEntriesVC") as? UserCompetitionEntriesViewController {
//                //vc.user = user
//                //vc.competition = entry.competition
//                navigationController?.pushViewController(vc, animated: true)
//            }
//        }

    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
