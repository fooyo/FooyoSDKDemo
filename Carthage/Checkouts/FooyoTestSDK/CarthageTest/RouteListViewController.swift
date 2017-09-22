//
//  RouteListViewController.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 6/3/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SVProgressHUD
import Mapbox
import MapKit
import SVProgressHUD


public class FooyoNavigationViewController: UIViewController {
    
    fileprivate var changeMode = FooyoConstants.ChangePoint.ChangeStart
    
    fileprivate var startIndex: FooyoIndex?
    fileprivate var endIndex: FooyoIndex?
    
    fileprivate var endItem: FooyoItem?
    fileprivate var startItem: FooyoItem?
    
    fileprivate var startCoord: CLLocationCoordinate2D?
    fileprivate var endCoord: CLLocationCoordinate2D?
    
    fileprivate var mapView = MGLMapView()
    
    fileprivate var sugRoute: FooyoRoute?
    fileprivate var walkingRoutes: [FooyoRoute]?
    fileprivate var busRoutes: [FooyoRoute]?
    fileprivate var pagination = FooyoPagination()
//    fileprivate var refreshControlOne = UIRefreshControl()
//    fileprivate var refreshControlTwo = UIRefreshControl()
//    fileprivate var refreshControlThree = UIRefreshControl()
    
    fileprivate var backButton: UIImageView = {
        let t = UIImageView()
        t.applyBundleImage(name: "general_leftarrow")
        t.backgroundColor = .clear
        t.contentMode = .scaleAspectFit
        return t
    }()
    fileprivate var bigBack: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        t.isUserInteractionEnabled = true
        return t
    }()
    
    fileprivate var startIcon: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_gps")
        t.backgroundColor = .white
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    fileprivate var endIcon: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_markersmall")
        t.backgroundColor = .white
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var switchIcon: UIButton! = {
        let t = UIButton()
        t.setImage(UIImage.getBundleImage(name: "navigation_switch"), for: .normal)
        return t
    }()
    
    fileprivate var startLabel: UILabel! = {
        let t = UILabel()
        t.backgroundColor = UIColor.white
        t.textColor = UIColor.ospSentosaBlue
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.isUserInteractionEnabled = true
        return t
    }()
    
    fileprivate var endLabel: UILabel! = {
        let t = UILabel()
        t.backgroundColor = UIColor.white
        t.textColor = UIColor.black
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.isUserInteractionEnabled = true
        return t
    }()
    fileprivate var startLine: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    fileprivate var endLine: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    
    
//    fileprivate var sugTable: UITableView! = {
//        let t = UITableView()
//        t.register(RouteListTableViewCell.self, forCellReuseIdentifier: RouteListTableViewCell.reuseIdentifier)
//        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
//        t.tableFooterView = UIView()
//        t.separatorColor = UIColor.sntWhite
//        t.separatorInset = UIEdgeInsets.zero
//        return t
//    }()
//    fileprivate var walkingTable: UITableView! = {
//        let t = UITableView()
//        t.register(RouteListTableViewCell.self, forCellReuseIdentifier: RouteListTableViewCell.reuseIdentifier)
//        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
//        t.tableFooterView = UIView()
//        t.separatorColor = UIColor.sntWhite
//        t.separatorInset = UIEdgeInsets.zero
//        return t
//    }()
//    fileprivate var busTable: UITableView! = {
//        let t = UITableView()
//        t.register(RouteListTableViewCell.self, forCellReuseIdentifier: RouteListTableViewCell.reuseIdentifier)
//        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
//        t.tableFooterView = UIView()
//        t.separatorColor = UIColor.sntWhite
//        t.separatorInset = UIEdgeInsets.zero
//        return t
//    }()
    
    var pageMenu : CAPSPageMenu?
    fileprivate var controllerArray = [RouteTableViewController]()
    
    // MARK: - Life Cycle
    
    public init(startIndex: FooyoIndex? = nil, endIndex: FooyoIndex? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: FooyoConstants.notifications.FooyoDisplayAlert, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateNavigation(notification:)), name: FooyoConstants.notifications.FooyoUpdateNavigationPoint, object: nil)

