//
//  ItemsDetails2ViewController.swift
//  ARMenu
//
//  Created by Rohan Tyagi on 3/21/20.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import UIKit

class ItemsDetails2ViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
       @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var priceLabel: UILabel!
       var menuitem: MenuItem?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           // Do any additional setup after loading the view.
           titleLabel.text = menuitem?.name
           priceLabel.text = "Price: $" +  (menuitem?.price.stringValue ?? "")
           itemImage.image = menuitem?.img
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           guard let viewController = segue.destination as? ViewController
           else {
               return
           }
           viewController.menuitem = menuitem
       }

}
