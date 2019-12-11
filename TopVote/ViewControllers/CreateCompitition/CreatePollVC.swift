//
//  CategoryVC.swift
//  Topvote
//
//  Created by CGT on 24/08/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import UIKit

class CreatePollVC: UIViewController {
    
    
    @IBOutlet weak var imgCompetition: UIImageView!
    
    @IBOutlet weak var txtName: CustomUITextField!
    
    @IBOutlet weak var txtStartDate: CustomUITextField!
    
    @IBOutlet weak var txtEndDate: CustomUITextField!
    
    @IBOutlet weak var txtDescription: CustomUITextField!
    
    @IBOutlet weak var txtCategory: CustomUITextField!
    
    @IBOutlet var btnCompType: [UIButton]!
    
    @IBOutlet weak var tblCompition: UITableView!
    
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var viewFullImage: UIView!
    
    @IBOutlet weak var imgFull: UIImageView!
    
    let picker = UtilityManager.normalPicker()
    var pickerDate = UtilityManager.picker_Date_Create()
    
//    var compititionObj = Competition()
    
    var createPollOptionArray = CreatePollOptions()
    var pickerArr = [String]()
    var comptitionImage:UIImage?  = nil
    var comptitionImageURL:String?  = ""
    var selectedTxtField = UITextField()
    var selectedButtonIndex:Int = -1  // 1= compition, 2= logo
    let dateFormatter = DateFormatter()
    var categoryArray = Categorys()
    var savedCategory = Categorys()
    var savedIdCategory = NSMutableArray()
    var objPoll = Poll()
    var objComp = Competition()

    let typeArray = ["Text", "Image", "Video"]

