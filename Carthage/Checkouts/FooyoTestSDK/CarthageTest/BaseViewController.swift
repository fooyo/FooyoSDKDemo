//
//  BaseViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 22/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//


import UIKit
import SnapKit
import Mapbox

class BaseViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: FooyoConstants.notifications.FooyoDisplayAlert, object: nil)

        applyGeneralVCSettings(vc: self)
        HttpClient.sharedInstance.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func displayAlert(notification: Notification) {
        if let info = notification.object as? [String: String] {
            let title = info["title"] ?? ""
            let msg = info["message"] ?? ""
            displayAlert(title: title, message: msg, complete: nil)
        }
    }
}
