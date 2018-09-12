//
//  CategoryVC.swift
//  Topvote
//
//  Created by CGT on 24/08/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import UIKit

class CreateCompititionVC: UIViewController {
    
    @IBOutlet weak var tblCompition: UITableView!
    
    let picker = UtilityManager.normalPicker()
    var pickerDate = UtilityManager.picker_Date_Create()

    var createCompArray = CreateCompititions()
    var pickerArr = [String]()
    
    var comptitionImage:UIImage?  = nil
    
    var comptitionImageURL:String?  = ""
    
    var selectedTxtField = UITextField()
    var selectedButtonIndex:Int = 1  // 1= compition, 2= logo
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        pickerDate.datePickerMode = .date
        
        picker.dataSource = self
        picker.delegate = self
        pickerDate.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        pickerDate.minimumDate = Date()
        setListData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnAddImageTapped(_ sender: UIButton) {
        imagePickerManager.showImageOptionAt(vc: self)
    }
    
    func setListData(){
        for i in 0...4{
        let obj = CreateCompitition()
        switch i {
        case 0:
            obj.setData(type: 1, titleStr: "Title", placeHolderStr:"Title", valueStr: "", pickerArrayList: [])
        case 1:
             obj.setData(type: 3, titleStr: "Start Date (UTC) The date/time when the competition will automatically start. UTC is -4 hours of EST.", placeHolderStr:"Start date", valueStr: "", pickerArrayList: [])
        case 2:
           obj.setData(type: 3, titleStr: "End Date (UTC) The date/time when the competition will expire and winners will be chosen. UTC is -4 hours of EST.", placeHolderStr:"End date", valueStr: "", pickerArrayList: [])
        case 3:
           obj.setData(type: 1, titleStr: "Text Description text shown on the entries screen.", placeHolderStr:"Text", valueStr: "", pickerArrayList: [])
        case 4:
          obj.setData(type: 2, titleStr: "Type Acceptable content", placeHolderStr:"Select Type", valueStr: "", pickerArrayList: ["Image","Video", "Text"])
      
        default:
            print("default")
        }
            
           createCompArray.append(obj)

        }

        tblCompition.reloadData()
    }
    
    @IBAction func buttonImageAction(_ sender: UIButton) {
        selectedButtonIndex = sender.tag
        chooseMedia()
    }
    
    
    
    
    @IBAction func saveTapped(_ sender: Any) {
        if(isValidForm()){
            UtilityManager.ShowHUD(text: "Please wait...")
            uploadMedia(imageTag: 1, image: comptitionImage!)
        //submitAPI()
        }
        
    }
    func isValidForm()-> Bool{

        if(comptitionImage == nil){
            self.showErrorAlert(errorMessage: "Please select competiton image")
            return false
            
        }
    else if(createCompArray[0].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please enter title")
        return false
        }
        else if(createCompArray[1].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
        
          self.showErrorAlert(title:"", errorMessage: "Please enter by text")
        return false

        }
        else if(createCompArray[1].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please select start date")
        return false

        }
        else if(createCompArray[2].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
         self.showErrorAlert(title:"", errorMessage: "Please select end date")
        return false

        }
        else if dateFormatter.date(from: createCompArray[1].value!)?.compare(dateFormatter.date(from: createCompArray[2].value!)!) == .orderedDescending{
            
            self.showErrorAlert(title:"", errorMessage: "Start date can't be greater than to end date")
            return false
        }
//        else if dateFormatter.date(from: createCompArray[2].value!)?.compare(Date()) == .orderedAscending{
//            self.showErrorAlert(title:"", errorMessage: "Start date can't be less than to current date")
//            return false
//
//        }
//        else if dateFormatter.date(from: createCompArray[3].value!)?.compare(Date()) == .orderedAscending{
//            self.showErrorAlert(title:"", errorMessage: "End date can't be less than to current date")
//            return false
//
//        }
        else if(createCompArray[3].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            self.showErrorAlert(title:"", errorMessage: "Please enter description")
        return false

        }
    else if(createCompArray[4].value?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
        self.showErrorAlert(title:"", errorMessage: "Please select competitons type")
        return false

        }
   
    else
    {
        return true

    }
}
    
