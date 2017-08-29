//
//  MyItineraryViewController.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 20/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

public class FooyoMyPlanViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    fileprivate var controllerArray = [ItineraryListViewController]()
//    fileprivate var past = [Itinerary]()
//    fileprivate var today = [Itinerary]()
//    fileprivate var future = [Itinerary]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        applyGeneralVCSettings(vc: self)
        // Do any additional setup after loading the view.
//        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "navbar-add"),  style: .plain, target: self, action: #selector(addHandler))
//        navigationItem.rightBarButtonItem = editButton
//        NotificationCenter.default.addObserver(self, selector: #selector(updateItineraries), name: NSNotification.Name(rawValue: Constants.Notification.newItinerary.rawValue), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateItineraries), name: NSNotification.Name(rawValue: Constants.Notification.updateItinerary.rawValue), object: nil)

//        setupNavigationBar()
//        loadData()
        configurePageViews()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configurePageViews() {
        debugPrint("i am configurePageViews")

        controllerArray = [ItineraryListViewController]()
        
        
//        let controllerOne = ItineraryListViewController(itineraries: Itinerary.future)
        let controllerOne = ItineraryListViewController()
        controllerOne.parentVC = self
        controllerOne.title = "UPCOMING PLANS"
        controllerArray.append(controllerOne)
        
        
//        let controllerTwo = ItineraryListViewController(itineraries: Itinerary.today)
        let controllerTwo = ItineraryListViewController()
        controllerTwo.parentVC = self
        controllerTwo.title = "TODAY PLANS"
        controllerArray.append(controllerTwo)

//        let controllerThree = ItineraryListViewController(itineraries: Itinerary.past)
        let controllerThree = ItineraryListViewController()
        controllerThree.parentVC = self
        controllerThree.title = "PAST PLANS"
        controllerArray.append(controllerThree)
        
        let width = Constants.mainWidth / 3
        let parameters: [CAPSPageMenuOption] = [
            CAPSPageMenuOption.scrollMenuBackgroundColor(.white),
            CAPSPageMenuOption.viewBackgroundColor(.white),
            CAPSPageMenuOption.selectionIndicatorColor(UIColor.ospSentosaOrange),
            CAPSPageMenuOption.unselectedMenuItemLabelColor(UIColor.ospDarkGrey),
            CAPSPageMenuOption.selectedMenuItemLabelColor(UIColor.ospSentosaOrange),
            CAPSPageMenuOption.bottomMenuHairlineColor(UIColor.ospGrey50),
            CAPSPageMenuOption.menuHeight(40),
            CAPSPageMenuOption.menuMargin(0),
            CAPSPageMenuOption.menuItemWidth(width),
            CAPSPageMenuOption.menuItemFont(UIFont.DefaultBoldWithSize(size: Scale.scaleY(y: 12))),
            CAPSPageMenuOption.useMenuLikeSegmentedControl(true),
            CAPSPageMenuOption.menuItemSeparatorColor(.white),
            CAPSPageMenuOption.scrollAnimationDurationOnMenuItemTap(300),
            CAPSPageMenuOption.selectionIndicatorHeight(5)
            ]
//        let parameters: [CAPSPageMenuOption] = [
//            .scrollMenuBackgroundColor(UIColor.white),
//            .viewBackgroundColor(.white),
//            .selectionIndicatorColor(UIColor.ospSentosaOrange),
//            .unselectedMenuItemLabelColor(UIColor.ospDarkGrey),
//            .selectedMenuItemLabelColor(UIColor.ospSentosaOrange),
//            .bottomMenuHairlineColor(UIColor.ospGrey50),
//            .menuHeight(Scale.scaleY(y: 40)),
//            .menuMargin(Scale.scaleX(x: 0)),
//            .menuItemWidth(width),
//            .menuItemFont(UIFont.DefaultBoldWithSize(size: Scale.scaleY(y: 12))),
//            .useMenuLikeSegmentedControl(true),
//            .menuItemSeparatorColor(.white),
//            .scrollAnimationDurationOnMenuItemTap(300),
//            .selectionIndicatorHeight(5)
//        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: Scale.scaleY(y: 26), width: Constants.mainWidth, height: Constants.mainHeight), pageMenuOptions: parameters)
        
        view.addSubview(pageMenu!.view)
    }
    
//    func setupNavigationBar() {
//        navigationItem.title = "My Itineraries"
//        let leftItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_profile"), style: .plain, target: self, action: #selector(profileHandler))
//        navigationItem.leftBarButtonItem = leftItem
//    }
    
    func loadData() {
//        self.past = Itinerary.myItineraries.filter({ (itinerary) -> Bool in
//            let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
//            return check == -1// > 0
//        })
//        self.future = Itinerary.myItineraries.filter({ (itinerary) -> Bool in
//            let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
//            return check == 1
//        })
//        self.today = Itinerary.myItineraries.filter({ (itinerary) -> Bool in
//            let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
//            return check == 0
//        })
        self.configurePageViews()
//        SVProgressHUD.show()
//        HttpClient.sharedInstance.getItineraries { (itineraries, isSuccess) in
//            SVProgressHUD.dismiss()
//            if isSuccess {
//                if let itineraries = itineraries {
//                    debugPrint("success")
//                    self.past = itineraries.filter({ (itinerary) -> Bool in
//                        let date = DateTimeTool.fromFormatThreeToDate((itinerary.time)!)
////                        let early = date.daysEarlier(than: Date())
//                        let early = date.hoursEarlier(than: Date())
//                        debugPrint("=======")
//                        debugPrint(date)
//                        debugPrint(Date())
//                        debugPrint("=======")
////                        return early > 0
//                        return early > 2
//                    })
//                    self.today = itineraries.filter({ (itinerary) -> Bool in
//                        let date = DateTimeTool.fromFormatThreeToDate((itinerary.time)!)
////                        let early = date.daysEarlier(than: Date())
//                        let early = date.hoursEarlier(than: Date())
//                        return (early >= 0) && (early < 2)
//                    })
//                    self.future = itineraries.filter({ (itinerary) -> Bool in
//                        let date = DateTimeTool.fromFormatThreeToDate((itinerary.time)!)
//                        let early = date.daysEarlier(than: Date())
//                        return early < 0
//                    })
//                }
//            } else {
//                self.past = Itinerary.myItineraries
//                self.today = Itinerary.myItineraries
//                self.future = Itinerary.myItineraries
//            }
//            self.configurePageViews()
//        }
    }
    
//    func profileHandler() {
//        self.viewDeckController?.open(.left, animated: true)
//    }
//    
//    func addHandler() {
////        gotoNewItinerary()
//    }
}

//extension MyItineraryViewController {
//    func updateItineraries() {
//        configurePageViews()
//    }
//}

//extension 
