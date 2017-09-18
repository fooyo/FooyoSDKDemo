//
//  EditItineraryViewController.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 16/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox
import AlamofireImage
//import LXReorderableCollectionViewFlowLayout
import SVProgressHUD
//import DateToolsSwift

//protocol EditItineraryViewControllerDelegate: class {
//    func editUpdateItinerary(itinerary: FooyoItinerary)
//}

class EditItineraryViewController: FooyoBaseMapViewController {
    fileprivate var itinerary: FooyoItinerary?
    var startItem = FooyoItem()
    var timeNow = Date()
    var ignoreBudget = false
    var ignoreTime = false
    
    var plotted = false
    var lines = [MGLPolylineFeature]()

    var listBtn: ShadowView! = {
        let t = ShadowView()
        t.backgroundColor = .white
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var listBtnInside: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "plan_listview")
        t.contentMode = .scaleAspectFit
        t.layer.cornerRadius = Scale.scaleY(y: 15) / 2
        return t
    }()
    
    var expanded = false
    
    var autoButton: ShadowView! = {
        let t = ShadowView()
        t.backgroundColor = UIColor.ospSentosaOrange
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var autoButtonInside: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "plan_optimize")
        t.contentMode = .scaleAspectFit
        return t
    }()
    
    var undoBtn: ShadowView! = {
        let t = ShadowView()
        t.backgroundColor = .white
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var undoBtnInside: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "plan_undo")
        t.contentMode = .scaleAspectFit
        return t
    }()
    var redoBtn: ShadowView! = {
        let t = ShadowView()
        t.backgroundColor = .white
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var redoBtnInside: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "plan_redo")
        t.contentMode = .scaleAspectFit
        return t
    }()
    
    var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: Scale.scaleY(y: 39), left: 0, bottom: Scale.scaleY(y: 16), right: Scale.scaleX(x: 16))
        //        layout.itemSize = CGSize(width: Scale.scaleX(x: 330), height: Scale.scaleY(y: 106))
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - Scale.scaleX(x: 20), height: Scale.scaleY(y: 106))
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        t.register(ItineraryMapCollectionViewCell.self, forCellWithReuseIdentifier: ItineraryMapCollectionViewCell.reuseIdentifier)
        t.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        t.alwaysBounceHorizontal = true
        t.alwaysBounceVertical = false
        return t
    }()
    
