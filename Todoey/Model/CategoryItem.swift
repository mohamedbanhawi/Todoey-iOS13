//
//  CategoryItem.swift
//  Todoey
//
//  Created by Mohamed Elbanhawi on 26/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryItem: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // forward relationship 1:many(Item Objects) // inverse is not define automatically
}
