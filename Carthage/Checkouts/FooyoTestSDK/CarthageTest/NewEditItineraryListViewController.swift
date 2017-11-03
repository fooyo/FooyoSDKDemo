//
//  NewEditItineraryListViewController.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 27/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SVProgressHUD


class NewEditItineraryListViewController: BaseViewController {
    fileprivate var itinerary: FooyoItinerary?
    
    var key = ""
    var pageMenu : CAPSPageMenu?
    fileprivate var controllerArray = [ItemListViewController]()
    fileprivate var attractions = [FooyoItem]()
    fileprivate var trails = [FooyoItem]()
    fileprivate var events = [FooyoItem]()
    
    fileprivate var overLay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey10
        return t
    }()
    
    fileprivate var searchView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        return t
    }()
    
    fileprivate var searchField: UITextField! = {
        let t = UITextField()
        t.placeholder = "Where would you like to go?"
        t.textColor = UIColor.ospDarkGrey
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.backgroundColor = .white
        t.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 38, height: 1))
        t.leftViewMode = .always
        t.returnKeyType = .search
        t.clearButtonMode = .whileEditing
        return t
    }()
    
    fileprivate var searchIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "basemap_search")
        return t
    }()
    
    fileprivate var homePage: FooyoConstants.PageSource = .FromAddToPlan
    
    // MARK: - Life Cycle
    init(plan: FooyoItinerary, homePage: FooyoConstants.PageSource) {
        super.init(nibName: nil, bundle: nil)
        self.itinerary = plan
        self.homePage = homePage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(getIndexFromBase(notification:)), name: FooyoConstants.notifications.FooyoGetIndexFromBase, object: nil)

        navigationItem.title = itinerary?.name
        view.addSubview(overLay)
        view.addSubview(searchView)
        searchView.addSubview(searchField)
//        searchField.delegate = self
        searchField.addTarget(self, action: #selector(serchUpdate), for: .editingChanged)
        searchField.addSubview(searchIcon)
        SVProgressHUD.show()
        setConstraints()
        configurePageViews()
        DispatchQueue.global(qos: .background).async {
            self.sortItems()
            SVProgressHUD.dismiss()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setConstraints() {
        overLay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 10))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.leading.equalTo(Scale.scaleX(x: 10))
            make.trailing.equalTo(Scale.scaleX(x: -10))
        }
        searchField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        searchIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 20))
            make.leading.equalTo(Scale.scaleX(x: 9))
        }
    }
    func reloadVCs() {
        controllerArray[0].reloadTableData(items: attractions)
        controllerArray[1].reloadTableData(items: trails)
        controllerArray[2].reloadTableData(items: events)
    }
    
    func getIndexFromBase(notification: Notification) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configurePageViews() {
        controllerArray = [ItemListViewController]()
        let controllerOne = ItemListViewController(items: [FooyoItem](), homePage: homePage)
        controllerOne.parentVC = self
        controllerOne.title = "ATTRACTIONS"
        controllerArray.append(controllerOne)
        
        
        let controllerTwo = ItemListViewController(items: [FooyoItem](), homePage: homePage)
        controllerTwo.parentVC = self
        controllerTwo.title = "INTERACTIVE TRAILS"
        controllerArray.append(controllerTwo)
        
        let controllerThree = ItemListViewController(items: [FooyoItem](), homePage: homePage)
        controllerThree.parentVC = self
        controllerThree.title = "EVENTS & PROMOTIONS"
        controllerArray.append(controllerThree)
        
        let parameters: [CAPSPageMenuOption] = [
            CAPSPageMenuOption.scrollMenuBackgroundColor(.white),
            CAPSPageMenuOption.viewBackgroundColor(.white),
            CAPSPageMenuOption.selectionIndicatorColor(UIColor.ospSentosaOrange),
            CAPSPageMenuOption.unselectedMenuItemLabelColor(UIColor.ospDarkGrey),
            CAPSPageMenuOption.selectedMenuItemLabelColor(UIColor.ospSentosaOrange),
            CAPSPageMenuOption.bottomMenuHairlineColor(UIColor.ospGrey50),
            CAPSPageMenuOption.menuHeight(40),
            CAPSPageMenuOption.menuMargin(0),
            //            CAPSPageMenuOption.menuItemWidth(width),
            CAPSPageMenuOption.menuItemFont(UIFont.DefaultBoldWithSize(size: Scale.scaleY(y: 12))),
            //            CAPSPageMenuOption.useMenuLikeSegmentedControl(true),
            CAPSPageMenuOption.menuItemWidthBasedOnTitleTextWidth(true),
            CAPSPageMenuOption.menuItemSeparatorColor(.white),
            CAPSPageMenuOption.scrollAnimationDurationOnMenuItemTap(300),
            CAPSPageMenuOption.selectionIndicatorHeight(5)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 20, width: FooyoConstants.mainWidth, height: FooyoConstants.mainHeight), pageMenuOptions: parameters)
        pageMenu!.view.removeFromSuperview()
        view.addSubview(pageMenu!.view)
        
        pageMenu!.view.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
            make.top.equalTo(searchView.snp.bottom).offset(Scale.scaleY(y: 10))
        }
    }
    
    func sortItems() {
        attractions = [FooyoItem]()
        events = [FooyoItem]()
        trails = [FooyoItem]()
        for each in FooyoItem.items {
            if each.category?.name == FooyoConstants.CategoryName.Attractions.rawValue {
                if each.name?.lowercased().contains(key.lowercased()) == true || key == "" {
                    attractions.append(each)
                }
            } else if each.category?.name == FooyoConstants.CategoryName.Events.rawValue {
                if each.name?.lowercased().contains(key.lowercased()) == true || key == "" {
                    events.append(each)
                }
            } else if each.category?.name == FooyoConstants.CategoryName.Trails.rawValue {
                if each.name?.lowercased().contains(key.lowercased()) == true || key == "" {
                    if each.isNonLinearHotspot() {
                        var have = false
                        for trail in trails {
                            if trail.levelOneId == each.levelOneId {
                                have = true
                                break
                            }
                        }
                        if !have {
                            let tmp = FooyoItem()
                            tmp.category = each.category
                            tmp.levelOneId = each.levelOneId
                            tmp.name = each.trailName
                            tmp.coverImages = each.trailImage
                            trails.append(tmp)
                        }
                    } else {
                        trails.append(each)
                    }
                }
            }
        }
        reloadVCs()
    }
    
    func serchUpdate(field: UITextField) {
        key = field.text!
        debugPrint(key)
        sortItems()
    }
}

//extension NewEditItineraryListViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        <#code#>
//    }
//}
