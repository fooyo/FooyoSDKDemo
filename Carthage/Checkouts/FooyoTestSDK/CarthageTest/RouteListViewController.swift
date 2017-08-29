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


public class FooyoNavigationViewController: UIViewController {
    
    fileprivate var changeMode = Constants.ChangePoint.ChangeStart
    fileprivate var destination: FooyoItem?
    fileprivate var startItem: FooyoItem?
    
    fileprivate var start: CLLocationCoordinate2D?
    fileprivate var end: CLLocationCoordinate2D?
    
    fileprivate var mapView = MGLMapView()
    
    fileprivate var sugRoute: FooyoRoute?
    fileprivate var walkingRoutes: [FooyoRoute]?
    fileprivate var busRoutes: [FooyoRoute]?
    fileprivate var pagination = FooyoPagination()
    fileprivate var refreshControlOne = UIRefreshControl()
    fileprivate var refreshControlTwo = UIRefreshControl()
    fileprivate var refreshControlThree = UIRefreshControl()

    fileprivate var upperView: UIView = {
        let t = UIView()
        t.backgroundColor = .white
        t.isUserInteractionEnabled = true
        return t
    }()
    
//    fileprivate var backButton: UIButton = {
//        let t = UIButton()
//        t.setImage(#imageLiteral(resourceName: "back"), for: .normal)
//        return t
//    }()
    
    fileprivate var startIcon: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_gps")
        t.backgroundColor = .white
//        t.contentMode = .center
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
//    fileprivate var dashLine: UIImageView! = {
//        let t = UIImageView()
//        t.image = #imageLiteral(resourceName: "dot_line")
//        t.backgroundColor = .white
//        t.contentMode = .center
//        return t
//    }()
    
    fileprivate var switchIcon: UIButton! = {
        let t = UIButton()
        t.setImage(UIImage.getBundleImage(name: "navigation_switch"), for: .normal)
        return t
    }()
    
//    fileprivate var startView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .clear
//        t.isUserInteractionEnabled = true
//        return t
//    }()
//    
//    fileprivate var endView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .clear
//        t.isUserInteractionEnabled = true
//        return t
//    }()
    
    fileprivate var startLabel: UILabel! = {
        let t = UILabel()
        t.backgroundColor = UIColor.white
        t.textColor = UIColor.ospSentosaBlue
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.isUserInteractionEnabled = false
        return t
    }()
    
    fileprivate var endLabel: UILabel! = {
        let t = UILabel()
        t.backgroundColor = UIColor.white
        t.textColor = UIColor.black
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.isUserInteractionEnabled = false
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
    
//    fileprivate var sugBtn: UIButton! = {
//        let t = UIButton()
//        t.layer.cornerRadius = Scale.scaleY(y: 32) / 2
//        t.setTitle("Suggested", for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
//        t.setTitleColor(UIColor.sntGreyishBrown, for: .normal)
////        t.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        t.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        t.clipsToBounds = true
//        return t
//    }()
//    
//    fileprivate var walkingBtn: UIButton! = {
//        let t = UIButton()
//        t.layer.cornerRadius = Scale.scaleY(y: 32) / 2
//        t.setTitle("Walking", for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
//        t.setTitleColor(UIColor.sntGreyishBrown, for: .normal)
//        t.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        t.clipsToBounds = true
//        return t
//    }()
//    
//    fileprivate var busBtn: UIButton! = {
//        let t = UIButton()
//        t.layer.cornerRadius = Scale.scaleY(y: 32) / 2
//        t.setTitle("Transport", for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
//        t.setTitleColor(UIColor.sntGreyishBrown, for: .normal)
//        t.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        t.clipsToBounds = true
//        return t
//    }()
//    
//    fileprivate var scrollView: UIScrollView! = {
//        let t = UIScrollView()
//        t.backgroundColor = .white
//        t.isScrollEnabled = false
//        return t
//    }()
//    
//    fileprivate var sugView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .red
//        return t
//    }()
//    
//    fileprivate var walkingView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .blue
//        return t
//    }()
//    fileprivate var busView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .green
//        return t
//    }()
//    
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
    
    // MARK: - Life Cycle
    public init(startCategory: String? = nil, startLevelOneId: Int? = nil, startLevelTwoId: Int? = nil, endCategory: String?, endLevelOneId: Int?, endLevelTwoId: Int? = nil ) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: Constants.notifications.FooyoDisplayAlert, object: nil)

//        if mapView.userLocation.
        applyGeneralVCSettings(vc: self)