//    var collectionViewTwo: UICollectionView! = {
//        let layout = LXReorderableCollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: Scale.scaleY(y: 39), left: Scale.scaleX(x: 24), bottom: Scale.scaleY(y: 24), right: Scale.scaleX(x: 24))
//        let space = (FooyoConstants.mainWidth - 2 * Scale.scaleX(x: 24) - 3 * Scale.scaleX(x: 98)) / 2
//        layout.itemSize = CGSize(width: Scale.scaleX(x: 98), height: Scale.scaleY(y: 92))
//        layout.minimumInteritemSpacing = space
//        layout.minimumLineSpacing = space
//        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
//        t.register(ItineraryEditViewTwoCollectionViewCell.self, forCellWithReuseIdentifier: ItineraryEditViewTwoCollectionViewCell.reuseIdentifier)
//        t.backgroundColor = UIColor.white.withAlphaComponent(0.85)
//        t.alwaysBounceHorizontal = false
//        t.alwaysBounceVertical = true
//        return t
//    }()
    
    // Item View
    var displayedItem: FooyoItem?

    var itemView: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        t.clipsToBounds = true
        t.layer.cornerRadius = 6
        t.isUserInteractionEnabled = true
        return t
    }()
    var avatarView: UIImageView! = {
        let t = UIImageView()
        t.backgroundColor = UIColor.ospWhite
        t.contentMode = .scaleAspectFill
        t.clipsToBounds = true
        t.layer.cornerRadius = 6
        return t
    }()
    
    var nameLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.black
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    fileprivate var tagLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.ospGrey
        return t
    }()
    fileprivate var reviewView: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_review")
        t.contentMode = .scaleAspectFit
        return t
    }()
    fileprivate var reviewLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.black
        t.contentMode = .scaleAspectFit
        return t
    }()
    fileprivate var playView: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "plan_clock")
        t.contentMode = .scaleAspectFit
        return t
    }()
    fileprivate var playLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.black
        t.contentMode = .scaleAspectFit
        return t
    }()
    
    var budgetLabel: UILabel! = {
        let t = UILabel()
        t.alpha = 0.9
        t.backgroundColor = UIColor.ospSentosaGreen
        t.text = "$0"
        t.textAlignment = .center
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.layer.cornerRadius = Scale.scaleY(y: 30)  / 2
        t.clipsToBounds = true
        t.textColor = .white
        return t
    }()
    
    var expandBtn: UIImageView! = {
        let t = UIImageView()
        t.clipsToBounds = true
        t.isUserInteractionEnabled = true
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "general_uparrow")
        return t
    }()
    
    var history = [FooyoItinerary]()
    var currentIndex = 0

    // MARK: - Life Cycle
    init(itinerary: FooyoItinerary) {
        super.init(hideTheDefaultNavigationBar: false)
        self.itinerary = itinerary.makeCopy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.isUserInteractionEnabled = false
        addToHistory()
        if itinerary?.tripType == FooyoConstants.tripType.HalfDayAfternoon.rawValue {
            timeNow = DateTimeTool.fromFormatOneToDate("12:30")
        } else {
            timeNow = DateTimeTool.fromFormatOneToDate("09:00")
        }
        
        self.navigationItem.title = itinerary?.name
        goBtn.isHidden = true
        gpsBtn.isHidden = true
        setupNavigationBar()
        view.addSubview(listBtn)
        listBtn.addSubview(listBtnInside)
        view.addSubview(itemView)
        itemView.addSubview(avatarView)
        itemView.addSubview(nameLabel)
        itemView.addSubview(tagLabel)
        itemView.addSubview(reviewView)
        itemView.addSubview(reviewLabel)
        itemView.addSubview(playView)
        itemView.addSubview(playLabel)
        view.addSubview(budgetLabel)
        view.addSubview(collectionView)
        view.addSubview(autoButton)
        autoButton.addSubview(autoButtonInside)
        view.addSubview(redoBtn)
        redoBtn.addSubview(redoBtnInside)
        view.addSubview(undoBtn)
        undoBtn.addSubview(undoBtnInside)
        view.addSubview(expandBtn)
        
        let redoGesture = UITapGestureRecognizer(target: self, action: #selector(redoHandler))
        redoBtn.addGestureRecognizer(redoGesture)
        let undoGesture = UITapGestureRecognizer(target: self, action: #selector(undoHandler))
        undoBtn.addGestureRecognizer(undoGesture)
        
        let optimizeGesture = UITapGestureRecognizer(target: self, action: #selector(autoButtonHandler))
        autoButton.addGestureRecognizer(optimizeGesture)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setConstraints()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItems = nil
        navigationItem.rightBarButtonItems = nil
        navigationItem.hidesBackButton = false
        let rightBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveHandler))
        navigationItem.rightBarButtonItem = rightBtn
        if let name = itinerary?.name {
            navigationItem.title = name
        } else {
            let title = "Trip on " + DateTimeTool.fromFormatThreeToFormatTwo(date: (itinerary?.time)!)
            navigationItem.title = title
            itinerary?.name = title
        }
    }
    
    func setConstraints() {
        listBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 40))
            make.top.equalTo(filterBtn.snp.bottom).offset(Scale.scaleY(y: 10))
