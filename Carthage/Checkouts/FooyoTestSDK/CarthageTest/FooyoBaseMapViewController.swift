//
//  FooyoBaseMapViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 2/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox
import AlamofireImage
import SVProgressHUD

public protocol FooyoBaseMapViewControllerDelegate: class {
    func fooyoBaseMapViewController(didSelectInformationWindow index: FooyoIndex)
}
//import
public class FooyoBaseMapViewController: UIViewController {
    public weak var delegate: FooyoBaseMapViewControllerDelegate?
    
    //MARK: - Variables for LDR Info
    fileprivate var ldrView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        return t
    }()
    
    fileprivate var ldrOverLay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        t.isUserInteractionEnabled = true
        return t
    }()
    fileprivate var ldrContainer: UIScrollView! = {
        let t = UIScrollView()
        t.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        t.layer.cornerRadius = 12
        t.clipsToBounds = true
        t.alwaysBounceVertical = true
        t.alwaysBounceHorizontal = false
        return t
    }()
    fileprivate var ldrTitle: UILabel! = {
        let t = UILabel()
        t.backgroundColor = .clear
        t.textColor = .black
        t.textAlignment = .center
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.numberOfLines = 0
        return t
    }()
    fileprivate var ldrTimeIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.backgroundColor = .clear
        t.image = UIImage.getBundleImage(name: "basemap_ldrclock")
        return t
    }()
    fileprivate var ldrParkIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.backgroundColor = .clear
        t.image = UIImage.getBundleImage(name: "basemap_ldrpark")
        return t
    }()
    fileprivate var ldrBusIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.backgroundColor = .clear
        t.image = UIImage.getBundleImage(name: "basemap_ldrstop")
        return t
    }()
    fileprivate var ldrTimeLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.ospSentosaBlue
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.text = "Operating Hours"
        return t
    }()
    fileprivate var ldrBusLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.ospSentosaBlue
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.text = "Getting There"
        return t
    }()
    fileprivate var ldrParkLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.ospSentosaBlue
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.text = "Nearest Carpark"
        return t
    }()
    fileprivate var ldrTimeContent: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.black
        t.font = UIFont.DefaultRegularWithSize(size: 12)
        t.numberOfLines = 0
        return t
    }()
    fileprivate var ldrBusContent: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.black
        t.font = UIFont.DefaultRegularWithSize(size: 12)
        t.numberOfLines = 0
        return t
    }()
    fileprivate var ldrParkContent: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.black
        t.font = UIFont.DefaultRegularWithSize(size: 12)
        t.numberOfLines = 0
        return t
    }()
    fileprivate var ldrCancelBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("Close", for: .normal)
        t.setTitleColor(UIColor.ospSentosaBlue, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    
    fileprivate var ldrGoBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("Get There", for: .normal)
        t.setTitleColor(UIColor.ospSentosaBlue, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    fileprivate var ldrLineOne: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey
        return t
    }()
    fileprivate var ldrLineTwo: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey
        return t
    }()
    //MARK: - Variables for Plan Creation
    var itinerary: FooyoItinerary?
    var route: FooyoRoute?

    //MARK: - Variables for general map
    var hideBar = true
    var sourcePage = FooyoConstants.PageSource.FromHomeMap
    
    var items: [FooyoItem]?
    fileprivate var scaled = false
    //MARK: - Variables for MapView
    var mapView: MGLMapView!
    var mapCenter: CLLocationCoordinate2D?
    
    var allAnnotations = [MyCustomPointAnnotation]()
    var searchItem: FooyoItem?
    var searchAnnotation: MyCustomPointAnnotation?

    //MARK: - Variables for SearchView
    var searchView: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        t.layer.cornerRadius = 6
        t.layer.shadowColor = UIColor.ospBlack20.cgColor
        t.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
        t.layer.shadowRadius = Scale.scaleY(y: 4)
        t.layer.shadowOpacity = 1
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var searchIcon: UIImageView! = {
        let t = UIImageView()
        t.backgroundColor = .clear
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.applyBundleImage(name: "basemap_markersmall")
        return t
    }()
    var crossIcon: UIImageView! = {
        let t = UIImageView()
        t.backgroundColor = .clear
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.isHidden = true
        t.isUserInteractionEnabled = true
        t.applyBundleImage(name: "basemap_cross")
        return t
    }()
    
    var bigCross: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        t.isHidden = true
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var searchLabel: UILabel! = {
        let t = UILabel()
        t.text = "Where would you like to go?"
        t.textColor = UIColor.ospDarkGrey
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var filterBtn: ShadowView! = {
        let t = ShadowView()
        t.backgroundColor = .white
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var filterBtnInside: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_filter")
        t.contentMode = .scaleAspectFit
        t.layer.cornerRadius = Scale.scaleY(y: 15) / 2
        return t
    }()
    
    var gpsBtn: ShadowView! = {
        let t = ShadowView()
        t.backgroundColor = .white
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        return t
    }()
    
    var gpsBtnInside: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_gps")
        t.contentMode = .scaleAspectFit
        t.layer.cornerRadius = Scale.scaleY(y: 22) / 2
        return t
    }()
    
    var goBtn: ShadowView! = {
        let t = ShadowView()
        t.backgroundColor = UIColor.ospSentosaGreen
        t.layer.cornerRadius = Scale.scaleY(y: 52) / 2
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var goBtnInside: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_direction")
        t.contentMode = .scaleAspectFit
        t.layer.cornerRadius = Scale.scaleY(y: 22) / 2
        return t
    }()

    var goBtnInsideLabel: UILabel! = {
        let t = UILabel()
        t.textColor = .white
        t.backgroundColor = .clear
        t.textAlignment = .center
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
        t.text = "GO"
        return t
    }()
    
    fileprivate var filterView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        return t
    }()
    
    fileprivate var overLay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        t.isUserInteractionEnabled = true
        return t
    }()
    fileprivate var categoryTable: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorInset = UIEdgeInsets.zero
        t.separatorColor = .clear
        t.separatorStyle = .singleLine
        t.clipsToBounds = true
        t.layer.cornerRadius = 12
        t.isScrollEnabled = false
        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return t
    }()
    fileprivate var amenityTable: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorInset = UIEdgeInsets.zero
        t.separatorColor = .clear
        t.separatorStyle = .singleLine
        t.clipsToBounds = true
        t.layer.cornerRadius = 12
        t.isScrollEnabled = false
        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return t
    }()
    fileprivate var transportationTable: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorInset = UIEdgeInsets.zero
        t.separatorColor = .clear
        t.separatorStyle = .singleLine
        t.clipsToBounds = true
        t.layer.cornerRadius = 12
        t.isScrollEnabled = false
        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return t
    }()
    fileprivate var cancelBtn: UILabel! = {
        let t = UILabel()
        t.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        t.clipsToBounds = true
        t.layer.cornerRadius = 12
        t.text = "Cancel"
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 18))
        t.textColor = UIColor.ospIoSblue
        t.textAlignment = .center
        t.isUserInteractionEnabled = true
        return t
    }()
    
