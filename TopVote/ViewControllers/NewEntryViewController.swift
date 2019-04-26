//
//  NewEntryViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
//import FPPicker
//import Parse
import AVFoundation
import AVKit
import MobileCoreServices
//import SDWebImage

protocol NewEntryViewControllerDelegate {
    func didSaveNewEntry(_ entry: Entry)
}

class NewEntryViewController: VideoPlayerViewController, UINavigationControllerDelegate {
//class NewEntryViewController: VideoPlayerViewController, FPPickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var txtViewMain: UIView!
    @IBOutlet weak var lblTextPlaceHolder: UILabel!
    @IBOutlet weak var lblCharLeft: UILabel!

    @IBOutlet weak var scrollViewEntry: UIScrollView!

    @IBOutlet weak var txtViewDesc: CustomeTPTextView!

    var entryMediaInfo: Media? {
        didSet {
            uploadButton.isSelected = (entryMediaInfo != nil)
        }
    }
    var competition: Competition?
    var delegate: NewEntryViewControllerDelegate?
    var isFirstTime = true

    var isUploading = false
    var isComeFromDeepLink = false

    // MARK: - ViewController Method

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(competition?.type == 2){
            scrollViewEntry?.isHidden = true
            txtViewMain.isHidden = false
            
        }
        else if (isFirstTime) {
            txtViewMain.isHidden = true
            scrollViewEntry?.isHidden = false

            isFirstTime = false
            chooseMedia()
        }
    }
    
    func refreshView() {
        imageView.isHidden = true
        
        if let entryMediaInfo = entryMediaInfo, let type = entryMediaInfo.type {
            if type == "IMAGE" {
                if let imageURL = entryMediaInfo.secure_url {
                    imageView.isHidden = false
                    imageView?.af_setImage(withURL: imageURL, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                    UtilityManager.RemoveHUD()
                    mediaView.removePlayer()
                }
            }
                
            if type == "VIDEO" ||  (type == "IMAGE-VIDEO" && (competition?.mediaUri?.contains(".mov"))!)  {
                if let url = entryMediaInfo.secure_url {
                    imageView.isHidden = true
                    mediaView.addPlayer(url)
                    UtilityManager.RemoveHUD()
                }
            }
        }
    }

    @IBAction func chooseMedia(_ sender: AnyObject) {
        chooseMedia()
    }
    
    @IBAction func enterCompetitionAction(_ sender: AnyObject) {
//        if (txtField.text?.isEmpty)!{
//            self.showErrorAlert(errorMessage: "Please input a title!")
//            return
//        }
//        else
        if txtViewDesc.text?.count == 0{
             self.showErrorAlert(title:"", errorMessage: "Please enter your words")
            return
        }
        else{
            UtilityManager.ShowHUD(text: "Please wait...")

            LocationManager.instance.getLocationAndName { (success, location, locationName) -> Void in
                if (success) {
                    
                    guard let accountId = AccountManager.session?.account?._id else {
                        return
                    }
                    guard let competitionId = self.competition?._id else {
                        return
                    }
                 
//                    guard let mediaType = self.entryMediaInfo?.type else {
//                        return
//                    }
                    var newEntry = [
                        "account": accountId,
                        "title": "text",
                        "mediaType": "TEXT",
                        "locationName": locationName ?? "Not provided",
                        "text" : self.txtViewDesc.text!
                        ] as [String : Any]
                    
                    if(self.tabBarController?.selectedIndex == 3 ){
                        newEntry["privateCompetition"] = competitionId
                    }
                    else
                    {
                        newEntry["competition"] = competitionId
                    }
                    
                    Entry.create(params: newEntry, error: { (errorMessage) in
                        DispatchQueue.main.async {
                            UtilityManager.RemoveHUD()
                            self.showErrorAlert(errorMessage: errorMessage)
                        }
                    }, completion: { (entry) in
                        DispatchQueue.main.async {
                            UtilityManager.RemoveHUD()
                            
                            let _ = self.navigationController?.popViewController(animated: true)
                            print("Share New Entry \(entry)")
                            self.delegate?.didSaveNewEntry(entry)
                        }
                    })
                } else {
                   // UtilityManager.RemoveHUD()

                    self.showErrorAlert(errorMessage: "Use of your location is required to enter. Please allow access in the settings app")
                }
            }
        }
    }
    
    func chooseMedia() {
        print("imagePickerController")

        print(self.competition?.type!)

        let alertController = UIAlertController(title: "How would you like to submit?", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .camera
                if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                    print("imagePickerController")

                    if(self?.competition?.type == 0){

                         imagePickerController.mediaTypes = [mediaTypes[0]]
                    }
                    else if(self?.competition?.type == 3){
                        imagePickerController.mediaTypes = [mediaTypes[0],mediaTypes[1]]

                    imagePickerController.videoMaximumDuration = 60
                        imagePickerController.allowsEditing = true
                    }
                    else{
                        
                         imagePickerController.mediaTypes = [mediaTypes[1]]
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
        
        var ActionTitle = "Image Library"
        
        if(self.competition?.type == 1){
            ActionTitle = "Video Library"
        }
        
        
        let photoLibraryAction = UIAlertAction(title: ActionTitle, style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = true

                imagePickerController.sourceType = .photoLibrary
                if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                    
                    if(self?.competition?.type == 0){
                        
                        imagePickerController.mediaTypes = [mediaTypes[0]]
                    }
                    else if(self?.competition?.type == 3){
                     imagePickerController.mediaTypes = [mediaTypes[0],mediaTypes[1]]
                        imagePickerController.videoMaximumDuration = 60
                        imagePickerController.allowsEditing = true
                    }
                    else  {
                        imagePickerController.mediaTypes = [mediaTypes[1]]
                        imagePickerController.videoMaximumDuration = 30
                        imagePickerController.allowsEditing = true
                    }
                 
                }
                imagePickerController.navigationBar.backgroundColor = Constants.appThemeColor
                imagePickerController.navigationBar.tintColor = Constants.appYellowColor

                imagePickerController.delegate = self
                imagePickerController.navigationItem.title = ActionTitle
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
        
        
//        let fpController = TVfpPickerController()
//        fpController.fpdelegate = self
//        if (MediaType(rawValue: self.competition.type) == MediaType.video) {
//            fpController.navigationController?.title = "Choose a Video"
//            fpController.dataTypes = ["video/*"]
//        } else {
//            fpController.navigationController?.title = "Choose a Photo"
//            fpController.dataTypes = ["image/*"]
//        }
//        fpController.sourceNames = [FPSourceCamera, FPSourceCameraRoll, FPSourceFacebook, FPSourceInstagram]
//        fpController.allowsEditing = true
//        fpController.videoMaximumDuration = 30
//
//        present(fpController, animated: true, completion: nil)
    }
    
//    func fpPickerController(_ pickerController: FPPickerController!, didFinishPickingMediaWith info: FPMediaInfo!) {
//        pickerController.dismiss(animated: true, completion: nil)
//
//        entryMediaInfo = info
//        refreshView()
//    }
//
//    func fpPickerControllerDidCancel(_ pickerController: FPPickerController!) {
//        pickerController.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func enterCompetitionTapped(_ sender: AnyObject) {
        enter()
    }

    func enter() {
        guard isUploading == false else {
            return
        }
        guard let competition = competition else {
            return
        }
        if (competition.hasEnded()) {
            self.showAlert(errorMessage: "The competition has ended")
        } else {
            guard let entryMediaInfo = entryMediaInfo else {
                self.showErrorAlert(errorMessage: "Upload failed.")
                return
            }
            if let name = captionTextField.text, name.count > 0 {
                UtilityManager.ShowHUD(text: "Please wait...")
                LocationManager.instance.getLocationAndName { (success, location, locationName) -> Void in
                    UtilityManager.RemoveHUD()
                    if (success) {
                        self.isUploading = true
                
                        guard let accountId = AccountManager.session?.account?._id else {
                            return
                        }
                        guard let competitionId = self.competition?._id else {
                            return
                        }
                        guard let mediaURL = entryMediaInfo.secure_url?.absoluteString else {
                            return
                        }
                        guard let mediaType = entryMediaInfo.type else {
                            return
                        }
                        
                        var newEntry = [
                            "account": accountId,
                            "title": name,
                            "mediaType": mediaType,
                            "mediaUri": mediaURL,
                            "locationName": locationName ?? "Not provided"
                        ] as [String : Any]
                        
                        if(self.tabBarController?.selectedIndex == 3 ){
                           newEntry["privateCompetition"] = competitionId
                        }
                        else
                        {
                            newEntry["competition"] = competitionId
                        }
                        
                        
                        if let thumbnail = entryMediaInfo.thumbnail?.absoluteString {
                            newEntry["mediaUriThumbnail"] = thumbnail
                        }
                
                        Entry.create(params: newEntry, error: { (errorMessage) in
                            DispatchQueue.main.async {
                                self.showErrorAlert(errorMessage: errorMessage)
                            }
                        }, completion: { (entry) in
                            DispatchQueue.main.async {
                                self.isUploading = false
                                if(self.isComeFromDeepLink){
                                      self.showErrorAlert(title:"Congratulation", errorMessage: "Your Entry has been submited successfully.")
                                self.navigationController?.popToRootViewController(animated: true)
                                    
                                }
                                else{
                                
                                let _ = self.navigationController?.popViewController(animated: true)
                                if(entry.competition?.autoApprove == 1){
                                    print("New Entry \(entry)")
                                self.delegate?.didSaveNewEntry(entry)
                                }
                                }
                            }
                        })
                    } else {
                        self.showErrorAlert(errorMessage: "Use of your location is required to enter. Please allow access in the settings app")
                    }
                }
            } else {
                self.showErrorAlert(errorMessage: "Please input a title!")
            }
        }
    }
    
    func getdataSizeinMB(forData data:Data) -> Double {
        let imageSize: Int = data.count
        let sizeinKB =  (Double(imageSize) / 1024.0)
        let sizeinMB =  sizeinKB / 1024.0
        return sizeinMB
    }
    
//
//    func cropVideo(sourceURL1: NSURL, statTime:Float, endTime:Float)
//    {
//        let manager = FileManager.default
//
//        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
//        guard let mediaType = "mp4" as? String else {return}
//        guard let url = sourceURL1 as? NSURL else {return}
//
//        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
//            let asset = AVAsset(URL: url as URL)
//            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
//            print("video length: \(length) seconds")
//
//            let start = statTime
//            let end = endTime
//
//            var outputURL = documentDirectory.URLByAppendingPathComponent("output")
//            do {
//                try manager.createDirectoryAtURL(outputURL, withIntermediateDirectories: true, attributes: nil)
//                let name = Moment.newName()
//                outputURL = outputURL.URLByAppendingPathComponent("\(name).mp4")
//            }catch let error {
//                print(error)
//            }
//
//            //Remove existing file
//            _ = try? manager.removeItemAtURL(outputURL)
//
//
//            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
//            exportSession.outputURL = outputURL
//            exportSession.outputFileType = AVFileTypeMPEG4
//
//            let startTime = CMTime(seconds: Double(start ?? 0), preferredTimescale: 1000)
//            let endTime = CMTime(seconds: Double(end ?? length), preferredTimescale: 1000)
//            let timeRange = CMTimeRange(start: startTime, end: endTime)
//
//            exportSession.timeRange = timeRange
//            exportSession.exportAsynchronouslyWithCompletionHandler{
//                switch exportSession.status {
//                case .Completed:
//                    print("exported at \(outputURL)")
//                    self.saveVideoTimeline(outputURL)
//                case .Failed:
//                    print("failed \(exportSession.error)")
//
//                case .Cancelled:
//                    print("cancelled \(exportSession.error)")
//
//                default: break
//                }
//            }
//        }
//    }
//
    func validationMethod(data : Data!) -> Bool? {

        if data != nil {
            let dataSizeinKb = getdataSizeinMB(forData: data)
          //  if(switchApi.isOn){ // microsoft
            if(dataSizeinKb > 5){
                    self.showErrorAlert(title:"", errorMessage: "Image and Video can't be greater than 5 mb.")
                    return false
                }
//            } else { // face PP
//                if(dataSizeinKb > 2){
//                    return MESSAGES.LARGE_IMAGE
//                }
//            }
            return true
        }
        return false
    }
}

extension NewEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        enter()
        return true
    }
}
extension NewEntryViewController: UITextViewDelegate {
    
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == #selector(select(_:))
//        {
//            return true
//        } else {
//            return false
//   //     }
//    }
//
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool{
//        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
//            return false
//        }
//        return super.canPerformAction(action, withSender: sender)
//    }
//
    
//    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
////        if action == #selector(copy(_:)) || action == #selector(paste(_:) || action == #selector(cut(_:)) {
////            return false
////        }
//
//        if(action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:))){
//            return false
//        }
//
//        return true
//    }
//    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
//        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
//            return false
//        }
//
//        return super.canPerformAction(action, withSender: sender)
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
          let txtAfterUpdate1 = newText.trimmingCharacters(in: .whitespacesAndNewlines)
            if ((txtAfterUpdate1.count) == 0) {
                lblCharLeft.text = "\(500 - (txtAfterUpdate1.count)) characters left"
                self.lblTextPlaceHolder.isHidden = false
                return true
            }
                
            lblCharLeft.text = "\(500 - (txtAfterUpdate1.count)) characters left"
            self.lblTextPlaceHolder.isHidden = true
            return true
            
        }
        