//            make.trailing.equalTo(Scale.scaleX(x: -16))
            make.centerX.equalTo(filterBtn)
        }
        listBtnInside.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 15))
            make.center.equalToSuperview()
        }
        itemView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.leading.equalToSuperview().offset(Scale.scaleX(x: 16))
            make.trailing.equalToSuperview().offset(Scale.scaleX(x: -16))
            make.height.equalTo(Scale.scaleY(y: 106))
        }
        avatarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Scale.scaleY(y: 5))
            make.bottom.equalToSuperview().offset(Scale.scaleY(y: -5))
            make.leading.equalToSuperview().offset(Scale.scaleX(x: 5))
            make.width.equalTo(avatarView.snp.height)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(Scale.scaleX(x: 16))
            make.trailing.equalToSuperview().offset(Scale.scaleX(x: -16))
            make.top.equalToSuperview().offset(Scale.scaleY(y: 10))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)//.offset(Scale.scaleY(y: <#T##CGFloat#>))
            make.trailing.equalTo(nameLabel)
        }
        playView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.height.width.equalTo(Scale.scaleY(y: 16))
            make.bottom.equalTo(reviewView.snp.top).offset(Scale.scaleY(y: -10))
        }
        playLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(reviewLabel)
            make.trailing.equalTo(reviewLabel)
            make.centerY.equalTo(playView)
        }
        reviewView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.height.width.equalTo(Scale.scaleY(y: 16))
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
        reviewLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(reviewView)
            make.leading.equalTo(reviewView.snp.trailing).offset(Scale.scaleX(x: 8))
            make.trailing.equalTo(nameLabel)
        }
        budgetLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 30))
            make.width.equalTo(Scale.scaleX(x: 60))
            make.top.equalTo(searchView.snp.bottom).offset(Scale.scaleY(y: 8))
        }
        
        autoButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.trailing.equalTo(-Scale.scaleX(x: 16))
            make.width.height.equalTo(Scale.scaleY(y: 40))
        }
        autoButtonInside.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 21.8))
        }
        redoBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(autoButton)
            make.width.height.equalTo(autoButton)
            make.leading.equalTo(undoBtn.snp.trailing).offset(Scale.scaleX(x: 8))
        }
        redoBtnInside.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 15))
        }
        undoBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(autoButton)
            make.width.height.equalTo(autoButton)
            make.leading.equalTo(Scale.scaleX(x: 16))
        }
        
        undoBtnInside.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 15))
        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 39) + Scale.scaleY(y: 16) + Scale.scaleY(y: 106))
            make.top.equalTo(autoButton.snp.centerY)
        }
        expandBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(Scale.scaleX(x: 23))
            make.height.equalTo(Scale.scaleY(y: 25))
            make.top.equalTo(collectionView)//.offset(Scale.scaleY(y: 16))
        }
        
    }
    
    func addToHistory() {
        if currentIndex < history.count - 1 {
            history[currentIndex + 1] = itinerary!.makeCopy()
            history = Array(history[0...(currentIndex + 1)])
        } else {
            history.append(itinerary!.makeCopy())
        }
        if history.count == 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        checkHistory()
    }
    
    func redoHandler() {
        currentIndex += 1
        itinerary = history[currentIndex].makeCopy()
        debugPrint("the number of routes: \(itinerary?.routes?.count)")
        reloadData()
        checkHistory()
        updateBudget()
    }
    func undoHandler() {
        currentIndex -= 1
        itinerary = history[currentIndex].makeCopy()
        debugPrint("the number of routes: \(itinerary?.routes?.count)")
        reloadData()
        checkHistory()
        updateBudget()
    }
    
    func checkHistory() {
        if history.count == 0 {
            redoBtn.alpha = 0.36
            undoBtn.alpha = 0.36
            redoBtn.isUserInteractionEnabled = false
            undoBtn.isUserInteractionEnabled = false
        } else {
            if currentIndex == 0 {
                undoBtn.alpha = 0.36
                redoBtn.alpha = 0.9
                redoBtn.isUserInteractionEnabled = true
                undoBtn.isUserInteractionEnabled = false
            } else if currentIndex == history.count - 1 {
                undoBtn.alpha = 0.9
                redoBtn.alpha = 0.36
                redoBtn.isUserInteractionEnabled = false
                undoBtn.isUserInteractionEnabled = true
            } else {
                undoBtn.alpha = 0.9
                redoBtn.alpha = 0.9
                redoBtn.isUserInteractionEnabled = true
                undoBtn.isUserInteractionEnabled = true
            }
        }
    }

    //MARK: Handler
    func autoButtonHandler() {
        if (self.itinerary?.items)!.count > 2 {
            var start = Int()
            
            if startItem.id == nil {
                start = (self.itinerary?.items?[0].id)!
            } else {
                start = startItem.id!
            }
            let all = (self.itinerary?.items)!.map({ (item) -> Int in
                return item.id!
            })
            SVProgressHUD.show()
            debugPrint("going to optimize")
            HttpClient.sharedInstance.optimizeRoute(start: start, all: all, type: (itinerary?.tripType)!, budget: (itinerary?.budget)!, time: (itinerary?.time)!, completion: { (itinerary, isSuccess) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    var items = [FooyoItem]()
                    for each in (itinerary?.items)! {
                        let item = (self.itinerary?.items)!.first(where: { (n) -> Bool in
                            return each.id == n.id
                        })
                        item?.arrivingTime = each.arrivingTime
                        item?.visitingTime = each.visitingTime
                        items.append(item!)
                    }
                    self.itinerary?.items = items
                    self.reloadEditData()
                    self.addToHistory()
                    self.collectionView.reloadData()
//                    self.collectionViewTwo.reloadData()
                }
            })
        }
    }
    func saveHandler() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Save your trip", message: "Are you sure to save the following trip?", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = self.itinerary?.name
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.itinerary?.name = textField?.text
            var startId = Int()
            if self.startItem.id == nil {
                startId = (self.itinerary?.items?[0].id)!
            } else {
                startId = self.startItem.id!
            }
            let allId = (self.itinerary?.items)!.map({ (item) -> Int in
                return item.id!
            })
            SVProgressHUD.show()
            if let id = self.itinerary?.id {
//                HttpClient.sharedInstance.updateItinerary(id: id, allId: allId, name: (self.itinerary?.name)!, type: (self.itinerary?.tripType)!, completion: { (itinerary, isSuccess) in
//                    SVProgressHUD.dismiss()
//                    if isSuccess {
//                        if let itinerary = itinerary {
//                            Itinerary.update(itineraty: itinerary)
//                            Itinerary.sort()
//                            NotificationCenter.default.post(name:   NSNotification.Name(rawValue: Constants.Notification.updateItinerary.rawValue), object: itinerary)
//                            
//                            //                            self.navigationController?.popToRootViewController(animated: true)
//                            _ = self.navigationController?.popViewController(animated: true)
//                            //                            self.delegate?.editUpdateItinerary(itinerary: itinerary)
//                        }
//                    }
//                })
            } else {
                HttpClient.sharedInstance.createItinerary(startId: startId, allId: allId, start: (self.itinerary?.time)!, name: (self.itinerary?.name)!, budget: (self.itinerary?.budget)!, type: (self.itinerary?.tripType)!, completion: { (itinerary, isSuccess) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        if let itinerary = itinerary {
                            debugPrint("i got the itinerary")
//                            Itinerary.myItineraries.append(itinerary)
//                            Itinerary.sort()
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notification.newItinerary.rawValue), object: nil)
                            self.PostItinerarySavedNotification(plan: itinerary)
                        }
                        _ = self.dismiss(animated: true, completion: nil)
                    } else {
                        self.displayAlert(title: "Error", message: "Server error. Please try again later", complete: nil)
                    }
                })
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCollection() {
        UIView.animate(withDuration: 0.3, animations: {
            let height = -(Scale.scaleY(y: 40) / 2 + Scale.scaleY(y: 39) + Scale.scaleY(y: 16) + Scale.scaleY(y: 106))
            self.collectionView.transform = CGAffineTransform(translationX: 0, y: height)
            self.redoBtn.transform = CGAffineTransform(translationX: 0, y: height)
            self.undoBtn.transform = CGAffineTransform(translationX: 0, y: height)
            self.autoButton.transform = CGAffineTransform(translationX: 0, y: height)
            self.expandBtn.transform = CGAffineTransform(translationX: 0, y: height)
        })
    }
    
    func dismissCollection() {
        self.collectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        self.redoBtn.transform = CGAffineTransform(translationX: 0, y: 0)
        self.undoBtn.transform = CGAffineTransform(translationX: 0, y: 0)
        self.autoButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.expandBtn.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func showCollectionTwo() {
        UIView.animate(withDuration: 0.3, animations: {
            let height = -(Scale.scaleY(y: 44) / 2 + Scale.scaleY(y: 292))
//            self.collectionViewTwo.transform = CGAffineTransform(translationX: 0, y: height)
//            self.redoBtn.transform = CGAffineTransform(translationX: 0, y: height)
//            self.undoBtn.transform = CGAffineTransform(translationX: 0, y: height)
//            self.autoButton.transform = CGAffineTransform(translationX: 0, y: height)
//            self.filterBtn.transform = CGAffineTransform(translationX: 0, y: height)
//            self.listBtn.transform = CGAffineTransform(translationX: 0, y: height)
//            self.expandBtn.transform = CGAffineTransform(translationX: 0, y: height).rotated(by: CGFloat.pi)
        })
    }
    
    func dismissCollectionTwo() {
//        self.collectionViewTwo.transform = CGAffineTransform(translationX: 0, y: 0)
//        self.redoBtn.transform = CGAffineTransform(translationX: 0, y: 0)
//        self.undoBtn.transform = CGAffineTransform(translationX: 0, y: 0)
//        self.autoButton.transform = CGAffineTransform(translationX: 0, y: 0)
//        self.filterBtn.transform = CGAffineTransform(translationX: 0, y: 0)
//        self.expandBtn.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    func dismissItem() {
        self.itemView.transform = CGAffineTransform(translationX: 0, y: 0)
//        self.gpsBtn.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func showItem(item: FooyoItem) {
        self.displayedItem = item
        if let image = item.coverImages {
            let size = CGSize(width: Scale.scaleY(y: 106), height: Scale.scaleY(y: 106))
            avatarView.af_setImage(
                withURL: NSURL(string: image)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        }
        nameLabel.text = item.name
        tagLabel.text = item.getTag()
        playLabel.text = "Play time: " + item.getVisitingTime()
        reviewLabel.text = item.rating
        dismissItem()
        UIView.animate(withDuration: 0.3) {
            self.itemView.transform = CGAffineTransform(translationX: 0, y: -Scale.scaleY(y: 122))
//            self.gpsBtn.transform = CGAffineTransform(translationX: 0, y: -Scale.scaleY(y: 54))
//            self.listBtn.transform = CGAffineTransform(translationX: 0, y: -Scale.scaleY(y: 122))
        }
    }
    
    func reloadEditData() {
//        super.reloadData()
        showCollection()
        reloadMapIcons()
        self.collectionView.reloadData()
//        self.collectionViewTwo.reloadData()
    }
    
    //MARK: - Override
    override func clearMapView() {
        super.clearMapView()
        mapView.removeAnnotations(lines)
        plotted = false

    }
    
    override func reloadMapIcons() {
        super.reloadMapIcons()
        if let items = itinerary?.items {
            if items.count > 1 {
                if expanded {
                    mapView.setVisibleCoordinateBounds((itinerary?.getBounds())!, edgePadding: UIEdgeInsetsMake(120, 60, 320, 60), animated: true)
                } else {
                    mapView.setVisibleCoordinateBounds((itinerary?.getBounds())!, edgePadding: UIEdgeInsetsMake(120, 60, 190, 60), animated: true)
                }
            } else if items.count == 1 {
                mapView.setCenter(items[0].getCoor(), animated: true)
            }
        }
        debugPrint("plotted is \(plotted)")
        if !plotted {
            loadGeoJson()
            plotted = true
        }
    }
}

extension EditItineraryViewController {
    override func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        if let annotation = annotation as? MyCustomPointAnnotation {
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            //            let reuseIdentifier = (annotation.item?.category)!
            var reuseIdentifier = ""
            reuseIdentifier = (annotation.reuseId)!
            if annotation.item?.id == searchItem?.id {
                reuseIdentifier = FooyoConstants.AnnotationId.UserMarker.rawValue
            }
            if let items = self.itinerary?.items {
                for each in items {
                    if annotation.item?.id == each.id {
                        reuseIdentifier = FooyoConstants.AnnotationId.ItineraryItem.rawValue
                        break
                    }
                }
            }
            // For better performance, always try to reuse existing annotations.
            // If there’s no reusable annotation view available, initialize a new one.
            
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView {
//                annotationView.applyColor(annotation: annotation)
                return annotationView
            } else {
                var annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                if reuseIdentifier == FooyoConstants.AnnotationId.ItineraryItem.rawValue {
                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 25), height: Scale.scaleY(y: 25))
                    if let index = self.itinerary?.items?.index(of: annotation.item!) {
                        annotationView.indexLabel.text = "\(index)"
                    }
                } else if reuseIdentifier == FooyoConstants.AnnotationId.UserMarker.rawValue {
                    annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 17), height: Scale.scaleY(y: 48))
                } else {
                    if (annotation.item?.belongsToTheme(theme: itinerary?.theme))! {
                        annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 20), height: Scale.scaleY(y: 20))
                    } else {
                        annotationView.frame = CGRect(x: 0, y: 0, width: Scale.scaleY(y: 12), height: Scale.scaleY(y: 12))
                    }
                    annotationView.alpha = 0.6
                }
