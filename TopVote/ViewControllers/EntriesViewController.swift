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
        
        
//        if let competition = competition {
//            navigationItem.title = competition.title?.uppercased()
//            textLabel?.text = competition.text
//            if let username = AccountManager.session?.account?.username {
//
//
//                KochavaTracker.shared.sendEvent(withNameString: "Viewed Competition", infoDictionary: ["User Name": "\(username)", "Competition Name": "\(competition.text!)"])
//            }
//
//
//
//        }
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func entriesQuery(type: Int) {
        //        if let user = user {
        //            return PFEntry.entriesForUserCompetionQuery(user, competition: competition)
        //        }
    }
}


class UserEntriesViewController: EntriesViewController {
    
    var user : Account?
    
    override func entriesQuery(type: Int) {
        if let user1 = user {
            let queryParams = [
                "account": user1._id ?? "", "hideGiftURL" : "1"
                

            ]
            user1.entries(queryParams: queryParams, error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
                }, completion: { [weak self] (entries) in
                   // DispatchQueue.main.async {
                        self?.entries = entries
                        if(entries.count > 0){
                            self?.user = entries[0].account
                        }
                        //refreshProfile()
                        self?.tableView.delegate = self
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.tableView.reloadData()
                    }
                        self?.refreshControl.endRefreshing()
                  //  }
            })
        }
    }
}

class CompetitionEntriesViewController: EntriesViewController {
    
//    @IBOutlet weak var viewSound: UIView!
    var competition : Competition?
    var compID : String!

//    var player: AVPlayer?
//    var playerLayer: AVPlayerLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let competition = competition {
            navigationItem.title = competition.title?.uppercased()
            textLabel?.text = competition.text
            
            
            
            if let username = AccountManager.session?.account?.username {
                
                
                KochavaTracker.shared.sendEvent(withNameString: "Viewed Competition", infoDictionary: ["User Name": "\(username)", "Competition Name": "\(competition.title!)"])
            }
            
            
            
        }
        
        
       // textLabel?.text = competition?.text
        self.navigationController?.navigationBar.topItem?.title = ""
        
        
//        player = AVPlayer(url: URL(string:
//            "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!)
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        playerLayer?.frame = viewSound.bounds
//        do {
//            //            try  AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeMoviePlayback, options: [.mixWithOthers])
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
//            try AVAudioSession.sharedInstance().setActive(true)
//        }
//        catch {
//            // report for an error
//        }
//        player?.play()
//        textLabel?.sizeToFit()
//        self.player?.seek(to: kCMTimeZero)
//        viewSound.layer.insertSublayer(playerLayer!, at: 0)
//        viewSound.isHidden = true
        
        // textLabel?.backgroundColor = UIColor.red
        //        if(!isComeFromDeepUrl!){
        //            getCompeteStatus(id:competition?._id)
        //        }
        
    }
    
