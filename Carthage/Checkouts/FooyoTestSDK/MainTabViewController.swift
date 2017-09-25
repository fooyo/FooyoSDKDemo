//
//  MainTabViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 28/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareTabs()
        selectedIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareTabs() {
        let nameArr = ["Explore", "Plan", "Map", "Cart", "More"]
        //        let nameArr = ["信用钱包", "还款", "消息中心", "我"]
        
        //        tabBar.tintColor = UIColor.qpnPaleRedColor()
        var controllers = [UIViewController]()
        for index in 0..<nameArr.count {
            let rootVc = viewControllerAtIndex(index: index)
            let nav = UINavigationController(rootViewController: rootVc)
            let tabItem = UITabBarItem(title: nameArr[index], image: UIImage(named: "tab\(index + 1)_off"), selectedImage: UIImage(named: "tab\(index + 1)_on"))
            //            tabItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            nav.tabBarItem = tabItem
            controllers.append(nav)
        }
        viewControllers = controllers
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        switch index {
        case 0:
            return ExploreViewController()
        case 1:
//            return FooyoMyPlanViewController(userId: nil)
            return FooyoMyPlanViewController(userId: FooyoUser.currentUser.userId)
        case 2:
            let vc = FooyoBaseMapViewController(hideTheDefaultNavigationBar: true)
            vc.delegate = self
            return vc
        case 2:
            return UIViewController()
        default:
            return UIViewController()
        }
    }
}

extension MainTabViewController: FooyoBaseMapViewControllerDelegate {
    func fooyoBaseMapViewController(didSelectInformationWindow index: FooyoIndex) {
        debugPrint(index.category)
        debugPrint(index.levelOneId)
        debugPrint(index.levelTwoId)
    }
}
