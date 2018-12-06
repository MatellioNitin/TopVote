//
//  SplashViewController.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
import CoreLocation
class SplashViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let imageView = CircleImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(SplashViewController.setupProfileTabBarImage as (SplashViewController) -> () -> ()), name: NSNotification.Name(rawValue: "ProfileImageChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorView.startAnimating()
        self.logoImageView.isHidden = false
        logoImageView.center = view.center
    }
     func locationOn() {
        print("viewDidLayoutSubviews")
        
        if AccountManager.fetchLastSession(), let currentAccount = AccountManager.session?.account {
            
            //            if (user.needsProfileFix()) {
            //                user.setup({ (success, error) -> Void in
            //                    if (success) {
            //                        self.editProfile()
            //                    } else {
            //                        self.showErrorPopup(error?.localizedDescription, completion: nil)
            //                    }
            //                })
            //            } else {
            //                //
            (UIApplication.shared.delegate as? AppDelegate)?.registerForRemoteNotification()
            //                //
            setupProfileTabBarImage()
            //                //
            LocationManager.instance.getLocationAndName { (success, location, locationName) -> Void in
                if (success) {
                    //                        user.location = PFGeoPoint(location: location)
                    currentAccount.locationName = locationName
                    currentAccount.save(error: { (errorMessage) in
                        
                    }, completion: {
                        DispatchQueue.main.async {
                            self.animateToApp()
                        }
                    })
                } else {
                    
                    
                    // self.presentSettings()
                    
                    //self.showAlert(title: "Oops!", confirmTitle: "Settings", errorMessage: "Use of your location is required to use the app. Please allow access in the settings app", actions: nil, confirmCompletion: nil, completion: {
                    //})
                    
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.isHidden = true
                    self.locationPopUp()
                    // self.showErrorAlert(errorMessage: "Use of your location is required to use the app. Please allow access in the settings app")
                }
            }
            //            }
        } else {
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LogInNC") {
                self.present(loginVC, animated: true, completion: nil)
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LogInNC") {
//            self.present(loginVC, animated: true, completion: nil)
//        }
        
        if AccountManager.fetchLastSession(), let currentAccount = AccountManager.session?.account {
            
//            if (user.needsProfileFix()) {
//                user.setup({ (success, error) -> Void in
//                    if (success) {
//                        self.editProfile()
//                    } else {
//                        self.showErrorPopup(error?.localizedDescription, completion: nil)
//                    }
//                })
//            } else {
//                //
                (UIApplication.shared.delegate as? AppDelegate)?.registerForRemoteNotification()
//                //
                setupProfileTabBarImage()
//                //
                LocationManager.instance.getLocationAndName { (success, location, locationName) -> Void in
                    if (success) {
//                        user.location = PFGeoPoint(location: location)
                        currentAccount.locationName = locationName
                        currentAccount.save(error: { (errorMessage) in
                            
                        }, completion: {
                            DispatchQueue.main.async {
                                self.animateToApp()
                            }
                        })
                    } else {
                        
                        
                       // self.presentSettings()
                        
                        //self.showAlert(title: "Oops!", confirmTitle: "Settings", errorMessage: "Use of your location is required to use the app. Please allow access in the settings app", actions: nil, confirmCompletion: nil, completion: {
                            
                        //})
                        self.activityIndicatorView.stopAnimating()
                            self.activityIndicatorView.isHidden = true
                            self.locationPopUp()
                        // self.showErrorAlert(errorMessage: "Use of your location is required to use the app. Please allow access in the settings app")
                    }
                }
//            }
        } else {
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LogInNC") {
                self.present(loginVC, animated: true, completion: nil)
            }
        }
    }
     func locationPopUp() {
        
        let uiAlert = UIAlertController(title: "Location", message: "Use of your location is required to use the app. Please allow access in the settings app", preferredStyle: UIAlertControllerStyle.alert)
        self.present(uiAlert, animated: true, completion: nil)
   
        uiAlert.addAction(UIAlertAction(title: "Go to Setting", style: .cancel, handler: { action in
            
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                // If general location settings are enabled then open location settings for the app
                UIApplication.shared.openURL(url)
            }     }))
        
//
//        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
//            exit(0)
//        }))
//
    }
    
    func presentSettings() {
        let alertController = UIAlertController(title: "Oops!", message: "Use of your location is required to use the app. Please allow access in the settings app", preferredStyle: .alert)
        //        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:]
                    , completionHandler: { _ in
                        // Handle
                        print("Handle")
                })
            }
        })
        
        present(alertController, animated: true)
    }
    
    func checkLocationAccess() {
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            print("Denied, request permission from settings")
            presentSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
            break
        case .notDetermined:
           break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        }
    }

    
    func editProfile() {
        self.performSegue(withIdentifier: "toEditProfile", sender: nil)
    }
    
    func animateToApp() {
        activityIndicatorView.stopAnimating()
        UIView.animate(withDuration: 0.25, animations: {
            var frame = self.logoImageView.frame
            frame.origin.y += 120
            self.logoImageView.frame = frame
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.1, animations: {
                    var frame = self.logoImageView.frame
                    frame.origin.y -= self.view.frame.height
                    self.logoImageView.frame = frame
                }, completion: { (completed) in
                    self.logoImageView.isHidden = true
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                }) 
        }) 
    }
    
    @objc func setupProfileTabBarImage() {
        if let profileImageUri = AccountManager.session?.account?.profileImageUri, let uri = URL(string: profileImageUri) {
            imageView.af_setImage(withURL: uri, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false, completion: { (image) in
                if let image = image.value {
                    self.setProfileTabBarImage(image)
                }
            })
        }
    }
    
    func setupProfileTabBarImage(_ tbvc: UITabBarController) {
        if let profileImageUri = AccountManager.session?.account?.profileImageUri, let uri = URL(string: profileImageUri) {
            imageView.af_setImage(withURL: uri, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false, completion: { (image) in
                if let image = image.value {
                    self.setProfileTabBarImage(tbvc, image:image)
                }
            })
        }
    }
    
    func setProfileTabBarImage(_ tbvc: UITabBarController, image: UIImage) {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0)
        imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        image = image?.withRenderingMode(.alwaysOriginal)
//
        for vc in tbvc.childViewControllers {
            if let vc = vc as? UINavigationController {
                if vc.viewControllers.first is MyProfileViewController {
                    vc.tabBarItem = UITabBarItem(title: "Profile", image: image, selectedImage: image)

//    if((AccountManager.session?.account?.categories)!.count == 0){
//            let nav = vc.tabBarController?.viewControllers![0] as! UINavigationController
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
//            if let categoryVC = tbvc.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") {
//                nav.viewControllers.first?.present(categoryVC, animated: false, completion: nil)
//            }
//         }
//
        
      //              }
        }
    }
       print("LOGIN")
        
    }
    }
    
    func setProfileTabBarImage(_ image: UIImage) {
        if let tbvc = presentedViewController as? UITabBarController {
            setProfileTabBarImage(tbvc, image: image)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMain") {
            if let tbvc = segue.destination as? UITabBarController {
                self.setupProfileTabBarImage(tbvc)
            }
        } else if (segue.identifier == "toEditProfile") {
            if let nc = segue.destination as? UINavigationController {
                if let vc = nc.childViewControllers.first as? EditProfileViewController {
                    vc.canLogout = false
                }
            }
        }
    }
    
}
