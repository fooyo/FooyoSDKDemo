//
//  SetUserViewController.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 18/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import FooyoTestSDK

class SetUserViewController: UIViewController {
    fileprivate var tableView: UITableView! = {
        let t = UITableView()
        t.register(FeatureInputTableViewCell.self, forCellReuseIdentifier: FeatureInputTableViewCell.reuseIdentifier)
        t.tableFooterView = UIView()
        t.keyboardDismissMode = .onDrag
        return t
    }()
    
    fileprivate var holders = ["Give User Id"]
    fileprivate var titles = ["User Id"]
    
    var button: UIButton! = {
        let t = UIButton()
        t.backgroundColor = .black
        t.setTitleColor(.white, for: .normal)
        t.setTitle("Login", for: .normal)
        return t
    }()
    
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "User Login"
        view.backgroundColor = .white
        view.addSubview(button)
        button.addTarget(self, action: #selector(btnHandler), for: .touchUpInside)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.height.equalTo(45)
        }
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(50)
            make.top.equalTo(tableView.snp.bottom).offset(10)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.navigationBar.isHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.isHidden = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func btnHandler() {
        if let id = id {
            if id == "" {
                displayAlert(title: "Reminder", message: "Please give a valid User Id.", complete: nil)
                return
            }
            ACCNUser.currentUser.userId = id
            FooyoSDKSignIn(userId: id)
            //            displayAlert(title: "Done", message: "", complete: nil)
            displayAlert(title: "Done", message: "User Id is set successfully", complete: { 
            })
        }
    }
    
    func idChanged(sender: UITextField) {
        self.id = sender.text
    }
}


extension SetUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = titles[indexPath.row]
        let holder = holders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FeatureInputTableViewCell.reuseIdentifier) as! FeatureInputTableViewCell
        cell.configureWith(title: title, placeHold: holder, isCompulsory: false)
        cell.inputField.addTarget(self, action: #selector(idChanged), for: .editingChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
