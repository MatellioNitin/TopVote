//
//  SurveyVC.swift
//  Topvote
//
//  Created by CGT on 24/08/18.
//  Copyright © 2018 Top, Inc. All rights reserved.

import UIKit

class SurveyVC: UIViewController {

    @IBOutlet weak var tblSurvey: UITableView!
    
    var objSurvey = Survey()
    var surveyId = ""
    var isAlreadySubmit = false
    var isDeepLinkClick:Bool = false
    var delegate: PollSurveyDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = "FILL SURVEY"
      // self.navigationController?.navigationBar.topItem?.title = ""

        self.tblSurvey.estimatedRowHeight = 88.0
        self.tblSurvey.estimatedSectionHeaderHeight = 25;

        self.tblSurvey.rowHeight = UITableViewAutomaticDimension
        self.tblSurvey.sectionHeaderHeight = UITableViewAutomaticDimension;
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "SURVEY"



        if(isDeepLinkClick){
            getSurveyDataDeepLink()
        }
        else{
            getSurveyData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    func getSurveyDataDeepLink(key:String = ""){
        
        if UIApplication.shared.applicationState == .background {
            return
        }
        UtilityManager.ShowHUD(text: "Please wait...")
        self.navigationItem.rightBarButtonItem = nil

        Survey.getSurveyDeepLink(surveyID: surveyId, error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                self?.showErrorAlert(errorMessage: errorMessage)
                
            }
        }) { [weak self] (survey) in
            UtilityManager.RemoveHUD()
            print(survey)
            self?.objSurvey = survey
            if((self?.objSurvey.questions?.count)! > 0 &&  self?.objSurvey.questions![0].selected != ""){
                self?.isAlreadySubmit = true
                
//                let shareButton = UIBarButtonItem(image:UIImage(named:"share"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(self?.shareClick))
//                
//                self?.navigationItem.rightBarButtonItem = shareButton
                
                
                
            }
            
            
            self?.tblSurvey.reloadData()
            print("get Poll success")
        }
    }
    
    func getSurveyData(key:String = ""){

            if UIApplication.shared.applicationState == .background {
                return
            }
                UtilityManager.ShowHUD(text: "Please wait...")
        self.navigationItem.rightBarButtonItem = nil
                Survey.getSurvey(surveyID: surveyId, error: { [weak self] (errorMessage) in
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()

                        self?.showErrorAlert(errorMessage: errorMessage)

                    }
                }) { [weak self] (survey) in
                        UtilityManager.RemoveHUD()
                        print(survey)
                        self?.objSurvey = survey
                    self?.isAlreadySubmit = false

                    if((self?.objSurvey.questions?.count)! > 0 &&  self?.objSurvey.questions![0].selected != ""){
                        self?.isAlreadySubmit = true
                        
                        let shareButton = UIBarButtonItem(image:UIImage(named:"share"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(self?.shareClick))

                        self?.navigationItem.rightBarButtonItem = shareButton
                        
                        
                        
                    }
                    
                    
                        self?.tblSurvey.reloadData()
                        print("get Poll success")
        }
        }
