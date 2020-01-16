//
//  DetailsMenuCell.swift
//  ElMenues
//
//  Created by Apple on 1/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Kingfisher

class DetailsMenuCell: UITableViewCell {


    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(item: ItemsModel){
        detailsNameLabel.text = item.name
        let url = URL(string: item.photoUrl)
        detailsImage.kf.setImage(with: url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
