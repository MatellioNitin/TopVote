//
//  CategoryVC.swift
//  Topvote
//
//  Created by CGT on 24/08/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblCategory: UITableView!
    
    var categoryArray = Categorys()
    var savedCategory = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.tabBarController?.selectedIndex != 4){
            btnBack.isHidden = true
        }
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        savedCategory = NSMutableArray(array: (AccountManager.session?.account?.categories)!)

        getCategoryList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false

    }
    func getCategoryList(){

            if UIApplication.shared.applicationState == .background {
                return
            }

            Category.find(queryParams: [:], error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
            }) { [weak self] (competitions) in
                DispatchQueue.main.async {
                    self?.categoryArray = competitions
                    if(self?.savedCategory.count == self?.categoryArray.count){
                        self?.btnSelectAll .setTitle("UnSelect All", for: .normal)
                    }
                    
                    self?.tblCategory.reloadData()
                }
            }

        }
//   }

    // MARK: - IBAction Method
//
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if let user = AccountManager.session?.account {
          
            user.categories = savedCategory as? [String]
            
            user.save(error: { [weak self ](errorMessage) in
                DispatchQueue.main.async {
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
                }, completion: {
                    DispatchQueue.main.async {
                        AccountManager.session?.account = user
                       
                        if self.navigationController?.viewControllers == nil {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            let _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
            })
        }
        
    }
    
    @IBAction func btnSelectAllAction(_ sender: Any) {

        if(btnSelectAll.titleLabel?.text == "Select All"){
            btnSelectAll .setTitle("UnSelect All", for: .normal)
            savedCategory.removeAllObjects()
            for i in 0...categoryArray.count - 1 {
                savedCategory.add(categoryArray[i]._id!)
            }
        }
        else{
            btnSelectAll .setTitle("Select All", for: .normal)
            savedCategory.removeAllObjects()
        }
        tblCategory.reloadData()
    }

    func getAllSelectedIds(){

       // let foundIds = categoryArray.filter { $0.isSelect == true }.map { $0._id }
    }
}


extension CategoryVC : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.separatorColor = UIColor.clear
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell =  tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath as IndexPath) as! CommonCell

        let objectList:Category = categoryArray[indexPath.row]

     
        cell.lblCategoryName.text = objectList.name
      
        if (savedCategory.contains(objectList._id!)){
            cell.imgCheck.image = UIImage(named:"check")
        }
        else
        {
            cell.imgCheck.image = UIImage(named:"uncheck")

        }
        
        cell.viewShadow.layer.shadowColor = UIColor.lightGray.cgColor
        cell.viewShadow.layer.shadowOpacity = 1
        cell.viewShadow.layer.shadowOffset = CGSize.zero
        cell.viewShadow.layer.shadowRadius = 2

        return cell
    }

}

extension CategoryVC:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(savedCategory.contains(categoryArray[indexPath.row]._id!)){
        
            let index = savedCategory.index(of: categoryArray[indexPath.row]._id!)
            savedCategory.removeObject(at: index)
            
        }
        else{
        savedCategory.add(categoryArray[indexPath.row]._id!)
        }
        tblCategory.reloadData()
      //  tableView.reloadRows(at: [indexPath], with: .none)

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }


}


