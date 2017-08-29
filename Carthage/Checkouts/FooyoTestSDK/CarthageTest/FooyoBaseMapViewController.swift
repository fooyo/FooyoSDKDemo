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
    func didTapInformationWindow(category: String, levelOneId: Int, levelTwoId: Int?)
}
//import
public class FooyoBaseMapViewController: UIViewController {
    public weak var delegate: FooyoBaseMapViewControllerDelegate?
    var items: [FooyoItem]?
//    var filters: [Constants.FilterType]? = [.Attraction, .Event, .FB, .Shop, .Hotel, .LinearTrail, .NonLinearTrail, .RestRoom,
//                                            .PrayerRoom, .TickingCounter, .BusStop, .TramStop, .ExpressStop, .CableStop]
    
    var sourcePage = Constants.PageSource.FromHomeMap
    //MARK: - Variables for MapView
    var mapView: MGLMapView!
    var mapCenter: CLLocationCoordinate2D?
    
    var allAnnotations = [MyCustomPointAnnotation]()
//    var attractionAnnotations = [MyCustomPointAnnotation]()
//    var eventAnnotations = [MyCustomPointAnnotation]()
//    var fbAnnotations = [MyCustomPointAnnotation]()
//    var shopAnnotations = [MyCustomPointAnnotation]()
//    var hotelAnnotations = [MyCustomPointAnnotation]()
//    var trailAnnotations = [MyCustomPointAnnotation]()
//    var nonTrailAnnotations = [MyCustomPointAnnotation]()
//
//    var restAnnotations = [MyCustomPointAnnotation]()
//    var prayerAnnotations = [MyCustomPointAnnotation]()
//    var ticketingAnnotations = [MyCustomPointAnnotation]()
//    var busAnnotations = [MyCustomPointAnnotation]()
//    var tramAnnotations = [MyCustomPointAnnotation]()
//    var expressAnnotations = [MyCustomPointAnnotation]()
//    var cableAnnotations = [MyCustomPointAnnotation]()
    
    var searchAnnotation: MyCustomPointAnnotation?
    
    //MARK: - Variables for MapView
    var searchView: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        t.layer.cornerRadius = 6
        t.layer.shadowColor = UIColor.ospBlack20.cgColor
        t.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
        t.layer.shadowRadius = Scale.scaleY(y: 4)
        t.layer.shadowOpacity = 1
        t.isUserInteractionEnabled = true
//        t.alpha = 0.9
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
//    var crossIconOne: UIImageView! = {
//        let t = UIImageView()
//        t.backgroundColor = .clear
//        t.contentMode = .scaleAspectFit
//        t.clipsToBounds = true
//        t.image = #imageLiteral(resourceName: "plus").imageByReplacingContentWithColor(color: UIColor.sntGreyish)
//        t.isHidden = true
//        t.isUserInteractionEnabled = true
//        return t
//    }()
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
    
    
    //for show on map
    fileprivate var selectedCategory: String?
    fileprivate var selectedId: Int?
    fileprivate var showOnMapMode: Bool = false
    //MARK: - Life Cycle
    public init(category: String? = nil, levelOneId: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.selectedCategory = category
        self.selectedId = levelOneId
        if category != nil {
            self.showOnMapMode = true
        } else {
            self.showOnMapMode = false
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        applyGeneralVCSettings(vc: self)

        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: Constants.notifications.FooyoDisplayAlert, object: nil)
        setupMapView()
        setupSearchView()
        setupOtherViews()
        checkBundle()
        
        loadPlaces()
        loadCategries(withLoading: false)
    }
    
//    override public func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if self.navigationController?.navigationBar.isHidden == false {
//            UIView.animate(withDuration: 0.3, animations: { 
//                self.navigationController?.navigationBar.isHidden = true
//            })
//        }
//    }
    
    
    //MARK: - Setup Views
    func setupSearchView() {
        view.addSubview(searchView)
        //        searchView.addSubview(searchIconOne)
        searchView.addSubview(searchLabel)
        searchView.addSubview(searchIcon)
        //        searchView.addSubview(crossIconOne)
        //        crossIconOne.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI_4))
        //        let crossGesture = UITapGestureRecognizer(target: self, action: #selector(crossHandler))
        //        crossIconOne.addGestureRecognizer(crossGesture)
        let searchGesture = UITapGestureRecognizer(target: self, action: #selector(searchHandler))
        searchView.addGestureRecognizer(searchGesture)
        searchViewConstraints()
        if showOnMapMode {
            searchView.isHidden = true
        }
    }
    
    func setupMapView() {
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapCenter = CLLocationCoordinate2D(latitude: Constants.mapCenterLat, longitude: Constants.mapCenterLong)
        mapView.setCenter(mapCenter!, zoomLevel: Constants.initZoomLevel, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
//        mapView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.top.equalTo(topLayoutGuide.snp.bottom)
//            make.bottom.equalTo(bottomLayoutGuide.snp.top)
//        }
    }
    
    func setupOtherViews() {
        view.addSubview(filterBtn)
        filterBtn.addSubview(filterBtnInside)
        view.addSubview(gpsBtn)
        gpsBtn.addSubview(gpsBtnInside)
        let locateGesture = UITapGestureRecognizer(target: self, action: #selector(locateHandler))
        gpsBtn.addGestureRecognizer(locateGesture)
        view.addSubview(goBtn)
        goBtn.addSubview(goBtnInside)
        goBtn.addSubview(goBtnInsideLabel)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(goBtnHandler))
        goBtn.addGestureRecognizer(gesture)
        if showOnMapMode {
            filterBtn.isHidden = true
        }

        otherViewsConstraints()
    }
    
    func searchViewConstraints() {
        searchView.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 10))
            make.trailing.equalTo(Scale.scaleX(x: -10))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 10))
