//
//  DetailsViewController.swift
//  ElMenues
//
//  Created by Apple on 1/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var imageHeigh: NSLayoutConstraint!
    @IBOutlet weak var trailingConstrain: NSLayoutConstraint!
    var lastContentOffset: CGFloat = 0
    var item: ItemsModel?
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.delegate = self
        title = "Dish Details"
        self.navigationController?.navigationBar.topItem?.title = " "
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    func setupView(){
        let url = URL(string: item!.photoUrl)
        detailsImage.kf.setImage(with: url)
        descriptionLabel.text = item?.itemDescription
    }
}


extension DetailsViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = (scrollView.contentOffset.y - 200)
       // let height = max(10, y)
        let rect = CGRect(x: 0, y: 200, width: view.bounds.width, height: y)
        detailsImage.frame = rect
        print(y)
    }
}

