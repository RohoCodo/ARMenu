//
//  AccountViewController.swift
//  ARMenu
//
//  Created by Valentin Porcellini on 28/04/2020.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import UIKit
import CloudKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        KeychainItem.currentUserIdentifier = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePictureButton(_ sender: Any) {
        showImagePickerController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customActivityIndicator(self.view)
        DispatchQueue.main.async {
            let user = db.fetchUserWithCloudID(cloudID: KeychainItem.currentUserIdentifier!)
            self.usernameTextField.text = user.userName
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            // MARK: TODO: get image
            if user.profilePhoto != nil {
                let imageAsset: CKAsset? = user.profilePhoto
                let data = NSData(contentsOf: (imageAsset?.fileURL!)!)
                let img = UIImage(data: data! as Data)
                self.profileImage.image = img
            }
            
            removeActivityIndicator(self.view)
        }
    }
    
    @objc func DismissKeyboard(){
        //Causes the view to resign from the status of first responder.
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        customActivityIndicator(self.view)
        DispatchQueue.main.async {
            let cloudID = KeychainItem.currentUserIdentifier
            let result = db.editUserName(cloudID: cloudID!, name: self.usernameTextField.text!)
            print(result)
            removeActivityIndicator(self.view)
            self.dismiss(animated: true, completion: nil)
        }
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

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.profileImage.image = editedImage
            customActivityIndicator(self.view)
            DispatchQueue.main.async {
                // Create a URL in the /tmp directory
                guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png") else {
                    return
                }
                // save image to URL
                do {
                    try editedImage.pngData()?.write(to: imageURL)
                } catch { }
                
                let imageAsset = CKAsset(fileURL: imageURL)
            
                let result = db.editUsePhoto(cloudID: KeychainItem.currentUserIdentifier!, photo: imageAsset)
                print(result)
                removeActivityIndicator(self.view)
            }
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