            if (textView.text as NSString?) != nil {
            
            let txtAfter = textView.text + text
                
                //(textView.text as NSString).replacingCharacters(in: range, with: text as String)

                let txtAfterUpdate = txtAfter.trimmingCharacters(in: .whitespacesAndNewlines)

          //  let txtAfterUpdate = text.replacingCharacters(in: range, with: text as String)
                if ((txtAfterUpdate.count) >= 500) {
                    lblCharLeft.text = "0 character left"
                return false
            }
                else if ((txtAfterUpdate.count) == 0) {
                    lblCharLeft.text = "\(500 - (txtAfterUpdate.count)) characters left"
                self.lblTextPlaceHolder.isHidden = false
                return true
                
            }
            else {
                
                    lblCharLeft.text = "\(500 - (txtAfterUpdate.count)) characters left"
                
                self.lblTextPlaceHolder.isHidden = true
                return true
                
            }
            
        }
        return true
       
   // }
    }
}
// MARK: - UIImagePickerControllerDelegate
extension NewEntryViewController: UIImagePickerControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        var ActionTitle = "Image Library"
        
        if(self.competition?.type == 1){
            ActionTitle = "Video Library"
        }
        viewController.navigationItem.title = ActionTitle
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            if mediaType == kUTTypeImage as String {
                if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                    if let fixedImage = pickedImage.fixedOrientation() {
                        if let data = UIImageJPEGRepresentation(fixedImage, 0.8) {
                            
//                            let dataSizeinKb = getdataSizeinMB(forData: data)
//                            if(dataSizeinKb > 5){
//                                self.showErrorAlert(title:"", errorMessage: "Image can't be greater than 5 mb.")
//                                return
//                            }
                            
//                            if(self.validationMethod(data: data))!{

                            let temporaryDirectory = NSTemporaryDirectory()
                            let fileName = UUID().uuidString + ".png"
                            if let imageFileURL = NSURL.fileURL(withPathComponents: [temporaryDirectory, fileName]) {
                                do {
                                    try data.write(to: imageFileURL, options: .atomic)
                                } catch {
                                    print("Writing image failed!")
                                }
                                DispatchQueue.main.async {
                                    UtilityManager.ShowHUD(text: "Please wait...")
                                }
                                Media.uploadPhoto(imageFileURL, progress: { (progress, completed) in
                                    print("progress: \(progress)  completed: \(completed)")
                                }, error: { (errorMessage) in
                                    print(errorMessage)
                                }, completion: { (photo) in
                                    DispatchQueue.main.async {
                                        // UtilityManager.RemoveHUD()
                                        self.entryMediaInfo = photo
                                        self.refreshView()
                                    }
                                })
                            }
                        }
                  //  }
                  }
                }
            } else if mediaType == kUTTypeMovie as String {
                if let url = info[UIImagePickerControllerMediaURL] as? URL {
                    var playerItem = AVPlayerItem(url: url)
                    var duration: CMTime = playerItem.duration
                    var seconds: Float = Float(CMTimeGetSeconds(duration))
                    
                   

                    let videoData: Data = NSData(contentsOf: url as URL)! as Data
                    
//                    let dataSizeinKb = getdataSizeinMB(forData: videoData)
//                    if(dataSizeinKb > 5){
//                        self.showErrorAlert(title:"", errorMessage: "Video can't be greater than 5 mb.")
//                        return
//                    }
                    
                 //   if(self.validationMethod(data: videoData))!{
                        
                        DispatchQueue.main.async {
                            UtilityManager.ShowHUD(text: "Please wait...")
                            
                    }
                    
                    Media.uploadVideo(url, progress: { (progress, completed) in
                        print("progress: \(progress)  completed: \(completed)")
                    }, error: { (errorMessage) in
                        print(errorMessage)
                    }, completion: { (video) in
                        DispatchQueue.main.async {
                           //UtilityManager.RemoveHUD()
                            self.entryMediaInfo = video
                            self.refreshView()
                        }
                    })
                 }
             //  }
             
           }
         }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
