//
//  CompetitionListTableViewController.swift
//  Topvote
//
//  Copyright (c) 2018 Top, Inc. All rights reserved.
//

import UIKit
class HomePrivateViewController: CompetitionsViewController {
    
    @IBOutlet weak var competitionPollTab: UISegmentedControl!
    
    override func loadCompetitions() {
        navigationItem.title = "CREATE"

        super.loadCompetitions()
        
        if UIApplication.shared.applicationState == .background {
            return
        }
        callListData()
//        Competition.findPrivate(queryParams: ["status":"0"], error: { [weak self] (errorMessage) in
//            DispatchQueue.main.async {
//                self?.showErrorAlert(errorMessage: errorMessage)
//            }
//        }) { [weak self] (competitions) in
//            DispatchQueue.main.async {
//                self?.competitions = competitions
//                self?.tableView.reloadData()
//                self?.refreshControl.endRefreshing()
//
//            }
//        }
        
        guard let location = LocationManager.instance.locationManager.location else {
            return
        }
        
        //            PFCloud.callFunction(inBackground: "localCompetitions", withParameters: ["lat":location.coordinate.latitude,"lng":location.coordinate.longitude]) { [weak self] (result, error) in
        //            if (error == nil), let competitions = result as? [PFCompetition] {
        //                self?.localCompetitions = competitions
        //                self?.tableView.reloadData()
        //            }
        //            self?.refreshControl.endRefreshing()
        //        }
    }
    
    override func openCompetition(_ competition: Competition) {
        if(competition.sType == "poll"){
            self.performSegue(withIdentifier: "toPrivatePoll", sender: competition)
            
        }
        else if(competition.sType == "survey"){
            self.performSegue(withIdentifier: "toSurvey", sender: competition)
            
        }
        else{
            self.performSegue(withIdentifier: "toEntries", sender: competition)
        }
    }
    
    @IBAction func competitionPollTabAction(_ sender: UISegmentedControl) {
        callListData()
    }
    
    func callListData(){
      
        if(competitionPollTab.selectedSegmentIndex == 0){
            Competition.findPrivate(queryParams: ["status":"0"], error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                    self?.showErrorAlert(errorMessage: errorMessage)
                    self!.competitions.removeAll()
                    self!.tableView.reloadData()
                }
            }) { [weak self] (competitions) in
                DispatchQueue.main.async {
                    self?.competitions = competitions
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
        else
        {
            Competition.findPrivatePoll(queryParams: [:], error: { [weak self] (errorMessage) in
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
        }
    }
}

class PrivateCompetitionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PollSurveyDelegate {
    
  
    
    
    
    var competitions = Competitions()
    var localCompetitions = Competitions()
    var activityVC : UIActivityViewController?
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  navigationItem.title = "P2P"
        self.tableView.register(UINib(nibName: "CompetitionTableViewCell", bundle: nil), forCellReuseIdentifier: "competitionCell")
        self.tableView.register(UINib(nibName: "NoCompetitionILikeCell", bundle: nil), forCellReuseIdentifier: "finalCell")

        refreshControl.addTarget(self, action: #selector(PrivateCompetitionsViewController.loadCompetitions), for: UIControlEvents.valueChanged)
                
        loadCompetitions()
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.topItem?.title = ""

       // self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        //  TODO: This is not good. This is mostly being used to refresh timer labels.
        //  this should be done on the label side in the future.
        ///Timer.scheduledTimer(timeInterval: Constants.COMPETITIONS_REFRESH_TIME, target: self, selector: #selector(PrivateCompetitionsViewController.loadCompetitions), userInfo: nil, repeats: true)
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
            if (success) {
                
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func competitionSuggestionTapped(_ sender: AnyObject) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCompititionVC") as? CreateCompititionVC {
        
     self.navigationController?.pushViewController(vc, animated: true)
    
        }
    }
        
    @IBAction func pollTapped(_ sender: AnyObject) {
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCompititionVC") as? CreateCompititionVC {
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        
        
//        if let nc = storyboard?.instantiateViewController(withIdentifier: "SubmitIdeaNC") {
//            self.present(nc, animated: true, completion: nil)
//        }
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
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "competitionCell", for: indexPath) as! CompetitionTableViewCell
        if (indexPath.section == 0) {
            let competition = localCompetitions[indexPath.row]
            cell.configureWithCompetition(competition,tabbarIndex:3)
            
        } else {
            
            let competition = competitions[indexPath.row]
            cell.configureWithCompetition(competition, tabbarIndex:3)

           
            
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
        }
        else if (segue.identifier == "toEntry"), let vc = segue.destination as? EntryViewController {
            vc.entryId = (sender as! Competition).winner?._id
        }
        else if (segue.identifier == "toPrivatePoll"), let vc = segue.destination as? PollVC {
            vc.pollId = (sender as! Competition)._id!
            vc.isUserPoll = (sender as! Competition).isPrivate!
            vc.Id = (sender as! Competition)._id!
            vc.delegate = self
        }
        
        
        
    }

}
