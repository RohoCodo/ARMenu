# Plum Tree ARMenu iOS Documentation

## Build Targets
This App is intended to be build on iPhones with iOS 13.0 or later. 


## App Navigation
Please refer to the Storyboard file in this repository to view the navigation flow of the App. 

## Database Requests
Functions to fetch data from the backend is in `DatabaseRequest.swift`. 

## Data Structures
`Model` contains classes that represent the data structures used in our App. 

## Important ViewControllers
### AR
All ViewControllers in the `AR` folder help create the AR view in our app. 
These ViewControllers are adapted from Apple's [example project](https://developer.apple.com/documentation/arkit/world_tracking/placing_objects_and_handling_3d_interaction). More details can be found in the link. 

### MenuCardViewController
This ViewController controls the digital menu of our App, including logic for database reqeusts and collapsible dropdown menus. 

### ScannerViewController
This ViewController controls the scanning view which is used to scan menu items on a physical menu. 

### ItemDetailsViewController
This ViewController controls the details page of a dish, including displaying its reviews. 

### AccountViewController
This ViewController controls the "My Account" view, which displays and updates profile picture and usernames. 

### SignInViewController
This ViewController controls the "Sign-in with Apple" functionality. 

### AddReviewViewController
This ViewController controls the view from which users can add reviews for a dish. 


## Test Suite
A test suite for this project is provided in `ARMenuTests`. 