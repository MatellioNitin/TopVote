//  CategoryVC.swift
//  Topvote
//  Created by CGT on 24/08/18.
//  Copyright © 2018 Top, Inc. All rights reserved.

import UIKit

protocol PollSurveyDelegate {
    func didSavePollSurvey(text: String, link: String, pollOrSurvey:String)
}

class PollVC: UIViewController, PollCellDelegate {

    @IBOutlet weak var tblPoll: UITableView!

    var objPoll = Poll()
    var savedPoll = NSMutableArray()
    var isDeepLinkClick:Bool = false
    var selectId:String = ""
    var unSelectId:String = ""
    var pollId = ""
    var delegate: PollSurveyDelegate?
    var isVideoMuted = true

    override func viewDidLoad() {
        super.viewDidLoad()

      //  navigationItem.title = "POLL"
       // self.navigationController?.navigationBar.topItem?.title = ""

        self.tblPoll.estimatedRowHeight = 100;
//        self.tblPoll.rowHeight = UITableViewAutomaticDimension
        tblPoll.rowHeight = UITableViewAutomaticDimension

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "POLL"

        if(isDeepLinkClick){
            getPollDataForDeeplink()
        }
        else{
            getPollData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false

    }

    func getPollDataForDeeplink(){

        UtilityManager.ShowHUD(text: "Please wait...")

        if UIApplication.shared.applicationState == .background {
            return
        }
        self.navigationItem.rightBarButtonItem = nil

        Poll.getPollDeepLink(pollID: pollId, error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {

                UtilityManager.RemoveHUD()
                self?.navigationController?.popViewController(animated: true)
                self?.showErrorAlert(errorMessage: errorMessage)

            }
        }) { [weak self] (polls) in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                self?.objPoll = polls

                if(self?.objPoll.selected != ""){
                    self?.selectId = (self?.objPoll.selected)!

                    if(!(self?.isDeepLinkClick)!){
//                        let button1 = UIBarButtonItem(image: UIImage(named: "shareOnNav"), style: .plain, target: self, action:#selector(self?.shareClick))
//                        self?.navigationItem.rightBarButtonItem  = button1
                    }
                }
                print("get Poll success")
                self?.tblPoll.reloadData()
            }
        }
    }

    func getPollData(){

            UtilityManager.ShowHUD(text: "Please wait...")
        self.navigationItem.rightBarButtonItem = nil

            if UIApplication.shared.applicationState == .background {
                return
            }
                Poll.getPoll(pollID: pollId, error: { [weak self] (errorMessage) in
                    DispatchQueue.main.async {

                        UtilityManager.RemoveHUD()
                    self?.navigationController?.popViewController(animated: true)
                        self?.showErrorAlert(errorMessage: errorMessage)

                    }
                }) { [weak self] (polls) in
                    DispatchQueue.main.async {
                        print(polls)

                        UtilityManager.RemoveHUD()
                        self?.objPoll = polls
                        self?.navigationItem.title = polls.title

                        if(self?.objPoll.selected != ""){
                            self?.selectId = (self?.objPoll.selected)!

                            if(!(self?.isDeepLinkClick)!){
                            let button1 = UIBarButtonItem(image: UIImage(named: "shareOnNav"), style: .plain, target: self, action:#selector(self?.shareClick))
                            self?.navigationItem.rightBarButtonItem  = button1
                                
                            }
                        }
                        print("get Poll success")
                        self?.tblPoll.reloadData()
                }
            }
        }

    @objc func shareClick(){

        guard let url = self.objPoll.deepUrl else {
            return
        }
        var textToShare = ""
        if(self.objPoll.shareText == ""){
            textToShare = "Sharing text demo for Poll"
        }
        else{
            textToShare = self.objPoll.shareText!
        }

        let objectsToShare = [textToShare, url] as [Any]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            //print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            if (success) {
                activityViewController.navigationController?.navigationBar.tintColor = Constants.appYellowColor

            }
        }

        present(activityViewController, animated: true, completion: nil)
    }

    func submitAPI()  {

        UtilityManager.ShowHUD(text: "Please wait...")
        var params = [String: Any]()
        params["poll"] = objPoll._id
        params["option"] = selectId

        Poll.setPoll(queryParams: params, error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (competitions) in
            DispatchQueue.main.async {

                UtilityManager.RemoveHUD()
                print(competitions)
             //   self?.showErrorAlert(title:"Congratulation", errorMessage: "Your Poll is submited successfully.")
            self?.navigationController?.popViewController(animated: true)

                self?.delegate?.didSavePollSurvey(text: (competitions.shareText)!, link: (competitions.deepUrl)!,pollOrSurvey: "Poll")


            }
        }

    }

    func formValid()->Bool{
        for i in 0...(objPoll.options?.count)!-1{
            if(objPoll.options![i]._id == nil){
                return false
            }
        }
        return true
    }
    
    
    
    func playMedia(_ cell: PollTBCell) {
        cell.toggleMedia()
    }
    
    func volumeMedia(_ cell: PollTBCell) {
        cell.toggleVolume()
    }
    
    func voteEntry(index:Int) {
        selectId = objPoll.options![index]._id!
        if(selectId != "")
        {
            submitAPI()
        }
        else
        {
            self.showErrorAlert(title:"", errorMessage: "Please fill Poll form.")
            
        }
        
        
        
        
//        if(isUnVote){
//            entry.vote(numberOfVotes: 1, error: { (errorMessage) in
//                DispatchQueue.main.async {
//                    self.showErrorAlert(errorMessage: errorMessage)
//                }
//            }, completion: {
//                DispatchQueue.main.async {
//                    cell.refreshVotes()
//                }
//            })
//        }
//        else
//        {
//
//            let alertController = TVAlertController(title: "Vote", message: entry.subTitle, preferredStyle: .actionSheet)
//            let voteAction = UIAlertAction(title: "Vote", style: .default, handler: { (action) -> Void in
//                entry.vote(numberOfVotes: 1, error: { (errorMessage) in
//                    DispatchQueue.main.async {
//                        self.showErrorAlert(errorMessage: errorMessage)
//                    }
//                }, completion: {
//                    DispatchQueue.main.async {
//                        cell.refreshVotes()
//                    }
//                })
//            })
            
  //  }
}
    
    // MARK: - IBAction Method
    @IBAction func submitAction(_ sender: UIButton) {
        print("GIVE POLL")
        if(sender.currentTitle == "GIVE POLL"){
           // let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)


//            if let vc = mainStoryboard.instantiateViewController(withIdentifier: "PollListVC") as? PollVC {
                self.pollId = objPoll._id!
                self.isDeepLinkClick = false
                self.viewWillAppear(false)

            //    self.navigationController?.pushViewController(vc, animated: true)
           // }

        }
        else{
        if(selectId != "")
            {
                submitAPI()
            }
        else
            {
                self.showErrorAlert(title:"", errorMessage: "Please fill Poll form.")

            }
        }
    }


    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