//    func addPlayer(_ url: URL) {
//
//        player = AVPlayer(url: url)
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        player?.isMuted = true
//
//        do {
//            //            try  AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeMoviePlayback, options: [.mixWithOthers])
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
//            try AVAudioSession.sharedInstance().setActive(true)
//        }
//        catch {
//            // report for an error
//        }
//
//
//    }
//
//    @IBAction func btnVolume(_ sender: Any) {
//        player?.isMuted =  !(player?.isMuted)!
//    }
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    
        if(isComeFromDeepUrl!){
            //compID = idEntry
        }
        else{
            getCompeteStatus(id:competition?._id)

        }
        
        navigationItem.title = competition?.title?.uppercased()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func getCompeteStatus(id:String!){
        UtilityManager.ShowHUD(text: "Please wait...")
        
        Entry.getCompStatus(compId:id , error: { (errorMessage) in
            UtilityManager.RemoveHUD()
            
            self.showErrorAlert(errorMessage: errorMessage)
        }) { (flag) in
            // DispatchQueue.main.async {
            UtilityManager.RemoveHUD()
//            self.navigationItem.rightBarButtonItem = nil
            
            let competeButton = UIBarButtonItem(image: UIImage(named: "competeButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CompetitionEntriesViewController.toNewEntry))
//        self.navigationItem.rightBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font :font], for: .normal)
            
           // UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
            
           // appearance().setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)

            
            self.navigationItem.rightBarButtonItem = competeButton
            
            if(!flag.participated!){

                if let competition = self.competition {

                    if (!competition.hasEnded()) {

                        self.isPopUpShow = false

                    }
                    else
                    {
                        if(!self.isPopUpShow){
                            self.isPopUpShow = false
//                            self.showErrorAlert(errorMessage: "You can no longer enter because you are  already submitted entry for this competition.")
                    }

                    }
                   
                }
//                else if(self.isComeFromDeepUrl)!
//                {
//                    let competeButton = UIBarButtonItem(title: "Compete", style:UIBarButtonItemStyle.plain, target: self, action: #selector(CompetitionEntriesViewController.toNewEntry))
//                    self.navigationItem.rightBarButtonItem = competeButton
//                }
                else
                {
                    if(self.competition == nil){
                        // comes from deep link
                        self.isPopUpShow = false

                    }
                    else
                    {
                        self.isPopUpShow = false
                    }
                       // self.showErrorAlert(errorMessage: "You can no longer enter because you are  already submitted entry for this competition.")
                  //  }
                }
            //}
            }
            else
            {
               // if(!self.isPopUpShow){
                    self.isPopUpShow = false
               // self.showErrorAlert(errorMessage: "You can no longer enter because you are  already submitted entry for this competition.")
             //   }
            }
            
            if(self.tabBarController?.selectedIndex == 2 || (self.entries.count == 1 && self.entries[0].competition?.status != 0)){
                self.isPopUpShow = false
                self.navigationItem.rightBarButtonItem = nil
            }
         
            if(self.tabBarController?.selectedIndex == 3 && self.competition != nil && self.competition?.status == 1){
//                self.isPopUpShow = false
                self.navigationItem.rightBarButtonItem = nil
            }
            
        }
    }
    
    @objc func toNewEntry() {
        print("toNewEntry1")
       
        if(self.isPopUpShow){
            
//            if let competition = self.competition {
//                if (!competition.hasEnded()) {
//                    redirectOnUploadScreen()
//                }
//                else
//                {
                    self.showErrorAlert(errorMessage: "Sorry, you have already entered this competition!")
                    
            //    }
          //  }
        }
        else
            //if(self.isComeFromDeepUrl)!
        {
            redirectOnUploadScreen()
        }
        
       
    }
    
    func redirectOnUploadScreen(){
        
        if let competition = competition {
            print("toNewEntry2")
            
            if (competition.status == 1) {
                self.showAlert(errorMessage: "The competition has ended")
            }
            else if (competition.status == -1) {
                self.showAlert(errorMessage: "The competition not started yet.")
            }
            else if (competition.status == 0)
            {
                performSegue(withIdentifier: "toNewEntry", sender: nil)

            }
//            if (!competition.hasEnded()) {
//                performSegue(withIdentifier: "toNewEntry", sender: nil)
//            } else {
//                self.showErrorAlert(errorMessage: "The competition has ended")
//            }
        }
        else
        {
            print("toNewEntry3")
            
            performSegue(withIdentifier: "toNewEntry", sender: nil)
        }
    }
    
    override func entriesQuery(type: Int) {
        //        let query = PFEntry.queryWithIncludes()
        //        query?.whereKey("competition", equalTo: competition)
  
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {

        self.isAPIRunning = true
        
        guard let competition = self.competition, let competitionId = competition._id else {
            return
        }
        var queryParams = ["":""]
//        if(self.tabBarController?.selectedIndex == 3){
//            //P2P
//            queryParams = [
//                "privateCompetition": competitionId
//            ]
//        }
//        else
//        {
            if(competition.isPrivate != 0){
                queryParams = [
                    "privateCompetition": competitionId
                ]
            }
            else
            {
                queryParams = [
                    "competition": competitionId,
                    "status": "1"
                ]
            }
       // }
        if(self.tabBarController?.selectedIndex == 2){
            //Hall Of Fame
            queryParams["sort"] = "1"
            
        }
        if(type == 1) {
            queryParams["sort"] = "1"
        }
        UtilityManager.ShowHUD(text: "Please wait...")
        
        Entry.find(queryParams: queryParams, error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (entries) in
            DispatchQueue.main.async {
                
                self?.entries = entries
                //                if(self?.tabBarController?.selectedIndex == 2 && entries.count > 1){
                //                    // Hall Of Fame
                //                    // Remove first winner entry in the list
                //                self?.entries.remove(at: 0)
                //                }
                UtilityManager.RemoveHUD()
                self?.tableView.delegate = self
                self?.isAPIRunning = false
                
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                
            }
        }
        }
   
    }
    
    override func singleEntry(entryId1:String!) {
  
            if let entryId = entryId1 {
                UtilityManager.ShowHUD(text: "Please wait...")

                Entry.getSingleEntry(entryId: entryId, error: { (errorMessage) in
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()

                        self.showErrorAlert(errorMessage: errorMessage)
                    }
                }, completion: { (entry) in
                    self.entries = [entry]
                    if(self.entries[0].competition == nil){
                        self.navigationItem.title = self.entries[0].privateCompetition?.title?.uppercased()
                        
                        self.getCompeteStatus(id:self.entries[0].privateCompetition?._id)
                        
                        self.textLabel?.text = self.entries[0].privateCompetition?.text
                        self.textHeader = self.entries[0].privateCompetition?.text
                      //  self.textLink = self.entries[0].privateCompetition?.termsLink
                        DispatchQueue.main.async {
                            
                            self.tableView.delegate = self
                            self.isAPIRunning = false
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                            
                        }
                        
                    }
                    else{
                        self.navigationItem.title = self.entries[0].competition?.title?.uppercased()
                        
                        
                        self.getCompeteStatus(id:self.entries[0].competition?._id)
                        
                        self.textLabel?.text = self.entries[0].competition?.text
                        self.textHeader = self.entries[0].competition?.text
                        self.textLink = self.entries[0].competition?.termsLink
                        DispatchQueue.main.async {
                            
                            self.tableView.delegate = self
                            self.isAPIRunning = false
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                            
                        }
                    }

                })
            }
        }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare1")
        if (segue.identifier == "toNewEntry") {
            if let vc = segue.destination as? NewEntryViewController {
                
                if(isComeFromDeepUrl)!{
                    vc.competition = entries[0].competition
                    vc.isComeFromDeepLink = isComeFromDeepUrl!
                }
                else
                {
                    if(entryUpdate != nil){
                        vc.entryUpdate = entryUpdate
                    }
                    vc.competition = competition
                }
                vc.delegate = self
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

class EntriesViewController: KeyboardScrollViewController, UITableViewDataSource, UITableViewDelegate {
    var isPopUpShow: Bool = false

    enum SearchType : Int {
        case new = 0
        case top
    }
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UILabel?
    @IBOutlet weak var textLabelHeight: NSLayoutConstraint?
    @IBOutlet weak var barViewText: UIView?
    @IBOutlet weak var heightSegmentBar: NSLayoutConstraint?


    @IBOutlet weak var segmentedControl: UISegmentedControl?
    var entryUpdate = Entry()

    var entries = Entries() {
        didSet {
            selectedEntry = nil
            comments.removeAll()
            self.tableView.delegate = self
          //  tableView.reloadData()
        }
    }
    
    var searchType = SearchType.new
    var playingCell: EntryTableViewCell?
    var comments = [Entry:[Comment]]()
    var selectedEntry: Entry?
    var textHeader: String? = ""
    var textLink: String? = ""
    var isComeFromDeepUrl: Bool? = false
    var idEntry:String = ""
    var isAPIRunning = true

    var shouldAutoplay = true
    var isVideoMuted = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = nil
        if(isComeFromDeepUrl)!{
            refreshControl.addTarget(self, action: #selector(EntriesViewController.loadSingleEntry), for: UIControlEvents.valueChanged)
        }
        else
        {
            refreshControl.addTarget(self, action: #selector(EntriesViewController.loadEntries), for: UIControlEvents.valueChanged)
        }
        print(self.navigationController?.navigationBar.titleTextAttributes!)

  
        
        
        if(self.tabBarController?.selectedIndex == 2 || isComeFromDeepUrl!){
            //Hall Of Fame
            heightSegmentBar?.constant = 0.0
            segmentedControl?.layoutIfNeeded()
        }
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        self.refreshControl.tintColor = UIColor(red:80.0/255.0, green:54.0/255.0, blue:89.0/255.0, alpha:1.0)
        
        tableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "competitionItem")
        tableView.register(UINib(nibName: "EntryTextTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryTextTableViewCell")
        
        tableView.register(UINib(nibName: "MoreCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreCommentsCell")
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.register(UINib(nibName: "AddCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "AddCommentCell")
        tableView.estimatedRowHeight = 36
        tableView.estimatedSectionHeaderHeight = 50

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension

     //   tableView.delegate = self
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let height = self.textLabel?.heightForView(text: (self.textLabel?.text)!, font: (self.textLabel?.font)!, width: (self.textLabel?.frame.width)!)
//            self.textLabelHeight?.constant = height! + 100.0
//            self.textLabel?.setNeedsUpdateConstraints()
//            self.textLabel?.layoutIfNeeded()
//            self.barViewText?.layoutIfNeeded()
//            self.barViewText?.layoutSubviews()
//            self.view.layoutSubviews()
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(isComeFromDeepUrl!){
            loadSingleEntry()
        }
        else
        {
            loadEntries()
        }
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
                cell.volumeMediaTapped()
            }
        }
    }
    
    func entriesQuery(type: Int) {
        // subclassed
    }
    
    func singleEntry(entryId1:String) {
        // subclassed
    }
    
    @objc func loadSingleEntry() {
        singleEntry(entryId1:idEntry)
    }


    
    @objc func loadEntries() {
        
        let currentSearchType = searchType
//        if let currentUser = AccountManager.session?.account, currentUser._id != user._id {
//
//
//        }
    //   else
        if (currentSearchType == .new) {
              // DispatchQueue.main.async {
                self.entriesQuery(type: 0)
           // }
            //            let query = entriesQuery()
            //            query?.order(byDescending: "createdAt")
            //            query?.findObjectsInBackground(block: { [weak self] (entries, error) -> Void in
            //                if (error == nil), let entries = entries as? [PFEntry] {
            //                    self?.entries = entries
            //                }
            //
            //            })
        } else if (currentSearchType == .top) {
             //  DispatchQueue.main.async {
                self.entriesQuery(type: 1)
           // }
            
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
  
    @IBAction func linkTapAction(_ sender: UIButton) {
        guard let url = URL(string: self.textLink!) else { return }
        UIApplication.shared.open(url)
        
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(isAPIRunning){
           return 0
        }
        else if(self.tabBarController?.selectedIndex == 2 && entries.count > 10){
            return 10 + 1
        }
        return entries.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 0
        }
        
        let entry = entries[section-1]
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
            let entry = entries[indexPath.section-1]
            if(entry.mediaType == "TEXT"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTextTableViewCell", for: indexPath) as! EntryTextTableViewCell
                
                cell.configureWithEntry(entry, compact: false)
                cell.delegate = self as EntryTextTableViewCellDelegate
                
                if(tabBarController?.selectedIndex == 2){
                    cell.voteButtonWidth?.constant = 0
                    cell.voteButtonLeading? .constant = 0
                  
                    cell.commentButton?.layoutIfNeeded()
                    cell.voteButton?.layoutIfNeeded()
                    
                    cell.voteButton?.isHidden = true
                    cell.commentButton?.isHidden = true
                }
                else if(tabBarController?.selectedIndex == 3 || tabBarController?.selectedIndex == 2){
                    // For p2p
                    cell.shareButton?.isHidden = true
                    print("shareButtn0")

                    }
                else{
                    cell.shareButton?.isHidden = false
                    print("shareButtn1")
                }
                
                if(self.entries[0].competition != nil){

                if (self.entries.count == 1 && self.entries[0].competition?.status != 0){
                    cell.voteButton?.isUserInteractionEnabled = false
                    cell.shareButton?.isHidden = true
                    cell.moreButton?.isHidden = true
                    cell.status = (self.entries[0].competition?.status)!
                    if(entry.mediaType == "TEXT"){
                        cell.textTypeLabel?.isUserInteractionEnabled = false
                    }
                }
                }
               else if(self.entries[0].privateCompetition != nil)
                {
                    if (self.entries.count == 1 && self.entries[0].privateCompetition?.status != 0){
                        cell.voteButton?.isUserInteractionEnabled = false
                        cell.shareButton?.isHidden = true
                        cell.moreButton?.isHidden = true
                        cell.status = (self.entries[0].privateCompetition?.status)!
                        if(entry.mediaType == "TEXT"){
                            cell.textTypeLabel?.isUserInteractionEnabled = false
                        }
                       
                    }
                    
                }
                
                
                return cell
                
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "competitionItem", for: indexPath) as! EntryTableViewCell
                cell.volumeButton?.isHidden = true
                if let mediaType = entry.mediaType {
                    if mediaType == "VIDEO" ||  (mediaType == "IMAGE-VIDEO" && (entry.mediaUri?.contains(".mov"))!) {
                    cell.volumeButton?.isHidden = false
                if(isVideoMuted){
                    cell.volumeButton?.setImage(UIImage(named:"soundOff"), for: .normal)
                           //isVideoMuted = false
                        }
                        else {
                        cell.volumeButton?.setImage(UIImage(named:"soundOn"), for: .normal)
                         //   isVideoMuted = true
                        }
                    }
                }
                
                NSLog("configureWithEntry\(entry)")
                NSLog("configureWithEntry\(tabBarController?.selectedIndex)")
                NSLog("configureWithEntry\(isVideoMuted)")
                var selectedIndex = 0
                if(self.tabBarController == nil){
                    selectedIndex = 1
                }
                else
                {
                     selectedIndex = (tabBarController?.selectedIndex)!

                }
                
                cell.configureWithEntry(entry, compact: false,selectedTab:selectedIndex, isVideoMuted:isVideoMuted)
                if(tabBarController?.selectedIndex == 2){
                    cell.voteButtonWidth?.constant = 0
                    cell.voteButtonLeading? .constant = 0
                    cell.voteButton?.layoutSubviews()
                    cell.voteButton?.isHidden = true
                    cell.commentWidth?.constant = 0
                    cell.commentLeading? .constant = 0
                    cell.commentButton?.layoutSubviews()
                    cell.commentButton?.isHidden = true
                  //  cell.status = 1
                }
                    
                else if(selectedIndex == 3 || selectedIndex == 2){
                    // For p2p
                    cell.shareButton?.isHidden = true
                    print("shareButtn2")

                }
                else{
                    cell.shareButton?.isHidden = false
                    print("shareButtn3")
                }
             
                if(self.isComeFromDeepUrl)!{
                    cell.shareButton?.isHidden = false
                    cell.moreButton?.isHidden = true
                    print("shareButtn4")
                }
                
                if(self.entries[0].competition != nil){
                
                    if (self.entries.count >= 1 && self.entries[0].competition?.status != 0){
                    cell.status = (self.entries[0].competition?.status)!

                    cell.voteButton?.isUserInteractionEnabled = false
                    cell.shareButton?.isHidden = true
                    cell.moreButton?.isHidden = true
                    
                    if(entry.mediaType! == "TEXT"){
                        cell.textTypeLabel?.isUserInteractionEnabled = false
                    }
                    else if entry.mediaType! == "IMAGE" {
                         cell.entryImageView?.isUserInteractionEnabled = false
                    }
                    else if entry.mediaType! == "VIDEO" || entry.mediaType! == "IMAGE-VIDEO" {
                        cell.mediaView?.isUserInteractionEnabled = false
                    }
                }
                }
                else if(self.entries[0].privateCompetition != nil)
                {
                    if (self.entries.count >= 1 && self.entries[0].privateCompetition?.status != 0){
                        cell.status = (self.entries[0].privateCompetition?.status)!
                        
                        cell.voteButton?.isUserInteractionEnabled = false
                        cell.shareButton?.isHidden = true
                        cell.moreButton?.isHidden = true
                        
                        if(entry.mediaType! == "TEXT"){
                            cell.textTypeLabel?.isUserInteractionEnabled = false
                        }
                        else if entry.mediaType! == "IMAGE" {
                            cell.entryImageView?.isUserInteractionEnabled = false
                        }
                        else if entry.mediaType! == "VIDEO" || entry.mediaType! == "IMAGE-VIDEO" {
                            cell.mediaView?.isUserInteractionEnabled = false
                        }
                    }
                    
                }
                
                
                cell.delegate = self
           
                return cell
                
            }
            
            
            
        } else {
            
            if (indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 ) {
                let entry = entries[indexPath.section - 1]
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
        let entry = entries[indexPath.section-1]
        cell.entry = entry
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            let entry = entries[indexPath.section-1]
            if(entry.mediaType == "TEXT"){
                return UITableViewAutomaticDimension
            }
          //  return UITableViewAutomaticDimension

           // return 450
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != tableView.numberOfRows(inSection: indexPath.section-1) - 1 ) {
            let entry = entries[indexPath.section-1]
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
    
  //  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if(section == 0 && self.tableView.delegate != nil){
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "TextHeaderCell")
            let textView = headerCell?.viewWithTag(5) as? UITextView
            let tapButton = headerCell?.viewWithTag(10) as? UIButton
            let lblCompleted = headerCell?.viewWithTag(6) as? UILabel
            lblCompleted?.isHidden = true
            let lblUnderLine = headerCell?.viewWithTag(11) as? UILabel

                if(self.textHeader! != ""){
                    tapButton?.alpha = 0.0
                  //  self.textLink = "https://www.google.com"
                    tapButton?.isUserInteractionEnabled = false
                    var textLink = ""
                    if(self.textLink == nil || self.textLink! == ""){
                        self.textLink = ""
                        lblUnderLine?.isHidden = true
                        textLink = self.textLink!
                        textView?.text = self.textHeader!
                    }
                    else
                    {
                        lblUnderLine?.isHidden = false
                        tapButton?.alpha = 1.0
                        tapButton?.isUserInteractionEnabled = true
                        textLink = self.textLink!
                        textView?.text = self.textHeader!
                        tapButton?.addTarget(self, action:#selector(self.linkTapAction(_:)), for: .touchUpInside)

                    }
                    
                    var myMutableString = NSMutableAttributedString()
                    myMutableString = NSMutableAttributedString(string: (textView?.text!)!)
                    var rangeStart : NSRange?
                    var rangeEnd : NSRange?
                    
                    rangeStart = ((textView?.text)! as NSString).range(of: self.textHeader!)
                    rangeEnd = ((textView?.text)! as NSString).range(of: textLink)
                    if rangeStart?.location == rangeEnd?.location {
                        rangeEnd = NSMakeRange(rangeStart!.length + 1, rangeEnd!.length)
                        
                    }
                    myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 67.0/255.0, green: 35.0/255.0, blue: 84.0/255.0, alpha: 1.0), range: rangeStart!)
                    myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue.cgColor, range: rangeEnd!)
                    myMutableString.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize: 16), range:rangeStart!)
                    myMutableString.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize: 16), range:rangeEnd!)
                    
                    textView?.attributedText = myMutableString
                    textView?.textAlignment = .center
                  //  textView?.font = UIFont.systemFont(ofSize: 16)
            }
            else
            {
                textView?.text = self.textHeader!

            }
            if(self.tabBarController?.selectedIndex == 2){
                lblCompleted?.isHidden = false

            }

            
            return headerCell
    }
        return  UIView(frame: .zero)
    
    }
    
    private func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
        return UITableViewAutomaticDimension
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == 0){
            return UITableViewAutomaticDimension
        }
        else{
            return 0
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
//        else if (segue.identifier == "toNewEntry") {
//            if let vc = segue.destination as? NewEntryViewController {
//                vc.entry = sender as? Entry
//            }
//        }
    }
}


