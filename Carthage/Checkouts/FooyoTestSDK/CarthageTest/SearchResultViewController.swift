//
//  SearchResultViewController.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 13/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {
    weak var sourceVC: UIViewController?
    fileprivate var searchSource = FooyoConstants.PageSource.FromHomeMap
    fileprivate var key: String = ""
    fileprivate var results = [FooyoItem]()
    fileprivate var overLay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey10
        return t
    }()
    
    fileprivate var bigBack: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        return t
    }()
    fileprivate var backView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "general_leftarrow")
        return t
    }()
    fileprivate var searchBtn: UIButton! = {
        let t = UIButton()
//        t.setTitle(", for: <#T##UIControlState#>)
        t.setTitleColor(UIColor.ospDarkGrey, for: .normal)
        t.setImage(UIImage.getBundleImage(name: "basemap_search"), for: .normal)
        t.backgroundColor = UIColor.white
        return t
    }()
    fileprivate var searchLine: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    
    fileprivate var tableView: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorStyle = .none
        t.register(ItemSummaryTableViewCell.self, forCellReuseIdentifier: ItemSummaryTableViewCell.reuseIdentifier)
        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        t.tableFooterView = UIView()
        t.keyboardDismissMode = .onDrag
        return t
    }()
    
    // MARK: - Life Cycle
    init(key: String, searchSource: FooyoConstants.PageSource) {
        super.init(nibName: nil, bundle: nil)
        self.key = key
        self.searchSource = searchSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        refreshData()
        findMatch()
//        searchField.text = key
        searchBtn.setTitle(" \(key) ", for: .normal)
        //        automaticallyAdjustsScrollViewInsets = false
        //        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor.white
        view.addSubview(overLay)
        view.addSubview(bigBack)
        bigBack.addSubview(backView)
        view.addSubview(searchBtn)
        searchBtn.addTarget(self, action: #selector(searchHandler), for: .touchUpInside)
        searchBtn.addSubview(searchLine)
        view.addSubview(tableView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backHandler))
        bigBack.addGestureRecognizer( gesture)
        tableView.delegate = self
        tableView.dataSource = self
        
        setConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        //        navigationController?.navigationBar.isTranslucent = true
    //        if self.navigationController?.isNavigationBarHidden == false {
    //            UIView.animate(withDuration: 0.3) {
    //                self.navigationController?.isNavigationBarHidden = true
    //            }
    //        }
    //    }
    
    func setConstraints() {
        overLay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        searchBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 9))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.leading.equalTo(Scale.scaleX(x: 33))
            make.trailing.equalTo(Scale.scaleX(x: -33))
        }
        searchLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        bigBack.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 24))
            make.centerY.equalTo(searchBtn)
            make.trailing.equalTo(searchBtn.snp.leading)
        }
        backView.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 8))
            make.width.equalTo(Scale.scaleX(x: 16))
            make.height.equalTo(Scale.scaleY(y: 16))
            make.centerY.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(searchBtn.snp.bottom).offset(Scale.scaleY(y: 11))
        }
    }
    
    func backHandler() {
//        _ = self.navigationController?.popViewController(animated: true)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func searchHandler() {
        let vc = SearchHistoryViewController(source: .FromHomeMap)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func findMatch() {
        //        self.history = User.currentUser.recentSearch
        //        history = [324, 325, 326, 327]
        results = FooyoItem.items.filter({ (item) -> Bool in
            return (item.name)!.lowercased().contains(key.lowercased())
        })
        //        tableView.reloadData()
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.count == 0 {
            return 1
        } else {
            return results.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if results.count != 0 {
            let item = results[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemSummaryTableViewCell.reuseIdentifier) as! ItemSummaryTableViewCell
            cell.configureWith(item: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
            cell.configureWith("There is no matching result.")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let t = UIView()
        t.backgroundColor = UIColor.white
        let label = UILabel()
        label.text = "SEARCH RESULTS"
        label.font = UIFont.DefaultBoldWithSize(size: Scale.scaleY(y: 12))
        label.textColor = UIColor.ospDarkGrey
        t.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 9))
            make.centerY.equalToSuperview()
        }
        return t
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Scale.scaleY(y: 26)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if results.count != 0 {
            return Scale.scaleY(y: 55)
        } else {
            return tableView.frame.height
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if results.count > 0 {
            let item = results[indexPath.row]
            if FooyoUser.currentUser.updateSearchResult(newId: item.id!) {
                FooyoUser.currentUser.saveToDefaults()
                PostUpdateHistoryNotification()
            }
            //            let history = history[indexPath.row]
            //            let id = history["id"] as! Int
            //            let category = history["category"] as! String
            //            let name = history["name"] as! String
            //
            
            if searchSource == FooyoConstants.PageSource.FromHomeMap {
                PostSearchNotification(item: item)
            } else if searchSource == FooyoConstants.PageSource.FromItineraryEditMap {
            } else if searchSource == FooyoConstants.PageSource.FromNavigation {
                PostUpdateNavigationPointNotification(item: item)
            }
            if let sourceVC = sourceVC {
                _ = self.navigationController?.popToViewController(sourceVC, animated: true)
            }

        }
        //        }
    }
}
