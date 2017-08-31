//
//  ExploreViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 28/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import FooyoTestSDK

class ExploreViewController: UIViewController {

    fileprivate var tableView: UITableView! = {
        let t = UITableView()
        t.register(FeatureTableViewCell.self, forCellReuseIdentifier: FeatureTableViewCell.reuseIdentifier)
        t.tableFooterView = UIView()
        t.separatorStyle = .none
        return t
    }()
    fileprivate var featureNames = ["Show On Map", "Create Plan", "Add To Plan", "Navigation"]
    fileprivate var featureColors = ["1abc9c", "16a085", "f1c40f", "f39c12"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        
        navigationItem.title = "Fooyo SDK Examples"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            //            make.leading.equalToSuperview()
            //            make.trailing.equalToSuperview()
            //            make.top.equalTo(topLayoutGuide.snp.bottom)
            //            make.bottom.equalToSuperview()
        }
        //        view.addSubview(button)
        //
        //        button.addTarget(self, action: #selector(sdkHandler), for: .touchUpInside)
        //        button.snp.makeConstraints { (make) in
        //            make.center.equalToSuperview()
        //            make.height.equalTo(50)
        //            make.leading.equalTo(50)
        //            make.trailing.equalTo(-50)
        //        }
    }
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.navigationBar.isHidden == false {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }
    //
    //    func sdkHandler() {
    ////        let vc = FooyoSDKNewItineraryViewController()
    //        let vc = FooyoBaseMapViewController()
    //        let nav = UINavigationController(rootViewController: vc)
    //        nav.navigationBar.isHidden = true
    //        self.present(nav, animated: true, completion: nil)
    //    }
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = featureNames[indexPath.row]
        let color = UIColor(hexString: "0x" + featureColors[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: FeatureTableViewCell.reuseIdentifier) as! FeatureTableViewCell
        cell.configureWith(name: name, color: color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            let vc = ShowOnMapInputViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = FooyoCreatePlanViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        case 2:
            let vc = AddToPlanInputViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = NavigationInputViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
        break
        }
    }
}

//extension ViewController: FooyoBaseMapViewControllerDelegate {
//    func didTapInformationWindow(category: String, levelOneId: Int, levelTwoId: Int?) {
//        debugPrint(category)
//        debugPrint(levelOneId)
//        debugPrint(levelTwoId)
//    }
//}
