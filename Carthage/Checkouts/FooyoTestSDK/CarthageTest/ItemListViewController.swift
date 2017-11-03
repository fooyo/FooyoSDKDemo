//
//  ItemListViewController.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 27/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import TPKeyboardAvoidingKit

class ItemListViewController: BaseViewController {
    weak var parentVC: UIViewController?
    
    fileprivate var items = [FooyoItem]()
    
    fileprivate var tableView: TPKeyboardAvoidingTableView! = {
        let t = TPKeyboardAvoidingTableView()
        t.separatorStyle = .none
        t.register(ItemSummaryTwoTableViewCell.self, forCellReuseIdentifier: ItemSummaryTwoTableViewCell.reuseIdentifier)
        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        t.backgroundColor = UIColor.clear
        t.tableFooterView = UIView()
        t.keyboardDismissMode = .onDrag
        return t
    }()
    fileprivate var homePage: FooyoConstants.PageSource = .FromAddToPlan

    // MARK: - Life Cycle
    init(items: [FooyoItem], homePage: FooyoConstants.PageSource) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
        self.homePage = homePage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableData(items: [FooyoItem]) {
        self.items = items
        tableView.reloadData()
    }
}

extension ItemListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            return 1
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if items.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier, for: indexPath) as! EmptyTableViewCell
            cell.overlay.backgroundColor = .clear
            cell.configureWith("Coming soon...😬")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemSummaryTwoTableViewCell.reuseIdentifier, for: indexPath)  as! ItemSummaryTwoTableViewCell
            let item = items[indexPath.row]
            cell.configureWith(item: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if items.count == 0 {
            return tableView.frame.height
        } else {
            return Scale.scaleY(y: 84)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if items.count > 0 {
            let item = items[indexPath.row]
            if homePage == FooyoConstants.PageSource.FromAddToPlan {
                PostAddToPlanItemSelectionNotification(item: item)
            } else if homePage == FooyoConstants.PageSource.FromMyPlan {
                item.isInEditMode = true
                PostMyPlanItemSelectionNotification(item: item)
            }
        }
    }
}
