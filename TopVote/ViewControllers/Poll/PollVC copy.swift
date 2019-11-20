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
    var objPollCount = Poll()

    var savedPoll = NSMutableArray()
    var isDeepLinkClick:Bool = false
    var selectId:String = ""
    var unSelectId:String = ""
    var pollId = ""
    var delegate: PollSurveyDelegate?
    var isVideoMuted = true
    var selectedIndexPath:IndexPath? = nil
    var totalProgressCount = 0
    var selectedDoubleTapIndexPath:IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

      //  navigationItem.title = "POLL"
       // self.navigationController?.navigationBar.topItem?.title = ""

        self.tblPoll.estimatedRowHeight = 100;
        self.tblPoll.estimatedSectionHeaderHeight = 100;
//        self.tblPoll.rowHeight = UITableViewAutomaticDimension
        tblPoll.rowHeight = UITableViewAutomaticDimension
        tblPoll.sectionHeaderHeight = UITableViewAutomaticDimension


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
        
        getleaderboardData()
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
                        self!.fillLeaderBoardData()
                        print("get Poll success")
                        self?.tblPoll.reloadData()
                }
            }
        }

    func getleaderboardData(){
        
        UtilityManager.ShowHUD(text: "Please wait...")
        if UIApplication.shared.applicationState == .background {
            return
        }
        Poll.getLeaderboardDetail(pollID: pollId, error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                
                UtilityManager.RemoveHUD()
                self?.navigationController?.popViewController(animated: true)
                self?.showErrorAlert(errorMessage: errorMessage)
                
            }
        }) { [weak self] (polls) in
            DispatchQueue.main.async {
                print(polls)
                
                UtilityManager.RemoveHUD()
                self?.objPollCount = polls
                print("get Poll success")
                self!.fillLeaderBoardData()
            
            }
        }
    }

    func fillLeaderBoardData(){
        totalProgressCount = 0
        if(self.objPoll.options!.count > 0){
            
            for i in 0...(self.objPoll.options!.count)-1{
                self.objPoll.options![i].count = 0
            }
            
            for i in 0...(self.objPoll.options!.count)-1{
                for dictCount in self.objPollCount.pollCount!{
                    if(self.objPoll.options![i]._id == dictCount._id){
                        totalProgressCount = totalProgressCount + dictCount.count!
                        self.objPoll.options![i].count = dictCount.count!
                    }
                
            }
        }
            
        }
        self.tblPoll.reloadData()

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

    func submitAPI(index:Int)  {

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
                if(self!.selectId == self!.objPoll.selected){
                    // Unvote
                    self!.selectId = ""
                    self!.objPoll.selected = ""
//                    let currentCell = self!.tblPoll.cellForRow(at: self!.selectedIndexPath!) as! PollTBCell
                    if(self!.selectedIndexPath != nil){
                    
                   // self!.tblPoll.reloadRows(at: [self!.selectedIndexPath!], with: UITableViewRowAnimation.none)
                    }
                    else
                    {
                     //   self!.tblPoll.reloadData()
                    }
//                    self!.totalProgressCount = self!.totalProgressCount - 1
//                    self!.objPoll.options![self!.selectedIndexPath!.row].count = self!.objPoll.options![self!.selectedIndexPath!.row].count! - 1
                    
                //    self!.tblPoll.reloadSections([1], with: .none)

                   // currentCell.btnVote .setImage(UIImage(named:"button-icon-star"), for: .normal)
                }
                else
                {
                    self!.objPoll.selected = self!.selectId
                    self!.objPoll.mediaUri = competitions.mediaUri
                    self!.objPoll.shareText = competitions.shareText
                    
//                    self!.totalProgressCount = self!.totalProgressCount + 1
//                    self!.objPoll.options![self!.selectedIndexPath!.row].count = self!.objPoll.options![self!.selectedIndexPath!.row].count! + 1
                    
                  //  let currentCell = self!.tblPoll.cellForRow(at: self!.selectedIndexPath!) as! PollTBCell
                    
                   // currentCell.btnVote .setImage(UIImage(named:"button-icon-star"), for: .normal)
                    
                    let indexPath1 = NSIndexPath(row: index, section: 0)
//                    let currentCell1 = self!.tblPoll.cellForRow(at: indexPath1 as IndexPath) as! PollTBCell
//                    currentCell1.btnVote .setImage(UIImage(named:"button-icon-star-select"), for: .normal)
                    if(self!.selectedIndexPath != nil){

                 //   self!.tblPoll.reloadRows(at: [self!.selectedIndexPath!, indexPath1 as IndexPath], with: UITableViewRowAnimation.none)
                        
         
                        
                    }
                    else
                    {
                       // self!.tblPoll.reloadData()
                    }
//                    self!.tblPoll.reloadSections([1], with: .none)

//                self?.navigationController?.popViewController(animated: true)
//
//                self?.delegate?.didSavePollSurvey(text: (competitions.shareText)!, link: (competitions.deepUrl)!,pollOrSurvey: "Poll")

                }
                
                self!.getleaderboardData()
                
                if(!(self?.isDeepLinkClick)! && self!.selectId != ""){
                    let button1 = UIBarButtonItem(image: UIImage(named: "shareOnNav"), style: .plain, target: self, action:#selector(self?.shareClick))
                    self?.navigationItem.rightBarButtonItem  = button1
                }
                else{
                    self?.navigationItem.rightBarButtonItem = nil
                }

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

    @objc func voteEntryDoubleTap(sender:UITapGestureRecognizer){
        selectId = objPoll.options![sender.view!.tag]._id!
        if(selectId != "" && (self.objPoll.selected)! != selectId){
            submitAPI(index:sender.view!.tag)
        }
//        else
//        {
//            self.showErrorAlert(title:"", errorMessage: "Please fill Poll form.")
//        }
    }
    
    func roundToTens(x : Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    func voteEntry(index:Int) {
        selectId = objPoll.options![index]._id!
        if(selectId != "")
        {
            submitAPI(index: index)
        }
        else
        {
            self.showErrorAlert(title:"", errorMessage: "Please fill Poll form.")
        }
    }
        
//    @objc func voteButtonTapped(_ sender: UILongPressGestureRecognizer) {
//            guard let entry = entry else {
//                return
//            }
//            if (sender.state == UIGestureRecognizerState.began) {
//
//                if(entry.hasVoted != true){
//                    // self.voteButton?.isEnabled = false
//                    self.delegate?.voteEntry(self, entry:entry, isUnVote:false)
//                }
//                else
//                {
//                    self.delegate?.voteEntry(self, entry:entry, isUnVote:true)
//                }
//            }
//        }
        
        
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
//}
    
    
  
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
                //submitAPI()
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
//}

}

extension PollVC : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.separatorColor = UIColor.clear
        if(self.objPoll.options?.count == 0){
            return 0
        }
//        else if(self.objPollCount.pollCount?.count != 0){
//             return 2
//        }
        return 2
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
        if(section == 0){  return self.objPoll.options!.count   }
        else if(section == 1){  return self.objPoll.options!.count   }
        else{
            return 0
        }
                        
                        
            }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let dict = objPoll.options![indexPath.row]
            // 0 - Text
            // 1 - Image
            // 2 - Video
            
            let tapImageGR = UITapGestureRecognizer(target: self, action: #selector(self.voteEntryDoubleTap))
            let tapImageGR1 = UITapGestureRecognizer(target: self, action: #selector(self.voteEntryDoubleTap))

            
            if(dict.type == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "PollTextTBCell", for: indexPath) as! PollTBCell
                cell.lblText.text = dict.title
                
          //      ptionText?.addGestureRecognizer(voteDoubleTap)

               

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
                    cell.lblOptionText.isUserInteractionEnabled = false
                    cell.lblText.isUserInteractionEnabled = false
                    selectedIndexPath = indexPath
                    cell.lblOptionText.removeGestureRecognizer(tapImageGR)
                    cell.lblText.removeGestureRecognizer(tapImageGR1)
                    cell.btnVote .setImage(UIImage(named:"button-icon-star-select"), for: .normal)
                }
                else
                {
                    cell.lblOptionText.isUserInteractionEnabled = true
                    cell.lblText.isUserInteractionEnabled = true
                    tapImageGR.numberOfTapsRequired = 2
                    cell.lblOptionText.addGestureRecognizer(tapImageGR)
                    selectedDoubleTapIndexPath = indexPath
                    cell.lblOptionText.tag = indexPath.row
                    
                    
                    tapImageGR1.numberOfTapsRequired = 2
                    cell.lblText.addGestureRecognizer(tapImageGR1)
                    cell.lblText.tag = indexPath.row
                    
                    cell.btnVote .setImage(UIImage(named:"button-icon-star"), for: .normal)
                }
//                if((self.objPoll.selected)! != ""){
//                    cell.btnVote.isUserInteractionEnabled = false
//
//                }
                
             
                
                
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PollImageVideoTBCell", for: indexPath) as! PollTBCell
                cell.btnVote.tag = indexPath.row

                cell.btnVolume?.isHidden = true
                cell.lblOptionText.text = dict.optionText
                cell.lblOptionText.isUserInteractionEnabled = true
                
                if((self.objPoll.selected)! == dict._id!){
                    selectedIndexPath = indexPath
                    cell.imgPollView.removeGestureRecognizer(tapImageGR)
                    cell.btnVote .setImage(UIImage(named:"button-icon-star-select"), for: .normal)
                }
                else
                {
                    tapImageGR.numberOfTapsRequired = 2
                    cell.imgPollView.addGestureRecognizer(tapImageGR)
                    selectedDoubleTapIndexPath = indexPath
                    cell.imgPollView.tag = indexPath.row
                    cell.btnVote .setImage(UIImage(named:"button-icon-star"), for: .normal)
                }
               
//                if((self.objPoll.selected)! != ""){
//                    cell.btnVote.isUserInteractionEnabled = false
//                }
                
                if(dict.type == 2){
                    if let mediaUri = dict.title, let uri = URL(string: mediaUri) {
                       
                        cell.btnVolume?.isHidden = true
                        cell.imgPollView.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: true)
                    }
                    cell.imgPollView.tag = indexPath.row


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
                    cell.viewImg.tag = indexPath.row

                }
                cell.delegate = self
                return cell
            }
        }
        else
        {
            let dict = objPoll.options![indexPath.row]
            print(indexPath.row)
            print(dict)

            // 0 - Text
            // 1 - Image
            // 2 - Video
            let cell =  tableView.dequeueReusableCell(withIdentifier: "LeaderShipTBCell") as! PollTBCell
           // let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderShipTBCell", for: indexPath) as! PollTBCell

            if(dict.type == 0){
                cell.imgOption.image = UIImage(named: "textImage")
                 cell.imgPlay.isHidden = true
//                return cell
            }
            else{
                if(dict.type == 2){
                     cell.imgPlay.isHidden = true
                }
                else
                {
                    cell.imgPlay.isHidden = false

                }
                    if let mediaUri = dict.title, let uri = URL(string: mediaUri) {
                        cell.imgOption.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: true)
                    }
            }
            
            if(totalProgressCount != 0 && dict.count != nil && dict.count != 0)
            {
               
            let progress = Int(round((Double(dict.count!)/Double(totalProgressCount) * 100)))
                
             
            let intProgress = "\(progress)"
            let progressWidth = Float(self.view.frame.width - 130)
                
            cell.lblLeading.constant = CGFloat(15 + Int((progressWidth  * Float(intProgress)!) / 100))

            cell.lblProgressCount.text = "\(intProgress) %"
                
            cell.progressView.progress = Float(intProgress)! / 100
                
                if(indexPath.row == 1){
                    print("progress \(Float(intProgress)! / 100)")
                    
                }
            }
            else{
                cell.lblProgressCount.text = "0 %"
                
                cell.lblLeading.constant =  0
                cell.progressView.progress =  0
                
            }
            
            
            
            
            
