////
////  DisplayItineraryViewController.swift
////  FooyoSDKExample
////
////  Created by Yangfan Liu on 20/9/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import UIKit
//import Mapbox
//
//class DisplayItineraryViewController: EditItineraryViewController {
//
//    override func viewDidLoad() {
////        isEditMode = false
//        super.viewDidLoad()
////        NotificationCenter.default.addObserver(self, selector: #selector(updateItineraries(_:)), name: NSNotification.Name(rawValue: Constants.Notification.updateItinerary.rawValue), object: nil)
//        
//        // Do any additional setup after loading the view.
////        filterBtn.isHidden = true
//        searchView.isHidden = true
//        listBtn.isHidden = true
//        redoBtn.isHidden = true
//        undoBtn.isHidden = true
//        autoButton.isHidden = true
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//        setupNavigationBar()
//    }
//    
//    override func setupNavigationBar() {
//        navigationItem.title = itinerary?.name
//        let switchButton = UIBarButtonItem(image: UIImage.getBundleImage(name: "plan_listview"),  style: .plain, target: self, action: #selector(listModeHandler))
//        let editButton = UIBarButtonItem(image: UIImage.getBundleImage(name: "plan_edit"),  style: .plain, target: self, action: #selector(editHandler))
//        navigationItem.rightBarButtonItems = [editButton, switchButton]
//    }
//    
//    
//}
//
//extension DisplayItineraryViewController    {
//    override func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        return false
//    }
////    func updateItineraries(_ notification: Foundation.Notification) {
////        debugPrint("i got the notification")
////        if let itinerary = notification.object as? Itinerary {
////            if itinerary.id == self.itinerary?.id {
////                self.itinerary = itinerary.makeCopy()
////                var oldItems = self.itinerary?.items
////                updateItinerary(items: oldItems!)
////                reloadData()
////            }
////        }
////    }
//}
