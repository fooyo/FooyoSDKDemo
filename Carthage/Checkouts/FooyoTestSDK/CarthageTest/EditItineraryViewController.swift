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
//import RAReorderableLayout
import SVProgressHUD
//import DateToolsSwift

//protocol EditItineraryViewControllerDelegate: class {
//    func fooyoItinerryViewController(didSelectInformationWindow index: FooyoIndex)
//}

class EditItineraryViewController: FooyoBaseMapViewController {
//    public weak var delegate: EditItineraryViewControllerDelegate?

    fileprivate var firstTimeLoad = true
    fileprivate var homePage: FooyoConstants.PageSource = .FromAddToPlan
    var isDisplayMode: Bool = true
    
    var startItem = FooyoItem()
    var timeNow = Date()
    var ignoreBudget = false
    var ignoreTime = false
    
    var viewMode = FooyoConstants.ViewMode.Map
    
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
        layout.sectionInset = UIEdgeInsets(top: Scale.scaleY(y: 34), left: 0, bottom: Scale.scaleY(y: 16), right: Scale.scaleX(x: 16))
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - Scale.scaleX(x: 20), height: Scale.scaleY(y: 106))
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: Scale.scaleY(y: 150)), collectionViewLayout: layout)
        t.register(ItineraryMapCollectionViewCell.self, forCellWithReuseIdentifier: ItineraryMapCollectionViewCell.reuseIdentifier)
        t.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        t.alwaysBounceHorizontal = true
        t.alwaysBounceVertical = false
        return t
    }()
    
    var collectionViewTwo: UICollectionView! = {
        let layout = RAReorderableLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: Scale.scaleX(x: 15), bottom: Scale.scaleY(y: 15), right: Scale.scaleX(x: 15))
        let size = (FooyoConstants.mainWidth - 4 * Scale.scaleX(x: 15)) / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = Scale.scaleX(x: 15)
        layout.minimumLineSpacing = Scale.scaleX(x: 15)
        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: Scale.scaleY(y: 292)), collectionViewLayout: layout)
        t.register(ItineraryEditViewTwoCollectionViewCell.self, forCellWithReuseIdentifier: ItineraryEditViewTwoCollectionViewCell.reuseIdentifier)

        t.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        t.alwaysBounceHorizontal = false
        t.alwaysBounceVertical = true
        return t
    }()
    
    var collectionViewTwoUpper: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        return t
    }()
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
    
    fileprivate var allBusView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
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
        t.applyBundleImage(name: "general_uparrow", replaceColor: UIColor.ospSentosaBlue)
        return t
    }()
    
    var history = [FooyoItinerary]()
    var currentIndex = 0

    // MARK: - Life Cycle
    init(itinerary: FooyoItinerary, isDisplay: Bool = false, homePage: FooyoConstants.PageSource) {
        super.init(hideTheDefaultNavigationBar: false)
//        self.itinerary = itinerary.makeCopy()
        self.itinerary = itinerary
        self.isDisplayMode = isDisplay
        self.homePage = homePage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("i am view loading")
        debugPrint(itinerary?.items?.count)
        debugPrint(itinerary?.routes?.count)
        NotificationCenter.default.addObserver(self, selector: #selector(getIndexFromBase(notification:)), name: FooyoConstants.notifications.FooyoGetIndexFromBase, object: nil)

        if let items = self.itinerary?.items, let routes = self.itinerary?.routes {
            if items.count != routes.count + 1 {
                checkHistory()
                updateNavigationInformation()
            } else {
                addToHistory()
            }
        } else {
            if self.itinerary?.items != nil && self.itinerary?.routes == nil {
                checkHistory()
                updateNavigationInformation()
            } else {
                addToHistory()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addItem(notification:)), name: FooyoConstants.notifications.FooyoItineraryAddItem, object: nil)
        
        if itinerary?.tripType == FooyoConstants.tripType.HalfDayAfternoon.rawValue {
            timeNow = DateTimeTool.fromFormatOneToDate("12:30")
        } else {
            timeNow = DateTimeTool.fromFormatOneToDate("09:00")
        }
        
        goBtn.isHidden = true
//        gpsBtn.isHidden = true
        setupNavigationBar()
        view.addSubview(listBtn)
        listBtn.addSubview(listBtnInside)
        view.addSubview(itemView)
        let itemViewGesture = UITapGestureRecognizer(target: self, action: #selector(itemViewGestureHandler))
        itemView.addGestureRecognizer(itemViewGesture)
        itemView.addSubview(avatarView)
        itemView.addSubview(nameLabel)
        itemView.addSubview(tagLabel)
        itemView.addSubview(reviewView)
        itemView.addSubview(reviewLabel)
        itemView.addSubview(playView)
        itemView.addSubview(playLabel)
        itemView.addSubview(allBusView)
        view.addSubview(budgetLabel)
        view.addSubview(collectionView)
        view.addSubview(collectionViewTwo)
        view.addSubview(collectionViewTwoUpper)

        view.addSubview(autoButton)
        autoButton.addSubview(autoButtonInside)
        view.addSubview(redoBtn)
        redoBtn.addSubview(redoBtnInside)
        view.addSubview(undoBtn)
        undoBtn.addSubview(undoBtnInside)
        view.addSubview(expandBtn)
        let expandGesture = UITapGestureRecognizer(target: self, action: #selector(expandHandler))
        expandBtn.addGestureRecognizer(expandGesture)

        let listGesture = UITapGestureRecognizer(target: self, action: #selector(listHandler))
        listBtn.addGestureRecognizer(listGesture)
        let redoGesture = UITapGestureRecognizer(target: self, action: #selector(redoHandler))
        redoBtn.addGestureRecognizer(redoGesture)
        let undoGesture = UITapGestureRecognizer(target: self, action: #selector(undoHandler))
        undoBtn.addGestureRecognizer(undoGesture)
        
        let optimizeGesture = UITapGestureRecognizer(target: self, action: #selector(autoButtonHandler))
        autoButton.addGestureRecognizer(optimizeGesture)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewTwo.delegate = self
        collectionViewTwo.dataSource = self
        setConstraints()
        if itinerary?.items?.count != nil {
            showCollection()
            updateBudget()
        }
        checkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.navigationBar.isHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.isHidden = false
            }
        }
        if self.navigationController?.isNavigationBarHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.isNavigationBarHidden = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstTimeLoad {
            firstTimeLoad = false
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
        }
    }
    
    func itemViewGestureHandler() {
        if let item = displayedItem {
            if homePage == FooyoConstants.PageSource.FromMyPlan {
                if isDisplayMode {
                    item.isInEditMode = false
                } else {
                    item.isInEditMode = true
                }
                PostMyPlanItemSelectionNotification(item: item)
            } else if homePage == FooyoConstants.PageSource.FromAddToPlan {
                PostAddToPlanItemSelectionNotification(item: item)
            }
        }
    }
    func checkMode() {
        if isDisplayMode {
//            redoBtn.alpha = 0
//            undoBtn.alpha = 0
//            autoButton.alpha = 0
            listBtn.alpha = 0
            searchView.alpha = 0
            gpsBtn.alpha = 1
            filterBtn.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -50))
            budgetLabel.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -50))
        }
    }
    
    func updateMode() {
        isDisplayMode = !isDisplayMode
        for each in mapView.selectedAnnotations {
            mapView.deselectAnnotation(each, animated: true)
        }
//        mapView.deselectAnnotation(<#T##annotation: MGLAnnotation?##MGLAnnotation?#>, animated: <#T##Bool#>)
        setupNavigationBar()
        if isDisplayMode {
            UIView.animate(withDuration: 0.3, animations: {
                self.redoBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                self.undoBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                self.autoButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.filterBtn.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -50))
                self.budgetLabel.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -50))
                self.searchView.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -50))