//            make.top.equalTo(Constants.statusBarHeight + Scale.scaleY(y: 10))
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
    }
    
    func otherViewsConstraints() {
        filterBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 40))
            make.top.equalTo(searchView.snp.bottom).offset(Scale.scaleY(y: 16))
            make.trailing.equalTo(Scale.scaleX(x: -16))
        }
        filterBtnInside.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 15))
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
                    debugPrint("success")
                    self.items = places
                    self.reloadData()
                } else {
                    debugPrint("fail")
                }
            }
        } else {
            self.items = FooyoItem.items
            self.reloadData()
        }
    }
    
    //MARK: Handler
    func locateHandler() {
        mapView.userTrackingMode = .followWithHeading
    }
    func goBtnHandler() {
        featureUnavailable()
    }
    func crossHandler() {
        //        searchAnnotation?.reuseId = searchAnnotation?.item?.category
        searchAnnotation?.reuseIdHigher = nil
        searchAnnotation = nil
//        crossIcon.isHidden = true
        searchLabel.text = "Where would you like to go?"
//        reloadMapIcons()
    }

    func searchHandler() {
        featureUnavailable()
    }
    
    //MAKR: Data Handler
    func reloadData() {
        sortItems()
        reloadMapIcons()
//        crossHandler()
    }
    
    func sortItems() {
//        clearMapView()
//        clearMapData()
        
        if let items = items {
            allAnnotations = [MyCustomPointAnnotation]()
            for each in items {
                let point = MyCustomPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: each.coordinateLan!, longitude: each.coordinateLon!)
                point.title = each.name
                point.item = each
                point.reuseId = each.category?.name
                point.reuseIdOriginal = each.category?.name
                allAnnotations.append(point)
//                switch (each.category?.name)! {
//                case "Ticketing Counters":
//                    ticketingAnnotations.append(point)
//                case "Events":
//                    eventAnnotations.append(point)
//                case "Prayer Rooms":
//                    prayerAnnotations.append(point)
//                case "Attractions":
//                    attractionAnnotations.append(point)
//                case "F&B":
//                    fbAnnotations.append(point)
//                case "Hotels & Spas":
//                    hotelAnnotations.append(point)
//                case "Retail & Other Services":
//                    shopAnnotations.append(point)
//                case "Linear Trails":
//                    trailAnnotations.append(point)
//                case "Non-Linear Trails":
//                    nonTrailAnnotations.append(point)
//                case "Rest Rooms":
//                    eventAnnotations.append(point)
//                case "Bus Stops":
//                    prayerAnnotations.append(point)
//                case "Tram Stops":
//                    tramAnnotations.append(point)
//                case "Express Stations":
//                    expressAnnotations.append(point)
//                case "Cable Car Stations":
//                    cableAnnotations.append(point)
//                default:
//                    break
//                }
            }
        }
    }
    
    func reloadMapIcons() {
        var allAnno = [MyCustomPointAnnotation]()
        if showOnMapMode {
            if let category = selectedCategory {
                if let id = selectedId {
                    var selected = allAnnotations[0]
                    for each in allAnnotations {
                        let item = each.item
                        if item?.category?.name == category && item?.ospId == id {
                            selected = each
                            break
                        }
                    }
                    allAnno.append(selected)
                } else {
                    for each in allAnnotations {
                        let item = each.item
                        if item?.category?.name == category {
                            allAnno.append(each)
                        }
                    }
                    if allAnno.isEmpty {
                        allAnno = allAnnotations.filter({ (anno) -> Bool in
                            return anno.item?.category?.name == "Events"
                        })
                    }
                }
            }
        } else {
            allAnno = allAnnotations
        }
//        clearMapView()
//        if let filters = filters {
//            if filters.contains(.Attraction) {
//                allAnno.append(contentsOf: attractionAnnotations)
//            }
//            if filters.contains(.BusStop) {
//                allAnno.append(contentsOf: busAnnotations)
//            }
//            if filters.contains(.CableStop) {
//                allAnno.append(contentsOf: cableAnnotations)
//            }
//            if filters.contains(.Event) {
//                allAnno.append(contentsOf: eventAnnotations)
//            }
//            if filters.contains(.ExpressStop) {
//                allAnno.append(contentsOf: expressAnnotations)
//            }
//            if filters.contains(.FB) {
//                allAnno.append(contentsOf: fbAnnotations)
//            }
//            if filters.contains(.Hotel) {
//                allAnno.append(contentsOf: hotelAnnotations)
//            }
//            if filters.contains(.PrayerRoom) {
//                allAnno.append(contentsOf: prayerAnnotations)
//            }
//            if filters.contains(.RestRoom) {
//                allAnno.append(contentsOf: restAnnotations)
//            }
//            if filters.contains(.Shop) {
//                allAnno.append(contentsOf: shopAnnotations)
//            }
//            if filters.contains(.TickingCounter) {
//                allAnno.append(contentsOf: ticketingAnnotations)
//            }
//            if filters.contains(.LinearTrail) {
//                allAnno.append(contentsOf: trailAnnotations)
//            }
//            if filters.contains(.NonLinearTrail) {
//                allAnno.append(contentsOf: nonTrailAnnotations)
//            }
//            if filters.contains(.TramStop) {
//                allAnno.append(contentsOf: tramAnnotations)
//            }
//        }
        mapView.addAnnotations(allAnno)
//        if showOnMapMode {
//            for each in allAnno {
//                debugPrint("i am going to reload")
//                mapView.deselectAnnotation(each, animated: false)
//                mapView.selectAnnotation(each, animated: true)
//            }
//        }
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
}

