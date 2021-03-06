//
//  ShowOnMapInputViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 27/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import FooyoTestSDK

class ShowOnMapInputViewController: UIViewController {
    fileprivate var tableView: UITableView! = {
        let t = UITableView()
        t.register(FeatureInputTableViewCell.self, forCellReuseIdentifier: FeatureInputTableViewCell.reuseIdentifier)
        t.tableFooterView = UIView()
//        t.separatorStyle = .none
        t.keyboardDismissMode = .onDrag
        return t
    }()

    fileprivate var holders = ["Give Category Name", "Give Location ID"]
    fileprivate var titles = ["Category Name", "Location ID"]
    
    var button: UIButton! = {
        let t = UIButton()
        t.backgroundColor = .black
        t.setTitleColor(.white, for: .normal)
        t.setTitle("Show On Map", for: .normal)
        return t
    }()

    var category: String?
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Show On Map SDK"
        view.backgroundColor = .white
        view.addSubview(button)
        button.addTarget(self, action: #selector(btnHandler), for: .touchUpInside)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
//            make.bottom.equalToSuperview()
//            make.bottom.equalTo(button.snp.top).offset(-10)
            make.height.equalTo(45 * 2)
        }
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(50)
//            make.bottom.equalTo(-50)
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
//        debugDescription
        
        let index = FooyoIndex(category: "Fun Shops")
//        let index = FooyoIndex(category: "Interactive Trails", levelOneId: "6225")
        
        let vc = FooyoBaseMapViewController(index: index, hideTheDefaultNavigationBar: false)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
//        nav.navigationBar.isHidden = true
//        nav.modalPresentationStyle = .overFullScreen
//        
//        let topController = UIApplication.
//        topController?.present(nav, animated: true, completion: nil)
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.backgroundColor = .clear
//        self.navigationController?.pushViewController(vc, animated: true)
        return
        
        if let category = category {
            if category == "" {
//                displayAlert(title: "Reminder", message: "Please give a valid category name.", complete: nil)
//                return
                let index = FooyoIndex(category: "Attractions", levelOneId: "606")
                let vc = FooyoBaseMapViewController(index: index, hideTheDefaultNavigationBar: false)
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
//            if category == "" {
//                
//            }
            if let id = id {
                if id == "" {
                    let index = FooyoIndex(category: category)
                    let vc = FooyoBaseMapViewController(index: index, hideTheDefaultNavigationBar: false)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let index = FooyoIndex(category: category, levelOneId: id)
                    let vc = FooyoBaseMapViewController(index: index, hideTheDefaultNavigationBar: false)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let index = FooyoIndex(category: category)
                let vc = FooyoBaseMapViewController(index: index, hideTheDefaultNavigationBar: false)
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = FooyoBaseMapViewController(hideTheDefaultNavigationBar: false)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func categoryChanged(sender: UITextField) {
        self.category = sender.text
    }
    func idChanged(sender: UITextField) {
        self.id = sender.text
    }
}

extension ShowOnMapInputViewController: FooyoBaseMapViewControllerDelegate {
    func fooyoBaseMapViewController(didSelectInformationWindow index: FooyoIndex, isEditingAPlan: Bool) {
        debugPrint(isEditingAPlan)
        debugPrint(index.category)
        debugPrint(index.levelOneId)
        debugPrint(index.levelTwoId)
    }
}

extension ShowOnMapInputViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = titles[indexPath.row]
        let holder = holders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FeatureInputTableViewCell.reuseIdentifier) as! FeatureInputTableViewCell
        switch indexPath.row {
        case 0:
            cell.configureWith(title: title, placeHold: holder, isCompulsory: false)
            cell.inputField.addTarget(self, action: #selector(categoryChanged), for: .editingChanged)
        default:
            cell.configureWith(title: title, placeHold: holder, isCompulsory: false)
            cell.inputField.addTarget(self, action: #selector(idChanged), for: .editingChanged)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        switch indexPath.row {
//        case 0:
//            let vc = FooyoBaseMapViewController()
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 1:
//            let vc = ShowOnMapInputViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        default:
//            break
//        }
//    }
}