//            cell.progressView.layer.cornerRadius = 0
//            cell.progressView.isMasksToBounds = true
            
            switch indexPath.row{
            case 0:
                cell.progressView.progressTintColor = UIColor(red: 67.0/255.0, green: 37.0/255.0, blue: 81.0/255.0, alpha: 1.0)

            case 1:
                cell.progressView.progressTintColor = UIColor(red: 217.0/255.0, green: 166.0/255.0, blue: 80.0/255.0, alpha: 1.0)
            case 2:
                cell.progressView.progressTintColor = UIColor(red: 0.0/255.0, green: 48.0/255.0, blue: 246.0/255.0, alpha: 1.0)

            case 3:
                cell.progressView.progressTintColor = UIColor(red: 253/255.0, green: 123.0/255.0, blue: 63.0/255.0, alpha: 1.0)

            case 4:
                cell.progressView.progressTintColor = UIColor(red: 2.0/255.0, green: 134.0/255.0, blue: 72.0/255.0, alpha: 1.0)

            default:
                print("")
                
            }
            

            cell.contentView.layoutIfNeeded()

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
        
        if(indexPath.section == 1){
           return 50
        }
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
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
        if(section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderPollCell") as! PollTBCell
            cell.lblText.text = objPoll.description
            return cell
        
        }
    else{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderLeaderboardCell") as! PollTBCell
        cell.lblText.text = "Live Results!"
        return cell
    }
}
        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
//        return headerView
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


}