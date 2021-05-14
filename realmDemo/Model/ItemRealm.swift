//
//  ItemRealm.swift
//  realmDemo
//
//  Created by 維衣 on 2021/5/11.
//

import Foundation
import RealmSwift

class ItemRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?

    var parentCategory = LinkingObjects(fromType: CategoryRealm.self, property: "itemRealms")
}





