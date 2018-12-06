//
//  WebViewVC.swift
//  Studi
//
//  Created by CGT on 20/02/18.
//  Copyright © 2018 Matellio. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {

    
    //@IBOutlet weak var webBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewWeb: UIWebView!
    
    let termsAndConditionURL = "http://13.57.238.187:3000/terms-of-service"
    //MARK: ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilityManager.ShowHUD(text: "Please wait...", view:self.viewWeb)

           let url = URL (string:termsAndConditionURL)!
            let requestObj = URLRequest(url: url)
            self.viewWeb.loadRequest(requestObj)

            self.view.bringSubview(toFront: self.viewWeb)
        
        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillLayoutSubviews() {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction Method

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
//            viewWeb = nil
            viewWeb.delegate = nil
        
    }


}

extension WebViewVC: UIWebViewDelegate{
    
     func webViewDidFinishLoad(_ webView: UIWebView)
    {
        //webBottomConstraint.constant  = 0
       // webView.layoutIfNeeded()
        UtilityManager.RemoveHUD()

    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        
        //webBottomConstraint.constant  = 0
       // webView.layoutIfNeeded()

        UtilityManager.RemoveHUD()

    }
}