//MARK: - MAP delegate
extension FooyoBaseMapViewController: MGLMapViewDelegate {
    public func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        //        return MGLAnnotationView()
        // This example is only concerned with point annotations.
        if let annotation = annotation as? MyCustomPointAnnotation {
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            var reuseIdentifier = ""
            if let id = annotation.reuseIdHigher {
                reuseIdentifier = id
            } else {
                reuseIdentifier = (annotation.reuseId)!
            }
            debugPrint(reuseIdentifier)
            // For better performance, always try to reuse existing annotations.
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView {
                annotationView.applyColor(annotation: annotation)
                return annotationView
            } else {
                var annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                if reuseIdentifier == Constants.AnnotationId.UserMarker.rawValue {
                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 35), height: Scale.scaleY(y: 100))
                } else {
                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 12), height: Scale.scaleY(y: 12))
                }
                annotationView.applyColor(annotation: annotation)
                return annotationView
            }
            // If there’s no reusable annotation view available, initialize a new one.
            
        }
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
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
//            if (anno.item?.category)! != "restroom" {
//                // Hide the callout
//                let vc = gotoItemDetail(id: (anno.item?.id)!)
//                vc.delegate = self
//            }
            if let item = anno.item {
                let category = (item.category?.name)!
                let levelOneId = (item.ospId)!
                self.delegate?.didTapInformationWindow(category: category, levelOneId: levelOneId, levelTwoId: nil)
            }
            debugPrint("taped on the cell")
        }
    }
//    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
//        // Give our polyline a unique color by checking for its `title` property
//        if (annotation is MGLPolyline) {
//            // Mapbox cyan
//            //            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
//            return UIColor.sntDarkSkyBlue.withAlphaComponent(0.8)
//        }
//        else
//        {
//            return .red
//        }
//    }
}
