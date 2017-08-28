////
////  FilterViewController.swift
////  SmartSentosa
////
////  Created by Yangfan Liu on 18/2/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import UIKit
//protocol FilterViewControllerDelegate: class {
//    func filter(sortType: Constants.SortType?, filterType: [Constants.FilterType]?)
//}
//class FilterViewController: BaseViewController {
//    weak var delegate: FilterViewControllerDelegate?
//    fileprivate var mode: Constants.ViewMode?
//    
//    fileprivate var sortType: Constants.SortType?
//    fileprivate var filters: [Constants.FilterType]?
//    
//    fileprivate var tableView: UITableView! = {
//        let t = UITableView()
//        t.backgroundColor = UIColor.sntWhiteTwo
//        t.separatorStyle = .none
//        t.register(RadioButtonTableViewCell.self, forCellReuseIdentifier: RadioButtonTableViewCell.reuseIdentifier)
//        t.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier)
//
//        t.separatorColor = UIColor.sntWhiteTwo
//        return t
//    }()
//    fileprivate var applyBtn: UIButton! = {
//        let t = UIButton()
//        t.backgroundColor = UIColor.sntMelon
//        t.setTitleColor(.white, for: .normal)
//        t.setTitle("Apply Filters", for: .normal)
//        t.layer.cornerRadius = Scale.scaleY(y: 4)
//        t.clipsToBounds = true
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        return t
//    }()
//    
//    
//    // MARK: - Life Cycle
//    init(mode: Constants.ViewMode, sort: Constants.SortType? = nil, filters: [Constants.FilterType]?) {
//        super.init(nibName: nil, bundle: nil)
//        self.mode = mode
//        self.sortType = sort
//        self.filters = filters
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        navigationItem.title = "Filters"
//        view.backgroundColor = UIColor.sntWhiteTwo
//        view.addSubview(tableView)
//        view.addSubview(applyBtn)
//        tableView.delegate = self
//        tableView.dataSource = self
//        applyBtn.addTarget(self, action: #selector(applyHandler), for: .touchUpInside)
//        setConstraints()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func setConstraints() {
//        applyBtn.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 20))
//            make.trailing.equalTo(Scale.scaleX(x: -20))
//            make.bottom.equalTo(Scale.scaleX(x: -20))
//            make.height.equalTo(Scale.scaleY(y: 50))
//        }
//        tableView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalTo(applyBtn.snp.top).offset(Scale.scaleY(y: -20))
//        }
//    }
//    
//    func applyHandler() {
//        delegate?.filter(sortType: sortType, filterType: filters)
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    func checkFilter(filter: Constants.FilterType) -> Bool {
//        if let filters = filters {
//            if filters.isEmpty {
//                return false
//            } else {
//                if filters.contains(filter) {
//                    return true
//                }
//                return false
//            }
//        }
//        return false
//    }
//    
//    func attractionFilterSwitched(sender: UISwitch) {
//        if sender.isOn {
//            addFilter(filter: .Attraction)
//        } else {
//            removeFilter(filter: .Attraction)
//        }
//    }
//    
//    func restaurantFilterSwitched(sender: UISwitch) {
//        if sender.isOn {
//            addFilter(filter: .Restaurant)
//        } else {
//            removeFilter(filter: .Restaurant)
//        }
//    }
//    
//    func showFilterSwitched(sender: UISwitch) {
//        if sender.isOn {
//            addFilter(filter: .Show)
//        } else {
//            removeFilter(filter: .Show)
//        }
//    }
//    
//    func shopFilterSwitched(sender: UISwitch) {
//        if sender.isOn {
//            addFilter(filter: .Shop)
//        } else {
//            removeFilter(filter: .Shop)
//        }
//    }
//    
//    func stopFilterSwitched(sender: UISwitch) {
//        if sender.isOn {
//            addFilter(filter: .Stop)
//        } else {
//            removeFilter(filter: .Stop)
//        }
//    }
//    func addFilter(filter: Constants.FilterType) {
//        if let filters = filters {
//            if !filters.contains(filter) {
//                    self.filters?.append(filter)
//            }
//        } else {
//            filters = [filter]
//        }
//    }
//    
//    func removeFilter(filter: Constants.FilterType) {
//        if let filters = filters {
//            let index = filters.index(of: filter)
//            self.filters?.remove(at: index!)
//            if (self.filters?.isEmpty)! {
//                self.filters = nil
//            }
//        }
//    }
//}
//
//extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if mode == Constants.ViewMode.List {
//            return 2
//        }
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if mode == Constants.ViewMode.Map {
//            return 5
//        }
//        switch section {
//        case 0:
//            return 1
//        default:
//            return 5
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if mode == Constants.ViewMode.Map {
//            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
//            switch indexPath.row {
//            case 0:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_camera"), name: "Attractions", isOn: checkFilter(filter: Constants.FilterType.Attraction))
//                cell.switchBtn.addTarget(self, action: #selector(attractionFilterSwitched), for: .valueChanged)
//            case 1:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_show"), name: "Shows", isOn: checkFilter(filter: Constants.FilterType.Show))
//                cell.switchBtn.addTarget(self, action: #selector(showFilterSwitched), for: .valueChanged)
//            case 2:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_restaurant"), name: "Restaurants", isOn: checkFilter(filter: Constants.FilterType.Restaurant))
//                cell.switchBtn.addTarget(self, action: #selector(restaurantFilterSwitched), for: .valueChanged)
//            case 3:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_shop"), name: "Shops", isOn: checkFilter(filter: Constants.FilterType.Shop))
//                cell.switchBtn.addTarget(self, action: #selector(shopFilterSwitched), for: .valueChanged)
//            default:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_bus"), name: "Bus stops", isOn: checkFilter(filter: Constants.FilterType.Stop))
//                cell.switchBtn.addTarget(self, action: #selector(stopFilterSwitched), for: .valueChanged)
//            }
//            return cell
//        }
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: RadioButtonTableViewCell.reuseIdentifier, for: indexPath) as! RadioButtonTableViewCell
//            if let sortType = sortType {
//                cell.configureWith(sort: sortType)
//            }
//            cell.delegate = self
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
//            switch indexPath.row {
//            case 0:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_camera"), name: "Attractions", isOn: checkFilter(filter: Constants.FilterType.Attraction))
//                cell.switchBtn.addTarget(self, action: #selector(attractionFilterSwitched), for: .valueChanged)
//            case 1:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_show"), name: "Shows", isOn: checkFilter(filter: Constants.FilterType.Show))
//                cell.switchBtn.addTarget(self, action: #selector(showFilterSwitched), for: .valueChanged)
//            case 2:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_restaurant"), name: "Restaurants", isOn: checkFilter(filter: Constants.FilterType.Restaurant))
//                cell.switchBtn.addTarget(self, action: #selector(restaurantFilterSwitched), for: .valueChanged)
//            case 3:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_shop"), name: "Shops", isOn: checkFilter(filter: Constants.FilterType.Shop))
//                cell.switchBtn.addTarget(self, action: #selector(shopFilterSwitched), for: .valueChanged)
//            default:
//                cell.configureWith(image: #imageLiteral(resourceName: "filter_bus"), name: "Bus stops", isOn: checkFilter(filter: Constants.FilterType.Stop))
//                cell.switchBtn.addTarget(self, action: #selector(stopFilterSwitched), for: .valueChanged)
//            }
//            return cell
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return Scale.scaleY(y: 52)
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor.sntWhiteTwo
//        let label = UILabel()
//        label.textColor = UIColor.sntWarmGrey
//        label.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        view.addSubview(label)
//        label.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 20))
//            make.bottom.equalTo(Scale.scaleY(y: -10))
//        }
//
//        if mode == Constants.ViewMode.Map {
//            label.text = "Filters by"
//            return view
//        }
//        switch section {
//        case 0:
//            label.text = "Sort by"
//        default:
//            label.text = "Filters by"
//        }
//        return view
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return Scale.scaleY(y: 48)
//    }
//}
//
//extension FilterViewController: RadioButtonTableViewCellDelegate {
//    func sortTypeChanged(sort: Constants.SortType) {
//        self.sortType = sort
//    }
//}
