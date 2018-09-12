//
//  AppDelegate.swift
//  Super
//
//  Created by Matthew Arkin on 10/1/14.
//  Copyright (c) 2014 Super. All rights reserved.
//

import UIKit
//import Parse
//import ParseFacebookUtilsV4
//import ParseTwitterUtils
//import FPPicker
import FBSDKCoreKit
import OAuthSwift
import UserNotifications
import IQKeyboardManagerSwift
import Branch

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let screenBounds = UIScreen.main.bounds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // PARSE
//        PFVoter.registerSubclass()
//        PFCompetition.registerSubclass()
//        PFEntry.registerSubclass()
//        PFActivity.registerSubclass()
//        PFVote.registerSubclass()
//        PFComment.registerSubclass()
//        PFFlag.registerSubclass()
//        PFIdea.registerSubclass()
//        PFIdeaVote.registerSubclass()
//        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
//            configuration.server = Constants.parseURL
//            configuration.applicationId = Constants.Parse.applicationId
//            configuration.clientKey = Constants.Parse.clientKey
//        }))
//        Parse.setLogLevel(.debug)
//        PFUser.register(self, forAuthType: "instagram")
//        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
//        PFTwitterUtils.initialize(withConsumerKey: Constants.Twitter.consumerKey, consumerSecret: Constants.Twitter.consumerSecret)
//        PFAnalytics.trackAppOpened(launchOptions: launchOptions)

        // FILEPICKER
        //FPConfig.sharedInstance().apiKey = Constants.FilePicker.apiKey

        // FB
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //
        
        
        let branch: Branch = Branch.getInstance()
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            // If the key 'pictureId' is present in the deep link dictionary
            print("params: %@", params as? [String: AnyObject] ?? {})

            print("params received: %@", params!)
            if error == nil && ((params!["~referring_link"]) != nil){
                let dictParams: NSDictionary = params! as NSDictionary
                print("dictParams: %@", dictParams)
                
                let urlRef = dictParams["~referring_link"] as! String
                print("referring_link: %@", urlRef)
                
                let strUrlRef = urlRef.components(separatedBy: "/")
                
                self.deppLinkAPI(key:strUrlRef.last!)
            }
//
//            if error == nil && params!["+clicked_branch_link"] != nil && params!["id"] != nil {
//
//
//                print("clicked picture link!")
//                // load the view to show the picture
//            }
            
            
            else {
                // load your normal view
            }
        })
        
//        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
//
////        branch.initSession(launchOptions: launchOptions) { (params, error) in
//            if error == nil {
//                print("params received: %@", params)
//
//                let latestParams = Branch.getInstance().getLatestReferringParams()
//                print("params: %@", latestParams!)
//                if((latestParams!["~referring_link"]) != nil){
//                    let dictParams: NSDictionary = latestParams! as NSDictionary
//                    print("dictParams: %@", dictParams)
//
//                    let urlRef = dictParams["~referring_link"] as! String
//                    print("referring_link: %@", urlRef)
//
//                    let strUrlRef = urlRef.components(separatedBy: "/")
//
//                    self.deppLinkAPI(key:strUrlRef.last!)
//                }
//
//
//
//                }
//            }
        

        
        LocationManager.instance.requestPermissions()
            IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysHide
        
        Style.setup()
        
        if let tbvc = window?.rootViewController as? UITabBarController {
            for index in 0..<tbvc.childViewControllers.count {
                tbvc.selectedIndex = index
            }
            tbvc.selectedIndex = 0
        }
        
