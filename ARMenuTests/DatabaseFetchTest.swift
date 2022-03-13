//
//  DatabaseFetchTest.swift
//  ARMenuTests
//
//  Created by William Bai on 4/22/20.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import XCTest
import CloudKit
@testable import ARMenu

class DatabaseFetchTest: XCTestCase {

        // fetch public database
        let db = CKContainer.default().publicCloudDatabase
        
        override func setUp() {
            // Put setup code here. This method is called before the invocation of each test method in the class.
        }

        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
        }
        
        // fetch all Restaurant
        func testExample1() {
            // fetch all restaurants
            
            print("Start Test 1")
            
            let dr = DatabaseRequest()
            let rs = dr.fetchAllRestaurants()
            print(rs)
            
            print("test 1 finished")
        }

        // fetch information of a restaurant given restaurant id
        func testExample2() {
            
            print("Start Test 2")
            
            let restaurantID = "96D93F3C-F03A-2157-B4B7-C6DBFCCC37D0"
            
            let dr = DatabaseRequest()
            let r = dr.fetchRestaurantWithID(id: restaurantID)
            print(r.name)
            
            print("test 2 finished")
        }
        

        // fetch dishes from a restaurant
        func testExample3() {
            
            print("Start Test 3")
            
            let dr = DatabaseRequest()
            let res = dr.fetchRestaurantWithID(id: "96D93F3C-F03A-2157-B4B7-C6DBFCCC37D0")
            let dishes = dr.fetchRestaurantDishes(res: res)
            print(dishes)
            
            print("test 3 finished")
        }

                
        // fetch information of a dish given dish id
        func testExample4() {
            
            print("Start Test 4")
            
            let dr = DatabaseRequest()
            let dish = dr.fetchDish(recordID: "E0D77AE6-D5F9-C7AA-7E80-441B54B91AFB")
            print(dish)
            
            print("test 4 finished")
        }
        
        // fetch information of a user given user id or cloud id
        func testExample5() {
            
            print("Start Test 5")
            
            let dr = DatabaseRequest()
            
            let u1 = dr.fetchUser(recordID: "0F5BACE3-BA0F-4744-AFB1-EA8E03925865")
            print(u1)
            
            let u2 = dr.fetchUserWithCloudID(cloudID: "001070.472563439d3548ad8b6734bdccaed20c.0557")
            print(u2)
            
            print("test 5 finished")
        }
        
        // fetch information of a review given review id
        func testExample6() {
            
            print("Start Test 6")
            
            let dr = DatabaseRequest()
            let review = dr.fetchReview(id: "26C6A482-5616-42AF-B9AC-5FF21A76EB93")
            print(review)
            
            print("test 6 finished")
        }
        
        // fetch all reviews for a dish given dish id
        func testExample7() {
            
            print("Start Test 7")
            
            let dr = DatabaseRequest()
            let dish = dr.fetchDish(recordID: "0E01ACD4-04B4-BEC0-384E-F7FABB605584")
            let reviews = dr.fetchDishReviews(d: dish)
            print(reviews)
            
            print("test 7 finished")
        }
        
        // fetch reviews by a user given user
        func testExample8() {
            
            print("Start Test 8")

            let dr = DatabaseRequest()
            let u = dr.fetchUser(recordID: "0F5BACE3-BA0F-4744-AFB1-EA8E03925865")
            let reviews = dr.fetchUserReviews(user: u)
            print(reviews)
            
            print("test 8 finished")
        }
        
        
        // search for restaurants by keyword
        func testExample9() {
            
            print("Start Test 9")
            
            let restaurantKeyword = "Plum"
            let dr = DatabaseRequest()
            let r = dr.searchRestaurant(keyword: restaurantKeyword)
            print(r)
            
            print("test 9 finished")
        }
        
        // search for model mesh by dish
        func testExample10() {
            
            print("Start Test 10")
            
            let dr = DatabaseRequest()
            let dish = dr.fetchDish(recordID: "67EE938E-B6E3-0BFA-2528-204C93FB0F3F")
            print(dish.model!)
            let model_mesh = dr.fetchDishModel(dish: dish)
            print(model_mesh!)
            
            print("test 10 finished")
        }
        
        // add review
        func testExample11() {
            
            print("Start Test 11")
            
            let dr = DatabaseRequest()
            let description = "TEST4/5"
            let dish = CKRecord.Reference(recordID: CKRecord.ID(recordName: "E0D77AE6-D5F9-C7AA-7E80-441B54B91AFB"), action: .none)
            let cloudID = "001070.472563439d3548ad8b6734bdccaed20c.0557"
            let r = dr.addReview(description: description, headline: description, dishRef: dish, cloudID: cloudID)
            print(r)
            print("test 11 finished")
        }
        
        // fetch the user of a review
        func testExample12() {
            
            print("Start Test 12")
            
            let dr = DatabaseRequest()
            let review = dr.fetchReview(id: "81ED38B4-51BC-43BD-8006-E6D7E4D700BF")
            let user = dr.fetchReviewUser(review: review)
            print(user)
            print(user.userName)
            print(user.cloudIdentifier)
            print("test 12 finished")
        }
        
    // modify user name
        func testExample13() {
            
            print("Start Test 13")
            
            let dr = DatabaseRequest()
            let cloudID =  "001070.472563439d3548ad8b6734bdccaed20c.0557"
            let result = dr.editUserName(cloudID : cloudID, name : "RongTan19")
            print(result)
            print("test 13 finished")
        }
    }
