//
//  MenuCardViewController.swift
//  ARMenu
//
//  Created by Valentin Porcellini on 20/02/2020.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import UIKit
import CloudKit
import AuthenticationServices


let db = DatabaseRequest()
var restaurant : Restaurant? = nil
var dishes : [Dish] = []
var bgColor : UIColor = UIColor.white
var cellShadowOpacity : Float = 0.5

class MenuCardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var myAccountBtn: UIButton!
    var sectionItems: [DishCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        bgColor = UIColor.init { (trait) -> UIColor in

            return trait.userInterfaceStyle == .dark ? .darkGray : .white
        }
        
        cellShadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0 : 0.5
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if dishes.isEmpty {
            customActivityIndicator(self.view)
            DispatchQueue.main.async {
                restaurant = db.fetchRestaurantWithID(id: "96D93F3C-F03A-2157-B4B7-C6DBFCCC37D0")
                dishes = db.fetchRestaurantDishes(res: restaurant!)
                self.categorizeDishes(dishes: dishes)
                self.collectionView.reloadData()
                removeActivityIndicator(self.view)
            }
        }
        else if self.sectionItems.count == 0 {
            categorizeDishes(dishes: dishes)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      bgColor = UIColor.init { (trait) -> UIColor in

          return trait.userInterfaceStyle == .dark ? .darkGray : .white
      }
        
        cellShadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0 : 0.5
        
        collectionView.reloadData()
    }
    
    
    @IBAction func myAccount(_ sender: Any) {
        if (KeychainItem.currentUserIdentifier == nil) {
            self.performSegue(withIdentifier: "MyAccountLogin", sender: self)
        } else {
            self.performSegue(withIdentifier: "MyAccount", sender: self)
        }
    }
    
    
    func categorizeDishes(dishes: [Dish]) {
        var typeToDishes: [String : [Dish]] = [:]
        for dish in dishes {
            if (typeToDishes[dish.type] == nil) {
                typeToDishes[dish.type] = [dish]
            } else {
                typeToDishes[dish.type]?.append(dish)
            }
        }
        for (category, dishes) in typeToDishes {
            self.sectionItems.append(DishCategory(isExpanded: true, dishes: dishes, name: category))
        }
    }
    
    public func getDishes() -> [Dish] {
        return dishes
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !sectionItems[section].isExpanded {
            return 0
        }
        
        return sectionItems[section].dishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CollectionViewCell
        
        cell.dishName.text = sectionItems[indexPath.section].dishes[indexPath.row].name
        
        let file: CKAsset? = sectionItems[indexPath.section].dishes[indexPath.row].coverPhoto
        let data = NSData(contentsOf: (file?.fileURL!)!)
        let img = UIImage(data: data! as Data)
        cell.dishImage.image = img
        
        let price = sectionItems[indexPath.section].dishes[indexPath.row].price
        let strPrice = price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price)
        
        cell.dishPrice.text = "$" + strPrice
        
        //Styling
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.backgroundColor = bgColor.cgColor
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 0.5).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 8
        cell.layer.shadowOpacity = cellShadowOpacity
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.dishImage.layer.cornerRadius = 10.0
        cell.layer.cornerRadius = 10.0
        cell.dishImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
      // 1
      switch kind {
      // 2
      case UICollectionView.elementKindSectionHeader:
        // 3
        guard
          let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "\(MenuCardHeaderView.self)",
            for: indexPath) as? MenuCardHeaderView
          else {
            fatalError("Invalid view type")
        }
        var text: String
        text = self.sectionItems[indexPath.section].name
        headerView.headerLabel.text = text
        headerView.expandButton.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        headerView.expandButton.tag = indexPath.section
        if self.sectionItems[indexPath.section].isExpanded {
            headerView.expandButton.setImage(UIImage(named: "Image-3"), for: .normal)
        } else {
            headerView.expandButton.setImage(UIImage(named: "Image-2"), for: .normal)
        }
        return headerView
      default:
        // 4
        assert(false, "Invalid element type")
        return UICollectionReusableView()
      }
    }
    
    @objc func handleExpandClose(button: UIButton) {
        let section = button.tag
        let indexPath = [IndexPath]()
        
        let isExpanded = sectionItems[section].isExpanded
        sectionItems[section].isExpanded = !isExpanded
        
        if isExpanded {
            button.setImage(UIImage(named: "Image-3"), for: .normal)
            collectionView.insertItems(at: indexPath)
        } else {
            button.setImage(UIImage(named: "Image-2"), for: .normal)
            collectionView.deleteItems(at: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? ItemDetailsViewController,
            let index = self.collectionView!.indexPathsForSelectedItems?.first
            else {
                return
        }
        detailViewController.dish = sectionItems[index.section].dishes[index.row]
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