    func submitAPI()  {
        
      let index = pickerArr.index(of: createCompArray[4].value!)
        var params = [String: Any]()
        
        
//        comptitionImageURL = "https://res.cloudinary.com/top-inc/image/upload/v1536164836/i3mpxnqhbytjx0bjyse3.jpg"
        
    //let logoImageURL = "https://res.cloudinary.com/top-inc/image/upload/v1536164851/xubrdgbpxnxaensfjjfm.jpg"
        
        
        params["title"] = createCompArray[0].value!
        params["text"] = createCompArray[3].value!
        params["type"] = "\(index!)"
        params["mediaUri"] = comptitionImageURL!
        params["byImageUri"] = ""
        params["startDate"] = createCompArray[1].value!
        params["endDate"] = createCompArray[2].value!
        params["byText"] = "Text"
        params["owner"] = (AccountManager.session?.account?._id)!
   
    
        PCompitionCreate.find(queryParams: params, error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                        self?.showErrorAlert(errorMessage: errorMessage)
                }
            }) { [weak self] (competitions) in
                    DispatchQueue.main.async {
                        
                        UtilityManager.RemoveHUD()
                    self?.showErrorAlert(title:"Congratulation", errorMessage: "Your Private competiton is created successfully")
                        self?.navigationController?.popViewController(animated: true)
    
    }
    }
    
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                                self.submitAPI()

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
                imagePickerController.sourceType = .camera
                if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                    imagePickerController.mediaTypes = [mediaTypes[0]]
                }
                imagePickerController.delegate = self
                self?.present(imagePickerController, animated: true, completion: nil)
            } else {
                self?.showAlert(title: "Oops!", confirmTitle: "Ok", errorMessage: "Please allow access to your camera.", actions: nil, confirmCompletion: nil, completion: nil)
            }
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
           
                if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                    imagePickerController.mediaTypes = [mediaTypes[0]]
                }
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
        
        let strSet = dateFormatter.string(from: pickerDate.date)
        DispatchQueue.main.async { [unowned self] in
            let cell = self.tblCompition.cellForRow(at: IndexPath(row:self.selectedTxtField.tag + 1, section: 0)) as! CommonCell
            DispatchQueue.main.async {
                cell.txtField.text = strSet
            }
        }
    }
    
    func setDatePickerToTextField(_ textField: UITextField) {
      
        textField.inputView = pickerDate
    if(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            pickerDate.date = Date()
        } else {
        
            let textTofound = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let date = dateFormatter.date(from: textTofound!)
            pickerDate.date = date!
        
            
        }
 
        let strSet = dateFormatter.string(from: pickerDate.date)
        DispatchQueue.main.async { [unowned self] in
                textField.text = strSet
        }
    }

    
    func setPickerToTextField(_ textField: UITextField) {
        if(textField.tag == 4){
            pickerArr = createCompArray[selectedTxtField.tag].arrayList
        }
        
        picker.reloadAllComponents()
        textField.inputView = picker
    if(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            picker.selectRow(0, inComponent: 0, animated: false)
        
        } else {
            let textTofound = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            if(textField.tag == 6){
        let index1 =  pickerArr.index(of: textTofound!)
                picker.selectRow(index1!, inComponent: 0, animated: false)
          //  }
        
            }
        
        
    if(pickerArr.count > 0){
            //let txt:String!
        let strSet = pickerArr[picker.selectedRow(inComponent: 0)]
            DispatchQueue.main.async { [unowned self] in
            textField.text = strSet
            
            }
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
            return (tableView.frame.width * 120/580)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return (tableView.frame.width * 250/580)
        }
        switch indexPath.row {
        case 2, 3, 4:
            return (tableView.frame.width * 150/580)
        default:
            return (tableView.frame.width * 120/580)
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
        default:
            identifier = "TextCell"
        }
        
        // set cell UI delegate (and data in case last cell with "save btn")
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CommonCell
    
        if(indexPath.row == 0){
            cell.btnCompition.tag = 1
            
            if(comptitionImage != nil){
                cell.btnCompition.setImage(comptitionImage, for: .normal)
            }
            else{
            cell.btnCompition.setImage(UIImage(named:"upload"), for: .normal)
            }
       
            cell.btnCompition.addTarget(self, action:#selector(self.buttonImageAction(_:)), for: .touchUpInside)
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
     
        }
        return cell
    }
    
    
    
    
}

extension CreateCompititionVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTxtField = textField
        let dict = createCompArray[textField.tag]

        switch textField.tag {
        case 1:
            self.setDatePickerToTextField(textField)
        case 2:
            self.setDatePickerToTextField(textField)
        case 4:
            pickerArr = dict.arrayList
            self.setPickerToTextField(textField)
        default:
            textField.inputView = nil
            break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        if(textField.placeholder == "Last Name") {
//            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CustomTableViewCell
//            DispatchQueue.main.async {
//                cell.txtField?.placeHolderLabel.textColor = kColor.textFieldActive
//            }
//
//        } else if (textField.tag == 1 ){
//            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CustomTableViewCell
//            DispatchQueue.main.async {
//                cell.txtField?.placeHolderLabel.textColor = kColor.textFieldInActive
//            }
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      //  if(textField.placeholder == "Last Name" && selectedTxtField.tag != 0) {
//            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CustomTableViewCell
//            DispatchQueue.main.async {
//                cell.txtField?.placeHolderLabel.textColor = kColor.textFieldInActive
//            }
    //    }
        
        if(textField.tag == 6){
         
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      
        createCompArray[textField.tag].value = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc func textFieldDidChange(_ txtField: UITextField) {
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
         comptitionImage  = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        tblCompition.reloadData()
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
        return pickerArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedTxtField.tag {
        case 4: //
            let dict = createCompArray[selectedTxtField.tag]
            return dict.arrayList[row]
//        case 7: // state
//            let dict = createCompArray[selectedTxtField.tag]
//            return dict.arrayList[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedTxtField.tag {
        case 4: // image, video, text
            createCompArray[selectedTxtField.tag].value = pickerArr[row]
            selectedTxtField.text = pickerArr[row]
            
//        case 7: // featured or not
//                createCompArray[selectedTxtField.tag].value = pickerArr[row]
//                selectedTxtField.text = pickerArr[row]
        default:
            break
        }
    }
    
}




