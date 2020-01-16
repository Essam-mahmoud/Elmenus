//
//  TagesModel.swift
//  ElMenues
//
//  Created by Apple on 1/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class TagesModel:NSObject{
    var tagName: String
    var photoURL: String
    
    init(tagName: String, photoURL: String) {
        self.tagName = tagName
        self.photoURL = photoURL
    }
}