//    fileprivate var 
    //for show on map
    fileprivate var index: FooyoIndex?
    fileprivate var selectedCategory: FooyoCategory?
    fileprivate var selectedItem: FooyoItem?
    fileprivate var isShowAll: Bool {
        return selectedCategory == nil
    }
    
//    fileprivate var selectedCategory: String?
//    fileprivate var selectedId: Int?
//    fileprivate var showOnMapMode: Bool = false
    //MARK: - Life Cycle
//    public init(category: String? = nil, levelOneId: Int? = nil) {
//        super.init(nibName: nil, bundle: nil)
//        self.selectedCategory = category
//        self.selectedId = levelOneId
//        if category != nil {
//            self.showOnMapMode = true
//        } else {
//            self.showOnMapMode = false
//        }
//    }
    
    public init(index: FooyoIndex? = nil, hideTheDefaultNavigationBar: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.index = index
        self.hideBar = hideTheDefaultNavigationBar
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        applyGeneralVCSettings(vc: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: FooyoConstants.notifications.FooyoDisplayAlert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(highlightSearch(notification:)), name: FooyoConstants.notifications.FooyoSearch, object: nil)

        setupMapView()
        setupSearchView()
        setupOtherViews()
        setupCategoryListView()
        setupLDRView()
        checkBundle()
        
        loadPlaces()
        loadCategries(withLoading: false)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        mapCenter = CLLocationCoordinate2D(latitude: FooyoConstants.mapCenterLat, longitude: FooyoConstants.mapCenterLong)
//        mapView.setCenter(mapCenter!, zoomLevel: FooyoConstants.initZoomLevel, animated: true)

        
        if let anno = searchAnnotation {
            debugPrint("i am going to center")
            mapView.setCenter((searchItem?.getCoor())!, zoomLevel: 15, direction: 0, animated: true) {
                self.mapView.selectAnnotation(anno, animated: true)
            }
        }
        
        if index != nil {
            if let annotations = mapView.annotations as? [MyCustomPointAnnotation] {
                let anno = annotations[0]
                let item = anno.item
                mapView.setCenter((item?.getCoor())!, zoomLevel: 15, direction: 0, animated: true) {
                    if self.index?.category != FooyoConstants.CategoryName.Fun.rawValue {
                        self.mapView.selectAnnotation(anno, animated: true)
                    }
                }
            }
        }

//        if self.navigationController?.navigationBar.isHidden == false {
//            UIView.animate(withDuration: 0.3, animations: { 
//                self.navigationController?.navigationBar.isHidden = true
//            })
//        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hideBar {
            if self.navigationController?.isNavigationBarHidden == false {
                UIView.animate(withDuration: 0.3, animations: {
                    self.navigationController?.isNavigationBarHidden = true
                })
            }
        } else {
            if self.navigationController?.isNavigationBarHidden == true {
                UIView.animate(withDuration: 0.3, animations: {
                    self.navigationController?.isNavigationBarHidden = false
                })
            }
        }
    }
    
    
    //MARK: - Setup Views
    func setupLDRView() {
        if let vc = self.tabBarController {
            vc.view.addSubview(ldrView)
        } else if let vc = self.navigationController {
            vc.view.addSubview(ldrView)
        } else {
            view.addSubview(ldrView)
        }
        ldrView.addSubview(ldrOverLay)
        ldrView.addSubview(ldrContainer)
        ldrContainer.addSubview(ldrTitle)
        ldrContainer.addSubview(ldrTimeIcon)
        ldrContainer.addSubview(ldrTimeLabel)
        ldrContainer.addSubview(ldrTimeContent)
        ldrContainer.addSubview(ldrBusIcon)
        ldrContainer.addSubview(ldrBusLabel)
        ldrContainer.addSubview(ldrBusContent)
        ldrContainer.addSubview(ldrParkIcon)
        ldrContainer.addSubview(ldrParkLabel)
        ldrContainer.addSubview(ldrParkContent)
        ldrContainer.addSubview(ldrLineOne)
        ldrContainer.addSubview(ldrLineTwo)
        ldrContainer.addSubview(ldrCancelBtn)
        ldrContainer.addSubview(ldrGoBtn)
        ldrGoBtn.addTarget(self, action: #selector(ldrGoBtnHandler), for: .touchUpInside)
        ldrCancelBtn.addTarget(self, action: #selector(ldrCancelHandler), for: .touchUpInside)
        setLDRViewConstraints()
    }
    
    func ldrCancelHandler() {
        dismissLDRFilter()
    }
    
    func ldrGoBtnHandler() {
        let category = FooyoConstants.CategoryName.Trails.rawValue
        let one = selectedItem?.levelOneId
        let index = FooyoIndex(category: category, levelOneId: one!)
        let vc = FooyoNavigationViewController(startIndex: nil, endIndex: index)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setLDRViewConstraints() {
        ldrView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(FooyoConstants.mainHeight)
            make.top.equalTo((filterView.superview?.snp.bottom)!)
        }
        ldrOverLay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        ldrContainer.snp.makeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 90))
            make.leading.equalTo(Scale.scaleX(x: 24))
            make.trailing.equalTo(Scale.scaleX(x: -24))
            make.bottom.equalTo(Scale.scaleY(y: -70))
        }
        ldrTitle.snp.makeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 20))
            make.leading.equalTo(ldrView).offset(Scale.scaleX(x: 35))
            make.trailing.equalTo(ldrView).offset(Scale.scaleX(x: -35))
        }
        ldrTimeIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 18))
            make.leading.equalTo(ldrView).offset(Scale.scaleX(x: 51))
            make.top.equalTo(ldrTitle.snp.bottom).offset(Scale.scaleY(y: 24))
        }
        ldrTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(ldrTimeIcon)
            make.trailing.equalTo(ldrView).offset(Scale.scaleX(x: -51))
            make.leading.equalTo(ldrTimeIcon.snp.trailing).offset(Scale.scaleX(x: 8))
        }
        ldrTimeContent.snp.makeConstraints { (make) in
            make.top.equalTo(ldrTimeLabel.snp.bottom).offset(Scale.scaleY(y: 8))
            make.trailing.equalTo(ldrTimeLabel)
            make.leading.equalTo(ldrTimeLabel)
        }
        ldrBusIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 18))
            make.leading.equalTo(ldrView).offset(Scale.scaleX(x: 51))
            make.top.equalTo(ldrTimeContent.snp.bottom).offset(Scale.scaleY(y: 19))
        }
        ldrBusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(ldrBusIcon)
            make.trailing.equalTo(ldrView).offset(Scale.scaleX(x: -51))
            make.leading.equalTo(ldrBusIcon.snp.trailing).offset(Scale.scaleX(x: 8))
        }
        ldrBusContent.snp.makeConstraints { (make) in
            make.top.equalTo(ldrBusLabel.snp.bottom).offset(Scale.scaleY(y: 8))
            make.trailing.equalTo(ldrBusLabel)
            make.leading.equalTo(ldrBusLabel)
        }
        ldrParkIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 18))
            make.leading.equalTo(ldrView).offset(Scale.scaleX(x: 51))
            make.top.equalTo(ldrBusContent.snp.bottom).offset(Scale.scaleY(y: 19))
        }
        ldrParkLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(ldrParkIcon)
            make.trailing.equalTo(ldrView).offset(Scale.scaleX(x: -51))
            make.leading.equalTo(ldrParkIcon.snp.trailing).offset(Scale.scaleX(x: 8))
        }
        ldrParkContent.snp.makeConstraints { (make) in
            make.top.equalTo(ldrParkLabel.snp.bottom).offset(Scale.scaleY(y: 8))
            make.trailing.equalTo(ldrParkLabel)
            make.leading.equalTo(ldrParkLabel)
            make.bottom.equalTo(Scale.scaleY(y: -70))
        }
        ldrGoBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(ldrView).offset(Scale.scaleX(x: -24))
            make.bottom.equalTo(ldrView).offset(Scale.scaleY(y: -70))
            make.height.equalTo(Scale.scaleY(y: 50))
        }
        ldrCancelBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(ldrView).offset(Scale.scaleX(x: 24))
            make.bottom.equalTo(ldrView).offset(Scale.scaleY(y: -70))
            make.height.equalTo(Scale.scaleY(y: 50))
            make.width.equalTo(ldrGoBtn)
        }
        ldrLineOne.snp.makeConstraints { (make) in
            make.centerY.equalTo(ldrCancelBtn)
            make.width.equalTo(1)
            make.leading.equalTo(ldrCancelBtn.snp.trailing)
            make.trailing.equalTo(ldrGoBtn.snp.leading)
            make.height.equalTo(Scale.scaleY(y: 45))
        }
        ldrLineTwo.snp.makeConstraints { (make) in
            make.bottom.equalTo(ldrCancelBtn.snp.top)
            make.leading.equalTo(ldrCancelBtn)
            make.trailing.equalTo(ldrGoBtn)
            make.height.equalTo(1)
        }
    }
    func setupSearchView() {
        view.addSubview(searchView)
        //        searchView.addSubview(searchIconOne)
        searchView.addSubview(searchLabel)
        searchView.addSubview(searchIcon)
        searchView.addSubview(crossIcon)
        searchView.addSubview(bigCross)
        let crossGesture = UITapGestureRecognizer(target: self, action: #selector(crossHandler))
        bigCross.addGestureRecognizer(crossGesture)
        let searchGesture = UITapGestureRecognizer(target: self, action: #selector(searchHandler))
        searchView.addGestureRecognizer(searchGesture)
        searchViewConstraints()
    }
    
    func setupMapView() {
//        mapView = MGLMapView(frame: view.bounds)
        mapView = MGLMapView()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapCenter = CLLocationCoordinate2D(latitude: FooyoConstants.mapCenterLat, longitude: FooyoConstants.mapCenterLong)
        mapView.setCenter(mapCenter!, zoomLevel: FooyoConstants.initZoomLevel, animated: false)
//        fitMap()
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setupOtherViews() {
        view.addSubview(filterBtn)
        filterBtn.addSubview(filterBtnInside)
        let filterGesture = UITapGestureRecognizer(target: self, action: #selector(filterHandler))
        filterBtn.addGestureRecognizer(filterGesture)
        
        view.addSubview(gpsBtn)
        gpsBtn.addSubview(gpsBtnInside)
        let locateGesture = UITapGestureRecognizer(target: self, action: #selector(locateHandler))
        gpsBtn.addGestureRecognizer(locateGesture)
        view.addSubview(goBtn)
        goBtn.addSubview(goBtnInside)
        goBtn.addSubview(goBtnInsideLabel)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(goBtnHandler))
        goBtn.addGestureRecognizer(gesture)
//        if showOnMapMode {
//            filterBtn.isHidden = true
//        }
        
        otherViewsConstraints()
    }
    
    func setupCategoryListView() {
        
//        view.addSubview(filterView)
        if let vc = self.tabBarController {
            vc.view.addSubview(filterView)
        } else if let vc = self.navigationController {
            vc.view.addSubview(filterView)
        } else {
            view.addSubview(filterView)
        }
        filterView.addSubview(overLay)
        let overLayGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilter))
        overLay.addGestureRecognizer(overLayGesture)
        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilter))
        cancelBtn.addGestureRecognizer(cancelGesture)
        
        filterView.addSubview(categoryTable)
        filterView.addSubview(amenityTable)
        filterView.addSubview(transportationTable)
        filterView.addSubview(cancelBtn)
        categoryTable.delegate = self
        categoryTable.dataSource = self
        amenityTable.delegate = self
        amenityTable.dataSource = self
        transportationTable.delegate = self
        transportationTable.dataSource = self
        categoryListConstraints()
    }
    
    func categoryListConstraints() {
        
        filterView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(FooyoConstants.mainHeight)
            make.top.equalTo((filterView.superview?.snp.bottom)!)
        }
        overLay.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        cancelBtn.snp.remakeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 48))
            make.leading.equalTo(Scale.scaleX(x: 8))
            make.trailing.equalTo(Scale.scaleX(x: -8))
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
        categoryTable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(cancelBtn.snp.top).offset(Scale.scaleY(y: -8))
            make.leading.equalTo(Scale.scaleX(x: 8))
            make.trailing.equalTo(Scale.scaleX(x: -8))
            make.height.equalTo(CGFloat(FooyoCategory.others.count + 3) * (Scale.scaleY(y: 47.5)))
        }
        amenityTable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(categoryTable)
            make.leading.equalTo(filterView.snp.trailing).offset(Scale.scaleX(x: 8))
            make.width.equalTo(categoryTable)
            make.height.equalTo(CGFloat(FooyoCategory.amenities.count + 1) * (Scale.scaleY(y: 47.5)))
        }
        transportationTable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(categoryTable)
            make.leading.equalTo(filterView.snp.trailing).offset(Scale.scaleX(x: 8))
            make.width.equalTo(categoryTable)
            make.height.equalTo(CGFloat(FooyoCategory.transportations.count + 1) * (Scale.scaleY(y: 47.5)))
        }
    }
    
    func searchViewConstraints() {
        searchView.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 10))
            make.trailing.equalTo(Scale.scaleX(x: -10))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 10))
        }
        searchLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(Scale.scaleX(x: 10))
        }
        searchIcon.snp.makeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 14))
            make.width.equalTo(Scale.scaleX(x: 9.8))
            make.centerY.equalToSuperview()
            make.trailing.equalTo(Scale.scaleX(x: -12.2))
        }
        crossIcon.snp.makeConstraints { (make) in
            make.edges.equalTo(searchIcon)
        }
        bigCross.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(bigCross.snp.height)
        }
    }
    
    func otherViewsConstraints() {
        filterBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 40))
            make.top.equalTo(searchView.snp.bottom).offset(Scale.scaleY(y: 16))
            make.trailing.equalTo(Scale.scaleX(x: -16))
        }
        filterBtnInside.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 17))
            make.center.equalToSuperview()
        }
        gpsBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 40))
            make.trailing.equalTo(Scale.scaleX(x: -16))
            make.bottom.equalTo(goBtn.snp.top).offset(Scale.scaleY(y: -16))
        }
        gpsBtnInside.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(Scale.scaleY(y: 22))
        }
        goBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 52))
            make.trailing.equalTo(-Scale.scaleY(y: 10))
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(Scale.scaleY(y: -10))
        }
        goBtnInside.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 22))
            make.centerX.equalToSuperview()
            make.top.equalTo(Scale.scaleY(y: 8))
        }
        goBtnInsideLabel.snp.makeConstraints { (make) in
            make.top.equalTo(goBtnInside.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    //MARK: HTTP
    func loadCategries(withLoading: Bool) {
        if FooyoCategory.categories.isEmpty {
            if withLoading {
                SVProgressHUD.show()
            }
            HttpClient.sharedInstance.getCategories { (categories, isSuccess) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    debugPrint("success")
                    self.categoryListConstraints()
                    self.categoryTable.reloadData()
                    self.amenityTable.reloadData()
                    self.transportationTable.reloadData()
                } else {
                    debugPrint("fail")
                }
            }
        }
    }
    
    func loadPlaces() {
        if FooyoItem.items.isEmpty {
            SVProgressHUD.show()
            HttpClient.sharedInstance.getItems { (places, isSuccess) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.items = places
                    if let itinerary = self.itinerary {
                        itinerary.updateItems()
                    }
                    self.reloadData()
                }
            }
        } else {
            self.items = FooyoItem.items
            if let itinerary = itinerary {
                itinerary.updateItems()
            }
            self.reloadData()
        }
    }
    
    //MARK: Handler
    func ldrHandler(item: FooyoItem) {
        ldrTitle.text = parseOptionalString(input: item.name) + "\n" + parseOptionalString(input: item.region, defaultValue: "Pending")
        ldrTimeContent.text = item.operation
        ldrBusContent.text = item.gettingThere
        ldrParkContent.text = item.carpark
        
        UIView.animate(withDuration: 0.3) {
            self.ldrView.transform = CGAffineTransform.init(translationX: 0, y: -FooyoConstants.mainHeight)
        }
    }
    
    func dismissLDRFilter() {
        UIView.animate(withDuration: 0.3) {
            self.ldrView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    func filterHandler() {
        UIView.animate(withDuration: 0.3) {
            self.filterView.transform = CGAffineTransform.init(translationX: 0, y: -FooyoConstants.mainHeight)
        }
    }
    
    func dismissFilter() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.transportationTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.amenityTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.filterView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    func displayAmenities() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
            self.amenityTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
        }
    }
    
    
    func displayTransportations() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
            self.transportationTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
        }
    }
    
    func displayCategories() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.transportationTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.amenityTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    func locateHandler() {
//        self.mapView.setCenter((allAnnotations[0].item?.getCoor())!, zoomLevel: 15, direction: 0, animated: true) {
//            self.mapView.selectAnnotation(self.allAnnotations[0], animated: true)
//        }
        mapView.userTrackingMode = .followWithHeading
    }
    func goBtnHandler() {
        let vc = FooyoNavigationViewController(startIndex: nil, endIndex: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func crossHandler() {
        searchItem = nil
        crossIcon.isHidden = true
        bigCross.isHidden = true
        searchIcon.isHidden = false
        searchLabel.text = "Where would you like to go?"
        searchAnnotation = nil
        reloadMapIcons()
    }
    
    func searchHandler() {
        gotoSearchPage(source: .FromHomeMap, sourceVC: self)
    }
    
    //MAKR: Data Handler
    func reloadData() {
        sortItems()
        reloadMapIcons()
    }
    
    func sortItems() {
        if let items = items {
            allAnnotations = [MyCustomPointAnnotation]()
            for each in items {
                let point = MyCustomPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: each.coordinateLan!, longitude: each.coordinateLon!)
                point.title = each.name
                point.item = each
                point.reuseId = each.category?.name
                allAnnotations.append(point)
            }
        }
        if let route = route {
            if route.startItem == nil {
                let point = MyCustomPointAnnotation()
                if let start = route.startCoord {
                    point.coordinate = start
                }
                point.reuseId = FooyoConstants.AnnotationId.StartItem.rawValue
                allAnnotations.append(point)
                debugPrint("have created a start point")
            }
            if route.endItem == nil {
                let point = MyCustomPointAnnotation()
                if let end = route.endCoord {
                    point.coordinate = end
                }
                point.reuseId = FooyoConstants.AnnotationId.EndItem.rawValue
                allAnnotations.append(point)
            }
        }
    }
    
    func reloadMapIcons() {
        clearMapView()
        var allAnno = [MyCustomPointAnnotation]()
        if let index = index {
            searchView.isHidden = true
            filterBtn.isHidden = true
            goBtn.isHidden = true
            if index.isLocation() {
                allAnno = allAnnotations.filter({ (annotation) -> Bool in
                    if (annotation.item?.category?.name)!.lowercased() == (index.category)!.lowercased() && annotation.item?.levelOneId == index.levelOneId {
                        return true
                    }
                    return false
                })
            } else if index.isCategory() {
                allAnno = allAnnotations.filter({ (annotation) -> Bool in
                    if (annotation.item?.category?.name)!.lowercased() == (index.category)!.lowercased() {
                        return true
                    }
                    return false
                })
            }
        } else {
            if let selected = selectedCategory {
                allAnno = allAnnotations.filter({ (annotation) -> Bool in
                    if let search = searchItem {
                        if annotation.item?.id == search.id {
                            return true
                        }
                    }
                    if let items = self.itinerary?.items {
                        for each in items {
                            if annotation.item?.id == each.id {
                                return true
                            }
                        }
                    }

                    return annotation.item?.category?.id == selected.id
                })
                debugPrint(allAnno.count)
            } else {
                allAnno = allAnnotations
            }
        }
        mapView.addAnnotations(allAnno)
    }
    
    func clearMapView() {
        mapView.removeAnnotations(allAnnotations)
    }
    
    func checkBundle() {
        if let bundlePath: String = Bundle.main.path(forResource: "FooyoSDK", ofType: "bundle") {
            if let _ = Bundle(path: bundlePath) {
                return
            }
        }
        PostAlertNotification(title: "Error", message: "The \"FooyoSDK\" file is missing.")
    }

    func displayAlert(notification: Notification) {
        if let info = notification.object as? [String: String] {
            let title = info["title"] ?? ""
            let msg = info["message"] ?? ""
            displayAlert(title: title, message: msg, complete: nil)
        }
    }
    
    func highlightSearch(notification: Notification) {
        if let item = notification.object as? FooyoItem {
            searchItem = item
            searchAnnotation = allAnnotations.first(where: { (anno) -> Bool in
                return anno.item?.id == item.id
            })
            searchLabel.text = item.name
            crossIcon.isHidden = false
            bigCross.isHidden = false
            searchIcon.isHidden = true
            reloadMapIcons()
        }
    }
}

