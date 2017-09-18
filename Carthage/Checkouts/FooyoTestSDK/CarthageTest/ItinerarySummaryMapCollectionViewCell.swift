//
//  ItinerarySummaryMapCollectionViewCell.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 18/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox

class ItinerarySummaryMapCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ItinerarySummaryMapCollectionViewCell"
    var mapView: MGLMapView!
    var allAnnotations = [MyCustomPointAnnotation]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        mapView = MGLMapView()
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 5
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureWith(plan: FooyoItinerary) {
        mapView.setVisibleCoordinateBounds(plan.getBounds(), edgePadding: UIEdgeInsetsMake(2, 2, 2, 2), animated: true)
//        mapView.hide
        mapView.attributionButton.alpha = 0
        mapView.removeAnnotations(allAnnotations)
        if let items = plan.items {
            allAnnotations = [MyCustomPointAnnotation]()
            for each in items {
                let point = MyCustomPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: each.coordinateLan!, longitude: each.coordinateLon!)
                point.title = each.name
                point.item = each
                point.reuseId = each.category?.name
                point.reuseIdOriginal = each.category?.name
                allAnnotations.append(point)
            }
        }
        mapView.addAnnotations(allAnnotations)
    }
}

extension ItinerarySummaryMapCollectionViewCell: MGLMapViewDelegate {
    public func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        //        return MGLAnnotationView()
        // This example is only concerned with point annotations.
        if let annotation = annotation as? MyCustomPointAnnotation {
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            var reuseIdentifier = ""
            reuseIdentifier = (annotation.reuseId)!
            // For better performance, always try to reuse existing annotations.
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView {
                return annotationView
            } else {
                var annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 15), height: Scale.scaleY(y: 15))
                return annotationView
            }
            // If there’s no reusable annotation view available, initialize a new one.
        }
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
}