        mapView.showsUserLocation = true

//        initData()
//        
//        refreshData()
        automaticallyAdjustsScrollViewInsets = false
        
//        view.addSubview(scrollView)
//        scrollView.addSubview(sugView)
//        scrollView.addSubview(walkingView)
//        scrollView.addSubview(busView)
//        sugView.addSubview(sugTable)
//        walkingView.addSubview(walkingTable)
//        busView.addSubview(busTable)
        view.addSubview(upperView)
        upperView.addSubview(startLabel)
        upperView.addSubview(startLine)
        upperView.addSubview(endLabel)
        upperView.addSubview(endLine)
        upperView.addSubview(startIcon)
        upperView.addSubview(endIcon)
        upperView.addSubview(switchIcon)
        startLabel.text = "Your location"
        endLabel.text = "Palawan Beach"
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
//        switchIcon.addTarget(self, action: #selector(switchHandler), for: .touchUpInside)
//        backButton.addTarget(self, action: #selector(backHandler), for: .touchUpInside)
//        
//        let gestureOne = UITapGestureRecognizer(target: self, action: #selector(startHandler))
//        startView.addGestureRecognizer(gestureOne)
//        let gestureTwo = UITapGestureRecognizer(target: self, action: #selector(endHandler))
//        endView.addGestureRecognizer(gestureTwo)
        setConstraints()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.isNavigationBarHidden = false
            }
        }
    }
    
//    func startHandler() {
//        changeMode = .ChangeStart
//        let vc = gotoSearchPage(source: .FromNavigation)
//        vc.delegate = self
//    }
//    
//    func endHandler() {
//        changeMode = .ChangeEnd
//        let vc = gotoSearchPage(source: .FromNavigation)
//        vc.delegate = self
//    }
//    
//    func initData() {
//        self.end = destination?.getCoor()
//        checkUserLocation()
//        configureLable()
//    }
    
