//
//  EditProfileViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import MobileCoreServices
//import FPPicker
//import SDWebImage

class EditProfileViewController: KeyboardScrollViewController {
//class EditProfileViewController: KeyboardScrollViewController, FPPickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var btnProfileImage: UIButton!

    var mediaInfo: Media?
    var canLogout = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = AccountManager.session?.account {
            if let profileImageUri = user.profileImageUri, let uri = URL(string: profileImageUri) {
                profileImageView?.af_setImage(withURL: uri, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                btnProfileImage.setImage(nil, for: .normal)

            }
            
            usernameTextField.isUserInteractionEnabled = false
            emailTextField.isUserInteractionEnabled = false
            
            nameTextField.text = user.name
            usernameTextField.text = user.username
            emailTextField.text = user.email
            bioTextView.text = user.bio
        }
        logoutButton.isHidden = !canLogout
    }
    
    @IBAction func changeImage(_ sender: AnyObject) {
        changeImage()
    }

    func changeImage() {
        let alertController = UIAlertController(title: "Where would you like to upload from?", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = ["public.image"]
                imagePickerController.navigationBar.tintColor = Constants.appYellowColor

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
    
    @IBAction func logOutTapped(_ sender: AnyObject?) {

    UtilityManager.subscriptionUnsubscriptionNotification(isSubscribe: false)

        
        
        AccountManager.session?.account?.logout(error: { (errorMessage) in
            DispatchQueue.main.async {
                self.showErrorAlert(errorMessage: errorMessage)
            }
        }, completion: {
            DispatchQueue.main.async {
           
            AccountManager.clearSession()


                self.dismissToSplash()
            }
        })
    }
    
    @IBAction func changePasswordTapped(_ sender: AnyObject?) {
        
        let alertController = TVAlertController(title: "Change Password", message: "Please confirm your current password.", preferredStyle: .alert)
        alertController.addTextField { (textField) -> Void in
            textField.isSecureTextEntry = true
        }
        let okAction = UIAlertAction(title: "Confirm", style: .default) { (action) -> Void in
            if let newPassword = alertController.textFields?.first?.text, newPassword.characters.count > 0 {
                
            let params = ["password": newPassword]
            self.confirmPassword(confirmPassword:params)
                
                
//                PFCloud.callFunction(inBackground: "confirmCurrentPassword", withParameters: ["password": newPassword, "username": PFVoter.current()!.username!], block: { (result, error) -> Void in
//                    if let error = error {
//                        self.showErrorPopup("Incorrect password", completion: nil)
//                    } else {
//                        self.changePassword()
//                    }
//                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func changePassword() {
        let alertController = TVAlertController(title: "Change Password", message: "What do you want the new password to be?", preferredStyle: .alert)
        alertController.addTextField { (textField) -> Void in
            textField.isSecureTextEntry = true
        }
        let okAction = UIAlertAction(title: "Save", style: .default) { (action) -> Void in
            if let newPassword = alertController.textFields?.first?.text, newPassword.characters.count > 0 {
                
                let params = ["password": newPassword]
                self.changePassword(newPassword:params)
                
                
//                PFVoter.current()?.password = newPassword
//                PFVoter.current()?.saveInBackground(block: { (success, error) -> Void in
//                    if let error = error {
//                        self.showErrorPopup(error.localizedDescription, completion: nil)
//                    } else {
//                        self.showPopup("Success", message:"Your password was changed.", completion: nil)
//                    }
//                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func changePassword(newPassword: [String: Any]){
        UtilityManager.ShowHUD(text: "Please wait..")
        Account.passwordChange(params: newPassword, error: { (errorMessage) in
            UtilityManager.RemoveHUD()
            self.showErrorAlert(errorMessage: errorMessage)
        }, completion: { () in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                self.showAlert(title: "", confirmTitle: "Ok", errorMessage: "Your password updated successfully.", actions: nil, confirmCompletion: nil, completion: nil)
                

                //  self.user = followedAccount
                //self.refreshFollowButton()
                //   self.refreshProfile()
            }
        })
    }
    
    func confirmPassword(confirmPassword: [String: Any]){
        UtilityManager.ShowHUD(text: "Please wait..")
        
        Account.confirmPassword(params: confirmPassword, error: { (errorMessage) in
            UtilityManager.RemoveHUD()
            self.showErrorAlert(errorMessage: errorMessage)
        }, completion: { () in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()
                self.changePassword()
                //  self.user = followedAccount
                //self.refreshFollowButton()
                //   self.refreshProfile()
            }
        })
    }
    func dismissToSplash() {
       
        let presentingViewController = self.presentingViewController
        self.dismiss(animated: true, completion: { () -> Void in
            if !(presentingViewController is SplashViewController) {
                self.dismissToSplash()
            }
        })
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
//
//            navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    @IBAction func save(_ sender: AnyObject) {

        
//        UtilityManager.dismissToSplash()
//        return
        
        if let user = AccountManager.session?.account {
            if let mediaInfo = mediaInfo, let url = mediaInfo.secure_url?.absoluteString {
                user.profileImageUri = url
            }

            user.name = nameTextField.text
            user.username = usernameTextField.text?.lowercased()
            user.email = emailTextField.text
            user.bio = bioTextView.text

            user.save(error: { [weak self ](errorMessage) in
                DispatchQueue.main.async {
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
            }, completion: {
                DispatchQueue.main.async {
                    AccountManager.session?.account = user
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ProfileImageChanged"), object: nil)
                    if self.navigationController?.childViewControllers.first == self {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
//        if let frame = scrollView?.convert(textField.frame, from: textField.superview) {
//            self.scrollView?.scrollRectToVisible(frame, animated: true)
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         if let frame = scrollView?.convert(textView.frame, from: textView.superview) {
            self.scrollView?.scrollRectToVisible(frame, animated: true)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
           // textView.resignFirstResponder()
           // return false
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            if mediaType == kUTTypeImage as String {
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
                                    self.mediaInfo = photo
                                    self.profileImageView?.af_setImage(withURL: imageFileURL, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                                }
                            })
                        }
                    }
                }
            } else if mediaType == kUTTypeMovie as String {
                if let url = info[UIImagePickerControllerMediaURL] as? URL {
                    print(url)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
