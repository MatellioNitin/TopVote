//
//  KeyboardScrollViewController.swift
//

import UIKit

class KeyboardScrollViewController: UIViewController {

    @IBOutlet weak var scrollView : UIScrollView?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardScrollViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardScrollViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func changeToInsets(_ insets: UIEdgeInsets) {
        self.scrollView?.contentInset = insets
        self.scrollView?.scrollIndicatorInsets = insets
    }
    
    @objc func keyboardWillShow(_ notification : Notification) {
        let userInfo = notification.userInfo as! [String:AnyObject]
        if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let intersect = keyboardFrame.intersection(self.view.frame)
            if (!intersect.isNull) {
                if let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                    UIView.animate(withDuration: duration, animations: { () -> Void in
                        UIView.animate(withDuration: duration, animations: { () -> Void in
                            self.changeToInsets(UIEdgeInsetsMake(0, 0, intersect.size.height, 0))
                        })
                        }, completion: { (completion) -> Void in
                    })
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification : Notification) {
        let userInfo = notification.userInfo as! [String:AnyObject]
        if let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.changeToInsets(UIEdgeInsets.zero)
            })
        }
    }
}