//                annotationView.applyColor(annotation: annotation)
                return annotationView
            }
        }
        return nil
    }
    
//    func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool) {
//        if let annotations = mapView.annotations {
//            if mapView.zoomLevel > 16 {
//                for annotation in annotations {
//                    if let annotation = annotation as? MyCustomPointAnnotation {
//                        if let view = mapView.view(for: annotation) as? CustomAnnotationView {
//                            var reuseIdentifier = ""
//                            if let id = annotation.reuseIdHigher {
//                                reuseIdentifier = id
//                            } else {
//                                reuseIdentifier = (annotation.reuseId)!
//                            }
//                            
//                            if reuseIdentifier == FooyoConstants.AnnotationId.ItineraryItem.rawValue || reuseIdentifier == Constants.AnnotationId.UserMarker.rawValue {
//                            } else {
//                                UIView.animate(withDuration: 0.5, animations: {
//                                    view.frame.size = CGSize(width: Scale.scaleY(y: 28), height: Scale.scaleY(y: 28))
//                                    view.alpha = 0.8
//                                })
//                            }
//                        }
//                    }
//                }
//            } else {
//                for annotation in annotations {
//                    if let annotation = annotation as? MyCustomPointAnnotation {
//                        if let view = mapView.view(for: annotation) as? CustomAnnotationView {
//                            var reuseIdentifier = ""
//                            if let id = annotation.reuseIdHigher {
//                                reuseIdentifier = id
//                            } else {
//                                reuseIdentifier = (annotation.reuseId)!
//                            }
//                            
//                            if reuseIdentifier == Constants.AnnotationId.ItineraryItem.rawValue || reuseIdentifier == Constants.AnnotationId.UserMarker.rawValue {
//                            } else {
//                                UIView.animate(withDuration: 0.5, animations: {
//                                    if (annotation.item?.belongsToTheme(theme: self.itinerary?.theme))! {
//                                        view.frame.size = CGSize(width: Scale.scaleY(y: 20), height: Scale.scaleY(y: 20))
//                                    } else {
//                                        view.frame.size = CGSize(width: Scale.scaleY(y: 15), height: Scale.scaleY(y: 15))
//                                    }
//                                    view.alpha = 0.8
//                                })
//                            }
//                        }
//                    }
//                }
//                
//            }
//        }
//    }
    
    override func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        // Only show callouts for `Hello world!` annotation
        if annotation.responds(to: #selector(getter: UIPreviewActionItem.title)) {
            // Instantiate and return our custom callout view
            if let anno = annotation as? MyCustomPointAnnotation {
                let view = CustomCalloutViewItinerary(representedObject: anno)
                if let item = anno.item {
                    view.inItinerary = false
                    if itinerary?.items != nil {
                        if (itinerary?.items?.contains(item))! {
                            view.inItinerary = true
                        }
                    }
                }
                view.userDelegate = self
                return view
            }
        }
        return nil
    }
    
    override func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        //        mapView.deselectAnnotation(annotation, animated: false)
        if let anno = annotation as? MyCustomPointAnnotation {
            if let item = anno.item {
                if let items = itinerary?.items {
                    if items.contains(item) {
                        //                        dismissItem()
                        if expanded {
                            showCollectionTwo()
                        } else {
                            showCollection()
                            if let index = items.index(of: item) {
                                collectionView.scrollToItem(at: IndexPath(item: index, section:0), at: .left, animated: true)
                            }
                        }
                    } else {
                        if expanded {
                            dismissCollectionTwo()
                        } else {
                            dismissCollection()
                        }
                        showItem(item: item)
                    }
                } else {
                    if expanded {
                        dismissCollectionTwo()
                    } else {
                        dismissCollection()
                    }
                    showItem(item: item)
                }
            }
        }
    }
    
    func loadGeoJson() {
        if let items = itinerary?.items {
            if items.count > 1 {
                DispatchQueue.global(qos: .background).async(execute: {
                    self.lines = [MGLPolylineFeature]()
                    for index in 0..<(items.count - 1) {
                        let one = items[index]
                        let two = items[index + 1]
                        let latOne = (one.coordinateLan)!
                        let lonOne = (one.coordinateLon)!
                        let latTwo = (two.coordinateLan)!
                        let lonTwo = (two.coordinateLon)!
                        let list = [[latOne, lonOne],[latTwo, lonTwo]]
                        let line = self.getLine(locations: list)
                        self.lines.append(line)
                    }
                    debugPrint("number of lines: \(self.lines.count)")
                    DispatchQueue.main.async(execute: {
                        // Unowned reference to self to prevent retain cycle
                        [unowned self] in
                        self.drawPolyline(lines: self.lines)
                    })
                })
            }
        }
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
    func getLine(locations: [[Double]]) -> MGLPolylineFeature {
        var coordinates: [CLLocationCoordinate2D] = []
        
        for location in locations {
            let coordinate = CLLocationCoordinate2D(latitude: location[0], longitude: location[1])
            coordinates.append(coordinate)
        }
        return MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))
    }