//        if mapView.userLocation.
        applyGeneralVCSettings(vc: self)

        mapView.showsUserLocation = true
        
        findMatch(start: startIndex, end: endIndex)

//        refreshData()

        view.addSubview(bigBack)
        bigBack.addSubview(backButton)
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(backHandler))
        bigBack.addGestureRecognizer(backGesture)
        view.addSubview(startLabel)
        view.addSubview(startLine)
        view.addSubview(endLabel)
        view.addSubview(endLine)
        view.addSubview(startIcon)
        view.addSubview(endIcon)
        view.addSubview(switchIcon)
        //        upperView.addSubview(sugBtn)
//        upperView.addSubview(walkingBtn)
//        upperView.addSubview(busBtn)
//        sugTable.delegate = self
//        sugTable.dataSource = self
//        walkingTable.delegate = self
//        walkingTable.dataSource = self
//        busTable.delegate = self
//        busTable.dataSource = self
        
//        sugTable.addSubview(refreshControlOne)
//        sugTable.sendSubview(toBack: refreshControlOne)
//        refreshControlOne.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        walkingTable.addSubview(refreshControlTwo)
//        walkingTable.sendSubview(toBack: refreshControlTwo)
//        refreshControlTwo.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        busTable.addSubview(refreshControlThree)
//        busTable.sendSubview(toBack: refreshControlThree)
//        refreshControlThree.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        
//        activeSug()
//        sugBtn.addTarget(self, action: #selector(activeSug), for: .touchUpInside)
//        walkingBtn.addTarget(self, action: #selector(activeWalking), for: .touchUpInside)
//        busBtn.addTarget(self, action: #selector(activeBus), for: .touchUpInside)
//        scrollView.contentSize = CGSize(width: 3 * Constants.mainWidth, height: Constants.mainHeight - Scale.scaleY(y: 157))
//        sugView.frame = CGRect(x: 0, y: 0, width: Constants.mainWidth, height: Constants.mainHeight - Scale.scaleY(y: 157))
//        walkingView.frame = CGRect(x: Constants.mainWidth, y: 0, width: Constants.mainWidth, height: Constants.mainHeight - Scale.scaleY(y: 157))
//        busView.frame = CGRect(x: 2 * Constants.mainWidth, y: 0, width: Constants.mainWidth, height: Constants.mainHeight - Scale.scaleY(y: 157))
//        
        switchIcon.addTarget(self, action: #selector(switchHandler), for: .touchUpInside)
//        backButton.addTarget(self, action: #selector(backHandler), for: .touchUpInside)
//        
        let startGesture = UITapGestureRecognizer(target: self, action: #selector(startHandler))
        startLabel.addGestureRecognizer(startGesture)
        let endGesture = UITapGestureRecognizer(target: self, action: #selector(endHandler))
        endLabel.addGestureRecognizer(endGesture)
        configurePageViews()
        
        setConstraints()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.navigationBar.isHidden == false {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }
    
    func checkCoordValid(coord: CLLocationCoordinate2D) -> Bool {
        let lat = coord.latitude
        let lon = coord.longitude
        if lat < -90 || lat > 90 {
            return false
        }
        if lon < -180 || lon > 180 {
            return false
        }
        return true
    }
    
    func findMatch(start: FooyoIndex?, end: FooyoIndex?) {
        debugPrint(end)
        debugPrint(end?.category)
        debugPrint(end?.levelOneId)
        debugPrint(end?.levelTwoId)
        if let start = start {
            if start.isNonLinearTrailHotspot() {
                startItem = FooyoItem.items.first(where: { (item) -> Bool in
                    let checkOne = parseOptionalString(input: start.category) == parseOptionalString(input: item.category?.name)
                    let checkTwo = parseOptionalString(input: start.levelOneId) == parseOptionalString(input: item.levelOneId)
                    let checkThree = parseOptionalString(input: start.levelTwoId) == parseOptionalString(input: item.levelTwoId)
                    return checkOne && checkTwo && checkThree
                })
            } else if start.isLocation() {
                startItem = FooyoItem.items.first(where: { (item) -> Bool in
                    let checkOne = parseOptionalString(input: start.category) == parseOptionalString(input: item.category?.name)
                    let checkTwo = parseOptionalString(input: start.levelOneId) == parseOptionalString(input: item.levelOneId)
                    return checkOne && checkTwo
                })
            }
        }
        if let end = end {
            if end.isNonLinearTrailHotspot() {
                endItem = FooyoItem.items.first(where: { (item) -> Bool in
                    let checkOne = parseOptionalString(input: end.category) == parseOptionalString(input: item.category?.name)
                    let checkTwo = parseOptionalString(input: end.levelOneId) == parseOptionalString(input: item.levelOneId)
                    let checkThree = parseOptionalString(input: end.levelTwoId) == parseOptionalString(input: item.levelTwoId)
                    return checkOne && checkTwo && checkThree
                })
            } else if end.isLocation() {
                endItem = FooyoItem.items.first(where: { (item) -> Bool in
                    let checkOne = parseOptionalString(input: end.category) == parseOptionalString(input: item.category?.name)
                    let checkTwo = parseOptionalString(input: end.levelOneId) == parseOptionalString(input: item.levelOneId)
                    return checkOne && checkTwo
                })
            }
        }
        
        let test = FooyoItem.items.first { (item) -> Bool in
            let check = parseOptionalString(input: item.levelOneId) == "481"
            let checkTwo = parseOptionalString(input: item.category?.name) == "Attractions"
            return check && checkTwo
        }
        debugPrint(test)
        debugPrint(test?.category?.name)
        debugPrint(startItem)
        debugPrint(endItem)
        if let end = endItem {
            endLabel.text = end.name
            endItem = end
            endCoord = end.getCoor()
        } else {
            endLabel.text = "Choose Destination..."
            endItem = nil
            endCoord = nil
        }
        if let start = startItem {
            startLabel.text = start.name
            startCoord = start.getCoor()
            if endCoord != nil {
                refreshData()
            }
        } else {
            self.startLabel.text = "Your Location"
            SVProgressHUD.show()
            DispatchQueue.global(qos: .background).async {
                while !self.checkUserLocation() {
                    debugPrint("testing")
                }
                if self.endCoord != nil {
                    self.refreshData()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    func configurePageViews() {
        debugPrint("i am configurePageViews")
        
        controllerArray = [RouteTableViewController]()
        
        
        //        let controllerOne = ItineraryListViewController(itineraries: Itinerary.future)
        let controllerOne = RouteTableViewController()
//        controllerOne.parentVC = self
        controllerOne.title = "RECOMMENDED"
        controllerOne.parentVC = self
        controllerArray.append(controllerOne)
        
        
        //        let controllerTwo = ItineraryListViewController(itineraries: Itinerary.today)
        let controllerTwo = RouteTableViewController()
//        controllerTwo.parentVC = self
        controllerTwo.title = "WALK"
        controllerTwo.parentVC = self
        controllerArray.append(controllerTwo)
        
        //        let controllerThree = ItineraryListViewController(itineraries: Itinerary.past)
        let controllerThree = RouteTableViewController()
//        controllerThree.parentVC = self
        controllerThree.title = "CAR"
        controllerThree.parentVC = self
        controllerArray.append(controllerThree)
        
        let controllerFour = RouteTableViewController()
        //        controllerThree.parentVC = self
        controllerFour.title = "TRANSPORTATION"
        controllerFour.parentVC = self
        controllerArray.append(controllerFour)
        
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: Scale.scaleY(y: 143), width: FooyoConstants.mainWidth, height: FooyoConstants.mainHeight), pageMenuOptions: parameters)
        
        view.addSubview(pageMenu!.view)
    }
    
    
    func startHandler() {
        changeMode = .ChangeStart
        gotoSearchPage(source: .FromNavigation, sourceVC: self)
//        vc.delegate = self
    }
    
    func endHandler() {
        changeMode = .ChangeEnd
        gotoSearchPage(source: .FromNavigation, sourceVC: self)
//        vc.delegate = self
    }
//
    
    func configureVCs() {
        if let sug = sugRoute {
            controllerArray[0].reConfigure(routes: [sug])
        }
        if let walk = walkingRoutes {
            controllerArray[1].reConfigure(routes: walk)
        }
//        if let bus = busRoutes {
//            controllerArray[2].reConfigure(routes: bus)
//        }
        if let bus = busRoutes {
            controllerArray[3].reConfigure(routes: bus)
        }
    }
    
//    func configureLable() {
//        if let end = endItem {
//            self.endLabel.text = end.name
//        } else {
//            self.endLabel.text = "Your Location"
//        }
//        
//        if let start = startItem {
//            self.startLabel.text = start.name
//        } else {
//            self.startLabel.text = "Your Location"
//        }
//    }
    func checkUserLocation() -> Bool {
        var points = FooyoConstants.mapBound
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        if let userLocation = mapView.userLocation?.coordinate {
            if checkCoordValid(coord: userLocation) {
            } else {
                return false
            }
            
            let polygonRenderer = MKPolygonRenderer(polygon: polygon)
            let mapPoint: MKMapPoint = MKMapPointForCoordinate(userLocation)
            let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
            if !polygonRenderer.path.contains(polygonViewPoint) {
                startItem = FooyoItem.vivo
                startCoord = FooyoItem.vivo.getCoor()
                displayAlert(title: "Reminder", message: "The user's current location is not in Sentosa.\nThe starting point will be set to Sentosa Station.", complete: {
                    self.startLabel.text = self.startItem?.name
                })
                return true
            } else {
                startItem = nil
                startCoord = userLocation
                return true
            }
//            return checkCoordValid(coord: userLocation)
        } else {
            startItem = FooyoItem.vivo
            startCoord = FooyoItem.vivo.getCoor()
            displayAlert(title: "Reminder", message: "The user location is unavailable.\nThe starting point will be set to Sentosa Station.", complete: {
                self.startLabel.text = self.startItem?.name
            })
            return true
        }
    }
    
    func refreshData() {
        if !pagination.firstTimeLoaded {
            SVProgressHUD.show()
            pagination.firstTimeLoaded = true
        }
        sugRoute = nil
        walkingRoutes = nil
        busRoutes = nil
        pagination.resetData()
        loadData()
    }
//
    func sortRoutes(routes: [FooyoRoute]?) {
        if let routes = routes {
            for each in routes {
                each.startCoord = startCoord
                each.endCoord = endCoord
                if let start = startItem {
                    each.startItem = start
                }
                if let end = endItem {
                    each.endItem = end
                }
            }
            walkingRoutes = routes.filter({ (route) -> Bool in
                return route.type == "foot"
            })
            busRoutes = routes.filter({ (route) -> Bool in
                return route.type == "bus"
            })
            sugRoute = routes.first(where: { (route) -> Bool in
                return route.suggested == true
            })
            configureVCs()
        }
    }
//
    func loadData() {
        pagination.resetStatus()
        debugPrint(startCoord)
        debugPrint(endCoord)
        HttpClient.sharedInstance.findNavigationFor(start: startCoord!, end: endCoord!) { (routes, isSuccess) in
            if isSuccess {
                self.sortRoutes(routes: routes)
                self.pagination.loaded = true
                self.pagination.error = nil
                self.pagination.updatePage()
            } else {
                self.pagination.error = FooyoConstants.generalErrorMessage
            }
            SVProgressHUD.dismiss()
//            self.refreshControlOne.endRefreshing()
//            self.refreshControlTwo.endRefreshing()
//            self.refreshControlThree.endRefreshing()
//            self.sugTable.reloadData()
//            self.walkingTable.reloadData()
//            self.busTable.reloadData()
        }
    }
//
    func backHandler() {
        _ = navigationController?.popViewController(animated: true)
    }
    
//    func activeSug() {
//        enableSugBtn()
//        distableBusBtn()
//        distableWalkingBtn()
//        debugPrint(Constants.mainWidth)
//        debugPrint(scrollView.frame.height)
//        let size = CGRect(x: 0, y: 0, width: Constants.mainWidth, height: scrollView.frame.height)
//        scrollView.scrollRectToVisible(size, animated: true)
//    }
//    func activeWalking() {
//        enableWalkingBtn()
//        distableBusBtn()
//        distableSugBtn()
//        debugPrint(Constants.mainWidth)
//        debugPrint(scrollView.frame.height)
//        let size = CGRect(x: Constants.mainWidth, y: 0, width: Constants.mainWidth, height: scrollView.frame.height)
//        scrollView.scrollRectToVisible(size, animated: true)
//    }
//    func activeBus() {
//        enableBusBtn()
//        distableSugBtn()
//        distableWalkingBtn()
//        debugPrint(Constants.mainWidth)
//        debugPrint(scrollView.frame.height)
//        let size = CGRect(x: 2 * Constants.mainWidth, y: 0, width: Constants.mainWidth, height: scrollView.frame.height)
//        scrollView.scrollRectToVisible(size, animated: true)
//    }
    func setConstraints() {
        //        sugBtn.snp.makeConstraints { (make) in
//            make.height.equalTo(Scale.scaleY(y: 32))
//            make.leading.equalTo(Scale.scaleX(x: 15))
//            make.bottom.equalTo(Scale.scaleY(y: -8))
//        }
//        walkingBtn.snp.makeConstraints { (make) in
//            make.height.equalTo(sugBtn)
//            make.width.equalTo(sugBtn)
//            make.leading.equalTo(sugBtn.snp.trailing).offset(Scale.scaleX(x: 5))
//            make.centerY.equalTo(sugBtn)
//        }
//        busBtn.snp.makeConstraints { (make) in
//            make.centerY.equalTo(sugBtn)
//            make.height.equalTo(sugBtn)
//            make.width.equalTo(sugBtn)
//            make.leading.equalTo(walkingBtn.snp.trailing).offset(Scale.scaleX(x: 5))
//            make.trailing.equalTo(Scale.scaleX(x: -15))
//        }
//        backButton.snp.makeConstraints { (make) in
////            make.width.equalTo(Scale.scaleX(x: 10.4))
////            make.height.equalTo(Scale.scaleY(y: 17.8))
////            make.leading.equalTo(Scale.scaleX(x: 8.8))
//            make.top.equalTo(Scale.scaleY(y: 35.8))
//            make.leading.equalToSuperview()
//            make.trailing.equalTo(startIcon.snp.leading)
////            make.top.equalTo(startLabel)
//            make.bottom.equalTo(startLabel)
//        }
        
        bigBack.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 10))
            make.width.height.equalTo(Scale.scaleY(y: 30))
        }
        backButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 16))
        }
        
        switchIcon.snp.makeConstraints { (make) in
            make.width.equalTo(Scale.scaleX(x: 19))
            make.height.equalTo(Scale.scaleY(y: 15))
            make.trailing.equalTo(Scale.scaleX(x: -12))
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 50))
        }
        startLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(bigBack.snp.trailing)
            make.trailing.equalTo(switchIcon.snp.leading).offset(Scale.scaleX(x: -9))
            make.centerY.equalTo(switchIcon.snp.top)
        }
        startIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 16))
            make.trailing.equalTo(startLine)
            make.bottom.equalTo(startLine.snp.top).offset(Scale.scaleY(y: -8))
        }
        
        startLabel.snp.makeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 20))
            make.leading.equalTo(startLine).offset(Scale.scaleX(x: 10))
            make.trailing.equalTo(startIcon.snp.leading).offset(Scale.scaleX(x: -4))
            make.bottom.equalTo(startLine.snp.top).offset(Scale.scaleY(y: -7))
        }
