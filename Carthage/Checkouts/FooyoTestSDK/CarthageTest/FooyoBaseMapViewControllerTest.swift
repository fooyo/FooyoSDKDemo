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

//import
/*
class FooyoBaseMapViewControllerTest: BaseViewController {
 
    func loadData() {
        if Item.items.isEmpty {
            SVProgressHUD.show()
            HttpClient.sharedInstance.getItems { (items, isSuccess) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.errorView.isHidden = true
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                    if let items = items {
                        self.items = items
                        Item.items = items
                        Item.vivo = items.first(where: { (item) -> Bool in
                            return (item.name!.lowercased().contains("vivo")) && (item.name!.lowercased().contains("city"))
                        })!
                        self.reloadData()
                    }
                } else {
                    self.errorView.isHidden = false
                    self.navigationController?.navigationBar.isUserInteractionEnabled = false
                }
            }
        } else {
            self.items = Item.items
            self.reloadData()
        }
    }
    
    func setupErrorView() {
        view.addSubview(errorView)
        errorView.addSubview(overlayView)
        errorView.addSubview(reloadLabel)
        errorView.addSubview(reloadImage)
        errorView.addSubview(reloadView)
        let reloadGesture = UITapGestureRecognizer(target: self, action: #selector(reloadHandler))
        reloadView.addGestureRecognizer(reloadGesture)
    }
    func setupNavigationBar() {
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_filter"),  style: .plain, target: self, action: #selector(filterHandler))
        navigationItem.rightBarButtonItem = filterButton
        let logoView = UIImageView(image: #imageLiteral(resourceName: "Sentosa_Logo").imageByReplacingContentWithColor(color: .white))
        logoView.frame = CGRect(x: 0, y: 0, width: 96, height: 24)
        logoView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoView
    }
    
    
    
    func setupMapView() {
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapCenter = CLLocationCoordinate2D(latitude: Constants.mapCenterLat, longitude: Constants.mapCenterLong)
        mapView.setCenter(mapCenter!, zoomLevel: Constants.initZoomLevel, animated: false)
        mapView.showsUserLocation = true
        
        view.addSubview(mapView)
//        mapView.delegate = self
        // Fill an array with point annotations and add it to the map.
    }
    
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return to.distance(from: from)
    }
    func setupOtherView() {
        setupSearchView()
        
        view.addSubview(restroomButton)
        view.addSubview(locateButton)
        view.addSubview(overlayViewTwo)
        overlayViewTwo.alpha = 0.0
        restroomButton.image = #imageLiteral(resourceName: "toilet_gray")
        locateButton.image = #imageLiteral(resourceName: "location")
        let locateGesture = UITapGestureRecognizer(target: self, action: #selector(locateHandler))
        locateButton.addGestureRecognizer(locateGesture)
        let restroomGesture = UITapGestureRecognizer(target: self, action: #selector(restroomSwitchHandler))
        restroomButton.addGestureRecognizer(restroomGesture)
    }
    
    func setupSearchView() {
        view.addSubview(searchView)
        searchView.addSubview(searchIconOne)
        searchView.addSubview(searchLabelOne)
        searchView.addSubview(crossIconOne)
        crossIconOne.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI_4))
        let crossGesture = UITapGestureRecognizer(target: self, action: #selector(crossHandler))
        crossIconOne.addGestureRecognizer(crossGesture)
        let searchGesture = UITapGestureRecognizer(target: self, action: #selector(searchHandler))
        searchLabelOne.addGestureRecognizer(searchGesture)
    }
    

    func configureSearchView() {
        searchIconOne.isHidden = false
        searchLabelOne.isHidden = false
        crossIconOne.isHidden = false
    }
    
    func reloadData() {
        sortItems()
        reloadMapIcons()
        crossHandler()
    }
    
    func sortItems() {
        clearMapView()
        clearMapData()
        if let items = items {
            for each in items {
                let point = MyCustomPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: Double(each.coordinateLan!)!, longitude: Double(each.coordinateLon!)!)
                point.title = each.name
                point.item = each
                point.reuseId = each.category
                point.reuseIdOriginal = each.category
                allAnnotations.append(point)
                switch each.category! {
                case "attraction":
                    attractionAnnotations.append(point)
                    attractionItems.append(each)
                case "show":
                    showAnnotations.append(point)
                    showItems.append(each)
                case "restaurant":
                    restaurantAnnotations.append(point)
                    restaurantItems.append(each)
                case "shop":
                    shopAnnotations.append(point)
                    shopItems.append(each)
                case "bus_stop":
                    stopAnnotations.append(point)
                    stopItems.append(each)
                case "express_stop":
                    stopAnnotations.append(point)
                    stopItems.append(each)
                case "restroom":
                    restroomAnnotations.append(point)
                default:
                    break
                }
            }
        }
        attractionAnnotationsBK = attractionAnnotations
        shopAnnotationsBK = shopAnnotations
        showAnnotationsBK = showAnnotations
        stopAnnotationsBK = stopAnnotations
        restaurantAnnotationsBK = restaurantAnnotations
        
    }
    
    func reloadMapIcons() {
        clearMapView()
        var allAnno = [MyCustomPointAnnotation]()
        if let filters = filters {
            if filters.contains(.Attraction) {
                allAnno.append(contentsOf: attractionAnnotations)
            }
            if filters.contains(.Restaurant) {
                allAnno.append(contentsOf: restaurantAnnotations)
            }
            if filters.contains(.Show) {
                allAnno.append(contentsOf: showAnnotations)
            }
            if filters.contains(.Shop) {
                allAnno.append(contentsOf: shopAnnotations)
            }
            if filters.contains(.Stop) {
                allAnno.append(contentsOf: stopAnnotations)
            }
        }
        mapView.addAnnotations(allAnno)
    }
    
    func clearMapView() {
        mapView.removeAnnotations(allAnnotations)
        mapView.removeAnnotations(linesHome)
    }
    
    func clearMapData() {
        allAnnotations = [MyCustomPointAnnotation]()
        restroomAnnotations = [MyCustomPointAnnotation]()
        attractionAnnotations = [MyCustomPointAnnotation]()
        showAnnotations = [MyCustomPointAnnotation]()
        restaurantAnnotations = [MyCustomPointAnnotation]()
        shopAnnotations = [MyCustomPointAnnotation]()
        stopAnnotations = [MyCustomPointAnnotation]()
        searchAnnotation = nil
    }
    
    func setConstraints() {
        errorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        overlayView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        reloadLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(errorView.snp.centerY).offset(-Scale.scaleY(y: 100))
            make.leading.equalTo(Scale.scaleX(x: 50))
            make.trailing.equalTo(Scale.scaleX(x: -50))
        }
        reloadView.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 44))
            make.centerX.equalToSuperview()
            make.top.equalTo(reloadLabel.snp.bottom).offset(Scale.scaleY(y: 40))
        }
        reloadImage.snp.makeConstraints { (make) in
            make.center.equalTo(reloadView)
            make.height.width.equalTo(Scale.scaleY(y: 24))
        }
        searchView.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 24))
            make.trailing.equalTo(-Scale.scaleX(x: 24))
            make.height.equalTo(Scale.scaleY(y: 46))
            make.top.equalTo(Scale.scaleY(y: 48))
        }
        searchIconOne.snp.makeConstraints { (make) in
            make.width.equalTo(Scale.scaleX(x: 17))
            make.height.equalTo(Scale.scaleY(y: 20))
            make.leading.equalTo(Scale.scaleX(x: 16))
            make.centerY.equalToSuperview()
        }
        crossIconOne.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 15))
            make.trailing.equalTo(Scale.scaleX(x: -16))
            make.centerY.equalToSuperview()
        }
        searchLabelOne.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIconOne.snp.trailing).offset(Scale.scaleX(x: 6))
            make.trailing.equalTo(crossIconOne.snp.leading).offset(Scale.scaleX(x: -6))
        }
        restroomButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(Scale.scaleY(y: -42))
            make.height.width.equalTo(Scale.scaleY(y: 44))
            make.leading.equalTo(Scale.scaleX(x: 16))
        }
        locateButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(Scale.scaleY(y: -42))
            make.height.width.equalTo(Scale.scaleY(y: 44))
            make.trailing.equalTo(-Scale.scaleX(x: 16))
        }
        overlayViewTwo.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    // MARK: - Handlers
    
    func reloadHandler() {
        loadData()
    }
    func crossHandler() {
        //        searchAnnotation?.reuseId = searchAnnotation?.item?.category
        searchAnnotation?.reuseIdHigher = nil
        searchAnnotation = nil
        crossIconOne.isHidden = true
        searchLabelOne.text = "Search"
        reloadMapIcons()
    }
    
    func filterHandler() {
//        let vc = FilterViewController(mode: viewMode, sort: sortType, filters: filters)
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func locateHandler() {
        mapView.userTrackingMode = .followWithHeading
    }
    func restroomSwitchHandler() {
        restroomSwitch = !restroomSwitch
        if restroomSwitch {
            restroomButton.image = #imageLiteral(resourceName: "toilet_red")
            mapView.addAnnotations(restroomAnnotations)
        } else {
            restroomButton.image = #imageLiteral(resourceName: "toilet_gray")
            mapView.removeAnnotations(restroomAnnotations)
        }
    }
    
    func searchHandler() {
//        let vc = self.gotoSearchPage(source: .FromHomeMap)
//        vc.delegate = self
    }
}

 MARK: - MAP delegate
extension FooyoBaseMapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
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
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                if reuseIdentifier == Constants.AnnotationId.ItineraryItem.rawValue {
                    annotationView!.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 40), height: Scale.scaleY(y: 40))
                } else if reuseIdentifier == Constants.AnnotationId.UserMarker.rawValue {
                    annotationView!.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 35), height: Scale.scaleY(y: 100))
                } else {
                    annotationView!.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 28), height: Scale.scaleY(y: 28))
                    if selectedItinerary != nil {
                        annotationView?.alpha = 0.8
                    }
                }
                //
                //                if reuseIdentifier == Constants.AnnotationId.UserMarker.rawValue {
                //                    annotationView!.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 35), height: Scale.scaleY(y: 100))
                //                } else {
                //                }
                // Set the annotation view’s background color to a value determined by its longitude.
                //                let hue = CGFloat(annotation.coordinate.longitude) / 100
                //                annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
            }
            return annotationView
        }
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
        // Only show callouts for `Hello world!` annotation
        if annotation.responds(to: #selector(getter: UIPreviewActionItem.title)) {
            // Instantiate and return our custom callout view
            let view = CustomCalloutView(representedObject: annotation)
            view.userDelegate = self
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
        
        if let anno = annotation as? MyCustomPointAnnotation {
            if (anno.item?.category)! != "restroom" {
                // Hide the callout
                let vc = gotoItemDetail(id: (anno.item?.id)!)
                vc.delegate = self
            }
        }
    }
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        if (annotation is MGLPolyline) {
            // Mapbox cyan
            //            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
            return UIColor.sntDarkSkyBlue.withAlphaComponent(0.8)
        }
        else
        {
            return .red
        }
    }
    //    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
    //        debugPrint("deselect")
    //        debugPrint(annotation.title)
    ////        mapView.selectAnnotation(annotation, animated: false)
    //        mapView.selectAnnotation(annotation, animated: false)
    //
    //    }
    //
    //    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
    //        debugPrint("select")
    //        debugPrint(annotation.title)
    //        debugPrint(mapCenter?.latitude)
    //        debugPrint(annotation.coordinate.latitude)
    //        debugPrint(mapCenter?.longitude)
    //        debugPrint(annotation.coordinate.longitude)
    //        if annotation.coordinate.latitude == mapCenter!.latitude && annotation.coordinate.longitude == mapCenter!.longitude {
    //            debugPrint("already center")
    //        } else {
    //            mapCenter = annotation.coordinate
    //            mapView.setCenter(annotation.coordinate, animated: true)
    //        }
    //    }
}

MARK: - Filter Delegate
extension FooyoBaseMapViewController: FilterViewControllerDelegate {
    func filter(sortType: Constants.SortType?, filterType: [Constants.FilterType]?) {
        self.sortType = sortType
        self.filters = filterType
        reloadMapIcons()
    }
}

extension FooyoBaseMapViewController: CustomCalloutViewDelegate {
    //    func didTapDirection() {
    //        debugPrint("testing")
    //        self.gotoRoutes()
    //    }
    func didTapDirection(item: Item) {
        self.gotoRoutes(item: item)
    }
}

extension FooyoBaseMapViewController: SearchViewControllerDelegate, ItemDetailViewControllerDelegate {
    func searchViewItemSelected(id: Int, name: String, category: String) {
        exeDelegate(id: id, name: name, category: category)
    }
    
    func itemDetailItemSelected(id: Int, name: String, category: String) {
        exeDelegate(id: id, name: name, category: category)
    }
    func exeDelegate(id: Int, name: String, category: String) {
        if viewMode == Constants.ViewMode.List {
            switchToMap()
        }
        clearMapView()
        for each in allAnnotations {
            if each.item?.id == id {
                each.reuseIdHigher = Constants.AnnotationId.UserMarker.rawValue
                searchAnnotation = each
            } else {
                each.reuseIdHigher = nil
            }
        }
        reloadMapIcons()
        searchLabelOne.text = name
        crossIconOne.isHidden = false
        mapView.setCenter((searchAnnotation?.item?.getCoor())!, zoomLevel: 15, direction: 0, animated: true) {
            self.mapView.selectAnnotation(self.searchAnnotation!, animated: true)
        }
    }
    func flipBtn() {
        createButton.insideButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        createButton.insideButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        createButton.insideButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    func unFlipBtn() {
        createButton.insideButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        createButton.insideButton.titleLabel?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        createButton.insideButton.imageView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func updateSelectedItinerary() {
        if let itinerary = self.selectedItinerary {
            self.selectedItinerary = itinerary.makeCopy()
            if let items = selectedItinerary?.items {
                var newItems = [Item]()
                for each in items {
                    let item = Item.items.first(where: { (n) -> Bool in
                        return each.id == n.id
                    })
                    item?.arrivingTime = each.arrivingTime
                    item?.visitingTime = each.visitingTime
                    newItems.append(item!)
                }
                self.selectedItinerary?.items = newItems
            }
        }
    }
    func reloadMapIconsWithItinerary() {
        debugPrint("reloadMapIconsWithItinerary")
        clearMapView()
        var allAnno = [MyCustomPointAnnotation]()
        if let filters = filters {
            if filters.contains(.Attraction) {
                allAnno.append(contentsOf: attractionAnnotations)
            }
            if filters.contains(.Restaurant) {
                allAnno.append(contentsOf: restaurantAnnotations)
            }
            if filters.contains(.Show) {
                allAnno.append(contentsOf: showAnnotations)
            }
            if filters.contains(.Shop) {
                allAnno.append(contentsOf: shopAnnotations)
            }
            if filters.contains(.Stop) {
                allAnno.append(contentsOf: stopAnnotations)
            }
        }
        
        if selectedItinerary != nil {
            allAnno.append(contentsOf: selectedItineraryAnnotations)
        }
        mapView.addAnnotations(allAnno)
        
        //        if !plottedHome {
        //            plottedHome = true
        //        }
        loadGeoJson()
    }
    
    func loadGeoJson() {
        if let items = selectedItinerary?.items {
            if items.count > 1 {
                DispatchQueue.global(qos: .background).async(execute: {
                    self.linesHome = [MGLPolylineFeature]()
                    for index in 0..<(items.count - 1) {
                        let one = items[index]
                        let two = items[index + 1]
                        let latOne = Double((one.coordinateLan)!)!
                        let lonOne = Double((one.coordinateLon)!)!
                        let latTwo = Double((two.coordinateLan)!)!
                        let lonTwo = Double((two.coordinateLon)!)!
                        let list = [[latOne, lonOne],[latTwo, lonTwo]]
                        let line = self.getLine(locations: list)
                        self.linesHome.append(line)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        // Unowned reference to self to prevent retain cycle
                        [unowned self] in
                        self.drawPolyline(lines: self.linesHome)
                    })
                })
            }
        }
        
    }
    
    func getLine(locations: [[Double]]) -> MGLPolylineFeature {
        var coordinates: [CLLocationCoordinate2D] = []
        
        for location in locations {
            let coordinate = CLLocationCoordinate2D(latitude: location[0], longitude: location[1])
            coordinates.append(coordinate)
        }
        return MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))
    }
    
    func drawPolyline(lines: [MGLPolylineFeature]) {
        for line in lines {
            DispatchQueue.main.async(execute: {
                // Unowned reference to self to prevent retain cycle
                [unowned self] in
                self.mapView.addAnnotation(line)
            })
        }
        
    }
    
    func resetCategories() {
        for each in allAnnotations {
            each.reuseId = each.reuseIdOriginal
        }
        attractionAnnotations = attractionAnnotationsBK
        restaurantAnnotations = restaurantAnnotationsBK
        showAnnotations = showAnnotationsBK
        shopAnnotations = shopAnnotationsBK
        stopAnnotations = stopAnnotationsBK
    }
}

 */
