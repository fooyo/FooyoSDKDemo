//
//  ItineraryListViewController.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 20/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class ItineraryListViewController: BaseViewController {
    weak var parentVC: UIViewController?
    
    fileprivate var itineraries = [FooyoItinerary]()
    
    fileprivate var tableView: UITableView! = {
        let t = UITableView()
        t.separatorStyle = .none
        t.register(ItineraryTableViewCell.self, forCellReuseIdentifier: ItineraryTableViewCell.reuseIdentifier)
        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        t.backgroundColor = UIColor.clear
        t.tableFooterView = UIView()
        return t
    }()
    
    // MARK: - Life Cycle
    init(itineraries: [FooyoItinerary]) {
        super.init(nibName: nil, bundle: nil)
        self.itineraries = itineraries
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            //            make.top.equalTo(Scale.scaleY(y: 10))
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableData(itineraries: [FooyoItinerary]) {
        self.itineraries = itineraries
        tableView.reloadData()
    }
}

extension ItineraryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itineraries.count == 0 {
            return 1
        } else {
            return itineraries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if itineraries.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier, for: indexPath) as! EmptyTableViewCell
            cell.overlay.backgroundColor = .clear
            if FooyoUser.currentUser.userId == nil {
                cell.configureWith("Log in is required to view the plans.")
            } else {
                cell.configureWith("The list is empty.")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItineraryTableViewCell.reuseIdentifier, for: indexPath)  as! ItineraryTableViewCell
            cell.delegate = self
            let itinerary = itineraries[indexPath.row]
//            let gesture = UITapGestureRecognizer(target: self, action: #selector())
//            cell.delegate = self
            if indexPath.row == itineraries.count - 1 {
                cell.configureWith(itinerary: itinerary, hideLine: true)
            } else {
                cell.configureWith(itinerary: itinerary)
            }
//
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if itineraries.count == 0 {
            return tableView.frame.height
        } else {
            return Scale.scaleY(y: 190)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if itineraries.count > 0 {
            tableView.deselectRow(at: indexPath, animated: false)
            let itinerary = itineraries[indexPath.row]
            gotoDisplayItinerary(itinerary: itinerary, parentVC: parentVC)
//            let vc = EditItineraryViewController(itinerary: itinerary)
//            vc.hidesBottomBarWhenPushed = true
//            self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ItineraryListViewController: ItineraryTableViewCellDelegate {
    func ItineraryTableViewCellDidTapped(itinerary: FooyoItinerary) {
        gotoDisplayItinerary(itinerary: itinerary, parentVC: parentVC)
    }
}
