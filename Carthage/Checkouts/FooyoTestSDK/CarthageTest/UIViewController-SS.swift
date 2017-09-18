//
//  UIViewController-SS.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

extension UIViewController: HttpClientDelegte {
    func displayAlert(title: String, message: String, complete: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let complete = complete {
                complete()
            }
        }))
        present(alertController, animated: true, completion: nil)
        return
    }
    
    func alertMessage(title: String, message: String) {
        debugPrint("~~~~~~~~~~")
        debugPrint(message)
        displayAlert(title: title, message: message, complete: nil)
    }
    
    
    func featureUnavailable() {
        PostAlertNotification(title: "Reminder", message: "Sorry, this feature is currently unavailable.\nBut coming soon!😀")
    }
    
    func gotoSearchPage(source: FooyoConstants.PageSource, sourceVC: UIViewController) {
        let vc = SearchHistoryViewController(source: source)
        vc.sourceVC = sourceVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoSearchResult(key: String, source: FooyoConstants.PageSource, sourceVC: UIViewController) {
        let vc = SearchResultViewController(key: key, searchSource: source)
        vc.sourceVC = sourceVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