//
//    @IBAction func saveAction(_ sender: Any) {
//
//        if let user = AccountManager.session?.account {
//
//            user.categories = savedCategory as? [String]
//
//            user.save(error: { [weak self ](errorMessage) in
//                DispatchQueue.main.async {
//                    self?.showErrorAlert(errorMessage: errorMessage)
//                }
//                }, completion: {
//                    DispatchQueue.main.async {
//                        AccountManager.session?.account = user
//
//                        if self.navigationController?.viewControllers == nil {
//                            self.dismiss(animated: true, completion: nil)
//                        } else {
//                            let _ = self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//            })
//        }
//
//    }
//
}


extension PollVC : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.separatorColor = UIColor.clear
        if(self.objPoll.options?.count == 0){
            return 0
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        if(isDeepLinkClick){
//            if(self.objPoll.isFilled != nil && self.objPoll.isFilled!){
//                return self.objPoll.options!.count + 1
//            }
//            return self.objPoll.options!.count
//
//        }
//        else
//        {
//            if(self.objPoll.options?.count != 0){
//                if(self.objPoll.selected != ""){
//                    return self.objPoll.options!.count
//
//                }
                return self.objPoll.options!.count
          //  }

       // }

       // return 0

    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let dict = objPoll.options![indexPath.row]
            // 0 - Text
            // 1 - Image
            // 2 - Video
            if(dict.type == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "PollTextTBCell", for: indexPath) as! PollTBCell
                cell.lblText.text = dict.title!
                cell.lblOptionText.text = dict.optionText!
                if(dict.optionText! == ""){
                     cell.bottomViewMargin.constant = 0
                    cell.topViewMargine.constant = 0

                }
                else{
                    cell.bottomViewMargin.constant = 10
                    cell.topViewMargine.constant = 10
                    
                }
               cell.lblOptionText.layoutIfNeeded()
                
                cell.delegate = self
                cell.btnVote.tag = indexPath.row
                if((self.objPoll.selected)! == dict._id!){
                    cell.btnVote .setImage(UIImage(named:"button-icon-star-select"), for: .normal)
                }
                if((self.objPoll.selected)! != ""){
                    cell.btnVote.isUserInteractionEnabled = false

                }
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PollImageVideoTBCell", for: indexPath) as! PollTBCell
                cell.btnVote.tag = indexPath.row

                cell.btnVolume?.isHidden = true
                cell.lblOptionText.text = dict.optionText
                if((self.objPoll.selected)! == dict._id!){
                    cell.btnVote .setImage(UIImage(named:"button-icon-star-select"), for: .normal)
                }
                
                if((self.objPoll.selected)! != ""){
                    cell.btnVote.isUserInteractionEnabled = false
                }
                
                if(dict.type == 2){
                    if let mediaUri = dict.title, let uri = URL(string: mediaUri) {
                        cell.btnVolume?.isHidden = true
                        cell.imgPollView.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: true)
                    }

                }
                else
                {
                    cell.btnVolume?.isHidden = false

                    if(isVideoMuted){
                        cell.btnVolume?.setImage(UIImage(named:"soundOff"), for: .normal)
                    }
                    else {
                        cell.btnVolume?.setImage(UIImage(named:"soundOn"), for: .normal)
                        
                    }
                    
                    if let mediaUri = dict.title, let uri = URL(string: mediaUri) {
                        cell.viewImg.addPlayer(uri)
                    }
                   
                }
                cell.delegate = self
                return cell
            }
        
    }

  
    


}

extension PollVC:UITableViewDelegate{

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if(indexPath.row == 0){
//            return  40
//        }
//        else{
//            return  50
//
//        }
//
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NSLog("\(indexPath.row)")
//        if(self.objPoll.options.count  != nil){
            if (objPoll.options![indexPath.row].type == 1 || objPoll.options![indexPath.row].type == 2){
                return 350
            }
           return UITableViewAutomaticDimension
//    }
//        return 0

    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//
//       // return UITableViewAutomaticDimension
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        if(self.objPoll.selected == "" && indexPath.row != 0 && indexPath.row != self.objPoll.options!.count){
//
//        unSelectId = selectId
//        selectId = objPoll.options![indexPath.row-1]._id!
//        tblPoll.reloadData()
//
//        }

    }
//    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
//
////    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> CGFloat {
//       // return 40
//
//        return CGFloat.leastNormalMagnitude
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return UITableViewAutomaticDimension

        return 44  // or whatever
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderPollCell") as! PollTBCell
            cell.lblText.text = objPoll.title
            return cell
            
        }
        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
//        return headerView
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


}
