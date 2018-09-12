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
    @IBOutlet weak var txtField: CustomUITextField!
    @IBOutlet weak var txtViewDesc: RoundedTextView!

    
    
    var entryMediaInfo: Media? {
        didSet {
            uploadButton.isSelected = (entryMediaInfo != nil)
        }
    }
    var competition: Competition?
    var delegate: NewEntryViewControllerDelegate?
    var isFirstTime = true
    var isUploading = false

    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if(competition.sType == "text"){
//            txtViewMain.isHidden = false
//            scrol
//        }
        //else
        if (isFirstTime) {
            txtViewMain.isHidden = true

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
                    mediaView.removePlayer()
                }
            }
                
            if (type == "VIDEO") {
                if let url = entryMediaInfo.secure_url {
                    imageView.isHidden = true
                    mediaView.addPlayer(url)
                }
            }
        }
    }

    @IBAction func chooseMedia(_ sender: AnyObject) {
        chooseMedia()
    }
    
    @IBAction func enterCompetitionAction(_ sender: AnyObject) {
        
    }
    func chooseMedia() {
        
        let alertController = UIAlertController(title: "How would you like to submit?", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                    imagePickerController.mediaTypes = mediaTypes
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
                    imagePickerController.mediaTypes = mediaTypes
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
                LocationManager.instance.getLocationAndName { (success, location, locationName) -> Void in
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
                            "competition": competitionId,
                            "title": name,
                            "mediaType": mediaType,
                            "mediaUri": mediaURL,
                            "locationName": locationName ?? "Not provided"
                        ] as [String : Any]
                        
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
                                let _ = self.navigationController?.popViewController(animated: true)
                                self.delegate?.didSaveNewEntry(entry)
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
    
}

extension NewEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        enter()
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension NewEntryViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            if mediaType == kUTTypeImage as String {
                if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    if let fixedImage = pickedImage.fixedOrientation() {
                        if let data = UIImageJPEGRepresentation(fixedImage, 0.8) {
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
                                        self.entryMediaInfo = photo
                                        self.refreshView()
                                    }
                                })
                            }
                        }
                    }
                }
            } else if mediaType == kUTTypeMovie as String {
                if let url = info[UIImagePickerControllerMediaURL] as? URL {
                    print(url)
                    Media.uploadVideo(url, progress: { (progress, completed) in
                        print("progress: \(progress)  completed: \(completed)")
                    }, error: { (errorMessage) in
                        print(errorMessage)
                    }, completion: { (video) in
                        DispatchQueue.main.async {
                            self.entryMediaInfo = video
                            self.refreshView()
                        }
                    })
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
