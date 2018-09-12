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
    
    @IBAction func signUpTapped(_ sender: AnyObject?) {
        if let username = usernameTextField.text?.lowercased(), username.characters.count > 0 {
            if let email = emailTextField.text?.lowercased(), email.characters.count > 0 {
                if let password = passwordTextField.text, password.characters.count > 0 {
                    if let passwordC = passwordConfirmTextField.text, password.characters.count > 0 {
                        if (password != passwordC) {
                            self.showErrorAlert(errorMessage: "The passwords don't match!")
                        } else {
                            signUp(username, password: password, email: email)
                        }
                    } else {
                        self.showErrorAlert(errorMessage: "Please confirm your password!")
                    }
                } else {
                    self.showErrorAlert(errorMessage: "Please enter a password!")
                }
            } else {
                self.showErrorAlert(errorMessage: "Please enter an email!")
            }
        } else {
            self.showErrorAlert(errorMessage: "Please enter a username!")
        }
    }
    
    func signUp(_ username: String, password: String, email: String) {
        let params = [
            "email": email,
            "password": password,
            "username": username
        ]
        
        Account.create(params: params, error: { (errorMessage) in
            DispatchQueue.main.async {
                self.showErrorAlert(errorMessage: errorMessage)
            }
        }) { (account) in
            AccountManager.session?.account = account
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
