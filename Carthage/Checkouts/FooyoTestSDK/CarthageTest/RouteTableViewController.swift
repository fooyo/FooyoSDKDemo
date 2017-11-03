//
//  RouteTableViewController.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 15/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class RouteTableViewController: BaseViewController {
    fileprivate var routes: [FooyoRoute]?
    var parentVC: UIViewController?
    
    fileprivate var routeTable: UITableView! = {
        let t = UITableView()
        t.register(RouteListTableViewCell.self, forCellReuseIdentifier: RouteListTableViewCell.reuseIdentifier)
        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        t.tableFooterView = UIView()
        t.separatorColor = UIColor.ospGrey50
        t.separatorInset = UIEdgeInsets.zero
        return t
    }()
    
    // MARK: - Life Cycle
    init(routes: [FooyoRoute]? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.routes = routes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(routeTable)
        routeTable.delegate = self
        routeTable.dataSource = self
        routeTable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reConfigure(routes: [FooyoRoute]) {
        self.routes = routes
        self.routeTable.reloadData()
    }
    
}


extension RouteTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let routes = routes {
            if routes.count == 0 {
                return 1
            } else {
                return routes.count
            }
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let routes = routes {
            if routes.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
                cell.configureWith("Sorry, this feature is currently unavailable.\nBut coming soon!😀")
                return cell
            } else {
                let route = routes[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: RouteListTableViewCell.reuseIdentifier) as! RouteListTableViewCell
                cell.delegate = self
                cell.configureWith(route: route)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier) as! EmptyTableViewCell
            cell.configureWith("")
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let routes = routes {
            if routes.count == 0 {
                return tableView.frame.height
            } else {
                let route = routes[indexPath.row]
                return RouteListTableViewCell.estimateHeightWith(route: route)
            }
        } else {
            return tableView.frame.height
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let routes = routes {
            if routes.count > 0 {
                let route = routes[indexPath.row]
                let vc = RouteMapViewController(route: route)
                self.parentVC?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension RouteTableViewController: RouteListTableViewCellDelegate {
    func RouteListTableViewCellDelegateDidTap(route: FooyoRoute) {
        let vc = RouteMapViewController(route: route)
        self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
