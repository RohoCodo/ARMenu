//
//  AddReviewViewController.swift
//  ARMenu
//
//  Created by Valentin Porcellini on 25/04/2020.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import UIKit
import CloudKit

class AddReviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var headlineTextField: UITextField!
    @IBOutlet weak var addReviewTextView: UITextView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var placeholderText = "Add Review..."
    var dish: Dish?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishButton.isEnabled = false
        addReviewTextView.delegate = self
        headlineTextField.delegate = self
        
        headlineTextField.layer.borderColor = self.view.tintColor.cgColor;
        headlineTextField.layer.borderWidth = 1.0;
        headlineTextField.layer.cornerRadius = 5.0;
        
        addReviewTextView.layer.borderColor = self.view.tintColor.cgColor;
        addReviewTextView.layer.borderWidth = 1.0;
        addReviewTextView.layer.cornerRadius = 5.0;
        
        headlineTextField.addTarget(self, action: #selector(AddReviewViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func pressCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func pressPublishButton(_ sender: Any) {
        customActivityIndicator(self.view)
        
        let dishID = self.dish!.id
        let dishReference = CKRecord.Reference(recordID: dishID, action: .none)
        
        _ = db.addReview(description: addReviewTextView.text!, headline: headlineTextField.text!, dishRef: dishReference, cloudID: KeychainItem.currentUserIdentifier!)
        
        removeActivityIndicator(self.view)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if addReviewTextView.text.isEmpty || headlineTextField.text!.isEmpty || addReviewTextView.text == placeholderText {
            publishButton.isEnabled = false
        } else {
            publishButton.isEnabled = true
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView == addReviewTextView {
            if addReviewTextView.text == placeholderText {
                addReviewTextView.text = ""
                addReviewTextView.textColor =  UIColor { tc in
                    switch tc.userInterfaceStyle {
                    case .dark:
                        return UIColor.white
                    default:
                        return UIColor.black
                    }
                }
            }
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == addReviewTextView {
            if addReviewTextView.text.isEmpty || headlineTextField.text!.isEmpty {
                publishButton.isEnabled = false
            } else {
                publishButton.isEnabled = true
            }
        }
    }
    
    @objc func DismissKeyboard(){
        //Causes the view to resign from the status of first responder.
        view.endEditing(true)
    }
    
    
    
    // MARK: - Navigation
    
    
}

