//
//  AppCommon.swift
//  AshakAlena
//
//  Created by Mohammad Farhan on 22/12/176/8/17.
//  Copyright © 2017 Mohammad Farhan. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AppCommon: UIViewController {
    
    static let sharedInstance = AppCommon()
    
    func dismissLoader(_ view:UIView){
        view.viewWithTag(1000)?.removeFromSuperview()
    }
    
    func ShowLoader(_ view:UIView,color:UIColor){
        let Loader  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        Loader.backgroundColor = color
        Loader.tag = 1000
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        loadingIndicator.center = Loader.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = UIColor.black
        loadingIndicator.startAnimating();
        Loader.addSubview(loadingIndicator)
        view.addSubview(Loader)
    }
    
    func alert(title: String, message: String, controller: UIViewController, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        alert.view.tintColor = UIColor.hexColor(string: "023f82")
        
        controller.present(alert, animated: true, completion: nil)
        
    }
    
}
