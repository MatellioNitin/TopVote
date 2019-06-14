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
import Fabric
import Crashlytics
import OneSignal
import UserNotifications


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let screenBounds = UIScreen.main.bounds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver {
    
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

     //   AccountManager.clearSession()
        
        //registerForRemoteNotification(application: application)
   
       
        //UNNotification.registerParse()
   
        
        //OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
//        print("bounds = \(UIScreen.main.bounds)")
//        print("nativeBounds = \(UIScreen.main.nativeBounds)")
//        // logLevel
//        let logLevel: Any
//        #if DEBUG
//        logLevel = kKVALogLevelEnumTrace
//        #else
//        logLevel = kKVALogLevelEnumInfo
//        #endif
        
        // appGUIDString
        let appGUIDString: String
        #if DEBUG
        appGUIDString = "aa05480b-965c-4f54-a3ea-f89f96b02161"
        #else
        appGUIDString = "aa05480b-965c-4f54-a3ea-f89f96b02161"
        #endif
        
        // parametersDictionary
//        let parametersDictionary: [AnyHashable: Any] = [
//            kKVAParamLogLevelEnumKey: logLevel,
//            kKVAParamAppGUIDStringKey: appGUIDString
//        ]
        
        // KochavaTracker.shared
       // KochavaTracker.shared.configure(withParametersDictionary: parametersDictionary, delegate: nil)

        
        // KochavaTracker.shared.configure(withParametersDictionary: [kKVAParamAppGUIDStringKey: "aa05480b-965c-4f54-a3ea-f89f96b02161"], delegate: nil)
        
//        // parametersDictionary
//        var parametersDictionary: [AnyHashable: Any] = [:]
//        #if DEBUG
//        parametersDictionary[kKVAParamLogLevelEnumKey] = kKVALogLevelEnumTrace
//        #endif
//        parametersDictionary[kKVAParamAppGUIDStringKey] = "aa05480b-965c-4f54-a3ea-f89f96b02161"
//
//        // KochavaTracker.shared
//        KochavaTracker.shared.configure(withParametersDictionary: parametersDictionary, delegate: nil)
//
//        KochavaTracker.shared.sendEvent(withNameString: "Login", infoString: "Tovote Login")

//
//        // parametersDictionary
//        var parametersDictionary: [AnyHashable: Any] = [:]
//        #if DEBUG
//        parametersDictionary[kKVAParamLogLevelEnumKey] = kKVALogLevelEnumTrace
//        #endif
//        parametersDictionary[kKVAParamAppGUIDStringKey] = "aa05480b-965c-4f54-a3ea-f89f96b02161"
//        parametersDictionary["_SessionBegin"] = Date();
//
//        tracker.configure(withParametersDictionary:parametersDictionary, delegate: nil)
//
        
//        var eventMapObject: [AnyHashable: Any] = [:]
//        eventMapObject["name"] = "Nitin";
//        eventMapObject["time"] = "\(Date())";
//        KochavaTracker.shared.sendEvent(withNameString: "Login", infoDictionary: eventMapObject)
//
//
//        if let event = KochavaEvent(eventTypeEnum: .purchase) {
//            event.nameString = "Gold Token"
//            event.priceDoubleNumber = 0.99
//
//            KochavaTracker.shared.send(event)
//        }

        
       // KochavaTracker.shared.sendEvent(withNameString: "Player Defeated", infoString: nil)

        // KochavaTracker.shared
//        tracker.configure(withParametersDictionary: parametersDictionary, delegate: nil)

        
//        // parametersDictionary
//        var parametersDictionary: [AnyHashable: Any] = [:]
//        #if DEBUG
//        parametersDictionary[kKVAParamLogLevelEnumKey] = kKVALogLevelEnumTrace
//        #endif
//        parametersDictionary[kKVAParamAppGUIDStringKey] = "aa05480b-965c-4f54-a3ea-f89f96b02161"
//
//        // KochavaTracker.shared
//        tracker.configure(withParametersDictionary: parametersDictionary, delegate: nil)

        
        
        //
        if #available(iOS 10.0, *) {
            //iOS 10 or above version
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    else {
                        //Do stuff if unsuccessful...
                    }
                }
            })
        }
        else{
            //iOS 9
            let type: UIUserNotificationType = [ UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
        application.registerForRemoteNotifications()

        
        let _: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(notification!.payload.notificationID)")
            print("launchURL = \(notification?.payload.launchURL ?? "None")")
            print("content_available = \(notification?.payload.contentAvailable ?? false)")
        }
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            
            print("Message = \(payload!.body)")
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "None")")
            
            if let additionalData = result!.notification.payload!.additionalData {
                print("additionalData = \(additionalData)")
                
                
                if let actionSelected = payload?.actionButtons {
                    print("actionSelected = \(actionSelected)")
                }
                
                // DEEP LINK from action buttons
                if let actionID = result?.action.actionID {
                    
                    // For presenting a ViewController from push notification action button
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let instantiateRedViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "RedViewControllerID") as UIViewController
                    let instantiatedGreenViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "GreenViewControllerID") as UIViewController
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    
                    print("actionID = \(actionID)")
                    
                    if actionID == "id2" {
                        print("do something when button 2 is pressed")
                        self.window?.rootViewController = instantiateRedViewController
                        self.window?.makeKeyAndVisible()
                        
                        
                    } else if actionID == "id1" {
                        print("do something when button 1 is pressed")
                        self.window?.rootViewController = instantiatedGreenViewController
                        self.window?.makeKeyAndVisible()
                        
                    }
                }
            }
        }

        
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions, appId: "cbd64a92-89c7-4530-a271-576d27b0ed82", handleNotificationAction: nil, settings: onesignalInitSettings)
        
       // cbd64a92-89c7-4530-a271-576d27b0ed82
        //8d81c1c8-5fa8-410f-a33b-572edcaba0db for client account
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)
        
      //  OneSignal.setEmail("shailendra@matellio.com");
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //
        
        let branch: Branch = Branch.getInstance()
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            // If the key 'pictureId' is present in the deep link dictionary
            print("params: %@", params as? [String: AnyObject] ?? {})
            print("params received: %@", params!)
            
