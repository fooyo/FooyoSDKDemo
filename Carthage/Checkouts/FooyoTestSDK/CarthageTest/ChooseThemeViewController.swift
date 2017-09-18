//
//  ChooseThemeViewController.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 14/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
//import SVProgressHUD

 class ChooseThemeViewController: BaseViewController {

    fileprivate var selected: Int?
    fileprivate var infoLabel: UILabel! = {
        let t = UILabel()
        t.text = "Which of the following themes can best describe your plan?"
        t.textColor = UIColor.black
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        t.numberOfLines = 0
        t.textAlignment = .center
        return t
    }()
    
    fileprivate var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: Scale.scaleX(x: 20), bottom: 0, right: Scale.scaleX(x: 20))
        layout.itemSize = CGSize(width: Scale.scaleX(x: 260), height: Scale.scaleY(y: 235))
        layout.minimumInteritemSpacing = Scale.scaleX(x: 20)
        layout.minimumLineSpacing = Scale.scaleX(x: 20)
        layout.scrollDirection = .horizontal
        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        t.register(ThemeCollectionViewCell.self, forCellWithReuseIdentifier: ThemeCollectionViewCell.reuseIdentifier)
        t.backgroundColor = UIColor.white
        t.alwaysBounceHorizontal = true
        return t
    }()
    
    
    fileprivate var autoBtn: UIButton! = {
        let t = UIButton()
        t.backgroundColor = UIColor.ospSentosaGreen
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.setTitle("AUTO GENERATION", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        return t
    }()

    fileprivate var manualBtn: UIButton! = {
        let t = UIButton()
        t.backgroundColor = UIColor.ospSentosaBlue
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.setTitle("MANUAL CREATION", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        return t
    }()

    // MARK: - Life Cycle
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
        navigationItem.title = "Create your day plan"
        view.addSubview(infoLabel)
        view.addSubview(collectionView)
        view.addSubview(autoBtn)
        view.addSubview(manualBtn)
        collectionView.delegate = self
        collectionView.dataSource = self
        autoBtn.addTarget(self, action: #selector(autoHandler), for: .touchUpInside)
        manualBtn.addTarget(self, action: #selector(manualHandler), for: .touchUpInside)
        setConstraints()
    }

    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func manualHandler() {
        if let selected = selected {
            FooyoItinerary.newItinerary.theme = FooyoConstants.themes[selected].rawValue
            let vc = EditItineraryViewController(itinerary: FooyoItinerary.newItinerary)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            displayAlert(title: "Warning", message: "Please choose your theme.", complete: nil)
        }
    }
    func autoHandler() {
        featureUnavailable()
    }
    
    func setConstraints() {
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 20))
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(Scale.scaleY(y: 50))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 264))
        }
        autoBtn.snp.makeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 40))
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
            make.bottom.equalTo(manualBtn.snp.top).offset(Scale.scaleY(y: -10))
        }
        manualBtn.snp.makeConstraints { (make) in
            make.height.equalTo(Scale.scaleY(y: 40))
            make.leading.equalTo(Scale.scaleX(x: 20))
            make.trailing.equalTo(Scale.scaleX(x: -20))
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
    }
}

extension ChooseThemeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FooyoConstants.themes.count
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let theme = FooyoConstants.themes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeCollectionViewCell.reuseIdentifier, for: indexPath) as! ThemeCollectionViewCell
        cell.configureWith(theme: theme)
        if selected == indexPath.row {
            cell.selected()
        } else {
            cell.deselected()
        }
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let theme = FooyoConstants.themes[indexPath.row]
        let name = theme.rawValue
        
        selected = indexPath.row
        
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
