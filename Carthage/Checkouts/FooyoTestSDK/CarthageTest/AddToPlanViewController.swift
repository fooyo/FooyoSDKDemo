//
//  AddToPlanViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 28/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

public class FooyoAddToPlanViewController: UIViewController {
    
    fileprivate var index: FooyoIndex?
    fileprivate var overlay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospOverlay
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
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 16))
        t.textColor = UIColor.ospSentosaBlue
        t.textAlignment = .center
        return t
    }()
    
    fileprivate var newBtn: UIButton! = {
        let t = UIButton()
        t.setTitle("Add To A New Plan", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.layer.cornerRadius = 19.5
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
        return t
    }()
    
    public init(index: FooyoIndex, userId: String) {
        super.init(nibName: nil, bundle: nil)
        self.index = index
        FooyoUser.currentUser.userId = userId
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyGeneralVCSettings(vc: self)
        view.backgroundColor = .clear
        view.addSubview(overlay)
        view.addSubview(container)
        container.addSubview(containerOverlay)
        container.addSubview(newBtn)
        container.addSubview(inforLabel)
        container.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewHandler))
        view.addGestureRecognizer(gesture)
        newBtn.addTarget(self, action: #selector(newHandler), for: .touchUpInside)
        setConstraint()
        loadData()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func setConstraint() {
        overlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        container.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
            make.leading.equalTo(Scale.scaleX(x: 30))
            make.trailing.equalTo(Scale.scaleX(x: -30))
//            make.height.equalTo(400)
            make.top.equalTo(Scale.scaleY(y: 100))
            make.bottom.equalTo(Scale.scaleY(y: -150))
        }
        containerOverlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        inforLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(inforLabel.snp.bottom).offset(10)
            make.bottom.equalTo(newBtn.snp.top).offset(-10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        newBtn.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
    }
    func viewHandler() {
        _ = dismiss(animated: true, completion: nil)
    }
    func newHandler() {
        featureUnavailable()
    }
}

extension FooyoAddToPlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FooyoItinerary.todayAndFuture.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if FooyoItinerary.todayAndFuture.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier, for: indexPath) as! EmptyTableViewCell
            cell.configureWith("There is no existing plan.\nCreate a new plan to enjoy your visit.")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItinerarySmallTableViewCell.reuseIdentifier, for: indexPath)  as! ItinerarySmallTableViewCell
            let plan = FooyoItinerary.todayAndFuture[indexPath.row]
            cell.configureWith(itinerary: plan)
            //
            return cell
            }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Scale.scaleY(y: 130)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if itineraries.count > 0 {
        //            tableView.deselectRow(at: indexPath, animated: false)
        //            let itinerary = itineraries[indexPath.row]
        //            gotoDisplayItinerary(itinerary: itinerary, parentVC: parentVC!)
        //        }
        tableView.deselectRow(at: indexPath, animated: false)
        featureUnavailable()
    }
}


