//
//  StartViewController.swift
//  ARMenu
//
//  Created by Valentin Porcellini on 26/02/2020.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var digitalMenuButton: UIButton!
    @IBOutlet weak var scanMenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        digitalMenuButton.layer.cornerRadius = 5
        digitalMenuButton.layer.backgroundColor = UIColor(red: 0, green: 0.47, blue: 1, alpha: 1).cgColor
        digitalMenuButton.setTitleColor(.white, for: .normal)
        
        scanMenuButton.layer.cornerRadius = 5
        scanMenuButton.layer.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        scanMenuButton.setTitleColor(.white, for: .normal)
        
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