//        switchIcon.snp.makeConstraints { (make) in
//            make.centerY.equalTo(dashLine)
//            make.height.width.equalTo(Scale.scaleY(y: 24))
//            make.trailing.equalTo(-Scale.scaleX(x: 8))
//        }
        endLabel.snp.makeConstraints { (make) in
            make.height.equalTo(startLabel)
            make.leading.equalTo(startLabel)
            make.trailing.equalTo(startLabel)
            make.top.equalTo(startLine.snp.bottom).offset(Scale.scaleY(y: 23))
        }
        endLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(startLine)
            make.trailing.equalTo(startLine)
            make.top.equalTo(endLabel.snp.bottom).offset(Scale.scaleY(y: 7))
        }
        endIcon.snp.makeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 14))
            make.width.equalTo(Scale.scaleX(x: 9.8))
            make.centerX.equalTo(startIcon)
            make.bottom.equalTo(endLine.snp.top).offset(Scale.scaleY(y: -8))
        }
    }
    
//        dashLine.snp.makeConstraints { (make) in
//            make.centerX.equalTo(startIcon)
//            make.top.equalTo(startIcon.snp.bottom)
//            make.bottom.equalTo(endIcon.snp.top)
//        }
//        scrollView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.top.equalTo(upperView.snp.bottom)
//        }
//        sugTable.snp.makeConstraints { (make) in
//            make.edges.equalTo(sugView)
//        }
//        walkingTable.snp.makeConstraints { (make) in
//            make.edges.equalTo(walkingView)
//        }
//        busTable.snp.makeConstraints { (make) in
//            make.edges.equalTo(busView)
//        }
//    }
//    
//    func enableSugBtn() {
//        sugBtn.setImage(#imageLiteral(resourceName: "heart_white"), for: .normal)
//        sugBtn.setTitleColor(.white, for: .normal)
//        sugBtn.backgroundColor = UIColor.sntMelon
//    }
//    func distableSugBtn() {
//        sugBtn.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
//        sugBtn.setTitleColor(UIColor.sntGreyishBrown, for: .normal)
//        sugBtn.backgroundColor = UIColor.white
//    }
//    func enableWalkingBtn() {
//        walkingBtn.setImage(#imageLiteral(resourceName: "walking_white"), for: .normal)
//        walkingBtn.setTitleColor(.white, for: .normal)
//        walkingBtn.backgroundColor = UIColor.sntMelon
//    }
//    func distableWalkingBtn() {
//        walkingBtn.setImage(#imageLiteral(resourceName: "walking"), for: .normal)
//        walkingBtn.setTitleColor(UIColor.sntGreyishBrown, for: .normal)
//        walkingBtn.backgroundColor = UIColor.white
//    }
//    func enableBusBtn() {
//        busBtn.setImage(#imageLiteral(resourceName: "bus_white"), for: .normal)
//        busBtn.setTitleColor(.white, for: .normal)
//        busBtn.backgroundColor = UIColor.sntMelon
//    }
//    func distableBusBtn() {
//        busBtn.setImage(#imageLiteral(resourceName: "bus"), for: .normal)
//        busBtn.setTitleColor(UIColor.sntGreyishBrown, for: .normal)
//        busBtn.backgroundColor = UIColor.white
//    }
    func switchHandler() {
        let tmp = startCoord
        startCoord = endCoord
        endCoord = tmp
        let item = startItem
        startItem = endItem
        endItem = item
        let str = startLabel.text
        startLabel.text = endLabel.text
        endLabel.text = str
//        configureLable()
        startLabel.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: 20) + Scale.scaleY(y: 7) + 1 + Scale.scaleY(y: 23))
        endLabel.transform = CGAffineTransform(translationX: 0, y: -(Scale.scaleY(y: 20) + Scale.scaleY(y: 7) + 1 + Scale.scaleY(y: 23)))
        UIView.animate(withDuration: 0.3) { 
            self.startLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.endLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
//        pagination.reset()
//        refreshData()
    }
    func displayAlert(notification: Notification) {
        if let info = notification.object as? [String: String] {
            let title = info["title"] ?? ""
            let msg = info["message"] ?? ""
            displayAlert(title: title, message: msg, complete: nil)
        }
    }
    
    func updateNavigation(notification: Notification) {
        if let item = notification.object as? FooyoItem {
            switch changeMode {
            case .ChangeEnd:
                endItem = item
                endCoord = endItem?.getCoor()
                endLabel.text = endItem?.name
                refreshData()
            case .ChangeStart:
                startItem = item
                startCoord = startItem?.getCoor()
                startLabel.text = startItem?.name
                if endCoord != nil {
                    refreshData()
                }
            default:
                break
            }
        }
    }
}

