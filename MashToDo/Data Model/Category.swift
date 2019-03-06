//
//  Category.swift
//  MashToDo
//
//  Created by Mashud on 5/3/19.
//  Copyright © 2019 Mashud. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
