//
//  ViewController.swift
//  ElMenues
//
//  Created by Apple on 1/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: UIViewController {
    
    @IBOutlet weak var dishCollectionView: UICollectionView!
    @IBOutlet weak var mainScreenTableView: UITableView!
    var http = HttpHelper()
    var TagsArray = [TagesModel]()
    var ItemsArray = [ItemsModel]()
    var RowToShow = [ItemsModel]()
    private let detailsMenuCell = "DetailsMenuCell"
    private let DishCell = "MainDishesCell"
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        http.delegate = self
        getData(pageNumber: page)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        self.navigationItem.title = "El Menues"
        
    }
    
    // function to get Tages
    func getData(pageNumber: Int){
        let serviceURL = ApiConstant.getTages + "\(pageNumber)"
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.2))
        http.GetWithoutHeader(url: serviceURL, parameters: [:], Tag: 1)
    }
    // function to get Items
    func getItems(tagName: String){
        let serviceURL = ApiConstant.getItems + tagName
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.2))
        http.GetWithoutHeader(url: serviceURL, parameters: [:], Tag: 2)
    }
    
    //function to setup View
    func setupView(){
        dishCollectionView.register(UINib(nibName: DishCell, bundle: nil), forCellWithReuseIdentifier: DishCell)
        mainScreenTableView.register(UINib(nibName: detailsMenuCell, bundle: nil), forCellReuseIdentifier: detailsMenuCell)
        mainScreenTableView.tableFooterView = UIView()
    }
    
    // func to load new data
    private func loadMore() {
        page = page + 1
        let serviceURL = ApiConstant.getTages + "\(page)"
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.2))
        http.GetWithoutHeader(url: serviceURL, parameters: [:], Tag: 3)
    }
}

//MARK:- TableView Delegate & Data Source
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainScreenTableView.dequeueReusableCell(withIdentifier: detailsMenuCell, for: indexPath) as! DetailsMenuCell
        cell.setup(item: RowToShow[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainScreenTableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.item = RowToShow[indexPath.row]
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK:- CollectionView Delegate & Data Source
extension MainViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dishCollectionView.dequeueReusableCell(withReuseIdentifier: DishCell, for: indexPath) as! MainDishesCell
        cell.setup(dishModel: TagsArray[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == TagsArray.count - 1 {
            loadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let name = TagsArray[indexPath.item].tagName.split(separator: "-").last?.trimmingCharacters(in: .whitespaces){
            getItems(tagName: name)
        }
    }
}

//MARK:- Network Layer  Delegate & Data Source
extension MainViewController: HttpHelperDelegate{
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        print(json)
        
        if Tag == 1 {
            let tages = json["tags"].arrayValue
            for obj in tages{
                let tagItem = TagesModel(tagName: obj["tagName"].stringValue, photoURL: obj["photoURL"].stringValue)
                TagsArray.append(tagItem)
            }
            
            DispatchQueue.main.async {
                self.dishCollectionView.reloadData()
            }
            
            if let dishName = TagsArray[0].tagName.split(separator: "-").last {
                let name = dishName.trimmingCharacters(in: .whitespaces)
                getItems(tagName: String(name))
            }
            
        }
        
        if Tag == 2 {
            ItemsArray.removeAll()
            let items = json["items"].arrayValue
            for item in items {
                let itemObj = ItemsModel(id: item["id"].intValue, name: item["name"].stringValue, photoUrl: item["photoUrl"].stringValue, itemDescription: item["description"].stringValue)
                ItemsArray.append(itemObj)
            }
            RowToShow = ItemsArray
            
            DispatchQueue.main.async {
                self.mainScreenTableView.reloadData()
            }
            
        }
        
        if Tag == 3 {
            let tages = json["tags"].arrayValue
            for obj in tages {
                let tagItem = TagesModel(tagName: obj["tagName"].stringValue, photoURL: obj["photoURL"].stringValue)
                TagsArray.append(tagItem)
            }
            DispatchQueue.main.async {
                self.dishCollectionView.reloadData()
            }
        }
    }
    
    func receivedErrorWithStatusCode(statusCode: Int) {
        AppCommon.sharedInstance.alert(title: "Error", message: "Please check your internet connection", controller: self, actionTitle: "Ok", actionStyle: .default)
        AppCommon.sharedInstance.dismissLoader(self.view)
    }
    
    func retryResponse(numberOfrequest: Int) {
        
    }
    
    
}


