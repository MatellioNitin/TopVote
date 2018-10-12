//
//  CategoryVC.swift
//  Topvote
//
//  Created by CGT on 24/08/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import UIKit

class PollVC: UIViewController {

    @IBOutlet weak var tblPoll: UITableView!
    
    var objPoll = Poll()
    var savedPoll = NSMutableArray()
    var selectId:String = ""
    var unSelectId:String = ""
    
    var pollId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "SUBMIT POLL"
        self.navigationController?.navigationBar.topItem?.title = ""

        self.tblPoll.estimatedRowHeight = 40;
        self.tblPoll.rowHeight = UITableViewAutomaticDimension
        
        tblPoll.rowHeight = UITableViewAutomaticDimension
        getPollData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false

    }
    func getPollData(){
        
            UtilityManager.ShowHUD(text: "Please wait...")

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
                        UtilityManager.RemoveHUD()
                        self?.objPoll = polls
                        
                        if(self?.objPoll.selected != ""){
                            self?.selectId = (self?.objPoll.selected)!
                        }
                        
                        print("get Poll success")
                        self?.tblPoll.reloadData()
                    }
            
            
        }
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
                self?.showErrorAlert(title:"Congratulation", errorMessage: "Your Poll is submited successfully.")
                self?.navigationController?.popViewController(animated: true)
                
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
    // MARK: - IBAction Method
    
    @IBAction func submitAction(_ sender: UIButton) {
     //   if(formValid()){
        if(selectId != "")
        {
            submitAPI()
        }
        else
        {
            self.showErrorAlert(title:"", errorMessage: "Please fill Poll form.")
            
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
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.objPoll.selected != ""){
            return self.objPoll.options!.count + 1

        }
        else
        if(self.objPoll.options?.count != 0){
            return self.objPoll.options!.count + 2
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        var identifier = ""
        
        switch indexPath.row {
        case 0: identifier = "QuestionCell"
        case (self.objPoll.options?.count)!+1: identifier = "SubmitCell"
        default: identifier = "AnswerRadioCell"
        }
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath as IndexPath) as! CommonCell

     

        switch identifier {
        case "QuestionCell": cell.lblQuestion.text = self.objPoll.title
        case "AnswerRadioCell": cell.lblOption.text = self.objPoll.options![indexPath.row-1].title
        if(self.selectId == objPoll.options![indexPath.row-1]._id)
            {
                cell.imgRadio.image = UIImage(named:"radio_On")
            }
            else
            {
                cell.imgRadio.image = UIImage(named:"radio_Off")
            }
        default :
            cell.btnSubmit.addTarget(self, action:#selector(self.submitAction(_:)), for: .touchUpInside)

        }

        return cell
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
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.objPoll.selected == "" && indexPath.row != 0 && indexPath.row != self.objPoll.options!.count + 1){
            
        unSelectId = selectId
        selectId = objPoll.options![indexPath.row-1]._id!
        tblPoll.reloadData()
            
        }

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }


}


