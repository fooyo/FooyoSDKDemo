//
//  AddToPlanViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 28/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SVProgressHUD
public protocol FooyoAddToPlanViewControllerDelegate: class {
    func fooyoAddToPlanViewController(didSelectInformationWindow index: FooyoIndex, isEditingAPlan: Bool)
}

public class FooyoAddToPlanViewController: UIViewController {
    public weak var delegate: FooyoAddToPlanViewControllerDelegate?
    fileprivate var items: [FooyoItem]?
    fileprivate var index: FooyoIndex?
    fileprivate var overlay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospOverlay
        t.isUserInteractionEnabled = true
        return t
    }()
    fileprivate var crossButton: UIButton! = {
        let t = UIButton()
        t.setImage(UIImage.getBundleImage(name: "basemap_cross"), for: .normal)
        t.backgroundColor = .white
        t.clipsToBounds = true
        t.layer.cornerRadius = (Scale.scaleY(y: 40)) / 2
        return t
    }()
    fileprivate var container: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.white
        t.layer.cornerRadius = 5
        t.clipsToBounds = true
        t.isUserInteractionEnabled = true
        return t
    }()
    fileprivate var containerOverlay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey10
        t.isUserInteractionEnabled = true
        return t
    }()
    
    fileprivate var inforLabel: UILabel! = {
        let t = UILabel()
        t.text = "Add To An Existing Plan"
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 18))
        t.textColor = UIColor.ospSentosaBlue
        t.textAlignment = .center
        return t
    }()
    
    fileprivate var newBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("CREATE A NEW PLAN", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.layer.cornerRadius = 20
        t.backgroundColor = UIColor.ospSentosaGreen
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var tableView: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .white
        t.separatorStyle = .singleLine
        t.separatorColor = UIColor.ospGrey50
        t.separatorInset = UIEdgeInsets.zero
        t.tableFooterView = UIView()
        t.register(ItinerarySmallTableViewCell.self, forCellReuseIdentifier: ItinerarySmallTableViewCell.reuseIdentifier)
        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        return t
    }()
    
    public init(index: FooyoIndex, userId: String) {
        super.init(nibName: nil, bundle: nil)
        self.index = index
        FooyoUser.currentUser.userId = userId
        items = FooyoItem.findMatch(index: index)
//        debugPrint("i am in the init")
//        debugPrint(index.category)
//        debugPrint(index.levelOneId)
//        debugPrint(items)
//        debugPrint(items?.count)
//        if items?.count == 0 {
//            debugPrint("Cannot find any matched location in the database.")
//            displayAlert(title: "Error", message: "Cannot find any matched location in the database.", complete: nil)
//        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(itinerarySaved(notification:)), name: FooyoConstants.notifications.FooyoSavedItinerary, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemSelected(notification:)), name: FooyoConstants.notifications.FooyoAddToPlanItemSelected, object: nil)

        applyGeneralVCSettings(vc: self)
        view.backgroundColor = .clear
        view.addSubview(overlay)
        view.addSubview(crossButton)
        view.addSubview(container)
        container.addSubview(containerOverlay)
        container.addSubview(newBtn)
        if items == nil {
            newBtn.isEnabled = false
        }
        container.addSubview(inforLabel)
        container.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        crossButton.addTarget(self, action: #selector(viewHandler), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewHandler))
        overlay.addGestureRecognizer(gesture)
        newBtn.addTarget(self, action: #selector(newHandler), for: .touchUpInside)
        setConstraint()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.navigationBar.isHidden == false {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.isHidden = true
            }
        }
        if self.navigationController?.isNavigationBarHidden == false {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.isNavigationBarHidden = true
            }
        }

    }
    
    func loadData() {
        if let _ = FooyoUser.currentUser.userId {
            if FooyoItinerary.myItineraries == nil {
                SVProgressHUD.show()
                HttpClient.sharedInstance.getItineraries { (itineraries, isSuccess) in
                    debugPrint("getItineraries")
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        if let itineraries = itineraries {
                            FooyoItinerary.myItineraries = itineraries
                            FooyoItinerary.sort()
                            self.setContainer()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func setContainer() {
        var gotItineraries = false
        if FooyoItinerary.todayAndFuture.count > 0 && items != nil {
            gotItineraries = true
        }
        
        if gotItineraries {
            inforLabel.text = "Add To An Existing Plan"
        } else {
            if items == nil {
                inforLabel.text = "Internal Error"
            } else {
                inforLabel.text = "There Is No Upcoming Plan"
            }
        }
        container.snp.remakeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
            if gotItineraries {
                make.top.equalTo(Scale.scaleY(y: 75))
            } else {
                make.top.equalTo(Scale.scaleY(y: 233))
            }
            make.bottom.equalTo(crossButton.snp.top).offset(Scale.scaleY(y: -29))
        }
        containerOverlay.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        inforLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        tableView.snp.remakeConstraints { (make) in
//            if gotItineraries {
//            } else {
//                make.height.equalTo(0)
//            }
            
            make.top.equalTo(inforLabel.snp.bottom).offset(10)
            make.bottom.equalTo(newBtn.snp.top).offset(-10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        newBtn.snp.remakeConstraints { (make) in
            make.height.equalTo(40)
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
        crossButton.snp.remakeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 40))
            if gotItineraries {
                make.bottom.equalTo(Scale.scaleY(y: -60))
            } else {
                make.bottom.equalTo(Scale.scaleY(y: -210))
            }
            make.centerX.equalToSuperview()
        }
    }
    func setConstraint() {
        overlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setContainer()
    }
    func viewHandler() {
        _ = dismiss(animated: true, completion: nil)
    }
    func newHandler() {
        let vc = FooyoCreatePlanViewController(userId: FooyoUser.currentUser.userId!)
        vc.homePage = .FromAddToPlan
        vc.mustGoPlaces = items
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    func itinerarySaved(notification: Notification) {
        if let _ = notification.object as? FooyoItinerary {
            setContainer()
            self.tableView.reloadData()
        }
    }
    func itemSelected(notification: Notification) {
        debugPrint("i am receiving")
        if let item = notification.object as? FooyoItem {
            debugPrint("i am receiving a fooyo item")
            delegate?.fooyoAddToPlanViewController(didSelectInformationWindow: item.getFooyoIndex(), isEditingAPlan: true)
        }
    }
}

extension FooyoAddToPlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FooyoItinerary.todayAndFuture.count > 0 && items != nil {
            return FooyoItinerary.todayAndFuture.count
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if FooyoItinerary.todayAndFuture.count == 0 || items == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier, for: indexPath) as! EmptyTableViewCell
            if items == nil {
                cell.configureWith("The FooyoIndex given is incorrect.")
            } else {
                cell.configureWith("Create a new plan to enjoy your visit.")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItinerarySmallTableViewCell.reuseIdentifier, for: indexPath)  as! ItinerarySmallTableViewCell
            cell.delegate = self
            let plan = FooyoItinerary.todayAndFuture[indexPath.row]
            cell.configureWith(itinerary: plan)
            return cell
            }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if FooyoItinerary.todayAndFuture.count == 0 || items == nil  {
            return tableView.frame.height
        } else {
            return Scale.scaleY(y: 130)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        debugPrint(FooyoItinerary.todayAndFuture.count)
        if FooyoItinerary.todayAndFuture.count != 0 && items != nil {
            let plan = FooyoItinerary.todayAndFuture[indexPath.row].makeCopy()
            debugPrint("=======")
            debugPrint(plan.name)
            debugPrint(plan.items?.count)
            debugPrint(items?.count)
            if let planItems = plan.items {
                if let items = items {
                    for each in planItems {
                        for subeach in items {
                            debugPrint("plan item id: \(each.id), match item id: \(subeach.id)")
                            if each.id == subeach.id {
                                displayAlert(title: "Warning", message: "The place is already inside the chosen plan.\nRepeated visiting is not supported in the current version.", complete: nil)
                                return
                            }
                        }
                    }
                    plan.items?.append(contentsOf: items)
                    debugPrint(plan.items?.count)
                }
            }
            _ = gotoEditItinerary(itinerary: plan, homePage: FooyoConstants.PageSource.FromAddToPlan)
        }
    }
}

extension FooyoAddToPlanViewController: ItinerarySmallTableViewCellDelegate {
    func ItinerarySmallTableViewCellDidTapped(itinerary: FooyoItinerary) {
//        _ = gotoEditItinerary(itinerary: itinerary)
        if FooyoItinerary.todayAndFuture.count != 0 && items != nil {
//            let plan = FooyoItinerary.todayAndFuture[indexPath.row]
            if let planItems = itinerary.items {
                if let items = items {
                    for each in planItems {
                        for subeach in items {
                            debugPrint("plan item id: \(each.id), match item id: \(subeach.id)")
                            if each.id == subeach.id {
                                displayAlert(title: "Warning", message: "The place is already inside the chosen plan.\nRepeated visiting is not supported in the current version.", complete: nil)
                                return
                            }
                        }
                    }
                    itinerary.items?.append(contentsOf: items)
                }
            }
            _ = gotoEditItinerary(itinerary: itinerary, homePage: FooyoConstants.PageSource.FromAddToPlan)
        }
    }
}


