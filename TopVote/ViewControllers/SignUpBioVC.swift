//
//  SignUpBioVC.swift
//  Topvote
//
//  Created by NitinRaj on 30/09/19.
//  Copyright © 2019 Top, Inc. All rights reserved.
//

import UIKit

class SignUpBioVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtViewBio: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var whiteBGView: UIView!
    
    var tbvc: UITabBarController!
    var image: UIImage!
    var mediaInfo: Media?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let profileImageUri = AccountManager.session?.account?.profileImageUri, let uri = URL(string: profileImageUri) {
            imgUser.af_setImage(withURL: uri, placeholderImage:  UIImage(named: "profile-default-avatar"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false, completion: { (image) in
                if let image = image.value {
                    
                   // self.setProfileTabBarImage(tbvc, image:image)
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {

    }
    @IBAction func btnImageAction(_ sender: Any) {
        changeImage()

    }
    
    @IBAction func btnSkipAction(_ sender: Any) {
      //  enterIntoApp()
        saveAPI(text: "")
    }
   
    
    @IBAction func btnNextAction(_ sender: Any) {
        if(txtViewBio.text == ""){
            self.showErrorAlert(errorMessage: "Please enter your bio.")
        }
        else{
        UtilityManager.ShowHUD(text: "Please wait...")
        saveAPI(text: txtViewBio.text!)
      
    }
    
      
     
    }
    func saveAPI(text:String = ""){
        if let user = AccountManager.session?.account {
            if let mediaInfo = mediaInfo, let url = mediaInfo.secure_url?.absoluteString {
                user.profileImageUri = url
            }
            
            user.bio = txtViewBio.text
            user.save(error: { [weak self ](errorMessage) in
                UtilityManager.RemoveHUD()
                
                DispatchQueue.main.async {
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
                }, completion: {
                    AccountManager.session?.account = user
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ProfileImageChanged"), object: nil)
                    UtilityManager.RemoveHUD()
                    self.enterIntoApp()
                    
            })
        }
    }
    func enterIntoApp()
    {
        for vc in tbvc.childViewControllers {
            if let vc = vc as? UINavigationController {
                if vc.viewControllers.first is MyProfileViewController {
                    
                    if((AccountManager.session?.account?.categories)!.count == 0){
                        let nav = vc.tabBarController?.viewControllers![0] as! UINavigationController
                        
                        self.dismiss(animated: false, completion: nil)
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                            if let categoryVC = self.tbvc.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") {
                                nav.viewControllers.first?.present(categoryVC, animated: false, completion: nil)
                            }
                      //  }
                    }
                    else
                    {
                        self.dismiss(animated: true, completion: nil)

                    }
                }
            }
            print("LOGIN")
        }
    }
    
    func changeImage() {
        let alertController = UIAlertController(title: "Where would you like to upload from?", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = ["public.image"]
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
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.mediaTypes = ["public.image"]
                imagePickerController.delegate = self
                imagePickerController.navigationBar.tintColor = Constants.appYellowColor
                imagePickerController.navigationBar.backgroundColor = Constants.appThemeColor
                
                self?.present(imagePickerController, animated: true, completion: nil)
            } else {
                self?.showAlert(title: "Oops!", confirmTitle: "Ok", errorMessage: "Please allow access to your photo library.", actions: nil, confirmCompletion: nil, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let frame = scrollView?.convert(textView.frame, from: textView.superview) {
            self.scrollView?.scrollRectToVisible(frame, animated: true)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (textView.text.count == 0) {
                self.lblPlaceholder.isHidden = false
            }
            else
            {
                self.lblPlaceholder.isHidden = true
            }
        }
     
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UIImagePickerControllerDelegate
extension SignUpBioVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        UtilityManager.ShowHUD(text: "Please wait...")
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            //if mediaType == kUTTypeImage as String {
                if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    if let data = UIImageJPEGRepresentation(pickedImage, 0.8) {
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
                                    UtilityManager.RemoveHUD()
                                    self.mediaInfo = photo
                                    self.imgUser?.af_setImage(withURL: imageFileURL, placeholderImage: UIImage(named: "logoProfile"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                                }
                            })
                        }
                    }
                }
//            }
//            else if mediaType == kUTTypeMovie as String {
//                if let url = info[UIImagePickerControllerMediaURL] as? URL {
//                    print(url)
//                }
//            }
        }

    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
