//
//  CategoryRealm.swift
//  realmDemo
//
//  Created by 維衣 on 2021/5/11.
//

import Foundation
import RealmSwift

class CategoryRealm: Object {
    @objc dynamic var name: String = ""
    let itemRealms = List<ItemRealm>()
}





