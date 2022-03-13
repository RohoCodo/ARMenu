//
//  ReviewViewController.swift
//  CloudKitDemo
//
//  Created by EageRAssassin on 2/10/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import UIKit
import CloudKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var Headline: UITextField!
    @IBOutlet weak var Description: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingScore: UITextField!
    
    @IBOutlet weak var Submit: UIButton!
    
    var rating: Double = 0.0
    var reviewJsonObject: [Any]
        = []
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingScore.allowsEditingTextAttributes = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SubmitPressed(_ sender: Any) {
        
        print("headline: ", Headline.text ?? "")
        print("Description: ", Description.text ?? "")
        print("rating: ", rating)
        print("user name: ", UserStruct.name)
        print("button pressed")
        
        let currentDateTime = Date()
        print("Time: ", currentDateTime)
        
        let restaurantID = CKRecord.ID(recordName: "96D93F3C-F03A-2157-B4B7-C6DBFCCC37D0")
        let restaurantRef = CKRecord.Reference(recordID: restaurantID, action: .deleteSelf)
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        let reviewRecord = CKRecord(recordType: "Review")
        reviewRecord.setValue(Description.text, forKey: "Description")
        reviewRecord.setValue(Headline.text, forKey: "Headline")
        reviewRecord.setValue(rating, forKey: "Rating")
        reviewRecord.setValue(restaurantRef, forKey: "Restaurant")
        reviewRecord.setValue(currentDateTime, forKey: "Time")
        reviewRecord.setValue(UserStruct.name, forKey: "UserID")
        
        publicDatabase.save(reviewRecord){ (record, error) -> Void in
            DispatchQueue.main.sync {
                self.processResponse(record: record, error: error)
            }
        }
        
        // modify the restaurant review to add review on restaurant
        var restaurantRecord = CKRecord(recordType: "Restaurant")
        publicDatabase.fetch(withRecordID: restaurantID) { record, error in
            guard error == nil else { return }
            restaurantRecord = record!
        }
        
        do {
            sleep(1)
        }
        print("restaurantRecord:", restaurantRecord)

        var restaurantReview = restaurantRecord.value(forKey: "Reviews") as! [CKRecord.Reference]
        restaurantReview.append(CKRecord.Reference(recordID: reviewRecord.recordID, action: .deleteSelf))
        restaurantRecord.setValue(restaurantReview, forKey: "Reviews")
        
        let saveOper = CKModifyRecordsOperation()
        saveOper.recordsToSave = [restaurantRecord]
        saveOper.savePolicy = .ifServerRecordUnchanged
        saveOper.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if saveOper.isFinished == true {
                print("review saved in restaurant")
            }
        }
        publicDatabase.add(saveOper)
        
        // modify the user to add review on user
        let query = CKQuery(recordType: "ARMUser", predicate: NSPredicate(format: "CloudIdentifier = %@", UserStruct.name))

        var ARMUserRecord = CKRecord(recordType: "ARMUser")
        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
          records?.forEach({ (record) in
            ARMUserRecord = record
          })
        }
        
        do {
            sleep(2)
        }
        
        var UserReview = ARMUserRecord.value(forKey: "Reviews") as! [CKRecord.Reference]
        UserReview.append(CKRecord.Reference(recordID: reviewRecord.recordID, action: .deleteSelf))
        ARMUserRecord.setValue(restaurantReview, forKey: "Reviews")
        
        let saveOper2 = CKModifyRecordsOperation()
        saveOper2.recordsToSave = [ARMUserRecord]
        saveOper2.savePolicy = .ifServerRecordUnchanged
        saveOper2.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if saveOper.isFinished == true {
                print("review saved in user")
            }
        }
        publicDatabase.add(saveOper2)
        
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        rating = Double(ratingSlider.value * 5)
        rating = ceil(rating*10)/10
        ratingScore.text = String(Double(rating))
    }
 
    
    private func processResponse(record: CKRecord?, error: Error?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "We were not able to save your list."
            
        } else if record == nil {
            message = "We were not able to save your list."
        }
        
        print(message)
    }
    
}
