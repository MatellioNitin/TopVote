//
//  CompetitionListTableViewController.swift
//  Topvote
//
//  Copyright (c) 2018 Top, Inc. All rights reserved.
//

import UIKit
class HomePrivateViewController: CompetitionsViewController {
    
    override func loadCompetitions() {
        super.loadCompetitions()
        
        if UIApplication.shared.applicationState == .background {
            return
        }
    
        Competition.findPrivate(accountId:(AccountManager.session?.account?._id)!, error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (competitions) in
            DispatchQueue.main.async {
                self?.competitions = competitions
                self?.tableView.reloadData()
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
        //            self?.refreshControl.endRefreshing()
        //        }
    }
    
    override func openCompetition(_ competition: Competition) {
        self.performSegue(withIdentifier: "toEntries", sender: competition)
    }
}

class PrivateCompetitionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var competitions = Competitions()
    var localCompetitions = Competitions()
    var activityVC : UIActivityViewController?
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CompetitionTableViewCell", bundle: nil), forCellReuseIdentifier: "competitionCell")
        self.tableView.register(UINib(nibName: "NoCompetitionILikeCell", bundle: nil), forCellReuseIdentifier: "finalCell")

        refreshControl.addTarget(self, action: #selector(PrivateCompetitionsViewController.loadCompetitions), for: UIControlEvents.valueChanged)

        loadCompetitions()
        
        self.navigationItem.hidesBackButton = true

        //  TODO: This is not good. This is mostly being used to refresh timer labels.
        //  this should be done on the label side in the future.
        Timer.scheduledTimer(timeInterval: Constants.COMPETITIONS_REFRESH_TIME, target: self, selector: #selector(PrivateCompetitionsViewController.loadCompetitions), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCompetitions()
    }
    
    @objc func loadCompetitions() {
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
        return 280
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
        } else if (segue.identifier == "toEntry"), let vc = segue.destination as? EntryViewController {
            vc.entryId = (sender as! Competition).winner?._id
        }
    }

}
