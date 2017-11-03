//
//  NavigationInputViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 27/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class NavigationInputViewController: UIViewController {
    fileprivate var tableView: UITableView! = {
        let t = UITableView()
        t.register(FeatureInputTableViewCell.self, forCellReuseIdentifier: FeatureInputTableViewCell.reuseIdentifier)
        t.tableFooterView = UIView()
        t.keyboardDismissMode = .onDrag
        return t
    }()
    
    fileprivate var titles = ["Start Category", "Start Lvl 1 ID", "Start Lvl 2 ID", "End Category", "End Lvl 1 ID", "End Lvl 2 ID"]
    fileprivate var holders = ["Category Name", "Lvl 1 ID", "Lvl 2 ID", "Category Name", "Lvl 1 ID", "Lvl 2 ID"]
    
    var button: UIButton! = {
        let t = UIButton()
        t.backgroundColor = .black
        t.setTitleColor(.white, for: .normal)
        t.setTitle("Find Navigation", for: .normal)
        return t
    }()
    
    var startCategory: String?
    var startLvlOneID: String?
    var startLvlTwoID: String?
    
    var endCategory: String?
    var endLvlOneID: String?
    var endLvlTwoID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Navigation SDK"
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
            make.height.equalTo(45 * 6)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.navigationBar.isHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.isHidden = false
            }
        }
        if self.navigationController?.isNavigationBarHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.isNavigationBarHidden = false
            }
        }
    }
    
    func btnHandler() {
        //        debugDescription
        var startIndex: FooyoIndex?
        var endIndex: FooyoIndex?
        
//        debugPrint(startCategory)
//        debugPrint(startLvlOneID)
        if let start = startCategory, let one = startLvlOneID {
            if let two = startLvlTwoID {
                startIndex = FooyoIndex(category: start, levelOneId: one, levelTwoId: two)
            } else {
                startIndex = FooyoIndex(category: start, levelOneId: one)
            }
        } else {
            startIndex = FooyoIndex(category: "Express Stations", levelOneId: "384")
        }
        
        if let end = endCategory, let one = endLvlOneID {
            if let two = endLvlTwoID {
                endIndex = FooyoIndex(category: end, levelOneId: one, levelTwoId: two)
            } else {
                endIndex = FooyoIndex(category: end, levelOneId: one)
            }
        } else {
            endIndex = FooyoIndex(category: "Attractions", levelOneId: "783")
        }
        
        let vc = FooyoNavigationViewController(startIndex: startIndex, endIndex: endIndex)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fieldHandler(sender: UITextField) {
        let tag = sender.tag
        var text: String? = sender.text!
        if text == "" {
            text = nil
        }
        switch tag {
        case 0:
            startCategory = text
        case 1:
            startLvlOneID = text
        case 2:
            startLvlTwoID = text
        case 3:
            endCategory = text
        case 4:
            endLvlOneID = text
        case 5:
            endLvlTwoID = text
        default:
            break
        }
    }
//    func categoryChanged(sender: UITextField) {
//        self.category = sender.text
//    }
//    func idChanged(sender: UITextField) {
//        self.id = sender.text
//    }
}

//extension ShowOnMapInputViewController: FooyoBaseMapViewControllerDelegate {
//    func didTapInformationWindow(category: String, levelOneId: Int, levelTwoId: Int?) {
//        debugPrint(category)
//        debugPrint(levelOneId)
//        debugPrint(levelTwoId)
//    }
//}

extension NavigationInputViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = titles[indexPath.row]
        let holder = holders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FeatureInputTableViewCell.reuseIdentifier) as! FeatureInputTableViewCell
        cell.configureWith(title: title, placeHold: holder, isCompulsory: false)
        cell.inputField.tag = indexPath.row
        cell.inputField.addTarget(self, action: #selector(fieldHandler(sender:)), for: .editingChanged)
//        switch indexPath.row {
//        case 0:
//            cell.inputField.addTarget(self, action: #selector(categoryChanged), for: .editingChanged)
//        default:
//            cell.inputField.addTarget(self, action: #selector(idChanged), for: .editingChanged)
//        }
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
