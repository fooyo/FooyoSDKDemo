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
    
    // MARK: - Life Cycle
    public init(userId: String?) {
        super.init(nibName: nil, bundle: nil)
        if let id = userId {
            FooyoUser.currentUser.userId = id
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        applyGeneralVCSettings(vc: self)
        NotificationCenter.default.addObserver(self, selector: #selector(itinerarySaved(notification:)), name: FooyoConstants.notifications.FooyoSavedItinerary, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itineraryDownloaded), name: FooyoConstants.notifications.FooyoItineraryDownloaded, object: nil)

        // Do any additional setup after loading the view.
        configurePageViews()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.isNavigationBarHidden = true
            })
        }
        loadData()
    }
    
    
    func configurePageViews() {
        controllerArray = [ItineraryListViewController]()
        let controllerOne = ItineraryListViewController(itineraries: FooyoItinerary.today)
        controllerOne.parentVC = self
        controllerOne.title = "TODAY"
        controllerArray.append(controllerOne)
        
        
        let controllerTwo = ItineraryListViewController(itineraries: FooyoItinerary.future)
        controllerTwo.parentVC = self
        controllerTwo.title = "UPCOMING"
        controllerArray.append(controllerTwo)

        let controllerThree = ItineraryListViewController(itineraries: FooyoItinerary.past)
        controllerThree.parentVC = self
        controllerThree.title = "PAST"
        controllerArray.append(controllerThree)
        
        let width = FooyoConstants.mainWidth / 3
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: Scale.scaleY(y: 26), width: FooyoConstants.mainWidth, height: FooyoConstants.mainHeight), pageMenuOptions: parameters)
        
        for each in view.subviews {
            each.removeFromSuperview()
        }
        view.addSubview(pageMenu!.view)
    }
    
    func loadData() {
        debugPrint(FooyoUser.currentUser.userId)
        if let id = FooyoUser.currentUser.userId {
            debugPrint(FooyoItinerary.myItineraries)
            if FooyoItinerary.myItineraries == nil {
                SVProgressHUD.show()
                HttpClient.sharedInstance.getItineraries { (itineraries, isSuccess) in
                    debugPrint("getItineraries")
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        if let itineraries = itineraries {
                            FooyoItinerary.myItineraries = itineraries
                            FooyoItinerary.sort()
                            self.configurePageViews()
                        }
                    }
                }
            }
        }
    }

    
    func itinerarySaved(notification: Notification) {
        if let plan = notification.object as? FooyoItinerary {
            if FooyoItinerary.myItineraries != nil {
                (FooyoItinerary.myItineraries)!.append(plan)
                FooyoItinerary.sort()
                self.configurePageViews()
            }
        }
    }
    
    func itineraryDownloaded() {
        self.configurePageViews()
    }

}

//extension MyItineraryViewController {
//    func updateItineraries() {
//        configurePageViews()
//    }
//}

//extension 
