//
//  CreatePlanViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 28/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

public class FooyoCreatePlanViewController: UIViewController {

    fileprivate var fakeView: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "page_createplan")
        t.contentMode = .scaleAspectFit
        return t
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let leftBtn = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.applyGeneralVCSettings(vc: self)
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: Constants.notifications.FooyoDisplayAlert, object: nil)

        self.navigationItem.title = "Create your day plan"
        view.addSubview(fakeView)
        fakeView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewHandler))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewHandler() {
        featureUnavailable()
    }
    func cancelHandler() {
        _ = dismiss(animated: true, completion: nil)
    }
    func displayAlert(notification: Notification) {
        if let info = notification.object as? [String: String] {
            let title = info["title"] ?? ""
            let msg = info["message"] ?? ""
            displayAlert(title: title, message: msg, complete: nil)
        }
    }
}