//
    func updateNavigationInformation(fromAdd: Bool = false) {
        var start = Int()
        if startItem.id == nil {
            start = (self.itinerary?.items?[0].id)!
        } else {
            start = startItem.id!
        }
        let all = (self.itinerary?.items)!.map({ (item) -> Int in
            return item.id!
        })
        HttpClient.sharedInstance.optimizeRoute(start: start, all: all, keep: true, type: (itinerary?.tripType)!, budget: (itinerary?.budget)!, time: (itinerary?.time)!, completion: { (itinerary, isSuccess) in
            if isSuccess {
                if fromAdd {
                    if let warnings = itinerary?.warnings {
                        if !warnings.isEmpty {
                            for each in warnings {
                                if (each.contains("will be closed on the day")) {
                                    self.displayAlert(title: "Reminder", message: each, complete: nil)
                                } else if each.contains("budget is lower") && !self.ignoreBudget {
                                    let alertController = UIAlertController(title: "Reminder", message: each, preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Don't remind me again", style: .default, handler: { (action) in
                                        self.ignoreBudget = true
                                    }))
                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                } else if (each.contains("too long") || each.contains("estimated visiting time ")) && !self.ignoreTime {
                                    let alertController = UIAlertController(title: "Reminder", message: each, preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Don't remind me again", style: .default, handler: { (action) in
                                        self.ignoreTime = true
                                    }))
                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                }// else
                            }
                            
                        }
                    }
                }
                
                if let routes = itinerary?.routes {
                    self.itinerary?.routes = routes
                }
                if let items = itinerary?.items {
                    for index in 0..<(items.count) {
                        self.itinerary?.items?[index].arrivingTime = items[index].arrivingTime
                    }
                }
                self.collectionView.reloadData()