    // MARK: - ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        pickerDate.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        txtStartDate.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneButtonWiithModuleAction(done:)))
        txtEndDate.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneButtonWiithModuleAction(done:)))
        txtCategory.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneButtonWiithModuleAction(done:)))
        
        getCategoryList()
        if(objComp._id != nil){
            self.navigationItem.title = "Edit Poll"
            updateListData()
            getPollData()
            
        }
        else
        {
            if(objPoll.options?.count == 0){
                let obj = CreatePollOption()
                let obj1 = CreatePollOption()
                createPollOptionArray.append(obj)
                createPollOptionArray.append(obj1)
                tblCompition.reloadData()
            }
            
            self.navigationItem.title = "Create Poll"
            //setListData()
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - API Method
    
    func getCategoryList(){
        
        if UIApplication.shared.applicationState == .background {
            return
        }
        UtilityManager.ShowHUD(text: "Please wait...")
        
        Category.find(queryParams: [:], error: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                
                self?.showErrorAlert(errorMessage: errorMessage)
            }
        }) { [weak self] (competitions) in
            UtilityManager.RemoveHUD()
            //                DispatchQueue.main.async {
            
            self?.categoryArray = competitions
            if(self!.objComp._id != nil){
                if(self!.objComp.category != nil && self!.objComp.category!.count > 0){
                    self!.savedIdCategory = NSMutableArray(array: self!.objComp.category!)
                    if(self!.categoryArray.count != 0){
                        self!.fillCategoryObjectInArrayt()
                        self!.setCategory()
                    }
                }            }
            if(competitions.count > 0){
                var isAllSelecct = true
                
                if(self!.objPoll._id != nil && self!.objPoll.isPrivate == 0 ){
                    self!.fillCategoryObjectInArrayt()
                    self!.setCategory()
                }
                
                
                
                
                //self!.picker.delegate = self
                //self!.picker.dataSource = true
                //self!.picker.reloadAllComponents()
                
            }
            
            
            //                    print("self?.savedCategory.count \(self?.savedCategory.count)")
            //                        print("self?.savedCategory.count \(self?.savedCategory.count)")
            
            
            //                    if(self?.savedCategory.count == self?.categoryArray.count){
            //                        self?.btnSelectAll .setTitle("Unselect All", for: .normal)
            //                    }
            //                    else if(self?.savedCategory == nil || self?.savedCategory.count == 0){
            //                        self?.btnSelectAll.setTitle("Unselect All", for: .normal)
            //                    }
            
            
            // self?.tblCategory.reloadData()
        }
        //            }
        
    }
    
    func submitAPI()  {
        
        // let index = pickerArr.index(of: createCompArray[4].value!)
        var params = [String: Any]()
        
//        "mediaUri": "https://cdn.filestackcontent.com/2pneVvOfR0Or0vaAL3TM",
//        "byImageUri": "",
//        "title": "Poll Title 2nd",
//        "byText": "Powered by text",
//        "description": "Poll Description",
//        "category": ["5b90b55864c4ef152915bd1e"],
//        "shareText": "",
//        "startDate": "2019-11-22T15:00",
//        "endDate": "2019-12-18T15:00",
//        "options": [{
//        "type": 1,
//        "title": "https://cdn.filestackcontent.com/Qbd86mG9Rp2f2UJR8MZa",
//        "optionText": "Video desc 1"
//        }, {
//        "type": 2,
//        "title": "https://cdn.filestackcontent.com/uXS1qZXSvmDEAq8W2M5D",
//        "optionText": "Image desc 1"
//        }, {
//        "type": 0,
//        "title": "Text Option",
//        "optionText": "Text Option desc 1"
//        }]
//    }
        
        if(self.btnCompType[0].currentImage == UIImage(named:"radio_On")){
            params["isPrivate"] = "0"
        }
        else
        {
            params["isPrivate"] = "1"
        }
        
        let array = NSMutableArray()
        var dictOption = [String: Any]()

        for obj in createPollOptionArray{
            if(obj.type == "Text"){
                dictOption = ["type":"0", "title":obj.title!, "optionText":obj.optionText!]

            }
            else if(obj.type == "Image"){
                dictOption = ["type":"2", "title":obj.title!, "optionText":obj.optionText!]

            }
            else
            {
                dictOption = ["type":"1", "title":obj.title!, "optionText":obj.optionText!]

            }
            array.add(dictOption)
        }
        
        
        params["options"] = array
        params["category"] = savedIdCategory
        params["title"] = txtName.text!
        params["description"] =  txtDescription.text!
        //params["type"] = "\(index!)"
        params["mediaUri"] = comptitionImageURL!
        params["byImageUri"] = ""
        params["startDate"] = localToUTC(date:txtStartDate.text! + "00:00:00")
        params["endDate"] = localToUTC(date:txtEndDate.text!  +  "23:59:59")
        if let user = AccountManager.session?.account {
            params["byText"] = user.displayUserName
        }
     //   params["owner"] = (AccountManager.session?.account?._id)!
        
//        if(isPrivate){
//
//            PCompitionCreate.find(queryParams: params, error: { (errorMessage) in
//                DispatchQueue.main.async {
//                    UtilityManager.RemoveHUD()
//                    self.showErrorAlert(errorMessage: errorMessage)
//                }
//            }, completion: {
//                DispatchQueue.main.async {
//                    UtilityManager.RemoveHUD()
//                    self.showErrorAlert(title:"Congratulation", errorMessage: "Your Private competiton is created successfully")
//                    self.navigationController?.popViewController(animated: true)
//                }
//            })
//        }
//        else
//        {
            PCompitionCreate.createPoll(queryParams: params, error: {  (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(title:"Congratulation", errorMessage: "Your Poll is created successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            })
      //  }
        
    }
    
    
    func updateAPI()  {
        
        var params = [String: Any]()
        
        if(self.btnCompType[0].currentImage == UIImage(named:"radio_On")){
            params["isPrivate"] = "0"
        }
        else
        {
            params["isPrivate"] = "1"
        }
        
        let array = NSMutableArray()
        var dictOption = [String: Any]()
        
        for obj in createPollOptionArray{
            
            if(obj.type == "Text"){
                if(obj._id == ""){
                    dictOption = ["type":"0", "title":obj.title!, "optionText":obj.optionText!]
                }
                else
                {
                    dictOption = ["type":"0", "title":obj.title!, "optionText":obj.optionText!, "_id": obj._id!]
                }
            }
            else if(obj.type == "Image"){
                if(obj._id == ""){

                dictOption = ["type":"2", "title":obj.title!, "optionText":obj.optionText!]
                } else
                    {
                    dictOption = ["type":"2", "title":obj.title!, "optionText":obj.optionText!, "_id": obj._id!]
                        
                }
            }
            else
            {
                if(obj._id == ""){

                    dictOption = ["type":"1", "title":obj.title!, "optionText":obj.optionText!]
                } else
                {
                    dictOption = ["type":"1", "title":obj.title!, "optionText":obj.optionText!, "_id": obj._id!]
                
            }
                
            }
            array.add(dictOption)
        }
        
        
        params["options"] = array
        params["category"] = savedIdCategory
        params["title"] = txtName.text!
        params["description"] =  txtDescription.text!
        //params["type"] = "\(index!)"
        params["mediaUri"] = comptitionImageURL!
        params["byImageUri"] = ""
        params["startDate"] = localToUTC(date:txtStartDate.text! + "00:00:00")
        params["endDate"] = localToUTC(date:txtEndDate.text!  +  "23:59:59")
        if let user = AccountManager.session?.account {
            params["byText"] = user.displayUserName
        }
        PCompitionCreate.updatePoll(pollId: objPoll._id!, queryParams: params, error: {  (errorMessage) in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                self.showErrorAlert(errorMessage: errorMessage)
            }
        }, completion: {
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                self.showErrorAlert(title:"Congratulation", errorMessage: "Your Poll is updated successfully")
                self.navigationController?.popViewController(animated: true)
            }
        })
        //  }
        
    }
    
    func getPollData(){
        
        UtilityManager.ShowHUD(text: "Please wait...")
        
        if UIApplication.shared.applicationState == .background {
            return
        }
        if(objComp.type == 1){
            Poll.getUsersPoll(pollID: objComp._id!, error: { [weak self] (errorMessage) in
                //  DispatchQueue.main.async {
                
                UtilityManager.RemoveHUD()
                self?.navigationController?.popViewController(animated: true)
                self?.showErrorAlert(errorMessage: errorMessage)
                
                // }
            }) { [weak self] (polls) in
                //                    DispatchQueue.main.async {
                print(polls)
                self!.objPoll = polls
//
                if((self!.objPoll.options?.count)! > 0){
                    for i in 0...(self!.objPoll.options?.count)! - 1 {
                        
                    let obj = CreatePollOption()
                        obj._id = self!.objPoll.options![i]._id
                        obj.title = self!.objPoll.options![i].title
                        obj.optionText = self!.objPoll.options![i].optionText
                        
                        if(self!.objPoll.options![i].type! == 0){
                             obj.type =  "Text"
                                
                            }
                        else if(self!.objPoll.options![i].type! == 2){
                               obj.type =  "Image"
                                
                            }
                        else
                            {
                               obj.type =  "Video"
                            }
                        
                        
                        self!.createPollOptionArray.append(obj)
                    }
                   
                    self!.tblCompition.reloadData()
                }
                
                
                UtilityManager.RemoveHUD()
            
        
            }
        }
        else
        {
            Poll.getPoll(pollID: objComp._id!, error: { [weak self] (errorMessage) in
                //  DispatchQueue.main.async {
                
                UtilityManager.RemoveHUD()
                self?.navigationController?.popViewController(animated: true)
                self?.showErrorAlert(errorMessage: errorMessage)
                
                // }
            }) { [weak self] (polls) in
                //                    DispatchQueue.main.async {
                print(polls)
                
                UtilityManager.RemoveHUD()
                self!.objPoll = polls
                if((self!.objPoll.options?.count)! > 0){
                    for i in 0...(self!.objPoll.options?.count)! - 1 {
                        
                        let obj = CreatePollOption()
                        obj._id = self!.objPoll.options![i]._id
                        obj.title = self!.objPoll.options![i].title
                        obj.optionText = self!.objPoll.options![i].optionText
                        
                        if(self!.objPoll.options![i].type! == 0){
                            obj.type =  "Text"
                            
                        }
                        else if(self!.objPoll.options![i].type! == 2){
                            obj.type =  "Image"
                            
                        }
                        else
                        {
                            obj.type =  "Video"
                        }
                        
                        
                        self!.createPollOptionArray.append(obj)
                    }
                    
                    self!.tblCompition.reloadData()
                }
                
            }
        }
        
    }

    // MARK: - IBAction Method
    
    @IBAction func btnCloseAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.viewFullImage.alpha = 0
        })
    }
    
    @IBAction func btnAddOptionAction(_ sender: Any) {
        let obj = CreatePollOption()
        createPollOptionArray.append(obj)
        tblCompition.reloadData()
        let indexPath = IndexPath(row:createPollOptionArray.count-1, section: 0)
        tblCompition.scrollToRow(at: indexPath, at: .bottom, animated: true)

    }
  
    @IBAction func buttonDeleteAction(_ sender: UIButton) {
        
        let alertController = TVAlertController(title: "TOPVOTE", message: "Are you sure you want to remove this option? ", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            self.createPollOptionArray.remove(at: sender.tag)
            self.tblCompition.reloadData()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
 
//        let indexPath = IndexPath(row:createPollOptionArray.count-1, section: 0)
//        tblCompition.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    @IBAction func buttonImageTapAction(_ sender: UIButton) {
        
//        if let uri = URL(string: sender.accessibilityValue!) {
//            imgCompetition.af_setImage(withURL: uri, placeholderImage:  UIImage(named: "upload"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false, completion: { (image) in
//                if let image = image.value {
//                    self.imgFull.image = image
//                }
//            })
//        }
//
//        UIView.animate(withDuration: 0.5, animations: { () -> Void in
//            self.viewFullImage.alpha = 1.0
//        })
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCompTypeAction(_ sender: UIButton) {
        if((self.navigationItem.title?.contains("Edit"))!){
            return
        }
        
        if(sender == btnCompType[0]){
            btnCompType[0].setImage(UIImage(named:"radio_On"), for: .normal)
            btnCompType[1].setImage(UIImage(named:"radio_Off"), for: .normal)
        }
        else
        {
            btnCompType[0].setImage(UIImage(named:"radio_Off"), for: .normal)
            btnCompType[1].setImage(UIImage(named:"radio_On"), for: .normal)
        }
    }
    
    
    
    @IBAction func btnContentTypeAction(_ sender: UIButton) {
        if(sender.currentImage == UIImage(named:"check")){
            sender.setImage(UIImage(named:"uncheck"), for: .normal)
        }
        else
        {
            sender.setImage(UIImage(named:"check"), for: .normal)
        }
    }
    @IBAction func btnTitleAction(_ sender: UIButton) {
        
        selectedButtonIndex = Int(sender.accessibilityValue!)!
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = true
                
                imagePickerController.sourceType = .camera
                
                if(sender.tag < 450){
                    if UIImagePickerController.availableMediaTypes(for: .camera) != nil {
                        imagePickerController.mediaTypes =  ["public.image"]
                    }
                }
                else{
                    if UIImagePickerController.availableMediaTypes(for: .camera) != nil {
                        imagePickerController.mediaTypes =  ["public.movie"]
                    }
                }
                
              
                
                imagePickerController.navigationBar.tintColor = Constants.appYellowColor
                imagePickerController.navigationBar.backgroundColor = Constants.appThemeColor
                
                imagePickerController.delegate = self
                self?.present(imagePickerController, animated: true, completion: nil)
            } else {
                self?.showAlert(title: "Oops!", confirmTitle: "Ok", errorMessage: "Please allow access to your camera.", actions: nil, confirmCompletion: nil, completion: nil)
            }
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = true
                
                imagePickerController.sourceType = .photoLibrary
                
                if(sender.tag < 450){
                    if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
                        imagePickerController.mediaTypes =  ["public.image"]
                    }
                }
                else{
                    if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
                        imagePickerController.mediaTypes =  ["public.movie"]
                    }
                }
                
                imagePickerController.navigationBar.tintColor = Constants.appYellowColor
                imagePickerController.navigationBar.backgroundColor = Constants.appThemeColor
                
                
                imagePickerController.delegate = self
                self?.present(imagePickerController, animated: true, completion: nil)
            } else {
                self?.showAlert(title: "Oops!", confirmTitle: "Ok", errorMessage: "Please allow access to your camera.", actions: nil, confirmCompletion: nil, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    
    @IBAction func btnPickerAction(_ sender: UIButton) {
        selectedTxtField.resignFirstResponder()
        if(sender.tag == 501){
            txtStartDate.becomeFirstResponder()
        }
        else  if(sender.tag == 502){
            txtEndDate.becomeFirstResponder()
        }
        else
        {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
                vc.currentPollVC = self
                vc.savedCategoryObjArray = savedCategory
                vc.savedCategory = savedIdCategory
                navigationController?.pushViewController(vc, animated: true)
                //            txtCategory.becomeFirstResponder()
            }
        }
    }
    
    
    @IBAction func buttonImageAction(_ sender: UIButton) {
        // selectedButtonIndex = sender.tag
        selectedButtonIndex = -1
        chooseMedia()
    }
    
  
    
    @IBAction func saveTapped(_ sender: Any) {
        if(isValidForm()){
            UtilityManager.ShowHUD(text: "Please wait...")
            
            uploadMedia(imageTag: -1, image: comptitionImage!)
        }
        
    }
    
    
    // MARK: - Custom Method
    func updateListData(){
        
        txtName.text =  objComp.title!
        txtStartDate.text =  objComp.startDate!.formattedDateOnlyForFullYear()
        txtEndDate.text =  objComp.endDate!.formattedDateOnlyForFullYear()
        txtDescription.text =  objComp.description
        
        if let profileImageUri = objComp.mediaUri, let uri = URL(string: profileImageUri) {
            imgCompetition.af_setImage(withURL: uri, placeholderImage:  UIImage(named: "upload"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false, completion: { (image) in
                if let image = image.value {
                    self.comptitionImage = image
                }
            })
        }
        if(objComp.isPrivate == 0){
            btnCompType[0].setImage(UIImage(named:"radio_On"), for: .normal)
            btnCompType[1].setImage(UIImage(named:"radio_Off"), for: .normal)
        }
        else
        {
            btnCompType[0].setImage(UIImage(named:"radio_Off"), for: .normal)
            btnCompType[1].setImage(UIImage(named:"radio_On"), for: .normal)
        }
        
        if(objComp.category != nil && objComp.category!.count > 0){
            savedIdCategory = NSMutableArray(array: objComp.category!)
            if(categoryArray.count != 0){
                fillCategoryObjectInArrayt()
                setCategory()
            }
        }

        
        // savedIdCategory =
    }
        
    
    func uploadMedia(imageTag:Int, image:UIImage){
        
        if image != nil {
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                let temporaryDirectory = NSTemporaryDirectory()
                let fileName = UUID().uuidString + ".png"
                if let imageFileURL = NSURL.fileURL(withPathComponents: [temporaryDirectory, fileName]) {
                    do {
                        try data.write(to: imageFileURL, options: .atomic)
                    } catch {
                        print("Writing image failed!")
                    }
                    
                    Media.uploadPhoto(imageFileURL, progress: { (progress, completed) in
                        print("progress: \(progress)  completed: \(completed)")
                    }, error: { (errorMessage) in
                        print(errorMessage)
                    }, completion: { (photo) in
                        DispatchQueue.main.async {
                            let photoData = photo
                            if(imageTag == -1){
                                self.comptitionImageURL = (photoData.secure_url?.absoluteString)
                                if(self.objComp._id != nil){
                                    self.updateAPI()
                                }
                                else{
                                    self.submitAPI()
                                }
                            }
                            else
                            {
                                UtilityManager.RemoveHUD()
                                self.createPollOptionArray[self.selectedButtonIndex].title =  (photoData.secure_url?.absoluteString)
                                let indexPath = IndexPath(row:self.selectedButtonIndex, section: 0)
                                self.tblCompition.reloadRows(at: [indexPath], with: .none)
                            }
                            
                            //                            guard (photoData.secure_url?.absoluteString) != nil else {
                            //                                return
                            //                            }
                            
                        }
                    })
                }
            }
        }
        
    }
    
    
    func chooseMedia() {
        
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = true
                
                imagePickerController.sourceType = .camera
                if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                    imagePickerController.mediaTypes = [mediaTypes[0]]
                }
                imagePickerController.navigationBar.tintColor = Constants.appYellowColor
                imagePickerController.navigationBar.backgroundColor = Constants.appThemeColor
                
                imagePickerController.delegate = self
                self?.present(imagePickerController, animated: true, completion: nil)
            } else {
                self?.showAlert(title: "Oops!", confirmTitle: "Ok", errorMessage: "Please allow access to your camera.", actions: nil, confirmCompletion: nil, completion: nil)
            }
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = true
                
                imagePickerController.sourceType = .photoLibrary
                
                if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                    imagePickerController.mediaTypes = [mediaTypes[0]]
                }
                
                imagePickerController.navigationBar.tintColor = Constants.appYellowColor
                imagePickerController.navigationBar.backgroundColor = Constants.appThemeColor
                
                
                imagePickerController.delegate = self
                self?.present(imagePickerController, animated: true, completion: nil)
            } else {
                self?.showAlert(title: "Oops!", confirmTitle: "Ok", errorMessage: "Please allow access to your camera.", actions: nil, confirmCompletion: nil, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    @objc func handleDatePicker(){
        //        if(self.selectedTxtField.tag > 200){ // Time
        //            pickerDate.minimumDate = nil
        //
        //            dateFormatter.dateFormat = "hh:mm a"
        //
        //            let strSet = dateFormatter.string(from: pickerDate.date)
        //            DispatchQueue.main.async { [unowned self] in
        //                let cell = self.tblCompition.cellForRow(at: IndexPath(row:(self.selectedTxtField.tag - 200), section: 0)) as! CommonCell
        //                DispatchQueue.main.async {
        //                    cell.txtTime.text = strSet
        //                }
        //            }
        //
        //
        //        }
        //        else{ // Date
        pickerDate.minimumDate = Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let strSet = dateFormatter.string(from: pickerDate.date)
        //        DispatchQueue.main.async { [unowned self] in
        //            let cell = self.tblCompition.cellForRow(at: IndexPath(row:(self.selectedTxtField.tag - 100), section: 0)) as! CommonCell
        DispatchQueue.main.async {
            if(self.selectedTxtField == self.txtStartDate){
                self.txtStartDate.text = strSet
            }
            else
            {
                self.txtEndDate.text = strSet
            }            }
        //  }
        // }
    }
    
    func setDatePickerToTextField(_ textField: UITextField) {
        
        textField.inputView = pickerDate
        if(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            pickerDate.date = Date()
        } else {
            
            let textTofound = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let textTofound1 = textTofound?.split(separator: " ").first
            let date = dateFormatter.date(from: "\(textTofound1!)")
            pickerDate.date = date!
            
        }
        
        let strSet = dateFormatter.string(from: pickerDate.date)
        
        textField.text = strSet
        
        //        DispatchQueue.main.async { [unowned self] in
        //            if(textField.tag == 102){
        //                textField.text = strSet
        //                self.createCompArray[1].value = strSet
        //
        //            }
        //            else
        //            {
        //                textField.text = strSet
        //                self.createCompArray[2].value = strSet
        //
        //            }
        //        }
        //
        
    }
    
    
    func setCategoryPickerToTextField(_ textField: UITextField) {
        
        picker.reloadAllComponents()
        textField.inputView = picker
        if(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            picker.selectRow(0, inComponent: 0, animated: false)
            
        } else {
            let textTofound = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let object = categoryArray.filter { $0.name == textTofound}
            
          //  picker.selectRow(categoryArray.firstIndex(of: object.last!)!, inComponent: 0, animated: false)
            
        }
        
        
        if(pickerArr.count > 0){
            //let txt:String!
            let strSet = pickerArr[picker.selectedRow(inComponent: 0)]
            DispatchQueue.main.async { [unowned self] in
                textField.text = strSet
                
            }
        }
    }
    
    func setPickerToTextField(_ textField: UITextField) {
        
        picker.reloadAllComponents()
        textField.inputView = picker
        if(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            picker.selectRow(0, inComponent: 0, animated: false)
            
        } else {
            let textTofound = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            picker.selectRow(typeArray.firstIndex(of: textTofound!)!, inComponent: 0, animated: false)
        }
        
        if(typeArray.count > 0){
            //let txt:String!
            let strSet = typeArray[picker.selectedRow(inComponent: 0)]
            DispatchQueue.main.async { [unowned self] in
                textField.text = strSet
            }
        }
    }

    
    
    @objc func doneButtonWiithModuleAction(done : UITextField){
        selectedTxtField.resignFirstResponder()
    }
    @objc func doneSSelecteTypeAction(done : UITextField){
        selectedTxtField.resignFirstResponder()
        let indexPath = IndexPath(row:selectedTxtField.tag - 200, section: 0)
        tblCompition.reloadRows(at: [indexPath], with: .none)
    }
    
    
    func isValidForm()-> Bool{
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        if(comptitionImage == nil){
            self.showErrorAlert(errorMessage: "Please select poll image")
            return false
            
        }
        else if(txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please enter name of poll.")
            return false
        }
            //        else if(createCompArray[1].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            //
            //          self.showErrorAlert(title:"", errorMessage: "Please ") // Please enter by text
            //        return false
            //
            //        }
        else if(txtStartDate.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please select start date of poll.")
            return false
            
        }
        else if(txtEndDate.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please select end date of poll.")
            return false
            
        }
        else if dateFormatter.date(from: txtStartDate.text!)?.compare(dateFormatter.date(from: txtEndDate.text!)!) == .orderedDescending{
            
            self.showErrorAlert(title:"", errorMessage: "Start date can't be greater than to end date")
            return false
        }
        else if compareDate(date1: dateFormatter.date(from: txtStartDate.text!)!, date2: Date()) && objPoll._id == nil{
            
            // else if dateFormatter.date(from: createCompArray[1].value!)!.compare(Date()) == .orderedAscending{
            self.showErrorAlert(title:"", errorMessage: "Start date can't be less than to current date")
            return false
            
        }
        else if compareDate(date1: dateFormatter.date(from: txtEndDate.text!)!, date2: Date()){
            //  else if dateFormatter.date(from: createCompArray[2].value!)!.compare(Date()) == .orderedAscending{
            self.showErrorAlert(title:"", errorMessage: "End date can't be less than to current date")
            return false
            
        }
//        else if(txtDescription.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
//            self.showErrorAlert(title:"", errorMessage: "Please enter description of poll.")
//            return false
//
//        }
//        else if(categoryArray.count == 0){
//            self.showErrorAlert(title:"", errorMessage: "Please select atlease one category.")
//            return false
//
//        }
        else if(isAnyEmptyEntry()){
        self.showErrorAlert(title:"", errorMessage: "Please fill all options.")
            return false
        }
            //    else if(createCompArray[4].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            //        self.showErrorAlert(title:"", errorMessage: "Please select competitons type")
            //        return false
            //
            //        }
            
        else
        {
            return true
        }
    }
    func isAnyEmptyEntry() -> Bool{
        for obj in createPollOptionArray{
            if(obj.type == "" || obj.title == "" || obj.optionText == ""){
                return true
            }
//            if(obj.type == ""){
//                self.showErrorAlert(title:"", errorMessage: "Please select type of option.")
//
//                return true
//            }
//            else if(obj.title == ""){
//                self.showErrorAlert(title:"", errorMessage: "Please fill all options.")
//
//                return true
//            }
//            else if(obj.optionText == ""){
//                self.showErrorAlert(title:"", errorMessage: "Please fill all options.")
//
//                return true
//            }

        }
        return false

    }
    
    func compareDate(date1:Date, date2:Date) -> Bool {
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    
    //    func localToUTC(date:String) -> String {
    //        // 2018-09-24T12:43
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "MM/dd/yyyy"
    //       // dateFormatter.calendar = NSCalendar.current
    //       // dateFormatter.timeZone = TimeZone.current
    //
    //        let dt = dateFormatter.date(from: date)
    //       // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'"
    //
    //        return dateFormatter.string(from: dt!)
    //    } comment by nikhil
    
    
    func localToUTC(date:String) -> String {
        // 2018-09-24T12:43
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyyHH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
 
    
    func fillCategoryObjectInArrayt(){
        for i in 0...categoryArray.count - 1 {
            if(savedIdCategory.contains(categoryArray[i]._id!)){
                savedCategory.append(categoryArray[i])
            }
        }
    }
    
    func setCategory(){
        if(savedCategory.count != 0){
            var nameArray = [String]()
            for i in 0...savedCategory.count - 1 {
                nameArray.append(categoryArray[i].name!)
            }
            txtCategory.text = nameArray.joined(separator: ", ")
        }
    }
}

extension CreatePollVC :UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return (tableView.frame.width * 250/580)
        }
        switch indexPath.row {
        case 2, 3, 4:
            return (tableView.frame.width * 150/580)
        default:
            return (tableView.frame.width * 160/580)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 190
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createPollOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set cell Identifier
        let identifier = "OptionCell"
        
        
        // set cell UI delegate (and data in case last cell with "save btn")
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CommonCell
        
            let dict = createPollOptionArray[indexPath.row]
        
            cell.txtSelect.placeholder = "Select Option Type"
            cell.txtDescription.placeholder = "Description"

            cell.txtSelect.text = dict.type
            cell.txtOption.text = dict.title
            cell.txtDescription.text = dict.optionText

//            cell.txtField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
            if(indexPath.row == 0 || indexPath.row == 1){
                cell.btnDelete.isHidden = true
            }
            else{
                cell.btnDelete.isHidden = false
            }
        
            cell.btnDelete.tag = indexPath.row
            cell.btnImageTap.accessibilityValue = dict.title
            cell.txtSelect.tag = 200 + indexPath.row
            cell.txtDescription.tag = 1000 + indexPath.row
        
            if(dict.type == ""){
                cell.txtOption.tag = indexPath.row
                cell.btnTitle.isHidden = true
                cell.imgOption.isHidden = true
                cell.txtOption.placeholder = "Title"
                cell.txtImageTrailing.constant = 0


            }
            else if(dict.type == "Text"){
                    cell.txtOption.tag = 300 + indexPath.row
                    cell.btnTitle.isHidden = true
                    cell.imgOption.isHidden = true
                    cell.txtImageTrailing.constant = 0
                    cell.txtOption.placeholder = "Title"


            }
            else if(dict.type == "Image"){
                cell.btnTitle.tag = 400 + indexPath.row
                cell.txtOption.tag = 400 + indexPath.row
                cell.btnTitle.accessibilityValue = "\(indexPath.row)"
                cell.btnTitle.isHidden = false
                cell.imgOption.isHidden = false
                cell.txtImageTrailing.constant = -30
                cell.txtOption.placeholder = "Browse"



            }
            else
            {
                cell.txtOption.tag = 400 + indexPath.row
                cell.btnTitle.tag = 450 + indexPath.row
                cell.btnTitle.accessibilityValue = "\(indexPath.row)"
                cell.btnTitle.isHidden = false
                cell.imgOption.isHidden = false
                cell.txtImageTrailing.constant = -30
                cell.txtOption.placeholder = "Browse"

            }
        
            if let imageUrl = dict.title, let url = URL(string: imageUrl) {
                cell.imgOption.af_setImage(withURL: url, placeholderImage: UIImage(named: "upload"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                
            }
            else
            {
               cell.imgOption.image = UIImage(named: "upload")
            }
        
        
            cell.contentView.layoutIfNeeded()
        
//            cell.btnImageTap.addTarget(self, action:#selector(self.buttonImageTapAction(_:)), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action:#selector(self.buttonDeleteAction(_:)), for: .touchUpInside)
            cell.btnTitle.addTarget(self, action:#selector(self.btnTitleAction(_:)), for: .touchUpInside)
        
            cell.txtSelect.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneSSelecteTypeAction(done:)))

        

//            cell.btnSelect.addTarget(self, action:#selector(self.btnSelectAction(_:)), for: .touchUpInside)

//            cell.txtSelect?.addTarget(self, action: #selector(textFieldShouldBeginEditing(_:)), for: .editingDidBegin)

        return cell
    }
    
}

extension CreatePollVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTxtField = textField
        selectedTxtField.tag = textField.tag
        
        if(textField.tag >= 500){
            switch textField {
            case txtStartDate, txtEndDate:
                dateFormatter.dateFormat = "MM/dd/yyyy"
                pickerDate.datePickerMode = .date
                self.setDatePickerToTextField(textField)
            case txtCategory:
                textField.resignFirstResponder()

//                if let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
//                    vc.currentPollVC = self
//                    vc.savedCategoryObjArray = savedCategory
//                    vc.savedCategory = savedIdCategory
//                    navigationController?.pushViewController(vc, animated: true)
//                }
//                self.setPickerToTextField(textField)
            default:
                textField.inputView = nil
                break
            }
        }
        else
        {
           // 200 - type - Image/Video/Text
           // 300 - browse - Tappable
           // 400 - Option - text type
            if(textField.tag >= 400){
                
            }
            else if(textField.tag >= 300){
                
            }
            else if(textField.tag >= 200){
                setPickerToTextField(textField)
            }
        }
        
        
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    
    @objc func textFieldActive(_ txtField: UITextField) {
        setPickerToTextField(txtField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField.tag >= 1000){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.createPollOptionArray[textField.tag - 1000].optionText =  textField.text
            }
        }
        else if(textField.tag >= 400){
            
        }
        else if(textField.tag >= 300){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.createPollOptionArray[textField.tag - 300].title =  textField.text
            }
        }
        else if(textField.tag >= 200){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.createPollOptionArray[textField.tag - 200].title =  textField.text
            }
        }
       
        
       return true
      
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreatePollVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if(selectedButtonIndex == -1){
            comptitionImage  = info[UIImagePickerControllerEditedImage] as? UIImage
            imgCompetition.image = comptitionImage
        }
        else{
            UtilityManager.ShowHUD(text: "Please wait...")
            if let mediaType = info[UIImagePickerControllerMediaType] as? String {
                if ((info[UIImagePickerControllerOriginalImage] as? UIImage) != nil) {
              uploadMedia(imageTag: selectedButtonIndex, image: (info[UIImagePickerControllerEditedImage] as? UIImage)!)
            }
            else {
                if let url = info[UIImagePickerControllerMediaURL] as? URL {
//                    var playerItem = AVPlayerItem(url: url)
//                    var duration: CMTime = playerItem.duration
//                    var seconds: Float = Float(CMTimeGetSeconds(duration))
//
                    
                    
                    let videoData: Data = NSData(contentsOf: url as URL)! as Data
                    
                    //                    let dataSizeinKb = getdataSizeinMB(forData: videoData)
                    //                    if(dataSizeinKb > 5){
                    //                        self.showErrorAlert(title:"", errorMessage: "Video can't be greater than 5 mb.")
                    //                        return
                    //                    }
                    
                    //   if(self.validationMethod(data: videoData))!{
                    
                    //  DispatchQueue.main.async {
                    UtilityManager.ShowHUD(text: "Please wait...")
                    
                    // }
                    
                    Media.uploadVideo(url, progress: { (progress, completed) in
                        print("progress: \(progress)  completed: \(completed)")
                    }, error: { (errorMessage) in
                        picker.dismiss(animated: true, completion: nil)
                        print(errorMessage)
                    }, completion: { (video) in
                        //    DispatchQueue.main.async {
                        print("progress: Done" )
                            UtilityManager.RemoveHUD()
                        let videoData = video

                            self.createPollOptionArray[self.selectedButtonIndex].title =  (videoData.secure_url?.absoluteString)
                            let indexPath = IndexPath(row:self.selectedButtonIndex, section: 0)
                            self.tblCompition.reloadRows(at: [indexPath], with: .none)
                        
                        
//                        picker.dismiss(animated: true, completion: nil)
                       
                        UtilityManager.RemoveHUD()
                        //  }
                    })
                }
                //  }
                
            }
            }
//            comptitionImage  = info[UIImagePickerControllerEditedImage] as? UIImage
//            imgCompetition.image = comptitionImage
        }
        //        tblCompition.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreatePollVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(createPollOptionArray[selectedTxtField.tag - 200].type == ""){
            createPollOptionArray[selectedTxtField.tag - 200].type = typeArray[row]
        }
         return typeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTxtField.text = typeArray[row]
        if(createPollOptionArray[selectedTxtField.tag - 200].type != typeArray[row]){
            createPollOptionArray[selectedTxtField.tag - 200].title = ""
        }
        createPollOptionArray[selectedTxtField.tag - 200].type =  typeArray[row]
     
    
    }
}

