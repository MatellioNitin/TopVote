//
//  CategoryVC.swift
//  Topvote
//
//  Created by CGT on 24/08/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import UIKit

class CreateCompititionVC: UIViewController {
    
    
    @IBOutlet weak var imgCompetition: UIImageView!
    
    @IBOutlet weak var txtName: CustomUITextField!
    
    @IBOutlet weak var txtStartDate: CustomUITextField!
    
    @IBOutlet weak var txtEndDate: CustomUITextField!
    
    @IBOutlet weak var txtDescription: CustomUITextField!
    
    @IBOutlet weak var txtCategory: CustomUITextField!
    
    @IBOutlet var btnCompType: [UIButton]!
    
    @IBOutlet var btnContentType: [UIButton]!
    @IBOutlet weak var tblCompition: UITableView!
    
    @IBOutlet weak var btnCategory: UIButton!
    
    let picker = UtilityManager.normalPicker()
    var pickerDate = UtilityManager.picker_Date_Create()

    var compititionObj = Competition()

    var createCompArray = CreateCompititions()
    var pickerArr = [String]()
    var comptitionImage:UIImage?  = nil
    var comptitionImageURL:String?  = ""
    var selectedTxtField = UITextField()
    var selectedButtonIndex:Int = 1  // 1= compition, 2= logo
    let dateFormatter = DateFormatter()
    var categoryArray = Categorys()
    var savedCategory = Categorys()
    var savedIdCategory = NSMutableArray()
    var isPrivateCheck:Bool! = false
    var isVideo:Bool! = false
    var isPhoto:Bool! = false

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
        if(compititionObj._id != nil){
            self.navigationItem.title = "Edit Competition"
            updateListData()
        }
        else
        {
            self.navigationItem.title = "Create Competition"
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
            if(competitions.count > 0){
                var isAllSelecct = true
                
                if(self!.compititionObj._id != nil && self!.compititionObj.isPrivate == 0 ){
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
        
        
//        comptitionImageURL = "https://res.cloudinary.com/top-inc/image/upload/v1536164836/i3mpxnqhbytjx0bjyse3.jpg"
        
    //let logoImageURL = "https://res.cloudinary.com/top-inc/image/upload/v1536164851/xubrdgbpxnxaensfjjfm.jpg"
//        let date = localToUTC(date:createCompArray[1].value!)
        
        if(!isPrivateCheck){
            var type = ""
            if(isPhoto && isVideo){
                type = "3"
            }
            else if(isPhoto && !isVideo)
            {
                type = "0"
            }
            else
            {
                type = "1"
            }
            
            params["type"] = type
            params["category"] = savedIdCategory
            
            // category (category > Array)
        }
        else
        {
            params["type"] = "3"
        }
        
        params["title"] = txtName.text!
        params["text"] =  txtDescription.text!
        //params["type"] = "\(index!)"
        params["mediaUri"] = comptitionImageURL!
        params["byImageUri"] = ""
        params["startDate"] = localToUTC(date:txtStartDate.text! + "00:00:00")
        params["endDate"] = localToUTC(date:txtEndDate.text!  +  "23:59:59")
        if let user = AccountManager.session?.account {
        params["byText"] = user.displayUserName
        }
        params["owner"] = (AccountManager.session?.account?._id)!
   
        if(isPrivateCheck){
            
            PCompitionCreate.find(queryParams: params, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(title:"Congratulation", errorMessage: "Your Private competiton is created successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else
        {
            PCompitionCreate.createPublicComp(queryParams: params, error: {  (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(title:"Congratulation", errorMessage: "Your competiton is created successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        
    }
    
    
    func updateAPI()  {
        
        // let index = pickerArr.index(of: createCompArray[4].value!)
        var params = [String: Any]()
        
        //        comptitionImageURL = "https://res.cloudinary.com/top-inc/image/upload/v1536164836/i3mpxnqhbytjx0bjyse3.jpg"
        
        //let logoImageURL = "https://res.cloudinary.com/top-inc/image/upload/v1536164851/xubrdgbpxnxaensfjjfm.jpg"
        //        let date = localToUTC(date:createCompArray[1].value!)
        
        
       // 1 = Video, 2 = Image, 0 = Text
        if(!isPrivateCheck){
            var type = ""
            if(isPhoto && isVideo){
                type = "3"
            }
            else if(isPhoto && !isVideo)
            {
                type = "0"
            }
            else
            {
                type = "1"
            }
            
            
            
            params["type"] = type
            params["category"] = savedIdCategory


           // category (category > Array)
        }
        else
        {
            params["type"] = "3"

        }
        params["title"] = txtName.text!
        params["text"] =  txtDescription.text!
        //params["type"] = "\(index!)"
        params["mediaUri"] = comptitionImageURL!
        params["byImageUri"] = ""
        params["startDate"] = localToUTC(date:txtStartDate.text! + "00:00:00")
        params["endDate"] = localToUTC(date:txtEndDate.text!  +  "23:59:59")
        if let user = AccountManager.session?.account {
            params["byText"] = user.displayUserName
        }
        params["owner"] = (AccountManager.session?.account?._id)!
        
        if(isPrivateCheck){
            PCompitionCreate.updatePrivateComp(compId: compititionObj._id!, params: params, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(title:"Congratulation", errorMessage: "Your Private competiton is updated successfully")
                    self.navigationController?.popViewController(animated: true)
            }})
        }
        else
        {
            PCompitionCreate.updatePublicComp(compId: compititionObj._id!, queryParams: params, error: { (errorMessage) in
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    UtilityManager.RemoveHUD()
                    self.showErrorAlert(title:"Congratulation", errorMessage: "Your competiton is updated successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        
    }
    
    // MARK: - IBAction Method

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCompTypeAction(_ sender: UIButton) {
        if((self.navigationItem.title?.contains("Edit"))!){
            return
        }
        
        if(sender == btnCompType[0]){
            setPublicData()
        }
        else
        {
            setPrivateData()
        }
    }
    

    
    @IBAction func btnContentTypeAction(_ sender: UIButton) {
        if(sender == btnContentType[0]){
            if(sender.currentImage == UIImage(named:"check")){
                sender.setImage(UIImage(named:"uncheck"), for: .normal)
                isPhoto = false
                
            }
            else
            {
                sender.setImage(UIImage(named:"check"), for: .normal)
                isPhoto = true

            }
       
        }
        else{
            if(sender.currentImage == UIImage(named:"check")){
                sender.setImage(UIImage(named:"uncheck"), for: .normal)
                isVideo = false
                
            }
            else
            {
                sender.setImage(UIImage(named:"check"), for: .normal)
                isVideo = true

            }
        }
        
       
        
        
    }
    
    @IBAction func btnPickerAction(_ sender: UIButton) {
        selectedTxtField.resignFirstResponder()
        if(sender.tag == 102){
            txtStartDate.becomeFirstResponder()
        }
        else  if(sender.tag == 103){
            txtEndDate.becomeFirstResponder()
        }
        else
        {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
               vc.currentVC = self
                vc.savedCategoryObjArray = savedCategory
                vc.savedCategory = savedIdCategory
                navigationController?.pushViewController(vc, animated: true)
//            txtCategory.becomeFirstResponder()
        }
    }
    }

    
    @IBAction func buttonImageAction(_ sender: UIButton) {
        // selectedButtonIndex = sender.tag
        chooseMedia()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if(isValidForm()){
            UtilityManager.ShowHUD(text: "Please wait...")
            uploadMedia(imageTag: 1, image: comptitionImage!)
        }
        
    }
    
    
    // MARK: - Custom Method
    
    func setData(){
        if(compititionObj._id != nil && comptitionImage == nil){
            
            if let profileImageUri = compititionObj.mediaUri, let uri = URL(string: profileImageUri) {
                imgCompetition.af_setImage(withURL: uri, placeholderImage:  UIImage(named: "upload"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false, completion: { (image) in
                    if let image = image.value {
                        self.comptitionImage = image
                    }
                })
            }
            else
            {
                imgCompetition.image = comptitionImage
            }
            
            txtName.text = compititionObj.title!
            txtStartDate.text = compititionObj.startDate!.formattedDateOnlyForFullYear()
            txtEndDate.text = compititionObj.endDate!.formattedDateOnlyForFullYear()
            txtDescription.text = compititionObj.text!
            
        }
        else
        {
            if(comptitionImage != nil){
                imgCompetition.image = comptitionImage
            }
            else{
                imgCompetition.image = UIImage(named:"upload")
            }
            
            txtStartDate.isUserInteractionEnabled = false
            txtStartDate.alpha = 0.5
        }
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
                            if(imageTag == 1){
                                self.comptitionImageURL = (photoData.secure_url?.absoluteString)
                                
                         
                                    if(self.compititionObj._id != nil){
                                        self.updateAPI()
                                        
                                    }
                                    else{
                                        self.submitAPI()
                                    }
                                
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

    func setPickerToTextField(_ textField: UITextField) {
        
        picker.reloadAllComponents()
        textField.inputView = picker
    if(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            picker.selectRow(0, inComponent: 0, animated: false)
        
        } else {
            let textTofound = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let object = categoryArray.filter { $0.name == textTofound}
        
        picker.selectRow(categoryArray.firstIndex(of: object.last!)!, inComponent: 0, animated: false)
        
            }
        
        
    if(pickerArr.count > 0){
            //let txt:String!
        let strSet = pickerArr[picker.selectedRow(inComponent: 0)]
            DispatchQueue.main.async { [unowned self] in
            textField.text = strSet
            
            }
        }
    }
    
    func updateListData(){
        
        txtName.text =  compititionObj.title!
        txtStartDate.text =  compititionObj.startDate!.formattedDateOnlyForFullYear()
        txtEndDate.text =  compititionObj.endDate!.formattedDateOnlyForFullYear()
        txtDescription.text =  compititionObj.text!
        if let profileImageUri = compititionObj.mediaUri, let uri = URL(string: profileImageUri) {
           imgCompetition.af_setImage(withURL: uri, placeholderImage:  UIImage(named: "upload"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false, completion: { (image) in
                if let image = image.value {
                    self.comptitionImage = image
                }
            })
        }
        
        if(compititionObj.isPrivate == 0){
            btnCompType[0].setImage(UIImage(named:"radio_On"), for: .normal)
            btnCompType[1].setImage(UIImage(named:"radio_Off"), for: .normal)
            setPublicData()
        }
        else
        {
            setPrivateData()
            btnCompType[0].setImage(UIImage(named:"radio_Off"), for: .normal)
            btnCompType[1].setImage(UIImage(named:"radio_On"), for: .normal)
        }
        
        if(compititionObj.type == 0){
            self.btnContentType[0].setImage(UIImage(named:"check"), for: .normal)
            self.btnContentType[1].setImage(UIImage(named:"uncheck"), for: .normal)
            isPhoto = true
            isVideo = false
        }
        else if(compititionObj.type == 1){
            self.btnContentType[1].setImage(UIImage(named:"check"), for: .normal)
            self.btnContentType[0].setImage(UIImage(named:"uncheck"), for: .normal)
            isPhoto = false
            isVideo = true
            
        }
//        else if(compititionObj.type == 2){
//            self.btnContentType[0].setImage(UIImage(named:"check"), for: .normal)
//            self.btnContentType[1].setImage(UIImage(named:"uncheck"), for: .normal)
//
//        }
        else{
            //if(compititionObj.type == 3){
            self.btnContentType[0].setImage(UIImage(named:"check"), for: .normal)
            self.btnContentType[1].setImage(UIImage(named:"check"), for: .normal)
            isPhoto = true
            isVideo = true
        }
        
       // savedIdCategory =
      
        
        

    }
    
    
    func setListData(){
        for i in 0...4{
            let obj = CreateCompitition()
            switch i {
            case 0:
                obj.setData(type: 1, titleStr: "Name your competition", placeHolderStr:"For example: Best Haircut", valueStr: "", pickerArrayList: [])
            case 1:
                obj.setData(type: 3, titleStr: "Select start date", placeHolderStr:"Start date", valueStr: "", pickerArrayList: [])
            case 2:
                obj.setData(type: 3, titleStr: "Select end date", placeHolderStr:"End date", valueStr: "", pickerArrayList: [])
            case 3:
                obj.setData(type: 1, titleStr: "Describe your competition for your friends", placeHolderStr:"This is a description of your competition", valueStr: "", pickerArrayList: [])
            case 4:
                obj.setData(type: 1, titleStr: "Category", placeHolderStr:"Select Category", valueStr: "", pickerArrayList: [])
                
                //        case 4:
                //          obj.setData(type: 2, titleStr: "Select competition entries", placeHolderStr:"Select competition entries", valueStr: "Image & Video", pickerArrayList: ["Image & Video"])
                
            default:
                print("default")
            }
            
            createCompArray.append(obj)
            
        }
        
        tblCompition.reloadData()
    }
    
    @objc func doneButtonWiithModuleAction(done : UITextField){
        selectedTxtField.resignFirstResponder()
    }
    
    func isValidForm()-> Bool{
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        if(comptitionImage == nil){
            self.showErrorAlert(errorMessage: "Please select competiton image")
            return false
            
        }
        else if(txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please enter name of competition.")
            return false
        }
            //        else if(createCompArray[1].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            //
            //          self.showErrorAlert(title:"", errorMessage: "Please ") // Please enter by text
            //        return false
            //
            //        }
        else if(txtStartDate.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please select start date of competition.")
            return false
            
        }
        else if(txtEndDate.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please select end date of competition.")
            return false
            
        }
        else if dateFormatter.date(from: txtStartDate.text!)?.compare(dateFormatter.date(from: txtEndDate.text!)!) == .orderedDescending{
            
            self.showErrorAlert(title:"", errorMessage: "Start date can't be greater than to end date")
            return false
        }
        else if compareDate(date1: dateFormatter.date(from: txtStartDate.text!)!, date2: Date()) && compititionObj._id == nil{
            
            // else if dateFormatter.date(from: createCompArray[1].value!)!.compare(Date()) == .orderedAscending{
            self.showErrorAlert(title:"", errorMessage: "Start date can't be less than to current date")
            return false
            
        }
        else if compareDate(date1: dateFormatter.date(from: txtEndDate.text!)!, date2: Date()){
            //  else if dateFormatter.date(from: createCompArray[2].value!)!.compare(Date()) == .orderedAscending{
            self.showErrorAlert(title:"", errorMessage: "End date can't be less than to current date")
            return false
        }
            
       else if(!isPrivateCheck && !isPhoto && !isVideo){
            self.showErrorAlert(title:"", errorMessage: "Please select content type.")
            return false
        }
            
//        else if(txtDescription.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
//            self.showErrorAlert(title:"", errorMessage: "Please enter description of competition.")
//            return false
//
//        }
//        else if(categoryArray.count == 0){
//            self.showErrorAlert(title:"", errorMessage: "Please select atlease one category.")
//            return false
//            
//        }
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
    
    func setPrivateData(){
        isPrivateCheck = true
        btnCompType[0].setImage(UIImage(named:"radio_Off"), for: .normal)
        btnCompType[1].setImage(UIImage(named:"radio_On"), for: .normal)
        txtCategory.isEnabled = false
        btnCategory.isEnabled = false
        
        btnCategory.backgroundColor = UIColor.lightGray
        btnCategory.alpha = 0.1
        txtCategory.alpha = 0.6
        
        btnContentType[0].isEnabled = false
        btnContentType[1].isEnabled = false
    }
    
    func setPublicData(){
        isPrivateCheck = false

        btnCompType[0].setImage(UIImage(named:"radio_On"), for: .normal)
        btnCompType[1].setImage(UIImage(named:"radio_Off"), for: .normal)
        btnCategory.isEnabled = true
        txtCategory.isEnabled = true
        btnCategory.backgroundColor = UIColor.clear
        btnCategory.alpha = 1.0
        txtCategory.alpha = 1.0
        btnContentType[0].isEnabled = true
        btnContentType[1].isEnabled = true
        
        if(compititionObj.category != nil && compititionObj.category!.count > 0){
            savedIdCategory = NSMutableArray(array: compititionObj.category!)
        if(categoryArray.count != 0){
            fillCategoryObjectInArrayt()
            setCategory()
        }
        }
     
       
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
            let index = categoryArray.index(of: savedCategory[i])
            nameArray.append(categoryArray[index!].name!)
        }
        txtCategory.text = nameArray.joined(separator: ", ")
    }
    }
}

extension CreateCompititionVC :UITableViewDataSource, UITableViewDelegate {
    
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
        if(indexPath.row == 0){
            return (tableView.frame.width * 250/580)
        }
        switch indexPath.row {
        case 2, 3, 4:
            return (tableView.frame.width * 130/580)
        default:
            return (tableView.frame.width * 130/580)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createCompArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set cell Identifier
        let identifier: String
        switch indexPath.row {
        case 0:
            identifier = "ImageCell"
        case 2, 3:
            identifier = "DateTimeCell"
        default:
            identifier = "TextCell"
        }
        
        // set cell UI delegate (and data in case last cell with "save btn")
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CommonCell
    
        if(indexPath.row == 0){
            cell.btnCompition.tag = 1
            if(compititionObj._id != nil && comptitionImage == nil){
                
                if let profileImageUri = compititionObj.mediaUri, let uri = URL(string: profileImageUri) {
                    cell.imgCompetition.af_setImage(withURL: uri, placeholderImage:  UIImage(named: "upload"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false, completion: { (image) in
                        if let image = image.value {
                            self.comptitionImage = image
                        }
                    })
                }
                else
                {
                     cell.imgCompetition.image = comptitionImage
                }
            }
            else
            {
                if(comptitionImage != nil){
                    cell.imgCompetition.image = comptitionImage
                    //cell.btnCompition.setImage(comptitionImage, for: .normal)
                }
                else{
                     cell.imgCompetition.image = UIImage(named:"upload")
                //cell.btnCompition.setImage(UIImage(named:"upload"), for: .normal)
                }
            }
       
            cell.btnCompition.addTarget(self, action:#selector(self.buttonImageAction(_:)), for: .touchUpInside)
        }
        else if(indexPath.row == 2 || indexPath.row == 3)
        {
            let dict = createCompArray[indexPath.row-1]
            
            cell.lblTitle.text = dict.title
//            cell.txtDate.placeholder = "Select Date"
            //cell.txtTime.placeholder = "Select Time"

            cell.txtDate.tag = 100 + indexPath.row
           // cell.txtTime.tag = 200 + indexPath.row
            
            cell.txtDate.delegate = self
            cell.txtDate.text = dict.value
            
            if(indexPath.row == 2 && compititionObj._id != nil){
                cell.txtDate.isUserInteractionEnabled = false
                cell.txtDate.alpha = 0.5
            }
            
           // cell.txtTime.delegate = self

        }
        else
        {
            
            let dict = createCompArray[indexPath.row-1]
            cell.lblTitle.text = dict.title
            cell.txtField.placeholder = dict.placeHolder
            cell.txtField.text = dict.value
            cell.txtField.returnKeyType = .next
            cell.txtField.tag = indexPath.row - 1
            cell.txtField.delegate = self
            cell.txtField.keyboardType = .default
            if(indexPath.row == 5){
                cell.txtField.isEnabled = false
                cell.txtField.tintColor = UIColor.white
            }
            else
            {
                cell.txtField.tintColor = UIColor.black
            }
        }
        
        cell.txtField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return cell
    }

}

extension CreateCompititionVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTxtField = textField

        switch textField {
        case txtStartDate, txtEndDate:
            dateFormatter.dateFormat = "MM/dd/yyyy"
            pickerDate.datePickerMode = .date
            self.setDatePickerToTextField(textField)
        case txtCategory:
            self.setPickerToTextField(textField)
        default:
            textField.inputView = nil
            break
        }
        
        return true
    }
    
 
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        return true
    }
    
    
    
    @objc func textFieldDidChange(_ txtField: UITextField) {
       // createCompArray[txtField.tag].value = txtField.text
        // set Data into cells
//        switch txtField.tag {
//        case 0: // user firstname last name
//
//        case 1: // user email
//        case 2: // user Password
//        case 3: // user confirmPassword
//        case 4: // user phone Number
//        case 5: // user Address
//        case 6: // user country
//           // if let country = self.countryArr.first(where: {$0.name == txtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)}) {
//             //   self.sighUpData.country = country
//          //  }
//        default:
//            break
//        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
//        switch textField.tag {
//        case 2,3 :
//            if (string == " "){
//                return false
//            }
//            if ((textField.text?.count)! < 30 || string == ""){
//                return true
//            } else {
//                return false
//            }
//        case 4:
//            if (((textField.text?.count)! < 30 && string.isNumeric) || string == ""){
//                return true
//            } else {
//                return false
//            }
//        case 5, 8:
//            if ((textField.text?.count)! < 256 || string == ""){
//                return true
//            } else {
//                return false
//            }
//        default:
//            if ((textField.text?.count)! < 30 || string == ""){
//                return true
//            } else {
//                return false
//            }
//        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        
        return true
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension CreateCompititionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if(selectedButtonIndex == 1){
         comptitionImage  = info[UIImagePickerControllerEditedImage] as? UIImage
        imgCompetition.image = comptitionImage
        }
//        tblCompition.reloadData()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateCompititionVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let objectList:Category = categoryArray[row]
            return objectList.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let objectList:Category = categoryArray[row]
            txtCategory.text = objectList.name
    }
    
}




