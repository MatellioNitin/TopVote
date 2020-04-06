//
//  CompetitionListTableViewController.swift
//  Topvote
//
//  Copyright (c) 2018 Top, Inc. All rights reserved.

import UIKit

class HomeViewController: CompetitionsViewController, UITabBarControllerDelegate {
    
    
    override func loadCompetitions() {
        super.loadCompetitions()
        navigationItem.title = "TOPVOTE"
        if UIApplication.shared.applicationState == .background {
              return
        }
        appDelegate.checkP2P_isOn()
        Competition.find(queryParams: [:], error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (competitions) in
            DispatchQueue.main.async {
                self?.competitions = competitions
               // DispatchQueue.main.async {
                    self?.tableView.reloadData()
               // }
                self?.refreshControl.endRefreshing()
                self?.tabBarController!.delegate = self

                

            }
        }
        
        guard let location = LocationManager.instance.locationManager.location else {
            return
        }

//            PFCloud.callFunction(inBackground: "localCompetitions", withParameters: ["lat":location.coordinate.latitude,"lng":location.coordinate.longitude]) { [weak self] (result, error) in
//            if (error == nil), let competitions = result as? [PFCompetition] {
//                self?.localCompetitions = competitions
//                self?.tableView.reloadData()
//            }
        self.refreshControl.endRefreshing()
//        }
    }
    
    
    override func openCompetition(_ competition: Competition) {
        if(competition.sType == "poll"){
            self.performSegue(withIdentifier: "toPoll", sender: competition)

        }
        else if(competition.sType == "survey"){
            self.performSegue(withIdentifier: "toSurvey", sender: competition)

        }
        else{
            
        self.performSegue(withIdentifier: "toEntries", sender: competition)
        }
    }
    
    // MARK: - TabBar Deligate
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            // Code for item 1
        } else if(item.tag == 2) {
            // Code for item 2
        }
    }
    
    func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]){
        
    
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(self.tabBarController?.selectedIndex == 0 && self.competitions.count > 0){
            let indexPath = IndexPath(row: 0, section: 1)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        print("Selected view controller")
    }
}

class HallOfFameViewController: CompetitionsViewController {
    
    override func loadCompetitions() {

        super.loadCompetitions()

        if UIApplication.shared.applicationState == .background {
            return
        }
            //["status": 1]
        Competition.findHall(queryParams: [:], error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (competitions) in
            DispatchQueue.main.async {
                self?.competitions = competitions
                //DispatchQueue.main.async {
                    self?.tableView.reloadData()
             //   }
                self?.refreshControl.endRefreshing()

            }
        }
        
//        let query = PFCompetition.hallOfFameQuery()
//        query?.findObjectsInBackground { [weak self] (competitions, error) -> Void in
//            if (error == nil), let competitions = competitions as? [PFCompetition] {
//                self?.competitions = competitions
//                self?.tableView.reloadData()
//            }
//            self?.refreshControl.endRefreshing()
//        }
    }
    
    override func openCompetition(_ competition: Competition) {
     //   self.performSegue(withIdentifier: "toEntry", sender: competition)
        self.performSegue(withIdentifier: "toEntries", sender: competition)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "HALL OF FAME"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = ""
    }

}

class CompetitionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PollSurveyDelegate{
        
    var competitions = Competitions()
    var localCompetitions = Competitions()
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var activityVC : UIActivityViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "CompetitionTableViewCell", bundle: nil), forCellReuseIdentifier: "competitionCell")
        self.tableView.register(UINib(nibName: "NoCompetitionILikeCell", bundle: nil), forCellReuseIdentifier: "finalCell")

        refreshControl.addTarget(self, action: #selector(CompetitionsViewController.loadCompetitions), for: UIControlEvents.valueChanged)
        
        self.refreshControl.tintColor = UIColor(red:80.0/255.0, green:54.0/255.0, blue:89.0/255.0, alpha:1.0)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }

       // loadCompetitions()
        
