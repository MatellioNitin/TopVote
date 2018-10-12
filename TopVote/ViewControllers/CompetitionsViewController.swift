//
//  CompetitionListTableViewController.swift
//  Topvote
//
//  Copyright (c) 2018 Top, Inc. All rights reserved.
//

import UIKit

class HomeViewController: CompetitionsViewController {
    
    override func loadCompetitions() {
        super.loadCompetitions()
        navigationItem.title = "TOPVOTE"
        if UIApplication.shared.applicationState == .background {
              return
        }
      //  appDelegate.checkP2P_isOn()
        Competition.find(queryParams: [:], error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (competitions) in
            DispatchQueue.main.async {
                self?.competitions = competitions
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()

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
                self?.tableView.reloadData()
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
        self.performSegue(withIdentifier: "toEntry", sender: competition)
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

class CompetitionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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

        loadCompetitions()
        
//        tableView.estimatedRowHeight = 100;
//        tableView.rowHeight = UITableViewAutomaticDimension
        
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

    @IBAction func shareAction(_ sender: UIButton) {
        let competition = competitions[sender.tag]
        
        let text = competition.deepUrl!
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        
        
        
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
    
    @IBAction func competitionSuggestionTapped(_ sender: AnyObject) {
        if let nc = storyboard?.instantiateViewController(withIdentifier: "SubmitIdeaNC") {
            self.present(nc, animated: true, completion: nil)
        }
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
            cell.btnShare.tag = indexPath.row
            cell.btnShare.addTarget(self, action:#selector(self.shareAction(_:)), for: .touchUpInside)
            }
            else
            {
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

        } else if (segue.identifier == "toEntry"), let vc = segue.destination as? EntryViewController {
            vc.entryId = (sender as! Competition).winner?._id
        }
        else if (segue.identifier == "toPoll"), let vc = segue.destination as? PollVC {
            vc.pollId = (sender as! Competition)._id!
        }
        else if (segue.identifier == "toSurvey"), let vc = segue.destination as? SurveyVC {
            vc.surveyId = (sender as! Competition)._id!
        }
        
        
    }

}
