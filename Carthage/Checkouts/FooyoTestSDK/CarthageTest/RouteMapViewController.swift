//
//  RouteMapViewController.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 7/3/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox

class RouteMapViewController: FooyoBaseMapViewController {
    fileprivate var route: FooyoRoute?
    
    fileprivate var lowerView: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        return t
    }()
    
    var startIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "basemap_gps")
        return t
    }()
    var endIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "basemap_markersmall")
        return t
    }()
    
    
    var instructionView: UIScrollView! = {
        let t = UIScrollView()
        t.backgroundColor  = .white
        t.alwaysBounceVertical = false
        t.alwaysBounceHorizontal = true
        return t
    }()

    fileprivate var navigationIcon: ShadowView! = {
        let t = ShadowView()
        t.backgroundColor = UIColor.ospSentosaGreen
//        t.contentMode = .scaleAspectFit
        t.layer.cornerRadius = Scale.scaleY(y: 52) / 2
        return t
    }()
    fileprivate var navigationImage: UIImageView! = {
        let t = UIImageView()
        return t
    }()
    
//    var mapView: MGLMapView!
//    fileprivate var items: [FooyoItem]?
//    fileprivate var otherAnnotations = [MGLPointAnnotation]()
//    fileprivate var restroomSwitch: Bool = false
//    
//    fileprivate var restroomButton: UIImageView! = {
//        let t = UIImageView()
//        t.backgroundColor = .white
//        t.layer.cornerRadius = Scale.scaleY(y: 44) / 2
//        t.layer.shadowColor = UIColor.sntBlack22.cgColor
//        t.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
//        t.layer.shadowRadius = Scale.scaleY(y: 6)
//        t.layer.shadowOpacity = 1
//        t.alpha = 0.9
//        t.isUserInteractionEnabled = true
//        t.contentMode = .center
//        return t
//    }()
//    
//    fileprivate var locateButton: UIImageView! = {
//        let t = UIImageView()
//        t.backgroundColor = .white
//        t.layer.cornerRadius = Scale.scaleY(y: 44) / 2
//        t.layer.shadowColor = UIColor.sntBlack22.cgColor
//        t.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
//        t.layer.shadowRadius = Scale.scaleY(y: 6)
//        t.layer.shadowOpacity = 1
//        t.alpha = 0.9
//        t.isUserInteractionEnabled = true
//        t.contentMode = .center
//        return t
//    }()
    // MARK: - Life Cycle
    init(route: FooyoRoute) {
        super.init(hideTheDefaultNavigationBar: false)
        self.route = route
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = route?.getName()
        debugPrint(route!.getBounds())
        mapView.setVisibleCoordinateBounds(route!.getBounds(), edgePadding: UIEdgeInsetsMake(80, 80, 80, 80), animated: false)
        goBtn.isHidden = true
        view.addSubview(lowerView)
        lowerView.addSubview(navigationIcon)
        lowerView.addSubview(instructionView)
        instructionView.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 18))
            make.height.equalTo(Scale.scaleY(y: 28))
            make.trailing.equalTo(navigationIcon.snp.leading).offset(Scale.scaleX(x: -15))
            make.centerY.equalToSuperview()
        }
        lowerView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 60))
        }
        navigationIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 52))
            make.trailing.equalTo(Scale.scaleX(x: -10))
            make.centerY.equalTo(lowerView.snp.top)
        }
        gpsBtn.snp.remakeConstraints { (make) in
            make.centerX.equalTo(navigationIcon)
            make.height.width.equalTo(Scale.scaleY(y: 40))
            make.bottom.equalTo(navigationIcon.snp.top).offset(Scale.scaleY(y: -16))
        }
        setupInstructionView()
//        self.sortItems()
//        setConstraints()
    }
    
