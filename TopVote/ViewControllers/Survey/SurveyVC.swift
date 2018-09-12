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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "FILL SURVEY"
        
        self.tblSurvey.estimatedRowHeight = 88.0
        self.tblSurvey.estimatedSectionHeaderHeight = 25;

        self.tblSurvey.rowHeight = UITableViewAutomaticDimension
        self.tblSurvey.sectionHeaderHeight = UITableViewAutomaticDimension;
        
        getSurveyData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    func getSurveyData(key:String = ""){

            if UIApplication.shared.applicationState == .background {
                return
            }
                UtilityManager.ShowHUD(text: "Please wait...")

                Survey.getSurvey(surveyID: surveyId, error: { [weak self] (errorMessage) in
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()

                        self?.showErrorAlert(errorMessage: errorMessage)

                    }
                }) { [weak self] (survey) in
                        UtilityManager.RemoveHUD()

                        self?.objSurvey = survey
                    if((self?.objSurvey.questions?.count)! > 0 &&  self?.objSurvey.questions![0].selected != ""){
                        self?.isAlreadySubmit = true
                    }
                        self?.tblSurvey.reloadData()
                        print("get Poll success")
        }
        }

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
        }) { [weak self] (surveyArray) in
            DispatchQueue.main.async {
                
                UtilityManager.RemoveHUD()
                self?.showErrorAlert(title:"Congratulation", errorMessage: "Your Survey is submited successfully.")
                self?.navigationController?.popViewController(animated: true)
                
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
    
    // MARK: - IBAction Method
    
    @IBAction func submitAction(_ sender: UIButton) {
        if(formValid()){
        submitAPI()
        }
        else
        {
            self.showErrorAlert(title:"", errorMessage: "Please fill survey form.")

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
        if(isAlreadySubmit){
            return objSurvey.questions!.count + 1
        }
        return objSurvey.questions!.count + 2
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

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return  50
//
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!isAlreadySubmit){
        self.objSurvey.questions![indexPath.section-1].selected =  objSurvey.questions![indexPath.section-1].questionOptions[indexPath.row]._id
            tableView.reloadData()
//            tableView.s
            tableView.selectRow(at: IndexPath(row: indexPath.row, section: indexPath.section), animated: false, scrollPosition: .none)

          //  tableView.reloadSections([indexPath.section], with: .none)
        }

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if((objSurvey.questions!.count + 1) == section){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitCell") as! CommonCell
            cell.btnSubmit.addTarget(self, action:#selector(self.submitAction(_:)), for: .touchUpInside)
            return cell
        }
       else if(section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyHeaderCell") as! CommonCell
            cell.lblSurveyTitle1.text = self.objSurvey.title?.capitalized
            cell.lblSurveyTitle2.text = self.objSurvey.description
            return cell
        }
     //  else if((objSurvey.questions!.count) != section){
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionHeaderCell") as! CommonCell
            let questionObj = self.objSurvey.questions![section-1]
            cell.lblQuestion.text = questionObj.question
            return cell
       // }

//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        return headerView
        
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
  
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
       return UITableViewAutomaticDimension
        
    }
    
    
  
}


