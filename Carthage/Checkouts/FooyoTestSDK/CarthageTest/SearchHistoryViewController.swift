//
//  SearchHistoryViewController.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 12/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class SearchHistoryViewController: BaseViewController {    
    fileprivate var searchSource = FooyoConstants.PageSource.FromHomeMap
    weak var sourceVC: UIViewController?

    fileprivate var historyItems = [FooyoItem]()
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
    fileprivate var searchField: UITextField! = {
        let t = UITextField()
        t.placeholder = "Where would you like to go?"
        t.textColor = UIColor.ospDarkGrey
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.backgroundColor = .white
        t.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 9, height: 1))
        t.leftViewMode = .always
        t.returnKeyType = .search
        return t
    }()
    fileprivate var searchIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "basemap_search")
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
    init(source: FooyoConstants.PageSource) {
        super.init(nibName: nil, bundle: nil)
        self.searchSource = source
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHistory), name: FooyoConstants.notifications.FooyoUpdateHistory, object: nil)

        loadHistory()
//        automaticallyAdjustsScrollViewInsets = false
//        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor.white
        view.addSubview(overLay)
        view.addSubview(bigBack)
        bigBack.addSubview(backView)
        view.addSubview(searchField)
        searchField.delegate = self
        searchField.addSubview(searchIcon)
        searchField.addSubview(searchLine)
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
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.isNavigationBarHidden = true
            })
        }
    }
    
    func setConstraints() {
        overLay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        searchField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 9))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.leading.equalTo(Scale.scaleX(x: 33))
            make.trailing.equalTo(Scale.scaleX(x: -33))
        }
        searchIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 20))
            make.trailing.equalTo(Scale.scaleX(x: -9))
        }
        searchLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        bigBack.snp.makeConstraints { (make) in
//            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 17))
            make.leading.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 24))
            make.centerY.equalTo(searchField)
            make.trailing.equalTo(searchField.snp.leading)
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
            make.top.equalTo(searchField.snp.bottom).offset(Scale.scaleY(y: 11))
        }
    }
    
    func backHandler() {
        _ = self.navigationController?.popViewController(animated: true)
        //        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func loadHistory() {
        FooyoUser.awakeCurrentUserFromDefaults()
        if let history = FooyoUser.currentUser.searchHistory {
            historyItems = FooyoItem.items.filter({ (item) -> Bool in
                return history.contains((item.id)!)
            })

        }
    }
    
    func reloadHistory() {
        loadHistory()
        tableView.reloadData()
    }
    
    func searchHandler(key: String) {
        if let sourceVC = sourceVC {
            gotoSearchResult(key: key, source: searchSource, sourceVC: sourceVC)
        }
    }
}

extension SearchHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyItems.count == 0 {
            return 1
        } else {
            return historyItems.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if historyItems.count != 0 {
            let item = historyItems[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemSummaryTableViewCell.reuseIdentifier) as! ItemSummaryTableViewCell
            cell.configureWith(item: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
            cell.configureWith("History is empty.")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let t = UIView()
        t.backgroundColor = UIColor.white
        let upper = UIView()
        upper.backgroundColor = .white
        t.addSubview(upper)
        let lower = UIView()
        lower.backgroundColor = UIColor.ospGrey10
        t.addSubview(lower)
        let label = UILabel()
        label.text = "SEARCH HISTORY"
        label.font = UIFont.DefaultBoldWithSize(size: Scale.scaleY(y: 12))
        label.textColor = UIColor.ospDarkGrey
        t.addSubview(label)
        upper.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
        lower.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 10))
        }
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 9))
//            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
        return t
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Scale.scaleY(y: 26) + Scale.scaleY(y: 10)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if historyItems.count != 0 {
            return Scale.scaleY(y: 55)
        } else {
            return tableView.frame.height
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if historyItems.count > 0 {
            let item = historyItems[indexPath.row]
            
//            let history = history[indexPath.row]
//            let id = history["id"] as! Int
//            let category = history["category"] as! String
//            let name = history["name"] as! String
//            
            if searchSource == FooyoConstants.PageSource.FromHomeMap {
                PostSearchNotification(item: item)
            } else if searchSource == FooyoConstants.PageSource.FromItineraryEditMap {
                PostItineraryAddItemNotification(item: item)
            } else if searchSource == FooyoConstants.PageSource.FromNavigation {
                PostUpdateNavigationPointNotification(item: item)
            }
            if let sourceVC = sourceVC {
                _ = self.navigationController?.popToViewController(sourceVC, animated: true)
            }
        }

    }
}

extension SearchHistoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let key = textField.text!
        if key == "" {
            displayAlert(title: "Reminder", message: "The key word for search cannot be empty.", complete: nil)
        } else {
            searchHandler(key: key)
            //            let vc = SearchResultViewController(key: key)
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        return true
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let key = searchBar.text!
//        if key == "" {
//            displayAlert(title: "Reminder", message: "The key word for search cannot be empty.", complete: nil)
//        } else {
//            let vc = SearchResultViewController(key: key)
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
}
//
//extension SearchViewController: SearchResultViewControllerDelegate {
//    func searchResultItemSelected(id: Int, name: String, category: String) {
//        if searchSource == Constants.PageSource.FromHomeMap {
//            _ = self.navigationController?.popToRootViewController(animated: true)
//        } else {
//            _ = self.navigationController?.popViewController(animated: true)
//        }
//        delegate?.searchViewItemSelected(id: id, name: name, category: category)
//    }
//}