//    override
    
    func setupInstructionView() {
        for each in instructionView.subviews {
            each.snp.removeConstraints()
            each.removeFromSuperview()
        }
        instructionView.addSubview(startIcon)
        startIcon.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Scale.scaleY(y: 16))
        }
        let firstArrow = UIImageView()
        firstArrow.applyBundleImage(name: "navigation_rightarrow")
        firstArrow.contentMode = .scaleAspectFit
        instructionView.addSubview(firstArrow)
        firstArrow.snp.makeConstraints { (make) in
            make.leading.equalTo(startIcon.snp.trailing).offset(Scale.scaleX(x: 6))
            make.centerY.equalTo(startIcon)
            make.height.equalTo(Scale.scaleY(y: 5))
            make.width.equalTo(Scale.scaleX(x: 6))
        }
        
        var subViews = [NavigationItemView]()
        var index = 0
        var firstPSV = true
        for each in (route?.PSVList)! {
            let itemView = NavigationItemView(type: FooyoConstants.transportationTypes[each])
            instructionView.addSubview(itemView)
            subViews.append(itemView)
            if firstPSV {
                firstPSV = false
                itemView.snp.makeConstraints { (make) in
                    make.leading.equalTo(firstArrow.snp.trailing).offset(Scale.scaleX(x: 9))
                    make.centerY.equalToSuperview()
                    make.height.equalTo(Scale.scaleY(y: 28))
                    make.width.equalTo(Scale.scaleX(x: 85))
                }
            } else {
                itemView.snp.makeConstraints { (make) in
                    make.leading.equalTo(subViews[index - 1].snp.trailing).offset(Scale.scaleX(x: 9))
                    make.centerY.equalToSuperview()
                    make.height.equalTo(Scale.scaleY(y: 28))
                    make.width.equalTo(Scale.scaleX(x: 85))
                }
            }
            index = index + 1
        }
        
        instructionView.addSubview(endIcon)
        endIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 14))
            make.width.equalTo(Scale.scaleY(y: 10))
            make.leading.equalTo(subViews[index - 1].snp.trailing).offset(Scale.scaleX(x: 9))
        }
    }

//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("i am inside")
        if self.navigationController?.navigationBar.isHidden == true {
            debugPrint("i am redefining")
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.isHidden = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.setVisibleCoordinateBounds(route!.getBounds(), edgePadding: UIEdgeInsetsMake(80, 80, 80, 80), animated: true)
    }
    
    override func setupSearchView() {
        super.setupSearchView()
        searchView.isUserInteractionEnabled = false
        if let end = route?.endItem {
            searchLabel.text = end.name
        } else {
            if let end = route?.endCoord {
                searchLabel.text = "(\(end.latitude), \(end.longitude))"
            }
        }
    }
//    func setConstraints() {
//        restroomButton.snp.makeConstraints { (make) in
//            make.bottom.equalTo(Scale.scaleY(y: -42))
//            make.height.width.equalTo(Scale.scaleY(y: 44))
//            make.leading.equalTo(Scale.scaleX(x: 16))
//        }
//        locateButton.snp.makeConstraints { (make) in
//            make.bottom.equalTo(Scale.scaleY(y: -42))
//            make.height.width.equalTo(Scale.scaleY(y: 44))
//            make.trailing.equalTo(-Scale.scaleX(x: 16))
//        }
//    }
//    func restroomSwitchHandler() {
//        restroomSwitch = !restroomSwitch
//        if restroomSwitch {
//            restroomButton.image = #imageLiteral(resourceName: "toilet_red")
//            mapView.addAnnotations(restroomAnnotations)
//        } else {
//            restroomButton.image = #imageLiteral(resourceName: "toilet_gray")
//            mapView.removeAnnotations(restroomAnnotations)
//        }
//    }
//    func locateHandler() {
//        mapView.userTrackingMode = .followWithHeading
//    }
//    
//    func sortItems() {
//        if let items = items {
//            for each in items {
//                let point = MyCustomPointAnnotation()
//                point.coordinate = CLLocationCoordinate2D(latitude: Double(each.coordinateLan!)!, longitude: Double(each.coordinateLon!)!)
//                point.item = each
//                point.title = each.name
//                if each.id == route?.startItem?.id {
//                    point.reuseId = Constants.AnnotationId.StartItem.rawValue
//                } else if each.id == route?.endItem?.id {
//                    point.reuseId = Constants.AnnotationId.EndItem.rawValue
//                } else {
//                    point.reuseId = each.category!
//                }
//                switch each.category! {
//                case "restroom":
//                    restroomAnnotations.append(point)
//                default:
//                    otherAnnotations.append(point)
//                }
//            }
//        }
//        mapView.addAnnotations(otherAnnotations)
//    }
}

