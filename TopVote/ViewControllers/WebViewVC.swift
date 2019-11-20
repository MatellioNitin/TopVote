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
    
    @IBOutlet weak var lblTitle: UILabel!
    var isLogin:Bool = false
    let termsAndConditionURL = "http://admin.gettopvote.com/terms-of-service"
    let rulesURL = "http://admin.gettopvote.com/rules"

    //MARK: ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilityManager.ShowHUD(text: "Please wait...", view:self.viewWeb)
        var url:URL!
        if(isLogin){
            self.navigationController?.navigationBar.isHidden = true
             url = URL (string:rulesURL)!
            lblTitle.text = "VIEW RULES"
        }
        else
        {
             url = URL (string:termsAndConditionURL)!
             lblTitle.text = "TERMS OF SERVICE"
        }
            let requestObj = URLRequest(url: url)
            self.viewWeb.loadRequest(requestObj)

            self.view.bringSubview(toFront: self.viewWeb)
        
        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(isLogin){
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction Method

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
//            view-Web = nil
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