//MARK: - MAP delegate
extension FooyoBaseMapViewController: MGLMapViewDelegate {
    func checkReuse(annotation: MyCustomPointAnnotation) -> (String, Int) {
        var reuseIdentifier = (annotation.reuseId)!
        if let search = searchItem {
            if annotation.item?.id == search.id {
                reuseIdentifier = FooyoConstants.AnnotationId.UserMarker.rawValue
            }
        }
        var index = 0
        if let items = self.itinerary?.items {
            for each in items {
                if annotation.item?.id == each.id {
                    reuseIdentifier = FooyoConstants.AnnotationId.ItineraryItem.rawValue
                    break
                }
                index = index + 1
            }
        }
        if let route = self.route {
            if let start = route.startItem {
                if start.id == annotation.item?.id {
                    reuseIdentifier = FooyoConstants.AnnotationId.StartItem.rawValue
                }
            }
            if let end = route.endItem {
                if end.id == annotation.item?.id {
                    reuseIdentifier = FooyoConstants.AnnotationId.EndItem.rawValue
                }
            }
        }
        
        return (reuseIdentifier, index)
    }
    
    public func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        //        return MGLAnnotationView()
        // This example is only concerned with point annotations.
        if let annotation = annotation as? MyCustomPointAnnotation {
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            var (reuseIdentifier, index) = checkReuse(annotation: annotation)
            // For better performance, always try to reuse existing annotations.
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView {
                return annotationView
            } else {
                var annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                if reuseIdentifier == FooyoConstants.AnnotationId.StartItem.rawValue {
                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 12), height: Scale.scaleY(y: 12))
                } else if reuseIdentifier == FooyoConstants.AnnotationId.EndItem.rawValue {
                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 25.5), height: Scale.scaleY(y: 72))
                } else if reuseIdentifier == FooyoConstants.AnnotationId.ItineraryItem.rawValue {
                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 30), height: Scale.scaleY(y: 30))
                    annotationView.indexLabel.text = "\(index + 1)"
                } else if reuseIdentifier == FooyoConstants.AnnotationId.UserMarker.rawValue {
                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 25.5), height: Scale.scaleY(y: 72))
                } else {
                    if annotation.item?.isEssential() != true {
                        annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 12), height: Scale.scaleY(y: 12))
                    } else {
                        annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 16), height: Scale.scaleY(y: 16))
                    }
                    if itinerary != nil || route != nil {
                        annotationView.alpha = 0.5
                    }
                    annotationView.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                        annotationView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    }, completion: nil)
                }
                return annotationView
            }
            // If there’s no reusable annotation view available, initialize a new one.
        }
        return nil
    }
    public func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool) {
        if let annotations = mapView.annotations {
            if mapView.zoomLevel > 14 {
                for annotation in annotations {
                    if let annotation = annotation as? MyCustomPointAnnotation {
                        if let view = mapView.view(for: annotation) as? CustomAnnotationView {
                            var (reuseIdentifier, index) = checkReuse(annotation: annotation)
                            if reuseIdentifier == FooyoConstants.AnnotationId.UserMarker.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.StartItem.rawValue {
                                if annotation.scaled == false {
                                    annotation.scaled = true
                                    view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
                                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                                        view.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
                                    }, completion: nil)
                                }
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.EndItem.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.ItineraryItem.rawValue {
                            } else {
                                if annotation.item?.isEssential() == true {
                                    if annotation.scaled == false {
                                        annotation.scaled = true
                                        view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
                                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                                            view.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
                                        }, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if mapView.zoomLevel > 15 {
                for annotation in annotations {
                    if let annotation = annotation as? MyCustomPointAnnotation {
                        if let view = mapView.view(for: annotation) as? CustomAnnotationView {
                            var (reuseIdentifier, index) = checkReuse(annotation: annotation)
                            if reuseIdentifier == FooyoConstants.AnnotationId.UserMarker.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.StartItem.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.EndItem.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.ItineraryItem.rawValue {
                            } else {
                                if annotation.item?.isEssential() != true {
                                    if annotation.scaled == false {
                                        annotation.scaled = true
                                        view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
                                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                                            view.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
                                        }, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if mapView.zoomLevel <= 15 {
                for annotation in annotations {
                    if let annotation = annotation as? MyCustomPointAnnotation {
                        if let view = mapView.view(for: annotation) as? CustomAnnotationView {
                            var (reuseIdentifier, index) = checkReuse(annotation: annotation)
                            if reuseIdentifier == FooyoConstants.AnnotationId.UserMarker.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.StartItem.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.EndItem.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.ItineraryItem.rawValue {
                            } else {
                                if annotation.item?.isEssential() != true {
                                    if annotation.scaled == true {
                                        annotation.scaled = false
                                        view.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                                            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                                        }, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if mapView.zoomLevel <= 14 {
                for annotation in annotations {
                    if let annotation = annotation as? MyCustomPointAnnotation {
                        if let view = mapView.view(for: annotation) as? CustomAnnotationView {
                            var (reuseIdentifier, index) = checkReuse(annotation: annotation)
                            if reuseIdentifier == FooyoConstants.AnnotationId.UserMarker.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.StartItem.rawValue {
                                if annotation.scaled == true {
                                    annotation.scaled = false
                                    view.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                                        view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                                    }, completion: nil)
                                }
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.EndItem.rawValue {
                            } else if reuseIdentifier == FooyoConstants.AnnotationId.ItineraryItem.rawValue {
                            } else {
                                if annotation.item?.isEssential() == true {
                                    if annotation.scaled == true {
                                        annotation.scaled = false
                                        view.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                                            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                                        }, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    // Allow callout view to appear when an annotation is tapped.
    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        if let anno = annotation as? MyCustomPointAnnotation {
            if let item = anno.item {
                if item.category?.name == FooyoConstants.CategoryName.Fun.rawValue {
                    return false
                }
            }
        }

        return true
    }
    
    public func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        if annotation.responds(to: #selector(getter: UIPreviewActionItem.title)) {
            // Instantiate and return our custom callout view
            let view = CustomCalloutView(representedObject: annotation)
            //            view.userDelegate = self
            return view
        }
        
        return nil
    }
    //
    public func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
        
        if let anno = annotation as? MyCustomPointAnnotation {
            if let item = anno.item {
                let category = (item.category?.name)!
                let levelOneId = (item.levelOneId)!
                let index = FooyoIndex(category: category, levelOneId: levelOneId)
                self.delegate?.fooyoBaseMapViewController(didSelectInformationWindow: index)
            }
            debugPrint("taped on the cell")
        }
    }
    
    public func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        //        mapView.deselectAnnotation(annotation, animated: false)
        if let anno = annotation as? MyCustomPointAnnotation {
            if let item = anno.item {
                self.selectedItem = item
                if item.category?.name == FooyoConstants.CategoryName.Fun.rawValue {
                    ldrHandler(item: item)
                }
            }
        }
    }
    
    func configureFilterIcon(icon: Any?) {
        if let icon = icon as? UIImage {
            filterBtnInside.image = icon
        } else if let icon = icon as? String {
            let width = Scale.scaleY(y: 17)
            let height = Scale.scaleY(y: 17)
            let size = CGSize(width: width, height: height)
            filterBtnInside.af_setImage(
                withURL: NSURL(string: icon)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFitSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        }
    }
}

extension FooyoBaseMapViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case categoryTable:
            return FooyoCategory.others.count + 3
        case amenityTable:
            return FooyoCategory.amenities.count + 1
        case transportationTable:
            return FooyoCategory.transportations.count + 1
        default:
            return 0
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier) as! CategoryTableViewCell
        switch tableView {
        case categoryTable:
            switch indexPath.row {
            case 0:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Show All")
            case FooyoCategory.others.count + 1:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Amenities", rightIcon: UIImage.getBundleImage(name: "general_rightarrow"))
            case FooyoCategory.others.count + 2:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Transportations", rightIcon: UIImage.getBundleImage(name: "general_rightarrow"))
            default:
                let category = FooyoCategory.others[indexPath.row - 1]
                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
            }
        case amenityTable:
            switch indexPath.row {
            case 0:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "general_leftarrow"), title: "Amenities", boldTitle: true)
            default:
                let category = FooyoCategory.amenities[indexPath.row - 1]
                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
            }
        case transportationTable:
            switch indexPath.row {
            case 0:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "general_leftarrow"), title: "Transportations", boldTitle: true)
            default:
                let category = FooyoCategory.transportations[indexPath.row - 1]
                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
            }
        default:
            return cell
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Scale.scaleY(y: 47.5)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch tableView {
        case categoryTable:
            switch indexPath.row {
            case 0:
                selectedCategory = nil
                configureFilterIcon(icon: UIImage.getBundleImage(name: "basemap_all"))
                reloadMapIcons()
                
//                reDrawMapIcons()
                dismissFilter()
            case FooyoCategory.others.count + 1:
                displayAmenities()
            case FooyoCategory.others.count + 2:
                displayTransportations()
            default:
                let category = FooyoCategory.others[indexPath.row - 1]
                selectedCategory = category
                configureFilterIcon(icon: category.icon)
                reloadMapIcons()
//                reDrawMapIcons()
                dismissFilter()
//                break
            }
        case amenityTable:
            switch indexPath.row {
            case 0:
                displayCategories()
            default:
                let category = FooyoCategory.amenities[indexPath.row - 1]
                selectedCategory = category
                configureFilterIcon(icon: category.icon)
                reloadMapIcons()
//                reDrawMapIcons()
                dismissFilter()
            }
        case transportationTable:
            switch indexPath.row {
            case 0:
                displayCategories()
            default:
                let category = FooyoCategory.transportations[indexPath.row - 1]
                selectedCategory = category
                configureFilterIcon(icon: category.icon)
                reloadMapIcons()
//                reDrawMapIcons()
                dismissFilter()
            }
        default:
            break
        }
    }
    
    
}