extension RouteMapViewController {
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        debugPrint("loading all the annotation views")
//        // This example is only concerned with point annotations.
//        if let annotation = annotation as? MyCustomPointAnnotation {
//            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
////            let reuseIdentifier = (annotation.item?.category)!
//            let reuseIdentifier = (annotation.reuseId)!
//            
//            // For better performance, always try to reuse existing annotations.
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//            
//            // If there’s no reusable annotation view available, initialize a new one.
//            if annotationView == nil {
//                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
//                if reuseIdentifier == Constants.AnnotationId.StartItem.rawValue || reuseIdentifier == Constants.AnnotationId.EndItem.rawValue {
//                    annotationView!.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 40), height: Scale.scaleY(y: 40))
////                    mapView.bringSubview(toFront: annotationView!)
//                } else {
////                    annotationView!.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 28), height: Scale.scaleY(y: 28))
//                    annotationView!.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 15), height: Scale.scaleY(y: 15))
//                    annotationView?.alpha = 0.8
//                }
//                // Set the annotation view’s background color to a value determined by its longitude.
//                let hue = CGFloat(annotation.coordinate.longitude) / 100
//                annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
//            }
//            return annotationView
//        }
//        return nil
//    }
//    
//    
//    // Allow callout view to appear when an annotation is tapped.
//    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        return true
//    }
//    
//    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
//        // Only show callouts for `Hello world!` annotation
//        if annotation.responds(to: #selector(getter: UIPreviewActionItem.title)) {
//            // Instantiate and return our custom callout view
//            let view = CustomCalloutView(representedObject: annotation)
//            view.fromSource = Constants.PageSource.FromNavigation
//            return view
//        }
//        
//        return nil
//    }
//    
//    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        mapView.deselectAnnotation(annotation, animated: true)
//
//        if let rep = annotation as? MyCustomPointAnnotation {
//            if (rep.item?.category)! != "restroom" {
//                // Hide the callout
//                _ = gotoItemDetail(id: (rep.item?.id)!, from: Constants.PageSource.FromNavigation)
//            }
//        }
//    }
//    
//    func mapView(_ mapView: MGLMapView, didAdd annotationViews: [MGLAnnotationView]) {
//        for each in annotationViews {
////            if let anno = each as? MyCustomPointAnnotation {
////                if anno.reuseId == Constants.AnnotationId.EndItem.rawValue ||
////                    anno.reuseId == Constants.AnnotationId.EndPoint.rawValue ||
////                    anno.reuseId == Constants.AnnotationId.StartItem.rawValue ||
////                    anno.reuseId == Constants.AnnotationId.StartPoint.rawValue {
////                    let annoView = mapView.view(for: anno)
////                }
////            }
//            debugPrint(each.frame.width)
//            if each.frame.width == Scale.scaleY(y: 40) {
//                debugPrint("true")
//                mapView.bringSubview(toFront: each)
//                view.bringSubview(toFront: each)
//            }
//        }
//    }
//    
//    // Wait until the map is loaded before adding to the map.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        debugPrint("did finish loading style")
        loadGeoJson()
    }