extension EntriesViewController: EntryTableViewCellDelegate,EntryTextTableViewCellDelegate {
    func voteEntryDoubleTap(_ cell: EntryTextTableViewCell, entry: Entry, isUnVote: Bool) {
        if(isUnVote){
            UtilityManager.ShowHUD(text: "Please wait...")
            
            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    cell.refreshVotes()
                }
            })
        }
        else
        {
            
            //            let alertController = TVAlertController(title: "Vote", message: entry.subTitle, preferredStyle: .actionSheet)
            //            let voteAction = UIAlertAction(title: "Vote", style: .default, handler: { (action) -> Void in
            UtilityManager.ShowHUD(text: "Please wait...")
            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    cell.refreshVotes()
                }
            })
            
            //            let sVoteAction = UIAlertAction(title: "Topvote (worth 2 votes)", style: .default, handler: { (action) -> Void in
            //                entry.vote(numberOfVotes: 2, error: { (errorMessage) in
            //                    DispatchQueue.main.async {
            //                        self.showErrorAlert(errorMessage: errorMessage)
            //                    }
            //                }, completion: {
            //                    DispatchQueue.main.async {
            //                        cell.refreshVotes()
            //                    }
            //                })
            //            })
            //            alertController.addAction(voteAction)
            //            alertController.addAction(sVoteAction)
            //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            //                cell.refreshVotes()
            //            })
            //            alertController.addAction(cancelAction)
            //            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func voteEntryDoubleTap(_ cell: EntryTableViewCell, entry: Entry, isUnVote: Bool) {
        if(isUnVote){
            UtilityManager.ShowHUD(text: "Please wait...")
            
            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    cell.refreshVotes()
                }
            })
        }
        else
        {
            
            //            let alertController = TVAlertController(title: "Vote", message: entry.subTitle, preferredStyle: .actionSheet)
            //            let voteAction = UIAlertAction(title: "Vote", style: .default, handler: { (action) -> Void in
            UtilityManager.ShowHUD(text: "Please wait...")
            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    cell.refreshVotes()
                }
            })
            
            //            let sVoteAction = UIAlertAction(title: "Topvote (worth 2 votes)", style: .default, handler: { (action) -> Void in
            //                entry.vote(numberOfVotes: 2, error: { (errorMessage) in
            //                    DispatchQueue.main.async {
            //                        self.showErrorAlert(errorMessage: errorMessage)
            //                    }
            //                }, completion: {
            //                    DispatchQueue.main.async {
            //                        cell.refreshVotes()
            //                    }
            //                })
            //            })
            //            alertController.addAction(voteAction)
            //            alertController.addAction(sVoteAction)
            //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            //                cell.refreshVotes()
            //            })
            //            alertController.addAction(cancelAction)
            //            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    func voteEntry(_ cell: EntryTextTableViewCell, entry: Entry, isUnVote:Bool) {
        
        if(isUnVote){
            UtilityManager.ShowHUD(text: "Please wait...")

            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()

                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()

                    cell.refreshVotes()
                }
            })
        }
        else
        {
            
        let alertController = TVAlertController(title: "Vote", message: entry.subTitle, preferredStyle: .actionSheet)
        let voteAction = UIAlertAction(title: "Vote", style: .default, handler: { (action) -> Void in
            UtilityManager.ShowHUD(text: "Please wait...")
            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()

                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()

                    cell.refreshVotes()
                }
            })
        })
        let sVoteAction = UIAlertAction(title: "Topvote (worth 2 votes)", style: .default, handler: { (action) -> Void in
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
}
   
//    func voteEntryDoubleTap(_ cell: EntryTextTableViewCell, entry: Entry, isUnVote:Bool) {
//        
//   
//    }
    
    
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
    
    func volumeMedia(_ cell: EntryTableViewCell) {
        cell.toggleVolume()
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
                let numRows = tableView.numberOfRows(inSection: index+1)
                var indexPaths = [IndexPath]()
                for i in 1..<numRows {
                    indexPaths.append(IndexPath(row: i, section: index+1))
                }
                tableView.deleteRows(at: indexPaths, with: .automatic)
            }
            
            var shouldFetch = true
            if let index = entries.index(of: entry) {
                // prep for initial row insert
                let numRowsBefore = tableView.numberOfRows(inSection: index+1)
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
                    indexPaths.append(IndexPath(row: i, section: index+1))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
            if (shouldFetch) {
                // fetch comments if not already fetched.
                UtilityManager.ShowHUD(text: "Please wait...")

                if let entryId = entry._id {
                    Account.comments(entryId: entryId, queryParams: nil, error: { (errorMessage) in
                        
                    }, completion: { [weak self] (comments) in
                        DispatchQueue.main.async {
                            if (self?.selectedEntry == entry) {
                                if let index = self?.entries.index(of: entry) {
                                    let numRowsBefore = self?.tableView.numberOfRows(inSection: index+1) ?? 0
                                    self?.comments[entry] = comments
                                    var indexPaths: [IndexPath] = []
                                    let numRowsAfter = 2+min(4,comments.count)
                                    for i in numRowsBefore..<numRowsAfter {
                                        indexPaths.append(IndexPath(row: i, section: index+1))
                                    }
                                    self?.tableView.insertRows(at: indexPaths, with: .automatic)
                                    if (comments.count > 0) {
                                        // reload the first row (comment input) since it is now a comment
                                        self?.tableView.reloadRows(at: [IndexPath(row: 1, section: index+1)], with: .automatic)
                                    }
                                }
                            }
                        }
                    })
                    UtilityManager.RemoveHUD()

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
    
    func voteEntry(_ cell: EntryTableViewCell, entry: Entry, isUnVote:Bool) {
        
        if(isUnVote){
            UtilityManager.ShowHUD(text: "Please wait...")

            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    
                    UtilityManager.RemoveHUD()

                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                   
                    UtilityManager.RemoveHUD()

                    cell.refreshVotes()
                }
            })
        }
        else
        {

        let alertController = TVAlertController(title: "Vote", message: entry.subTitle, preferredStyle: .actionSheet)
        let voteAction = UIAlertAction(title: "Vote", style: .default, handler: { (action) -> Void in
            UtilityManager.ShowHUD(text: "Please wait...")
            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()

                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    
                    if let username = AccountManager.session?.account?.username {
                        KochavaTracker.shared.sendEvent(withNameString: "Voted in competition", infoDictionary: ["User Name": "\(username)", "Competition Name": "\(entry.title!)"])
                    }
                    
                    cell.refreshVotes()
                }
            })
        })
        let sVoteAction = UIAlertAction(title: "Topvote (worth 2 votes)", style: .default, handler: { (action) -> Void in
            UtilityManager.ShowHUD(text: "Please wait...")

            entry.vote(numberOfVotes: 2, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()

                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    if let username = AccountManager.session?.account?.username {
                        KochavaTracker.shared.sendEvent(withNameString: "Voted in competition", infoDictionary: ["User Name": "\(username)", "Competition Name": "\(entry.title!)"])
                    }
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
    }
   
    func shareEntry(_ entry: Entry) {
        guard let url = entry.deepUrl else {
            return
        }
       
        
        if let username = AccountManager.session?.account?.username {
            KochavaTracker.shared.sendEvent(withNameString: "Competition Shared", infoDictionary: ["User Name": "\(username)", "Competition Name": "\(entry.title!)"])
        }
        
        var textToShare = ""
        if(entry.competition?.shareText == nil || entry.competition?.shareText == ""){
            textToShare = ""
        }
        else
        {
            textToShare = (entry.competition?.shareText)!
        }
        
     
        
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
            let editAction = UIAlertAction(title: "Edit", style: .destructive) { (action) -> Void in
                self.entryUpdate = entry
                self.performSegue(withIdentifier: "toNewEntry", sender: nil)
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
                self.destroyEntry(entry)
            }
            
            alertController.addAction(editAction)
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
    
    func editEntry(_ entry: Entry) {
        performSegue(withIdentifier: "toNewEntry", sender: nil)
    }
    
    func destroyEntry(_ entry: Entry) {
        let alertController = TVAlertController(title: "Are you sure?", message: "This cannot be undone.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) -> Void in
            UtilityManager.ShowHUD(text: "Please wait...")

            entry.delete(error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
                }, completion: {
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()
                        self?.isPopUpShow = false
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
                "text": text ]
            
            UtilityManager.ShowHUD(text: "Please wait...")
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
                                let numRowsBefore = self?.tableView.numberOfRows(inSection: index+1) ?? 0
                                var indexPaths: [IndexPath] = []
                                let numRowsAfter = 2+min(4,self?.comments[entry]?.count ?? 0)
                                for i in numRowsBefore..<numRowsAfter {
                                    indexPaths.append(IndexPath(row: i, section: index+1))
                                }
                                self?.tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
                                indexPaths.removeAll()
                                for i in 1..<numRowsBefore {
                                    indexPaths.append(IndexPath(row: i, section: index+1))
                                }
                                self?.tableView.reloadRows(at: indexPaths as [IndexPath], with: .automatic)
                            } else {
                                self?.tableView.insertRows(at: [IndexPath(row: 1, section: index+1)], with: .automatic)
                            }
                        }
                    }
                    UtilityManager.RemoveHUD()

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
        //        let competeButton = UIBarButtonItem(title: "Compete", style:UIBarButtonItemStyle.plain, target: self, action: #selector(CompetitionEntriesViewController.toNewEntry))
        self.isPopUpShow = true
        self.isComeFromDeepUrl = false
     //   refreshControl.removeTarget(self, action: #selector(EntriesViewController.loadSingleEntry), for: UIControlEvents.valueChanged)
        
        refreshControl.addTarget(self, action: #selector(EntriesViewController.loadEntries), for: UIControlEvents.valueChanged)
        searchType = .new
        
        
       // self.navigationItem.rightBarButtonItem = nil
        let alertController = TVAlertController(title: "Entry submitted!", message: "Good Luck! Would you like to share your entry?", preferredStyle: .alert)
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) -> Void in
            // Share my entry
            
            print("share your entry \(entry)")
            self.shareEntry(entry)
        }
        let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        //loadEntries()
    }
}

