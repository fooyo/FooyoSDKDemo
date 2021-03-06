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
    fileprivate var carRoutes: [FooyoRoute]?

    fileprivate var pagination = FooyoPagination()
    
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
        applyGeneralVCSettings(vc: self)

        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: FooyoConstants.notifications.FooyoDisplayAlert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNavigation(notification:)), name: FooyoConstants.notifications.FooyoUpdateNavigationPoint, object: nil)


        mapView.showsUserLocation = true
        findMatch(start: startIndex, end: endIndex)

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
        switchIcon.addTarget(self, action: #selector(switchHandler), for: .touchUpInside)
        
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
        if self.navigationController?.isNavigationBarHidden == false {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.isNavigationBarHidden = true
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
            if startItem == nil {
                displayAlert(title: "Internal Error", message: "The FooyoIndex given for the startpoint is incorrect.", complete: nil)
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
            if endItem == nil {
                displayAlert(title: "Internal Error", message: "The FooyoIndex given for the startpoint is incorrect.", complete: nil)
            }
        }
        
        
        if let end = endItem {
            endLabel.text = end.name
            endItem = end
            endCoord = end.getCoor()
            if endItem?.name?.lowercased().contains("universal studio") == true {
                endCoord = CLLocationCoordinate2D(latitude: 1.256455, longitude: 103.821418)
            }
        } else {
            endLabel.text = "Select A Location..."
            endItem = nil
            endCoord = nil
        }
        if let start = startItem {
            startLabel.text = start.name
            startCoord = start.getCoor()
            if startItem?.name?.lowercased().contains("universal studio") == true {
                startCoord = CLLocationCoordinate2D(latitude: 1.256455, longitude: 103.821418)
            }
            if endCoord != nil {
                refreshData()
            }
        } else {
            self.startLabel.text = "Your Location"
            SVProgressHUD.show()
            DispatchQueue.global(qos: .background).async {
                while !self.checkUserLocation() {
//                    debugPrint("testing")
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
        
//                let controllerThree = ItineraryListViewController(itineraries: Itinerary.past)
        let controllerThree = RouteTableViewController()
        //        controllerThree.parentVC = self
        controllerThree.title = "TRANSPORTATION"
        controllerThree.parentVC = self
        controllerArray.append(controllerThree)
        
        let controllerFour = RouteTableViewController()
        //        controllerThree.parentVC = self
        controllerFour.title = "CAR"
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
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: Scale.scaleY(y: 143), width: FooyoConstants.mainWidth, height: FooyoConstants.mainHeight - Scale.scaleY(y: 143)), pageMenuOptions: parameters)
        pageMenu!.view.removeFromSuperview()
        
        view.addSubview(pageMenu!.view)
    }
    
    
    func startHandler() {
        changeMode = .ChangeStart
        gotoSearchPage(source: .FromNavigation, sourceVC: self)
    }
    
    func endHandler() {
        changeMode = .ChangeEnd
        gotoSearchPage(source: .FromNavigation, sourceVC: self)
    }
//
    
    func configureVCs() {
        if let sug = sugRoute {
            controllerArray[0].reConfigure(routes: [sug])
        }
        if let walk = walkingRoutes {
            controllerArray[1].reConfigure(routes: walk)
        }
        if let bus = busRoutes {
            controllerArray[2].reConfigure(routes: bus)
        }
        if let car = carRoutes {
            controllerArray[3].reConfigure(routes: car)
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
//            debugPrint(userLocation.latitude)
//            debugPrint(userLocation.longitude)
//            startItem = nil
//            startCoord = CLLocationCoordinate2D(latitude: 1.252815, longitude: 103.821172)
//            return true
//            
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
        carRoutes = nil
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
            debugPrint("i am sorting the routes")
            for each in routes {
                debugPrint(each.type)
            }
            walkingRoutes = routes.filter({ (route) -> Bool in
                return route.type == FooyoConstants.RouteType.Walking.rawValue
            })
            busRoutes = routes.filter({ (route) -> Bool in
                return route.type == FooyoConstants.RouteType.PSV.rawValue
            })
            carRoutes = routes.filter({ (route) -> Bool in
                return route.type == FooyoConstants.RouteType.Car.rawValue
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
        }
    }
//
    func backHandler() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setConstraints() {
        bigBack.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 10))
            make.width.height.equalTo(Scale.scaleY(y: 40))
//            make.height.equalTo(Scale.scaleY(y: 100))
        }
        backButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 16))
//            make.top.equalTo(Scale.scaleY(y: <#T##CGFloat#>))
//            make.centerY.equalTo(Scale.scaleY(y: -35))
//            make.centerY.equalToSuperview()
//            make.top.equalToSuperview()
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
    
    func switchHandler() {
        let tmp = CLLocationCoordinate2D(latitude: (startCoord?.latitude)!, longitude: (startCoord?.longitude)!)
        startCoord = CLLocationCoordinate2D(latitude: (endCoord?.latitude)!, longitude: (endCoord?.longitude)!)
        endCoord = tmp
        
        let item = startItem?.makeCopy()
        startItem = endItem?.makeCopy()
        endItem = item
        
        let str = startLabel.text
        startLabel.text = endLabel.text
        endLabel.text = str

        startLabel.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: 20) + Scale.scaleY(y: 7) + 1 + Scale.scaleY(y: 23))
        endLabel.transform = CGAffineTransform(translationX: 0, y: -(Scale.scaleY(y: 20) + Scale.scaleY(y: 7) + 1 + Scale.scaleY(y: 23)))
        UIView.animate(withDuration: 0.3) { 
            self.startLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.endLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        pagination.reset()
        refreshData()
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
                if endItem?.name?.lowercased().contains("universal studio") == true {
                    endCoord = CLLocationCoordinate2D(latitude: 1.256455, longitude: 103.821418)
                }
                if startCoord != nil {
                    pagination.reset()
                    refreshData()
                }
            case .ChangeStart:
                startItem = item
                startCoord = startItem?.getCoor()
                startLabel.text = startItem?.name
                if startItem?.name?.lowercased().contains("universal studio") == true {
                    startCoord = CLLocationCoordinate2D(latitude: 1.256455, longitude: 103.821418)
                }

                if endCoord != nil {
                    pagination.reset()
                    refreshData()
                }
            default:
                break
            }
        }
    }
}

