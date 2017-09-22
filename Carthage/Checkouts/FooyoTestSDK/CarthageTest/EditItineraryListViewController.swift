//
//  EditItineraryListViewController.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 19/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditItineraryListViewController: BaseViewController {
    
    weak var sourceVC: UIViewController?
    fileprivate var selectedCategory: FooyoCategory?
    fileprivate var selectedCategoryItems = [FooyoItem]()

    fileprivate var itinerary: FooyoItinerary?
    fileprivate var categoryItems = [[FooyoItem]]()
    
    fileprivate var overLay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey10
        return t
    }()
    
    fileprivate var searchView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
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
        t.isUserInteractionEnabled = false
        return t
    }()
    fileprivate var searchIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "basemap_search")
        return t
    }()
    
    fileprivate var itemTableView: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorStyle = .none
        t.register(ItemSummaryTableViewCell.self, forCellReuseIdentifier: ItemSummaryTableViewCell.reuseIdentifier)
        t.tableFooterView = UIView()
        t.keyboardDismissMode = .onDrag
        return t
    }()
    
    fileprivate var filterView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        return t
    }()
    
    fileprivate var filterOverLay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        t.isUserInteractionEnabled = true
        return t
    }()
    fileprivate var categoryTable: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorInset = UIEdgeInsets.zero
        t.separatorColor = .clear
        t.separatorStyle = .singleLine
        t.clipsToBounds = true
        t.layer.cornerRadius = 12
        t.isScrollEnabled = false
        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return t
    }()
    fileprivate var amenityTable: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorInset = UIEdgeInsets.zero
        t.separatorColor = .clear
        t.separatorStyle = .singleLine
        t.clipsToBounds = true
        t.layer.cornerRadius = 12
        t.isScrollEnabled = false
        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return t
    }()
    fileprivate var transportationTable: UITableView! = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorInset = UIEdgeInsets.zero
        t.separatorColor = .clear
        t.separatorStyle = .singleLine
        t.clipsToBounds = true
        t.layer.cornerRadius = 12
        t.isScrollEnabled = false
        t.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return t
    }()
    fileprivate var cancelBtn: UILabel! = {
        let t = UILabel()
        t.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        t.clipsToBounds = true
        t.layer.cornerRadius = 12
        t.text = "Cancel"
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 18))
        t.textColor = UIColor.ospIoSblue
        t.textAlignment = .center
        t.isUserInteractionEnabled = true
        return t
    }()
    
    // MARK: - Life Cycle
    init(plan: FooyoItinerary) {
        super.init(nibName: nil, bundle: nil)
        self.itinerary = plan
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = itinerary?.name
        let rightBtn = UIBarButtonItem.init(image: UIImage.getBundleImage(name: "basemap_filter"), style: .plain, target: self, action: #selector(filterHandler))
        self.navigationItem.rightBarButtonItem = rightBtn
        view.addSubview(overLay)
        view.addSubview(searchView)
        searchView.addSubview(searchField)
        searchField.addSubview(searchIcon)
        view.addSubview(itemTableView)

        
        for _ in FooyoCategory.categories {
            categoryItems.append([FooyoItem]())
        }
        SVProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            self.sortItems()
            SVProgressHUD.dismiss()
        }

        let searchGesture = UITapGestureRecognizer(target: self, action: #selector(searchHandler))
        searchView.addGestureRecognizer(searchGesture)

        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        setConstraints()
        setupCategoryListView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.isNavigationBarHidden = false
            })
        }
    }
    func setupCategoryListView() {
        
        //        view.addSubview(filterView)
        if let vc = self.tabBarController {
            vc.view.addSubview(filterView)
        } else if let vc = self.navigationController {
            vc.view.addSubview(filterView)
        } else {
            view.addSubview(filterView)
        }
        filterView.addSubview(filterOverLay)
        let overLayGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilter))
        overLay.addGestureRecognizer(overLayGesture)
        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilter))
        cancelBtn.addGestureRecognizer(cancelGesture)
        
        filterView.addSubview(categoryTable)
        filterView.addSubview(amenityTable)
        filterView.addSubview(transportationTable)
        filterView.addSubview(cancelBtn)
        categoryTable.delegate = self
        categoryTable.dataSource = self
        amenityTable.delegate = self
        amenityTable.dataSource = self
        transportationTable.delegate = self
        transportationTable.dataSource = self
        categoryListConstraints()
    }
    
    func categoryListConstraints() {
        
        filterView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(FooyoConstants.mainHeight)
            make.top.equalTo((filterView.superview?.snp.bottom)!)
        }
        filterOverLay.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        cancelBtn.snp.remakeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 48))
            make.leading.equalTo(Scale.scaleX(x: 8))
            make.trailing.equalTo(Scale.scaleX(x: -8))
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
        categoryTable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(cancelBtn.snp.top).offset(Scale.scaleY(y: -8))
            make.leading.equalTo(Scale.scaleX(x: 8))
            make.trailing.equalTo(Scale.scaleX(x: -8))
            make.height.equalTo(CGFloat(FooyoCategory.others.count + 3) * (Scale.scaleY(y: 47.5)))
        }
        amenityTable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(categoryTable)
            make.leading.equalTo(filterView.snp.trailing).offset(Scale.scaleX(x: 8))
            make.width.equalTo(categoryTable)
            make.height.equalTo(CGFloat(FooyoCategory.amenities.count + 1) * (Scale.scaleY(y: 47.5)))
        }
        transportationTable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(categoryTable)
            make.leading.equalTo(filterView.snp.trailing).offset(Scale.scaleX(x: 8))
            make.width.equalTo(categoryTable)
            make.height.equalTo(CGFloat(FooyoCategory.transportations.count + 1) * (Scale.scaleY(y: 47.5)))
        }
    }
    
    
    func searchHandler() {
        if let sourceVC = sourceVC {
            gotoSearchPage(source: .FromItineraryEditMap, sourceVC: sourceVC)
        }
    }
    
    func filterHandler() {
        UIView.animate(withDuration: 0.3) {
            self.filterView.transform = CGAffineTransform.init(translationX: 0, y: -FooyoConstants.mainHeight)
        }
    }
    
    func dismissFilter() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.transportationTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.amenityTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.filterView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    func displayAmenities() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
            self.amenityTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
        }
    }
    
    
    func displayTransportations() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
            self.transportationTable.transform = CGAffineTransform.init(translationX: -FooyoConstants.mainWidth, y: 0)
        }
    }
    
    func displayCategories() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.transportationTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.amenityTable.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    func setConstraints() {
        overLay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    
        searchView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 10))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.leading.equalTo(Scale.scaleX(x: 10))
            make.trailing.equalTo(Scale.scaleX(x: -10))
        }
        searchField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        searchIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 20))
            make.trailing.equalTo(Scale.scaleX(x: -9))
        }
        itemTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchField.snp.bottom).offset(Scale.scaleY(y: 10))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func sortItems() {
        var index = 0
        for each in FooyoCategory.categories {
            let items = FooyoItem.items.filter({ (item) -> Bool in
                return item.category?.id == each.id
            })
            categoryItems[index] = items
            index = index + 1
        }
        itemTableView.reloadData()
    }
}