//                self.collectionViewTwo.reloadData()
//                if self.newItem != nil && self.newItemFirst {
//                    debugPrint("i am scrolling")
//                    self.newItemFirst = false
//                    self.collectionViewTwo.scrollToItem(at: IndexPath(row: (self.itinerary?.items?.count)! - 1, section: 0), at: .centeredVertically, animated: true)
//                }
                self.addToHistory()
            }
            
        })
    }
}

extension EditItineraryViewController: CustomCalloutViewItineraryDelegate {
    func updateBudget() {
        if let items = self.itinerary?.items {
            var budget: Double = 0
            for each in items {
                if let price = each.budget {
                    budget += price
                }
            }
            budgetLabel.text = "$\(Int(budget))"
            if budget > (self.itinerary?.budget)! {
                budgetLabel.backgroundColor = UIColor.ospSentosaRed
            } else {
                budgetLabel.backgroundColor = UIColor.ospSentosaGreen
            }
        }
    }
    func didTapAdd(item: FooyoItem) {
        if itinerary?.items == nil {
            itinerary?.items = [item]
            startItem = item
        } else {
            itinerary?.items?.append(item)
        }
        let count = (itinerary?.items?.count)!
        if count == 1 {
            item.arrivingTime = DateTimeTool.fromDateToFormatThree(date: timeNow)
        }
        reloadEditData()
        if count > 1 {
            updateNavigationInformation(fromAdd: true)
        } else {
            addToHistory()
        }
        updateBudget()
        
    }
    func didTapRemove(item: FooyoItem) {
        let index = itinerary?.items?.index(of: item)
        itinerary?.items?.remove(at: index!)
        if (itinerary?.items?.isEmpty)! {
            itinerary?.items = nil
        } else {
            itinerary?.routes?.removeLast()
        }
        if let count = itinerary?.items?.count {
            if count == 1 {
                item.arrivingTime = DateTimeTool.fromDateToFormatThree(date: timeNow)
            }
        }
        reloadMapIcons()
//        if let count = itinerary?.items?.count {
//            if count > 1 {
//                autoButtonHandler()
//                //                updateNavigationInformation()
//            } else {
//                addToHistory()
//            }
//        } else {
//            addToHistory()
//        }
        updateBudget()
        
    }
    func didTapStart(item: FooyoItem) {
//        if itinerary?.items == nil {
//            itinerary?.items = [item]
//        } else {
//            if (itinerary?.items)!.contains(item) {
//            } else {
//                itinerary?.items?.append(item)
//            }
//        }
//        let count = (itinerary?.items?.count)!
//        if count == 1 {
//            item.arrivingTime = DateTimeTool.fromDateToFormatThree(date: timeNow)
//        }
//        startItem = item
//        reloadData()
//        if count > 1 {
//            autoButtonHandler()
//        } else {
//            addToHistory()
//        }
//        //        addToHistory()
    }
    
    
    
