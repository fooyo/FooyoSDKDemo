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

    fileprivate var key = ""
    fileprivate var keyItems = [FooyoItem]()
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
        t.returnKeyType = .done
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
        searchField.addTarget(self, action: #selector(serchUpdate), for: .editingChanged)

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
        if self.navigationController?.navigationBar.isHidden == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.navigationBar.isHidden = true
            })
        }
        if self.navigationController?.isNavigationBarHidden == false {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.isNavigationBarHidden = true
            }
        }
        searchField.becomeFirstResponder()
    }
    
    func setConstraints() {
        overLay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        searchField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 9))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.leading.equalTo(Scale.scaleX(x: 40))
            make.trailing.equalTo(Scale.scaleX(x: -40))
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
//            make.height.equalTo(Scale.scaleY(y: 24))
            make.height.equalTo(searchField)
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
        if key == "" {
            if historyItems.count == 0 {
                return 1
            } else {
                return historyItems.count
            }
        } else {
            if keyItems.count == 0 {
                return 1
            } else {
                return keyItems.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if key == "" {
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
        } else {
            if keyItems.count != 0 {
                let item = keyItems[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: ItemSummaryTableViewCell.reuseIdentifier) as! ItemSummaryTableViewCell
                cell.configureWith(item: item)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
                cell.configureWith("There is no matching result.")
                return cell
            }
            
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
        if key == "" {
            label.text = "SEARCH HISTORY"
        } else {
            label.text = "SEARCH RESULTS"
        }
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
        if key == "" {
            
            if historyItems.count != 0 {
                return Scale.scaleY(y: 55)
            } else {
                return tableView.frame.height
            }
        } else {
            
            if keyItems.count != 0 {
                return Scale.scaleY(y: 55)
            } else {
                return tableView.frame.height
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if key == "" {
            
            if historyItems.count > 0 {
                let item = historyItems[indexPath.row]
                if searchSource == FooyoConstants.PageSource.FromHomeMap {
                    PostSearchNotification(item: item)
                    _ = self.navigationController?.popToRootViewController(animated: true)
                } else if searchSource == FooyoConstants.PageSource.FromItineraryEditMap {
                    PostItineraryAddItemNotification(item: item)
                    if let sourceVC = sourceVC {
                        _ = self.navigationController?.popToViewController(sourceVC, animated: true)
                    }
                } else if searchSource == FooyoConstants.PageSource.FromNavigation {
                    PostUpdateNavigationPointNotification(item: item)
                    if let sourceVC = sourceVC {
                        _ = self.navigationController?.popToViewController(sourceVC, animated: true)
                    }
                }
            }
        } else {
            if keyItems.count > 0 {
                let item = keyItems[indexPath.row]
                
                if FooyoUser.currentUser.updateSearchResult(newId: item.id!) {
                    FooyoUser.currentUser.saveToDefaults()
                    PostUpdateHistoryNotification()
                }
                
                if searchSource == FooyoConstants.PageSource.FromHomeMap {
                    PostSearchNotification(item: item)
                    _ = self.navigationController?.popToRootViewController(animated: true)
                } else if searchSource == FooyoConstants.PageSource.FromItineraryEditMap {
                    PostItineraryAddItemNotification(item: item)
                    if let sourceVC = sourceVC {
                        _ = self.navigationController?.popToViewController(sourceVC, animated: true)
                    }
                } else if searchSource == FooyoConstants.PageSource.FromNavigation {
                    PostUpdateNavigationPointNotification(item: item)
                    if let sourceVC = sourceVC {
                        _ = self.navigationController?.popToViewController(sourceVC, animated: true)
                    }
                }
                
            }
        }
    }
}

extension SearchHistoryViewController: UITextFieldDelegate {
    func serchUpdate(field: UITextField) {
        key = field.text!
        debugPrint(key)
        if key != "" {
            keyItems = FooyoItem.items.filter({ (item) -> Bool in
                if item.name?.lowercased().contains(key.lowercased()) == true {
                    return true
                }
                return false
            })
        } else {
            keyItems = [FooyoItem]()
        }
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let key = textField.text!
//        if key == "" {
//            displayAlert(title: "Reminder", message: "The key word for search cannot be empty.", complete: nil)
//        } else {
//            searchHandler(key: key)
//            //            let vc = SearchResultViewController(key: key)
////            vc.delegate = self
////            self.navigationController?.pushViewController(vc, animated: true)
//        }
        view.endEditing(true)
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
