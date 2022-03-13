//
//  CustomActivityIndicator.swift
//  ARMenu
//
//  Created by William Bai on 4/24/20.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import Foundation
import UIKit

func customActivityIndicator(_ view: UIView) {
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

    activityIndicator.tag = 789456123
    
    activityIndicator.center = view.center

    activityIndicator.layer.cornerRadius = 10

    activityIndicator.backgroundColor = (UIColor (white: 0.3, alpha: 0.5))   //create a background behind the spinner

    activityIndicator.hidesWhenStopped = true

    activityIndicator.style = UIActivityIndicatorView.Style.large

    view.addSubview(activityIndicator)

    activityIndicator.startAnimating()

    view.isUserInteractionEnabled = false
    
}

func removeActivityIndicator(_ view: UIView) {
    for subview in view.subviews{
        if subview.tag == 789456123 {
          subview.removeFromSuperview()
        }
    }
    view.isUserInteractionEnabled = true
}
