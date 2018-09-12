//
//  LoggedOutViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 5/9/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
//import ParseFacebookUtilsV4
//import ParseTwitterUtils
//import SwiftyJSON
import OAuthSwift

class LoggedOutViewController: KeyboardScrollViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = StyleGuide.attributtedText(text: "Username", font: usernameTextField.font!, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        passwordTextField.attributedPlaceholder = StyleGuide.attributtedText(text: "Password", font: passwordTextField.font!, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    @IBAction func instagramTapped(_ sender: UIButton) {
        // TODO if user is created in instagram spider backend, then this will create another user. Another option is to link the user here if the instagramId is already in the db wiht another user.
        
        let oauthswift = OAuth2Swift(
            consumerKey:    Constants.Instagram.clientID,
            consumerSecret: Constants.Instagram.clientSecret,
            authorizeUrl:   "https://api.instagram.com/oauth/authorize",
            accessTokenUrl: "https://api.instagram.com/oauth/access_token",
            responseType:   "code"
        )
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        oauthswift.authorize(
            //withCallbackURL: "http://localhost:8080/auth/instagram/callback",
            withCallbackURL: Config.host + "/auth/instagram/callback",
            scope: "public_content",
            state: "INSTAGRAM",
            success: { (credential, response, data) in
                var params = [String: Any]()
                if let instagramUser = data["user"] as? [String: Any] {
                    guard let username = instagramUser["username"] as? String else {
                        return
                    }
                    params["instagram"] = [
                        "id": instagramUser["id"],
                        "username": username,
                        "accessToken": data["access_token"]
                    ]
                    params["bio"] = instagramUser["bio"]
                    params["name"] = instagramUser["full_name"]
                    params["profileImageUri"] = instagramUser["profile_picture"]
                    params["username"] = "ig:" + username
                    params["user"] = "ig:" + username
                    params["password"] = instagramUser["id"]
                }
                
                Account.login(params: params, error: { (errorMessage) in
                    DispatchQueue.main.async {
                        self.showErrorAlert(errorMessage: errorMessage)
                    }
                }) { (account) in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        }) { (error) in
            DispatchQueue.main.async {
                self.showErrorAlert(errorMessage: error.localizedDescription)
            }
        }
    }

    @IBAction func facebookTapped(_ sender: UIButton) {
        let permissions: [ReadPermission] = [ReadPermission.publicProfile, ReadPermission.email]
        sender.isEnabled = false
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(readPermissions: permissions, viewController: self) { (loginResult) in
            switch loginResult {
            case .success(_, _, _):
                self.fetchFacebookInfo({
                    self.dismiss(animated: true, completion: nil)
                 })
                break
            case .cancelled:
                break
            case .failed(_):
                sender.isEnabled = true
                self.showErrorAlert(errorMessage: "There was a problem signing in with Facebook.")
                break
            }
        }
    }
    
    @IBAction func twitterTapped(_ sender: UIButton) {
        sender.isEnabled = false
//        PFTwitterUtils.logIn { (user, error) in
//            if let error = error {
//                sender.isEnabled = true
//                self.showErrorPopup(error.localizedDescription, completion: nil)
//            } else {
//                if (user?["twitterId"] == nil) {
//                    self.fetchTwitterInfo({
//                        self.dismiss(animated: true, completion: nil)
//                    })
//                } else {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
//        }
    }

    func fetchFacebookInfo(_ completion: (() -> Void)?) {
        let request = FBProfileRequest()
        request.start({ (_, result) in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                if let fbResponse: [String: Any] = response.dictionaryValue {
                    var params = [
                        "user": fbResponse["email"],
                        "facebook": [
                            "id": fbResponse["id"],
                            "accessToken": AccessToken.current?.authenticationToken
                        ],
                        "name": fbResponse["name"],
                        "ageRage": fbResponse["age_range"],
                        "gender": fbResponse["gender"],
                        "password": fbResponse["id"]
                    ]
                    
                    if let picture = fbResponse["picture"] as? [String: Any] {
                        if let data = picture["data"] as? [String: Any] {
                            if let profileImageUri = data["url"] as? String {
                                params["profileImageUri"] = profileImageUri
                            }
                        }
                    }

                    Account.login(params: params, error: { (errorMessage) in
                        DispatchQueue.main.async {
                            self.showErrorAlert(errorMessage: errorMessage)
                        }
                    }) { (account) in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case let .failed(error):
                print(error)
            }
        });
    }
    
    func fetchTwitterInfo(_ completion: (() -> Void)?) {
//        guard let screenName = PFTwitterUtils.twitter()?.screenName,
//            let requestString = URL(string: "https://api.twitter.com/1.1/users/show.json?screen_name=\(screenName)") else {
//                self.dismiss(animated: true, completion: nil)
//                return
//        }
//        let request = NSMutableURLRequest(url: requestString, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
//        PFTwitterUtils.twitter()?.sign(request)
//        let session = URLSession.shared
//        session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) in
//            if let error = error {
//                self?.showErrorPopup(error.localizedDescription, completion: nil)
//            } else {
//                var r: Any?
//                do {
//                    r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//                } catch {
//                    print(error)
//                }
//                guard let result = r else {
//                    return
//                }
//                let json = JSON(result)
//                PFVoter.current()?.twitterId = json["id_str"].string
//                PFVoter.current()?.name = json["name"].string
//                PFVoter.current()?.imageURL = json["profile_image_url_https"].string
//                PFVoter.current()?.saveInBackground()
//            }
//            completion?()
//        }).resume()
    }
 
    @IBAction func logInTapped(_ sender: AnyObject?) {
        if let username = usernameTextField.text?.lowercased(), username.characters.count > 0 {
            if let password = passwordTextField.text, password.characters.count > 0 {
                logIn(username, password: password)
            } else {
                self.showErrorAlert(errorMessage: "Please enter a password!")
            }
        } else {
            self.showErrorAlert(errorMessage: "Please enter a username!")
        }
    }
    
    func logIn(_ username: String, password: String) {
        let params = [
            "user": username,
            "password": password
        ]
        Account.login(params: params, error: { (errorMessage) in
            self.showErrorAlert(errorMessage: errorMessage)
        }) { (account) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        let alertController = TVAlertController(title: "Reset Password", message: "Enter your email to reset your password", preferredStyle: .alert)
        alertController.addTextField { (textField) -> Void in
        }
        let okAction = UIAlertAction(title: "Reset", style: .default) { (action) -> Void in
            if let email = alertController.textFields?.first?.text, email.characters.count > 0 {
//                PFVoter.requestPasswordResetForEmail(inBackground: email, block: { (success, error) in
//                    if let error = error {
//                        self.showErrorPopup(error.localizedDescription, completion: nil)
//                    } else {
//                        self.showPopup("Password Reset", message: "Please check your email.", completion: nil)
//                    }
//                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension LoggedOutViewController: UITextFieldDelegate {
    
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
            passwordTextField.resignFirstResponder()
            logInTapped(nil)
        }
        return true
    }
}
