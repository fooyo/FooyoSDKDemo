////
////  ChooseThemeViewController.swift
////  SmartSentosa
////
////  Created by Yangfan Liu on 14/4/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import UIKit
////import SVProgressHUD
//
//extension UIImageView {
//    func applyBundleImage(name: String, replaceColor: UIColor? = nil) -> Void  {
//        let bundlePath: String = Bundle.main.path(forResource: "FooyoTestSDK", ofType: "bundle")!
//        let bundle = Bundle(path: bundlePath)
//        let resource: String = bundle!.path(forResource: name, ofType: "png")!
//        if let color = replaceColor {
//            self.image = UIImage(contentsOfFile: resource)?.imageByReplacingContentWithColor(color: color)
//        } else {
//            self.image = UIImage(contentsOfFile: resource)
//        }
//        //        return UIImage(contentsOfFile: resource)!
//    }
//}
//
// class ChooseThemeViewController: BaseViewController {
//    
////    fileprivate var selected: Int?
////    fileprivate var infoLabel: UILabel! = {
////        let t = UILabel()
////        t.text = "Which of the themes below best describes your trip?"
////        t.textColor = UIColor.sntGreyishBrown
////        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 20))
////        t.numberOfLines = 0
////        t.textAlignment = .center
////        return t
////    }()
////    
////    fileprivate var collectionView: UICollectionView! = {
////        let layout = UICollectionViewFlowLayout()
////        layout.sectionInset = UIEdgeInsets(top: 0, left: Scale.scaleX(x: 16), bottom: 0, right: Scale.scaleX(x: 16))
////        layout.itemSize = CGSize(width: Scale.scaleX(x: 195), height: Scale.scaleY(y: 264))
////        layout.minimumInteritemSpacing = Scale.scaleX(x: 21)
////        layout.minimumLineSpacing = Scale.scaleX(x: 21)
////        layout.scrollDirection = .horizontal
////        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
////        t.register(ThemeCollectionViewCell.self, forCellWithReuseIdentifier: ThemeCollectionViewCell.reuseIdentifier)
////        t.backgroundColor = UIColor.white
////        t.alwaysBounceHorizontal = true
////        return t
////    }()
////    
////    
////    fileprivate var autoBtn: GradientButton! = {
////        let t = GradientButton()
////        t.setTitle("Auto Generation", for: .normal)
////        t.layer.cornerRadius = 4
////        t.clipsToBounds = true
////        t.setTitleColor(.white, for: .normal)
////        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
////        return t
////    }()
////    fileprivate var manualBtn: GradientButton! = {
////        let t = GradientButton()
////        t.setTitle("Manual Creation", for: .normal)
////        t.layer.cornerRadius = 4
////        t.clipsToBounds = true
////        t.setTitleColor(.white, for: .normal)
////        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
////        return t
////    }()
////    fileprivate var autoIcon: UIImageView! = {
////        let t = UIImageView()
////        t.contentMode = .scaleAspectFit
//////        t.image = #imageLiteral(resourceName: "auto")
////        t.applyBundleImage(name: "auto")
////        return t
////    }()
////    fileprivate var manualIcon: UIImageView! = {
////        let t = UIImageView()
////        t.contentMode = .scaleAspectFit
////        t.applyBundleImage(name: "map_edit")
//////        t.image = #imageLiteral(resourceName: "map_edit").imageByReplacingContentWithColor(color: .white)
////        return t
////    }()
////    // MARK: - Life Cycle
////    
////    
////    override  func viewDidLoad() {
////        super.viewDidLoad()
////        // Do any additional setup after loading the view.        
////        navigationItem.title = "Choose Trip Themes"
////        view.addSubview(infoLabel)
////        view.addSubview(collectionView)
////        view.addSubview(autoBtn)
////        view.addSubview(manualBtn)
////        autoBtn.addSubview(autoIcon)
////        manualBtn.addSubview(manualIcon)
////        collectionView.delegate = self
////        collectionView.dataSource = self
////        autoBtn.addTarget(self, action: #selector(autoHandler), for: .touchUpInside)
////        manualBtn.addTarget(self, action: #selector(manualHandler), for: .touchUpInside)
////        setConstraints()
////    }
////
////    override  func didReceiveMemoryWarning() {
////        super.didReceiveMemoryWarning()
////        // Dispose of any resources that can be recreated.
////    }
////    
////    func saveHandler() {
////        
////    }
////    func manualHandler() {
////        
////    }
////    func autoHandler() {
////    }
////    
////    func loadItinerary(id: Int) {
////    }
////    
////    func setConstraints() {
////        infoLabel.snp.makeConstraints { (make) in
////            make.top.equalTo(Scale.scaleY(y: 50))
////            make.leading.equalTo(Scale.scaleX(x: 46))
////            make.trailing.equalTo(Scale.scaleX(x: -46))
////        }
////        collectionView.snp.makeConstraints { (make) in
////            make.top.equalTo(infoLabel.snp.bottom).offset(Scale.scaleY(y: 50))
////            make.leading.equalToSuperview()
////            make.trailing.equalToSuperview()
////            make.height.equalTo(Scale.scaleY(y: 264))
////        }
////        autoBtn.snp.makeConstraints { (make) in
////            make.height.equalTo(Scale.scaleY(y: 50))
////            make.leading.equalTo(Scale.scaleX(x: 16))
////            make.trailing.equalTo(Scale.scaleX(x: -16))
////            make.bottom.equalTo(manualBtn.snp.top).offset(Scale.scaleY(y: -16))
////        }
////        manualBtn.snp.makeConstraints { (make) in
////            make.height.equalTo(Scale.scaleY(y: 50))
////            make.leading.equalTo(Scale.scaleX(x: 16))
////            make.trailing.equalTo(Scale.scaleX(x: -16))
////            make.bottom.equalTo(Scale.scaleY(y: -16))
////        }
////        autoIcon.snp.makeConstraints { (make) in
////            make.centerY.equalTo(autoBtn)
////            make.width.height.equalTo(Scale.scaleY(y: 24))
////            make.leading.equalTo(Scale.scaleX(x: 50))
////        }
////        manualIcon.snp.makeConstraints { (make) in
////            make.centerY.equalTo(manualBtn)
////            make.width.height.equalTo(Scale.scaleY(y: 24))
////            make.leading.equalTo(Scale.scaleX(x: 50))
////        }
////    }
//}
//
//extension ChooseThemeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
////     func numberOfSections(in collectionView: UICollectionView) -> Int {
////        return 1
////    }
////    
////     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return Constants.themes.count
////    }
////     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let theme = Constants.themes[indexPath.row]
//////        let image = Constants.themesImage[indexPath.row]
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeCollectionViewCell.reuseIdentifier, for: indexPath) as! ThemeCollectionViewCell
////        cell.configureWith(theme: theme)
//////        if selected.contains(indexPath.row) {
////        if selected == indexPath.row {
////            cell.selected()
////        } else {
////            cell.deselected()
////        }
////        return cell
////    }
////     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        collectionView.deselectItem(at: indexPath, animated: false)
//////        if selected.contains(indexPath.row) {
//////            selected.remove(at: selected.index(of: indexPath.row)!)
//////        } else {
//////            selected.append(indexPath.row)
//////        }
////        let theme = Constants.themes[indexPath.row]
////        let name = theme.rawValue
////        
////        selected = indexPath.row
////        
////        collectionView.reloadData()
////    }
//}