//        if let recentVoteData = UserDefaults.standard.object(forKey: "KEY_RECENT_VOTE_DATA") as? Data {
//            PFVote.recentVotes = (NSKeyedUnarchiver.unarchiveObject(with: recentVoteData) as? [NSVote]) ?? []
//        }
//        if let recentIdeaVoteData = UserDefaults.standard.object(forKey: "KEY_RECENT_IDEA_VOTE_DATA") as? Data {
//            PFIdeaVote.recentIdeaVotes = (NSKeyedUnarchiver.unarchiveObject(with: recentIdeaVoteData) as? [NSVote]) ?? []
//        }
        
        return true
    }
    
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("url action receieved")
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
            return true
        }
        
        let branchHandled = Branch.getInstance().application(app, open: url, options: options)
        if (!branchHandled) {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            // If not handled by Branch, do other deep link routing for the Facebook SDK, Pinterest SDK, etc
            print("params: %@", url)
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        print("sourceApplication")
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
            return true
        }
        
        let branchHandled = Branch.getInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation
        )
        if (!branchHandled) {
             return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return true
        

       
    }
    
    var notificationDevice: TVDevice?
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenData = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        if Account.isAuthenticated {
            let params: [String: Any] = [
                "model": UIDevice.current.model,
                "identifier": deviceTokenData,
                "version":  Bundle.main.releaseVersionNumber,
                "os": UIDevice.current.systemVersion
            ]
            Account.registerForNotifications(params: params,
                                             error: { (errorMessage) in
                                                print("registerForNotifications::error::\(errorMessage)")
            }, completion: { [weak self] (device) in
                self?.notificationDevice = device
                DispatchQueue.main.async {
                    //  NotificationCenter.default.post(name: .AccountSubscribedNotifications, object: nil)
                }
            })
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        Branch.getInstance().continue(userActivity)

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            OAuthSwift.handle(url: url)
        }
        else
        {
            Branch.getInstance().continue(userActivity)
        }
        print(userActivity)
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //Branch.getInstance().handlePushNotification(launchOptions)

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       // FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the applicationhttp was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func branchHandling(launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        let branch: Branch = Branch.getInstance()
        print("launchOptions\(String(describing: launchOptions))")
        
        branch.initSession(launchOptions: launchOptions) { (params, error) in
            
            
            
            if launchOptions != nil{
                print("launchOptions: %@", launchOptions as Any)
            }
            if error == nil {
                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                // params will be empty if no data found
                // ... insert custom logic here ...
                let defaultBranchKey = Bundle.main.object(forInfoDictionaryKey: "branch_key") as! String
                let branchKey = defaultBranchKey
                print("branchKey: %@", branchKey)
                NSLog("branchKey : %@", branchKey)
                print("params: %@", params!.description)
                NSLog("params : %@", params!.description)
                print("params: %@", params!)
                NSLog("params : %@", params!)
                //                // Check if callback scheme is vcardglobal://
                if params?["+clicked_branch_link"] as! Bool == true{
                    
                    print(params?["domain"] as Any) // standard URl with Scheme like : "vcard://http//rahulbansal.123look.com"
                    var stringUrl =  params?["domain"] as! String
                    stringUrl = stringUrl.components(separatedBy: "//").last!
                    stringUrl = stringUrl.components(separatedBy: ".").first!
                    
                    NSLog("%@hello",stringUrl)
                //    Constants.urlSchemeUserURL = stringUrl
                    
                    //                    }
                    if params?["suid"] != nil{
                       // Constants.urlSchemeSenderId = params?["suid"] as! String
                        
                    }
                    if params?["domain"] != nil{
                      //  Constants.urlDomainURL = params?["domain"] as! String
                        
                    }
                    if params?["mid"] != nil{
                      //  Constants.sharedUserId = params?["mid"] as! String
                     //   Constants.toAddCardId = params?["mid"] as! String
                        
                        
                    }
                    if params?["sponsorid"] != nil{
                       // Constants.sponsorId = params?["sponsorid"] as! String
                    }
                }
            }
            else{
                print("params: %@", error?.localizedDescription as Any)
                NSLog("params : %@", params!.description)
            }

//            if error == nil {
//
//                if let params = params {
//                    print("params: %@", params.description)
//                    let dictParams: NSDictionary = params as NSDictionary
//
//                    if(dictParams.value(forKey: "action") != nil) {
//
//                    }
//                }
//            }
      
        
        }
        
    }
    
    func deppLinkAPI(key:String){
        if((AccountManager.session) != nil){
            let urlLink = key + "/user/" + (AccountManager.session!.account?._id)! + "/add"
            
            
            Category.deepLink(deepLink: urlLink, error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                    print("deep link error")
                 //   self?.showErrorAlert(errorMessage: errorMessage)
                }
            }) { [weak self] (competitions) in
                DispatchQueue.main.async {
                    print("deep link success")

//                    self?.categoryArray = competitions
//                    self?.tblCategory.reloadData()
                }
            }
            
        }
        
       // /pvt-competitions/by-deep-link
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: * Remote Notifications
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func notificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void)  {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: completionHandler)
    }

}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
}

