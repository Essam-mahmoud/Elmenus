//
//  ItemsModel.swift
//  ElMenues
//
//  Created by Apple on 1/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class ItemsModel: NSObject{
    var id: Int
    var name: String
    var photoUrl: String
    var itemDescription: String
    
    init(id: Int, name: String, photoUrl: String, itemDescription: String) {
        self.id = id
        self.name = name
        self.photoUrl = photoUrl
        self.itemDescription = itemDescription
    }
}