//            dictParams: %@ {
//                "$one_time_use" = 0;
//                "+click_timestamp" = 1541488581;
//                "+clicked_branch_link" = 1;
//                "+is_first_session" = 0;
//                "+match_guaranteed" = 1;
//                id = 5be03c0a205b1d7132b6e219;
//                type = polls;
//                "~channel" = branch;
//                "~creation_source" = 0;
//                "~id" = 587973745273480690;
//                "~referring_link" = "https://topvotedev.app.link/2giNOFz5AR";
//            }

            if error == nil && ((params!["~referring_link"]) != nil){
                let dictParams: NSDictionary = params! as NSDictionary
                print("dictParams: %@", dictParams)
                
                let urlRef = dictParams["~referring_link"] as! String
                print("referring_link: %@", urlRef)
                
                let strUrlRef = urlRef.components(separatedBy: "/")
                let nav = (self.window?.rootViewController?.visibleViewController as? UINavigationController)
                
            //    print(nav?.viewControllers.count)
                
            if(nav == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let nav = (self.window?.rootViewController?.visibleViewController as? UINavigationController)

                if(nav != nil){
                self.deepLinkWork(params: params! as NSDictionary, nav: nav!, strUrlRef:strUrlRef.last!)
                }
                }
            }
        else{
                    self.deepLinkWork(params: params! as NSDictionary, nav: nav!, strUrlRef:strUrlRef.last!)
                }
           
                
                
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
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func deepLinkWork(params:NSDictionary,nav:UINavigationController, strUrlRef:String){
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        if(params["type"] != nil && params["type"] as! String == "polls"){
            
            if let vc = mainStoryboard.instantiateViewController(withIdentifier: "PollListVC") as? PollVC {
                // check same link click again
                if(nav.viewControllers.last? .isKind(of: PollVC.self))!{
                    let vc1 = nav.viewControllers.last as! PollVC
//                    if(vc1.pollId != params["pollId"] as! String && !(vc1.isDeepLinkClick)){
//                        vc.isDeepLinkClick = true
//                        vc.pollId = params["id"] as! String
//                        nav.pushViewController(vc, animated: true)
//                    }
//                    else if(vc1.pollId == params["pollId"] as! String && !(vc1.isDeepLinkClick)){
                        vc1.isDeepLinkClick = true
                        vc1.pollId = params["id"] as! String
                        vc1.viewWillAppear(false)
                    
                  //      nav.pushViewController(vc, animated: true)
                   // }
                }
                else{
                    vc.pollId = params["id"] as! String
                    vc.isDeepLinkClick = true
                    nav.pushViewController(vc, animated: true)
                }
                
            }

        }
        else if(params["type"] != nil && params["type"] as! String == "survey"){
            if let vc = mainStoryboard.instantiateViewController(withIdentifier: "SurveyVC") as? SurveyVC {
                // check same link click again
                if(nav.viewControllers.last? .isKind(of: SurveyVC.self))!{
                    let vc1 = nav.viewControllers.last as! SurveyVC
//                    if(vc1.surveyId != params["surveyId"] as! String && !(vc1.isDeepLinkClick)){
//                        vc.isDeepLinkClick = true
//                        vc.surveyId = params["id"] as! String
//                        nav.pushViewController(vc, animated: true)
//                    }
//                    else if(vc1.surveyId == params["surveyId"] as! String && !(vc1.isDeepLinkClick)){
                        vc1.isDeepLinkClick = true
                        vc1.surveyId = params["id"] as! String
                        vc1.viewWillAppear(false)

                   //     nav.pushViewController(vc, animated: true)
                //    }
                   
                }
                else{
                    vc.isDeepLinkClick = true
                    vc.surveyId = params["id"] as! String
                    nav.pushViewController(vc, animated: true)
                }
                
                
//                vc.isDeepLinkClick = true
//                vc.surveyId = params["id"] as! String
//                nav.pushViewController(vc, animated: true)
            }
            
     
        }
        else if(params["type"] != nil && params["type"] as! String == "entries"){
            //  if (segue.identifier == "toEntries"), let vc = segue.destination as? CompetitionEntriesViewController {
            //  vc.competition = sender as? Competition
            
            if let vc = mainStoryboard.instantiateViewController(withIdentifier: "entriesVC") as? CompetitionEntriesViewController {
                
                
                // check same link click again
                if(nav.viewControllers.last? .isKind(of: CompetitionEntriesViewController.self))!{
                    let vc1 = nav.viewControllers.last as! CompetitionEntriesViewController
                    if(vc1.idEntry != params["id"] as! String){
                        vc.isComeFromDeepUrl = true
                        vc.idEntry = params["id"] as! String
                        nav.pushViewController(vc, animated: true)
                    }
                }
                else{
                    vc.isComeFromDeepUrl = true
                    vc.idEntry = params["id"] as! String
                    nav.pushViewController(vc, animated: true)
                }
            }
            
        }
        else
        {
            self.deppLinkAPI(key:strUrlRef)
        }
        
        
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
        
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        if(handled){
        // Add any custom logic here.
        return handled
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
        
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        if(handled){
        // Add any custom logic here.
        return handled
        }
        
        let branchHandled = Branch.getInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation
        )
        if (!branchHandled) {
             return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return true
       
    }
    
    var notificationDevice: TVDevice?
    var deviceTokenData:String? = ""
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    deviceTokenData = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print("didRegisterForRemoteNotificationsWithDeviceToken \(String(describing: deviceTokenData))")
    registerNotification()
        
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
    
        print("applicationWillEnterForeground")
        
        if let wd = UIApplication.shared.delegate?.window {
            var vc = wd!.rootViewController
            if(vc is UINavigationController){
//                vc = (vc as! UINavigationController).?visibleViewController
//                print(vc)

            }
            
            if(vc is SplashViewController){
                (vc as! SplashViewController).locationOn()
            }
        }
        
//        print(self.window?.currentViewController)
//        if (self.window?.currentViewController is SplashViewController){
//        (self.window?.currentViewController as! SplashViewController).locationOn()
//
//        }
      
        checkP2P_isOn()
      
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
    // MARK: * Custome Method

    func checkP2P_isOn(){
        if((AccountManager.session) != nil){
            
            let controller = (window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController
            
            Category.p2pCheck(error: { (errorMessage) in
                
                
            }) { (flag) in
                
                if(flag.privateCompetition == 0){
                    if((self.window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController!.tabBarController != nil){
                        let tbController = (self.window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController!.tabBarController as! UITabBarController
                        
                        tbController.tabBar.items![3].isEnabled = false
                        
                        if(tbController.selectedIndex == 3){
                            tbController.selectedIndex = 0
                        }
                        
                    }
                }
                else {
                if((self.window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController!.tabBarController != nil){
                        let tbController = (self.window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController!.tabBarController as! UITabBarController
                            tbController.tabBar.items![3].isEnabled = true
                            
                    }
                    
                }
            
            }

        }
    }
    
    func deppLinkAPI(key:String){
        if((AccountManager.session) != nil){
            
            let controller = (window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController
            
            Category.deepLink(deepLink: key, error: { [weak self] (errorMessage) in
                DispatchQueue.main.async {
                    
                    controller?.showErrorAlert(errorMessage: errorMessage)
                }
            }) { [weak self] (deeplinkObj) in
                DispatchQueue.main.async {
                    print("deep link success \(deeplinkObj)")
                    controller?.showErrorAlert(title:"", errorMessage: deeplinkObj[0].message!)
 
//                    self?.categoryArray = competitions
//                    self?.tblCategory.reloadData()
                }
            }
        }
    }
    
    func goToRelatedScreen(competition: Competition){
        
        if((AccountManager.session) != nil){
            
             let controller = (window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController
            
        switch(competition.type!){
        case 1:
            controller?.tabBarController?.selectedIndex = 1
            (controller as! HomeViewController).openCompetition(competition)
        case 2:
            controller?.tabBarController?.selectedIndex = 1
            (controller as! HomeViewController).openCompetition(competition)
        case 3:
            controller?.tabBarController?.selectedIndex = 1
            (controller as! HomeViewController).openCompetition(competition)
        default:
                print("default")
        }

        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//comp// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

    
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    
    
    // TODO: update docs to change method name
    // Add this new method
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
    func registerNotification(){
        if Account.isAuthenticated {
            
            let params: [String: Any] = [
                "model": UIDevice.current.model,
                "platform": "iOS",
                "identifier": deviceTokenData!,
                "version":  Bundle.main.releaseVersionNumber,
                "os": UIDevice.current.systemVersion,
                "adId" :deviceTokenData!
               // "adId" : UIDevice.current.identifierForVendor?.uuidString
            ]
            Account.registerForNotifications(params: params,
                                             error: { (errorMessage) in
                                                print("registerForNotifications::error::\(errorMessage)")
            }, completion: { [weak self] (device) in
                self?.notificationDevice = device
                DispatchQueue.main.async {
                    UtilityManager.subscriptionUnsubscriptionNotification(isSubscribe: true)
                    
                    //NotificationCenter.default.post(name: .AccountSubscribedNotifications, object: nil)
                }
            })
       
        
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if((AccountManager.session) == nil){
            return
        }
        else
        {
            let userInfo = response.notification.request.content.userInfo as NSDictionary
            let apsDict = userInfo.value(forKey: "aps") as! NSDictionary

            
            print("Notification \(userInfo)")
        
             let controller = (window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController
            
            controller?.showAlert(title: "Topvote", confirmTitle: "Ok", errorMessage: apsDict.object(forKey: "alert") as! String, actions: nil, confirmCompletion: nil, completion: nil)
            }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if((AccountManager.session) == nil){
            return
        }
        else
        {
            let userInfo = notification.request.content.userInfo as NSDictionary
            let apsDict = userInfo.value(forKey: "aps") as! NSDictionary

            
            print("Notification \(userInfo)")
            
            let controller = (window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController
            
            controller?.showAlert(title: "Topvote", confirmTitle: "Ok", errorMessage: apsDict.object(forKey: "alert") as! String, actions: nil, confirmCompletion: nil, completion: nil)
        }
    }
}

