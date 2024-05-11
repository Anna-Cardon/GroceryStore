//
//  Store.swift
//  GroceryStore
//
//  Created by Anna on 4/16/23.
//

import Foundation

struct Store: Codable{
    var id: String?
    let name: String
    let address: String
    var items : [String]? //can be null so its optional "?"
}