extension EditItineraryListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == itemTableView {
            if selectedCategory == nil {
                return FooyoCategory.categories.count
            } else {
                debugPrint("i am reloading with section number 1")
                return 1
            }
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case categoryTable:
            return FooyoCategory.others.count + 3
        case amenityTable:
            return FooyoCategory.amenities.count + 1
        case transportationTable:
            return FooyoCategory.transportations.count + 1
        default:
            if selectedCategory == nil {
                return categoryItems[section].count
            } else {
                return selectedCategoryItems.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.itemTableView {
            var item = FooyoItem()
            if selectedCategory == nil {
                let items = categoryItems[indexPath.section]
                item = items[indexPath.row]
            } else {
                item = selectedCategoryItems[indexPath.row]
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemSummaryTableViewCell.reuseIdentifier) as! ItemSummaryTableViewCell
            cell.configureWith(item: item, rightImage: UIImage.getBundleImage(name: "plan_add"))
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier) as! CategoryTableViewCell
        switch tableView {
        case categoryTable:
            switch indexPath.row {
            case 0:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Show All")
            case FooyoCategory.others.count + 1:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Amenities", rightIcon: UIImage.getBundleImage(name: "general_rightarrow"))
            case FooyoCategory.others.count + 2:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "basemap_all"), title: "Transportations", rightIcon: UIImage.getBundleImage(name: "general_rightarrow"))
            default:
                let category = FooyoCategory.others[indexPath.row - 1]
                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
            }
        case amenityTable:
            switch indexPath.row {
            case 0:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "general_leftarrow"), title: "Amenities", boldTitle: true)
            default:
                let category = FooyoCategory.amenities[indexPath.row - 1]
                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
            }
        case transportationTable:
            switch indexPath.row {
            case 0:
                cell.configureWith(leftIcon: UIImage.getBundleImage(name: "general_leftarrow"), title: "Transportations", boldTitle: true)
            default:
                let category = FooyoCategory.transportations[indexPath.row - 1]
                cell.configureWith(leftIcon: category.icon, title: category.name, rightIcon: nil)
            }
        default:
            return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.itemTableView {
            let t = UIView()
            t.backgroundColor = UIColor.white
            let upper = UIView()
            upper.backgroundColor = .white
            t.addSubview(upper)
            let lower = UIView()
            lower.backgroundColor = UIColor.ospGrey10
            t.addSubview(lower)
            let label = UILabel()
            //        label.text = "SEARCH HISTORY"
            if selectedCategory == nil {
                label.text = FooyoCategory.categories[section].name
            } else {
                label.text = selectedCategory?.name
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
        } else {
            return nil
        }

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.itemTableView {
            return Scale.scaleY(y: 36)
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.itemTableView {
            return Scale.scaleY(y: 55)
        }
        return Scale.scaleY(y: 47.5)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == self.itemTableView {
            var item = FooyoItem()
            if selectedCategory == nil {
                let items = categoryItems[indexPath.section]
                item = items[indexPath.row]
            } else {
                item = selectedCategoryItems[indexPath.row]
            }
            PostItineraryAddItemNotification(item: item)
            if let sourceVC = sourceVC {
                self.navigationController?.popToViewController(sourceVC, animated: true)
            }
        } else {
            switch tableView {
            case categoryTable:
                switch indexPath.row {
                case 0:
                    selectedCategory = nil
                    //                reloadMapIcons()
                    dismissFilter()
                case FooyoCategory.others.count + 1:
                    displayAmenities()
                case FooyoCategory.others.count + 2:
                    displayTransportations()
                default:
                    let category = FooyoCategory.others[indexPath.row - 1]
                    selectedCategory = category
                    let index = FooyoCategory.categories.index(of: selectedCategory!)
                    debugPrint(index)
                    selectedCategoryItems = categoryItems[index!]
                    debugPrint(selectedCategoryItems.count)
                    itemTableView.reloadData()
                    dismissFilter()
                    //                break
                }
            case amenityTable:
                switch indexPath.row {
                case 0:
                    displayCategories()
                default:
                    let category = FooyoCategory.amenities[indexPath.row - 1]
                    selectedCategory = category
                    let index = FooyoCategory.categories.index(of: selectedCategory!)
                    selectedCategoryItems = categoryItems[index!]
                    itemTableView.reloadData()
                    dismissFilter()
                }
            case transportationTable:
                switch indexPath.row {
                case 0:
                    displayCategories()
                default:
                    let category = FooyoCategory.transportations[indexPath.row - 1]
                    selectedCategory = category
                    let index = FooyoCategory.categories.index(of: selectedCategory!)
                    selectedCategoryItems = categoryItems[index!]
                    itemTableView.reloadData()
                    dismissFilter()
                }
            default:
                break
            }
        }
    }
}
