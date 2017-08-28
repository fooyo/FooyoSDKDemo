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
        t.backgroundColor = .white
        t.separatorStyle = .singleLine
        t.separatorColor = UIColor.ospGrey50
        t.separatorInset = UIEdgeInsets.zero
        t.register(ItineraryTableViewCell.self, forCellReuseIdentifier: ItineraryTableViewCell.reuseIdentifier)
//        t.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        t.backgroundColor = UIColor.ospGrey10
        return t
    }()
    
    // MARK: - Life Cycle
//    init(itineraries: [FooyoItinerary]) {
//        super.init(nibName: nil, bundle: nil)
//        self.itineraries = itineraries
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.ospGrey10
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 10))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ItineraryListViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if itineraries.count == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier, for: indexPath) as! EmptyTableViewCell
//            cell.configureWith("The list is empty")
//            return cell
//        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItineraryTableViewCell.reuseIdentifier, for: indexPath)  as! ItineraryTableViewCell
//            let itinerary = itineraries[indexPath.row]
//            debugPrint(itinerary.tickets)
////            let gesture = UITapGestureRecognizer(target: self, action: #selector())
//            cell.delegate = self
//            cell.configureWith(itinerary: itinerary)
//            
            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Scale.scaleY(y: 190)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if itineraries.count > 0 {
//            tableView.deselectRow(at: indexPath, animated: false)
//            let itinerary = itineraries[indexPath.row]
//            gotoDisplayItinerary(itinerary: itinerary, parentVC: parentVC!)
//        }
        tableView.deselectRow(at: indexPath, animated: false)
        featureUnavailable()
    }
}

//extension ItineraryListViewController: ItineraryTableViewCellDelegate {
//    func displayTickets(itinerary: Itinerary) {
//        let vc = TicketsViewController(tickets: itinerary.tickets)
//        parentVC?.navigationController?.pushViewController(vc, animated: true)
//    }
//}
