//
//  Item.swift
//  Todoey
//
//  Created by Mohamed Elbanhawi on 26/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: CategoryItem.self, property: "items")  // autoupdating that represent zero or many linking objects // inverse relationship must be defined manually // using type of parent property & name of property in parent object
}
