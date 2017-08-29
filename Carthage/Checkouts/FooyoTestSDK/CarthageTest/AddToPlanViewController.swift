//
//  AddToPlanViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 28/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

public class FooyoAddToPlanViewController: UIViewController {
    
    fileprivate var overlay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospOverlay
        return t
    }()
    fileprivate var container: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        t.layer.cornerRadius = 5
        t.clipsToBounds = true
        t.isUserInteractionEnabled = true
        return t
    }()
    
    fileprivate var inforLabel: UILabel! = {
        let t = UILabel()
        t.text = "Choose An Existing Plan"
//        t.numberOfLines = 0
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
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
        t.register(FakeTableViewCell.self, forCellReuseIdentifier: FakeTableViewCell.reuseIdentifier)
        return t
    }()
    
    public init(category: String, levelOneId: Int) {
        super.init(nibName: nil, bundle: nil)
//        self.selectedCategory = category
//        self.selectedId = levelOneId
//        if category != nil {
//            self.showOnMapMode = true
//        } else {
//            self.showOnMapMode = false
//        }
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
        container.addSubview(newBtn)
        container.addSubview(inforLabel)
        container.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewHandler))
        view.addGestureRecognizer(gesture)
        newBtn.addTarget(self, action: #selector(newHandler), for: .touchUpInside)
        setConstraint()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setConstraint() {
        overlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(Scale.scaleX(x: 30))
            make.trailing.equalTo(Scale.scaleX(x: -30))
            make.height.equalTo(400)
        }
        inforLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(inforLabel.snp.bottom).offset(5)
            make.bottom.equalTo(newBtn.snp.top).offset(-20)
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
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 2
    //    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if itineraries.count == 0 {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier, for: indexPath) as! EmptyTableViewCell
        //            cell.configureWith("The list is empty")
        //            return cell
        //        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: FakeTableViewCell.reuseIdentifier, for: indexPath)  as! FakeTableViewCell
        //            let itinerary = itineraries[indexPath.row]
        //            debugPrint(itinerary.tickets)
        ////            let gesture = UITapGestureRecognizer(target: self, action: #selector())
        //            cell.delegate = self
        //            cell.configureWith(itinerary: itinerary)
        //
        return cell
        //        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Scale.scaleY(y: 80)
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


