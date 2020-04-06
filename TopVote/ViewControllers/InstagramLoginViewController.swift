//  InstagramLoginViewController.swift
//  Topvote
//  Created by Nilesh Solanki on 30/05/19.
//  Copyright © 2019 Top, Inc. All rights reserved.

import UIKit
import WebKit

class InstagramLoginViewController: UIViewController {
    var selectionBlock: ((_ dataRes: Dictionary<String,AnyObject>,_ status:Bool) -> Void)!

    @IBOutlet weak var instaGramWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI])
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
       // instaWebView.navigationDelegate=self
        //instaWebView.load(urlRequest)
        instaGramWebView.delegate = self
        instaGramWebView.loadRequest(urlRequest)

        // Do any additional setup after loading the view.
    }
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String) {
        API.INSTAGRAM_ACCESS_TOKEN = authToken
        print("Instagram authentication token ==", authToken)
        getUserInfo { (data, status) in
            DispatchQueue.main.async {
                self.selectionBlock(data, status)
                UtilityManager.RemoveHUD()

                self.dismiss(animated: true, completion: nil)
            }
        }
//        getUserInfo(){(data) in
//            DispatchQueue.main.async {
//                self.dismiss(animated: true, completion: nil)
//            }
//
//        }
    }
    
    func getUserInfo(completion: @escaping ((_ dataRes: Dictionary<String,AnyObject>,_ status:Bool) -> Void)){
        let url = String(format: "%@%@", arguments: [API.INSTAGRAM_USER_INFO,API.INSTAGRAM_ACCESS_TOKEN])
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard error == nil else {
                completion([:],false)
                //completion(false)
                //failure
                return
            }
            // make sure we got data
            guard let responseData = data else {
                completion([:],false)
                //completion(false)
                //Error: did not receive data
                return
            }
            do {
                guard let dataResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: AnyObject]
                    else {
                        completion([:],false)
                        //completion(false)
                        //Error: did not receive data
                        return
                }
                print(dataResponse)
                completion(dataResponse,true)
                //completion(true)
                // success (dataResponse) dataResponse: contains the Instagram data
            } catch let err {
                completion([:],false)
                //completion(false)
                //failure
            }
        })
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension InstagramLoginViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
}
extension InstagramLoginViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if checkRequestForCallbackURL(request: navigationAction.request){
            decisionHandler(.allow)
        }else{
            decisionHandler(.cancel)
        }
    }
}
struct API{
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
    static let INSTAGRAM_CLIENT_ID = Constants.Instagram.clientID
    static let INSTAGRAM_CLIENTSERCRET = Constants.Instagram.clientSecret
    static let INSTAGRAM_REDIRECT_URI = "https://www.gettopvote.com/auth/instagram/callback"
    static var INSTAGRAM_ACCESS_TOKEN = ""
    static let INSTAGRAM_SCOPE = "public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
}
