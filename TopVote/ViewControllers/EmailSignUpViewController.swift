//
//  EmailSignUpViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 4/26/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

class EmailSignUpViewController: KeyboardScrollViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
  //  @IBOutlet weak var btnTermsChck: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = StyleGuide.attributtedText(text: "Username", font: usernameTextField.font!, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        passwordTextField.attributedPlaceholder = StyleGuide.attributtedText(text: "Password", font: passwordTextField.font!, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        passwordConfirmTextField.attributedPlaceholder = StyleGuide.attributtedText(text: "Confirm Password", font: usernameTextField.font!, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        emailTextField.attributedPlaceholder = StyleGuide.attributtedText(text: "Email", font: passwordTextField.font!, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
    }
    
    @IBAction func backTapped(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
  func checkValidForm(){
    if let username = usernameTextField.text?.lowercased(), username.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.showErrorAlert(errorMessage: "Please enter user name!")
        }
    else if let password = passwordTextField.text?.lowercased(), password.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
        self.showErrorAlert(errorMessage: "Please enter password!")

        }
    else if let cPassword = passwordConfirmTextField.text?.lowercased(), cPassword.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
        self.showErrorAlert(errorMessage: "Please enter confirm password!")
        
        }
    else if (passwordTextField.text! != passwordConfirmTextField.text!) {
        self.showErrorAlert(errorMessage: "The passwords don't match!")
        }
    else if let email = emailTextField.text?.lowercased(), email.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
        self.showErrorAlert(errorMessage: "Please enter an email!")
        
        }
    else if !(UtilityManager.isValidEmail(enteredEmail: emailTextField.text!))  {
        self.showErrorAlert(errorMessage: "Please enter valid email!")
        }
//    else if(btnTermsChck.currentImage == UIImage(named:"uncheckTerms")){
//
//        self.showErrorAlert(errorMessage: "Please accept terms & conditions")
//    }
    else{
        signUp(usernameTextField.text!, password: passwordTextField.text!, email: emailTextField.text!)
        }
    
    
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject?) {
        checkValidForm()
    }
    
    @IBAction func btnTermsActons(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
   
    }
    
//    
//    @IBAction func btnCheckUnCheckAction(_ sender: Any) {
//        if(btnTermsChck.currentImage == UIImage(named:"uncheckTerms")){
//            btnTermsChck.setImage(UIImage(named:"checkTerms"), for: .normal)
//            
//        }
//        else{
//            btnTermsChck.setImage(UIImage(named:"uncheckTerms"), for: .normal)
//            
//        }
//        
//    }
//    
    
    func signUp(_ username: String, password: String, email: String) {
        UtilityManager.ShowHUD(text: "Please wait...")

        let params = [
            "email": email,
            "password": password,
            "username": username
        ]
        
        Account.create(params: params, error: { (errorMessage) in
            DispatchQueue.main.async {
                UtilityManager.RemoveHUD()

                self.showErrorAlert(errorMessage: errorMessage)
            }
        }) { (account) in
//            account.isSkipedControllerShow = true
            AccountManager.session?.account = account
            AccountManager.saveSession()

//            AccountManager.session?.account!.isSkipedControllerShow = true
            UtilityManager.RemoveHUD()

            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension EmailSignUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if let frame = scrollView?.convert(textField.frame, from: textField.superview) {
            self.scrollView?.scrollRectToVisible(frame, animated: true)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == usernameTextField) {
            textField.text = textField.text?.lowercased()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == usernameTextField) {
            passwordTextField.becomeFirstResponder()
        } else if (textField == passwordTextField) {
            passwordConfirmTextField.becomeFirstResponder()
        } else if (textField == passwordConfirmTextField) {
            emailTextField.becomeFirstResponder()
        } else if (textField == emailTextField) {
            emailTextField.resignFirstResponder()
            signUpTapped(nil)
        }
        return true
    }

}
