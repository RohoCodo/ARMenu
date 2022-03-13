//
//  SignInViewController.swift
//
//  Created by EageRAssassin on 2/10/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import UIKit
import CloudKit
import AuthenticationServices

class SignInViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var button: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleIDButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
    }
    
    @objc
    func appleIDButtonTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
}


extension SignInViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            KeychainItem.currentUserIdentifier = appleIDCredential.user
            KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
            KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
            KeychainItem.currentUserEmail = appleIDCredential.email
            
            print("User Id - \(appleIDCredential.user)")
            print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
            print("User Email - \(appleIDCredential.email ?? "N/A")")
            print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
            
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
            }
            
            //Show Home View Controller
            self.navigationController?.popViewController(animated: true)
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
            print("username", username)
            print("password", password)
        }
        
        // create user on public database if it does not exist
        let userID : String = KeychainItem.currentUserIdentifier!
        
        let query = CKQuery(recordType: "ARMUser", predicate: NSPredicate(value: true))
        let db = CKContainer.default().publicCloudDatabase
        var userExist = false
        db.perform(query, inZoneWith: nil) { (records, error) in
            for record in records! {
                userExist = userExist || (record.value(forKey: "CloudIdentifier") as! String == userID)
            }
        }
        do {
            sleep(1)
        }
        
        if (!userExist) {
            // add such a user
            let ARMUserRecord = CKRecord(recordType: "ARMUser")
            ARMUserRecord.setValue(userID, forKey: "CloudIdentifier")
            ARMUserRecord.setValue(0, forKey: "Karma")
            ARMUserRecord.setValue([], forKey: "ModelUploaded")
            ARMUserRecord.setValue(nil, forKey: "ProfilePhoto")
            ARMUserRecord.setValue([], forKey: "Reviews")
            
            db.save(ARMUserRecord){ (record, error) -> Void in
                DispatchQueue.main.sync {
                    self.processResponse(record: record, error: error)
                }
            }
        }
        UserStruct.name = userID
    }
    
    private func processResponse(record: CKRecord?, error: Error?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "We were not able to create a user."
            
        } else if record == nil {
            message = "We were not able to create a user."
        }
        
        print(message)
    }
}

extension SignInViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
