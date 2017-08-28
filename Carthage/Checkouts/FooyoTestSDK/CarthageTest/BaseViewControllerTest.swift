//
//  BaseViewController.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 17/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SnapKit
import Mapbox
//import SVProgressHUD
//import ViewDeck

public class BaseViewControllerTest: UIViewController {
    
    var statusBarHeight: CGFloat = 20
    var navigationBarHeight: CGFloat = 44
    
    
    //    overlayView.snp.makeConstraints { (make) in
    //    //            make.edges.equalToSuperview()
    //        make.leading.equalToSuperview()
    //        make.trailing.equalToSuperview()
    //        make.top.equalTo(viewDeckController.view.snp.bottom)
    //        make.height.equalToSuperview()
    //    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        MGLAccountManager.setAccessToken("pk.eyJ1IjoicHVzaGlhbiIsImEiOiJjaXdyaXptNDAweG1rMm90YmRnZHl0dDFpIn0.9kBN2eXNRe3uZ9VMoMhfhg")
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        //        dismissTapGesture.addTarget(self, action: #selector(dismissHandler))
        //        view.addGestureRecognizer(dismissTapGesture)
        
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        navigationBarHeight = (navigationController?.navigationBar.frame.height) ?? 44
        //        self.viewDeckController.view.addSubview(<#T##view: UIView##UIView#>)

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
//        Constants.dynamicSuggestionView.delegate = self
//        HttpClient.sharedInstance.delegate = self
        

    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

//extension BaseViewController: DynamicViewDelegate {
//    func dynamicManualUpdate(itinerary: Itinerary) {
//        //        debugPrint(Itin)
//        //        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//        debugPrint("i am inside the manual mode")
//        //        gotoEditItinerary(itinerary: itinerary)
//        //        gotoEditItinerary(itinerary: itinerary, withNotification: true)
//        let vc = EditItineraryViewController(itinerary: itinerary, inThePresentMode: true)
//        vc.notificationBtn.isHidden = false
//        let nav = UINavigationController(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)
//        //        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    func closeDynamic() {
//        debugPrint("closed the dynamic")
//        User.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getSuggestion), userInfo: nil, repeats: true)
//    }
//}
