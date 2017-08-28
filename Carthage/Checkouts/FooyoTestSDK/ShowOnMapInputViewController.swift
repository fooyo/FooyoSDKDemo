//
//  ShowOnMapInputViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 27/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

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
        
        if let category = category {
            if category == "" {
                displayAlert(title: "Reminder", message: "Please give a valid category name.", complete: nil)
                return
            }
            if let id = id {
                if id == "" {
                    let vc = FooyoBaseMapViewController(category: category, levelOneId: nil)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if let valid = Int(id) {
                        let vc = FooyoBaseMapViewController(category: category, levelOneId: valid)
                        vc.delegate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        displayAlert(title: "Reminder", message: "Please give a valid id.", complete: nil)
                    }
                }
            } else {
                let vc = FooyoBaseMapViewController(category: category, levelOneId: nil)
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = FooyoBaseMapViewController()
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
    func didTapInformationWindow(category: String, levelOneId: Int, levelTwoId: Int?) {
        debugPrint(category)
        debugPrint(levelOneId)
        debugPrint(levelTwoId)
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
