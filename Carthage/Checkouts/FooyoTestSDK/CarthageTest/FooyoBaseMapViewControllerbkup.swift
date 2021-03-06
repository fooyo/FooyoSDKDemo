////
////  FooyoBaseMapViewController.swift
////  CarthageTest
////
////  Created by Yangfan Liu on 2/8/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import UIKit
//import Mapbox
//import AlamofireImage
//import SVProgressHUD
//
//public protocol FooyoBaseMapViewControllerDelegate: class {
//    func fooyoBaseMapViewController(didSelectInformationWindow index: FooyoIndex)
//}
////import
//public class FooyoBaseMapViewController: UIViewController {
//    public weak var delegate: FooyoBaseMapViewControllerDelegate?
//    
//    var addCount = 0
//
//    //MARK: - Variables for Plan Creation
//    var itinerary: FooyoItinerary?
//    
//    //MARK: - Variables for general map
//    var hideBar = true
//    var sourcePage = FooyoConstants.PageSource.FromHomeMap
//    
//    var items: [FooyoItem]?
//    fileprivate var scaled = false
//    //MARK: - Variables for MapView
//    var mapView: MGLMapView!
//    var mapCenter: CLLocationCoordinate2D?
//    
//    var allAnnotations = [MyCustomPointAnnotation]()
//    var attractionAnnotations = [MyCustomPointAnnotation]()
//    var eventAnnotations = [MyCustomPointAnnotation]()
//    var trailAnnotations = [MyCustomPointAnnotation]()
//    var prayerAnnotations = [MyCustomPointAnnotation]()
//    var ticketAnnotations = [MyCustomPointAnnotation]()
//    var restroomAnnotations = [MyCustomPointAnnotation]()
//    var busAnnotations = [MyCustomPointAnnotation]()
//    var tramAnnotations = [MyCustomPointAnnotation]()
//    var cableAnnotations = [MyCustomPointAnnotation]()
//    var expressAnnotations = [MyCustomPointAnnotation]()
//    var funAnnotations = [MyCustomPointAnnotation]()
//    var nursingAnnotations = [MyCustomPointAnnotation]()
//    var taxiAnnotations = [MyCustomPointAnnotation]()
////    var isAttractionVisiable = false
////    var isEventVisible = false
//    var essentialAnnotations = [MyCustomPointAnnotation]()
//    var nonEssentialAnnotations = [MyCustomPointAnnotation]()
//
//    var searchItem: FooyoItem?
//    var searchAnnotation: MyCustomPointAnnotation?
//    
//    //MARK: - Variables for SearchView
//    var searchView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .white
//        t.layer.cornerRadius = 6
//        t.layer.shadowColor = UIColor.ospBlack20.cgColor
//        t.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
//        t.layer.shadowRadius = Scale.scaleY(y: 4)
//        t.layer.shadowOpacity = 1
//        t.isUserInteractionEnabled = true
//        return t
//    }()
//    
//    var searchIcon: UIImageView! = {
//        let t = UIImageView()
//        t.backgroundColor = .clear
//        t.contentMode = .scaleAspectFit
//        t.clipsToBounds = true
//        t.applyBundleImage(name: "basemap_markersmall")
//        return t
//    }()
//    var crossIcon: UIImageView! = {
//        let t = UIImageView()
//        t.backgroundColor = .clear
//        t.contentMode = .scaleAspectFit
//        t.clipsToBounds = true
//        t.isHidden = true
//        t.isUserInteractionEnabled = true
//        t.applyBundleImage(name: "basemap_cross")
//        return t
//    }()
//    var searchLabel: UILabel! = {
//        let t = UILabel()
//        t.text = "Where would you like to go?"
//        t.textColor = UIColor.ospDarkGrey
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        t.isUserInteractionEnabled = true
//        return t
//    }()
//    
//    var filterBtn: ShadowView! = {
//        let t = ShadowView()
//        t.backgroundColor = .white
//        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
//        t.isUserInteractionEnabled = true
//        return t
//    }()
//    
//    var filterBtnInside: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "basemap_filter")
//        t.contentMode = .scaleAspectFit
//        t.layer.cornerRadius = Scale.scaleY(y: 15) / 2
//        return t
//    }()
//    
//    var gpsBtn: ShadowView! = {
//        let t = ShadowView()
//        t.backgroundColor = .white
//        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
//        return t
//    }()
//    
//    var gpsBtnInside: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "basemap_gps")
//        t.contentMode = .scaleAspectFit
//        t.layer.cornerRadius = Scale.scaleY(y: 22) / 2
//        return t
//    }()
//    
//    var goBtn: ShadowView! = {
//        let t = ShadowView()
//        t.backgroundColor = UIColor.ospSentosaGreen
//        t.layer.cornerRadius = Scale.scaleY(y: 52) / 2
//        t.isUserInteractionEnabled = true
//        return t
//    }()
//    
//    var goBtnInside: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "basemap_direction")
//        t.contentMode = .scaleAspectFit
//        t.layer.cornerRadius = Scale.scaleY(y: 22) / 2
//        return t
//    }()
//    
//    var goBtnInsideLabel: UILabel! = {
//        let t = UILabel()
//        t.textColor = .white
//        t.backgroundColor = .clear
//        t.textAlignment = .center
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
//        t.text = "GO"
//        return t
//    }()
//    
//    fileprivate var filterView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .clear
//        return t
//    }()
//    
//    fileprivate var overLay: UIView! = {
//        let t = UIView()
//        t.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        t.isUserInteractionEnabled = true
//        return t
//    }()
//    fileprivate var categoryTable: UITableView! = {
//        let t = UITableView()
//        t.backgroundColor = .clear
//        t.separatorInset = UIEdgeInsets.zero
//        t.separatorColor = .clear
//        t.separatorStyle = .singleLine
//        t.clipsToBounds = true
//        t.layer.cornerRadius = 12
//        t.isScrollEnabled = false
//        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
//        return t
//    }()
//    fileprivate var amenityTable: UITableView! = {
//        let t = UITableView()
//        t.backgroundColor = .clear
//        t.separatorInset = UIEdgeInsets.zero
//        t.separatorColor = .clear
//        t.separatorStyle = .singleLine
//        t.clipsToBounds = true
//        t.layer.cornerRadius = 12
//        t.isScrollEnabled = false
//        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
//        return t
//    }()
//    fileprivate var transportationTable: UITableView! = {
//        let t = UITableView()
//        t.backgroundColor = .clear
//        t.separatorInset = UIEdgeInsets.zero
//        t.separatorColor = .clear
//        t.separatorStyle = .singleLine
//        t.clipsToBounds = true
//        t.layer.cornerRadius = 12
//        t.isScrollEnabled = false
//        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
//        return t
//    }()
//    fileprivate var cancelBtn: UILabel! = {
//        let t = UILabel()
//        t.backgroundColor = UIColor.white.withAlphaComponent(0.9)
//        t.clipsToBounds = true
//        t.layer.cornerRadius = 12
//        t.text = "Cancel"
//        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 18))
//        t.textColor = UIColor.ospIoSblue
//        t.textAlignment = .center
//        t.isUserInteractionEnabled = true
//        return t
//    }()
//    
//    //    fileprivate var
//    //for show on map
//    fileprivate var index: FooyoIndex?
//    fileprivate var selectedCategory: FooyoCategory?
//    fileprivate var isShowAll: Bool {
//        return selectedCategory == nil
//    }
//    
//    //    fileprivate var selectedCategory: String?
//    //    fileprivate var selectedId: Int?
//    //    fileprivate var showOnMapMode: Bool = false
//    //MARK: - Life Cycle
//    //    public init(category: String? = nil, levelOneId: Int? = nil) {
//    //        super.init(nibName: nil, bundle: nil)
//    //        self.selectedCategory = category
//    //        self.selectedId = levelOneId
//    //        if category != nil {
//    //            self.showOnMapMode = true
//    //        } else {
//    //            self.showOnMapMode = false
//    //        }
//    //    }
//    
//    public init(index: FooyoIndex? = nil, hideTheDefaultNavigationBar: Bool) {
//        super.init(nibName: nil, bundle: nil)
//        self.index = index
//        self.hideBar = hideTheDefaultNavigationBar
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        applyGeneralVCSettings(vc: self)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: FooyoConstants.notifications.FooyoDisplayAlert, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(highlightSearch(notification:)), name: FooyoConstants.notifications.FooyoSearch, object: nil)
//        
//        setupMapView()
//        setupSearchView()
//        setupOtherViews()
//        setupCategoryListView()
//        checkBundle()
//        
//        loadPlaces()
//        loadCategries(withLoading: false)
//    }
//    
//    override public func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if let anno = searchAnnotation {
//            debugPrint("i am going to center")
//            
//            //                self.mapView.setCenter((searchItem?.getCoor())!, zoomLevel: 15, animated: true)
//            //                self.mapView.selectAnnotation(anno, animated: true)
//            
//            mapView.setCenter((searchItem?.getCoor())!, zoomLevel: 15, direction: 0, animated: true) {
//                self.mapView.selectAnnotation(anno, animated: true)
//            }
//        }
//        
//        if index != nil {
//            if let annotations = mapView.annotations as? [MyCustomPointAnnotation] {
//                let anno = annotations[0]
//                let item = anno.item
//                mapView.setCenter((item?.getCoor())!, zoomLevel: 15, direction: 0, animated: true) {
//                    self.mapView.selectAnnotation(anno, animated: true)
//                }
//            }
//        }
//        
//        //        if self.navigationController?.navigationBar.isHidden == false {
//        //            UIView.animate(withDuration: 0.3, animations: {
//        //                self.navigationController?.navigationBar.isHidden = true
//        //            })
//        //        }
//    }
//    
//    override public func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if hideBar {
//            if self.navigationController?.isNavigationBarHidden == false {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.navigationController?.isNavigationBarHidden = true
//                })
//            }
//        } else {
//            if self.navigationController?.isNavigationBarHidden == true {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.navigationController?.isNavigationBarHidden = false
//                })
//            }
//        }
//    }
//    
//    
//    
//    //MARK: - Setup Views
//    func setupSearchView() {
//        view.addSubview(searchView)
//        //        searchView.addSubview(searchIconOne)
//        searchView.addSubview(searchLabel)
//        searchView.addSubview(searchIcon)
//        searchView.addSubview(crossIcon)
//        let crossGesture = UITapGestureRecognizer(target: self, action: #selector(crossHandler))
//        crossIcon.addGestureRecognizer(crossGesture)
//        //        searchView.addSubview(crossIconOne)
//        //        crossIconOne.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI_4))
//        //        let crossGesture = UITapGestureRecognizer(target: self, action: #selector(crossHandler))
//        //        crossIconOne.addGestureRecognizer(crossGesture)
//        let searchGesture = UITapGestureRecognizer(target: self, action: #selector(searchHandler))
//        searchView.addGestureRecognizer(searchGesture)
//        searchViewConstraints()
//    }
//    
//    func setupMapView() {
//        //        mapView = MGLMapView(frame: view.bounds)
//        mapView = MGLMapView()
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        // Set the map’s center coordinate and zoom level.
//        mapCenter = CLLocationCoordinate2D(latitude: FooyoConstants.mapCenterLat, longitude: FooyoConstants.mapCenterLong)
//        mapView.setCenter(mapCenter!, zoomLevel: FooyoConstants.initZoomLevel, animated: false)
//        mapView.showsUserLocation = true
//        mapView.delegate = self
//        view.addSubview(mapView)
////        mapView.mode
//        mapView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//    }
//    
//    func setupOtherViews() {
//        view.addSubview(filterBtn)
//        filterBtn.addSubview(filterBtnInside)
//        let filterGesture = UITapGestureRecognizer(target: self, action: #selector(filterHandler))
//        filterBtn.addGestureRecognizer(filterGesture)
//        
//        view.addSubview(gpsBtn)
//        gpsBtn.addSubview(gpsBtnInside)
//        let locateGesture = UITapGestureRecognizer(target: self, action: #selector(locateHandler))
//        gpsBtn.addGestureRecognizer(locateGesture)
//        view.addSubview(goBtn)
//        goBtn.addSubview(goBtnInside)
//        goBtn.addSubview(goBtnInsideLabel)
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(goBtnHandler))
//        goBtn.addGestureRecognizer(gesture)
//        //        if showOnMapMode {
//        //            filterBtn.isHidden = true
//        //        }
//        
//        otherViewsConstraints()
//    }
//    
//    func setupCategoryListView() {
//        
//        //        view.addSubview(filterView)
//        if let vc = self.tabBarController {
//            vc.view.addSubview(filterView)
//        } else if let vc = self.navigationController {
//            vc.view.addSubview(filterView)
//        } else {
//            view.addSubview(filterView)
//        }
//        filterView.addSubview(overLay)
//        let overLayGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilter))
//        overLay.addGestureRecognizer(overLayGesture)
//        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilter))
//        cancelBtn.addGestureRecognizer(cancelGesture)
//        
//        filterView.addSubview(categoryTable)
//        filterView.addSubview(amenityTable)
//        filterView.addSubview(transportationTable)
//        filterView.addSubview(cancelBtn)
//        categoryTable.delegate = self
//        categoryTable.dataSource = self
//        amenityTable.delegate = self
//        amenityTable.dataSource = self
//        transportationTable.delegate = self
//        transportationTable.dataSource = self
//        categoryListConstraints()
//    }
//    
//    func categoryListConstraints() {
//        
//        filterView.snp.remakeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.height.equalTo(FooyoConstants.mainHeight)
//            make.top.equalTo((filterView.superview?.snp.bottom)!)
//        }
//        overLay.snp.remakeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//        cancelBtn.snp.remakeConstraints { (make) in
//            make.height.equalTo(Scale.scaleY(y: 48))
//            make.leading.equalTo(Scale.scaleX(x: 8))
//            make.trailing.equalTo(Scale.scaleX(x: -8))
//            make.bottom.equalTo(Scale.scaleY(y: -10))
//        }
//        categoryTable.snp.remakeConstraints { (make) in
//            make.bottom.equalTo(cancelBtn.snp.top).offset(Scale.scaleY(y: -8))
//            make.leading.equalTo(Scale.scaleX(x: 8))
//            make.trailing.equalTo(Scale.scaleX(x: -8))
//            make.height.equalTo(CGFloat(FooyoCategory.others.count + 3) * (Scale.scaleY(y: 47.5)))
//        }
//        amenityTable.snp.remakeConstraints { (make) in
//            make.bottom.equalTo(categoryTable)
//            make.leading.equalTo(filterView.snp.trailing).offset(Scale.scaleX(x: 8))
//            make.width.equalTo(categoryTable)
//            make.height.equalTo(CGFloat(FooyoCategory.amenities.count + 1) * (Scale.scaleY(y: 47.5)))
//        }
//        transportationTable.snp.remakeConstraints { (make) in
//            make.bottom.equalTo(categoryTable)
//            make.leading.equalTo(filterView.snp.trailing).offset(Scale.scaleX(x: 8))
//            make.width.equalTo(categoryTable)
//            make.height.equalTo(CGFloat(FooyoCategory.transportations.count + 1) * (Scale.scaleY(y: 47.5)))
//        }
//    }
//    
//    func searchViewConstraints() {
//        searchView.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 10))
//            make.trailing.equalTo(Scale.scaleX(x: -10))
//            make.height.equalTo(Scale.scaleY(y: 40))
//            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 10))
//            //            make.top.equalTo(Constants.statusBarHeight + Scale.scaleY(y: 10))
//        }
//        searchLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(Scale.scaleX(x: 10))
//        }
//        searchIcon.snp.makeConstraints { (make) in
//            make.height.equalTo(Scale.scaleY(y: 14))
//            make.width.equalTo(Scale.scaleX(x: 9.8))
//            make.centerY.equalToSuperview()
//            make.trailing.equalTo(Scale.scaleX(x: -12.2))
//        }
//        crossIcon.snp.makeConstraints { (make) in
//            make.edges.equalTo(searchIcon)
//        }
//    }
//    
//    func otherViewsConstraints() {
//        filterBtn.snp.makeConstraints { (make) in
//            make.height.width.equalTo(Scale.scaleY(y: 40))
//            make.top.equalTo(searchView.snp.bottom).offset(Scale.scaleY(y: 16))
//            make.trailing.equalTo(Scale.scaleX(x: -16))
//        }
//        filterBtnInside.snp.makeConstraints { (make) in
//            make.width.height.equalTo(Scale.scaleY(y: 17))
//            make.center.equalToSuperview()
//        }
//        gpsBtn.snp.makeConstraints { (make) in
//            make.height.width.equalTo(Scale.scaleY(y: 40))
//            make.trailing.equalTo(Scale.scaleX(x: -16))
//            make.bottom.equalTo(goBtn.snp.top).offset(Scale.scaleY(y: -16))
//        }
//        gpsBtnInside.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.height.width.equalTo(Scale.scaleY(y: 22))
//        }
//        goBtn.snp.makeConstraints { (make) in
//            make.height.width.equalTo(Scale.scaleY(y: 52))
//            make.trailing.equalTo(-Scale.scaleY(y: 10))
//            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(Scale.scaleY(y: -10))
//        }
//        goBtnInside.snp.makeConstraints { (make) in
//            make.height.width.equalTo(Scale.scaleY(y: 22))
//            make.centerX.equalToSuperview()
//            make.top.equalTo(Scale.scaleY(y: 8))
//        }
//        goBtnInsideLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(goBtnInside.snp.bottom)
//            make.bottom.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//        }
//    }
//    
//    //MARK: HTTP
//    func loadCategries(withLoading: Bool) {
//        if FooyoCategory.categories.isEmpty {
//            if withLoading {
//                SVProgressHUD.show()
//            }
//            HttpClient.sharedInstance.getCategories { (categories, isSuccess) in
//                SVProgressHUD.dismiss()
//                if isSuccess {
//                    debugPrint("success")
//                    self.categoryListConstraints()
//                    self.categoryTable.reloadData()
//                    self.amenityTable.reloadData()
//                    self.transportationTable.reloadData()
//                } else {
//                    debugPrint("fail")
//                }
//            }
//        }
//    }
//    
//    func loadPlaces() {
//        if FooyoItem.items.isEmpty {
//            SVProgressHUD.show()
//            HttpClient.sharedInstance.getItems { (places, isSuccess) in
//                SVProgressHUD.dismiss()
//                if isSuccess {
//                    debugPrint("success")
//                    self.items = places
//                    debugPrint("in total has \(self.items?.count) items")
//                    self.reloadData()
//                } else {
//                    debugPrint("fail")
//                }
//            }
//        } else {
//            self.items = FooyoItem.items
//            self.reloadData()
//        }
//    }
//    
//    //MARK: Handler
//    func filterHandler() {
//        UIView.animate(withDuration: 0.3) {
//            self.filterView.transform = CGAffineTransform.init(translationX: 0, y: -FooyoConstants.mainHeight)
//        }
//    }
//    
//    func dismissFilter() {
//        UIView.animate(withDuration: 0.3) {
//            self.categoryTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
//            self.transportationTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
//            self.amenityTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
//            self.filterView.transform = CGAffineTransform.init(translationX: 0, y: 0)
//        }
//    }
//    
//    func displayAmenities() {
//        UIView.animate(withDuration: 0.3) {
//            self.categoryTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
//            self.amenityTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
//        }
//    }
//    
//    
//    func displayTransportations() {
//        UIView.animate(withDuration: 0.3) {
//            self.categoryTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
//            self.transportationTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
//        }
//    }
//    
//    func displayCategories() {
//        UIView.animate(withDuration: 0.3) {
//            self.categoryTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
//            self.transportationTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
//            self.amenityTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
//        }
//    }
//    
//    func locateHandler() {
//        //        self.mapView.setCenter((allAnnotations[0].item?.getCoor())!, zoomLevel: 15, direction: 0, animated: true) {
//        //            self.mapView.selectAnnotation(self.allAnnotations[0], animated: true)
//        //        }
//        mapView.userTrackingMode = .followWithHeading
//    }
//    func goBtnHandler() {
//        //        featureUnavailable()
//        let vc = FooyoNavigationViewController(startIndex: nil, endIndex: nil)
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func crossHandler() {
//        searchItem = nil
//        crossIcon.isHidden = true
//        searchIcon.isHidden = false
//        searchLabel.text = "Where would you like to go?"
//        if let anno = searchAnnotation {
//            reloadAnnotation(annotation: anno)
//        }
//        searchAnnotation = nil
//    }
//    
//    func searchHandler() {
//        gotoSearchPage(source: .FromHomeMap, sourceVC: self)
//    }
//    
//    //MAKR: Data Handler
//    func reloadData() {
//        sortItems()
//        reloadMapIcons()
//    }
//    
//    func sortItems() {
//        if let items = items {
//            allAnnotations = [MyCustomPointAnnotation]()
//            attractionAnnotations = [MyCustomPointAnnotation]()
//            eventAnnotations = [MyCustomPointAnnotation]()
//            trailAnnotations = [MyCustomPointAnnotation]()
//            prayerAnnotations = [MyCustomPointAnnotation]()
//            ticketAnnotations = [MyCustomPointAnnotation]()
//            restroomAnnotations = [MyCustomPointAnnotation]()
//            busAnnotations = [MyCustomPointAnnotation]()
//            tramAnnotations = [MyCustomPointAnnotation]()
//            cableAnnotations = [MyCustomPointAnnotation]()
//            expressAnnotations = [MyCustomPointAnnotation]()
//            funAnnotations = [MyCustomPointAnnotation]()
//            nursingAnnotations = [MyCustomPointAnnotation]()
//            taxiAnnotations = [MyCustomPointAnnotation]()
//            essentialAnnotations = [MyCustomPointAnnotation]()
//            nonEssentialAnnotations = [MyCustomPointAnnotation]()
//
//            for each in items {
//                let point = MyCustomPointAnnotation()
//                point.coordinate = CLLocationCoordinate2D(latitude: each.coordinateLan!, longitude: each.coordinateLon!)
//                point.title = each.name
//                point.item = each
//                point.reuseId = each.category?.name
//                allAnnotations.append(point)
//                switch (each.category?.name)! {
//                case "Attractions":
//                    attractionAnnotations.append(point)
//                    essentialAnnotations.append(point)
//                case "Events":
//                    eventAnnotations.append(point)
//                    essentialAnnotations.append(point)
//                case "Interactive Trails":
//                    trailAnnotations.append(point)
//                    essentialAnnotations.append(point)
//                case "Prayer Rooms":
//                    prayerAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                case "Ticketing Counters":
//                    ticketAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                case "Rest Rooms":
//                    restroomAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                case "Bus Stops":
//                    busAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                case "Tram Stops":
//                    tramAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                case "Cable Car Stations":
//                    cableAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                case "Express Stations":
//                    expressAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                case "Fun Shops":
//                    funAnnotations.append(point)
//                    essentialAnnotations.append(point)
//                case "Nursing Room":
//                    nursingAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                case "Taxi Stand":
//                    taxiAnnotations.append(point)
//                    nonEssentialAnnotations.append(point)
//                default:
//                    break
//                }
//            }
//        }
//    }
//    
//    func reloadCategory() {
//        clearMapView()
//        var allAnno = [MyCustomPointAnnotation]()
//        if let name = self.selectedCategory?.name {
//            switch name {
//            case "Attractions":
//                allAnno.append(contentsOf: attractionAnnotations)
//            case "Events":
//                allAnno.append(contentsOf: eventAnnotations)
//            case "Interactive Trails":
//                allAnno.append(contentsOf: trailAnnotations)
//            case "Prayer Rooms":
//                allAnno.append(contentsOf: prayerAnnotations)
//            case "Ticketing Counters":
//                allAnno.append(contentsOf: ticketAnnotations)
//            case "Rest Rooms":
//                allAnno.append(contentsOf: restroomAnnotations)
//            case "Bus Stops":
//                allAnno.append(contentsOf: busAnnotations)
//            case "Tram Stops":
//                allAnno.append(contentsOf: tramAnnotations)
//            case "Cable Car Stations":
//                allAnno.append(contentsOf: cableAnnotations)
//            case "Express Stations":
//                allAnno.append(contentsOf: expressAnnotations)
//            case "Fun Shops":
//                allAnno.append(contentsOf: funAnnotations)
//            case "Nursing Room":
//                allAnno.append(contentsOf: nursingAnnotations)
//            case "Taxi Stand":
//                allAnno.append(contentsOf: taxiAnnotations)
//            default:
//                break
//            }
//        } else {
//            allAnno.append(contentsOf: allAnnotations)
//        }
//        
//        for each in allAnno {
//            mapView.addAnnotation(each)
//        }
//    }
//    
//    func reloadMapIcons() {
//        clearMapView()
//        var allAnno = [MyCustomPointAnnotation]()
//        if let index = index {
//            searchView.isHidden = true
//            filterBtn.isHidden = true
//            goBtn.isHidden = true
//            if index.isLocation() {
//                allAnno = allAnnotations.filter({ (annotation) -> Bool in
//                    if (annotation.item?.category?.name)!.lowercased() == (index.category)!.lowercased() && annotation.item?.levelOneId == index.levelOneId {
//                        return true
//                    }
//                    return false
//                })
//            } else if index.isCategory() {
//                allAnno = allAnnotations.filter({ (annotation) -> Bool in
//                    if (annotation.item?.category?.name)!.lowercased() == (index.category)!.lowercased() {
//                        return true
//                    }
//                    return false
//                })
//                debugPrint(allAnno.count)
//            }
//        } else {
//            allAnno.append(contentsOf: attractionAnnotations)
//            allAnno.append(contentsOf: eventAnnotations)
//            allAnno.append(contentsOf: trailAnnotations)
//            allAnno.append(contentsOf: funAnnotations)
//
//            //            if let selected = selectedCategory {
//            //                allAnno = allAnnotations.filter({ (annotation) -> Bool in
//            //                    if let search = searchItem {
//            //                        if annotation.item?.id == search.id {
//            //                            return true
//            //                        }
//            //                    }
//            //                    return annotation.item?.category?.id == selected.id
//            //                })
//            //                debugPrint(allAnno.count)
//            //            } else {
//            ////                allAnno = allAnnotations.filter({ (anno) -> Bool in
//            ////                    if let search = searchItem {
//            ////                        if anno.item?.id == search.id {
//            ////                            return true
//            ////                        }
//            ////                    }
//            ////                    return anno.item?.isEssential() == true
//            ////                })
//            //                allAnno = allAnnotations
//            //            }
//        }
//        
//        for each in allAnno {
//            mapView.addAnnotation(each)
//        }
//    }
//    
//    func clearMapView() {
//        for each in allAnnotations {
//            mapView.removeAnnotation(each)
//        }
////        mapView.removeAnnotations(allAnnotations)
//    }
//    
//    func reloadAnnotation(annotation: MyCustomPointAnnotation) {
//        mapView.removeAnnotation(annotation)
//        mapView.addAnnotation(annotation)
//    }
//    
//    func checkBundle() {
//        if let bundlePath: String = Bundle.main.path(forResource: "FooyoSDK", ofType: "bundle") {
//            if let _ = Bundle(path: bundlePath) {
//                return
//            }
//        }
//        PostAlertNotification(title: "Error", message: "The \"FooyoSDK\" file is missing.")
//    }
//    
//    func displayAlert(notification: Notification) {
//        if let info = notification.object as? [String: String] {
//            let title = info["title"] ?? ""
//            let msg = info["message"] ?? ""
//            displayAlert(title: title, message: msg, complete: nil)
//        }
//    }
//    
//    func highlightSearch(notification: Notification) {
//        if let item = notification.object as? FooyoItem {
//            searchItem = item
//            searchLabel.text = item.name
//            crossIcon.isHidden = false
//            searchIcon.isHidden = true
//            if let anno = searchAnnotation {
//                searchItem = nil
//                reloadAnnotation(annotation: anno)
//            }
//            searchItem = item
//            searchAnnotation = allAnnotations.first(where: { (anno) -> Bool in
//                return anno.item?.id == searchItem?.id
//            })
//            if let anno = searchAnnotation {
//                reloadAnnotation(annotation: anno)
//            }
//        }
//    }
//    
//}
//
////MARK: - MAP delegate
//extension FooyoBaseMapViewController: MGLMapViewDelegate {
//    public func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        //        return MGLAnnotationView()
//        // This example is only concerned with point annotations.
//        if let annotation = annotation as? MyCustomPointAnnotation {
//            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
//            addCount = addCount + 1
//            debugPrint("i am adding \(addCount)")
//            var reuseIdentifier = ""
//            reuseIdentifier = (annotation.reuseId)!
//            if annotation.item?.id == searchItem?.id {
//                reuseIdentifier = FooyoConstants.AnnotationId.UserMarker.rawValue
//            }
//            
//            if let items = self.itinerary?.items {
//                for each in items {
//                    if annotation.item?.id == each.id {
//                        reuseIdentifier = FooyoConstants.AnnotationId.ItineraryItem.rawValue
//                        break
//                    }
//                }
//            }
//            
//            // For better performance, always try to reuse existing annotations.
//            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView {
//                return annotationView
//            } else {
//                var annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
//                if reuseIdentifier == FooyoConstants.AnnotationId.ItineraryItem.rawValue {
//                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 25), height: Scale.scaleY(y: 25))
//                    if let index = self.itinerary?.items?.index(of: annotation.item!) {
//                        annotationView.indexLabel.text = "\(index + 1)"
//                    }
//                } else if reuseIdentifier == FooyoConstants.AnnotationId.UserMarker.rawValue {
//                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 17), height: Scale.scaleY(y: 48))
//                } else {
//                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 12), height: Scale.scaleY(y: 12))
////                    annotationView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//                    if annotation.item?.isEssential() == true {
//                        if mapView.zoomLevel > 14 {
////                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
////                                annotationView.transform = CGAffineTransform.init(scaleX: 1.8, y: 1.8)
////                            }, completion: nil)
//                            annotationView.transform = CGAffineTransform.init(scaleX: 1.8, y: 1.8)
//                        } else {
////                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
////                                annotationView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
////                            }, completion: nil)
//                            annotationView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
//                        }
//                    } else {
//                        if mapView.zoomLevel > 15 {
////                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
////                                annotationView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
////                            }, completion: nil)
//                            annotationView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
//                        } else {
////                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
////                                annotationView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
////                            }, completion: nil)
//                            annotationView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
//
//                        }
//                    }
//                }
//                return annotationView
//            }
//            // If there’s no reusable annotation view available, initialize a new one.
//        }
//        return nil
//    }
////    public func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool) {
////        if mapView.zoomLevel > 14 {
////            for annotation in essentialAnnotations {
////                if let view = mapView.view(for: annotation) as? CustomAnnotationView {
////                    if annotation.scaled == false {
////                        annotation.scaled = true
////                        view.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
////                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
////                            view.transform = CGAffineTransform.init(scaleX: 1.8, y: 1.8)
////                        }, completion: nil)
////                    }
////                }
////            }
////        }
////
////        if mapView.zoomLevel <= 14 {
////            for annotation in essentialAnnotations {
////                if let view = mapView.view(for: annotation) as? CustomAnnotationView {
////                    if annotation.scaled == true {
////                        annotation.scaled = false
////                        view.transform = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
////                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
////                            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
////                        }, completion: nil)
////                    }
////                }
////            }
////        }
////        if mapView.zoomLevel > 15 {
////            for annotation in nonEssentialAnnotations {
////                if let view = mapView.view(for: annotation) as? CustomAnnotationView {
////                    if annotation.scaled == false {
////                        annotation.scaled = true
////                        view.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
////                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
////                            view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
////                        }, completion: nil)
////                    }
////                }
////            }
////        }
////        if mapView.zoomLevel <= 15 {
////            for annotation in nonEssentialAnnotations {
////                if let view = mapView.view(for: annotation) as? CustomAnnotationView {
////                    if annotation.scaled == true {
////                        annotation.scaled = false
////                        view.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
////                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
////                            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
////                        }, completion: nil)
////                    }
////                }
////            }
////        }
////    }
//    
//    public func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
//        debugPrint("regionDidChangeAnimated")
//        if mapView.zoomLevel > 15 {
//            if selectedCategory == nil {
//                for each in nonEssentialAnnotations {
//                    self.mapView.addAnnotation(each)
//                }
//            }
//        }
//        if mapView.zoomLevel <= 15 {
//            if selectedCategory == nil {
//                for each in nonEssentialAnnotations {
//                    self.mapView.removeAnnotation(each)
//                }
//            }
//        }
//    }
//    // Allow callout view to appear when an annotation is tapped.
//    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
////        if let anno = annotation as? MyCustomPointAnnotation {
////            if anno.isHidden {
////                return false
////            }
////        }
//        return true
//    }
//    
//    public func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
//        if annotation.responds(to: #selector(getter: UIPreviewActionItem.title)) {
//            // Instantiate and return our custom callout view
//            let view = CustomCalloutView(representedObject: annotation)
//            //            view.userDelegate = self
//            return view
//        }
//        
//        return nil
//    }
//    //
//    public func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        mapView.deselectAnnotation(annotation, animated: true)
//        
//        if let anno = annotation as? MyCustomPointAnnotation {
//            //            if (anno.item?.category)! != "restroom" {
//            //                // Hide the callout
//            //                let vc = gotoItemDetail(id: (anno.item?.id)!)
//            //                vc.delegate = self
//            //            }
//            if let item = anno.item {
//                let category = (item.category?.name)!
//                let levelOneId = (item.levelOneId)!
//                let index = FooyoIndex(category: category, levelOneId: levelOneId)
//                self.delegate?.fooyoBaseMapViewController(didSelectInformationWindow: index)
//            }
//            debugPrint("taped on the cell")
//        }
//    }
//    //    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
//    //        // Give our polyline a unique color by checking for its `title` property
//    //        if (annotation is MGLPolyline) {
//    //            // Mapbox cyan
//    //            //            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
//    //            return UIColor.sntDarkSkyBlue.withAlphaComponent(0.8)
//    //        }
//    //        else
//    //        {
//    //            return .red
//    //        }
//    //    }
//    
//    func configureFilterIcon(icon: Any?) {
//        if let icon = icon as? UIImage {
//            filterBtnInside.image = icon
//        } else if let icon = icon as? String {
//            let width = Scale.scaleY(y: 17)
//            let height = Scale.scaleY(y: 17)
//            let size = CGSize(width: width, height: height)
//            filterBtnInside.af_setImage(
//                withURL: NSURL(string: icon)! as URL,
//                placeholderImage: UIImage(),
//                filter: AspectScaledToFitSizeFilter(size: size),
//                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
//            )
//        }
//    }
//}
//
//extension FooyoBaseMapViewController: UITableViewDelegate, UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch tableView {
//        case categoryTable:
//            return FooyoCategory.others.count + 3
//        case amenityTable:
//            return FooyoCategory.amenities.count + 1
//        case transportationTable:
//            return FooyoCategory.transportations.count + 1
//        default:
//            return 0
//        }
//    }
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier) as! CategoryTableViewCell
//        switch tableView {
//        case categoryTable:
//            switch indexPath.row {
//            case 0:
//                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Show All")
//            case FooyoCategory.others.count + 1:
//                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Amenities", rightIcon: UIImage.getBundleImage(name: "general_rightarrow"))
//            case FooyoCategory.others.count + 2:
//                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Transportations", rightIcon: UIImage.getBundleImage(name: "general_rightarrow"))
//            default:
//                let category = FooyoCategory.others[indexPath.row - 1]
//                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
//            }
//        case amenityTable:
//            switch indexPath.row {
//            case 0:
//                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "general_leftarrow"), title: "Amenities", boldTitle: true)
//            default:
//                let category = FooyoCategory.amenities[indexPath.row - 1]
//                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
//            }
//        case transportationTable:
//            switch indexPath.row {
//            case 0:
//                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "general_leftarrow"), title: "Transportations", boldTitle: true)
//            default:
//                let category = FooyoCategory.transportations[indexPath.row - 1]
//                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
//            }
//        default:
//            return cell
//        }
//        return cell
//    }
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return Scale.scaleY(y: 47.5)
//    }
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        switch tableView {
//        case categoryTable:
//            switch indexPath.row {
//            case 0:
//                selectedCategory = nil
//                configureFilterIcon(icon: UIImage.getBundleImage(name: "basemap_all"))
////                reloadCategory()
//                addCount = 0
//                for each in nonEssentialAnnotations {
//                    self.mapView.addAnnotation(each)
//                }
//                dismissFilter()
//            case FooyoCategory.others.count + 1:
//                displayAmenities()
//            case FooyoCategory.others.count + 2:
//                displayTransportations()
//            default:
//                let category = FooyoCategory.others[indexPath.row - 1]
//                selectedCategory = category
//                configureFilterIcon(icon: category.icon)
//                reloadCategory()
//                dismissFilter()
//            }
//        case amenityTable:
//            switch indexPath.row {
//            case 0:
//                displayCategories()
//            default:
//                let category = FooyoCategory.amenities[indexPath.row - 1]
//                selectedCategory = category
//                configureFilterIcon(icon: category.icon)
//                reloadCategory()
//                dismissFilter()
//            }
//        case transportationTable:
//            switch indexPath.row {
//            case 0:
//                displayCategories()
//            default:
//                let category = FooyoCategory.transportations[indexPath.row - 1]
//                selectedCategory = category
//                configureFilterIcon(icon: category.icon)
//                reloadCategory()
//                dismissFilter()
//            }
//        default:
//            break
//        }
//    }
//    
//    
//}
