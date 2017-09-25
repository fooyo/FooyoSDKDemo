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
    
    var menuHeight: CGFloat = 0
    var pageMenu : CAPSPageMenu?
    fileprivate var controllerArray = [ItineraryListViewController]()
    fileprivate var createBtn: UIButton! = {
        let t = UIButton()
        t.backgroundColor = UIColor.ospSentosaGreen
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.setTitle("CREATE A NEW PLAN", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        return t
    }()
    // MARK: - Life Cycle
    public init(userId: String? = nil) {
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
        debugPrint("my itinerary vc has been loaded")
        applyGeneralVCSettings(vc: self)
//        view.backgroundColor = UIColor.ospGrey10
        NotificationCenter.default.addObserver(self, selector: #selector(itinerarySaved(notification:)), name: FooyoConstants.notifications.FooyoSavedItinerary, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itineraryDownloaded), name: FooyoConstants.notifications.FooyoItineraryDownloaded, object: nil)

        // Do any additional setup after loading the view.
        var tabBarHeight: CGFloat = 0
        if UITabBar.appearance().isTranslucent {
            tabBarHeight = 49
        }
        menuHeight = FooyoConstants.mainHeight - tabBarHeight - 20 - Scale.scaleY(y: 10) * 2 - Scale.scaleY(y: 40)
        
        configurePageViews()
        view.addSubview(createBtn)
        createBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(Scale.scaleX(x: 22))
            make.trailing.equalTo(view).offset(Scale.scaleX(x: -22))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(Scale.scaleY(y: -10))
        }
        createBtn.addTarget(self, action: #selector(createHandler), for: .touchUpInside)
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
    
    func createHandler() {
        if let id = FooyoUser.currentUser.userId {
            let vc = FooyoCreatePlanViewController(userId: id)
            let nav = UINavigationController(rootViewController: vc)
            self.navigationController?.present(nav, animated: true, completion: nil)
        } else {
            displayAlert(title: "Reminder", message: "You have to login first before you can create a new plan.", complete: nil)
        }
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
       
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 20, width: FooyoConstants.mainWidth, height: menuHeight), pageMenuOptions: parameters)
        pageMenu!.view.removeFromSuperview()
        view.addSubview(pageMenu!.view)
    }
    
    func reloadVCs() {
        controllerArray[0].reloadTableData(itineraries: FooyoItinerary.today)
        controllerArray[1].reloadTableData(itineraries: FooyoItinerary.future)
        controllerArray[2].reloadTableData(itineraries: FooyoItinerary.past)
    }
    
    func loadData() {
        if let id = FooyoUser.currentUser.userId {
            if FooyoItinerary.myItineraries == nil {
                SVProgressHUD.show()
                HttpClient.sharedInstance.getItineraries { (itineraries, isSuccess) in
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
        debugPrint("received the saved notification")
        if let _ = notification.object as? FooyoItinerary {
            self.reloadVCs()
        }
    }
    
    func itineraryDownloaded() {
        self.reloadVCs()
    }

}

//extension MyItineraryViewController {
//    func updateItineraries() {
//        configurePageViews()
//    }
//}

//extension 
