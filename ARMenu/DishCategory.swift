//
//  DishCategory.swift
//  ARMenu
//
//  Created by William Bai on 5/8/20.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import Foundation

class DishCategory {
    var isExpanded: Bool
    let dishes: [Dish]
    let name: String
    
    init(isExpanded: Bool, dishes: [Dish], name: String) {
        self.isExpanded = isExpanded
        self.dishes = dishes
        self.name = name
    }
}