    func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.itemView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}

extension EditItineraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = itinerary?.items {
            return items.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItineraryMapCollectionViewCell.reuseIdentifier, for: indexPath) as! ItineraryMapCollectionViewCell
//            cell.delegate = self
            let item = (itinerary?.items)![indexPath.row]
            if let count = itinerary?.routes?.count {
                if indexPath.row < count {
                    let route = itinerary?.routes?[indexPath.row]
                    route?.startItem = itinerary?.items?[indexPath.row]
                    route?.endItem = itinerary?.items?[indexPath.row + 1]
                    cell.configureWith(item: item, route: route, isLowBudgetVisiting: ((itinerary?.budget)! <= 100 && (itinerary?.tripType)! == FooyoConstants.tripType.FullDay.rawValue))
                    return cell
                }
            }
            cell.configureWith(item: item, isLowBudgetVisiting: ((itinerary?.budget)! <= 100 && (itinerary?.tripType)! == FooyoConstants.tripType.FullDay.rawValue))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItineraryEditViewTwoCollectionViewCell.reuseIdentifier, for: indexPath) as! ItineraryEditViewTwoCollectionViewCell
            let item = (itinerary?.items)![indexPath.row]
            cell.configureWith(item: item, isLowBudgetVisiting: ((itinerary?.budget)! <= 100 && (itinerary?.tripType)! == FooyoConstants.tripType.FullDay.rawValue))
            cell.deHighlight()
            //            if indexPath.row == (itinerary?.items?.count)! - 1 {
            //                if newItemFirst {
            //                    newItemFirst = false
            //                }
            //            }
