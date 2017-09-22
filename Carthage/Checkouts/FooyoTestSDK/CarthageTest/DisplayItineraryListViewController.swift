//
//  DisplayItineraryListViewController.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 3/5/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class DisplayItineraryListViewController: BaseViewController {
    fileprivate var itinerary: FooyoItinerary?
    fileprivate var tableView: UITableView! = {
        let t = UITableView()
        t.separatorStyle = .none
        t.tableFooterView = UIView()
        t.backgroundColor = .white
        t.register(ItineraryDisplayListTableViewCell.self, forCellReuseIdentifier: ItineraryDisplayListTableViewCell.reuseIdentifier)
        return t
    }()
    
    // MARK: - Life Cycle
    init(itinerary: FooyoItinerary) {
        super.init(nibName: nil, bundle: nil)
        self.itinerary = itinerary
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(updateItineraries(_:)), name: NSNotification.Name(rawValue: Constants.Notification.updateItinerary.rawValue), object: nil)
        

        // Do any additional setup after loading the view.
        setupNavigationBar()
//        view.addSubview(dateLabel)
//        view.addSubview(circleView)
//        view.addSubview(lineView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
//        dateLabel.text = DateTimeTool.fromFormatThreeToFormatTwo(date: (itinerary?.time)!)
        setConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupNavigationBar() {
        navigationItem.title = self.itinerary?.name
        let editButton = UIBarButtonItem(image: UIImage.getBundleImage(name: "plan_edit"), style: .plain, target: self, action: #selector(editHandler))
        navigationItem.rightBarButtonItem = editButton
    }
    
    func editHandler() {
        let _ = gotoEditItinerary(itinerary: itinerary!)
//        vc.delegate = self
    }
    func setConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension DisplayItineraryListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (itinerary?.items?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItineraryDisplayListTableViewCell.reuseIdentifier, for: indexPath) as! ItineraryDisplayListTableViewCell
//        cell.delegate = self
        let item = (itinerary?.items)![indexPath.row]
        if let count = itinerary?.routes?.count {
            if indexPath.row < count {
                let route = itinerary?.routes?[indexPath.row]
                route?.startItem = itinerary?.items?[indexPath.row]
                route?.endItem = itinerary?.items?[indexPath.row + 1]
                cell.configureWith(item: item, route: route, index: indexPath.row + 1)
                return cell
            }
        }
        cell.configureWith(item: item, index: indexPath.row + 1)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Scale.scaleY(y: 131)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        let item = itinerary?.items?[indexPath.row]
//        gotoItemDetail(id: (item?.id)!, from: .FromItineraryEditMap)
    }
}

//extension DisplayItineraryListViewController: ItineraryDisplayListTableViewCellDelegate {
//    func didTapRoute(route: Route) {
//        gotoRouteDetail(route: route)
//    }
//}

extension DisplayItineraryListViewController {
//    func updateItineraries(_ notification: Foundation.Notification) {
//        debugPrint("i got the notification")
//        if let itinerary = notification.object as? Itinerary {
//            if itinerary.id == self.itinerary?.id {
//                self.itinerary = itinerary.makeCopy()
//                tableView.reloadData()
//            }
//        }
//    }

}