//
//    @objc func shareEntry() {
//        guard let url = self.objSurvey.deepUrl else {
//            return
//        }
//        var textToShare = ""
//        if(self.objSurvey.shareText == ""){
//            textToShare = "Sharing text demo for poll"
//        }
//        else{
//            textToShare = self.objSurvey.shareText!
//        }
//        
//        let objectsToShare = [textToShare, url] as [Any]
//        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        activityViewController.completionWithItemsHandler = {
//            (activity, success, items, error) in
//
//            if (success) {
//                activityViewController.navigationController?.navigationBar.tintColor = Constants.appYellowColor
//
//            }
//        }
//        present(activityViewController, animated: true, completion: nil)
//    }
//    
//    
    func submitAPI()  {
        
        UtilityManager.ShowHUD(text: "Please wait...")
        
        var submissionsArray =  [Dictionary<String, String>]()
        
        var params = [String: Any]()
        params["surveyId"] = objSurvey._id
        params["accountId"] = AccountManager.session!.account?._id
        
        for i in 0...objSurvey.questions!.count - 1{
            //var dict = [String: Any]()
            var dict = Dictionary<String, String>()

            dict["questionId"] = objSurvey.questions![i]._id
            dict["optionId"] = objSurvey.questions![i].selected
            submissionsArray.append(dict)
            
        }
        params["submissions"] = submissionsArray        
        Survey.setSurvey(queryParams: params, error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()

                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (survey) in
            DispatchQueue.main.async {
                
                UtilityManager.RemoveHUD()
              //  self?.showErrorAlert(title:"Congratulation", errorMessage: "Your Survey is submited successfully.")
            self?.navigationController?.popViewController(animated: true)
               // self?.objSurvey = surveyArray

                self?.delegate?.didSavePollSurvey(text: (survey.shareText!), link: (survey.deepUrl!),pollOrSurvey: "Survey")
                
                
            }
        }
        
    }
    
    func formValid()->Bool{
        for i in 0...(objSurvey.questions?.count)!-1{
            if(self.objSurvey.questions![i].selected == ""){
                return false
            }
        }
        return true
    }
    @objc func shareClick(){
        guard let url = self.objSurvey.deepUrl else {
            return
        }
        var textToShare = ""
        if(self.objSurvey.shareText == ""){
            textToShare = "Sharing text demo for survey"
        }
        else{
            textToShare = self.objSurvey.shareText!
        }

            let objectsToShare = [textToShare, url] as [Any]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.completionWithItemsHandler = {
                (activity, success, items, error) in
                //print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
                if (success) {
                    activityViewController.navigationController?.navigationBar.tintColor = Constants.appYellowColor
                activityViewController.navigationController?.navigationBar.backgroundColor = Constants.appThemeColor

                    
                    
                    
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
    // MARK: - IBAction Method
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        if(sender.currentTitle == "FILL SURVEY"){
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SurveyVC") as? SurveyVC {
//                vc.surveyId = objSurvey._id!
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            self.surveyId = objSurvey._id!
            self.isDeepLinkClick = false
            self.viewWillAppear(false)

            
        }
        else{
            if(surveyId != "" && formValid())
            {
                submitAPI()
            }
            else
            {
                self.showErrorAlert(title:"", errorMessage: "Please fill survey form.")
                
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


extension SurveyVC : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.separatorColor = UIColor.clear
        if(self.objSurvey._id == nil || objSurvey.questions!.count == 0){
            return 0
        }

//        if(isAlreadySubmit){
//            return objSurvey.questions!.count + 1
//        }
//
//        return objSurvey.questions!.count + 2
//
        if(isDeepLinkClick){
            if(self.objSurvey.isFilled != nil && self.objSurvey.isFilled!){
                return self.objSurvey.questions!.count + 1
            }
            return self.objSurvey.questions!.count  + 2
        }
        else{
            if(isAlreadySubmit){
                return objSurvey.questions!.count + 1
            }
            return objSurvey.questions!.count + 2
        }
//        if(isAlreadySubmit){
//            return objSurvey.questions!.count + 1
//        }
//        return objSurvey.questions!.count + 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(objSurvey.questions?.count == 0){
            return 0
        }
        else if (section == 0){
            return 0
        }
        else if(((objSurvey.questions?.count)!+1) == section){
            return 0
        }
        else{
        
        return self.objSurvey.questions![section-1].questionOptions.count
        }
        //return categoryArray.coun[]

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell =  tableView.dequeueReusableCell(withIdentifier: "AnswerRadioCell", for: indexPath as IndexPath) as! CommonCell

        let optionsObj = objSurvey.questions![indexPath.section-1].questionOptions[indexPath.row]

        cell.lblOption.text = optionsObj.option
        
        if (objSurvey.questions![indexPath.section-1].questionOptions[indexPath.row]._id! ==  objSurvey.questions![indexPath.section-1].selected!)
            {
                cell.imgRadio.image = UIImage(named:"radio_On")
            }
            else
            {
                cell.imgRadio.image = UIImage(named:"radio_Off")
            
            }
      

        return cell
    }

   

}

extension SurveyVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!isAlreadySubmit){
        self.objSurvey.questions![indexPath.section-1].selected =  objSurvey.questions![indexPath.section-1].questionOptions[indexPath.row]._id
        }
        
        
        
        
//        DispatchQueue.main.async { [unowned self] in
//            UIView.setAnimationsEnabled(false)
       //     tableView.beginUpdates()
            tableView.reloadData()
        
//            tableView.endUpdates()
//        }
        
        
        
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if((objSurvey.questions!.count + 1) == section){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitCell") as! CommonCell
            
            if(self.objSurvey.isFilled == nil){
                cell.btnSubmit .setTitle("SUBMIT", for: .normal)
            }
            else
            {
                cell.btnSubmit .setTitle("FILL SURVEY", for: .normal)
            }
            
            
            
            cell.btnSubmit.addTarget(self, action:#selector(self.submitAction(_:)), for: .touchUpInside)
            return cell
        }
        else if(section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyHeaderCell") as! CommonCell
            cell.lblSurveyTitle1.text = self.objSurvey.title?.capitalized
            cell.lblSurveyTitle2.text = self.objSurvey.description
            return cell
        }
       else if((objSurvey.questions!.count + 1) != section){
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionHeaderCell") as! CommonCell
            let questionObj = self.objSurvey.questions![section-1]
            //DispatchQueue.main.async { [unowned self] in
                cell.lblQuestion.text = questionObj.question
            // }
            return cell
   
         }

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return UITableViewAutomaticDimension
        
    }
    
    
  
}