//                self.redoBtn.alpha = 0
//                self.undoBtn.alpha = 0
//                self.autoButton.alpha = 0
                self.listBtn.alpha = 0
                self.searchView.alpha = 0
                self.gpsBtn.alpha = 1
            })
            if itinerary?.items != nil {
                showCollection()
            } else {
                dismissBothCollection()
            }
        } else {
            if expanded {
                UIView.animate(withDuration: 0.3, animations: {
                    let height = -(Scale.scaleY(y: 40) / 2 + Scale.scaleY(y: 292))
                    self.redoBtn.transform = CGAffineTransform(translationX: 0, y: height)
                    self.undoBtn.transform = CGAffineTransform(translationX: 0, y: height)
                    self.autoButton.transform = CGAffineTransform(translationX: 0, y: height)
                    self.filterBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.budgetLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.searchView.transform = CGAffineTransform(translationX: 0, y: 0)
//                    self.redoBtn.alpha = 1
//                    self.undoBtn.alpha = 1
//                    self.autoButton.alpha = 1
                    self.listBtn.alpha = 1
                    self.searchView.alpha = 1
                    self.gpsBtn.alpha = 0
                })
                debugPrint(items)
                if itinerary?.items != nil {
                    showCollectionTwo()
                } else {
                    dismissBothCollection()
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    let height = -(Scale.scaleY(y: 40) / 2 + Scale.scaleY(y: 150))
                    self.redoBtn.transform = CGAffineTransform(translationX: 0, y: height)
                    self.undoBtn.transform = CGAffineTransform(translationX: 0, y: height)
                    self.autoButton.transform = CGAffineTransform(translationX: 0, y: height)
                    self.filterBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.budgetLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.searchView.transform = CGAffineTransform(translationX: 0, y: 0)
//                    self.redoBtn.alpha = 1
//                    self.undoBtn.alpha = 1
//                    self.autoButton.alpha = 1
                    self.listBtn.alpha = 1
                    self.searchView.alpha = 1
                    self.gpsBtn.alpha = 0
                })
                if itinerary?.items != nil {
                    showCollection()
                } else {
                    dismissBothCollection()
                }
            }
        }
    }
    func setupNavigationBar() {
        navigationItem.leftBarButtonItems = nil
        navigationItem.rightBarButtonItems = nil
        if homePage == .FromAddToPlan {
            navigationItem.title = itinerary?.name
            let rightBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveHandler))
            navigationItem.rightBarButtonItem = rightBtn
        } else if homePage == .FromMyPlan {
            if isDisplayMode {
                navigationItem.title = itinerary?.name
                let switchButton = UIBarButtonItem(image: UIImage.getBundleImage(name: "plan_newlistview"),  style: .plain, target: self, action: #selector(listModeHandler))
                let editButton = UIBarButtonItem(image: UIImage.getBundleImage(name: "plan_neweditview"),  style: .plain, target: self, action: #selector(editHandler))
                navigationItem.rightBarButtonItems = [editButton, switchButton]
            } else {
                let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler))
                navigationItem.leftBarButtonItem = cancelBtn
                
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
        }
    }
    
    func editHandler() {
        //        let _ = gotoEditItinerary(itinerary: itinerary!)
        updateMode()
    }
    
    func cancelHandler() {
        updateMode()
    }
    func listModeHandler() {
        let vc = DisplayItineraryListViewController(itinerary: itinerary!)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setConstraints() {
        listBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 40))
            make.top.equalTo(filterBtn.snp.bottom).offset(Scale.scaleY(y: 10))
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
        allBusView.snp.makeConstraints { (make) in
            make.leading.equalTo(playView)
            make.top.equalTo(playView)
            make.trailing.equalTo(playView)
            make.bottom.equalTo(reviewView)
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
        gpsBtn.snp.remakeConstraints { (make) in
            make.height.width.equalTo(autoButton)
            make.leading.equalTo(autoButton)
            make.bottom.equalTo(autoButton.snp.top).offset(Scale.scaleY(y: -10))
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
            make.height.equalTo(Scale.scaleY(y: 150))
            make.top.equalTo(autoButton.snp.centerY)
        }
        collectionViewTwoUpper.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(autoButton.snp.centerY)
            make.bottom.equalTo(collectionViewTwo.snp.top)
        }
        collectionViewTwo.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 292))
            make.top.equalTo(autoButton.snp.centerY).offset(Scale.scaleY(y: 34))
        }

        expandBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(Scale.scaleX(x: 30))
            make.height.equalTo(Scale.scaleY(y: 30))
            make.top.equalTo(collectionView)//.offset(Scale.scaleY(y: 16))
        }
    }
    
    func addToHistory() {
        debugPrint("addToHistory")
        debugPrint(currentIndex)
        debugPrint(history.count)
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
        reloadEditData()
        checkHistory()
        updateBudget()
    }
    
    func undoHandler() {
        currentIndex -= 1
        itinerary = history[currentIndex].makeCopy()
        reloadEditData()
        checkHistory()
        updateBudget()
    }
    
    func listHandler() {
        if let itinerary = itinerary {
            let vc = NewEditItineraryListViewController(plan: itinerary, homePage: homePage)
//            let vc = EditItineraryListViewController(plan: itinerary)
//            vc.sourceVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkHistory() {
        debugPrint("i am checking history")
        debugPrint(history.count)
        if history.count == 0 || history.count == 1 {
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
    func getIndexFromBase(notification: Notification) {
        if let index = notification.object as? FooyoIndex {
            let items = FooyoItem.findMatch(index: index)
            if let items = items {
                if let itineraryItems = itinerary?.items {
                    for each in items {
                        for itineraryItem in itineraryItems {
                            if each.id == itineraryItem.id {
                                displayAlert(title: "Reminder", message: "The selected location is already in the plan.", complete: nil)
                                return
                            }
                        }
                    }
                }
                if itinerary?.items == nil {
                    itinerary?.items = items
                    startItem = items[0]
                } else {
                    itinerary?.items?.append(contentsOf: items)
                }
                let count = (itinerary?.items?.count)!
                if count == 1 {
                    items[0].arrivingTime = DateTimeTool.fromDateToFormatThree(date: timeNow)
                }
                reloadEditData()
                if count > 1 {
                    updateNavigationInformation(fromAdd: true)
                } else {
                    addToHistory()
                }
                updateBudget()
            } else {
                displayAlert(title: "Internal Error", message: "There's no matching location with the given FooyoIndex", complete: nil)
            }
        }
    }
    
    func addItem(notification: Notification) {
        if let item = notification.object as? FooyoItem {
            let anno = allAnnotations.first(where: { (anno) -> Bool in
                return anno.item?.id == item.id
            })
            mapView.setCenter(item.getCoor(), zoomLevel: 14, direction: 0, animated: true, completionHandler: {
                self.mapView.selectAnnotation(anno!, animated: true)
            })

//            if itinerary?.items?.contains(item) == true {
//                if anno != nil {
//                    mapView.selectAnnotation(anno!, animated: true)
//                }
//            } else {
//                if anno != nil {
//                    didTapAdd(item: item, annotation: anno!)
//                }
//            }
        }
    }
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
                    self.collectionViewTwo.reloadData()
                }
            })
        }
    }
    func saveHandler() {
        
        guard itinerary?.items != nil else {
            displayAlert(title: "Warning", message: "You must add at least one location into your day plan before saving.", complete: nil)
            return
        }
        
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
                HttpClient.sharedInstance.updateItinerary(id: id, allId: allId, name: (self.itinerary?.name)!, type: (self.itinerary?.tripType)!, completion: { (itinerary, isSuccess) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        if let itinerary = itinerary {
                            FooyoItinerary.update(itineraty: itinerary)
                            FooyoItinerary.sort()
                            self.PostItinerarySavedNotification(plan: itinerary)
                            SVProgressHUD.showSuccess(withStatus: "Your itinerary has been updated successfully.")
                            if self.homePage == FooyoConstants.PageSource.FromMyPlan {
                                self.updateMode()
                            } else if self.homePage == FooyoConstants.PageSource.FromAddToPlan {
                                _ = self.navigationController?.popViewController(animated: true)
                            }
//                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            } else {
                HttpClient.sharedInstance.createItinerary(startId: startId, allId: allId, start: (self.itinerary?.time)!, name: (self.itinerary?.name)!, budget: (self.itinerary?.budget)!, type: (self.itinerary?.tripType)!, completion: { (itinerary, isSuccess) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        if let itinerary = itinerary {
                            debugPrint("i got the itinerary")
//                            Itinerary.myItineraries.append(itinerary)
//                            Itinerary.sort()
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notification.newItinerary.rawValue), object: nil)
                            if FooyoItinerary.myItineraries != nil {
                                (FooyoItinerary.myItineraries)!.append(itinerary)
                            } else {
                                FooyoItinerary.myItineraries = [itinerary]
                            }
                            FooyoItinerary.sort()
                            self.PostItinerarySavedNotification(plan: itinerary)
                            SVProgressHUD.showSuccess(withStatus: "Your itinerary has been created successfully.")
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
        dismissItem()
        UIView.animate(withDuration: 0.3, animations: {
            let height = -(Scale.scaleY(y: 40) / 2 + Scale.scaleY(y: 150))
            self.collectionView.transform = CGAffineTransform(translationX: 0, y: height)
            if self.isDisplayMode {
                self.gpsBtn.transform = CGAffineTransform(translationX: 0, y: height)
            } else {
                self.redoBtn.transform = CGAffineTransform(translationX: 0, y: height)
                self.undoBtn.transform = CGAffineTransform(translationX: 0, y: height)
                self.autoButton.transform = CGAffineTransform(translationX: 0, y: height)
            }
            self.expandBtn.transform = CGAffineTransform(translationX: 0, y: height)
            
            self.collectionViewTwo.transform = CGAffineTransform(translationX: 0, y: 0)
            self.collectionViewTwoUpper.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    func showCollectionTwo() {
        dismissItem()
        UIView.animate(withDuration: 0.3, animations: {
            let height = -(Scale.scaleY(y: 40) / 2 + Scale.scaleY(y: 292))
            self.collectionViewTwo.transform = CGAffineTransform(translationX: 0, y: height)
            self.collectionViewTwoUpper.transform = CGAffineTransform(translationX: 0, y: height)
            if self.isDisplayMode {
                self.gpsBtn.transform = CGAffineTransform(translationX: 0, y: height)
            } else {
                self.redoBtn.transform = CGAffineTransform(translationX: 0, y: height)
                self.undoBtn.transform = CGAffineTransform(translationX: 0, y: height)
                self.autoButton.transform = CGAffineTransform(translationX: 0, y: height)
            }
            self.expandBtn.transform = CGAffineTransform(translationX: 0, y: height).rotated(by: CGFloat.pi)
            
            self.collectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    func dismissBothCollection() {
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionViewTwo.transform = CGAffineTransform(translationX: 0, y: 0)
            self.collectionViewTwoUpper.transform = CGAffineTransform(translationX: 0, y: 0)
            self.collectionView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.redoBtn.transform = CGAffineTransform(translationX: 0, y: 0)
            self.undoBtn.transform = CGAffineTransform(translationX: 0, y: 0)
            self.autoButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.expandBtn.transform = CGAffineTransform(translationX: 0, y: 0)
        })
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
        switch (item.category?.name)! {
        case FooyoConstants.CategoryName.Attractions.rawValue, FooyoConstants.CategoryName.Events.rawValue, FooyoConstants.CategoryName.Trails.rawValue:
            playLabel.text = "Play time: " + item.getVisitingTime()
            reviewLabel.text = item.getRatingStr()
            playLabel.isHidden = false
            reviewLabel.isHidden = false
            reviewView.isHidden = false
            playView.isHidden = false
            allBusView.isHidden = true
        case FooyoConstants.CategoryName.Bus.rawValue:
            setupAllBusView(item: item)
            playLabel.isHidden = true
            reviewLabel.isHidden = true
            reviewView.isHidden = true
            playView.isHidden = true
            allBusView.isHidden = false
        default:
            allBusView.isHidden = true
            playLabel.isHidden = true
            reviewLabel.isHidden = true
            reviewView.isHidden = true
            playView.isHidden = true
        }
        dismissItem()
        dismissBothCollection()
        UIView.animate(withDuration: 0.3) {
            self.itemView.transform = CGAffineTransform(translationX: 0, y: -Scale.scaleY(y: 122))
//            self.gpsBtn.transform = CGAffineTransform(translationX: 0, y: -Scale.scaleY(y: 54))
//            self.listBtn.transform = CGAffineTransform(translationX: 0, y: -Scale.scaleY(y: 122))
        }
        
    }
    
    func setupAllBusView(item: FooyoItem) {
        for each in allBusView.subviews {
            each.snp.removeConstraints()
            each.removeFromSuperview()
        }
        var subBusViews = [UIView]()
        var subLabels = [UILabel]()
        var index = 0
        if let buses = item.buses {
            for each in buses {
                
                let busView = UILabel()
                busView.layer.cornerRadius = Scale.scaleY(y: 4)
                busView.clipsToBounds = true
                busView.textColor = .white
                busView.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 11))
                busView.text = each.name
                busView.textAlignment = .center
                
                switch (each.name)! {
                case "Bus A":
                    busView.backgroundColor = UIColor.busA
                    busView.textColor = .white
                case "Bus B":
                    busView.backgroundColor = UIColor.busB
                    busView.textColor = .white
                default:
                    break
                }
                let label = UILabel()
                label.attributedText = each.getArrivingStatus()
                
                allBusView.addSubview(busView)
                allBusView.addSubview(label)
                subBusViews.append(busView)
                subLabels.append(label)
                
                busView.snp.makeConstraints({ (make) in
                    make.leading.equalToSuperview()
                    make.width.equalTo(Scale.scaleX(x: 54))
                    make.height.equalTo(Scale.scaleY(y: 20))
                    if index == 0 {
                        make.top.equalToSuperview()
                    } else {
                        make.top.equalTo(subBusViews[index - 1].snp.bottom).offset(Scale.scaleY(y: 5))
                    }
                })
                label.snp.makeConstraints({ (make) in
                    make.leading.equalTo(busView.snp.trailing).offset(Scale.scaleX(x: 13))
                    make.centerY.equalTo(busView)
                })
                index += 1
            }
        }
    }
    func reloadEditData() {
        reloadMapIcons()
        if expanded {
            if itinerary?.items != nil {
                showCollectionTwo()
            } else {
                dismissBothCollection()
            }
        } else {
            if itinerary?.items != nil {
                showCollection()
            } else {
                dismissBothCollection()
            }
        }
        reloadCollections()
    }
    
    func reloadCollections() {
        self.collectionView.reloadData()
        self.collectionViewTwo.reloadData()
    }
    //MARK: - Override
    override func searchHandler() {
        gotoSearchPage(source: .FromItineraryEditMap, sourceVC: self)
    }
    
    override func clearMapView() {
        super.clearMapView()
        mapView.removeAnnotations(lines)
        plotted = false

    }
    
    override func reloadMapIcons() {
        super.reloadMapIcons()
//        if let items = itinerary?.items {
//            if items.count > 1 {
//                if expanded {
//                    mapView.setVisibleCoordinateBounds((itinerary?.getBounds())!, edgePadding: UIEdgeInsetsMake(120, 60, 320, 60), animated: true)
//                } else {
//                    mapView.setVisibleCoordinateBounds((itinerary?.getBounds())!, edgePadding: UIEdgeInsetsMake(120, 60, 190, 60), animated: true)
//                }
//            } else if items.count == 1 {
//                mapView.setCenter(items[0].getCoor(), animated: true)
//            }
//        }
        debugPrint("plotted is \(plotted)")
        if !plotted {
            loadGeoJson()
            plotted = true
        }
    }
    
    
//    func setupNavigationBar() {
//        
//    }
}

extension EditItineraryViewController {
//    override func mapviewcallout
    override func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
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
                    if isDisplayMode {
                        view.isEditable = false
                    } else {
                        if item.isEssential() {
                            view.isEditable = true
                        } else {
                            view.isEditable = false
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
    
    
    override func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        //        mapView.deselectAnnotation(annotation, animated: false)
        if let anno = annotation as? MyCustomPointAnnotation {
            if let item = anno.item {
                if let items = itinerary?.items {
                    if items.contains(item) {
                        if expanded {
                            showCollectionTwo()
                        } else {
                            showCollection()
                            if let index = items.index(of: item) {
                                collectionView.scrollToItem(at: IndexPath(item: index, section:0), at: .left, animated: true)
                            }
                        }
                    } else {
                        showItem(item: item)
                    }
                } else {
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
    func updateNavigationInformation(fromAdd: Bool = false, withSVP: Bool = false) {
        var start = Int()
        if startItem.id == nil {
            start = (self.itinerary?.items?[0].id)!
        } else {
            start = startItem.id!
        }
        let all = (self.itinerary?.items)!.map({ (item) -> Int in
            return item.id!
        })
        if withSVP {
            SVProgressHUD.show()
        }
        HttpClient.sharedInstance.optimizeRoute(start: start, all: all, keep: true, type: (itinerary?.tripType)!, budget: (itinerary?.budget)!, time: (itinerary?.time)!, completion: { (itinerary, isSuccess) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if fromAdd {
                    if let warnings = itinerary?.warnings {
                        if !warnings.isEmpty {
                            for each in warnings {
//                                if (each.contains("will be closed on the day")) {
//                                    self.displayAlert(title: "Reminder", message: each, complete: nil)
//                                } else if each.contains("budget is lower") && !self.ignoreBudget {
//                                    let alertController = UIAlertController(title: "Reminder", message: each, preferredStyle: .alert)
//                                    alertController.addAction(UIAlertAction(title: "Don't remind me again", style: .default, handler: { (action) in
//                                        self.ignoreBudget = true
//                                    }))
//                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                                    self.present(alertController, animated: true, completion: nil)
//                                } else if (each.contains("too long") || each.contains("estimated visiting time ")) && !self.ignoreTime {
//                                    let alertController = UIAlertController(title: "Reminder", message: each, preferredStyle: .alert)
//                                    alertController.addAction(UIAlertAction(title: "Don't remind me again", style: .default, handler: { (action) in
//                                        self.ignoreTime = true
//                                    }))
//                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                                    self.present(alertController, animated: true, completion: nil)
//                                }
                                if (each.contains("will be closed on the day")) {
                                    self.displayAlert(title: "Reminder", message: each, complete: nil)
                                } else if (each.contains("too long") || each.contains("estimated visiting time ")) && !self.ignoreTime {
                                    let alertController = UIAlertController(title: "Reminder", message: each, preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Don't remind me again", style: .default, handler: { (action) in
                                        self.ignoreTime = true
                                    }))
                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                
                                
                                
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
//                self.itinerary?.items = itinerary?.items
                for each in (itinerary?.items)! {
                    debugPrint(each.arrivingTime)
                }
                
                self.collectionViewTwo.reloadData()
                self.collectionView.reloadData()
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
        var budget: Double = 0
        if let items = self.itinerary?.items {
            for each in items {
                if let price = each.budget {
                    budget += price
                }
            }
        }
        budgetLabel.text = "$\(Int(budget))"
        if budget > (self.itinerary?.budget)! {
            budgetLabel.backgroundColor = UIColor.ospSentosaRed
            if self.ignoreBudget == false {
                let alertController = UIAlertController(title: "Reminder", message: "The estimated cost is higher than your budget.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Don't remind me again", style: .default, handler: { (action) in
                    self.ignoreBudget = true
                }))
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            budgetLabel.backgroundColor = UIColor.ospSentosaGreen
        }
    }
    func didTapAdd(item: FooyoItem, annotation: MyCustomPointAnnotation) {
        var items = [FooyoItem]()
        if item.isNonLinearHotspot() {
            items = item.findBrothers()
        } else {
            items = [item]
        }
        if itinerary?.items == nil {
            itinerary?.items = items
            startItem = items[0]
        } else {
            itinerary?.items?.append(contentsOf: items)
//            itinerary?.items?.append(item)
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
//        mapView.selectAnnotation(annotation, animated: true)
        
    }
    func didTapRemove(item: FooyoItem, annotation: MyCustomPointAnnotation) {
        let index = itinerary?.items?.index(of: item)
        itinerary?.items?.remove(at: index!)
        if (itinerary?.items?.isEmpty)! {
            itinerary?.items = nil
            dismissBothCollection()
        } else {
            itinerary?.routes?.removeLast()
        }
        if let count = itinerary?.items?.count {
            if count == 1 {
                item.arrivingTime = DateTimeTool.fromDateToFormatThree(date: timeNow)
            }
        }
        reloadEditData()
        if let count = itinerary?.items?.count {
            if count > 1 {
//                autoButtonHandler()
                updateNavigationInformation()
            } else {
                addToHistory()
            }
        } else {
            addToHistory()
        }
        updateBudget()
        
    }
    func didTapStart(item: FooyoItem, annotation: MyCustomPointAnnotation) {
        if itinerary?.items == nil {
            itinerary?.items = [item]
        } else {
            if (itinerary?.items)!.contains(item) {
            } else {
                itinerary?.items?.append(item)
            }
        }
        let count = (itinerary?.items?.count)!
        if count == 1 {
            item.arrivingTime = DateTimeTool.fromDateToFormatThree(date: timeNow)
        }
        startItem = item
        reloadEditData()
        if count > 1 {
            autoButtonHandler()
        } else {
            addToHistory()
        }
        
//        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.itemView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    func expandHandler() {
        expanded = !expanded
        if expanded == false {
            mapView.setVisibleCoordinateBounds((itinerary?.getBounds())!, edgePadding: UIEdgeInsetsMake(120, 60, 190, 60), animated: true)
            self.showCollection()
        } else {
            mapView.setVisibleCoordinateBounds((itinerary?.getBounds())!, edgePadding: UIEdgeInsetsMake(120, 60, 320, 60), animated: true)
            self.showCollectionTwo()
        }
    }
}

extension EditItineraryViewController: RAReorderableLayoutDataSource, RAReorderableLayoutDelegate {
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
        debugPrint("i am loading a collectionView")

        if collectionView == self.collectionView {
            debugPrint("i am loading a collectionView cell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItineraryMapCollectionViewCell.reuseIdentifier, for: indexPath) as! ItineraryMapCollectionViewCell
            cell.delegate = self
            let item = (itinerary?.items)![indexPath.row]
            if let count = itinerary?.routes?.count {
                if indexPath.row < count {
                    let route = itinerary?.routes?[indexPath.row]
                    route?.startItem = itinerary?.items?[indexPath.row]
                    route?.endItem = itinerary?.items?[indexPath.row + 1]
                    debugPrint("======")
                    debugPrint(route?.startItem?.name)
                    debugPrint(route?.endItem?.name)
                    debugPrint("----------")
                    cell.configureWith(item: item, route: route, isLowBudgetVisiting: ((itinerary?.budget)! <= 100 && (itinerary?.tripType)! == FooyoConstants.tripType.FullDay.rawValue))
                    return cell
                }
            }
            cell.configureWith(item: item, isLowBudgetVisiting: ((itinerary?.budget)! <= 100 && (itinerary?.tripType)! == FooyoConstants.tripType.FullDay.rawValue))
            return cell
        } else {
            debugPrint("i am loading a collectionViewTwo cell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItineraryEditViewTwoCollectionViewCell.reuseIdentifier, for: indexPath) as! ItineraryEditViewTwoCollectionViewCell
            let item = (itinerary?.items)![indexPath.row]
            debugPrint(item.arrivingTime)
            cell.configureWith(item: item, isLowBudgetVisiting: ((itinerary?.budget)! <= 100 && (itinerary?.tripType)! == FooyoConstants.tripType.FullDay.rawValue))
//            cell.deHighlight()
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
        if let items = itinerary?.items {
            let item = items[indexPath.row]
            if homePage == FooyoConstants.PageSource.FromMyPlan {
                if isDisplayMode {
                    item.isInEditMode = false
                } else {
                    item.isInEditMode = true
                }
                PostMyPlanItemSelectionNotification(item: item)
            } else if homePage == FooyoConstants.PageSource.FromAddToPlan {
                PostAddToPlanItemSelectionNotification(item: item)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if viewMode == FooyoConstants.ViewMode.Map && expanded == false {
                let x = collectionView.contentOffset.x
                var num = floor(x / (Scale.scaleX(x: 330) + Scale.scaleX(x: 16)))
                let reminder = x - num * (Scale.scaleX(x: 330) + Scale.scaleX(x: 16))
                if reminder >= (Scale.scaleX(x: 330) + Scale.scaleX(x: 16)) / 2 {
                    num += 1
                }
                
                let selectedItem = Int(num)
                collectionView.scrollToItem(at: IndexPath(item: selectedItem, section: 0), at: .left, animated: true)
                if let item = itinerary?.items?[selectedItem] {
                    for each in allAnnotations {
                        if each.item?.id == item.id {
                            mapView.selectAnnotation(each, animated: true)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if viewMode == FooyoConstants.ViewMode.Map && expanded == false  {
            let x = collectionView.contentOffset.x
            var num = floor(x / (Scale.scaleX(x: 330) + Scale.scaleX(x: 16)))
            let reminder = x - num * (Scale.scaleX(x: 330) + Scale.scaleX(x: 16))
            if reminder >= (Scale.scaleX(x: 330) + Scale.scaleX(x: 16)) / 2 {
                num += 1
            }
            let selectedItem = Int(num)
            collectionView.scrollToItem(at: IndexPath(item: selectedItem, section: 0), at: .left, animated: true)
            if let item = itinerary?.items?[selectedItem] {
                for each in allAnnotations {
                    if each.item?.id == item.id {
                        mapView.selectAnnotation(each, animated: true)
                        return
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, at: IndexPath, willMoveTo toIndexPath: IndexPath) {
        debugPrint("will move")
    }
    func collectionView(_ collectionView: UICollectionView, at: IndexPath, didMoveTo toIndexPath: IndexPath) {
        debugPrint("did move")

        if collectionView == collectionViewTwo {
            if let items = itinerary?.items {
                let item = items[at.item]
                itinerary?.items?.remove(at: at.item)
                itinerary?.items?.insert(item, at: toIndexPath.item)
            }
            reloadEditData()
            updateNavigationInformation()
        }
    }
}

extension EditItineraryViewController: DisplayItineraryListViewControllerDelegate {
    func displayItineraryListViewControllerUpdateTheMode() {
        self.updateMode()
    }
}

extension EditItineraryViewController: ItineraryMapCollectionViewCellDelegate {
    func didTapRoute(route: FooyoRoute) {
        var start: FooyoIndex?
        var end: FooyoIndex?
        if let item = route.startItem {
            let category = item.category?.name
            let one = item.levelOneId
            let two = item.levelTwoId
            start = FooyoIndex(category: category, levelOneId: one, levelTwoId: two)
        }
        if let item = route.endItem {
            let category = item.category?.name
            let one = item.levelOneId
            let two = item.levelTwoId
            end = FooyoIndex(category: category, levelOneId: one, levelTwoId: two)
        }
        let vc = FooyoNavigationViewController(startIndex: start, endIndex: end)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapNavigation(item: FooyoItem) {
        let category = item.category?.name
        let one = item.levelOneId
        let two = item.levelTwoId
        let index = FooyoIndex(category: category, levelOneId: one, levelTwoId: two)
        let vc = FooyoNavigationViewController(startIndex: nil, endIndex: index)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