//extension RouteListViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == sugTable {
//            return 1
//        } else if tableView == walkingTable {
//            if let routes = walkingRoutes {
//                if routes.count > 0 {
//                    return routes.count
//                }
//            }
//            return 1
//        } else {
//            if let routes = busRoutes {
//                if routes.count > 0 {
//                    return routes.count
//                }
//            }
//            return 1
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == sugTable {
//            if let sug = sugRoute {
//                let cell = tableView.dequeueReusableCell(withIdentifier: RouteListTableViewCell.reuseIdentifier, for: indexPath) as! RouteListTableViewCell
//                cell.configureWith(route: sug)
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
//                if let error = pagination.error {
//                    cell.configureWith(error)
//                } else {
//                    if pagination.loaded {
//                        cell.configureWith(Constants.generalErrorMessage)
//                    } else {
//                        cell.configureWith("")
//                    }
//                }
//                return cell
//            }
//        } else if tableView == walkingTable {
//            if let routes = walkingRoutes {
//                if routes.count == 0 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
//                    cell.configureWith("There is no walking path available.")
//                    return cell
//                }
//                let cell = tableView.dequeueReusableCell(withIdentifier: RouteListTableViewCell.reuseIdentifier, for: indexPath) as! RouteListTableViewCell
//                let route = routes[indexPath.row]
//                cell.configureWith(route: route)
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
//                if let error = pagination.error {
//                    cell.configureWith(error)
//                } else {
//                    if pagination.loaded {
//                        cell.configureWith(Constants.generalErrorMessage)
//                    } else {
//                        cell.configureWith("")
//                    }
//                }
//                return cell
//            }
//        } else {
//            if let routes = busRoutes {
//                if routes.count == 0 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
//                    cell.configureWith("There is no bus path available.")
//                    return cell
//                }
//                let cell = tableView.dequeueReusableCell(withIdentifier: RouteListTableViewCell.reuseIdentifier, for: indexPath) as! RouteListTableViewCell
//                let route = routes[indexPath.row]
//                cell.configureWith(route: route)
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
//                if let error = pagination.error {
//                    cell.configureWith(error)
//                } else {
//                    if pagination.loaded {
//                        cell.configureWith(Constants.generalErrorMessage)
//                    } else {
//                        cell.configureWith("")
//                    }
//                }
//                return cell
//            }
//
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == sugTable {
//            if let route = sugRoute {
//                return RouteListTableViewCell.estimateHeightWith(route: route)
//            }
//            return tableView.frame.height
//        } else if tableView == walkingTable {
//            if let routes = walkingRoutes {
//                if routes.count != 0 {
//                    let route = routes[indexPath.row]
//                    return RouteListTableViewCell.estimateHeightWith(route: route)
//                }
//            }
//            return tableView.frame.height
//        } else {
//            if let routes = busRoutes {
//                if routes.count != 0 {
//                    let route = routes[indexPath.row]
//                    return RouteListTableViewCell.estimateHeightWith(route: route)
//                }
//            }
//            return tableView.frame.height
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        if tableView == sugTable {
//            if let route = sugRoute {
//                gotoRouteDetail(route: route)
//            }
//        } else if tableView == walkingTable {
//            if let routes = walkingRoutes {
//                if routes.count != 0 {
//                    let route = routes[indexPath.row]
//                    gotoRouteDetail(route: route)
//                }
//            }
//        } else {
//            if let routes = busRoutes {
//                if routes.count != 0 {
//                    let route = routes[indexPath.row]
//                    gotoRouteDetail(route: route)
//                }
//            }
//        }
//    }
//}
//
//
//extension FooyoNavigationViewController: SearchViewControllerDelegate {
//    func searchViewItemSelected(id: Int, name: String, category: String) {
//        let items = Item.items.filter { (item) -> Bool in
//            return item.id == id
//        }
//        let item = items[0]
//        switch changeMode {
//        case .ChangeStart:
//            if item.id == destination?.id {
//                displayAlert(title: "Error", message: "The starting and the ending points cannot be the same.", complete: nil)
//                return
//            }
//            startLabel.text = name
//            start = item.getCoor()
//            startItem = item
//            pagination.reset()
//            refreshData()
//        default:
//            if item.id == startItem?.id {
//                displayAlert(title: "Error", message: "The starting and the ending points cannot be the same.", complete: nil)
//                return
//            }
//            endLabel.text = name
//            end = item.getCoor()
//            destination = item
//            pagination.reset()
//            refreshData()
//        }
//    }
//}