//            if item.id == newItem?.id {
//                cell.highlight()
//            } else {
//                cell.deHighlight()
//            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
//        gotoItemDetail(id: (itinerary?.items?[indexPath.row].id)!, from: .FromItineraryEditMap)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    //    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    //        debugPrint("go ahead")
    //    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            if viewMode == Constants.ViewMode.Map && expanded == false {
//                let x = collectionView.contentOffset.x
//                var num = floor(x / (Scale.scaleX(x: 330) + Scale.scaleX(x: 16)))
//                let reminder = x - num * (Scale.scaleX(x: 330) + Scale.scaleX(x: 16))
//                if reminder >= (Scale.scaleX(x: 330) + Scale.scaleX(x: 16)) / 2 {
//                    num += 1
//                }
//                
//                let selectedItem = Int(num)
//                collectionView.scrollToItem(at: IndexPath(item: selectedItem, section: 0), at: .left, animated: true)
//                for each in itineraryAnnotations {
//                    if each.index == selectedItem {
//                        mapView.selectAnnotation(each, animated: true)
//                        return
//                    }
//                }
//            }
//        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        debugPrint("scrollViewDidEndDecelerating")
//        if viewMode == Constants.ViewMode.Map && expanded == false  {
//            let x = collectionView.contentOffset.x
//            var num = floor(x / (Scale.scaleX(x: 330) + Scale.scaleX(x: 16)))
//            let reminder = x - num * (Scale.scaleX(x: 330) + Scale.scaleX(x: 16))
//            if reminder >= (Scale.scaleX(x: 330) + Scale.scaleX(x: 16)) / 2 {
//                num += 1
//            }
//            let selectedItem = Int(num)
//            debugPrint(x)
//            debugPrint(reminder)
//            debugPrint(num)
//            debugPrint(selectedItem)
//            collectionView.scrollToItem(at: IndexPath(item: selectedItem, section: 0), at: .left, animated: true)
//            for each in itineraryAnnotations {
//                if each.index == selectedItem {
//                    mapView.selectAnnotation(each, animated: true)
//                    return
//                }
//            }
//        }
    }
}
