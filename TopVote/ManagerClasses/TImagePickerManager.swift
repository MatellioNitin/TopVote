//
//  ImagePickerManager.swift
//  Softaps
//
//  Created by Anuj on 20/07/18.
//  Copyright © 2018 CGT. All rights reserved.
//

import UIKit

class TImagePickerManager: NSObject, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    var currentVC = UIViewController()
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self;
            imagePicker.sourceType = .camera
            currentVC.present(imagePicker, animated: true, completion: nil)
        } else{
            print("camera not awailable")
        }
    }
    
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self;
            imagePicker.sourceType = .photoLibrary
            currentVC.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showImageOptionAt(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            
        } else{
            print("Something went wrong")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
}
