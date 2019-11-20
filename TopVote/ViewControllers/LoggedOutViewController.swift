//
//  LoggedOutViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 5/9/16.
//  Copyright © 2016 TopVote. All rights reserved.

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import Crashlytics

//import ParseFacebookUtilsV4
//import ParseTwitterUtils
//import SwiftyJSON
import OAuthSwift

class LoggedOutViewController: KeyboardScrollViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = StyleGuide.attributtedText(text: "Username", font: usernameTextField.font!, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        passwordTextField.attributedPlaceholder = StyleGuide.attributtedText(text: "Password", font: passwordTextField.font!, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
//    @IBAction func callAction(_ sender: Any) {
//        
//        if let url = URL(string: "tel://**21*7014841471#") {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
////            UIApplication.shared.openURL(url)
//        }
//    }
    @IBAction func instagramTapped(_ sender: UIButton) {
        // TODO if user is created in instagram spider backend, then this will create another user. Another option is to link the user here if the instagramId is already in the db wiht another user.
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let instaLoginVc:InstagramLoginViewController  = storyboard.instantiateViewController(withIdentifier: "InstagramLoginViewController") as! InstagramLoginViewController
        instaLoginVc.selectionBlock = {(dataRes,status) -> () in
            
            print(dataRes,status)
            var params = [String: Any]()
            if let instagramUser = dataRes["data"] as? [String: Any] {
                guard let username = instagramUser["username"] as? String else {
                    return
                }
                
                params["instagram"] = [
                    "id": instagramUser["id"],
                    "username": username,
                    "accessToken": API.INSTAGRAM_ACCESS_TOKEN
                ]
                params["bio"] = instagramUser["bio"]
                params["name"] = instagramUser["full_name"]
                params["profileImageUri"] = instagramUser["profile_picture"]
                params["username"] = "ig:" + username
                params["user"] = "ig:" + username
                params["password"] = instagramUser["id"]
                
                if((instagramUser["email"]) == nil){
                    params["email"] = ""
                    
                }
                else
                {
                    params["email"] = instagramUser["email"]
                }
                
                Account.login(params: params, error: { (errorMessage) in
                    
                    DispatchQueue.main.async {
                        if(errorMessage.contains("enter your email") || errorMessage.contains("Account with")){
                            self.emailRequiredPopUp(param:params as [String : Any], showText: errorMessage)
                        }
                        else if(errorMessage.contains("Please enter your username.") || errorMessage.contains("Username with")){
                            self.userNameRequiredPopUp(param:params as [String : Any], showText: errorMessage)
                        }
                        else
                        {
                            self.showErrorAlert(errorMessage: errorMessage)
                            
                        }
                        
                        
                    }
                })
                { (account) in
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }
        }
        
        
        // }
        
        
        
        self.navigationController?.present(instaLoginVc, animated: true, completion: nil)
        /*
         let oauthswift = OAuth2Swift(
         consumerKey:    Constants.Instagram.clientID,
         consumerSecret: Constants.Instagram.clientSecret,
         authorizeUrl:   "https://api.instagram.com/oauth/authorize",
         accessTokenUrl: "https://api.instagram.com/oauth/access_token",
         responseType: "code" )
         
         oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
         oauthswift.authorize(
         //withCallbackURL: "http://localhost:8080/auth/instagram/callback",
         //            withCallbackURL: Config.host + "/auth/instagram/callback",
         // withCallbackURL: "https://www.gettopvote.com/auth/instagram/callback",
         withCallbackURL:"http://13.57.238.187:4000/auth/instagram/callback",
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
         
         if((instagramUser["email"]) == nil){
         params["email"] = ""
         
         }
         else
         {
         params["email"] = instagramUser["email"]
         }
         
         Account.login(params: params, error: { (errorMessage) in
         
         DispatchQueue.main.async {
         if(errorMessage.contains("enter your email")){
         self.emailRequiredPopUp(param:params)
         }
         else
         {
         self.showErrorAlert(errorMessage: errorMessage)
         
         }
         
         
         }
         }) { (account) in
         
         DispatchQueue.main.async {
         self.dismiss(animated: true, completion: nil)
         }
         }
         
         
         }
         
         // }
         
         
         }) { (error) in
         DispatchQueue.main.async {
         self.showErrorAlert(errorMessage: error.localizedDescription)
         }
         }
         */
    }
    
    func emailRequiredPopUp(param:[String: Any], showText:String){
        var params = param
        let alertController = TVAlertController(title: "TOPVOTE", message: showText, preferredStyle: .alert)
        
        alertController.addTextField { (textField) -> Void in
            textField.addTarget(alertController, action: #selector(alertController.textDidChangeInAlert), for: .editingChanged)
        }
    
        
        let okAction = UIAlertAction(title: "Proceed", style: .default) { (action) -> Void in
            if let email = alertController.textFields?.first?.text, email.count > 0 {
                
                params["email"] = email
                UtilityManager.ShowHUD(text: "Please wait...")

                Account.login(params: params, error: { (errorMessage) in
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()
                        if(errorMessage.contains("enter your email") || errorMessage.contains("Account with")){
                            self.emailRequiredPopUp(param:params as [String : Any], showText: errorMessage)
                        }
                        else if(errorMessage.contains("Please enter your username.") || errorMessage.contains("Username with")){
                            self.userNameRequiredPopUp(param:params as [String : Any], showText: errorMessage)
                        }
                        else
                        {
                            self.showErrorAlert(errorMessage: errorMessage)
                        }
                        
                    }
                }) { (account) in
                    
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()

                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                
                
            }
        }
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        okAction.isEnabled = false

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
 
    
    func userNameRequiredPopUp(param:[String: Any], showText:String){
        var params = param
        let alertController = TVAlertController(title: "TOPVOTE", message: showText, preferredStyle: .alert)
        
        alertController.addTextField { (textField) -> Void in
            textField.addTarget(alertController, action: #selector(alertController.textDidChangeInAlert), for: .editingChanged)
        }
        
        let okAction = UIAlertAction(title: "Proceed", style: .default) { (action) -> Void in
            if let username = alertController.textFields?.first?.text, username.count > 0 {
                
                params["username"] = username
                UtilityManager.ShowHUD(text: "Please wait...")

                Account.login(params: params, error: { (errorMessage) in
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()
//                        AccountManager.session?.account!.isSkipedControllerShow = true
//                        AccountManager.saveSession()
                        
                        if(errorMessage.contains("enter your email") || errorMessage.contains("Account with")){
                            self.emailRequiredPopUp(param:params as [String : Any], showText: errorMessage)
                        }
                        else if(errorMessage.contains("Please enter your username.") || errorMessage.contains("Username with")){
                            self.userNameRequiredPopUp(param:params as [String : Any], showText: errorMessage)
                        }

                        else
                        {
                            self.showErrorAlert(errorMessage: errorMessage)
                        }
                        
                    }
                }) { (account) in
                    
                    DispatchQueue.main.async {
                        UtilityManager.RemoveHUD()
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
//                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                
                
            }
            else
            {
                self.userNameRequiredPopUp(param: param, showText: showText)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        okAction.isEnabled = false

        alertController.addAction(okAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func facebookTapped(_ sender: UIButton) {
        let permissions: [ReadPermission] = [ReadPermission.publicProfile, ReadPermission.email]
        //sender.isEnabled = false
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
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
                //sender.isEnabled = true
                self.showErrorAlert(errorMessage: "There was a problem signing in with Facebook.")
                break
            }
        }
    }
    
    @IBAction func twitterTapped(_ sender: UIButton) {
        //  sender.isEnabled = false
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
                    var params = [//"username": fbResponse["email"],
                                 // "username": "",
                                  "user": fbResponse["id"],
                                  "facebook": [
                                    "id": fbResponse["id"],
                                    "accessToken": AccessToken.current?.authenticationToken
                        ],
                                  "name": fbResponse["name"],
                                  "ageRage": fbResponse["age_range"],
                                  "gender": fbResponse["gender"],
                                  "password": fbResponse["id"]
                        
                    ]
                    
                    if((fbResponse["email"]) == nil){
                        params["email"] = ""   }
                    else
                    {   params["email"] = fbResponse["email"] }
                    
                    if let picture = fbResponse["picture"] as? [String: Any] {
                        if let data = picture["data"] as? [String: Any] {
                            if let profileImageUri = data["url"] as? String {
                                //params["profileImageUri"] = profileImageUri
                                params["profileImageUri"] =  "http://graph.facebook.com/\(fbResponse["id"]!)/picture?type=normal"
                                
                            }
                        }
                    }
                    UtilityManager.ShowHUD(text: "Please wait...")

                    Account.login(params: params, error: { (errorMessage) in
                        DispatchQueue.main.async {
                            UtilityManager.RemoveHUD()

                            if(errorMessage.contains("enter your email") || errorMessage.contains("Account with")){
                                self.emailRequiredPopUp(param:params as [String : Any], showText: errorMessage)
                            }
                            else if(errorMessage.contains("Please enter your username.") || errorMessage.contains("Username with")){
                                self.userNameRequiredPopUp(param:params as [String : Any], showText: errorMessage)
                            }
                                
                            else
                            {
                                self.showErrorAlert(errorMessage: errorMessage)
                            }
                        }
                    }) { (account) in
                        DispatchQueue.main.async {
                            UtilityManager.RemoveHUD()

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
        //   Crashlytics.sharedInstance().crash()
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
        
        UtilityManager.ShowHUD(text: "Please wait...")
        
        let params = [
            "user": username,
            "password": password
        ]
        Account.login(params: params, error: { (errorMessage) in
            UtilityManager.RemoveHUD()
            
            self.showErrorAlert(errorMessage: errorMessage)
        }) { (account) in
            UtilityManager.RemoveHUD()
            
            appDelegate.registerNotification()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        let alertController = TVAlertController(title: "Reset Password", message: "Enter your correct email to reset your password", preferredStyle: .alert)
        alertController.addTextField { (textField) -> Void in
        }
        
        
        
        let okAction = UIAlertAction(title: "Reset", style: .default) { (action) -> Void in
            if let email = alertController.textFields?.first?.text, email.characters.count > 0  {
                if(!(UtilityManager.isValidEmail(enteredEmail: email))){
                    self.showAlert(title: "", confirmTitle: "Ok", errorMessage: "Please enter correct email.", actions: nil, confirmCompletion: nil, completion: nil)
                    self.forgotPassword(self.btnForgotPassword)
                }
                    
                else {
                    let params = ["user_email": email]
                    
                    UtilityManager.ShowHUD(text: "Please wait..")
                    Account.forgotPassword(params: params, error: { (errorMessage) in
                        UtilityManager.RemoveHUD()
                        self.showErrorAlert(errorMessage: errorMessage)
                    }, completion: { () in
                        DispatchQueue.main.async {
                            UtilityManager.RemoveHUD()
                            self.showAlert(title: "", confirmTitle: "Ok", errorMessage: "We reset your password. Please check your email.", actions: nil, confirmCompletion: nil, completion: nil)
                            
                        }
                    })
                    
                    
                    
                    //                PFVoter.requestPasswordResetForEmail(inBackground: email, block: { (success, error) in
                    //                    if let error = error {
                    //                        self.showErrorPopup(error.localizedDescription, completion: nil)
                    //                    } else {
                    //                        self.showPopup("Password Reset", message: "Please check your email.", completion: nil)
                    //                    }
                    //                })
                }
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

public extension UIAlertController {
    
    @objc func textDidChangeInAlert() {
        if let emailOrUserNameTextField = textFields?[0].text!.trimmingCharacters(in: .whitespacesAndNewlines),
            let action = actions.first {
            action.isEnabled = emailOrUserNameTextField.count > 0
        }
    }
    
        func showOnTop() {
            let win = UIWindow(frame: UIScreen.main.bounds)
            let vc = UIViewController()
            vc.view.backgroundColor = .clear
            win.rootViewController = vc
            win.windowLevel = UIWindowLevelAlert + 1  // Swift 3-4: UIWindowLevelAlert + 1
            win.makeKeyAndVisible()
            vc.present(self, animated: true, completion: nil)
        }
    
}