//    func configureLable() {
//        if let end = destination {
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
//    func checkUserLocation() {
//        var points = Constants.mapBound
//        let polygon = MKPolygon(coordinates: &points, count: points.count)
//        if let userLocation = mapView.userLocation?.location?.coordinate {
//            let polygonRenderer = MKPolygonRenderer(polygon: polygon)
//            let mapPoint: MKMapPoint = MKMapPointForCoordinate(userLocation)
//            let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
//            if !polygonRenderer.path.contains(polygonViewPoint) {
//                displayAlert(title: "Reminder", message: "The user's current location is not in Sentosa.\nThe starting point will be set to VivoCity.", complete: nil)
//            } else {
//                startItem = nil
//                start = userLocation
//                return
//            }
//        } else {
//            displayAlert(title: "Reminder", message: "The user location is unavailable.\nThe starting point will be set to VivoCity.", complete: nil)
//        }
//        start = Constants.vivoLocation
//        startItem = Item.vivo
//    }
//    
//    func refreshData() {
//        if !pagination.firstTimeLoaded {
//            SVProgressHUD.show()
//            pagination.firstTimeLoaded = true
//        }
//        sugRoute = nil
//        walkingRoutes = nil
//        busRoutes = nil
//        pagination.resetData()
//        loadData()
//    }
//    
//    func sortRoutes(routes: [Route]?) {
//        if let routes = routes {
//            for each in routes {
//                each.startCoord = start
//                each.endCoord = end
//                if let start = startItem {
//                    each.startItem = start
//                }
//                if let end = destination {
//                    each.endItem = end
//                }
//            }
//            walkingRoutes = routes.filter({ (route) -> Bool in
//                return route.type == "foot"
//            })
//            busRoutes = routes.filter({ (route) -> Bool in
//                return route.type == "bus"
//            })
//            sugRoute = routes.first(where: { (route) -> Bool in
//                return route.suggested == true
//            })
////            let routes = routes.filter({ (route) -> Bool in
////                return route.suggested == true
////            })
////            let routes = routes.filter(where: { (route) -> Bool in
////                return route.suggested == true
////            })
////            sugRoute = routes[0]
//        }
//    }
//    
//    func loadData() {
//        pagination.resetStatus()
//        HttpClient.sharedInstance.findNavigationFor(start: start!, end: end!) { (routes, isSuccess) in
//            if isSuccess {
//                self.sortRoutes(routes: routes)
//                self.pagination.loaded = true
//                self.pagination.error = nil
//                self.pagination.updatePage()
//            } else {
//                self.pagination.error = Constants.generalErrorMessage
//            }
//            SVProgressHUD.dismiss()
//            self.refreshControlOne.endRefreshing()
//            self.refreshControlTwo.endRefreshing()
//            self.refreshControlThree.endRefreshing()
//            self.sugTable.reloadData()
//            self.walkingTable.reloadData()
//            self.busTable.reloadData()
//        }
//    }
//    
//    func backHandler() {
//        _ = navigationController?.popViewController(animated: true)
//    }
//    
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
        
        upperView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.height.equalTo(Scale.scaleY(y: 100))
        }

        startLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 40))
            make.top.equalToSuperview()
            make.trailing.equalTo(Scale.scaleX(x: -60))
        }
        startLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(Scale.scaleX(x: 30))
            make.trailing.equalTo(Scale.scaleX(x: -40))
            make.top.equalTo(startLabel.snp.bottom)
        }
        startIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(startLabel)
            make.height.width.equalTo(Scale.scaleY(y: 16))
            make.trailing.equalTo(Scale.scaleX(x: -40))//backButton.snp.trailing).offset(Scale.scaleX(x: 13.8))
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
            make.top.equalTo(startLine.snp.bottom)
        }
        endLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(startLine)
            make.trailing.equalTo(startLine)
            make.top.equalTo(endLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
        endIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(endLabel)
            make.height.equalTo(Scale.scaleY(y: 14))
            make.width.equalTo(Scale.scaleX(x: 9.8))
            make.centerX.equalTo(startIcon)
//            make.height.width.equalTo(Scale.scaleY(y: 16))
//            make.leading.equalTo(Scale.scaleX(x: 36))//backButton.snp.trailing).offset(Scale.scaleX(x: 13.8))
        }
        switchIcon.snp.makeConstraints { (make) in
            make.width.equalTo(Scale.scaleX(x: 19))
            make.height.equalTo(Scale.scaleY(y: 15))
            make.centerY.equalToSuperview()
            make.trailing.equalTo(Scale.scaleX(x: -12))
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
//    func switchHandler() {
//        let tmp = start
//        start = end
//        end = tmp
//        let item = startItem
//        startItem = destination
//        destination = item
//        configureLable()
//        startLabel.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: 33) + Scale.scaleY(y: 8))
//        endLabel.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -33) - Scale.scaleY(y: 8))
//        UIView.animate(withDuration: 0.3) { 
//            self.startLabel.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.endLabel.transform = CGAffineTransform(translationX: 0, y: 0)
//        }
//        pagination.reset()
//        refreshData()
//    }
    func displayAlert(notification: Notification) {
        if let info = notification.object as? [String: String] {
            let title = info["title"] ?? ""
            let msg = info["message"] ?? ""
            displayAlert(title: title, message: msg, complete: nil)
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
