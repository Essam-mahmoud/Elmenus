//
//  MainDishesCell.swift
//  ElMenues
//
//  Created by Apple on 1/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Kingfisher

class MainDishesCell: UICollectionViewCell {
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setup(dishModel: TagesModel){
        let url = URL(string: dishModel.photoURL)
        dishImage.kf.setImage(with: url)
        if let name = dishModel.tagName.split(separator: "-").last{
            nameLabel.text = String(name)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