//    func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool) {
//        if mapView.zoomLevel > 16 {
//            for annotation in mapView.annotations! {
//                if let annotation = annotation as? MyCustomPointAnnotation {
//                    if let view = mapView.view(for: annotation) as? CustomAnnotationView {
//                        let reuseIdentifier = (annotation.reuseId)!
//                        if reuseIdentifier == Constants.AnnotationId.StartItem.rawValue || reuseIdentifier == Constants.AnnotationId.EndItem.rawValue {
//                        } else {
//                            UIView.animate(withDuration: 0.5, animations: {
//                                view.frame.size = CGSize(width: Scale.scaleY(y: 28), height: Scale.scaleY(y: 28))
//                                view.alpha = 1
//                            })
//                        }
//                    }
//                }
//            }
//        } else {
//            for annotation in mapView.annotations! {
//                if let annotation = annotation as? MyCustomPointAnnotation {
//                    if let view = mapView.view(for: annotation) as? CustomAnnotationView {
//                        let reuseIdentifier = (annotation.reuseId)!
//                        if reuseIdentifier == Constants.AnnotationId.StartItem.rawValue || reuseIdentifier == Constants.AnnotationId.EndItem.rawValue {
//                        } else {
//                            UIView.animate(withDuration: 0.5, animations: {
//                                view.frame.size = CGSize(width: Scale.scaleY(y: 15), height: Scale.scaleY(y: 15))
//                                view.alpha = 0.8
//                            })
//                        }
//                    }
//                }
//            }
//            
//        }
//    }
//    
    func loadGeoJson() {
//        DispatchQueue.global().async {
//            // Get the path for example.geojson in the app’s bundle.
//            guard let jsonUrl = Bundle.main.url(forResource: "example", withExtension: "geojson") else { return }
//            guard let jsonData = try? Data(contentsOf: jsonUrl) else { return }
//            
//            debugPrint(jsonData)
//            DispatchQueue.main.async {
//                self.drawPolyline(geoJson: jsonData)
//            }
//        }
        DispatchQueue.global(qos: .background).async(execute: {
            // Get the path for example.geojson in the app's bundle
//            let jsonPath = Bundle.main.path(forResource: "example", ofType: "geojson")
//            let url = URL(fileURLWithPath: jsonPath!)
            
            
            var lines = [MGLPolyline]()
            var linesType = [String]()
            if self.route?.type == "bus" {
                for index in 0..<(self.route?.typeList?.count)! {
                    let type = (self.route?.typeList)![index]
                    let list = (self.route?.coordList)![index]
                    let line = self.getLine(locations: list)
                    lines.append(line)
                    linesType.append(type.rawValue)
                }
            } else {
                let line = self.getLine(locations: (self.route?.coordinates)!)
                lines.append(line)
                linesType.append(FooyoConstants.RouteType.Walking.rawValue)
            }
            
            
//            var coordinates: [CLLocationCoordinate2D] = []
//            
//            if let locations = self.route?.coordinates  {
//                // Iterate over line coordinates, stored in GeoJSON as many lng, lat arrays
//                for location in locations {
//                    // Make a CLLocationCoordinate2D with the lat, lng
////                    debugPrint("--------------------")
////                    debugPrint(location)
//                    let coordinate = CLLocationCoordinate2D(latitude: location[1], longitude: location[0])
//                    
//                    // Add coordinate to coordinates array
//                    coordinates.append(coordinate)
//                }
//            }
//            
//            let line = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
            
            // Optionally set the title of the polyline, which can be used for:
            //  - Callout view
            //  - Object identification
//            line.title = "Crema to Council Crest"
            
            // Add the annotation on the main thread
            
            DispatchQueue.main.async(execute: {
                // Unowned reference to self to prevent retain cycle
                [unowned self] in
                self.drawPolyline(lines: lines, linesType: linesType)
            })
        })
    }
    
    func getLine(locations: [[Double]]) -> MGLPolyline {
        var coordinates: [CLLocationCoordinate2D] = []
        
        for location in locations {
            let coordinate = CLLocationCoordinate2D(latitude: location[1], longitude: location[0])
            coordinates.append(coordinate)
        }
        
        return MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
    }
    
    func drawPolyline(lines: [MGLPolyline], linesType: [String]) {
        // Add our GeoJSON data to the map as an MGLGeoJSONSource.
        // We can then reference this data from an MGLStyleLayer.
        
        // MGLMapView.style is optional, so you must guard against it not being set.
        guard let style = self.mapView.style else { return }
        var index = 0
        for (line, type) in zip(lines, linesType) {
            index += 1
            //        let shapeFromGeoJSON = try! MGLShape(data: geoJson, encoding: String.Encoding.utf8.rawValue)
            let shapeFromGeoJSON = line
            let source = MGLShapeSource(identifier: "polyline_\(index)", shape: shapeFromGeoJSON, options: nil)
            style.addSource(source)
            
            // Create new layer for the line
            let layer = MGLLineStyleLayer(identifier: "polyline_\(index)", source: source)
            layer.lineJoin = MGLStyleValue(rawValue: NSValue(mglLineJoin: .round))
            layer.lineCap = MGLStyleValue(rawValue: NSValue(mglLineCap: .round))
            //        layer.lineColor = MGLStyleValue(rawValue: UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1))
            layer.lineColor = MGLStyleValue(rawValue: UIColor.express)
            // Use a style function to smoothly adjust the line width from 2pt to 20pt between zoom levels 14 and 18. The `interpolationBase` parameter allows the values to interpolate along an exponential curve.
            layer.lineWidth = MGLStyleValue(rawValue: 1)
            //        layer.lineWidth = MGLStyleValue(interpolationBase: 1.5, stops: [
            //            14: MGLStyleValue(rawValue: 2),
            //            18: MGLStyleValue(rawValue: 9),
            //            ])
            
            // We can also add a second layer that will draw a stroke around the original line.
            let casingLayer = MGLLineStyleLayer(identifier: "polyline-case_\(index)", source: source)
            // Copy these attributes from the main line layer.
            casingLayer.lineJoin = layer.lineJoin
            casingLayer.lineCap = layer.lineCap
            // Line gap width represents the space before the outline begins, so should match the main line’s line width exactly.
            casingLayer.lineGapWidth = layer.lineWidth
            // Stroke color slightly darker than the line color.
            casingLayer.lineColor = MGLStyleValue(rawValue: UIColor.express)//UIColor(red: 41/255, green:145/255, blue:171/255, alpha:1))
            // Use a style function to gradually increase the stroke width between zoom levels 14 and 18.
            casingLayer.lineWidth = MGLStyleValue(interpolationBase: 1.5, stops: [
                14: MGLStyleValue(rawValue: 2),
                18: MGLStyleValue(rawValue: 5),
                ])
            
            // Just for fun, let’s add another copy of the line with a dash pattern.
            let dashedLayer = MGLLineStyleLayer(identifier: "polyline-dash_\(index)", source: source)
            dashedLayer.lineJoin = layer.lineJoin
            dashedLayer.lineCap = layer.lineCap
            dashedLayer.lineColor = MGLStyleValue(rawValue: UIColor.express)
            //        dashedLayer.lineOpacity = MGLStyleValue(rawValue: 0.5)
            dashedLayer.lineWidth = MGLStyleValue(rawValue: 5)//layer.lineWidth
            // Dash pattern in the format [dash, gap, dash, gap, ...]. You’ll want to adjust these values based on the line cap style.
            dashedLayer.lineDashPattern = MGLStyleValue(rawValue: [0, 1.5])
            
            if type == FooyoConstants.RouteType.Walking.rawValue {
                style.addLayer(layer)
                style.addLayer(dashedLayer)
            } else {
                style.addLayer(layer)
                style.addLayer(casingLayer)
            }
            //        style.insertLayer(casingLayer, below: layer)
            //        style.addLayer(casingLayer)
        }
    }
}