//        tableView.estimatedRowHeight = 100;
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 200;
        self.tableView.estimatedSectionHeaderHeight = 200;
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.topItem?.title = ""

        //  TODO: This is not good. This is mostly being used to refresh timer labels.
        //  this should be done on the label side in the future.
        //Timer.scheduledTimer(timeInterval: Constants.COMPETITIONS_REFRESH_TIME, target: self, selector: #selector(CompetitionsViewController.loadCompetitions), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        loadCompetitions()
    }
    
    deinit {
        // Timer.invalidate()
    }
    
    @objc func loadCompetitions() {
    }

    
  
    @IBAction func editAction(_ sender: UIButton) {
        if(competitions.count > 0){
            if(competitions[sender.tag].sType != "poll"){
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCompititionVC") as? CreateCompititionVC {
                    let competition = competitions[sender.tag]
                    vc.compititionObj = competition
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func shareHOFAction(_ sender: UIButton) {
        if(competitions.count > 0){
            let indexpath = IndexPath(row: sender.tag, section: 1)
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareHOFVC") as? ShareHOFVC {
                    vc.imageShareShow = tableView.snapshotRows(at: [indexpath])!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
        }
    }
    
    
    @IBAction func editPollAction(_ sender: UIButton) {
        if(competitions[sender.tag].sType == "poll"){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePollVC") as? CreatePollVC {
            let competition = competitions[sender.tag]
            vc.objComp = competition
            self.navigationController?.pushViewController(vc, animated: true)
        }
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let competition = competitions[sender.tag]
        
      // let shareText = competition.shareText!
        let shareText = ""
        if(competition.deepUrl != nil){
        let text = competition.deepUrl!
        let textShare = [ shareText, text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        }
        
        
        
//        activityVC = UIActivityViewController(
//            activityItems: [competition.deepUrl!],
//            applicationActivities: nil)
//
//        activityVC?.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
//            if !completed {
//                // User canceled
//                return
//            }
//            //  print(activityType)
//            self.present(self.activityVC!, animated: true, completion: nil)
//        }
    }
    @IBAction func btnRulesAction(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC {
            vc.isLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func competitionSuggestionTapped(_ sender: AnyObject) {
        if(self.tabBarController?.selectedIndex == 3 ){
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCompititionVC") as? CreateCompititionVC {
            self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        else{
        if let nc = storyboard?.instantiateViewController(withIdentifier: "SubmitIdeaNC") {
            self.present(nc, animated: true, completion: nil)
        }
        }
    }
    
    @IBAction func pollTapped(_ sender: AnyObject){
        if(self.tabBarController?.selectedIndex == 3 ){
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePollVC") as? CreatePollVC {
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        
    }
    
    
    
   
    func didSavePollSurvey(text: String, link: String, pollOrSurvey:String) {
        
        //self.navigationItem.rightBarButtonItem = nil
        let alertController = TVAlertController(title: "\(pollOrSurvey) submitted!", message: "Good Luck! Would you like to share \(pollOrSurvey)?", preferredStyle: .alert)
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) -> Void in
            // Share my entry
            self.sharePollSurvey(text: text, url: link)
        }
        let cancelAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        // loadEntries()
    }
    
    
    
    func sharePollSurvey(text:String, url:String) {
        let textToShare = "\(text)"
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
    
    
 
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return localCompetitions.count
        } else {
            return competitions.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(self.tabBarController?.selectedIndex == 2 && competitions[indexPath.row].winner?.mediaType == "TEXT"){
            let str = competitions[indexPath.row].winner?.text
            
            let font = UIFont.systemFont(ofSize: 15.0)
            
            let height = self.view.heightForView(text: str!, font: font, width: self.view.frame.width - 30)
           
            if(height < 30){
                return  180
            }
            else
            {
                return  height + 70
            }

        }
        return UITableViewAutomaticDimension
        return 280
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.tabBarController?.selectedIndex == 2 && competitions[indexPath.row].winner?.mediaType == "TEXT"){
            let str = competitions[indexPath.row].winner?.text
            
            let font = UIFont.systemFont(ofSize: 15.0)

            let height = self.view.heightForView(text: str!, font: font, width: self.view.frame.width - 30)
            
            if(height < 30){
                return  180
            }
            else
            {
                return  height + 70
            }

         
           // return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension

        return 280
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if(self.tabBarController?.selectedIndex == 2 && competitions[indexPath.row].winner?.mediaType == "IMAGE"){
//
//
//        }
//        return 280
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "competitionCell", for: indexPath) as! CompetitionTableViewCell
        if (indexPath.section == 0) {
            let competition = localCompetitions[indexPath.row]
            cell.configureWithCompetition(competition, tabbarIndex:(self.tabBarController?.selectedIndex)!)
        } else {
            let competition = competitions[indexPath.row]
            cell.configureWithCompetition(competition, tabbarIndex:(self.tabBarController?.selectedIndex)!)
            if(self.tabBarController?.selectedIndex == 3 && AccountManager.session!.account!._id! == competition.ownerId){
            cell.btnShare.isHidden = false
                
            cell.btnEdit.isHidden = false
            cell.btnShare.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            if(competition.isPrivate != 1){
                    cell.btnShare.isHidden = true
            }
            else if(competition.isPrivate == 1 && competition.status == 1){
                            cell.btnShare.isHidden = true
                            cell.btnEdit.isHidden = true
                            cell.timeView.isHidden = true
                            cell.timeRemainingLabel.isHidden = true

            }
            cell.btnShare.addTarget(self, action:#selector(self.shareAction(_:)), for: .touchUpInside)
            if(competition.sType == "poll"){
                cell.btnEdit.addTarget(self, action:#selector(self.editPollAction(_:)), for: .touchUpInside)
            }
            else
            {
                cell.btnEdit.addTarget(self, action:#selector(self.editAction(_:)), for: .touchUpInside)
            }
            cell.lblTitleTrailing.constant = 90
            cell.titleLabel.layoutIfNeeded()
                
            }
            else
            {
                cell.lblTitleTrailing.constant = 10
                cell.titleLabel.layoutIfNeeded()

                cell.btnEdit.isHidden = true
                cell.btnShare.isHidden = true
            }
            
            if((self.tabBarController?.selectedIndex)!  == 2){
                cell.btnShareBottom.addTarget(self, action:#selector(self.shareHOFAction(_:)), for: .touchUpInside)
                cell.btnShareBottom.tag = indexPath.row
            }
            
            if((self.tabBarController?.selectedIndex)! == 0 && competition.deepUrl != nil && competition.deepUrl != ""){
                cell.btnShare.isHidden = false
                cell.btnShare.tag = indexPath.row
                cell.btnShare.addTarget(self, action:#selector(self.shareAction(_:)), for: .touchUpInside)
                cell.lblTitleBottom.constant = 65
                cell.lblTitleTrailing.constant = 40
                cell.titleLabel.layoutIfNeeded()


                
            }
            else{
                
            if(!cell.btnEdit.isHidden){
                cell.lblTitleTrailing.constant = 90
                cell.titleLabel.layoutIfNeeded()
                }
            else
            {
                cell.lblTitleTrailing.constant = 10
                cell.titleLabel.layoutIfNeeded()
            }
                cell.lblTitleBottom.constant = 60
                cell.btnShare.isHidden = true
                
               
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            let competition = localCompetitions[indexPath.row]
            openCompetition(competition)
        } else {
            let competition = competitions[indexPath.row]
            openCompetition(competition)
        }
    }
    
    func openCompetition(_ competition: Competition) {
        // subclassed
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEntries"), let vc = segue.destination as? CompetitionEntriesViewController {
            vc.competition = sender as? Competition
            vc.textHeader = (sender as? Competition)?.text
            vc.textLink = (sender as? Competition)?.termsLink


        } else if (segue.identifier == "toEntry"), let vc = segue.destination as? EntryViewController {
            vc.entryId = (sender as! Competition).winner?._id
        }
        else if (segue.identifier == "toPoll"), let vc = segue.destination as? PollVC {
            vc.pollId = (sender as! Competition)._id!
            vc.Id = (sender as! Competition)._id!
            vc.isUserPoll = 0
            vc.delegate = self
        }
        else if (segue.identifier == "toPrivatePoll"), let vc = segue.destination as? PollVC {
            vc.pollId = (sender as! Competition)._id!
            vc.isUserPoll = (sender as! Competition).isPrivate!
            vc.Id = (sender as! Competition)._id!
            vc.delegate = self
        }
            
        else if (segue.identifier == "toSurvey"), let vc = segue.destination as? SurveyVC {
            vc.surveyId = (sender as! Competition)._id!
            vc.delegate = self

        }
        
        
    }

}
