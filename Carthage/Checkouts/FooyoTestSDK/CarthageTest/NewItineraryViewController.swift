////
////  NewItineraryViewController.swift
////  SmartSentosa
////
////  Created by Yangfan Liu on 14/4/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import UIKit
//import TGPControls
//
//enum Selected {
//    case Date
//    case Time
//    case Duration
//}
////func applyBundleImage(name: String) -> Void  {
////    let bundlePath: String = Bundle.main.path(forResource: "FooyoTestSDK", ofType: "bundle")!
////    let bundle = Bundle(path: bundlePath)
////    let resource: String = bundle!.path(forResource: name, ofType: "png")!
////    self.image = UIImage(contentsOfFile: resource)
////    //        return UIImage(contentsOfFile: resource)!
////}
//
////extension UIImageView {
////    func applyBundleImage(name: String) -> Void  {
////        let bundlePath: String = Bundle.main.path(forResource: "FooyoTestSDK", ofType: "bundle")!
////        let bundle = Bundle(path: bundlePath)
////        let resource: String = bundle!.path(forResource: name, ofType: "png")!
////        self.image = UIImage(contentsOfFile: resource)
////        //        return UIImage(contentsOfFile: resource)!
////    }
////}
//
//public class FooyoSDKNewItineraryViewController: BaseViewController {
//    
//    fileprivate var selected: Selected?
//
//    var dateDownArrow: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "dropdown_arrow_down")
//        t.contentMode = .center
//        return t
//    }()
//    
//    fileprivate var timeDownArrow: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "dropdown_arrow_down")
////        t.image.replace
//        t.contentMode = .center
//        return t
//    }()
//    
//    fileprivate var durationDownArrow: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "dropdown_arrow_down")
//        t.contentMode = .center
//        return t
//    }()
//    
//    fileprivate var durationUpArrow: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "dropdown_arrow_up")
//        t.contentMode = .center
//        return t
//    }()
//    
//    fileprivate var dateUpArrow: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "dropdown_arrow_up")
//        t.contentMode = .center
//        return t
//    }()
//    
//    fileprivate var timeUpArrow: UIImageView! = {
//        let t = UIImageView()
//        t.applyBundleImage(name: "dropdown_arrow_up")
//        t.contentMode = .center
//        return t
//    }()
//    fileprivate var dateLabel: UILabel! = {
//        let t = UILabel()
//        t.backgroundColor = UIColor.sntWhite
//        t.layer.cornerRadius = 4
//        t.clipsToBounds = true
//        t.textColor = UIColor.sntGreyishBrown
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 17))
//        t.textAlignment = .center
//        t.isUserInteractionEnabled = true
////        t.text = DateTimeTool.fromDateToFormatTwo(date: Date())
//        return t
//    }()
//    fileprivate var timeLabel: UILabel! = {
//        let t = UILabel()
//        t.backgroundColor = UIColor.sntWhite
//        t.layer.cornerRadius = 4
//        t.clipsToBounds = true
//        t.textColor = UIColor.sntGreyishBrown
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 17))
//        t.textAlignment = .center
//        t.isUserInteractionEnabled = true
//        t.text = "Morning"
//        return t
//    }()
//    fileprivate var durationLabel: UILabel! = {
//        let t = UILabel()
//        t.backgroundColor = UIColor.sntWhite
//        t.layer.cornerRadius = 4
//        t.clipsToBounds = true
//        t.textColor = UIColor.sntGreyishBrown
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 17))
//        t.textAlignment = .center
//        t.isUserInteractionEnabled = true
//        t.text = "One Full Day"
//        return t
//    }()
//    fileprivate var dateTitleLabel: UILabel! = {
//        let t = UILabel()
//        t.textColor = UIColor.sntGreyishBrown
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        t.text = "When is your trip?"
//        return t
//    }()
//    fileprivate var durationTitleLabel: UILabel! = {
//        let t = UILabel()
//        t.textColor = UIColor.sntGreyishBrown
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        t.text = "How long is your trip?"
//        return t
//    }()
//    fileprivate var budgetTitleLabel: UILabel! = {
//        let t = UILabel()
//        t.textColor = UIColor.sntGreyishBrown
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        t.text = "What is your budget (per pax)?"
//        return t
//    }()
//        fileprivate var pickerView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = UIColor.sntWhite
//        return t
//    }()
//    fileprivate var doneBtn: UIButton! = {
//        let t = UIButton()
//        t.setTitle("Done", for: .normal)
//        t.setTitleColor(UIColor.sntMelon, for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        return t
//    }()
//    fileprivate var lineView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .lightGray
//        return t
//    }()
//    fileprivate var customizedPickerView: UIPickerView! = {
//        let t = UIPickerView()
//        t.backgroundColor = .white
//        t.showsSelectionIndicator = true
//        return t
//    }()
//    fileprivate var datePickView: UIDatePicker! = {
//        let t = UIDatePicker()
//        t.datePickerMode = .date
//        t.backgroundColor = .white
//        t.minimumDate = Date()
//        return t
//    }()
//    fileprivate var slider: TGPDiscreteSlider = {
//        let t = TGPDiscreteSlider()
//        t.minimumValue = 0
////        t.tickCount = 8
//        t.tickCount = 4
//        t.tickStyle = 0
//        t.backgroundColor = .clear
//        t.tintColor = UIColor.sntTomato
//        return t
//    }()
//    
//    fileprivate var priceLabels: TGPCamelLabels! = {
//        let t = TGPCamelLabels()
////        t.names = ["50", "75", "100", "125", "150", "175", "200", "Any"]
//        t.names = ["50", "100", "150", "Any"]
//        t.upFontSize = Scale.scaleY(y: 14)
//        t.upFontColor = UIColor.sntTomato
//        t.downFontSize = Scale.scaleY(y: 14)
////        t.downFontColor = UIColor
//        return t
//    }()
//    
//    fileprivate var continueBtn: UIButton! = {
//        let t = UIButton()
//        t.setTitle("Continue", for: .normal)
//        t.layer.cornerRadius = 4
//        t.clipsToBounds = true
//        t.setTitleColor(.white, for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        return t
//    }()
//    
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        navigationController?.navigationBar.isTranslucent = false
//
//        navigationItem.title = "Create New Itinerary"
//        let leftBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler))
//        navigationItem.leftBarButtonItem = leftBtn
//        view.addSubview(dateTitleLabel)
//        view.addSubview(dateLabel)
//        dateLabel.addSubview(dateUpArrow)
//        dateLabel.addSubview(dateDownArrow)
////        dateDownArrow.setbu
////        dateDownArrow.setbu
////        dateDownArrow.setBundleImage(name: "")
//        view.addSubview(timeLabel)
//        timeLabel.addSubview(timeUpArrow)
//        timeLabel.addSubview(timeDownArrow)
//        view.addSubview(durationTitleLabel)
//        view.addSubview(durationLabel)
//        durationLabel.addSubview(durationUpArrow)
//        durationLabel.addSubview(durationDownArrow)
//        view.addSubview(budgetTitleLabel)
//        view.addSubview(priceLabels)
//        view.addSubview(slider)
//        slider.ticksListener = priceLabels
//        view.addSubview(continueBtn)
//        view.addSubview(pickerView)
//        pickerView.addSubview(doneBtn)
//        pickerView.addSubview(lineView)
//        pickerView.addSubview(datePickView)
//        pickerView.addSubview(customizedPickerView)
//        customizedPickerView.delegate = self
//        customizedPickerView.dataSource = self
//        setConstraints()
//        checkSelected()
//        let gestureOne = UITapGestureRecognizer(target: self, action: #selector(dateHandler))
//        dateLabel.addGestureRecognizer(gestureOne)
//        let gestureTwo = UITapGestureRecognizer(target: self, action: #selector(timeHandler))
//        timeLabel.addGestureRecognizer(gestureTwo)
//        let gestureThree = UITapGestureRecognizer(target: self, action: #selector(durationHandler))
//        durationLabel.addGestureRecognizer(gestureThree)
//        doneBtn.addTarget(self, action: #selector(doneHandler), for: .touchUpInside)
//        datePickView.addTarget(self, action: #selector(datePickHandler), for: .valueChanged)
//        slider.addTarget(self, action: #selector(sliderHandler), for: .valueChanged)
//        continueBtn.addTarget(self, action: #selector(continueHandler), for: .touchUpInside)
//    }
//
//    override public func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func cancelHandler() {
//        _ = self.navigationController?.dismiss(animated: true, completion: nil)
//    }
//    func continueHandler() {
//        let vc = ChooseThemeViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func sliderHandler() {
//        debugPrint(slider.value)
//        
//    }
//    func datePickHandler() {
//        let date = datePickView.date
//        dateLabel.text = DateTimeTool.fromDateToFormatTwo(date: date)
//    }
//    
//    func doneHandler() {
//        UIView.animate(withDuration: 0.3) { 
//            self.pickerView.transform = CGAffineTransform(translationX: 0, y: 0)
//        }
//        selected = nil
//        checkSelected()
//    }
//    func dateHandler() {
//        selected = .Date
//        checkSelected()
//        datePickView.isHidden = false
//        customizedPickerView.isHidden = true
//        UIView.animate(withDuration: 0.3) {
//            self.pickerView.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -240))
//        }
//    }
//    func timeHandler() {
//        selected = .Time
//        checkSelected()
//        datePickView.isHidden = true
//        customizedPickerView.isHidden = false
//        customizedPickerView.reloadAllComponents()
//        setLocation()
//        UIView.animate(withDuration: 0.3) {
//            self.pickerView.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -240))
//        }
//    }
//    func durationHandler() {
//        selected = .Duration
//        checkSelected()
//        datePickView.isHidden = true
//        customizedPickerView.isHidden = false
//        customizedPickerView.reloadAllComponents()
//        setLocation()
//        UIView.animate(withDuration: 0.3) {
//            self.pickerView.transform = CGAffineTransform(translationX: 0, y: Scale.scaleY(y: -240))
//        }
//    }
//    
//    func setLocation() {
//        if let selected = selected {
//            switch selected {
//            case .Time:
//                let time = timeLabel.text!
//                let index = Constants.tripTimeSource.index(of: time)
//                customizedPickerView.selectRow(index!, inComponent: 0, animated: true)
//            case .Duration:
//                let duration = durationLabel.text!
//                let index = Constants.tripDurationSource.index(of: duration)
//                customizedPickerView.selectRow(index!, inComponent: 0, animated: true)
//            default:
//                break
//            }
//        }
//    }
//    func checkSelected() {
//        if let selected = selected {
//            if selected == .Date {
//                dateDownArrow.isHidden = true
//                dateUpArrow.isHidden = false
//                
//                timeDownArrow.isHidden = false
//                timeUpArrow.isHidden = true
//                
//                durationDownArrow.isHidden = false
//                durationUpArrow.isHidden = true
//            } else if selected == .Time {
//                
//                dateDownArrow.isHidden = false
//                dateUpArrow.isHidden = true
//                
//                timeDownArrow.isHidden = true
//                timeUpArrow.isHidden = false
//                
//                durationDownArrow.isHidden = false
//                durationUpArrow.isHidden = true
//            } else if selected == .Duration {
//                
//                dateDownArrow.isHidden = false
//                dateUpArrow.isHidden = true
//                
//                timeDownArrow.isHidden = false
//                timeUpArrow.isHidden = true
//                
//                durationDownArrow.isHidden = true
//                durationUpArrow.isHidden = false
//            }
//        } else {
//            
//            dateDownArrow.isHidden = false
//            dateUpArrow.isHidden = true
//            
//            timeDownArrow.isHidden = false
//            timeUpArrow.isHidden = true
//            
//            durationDownArrow.isHidden = false
//            durationUpArrow.isHidden = true
//        }
//    }
//    func setConstraints() {
//        dateTitleLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 16))
//            make.top.equalTo(Scale.scaleY(y: 48))
//        }
//        dateLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(dateTitleLabel)
//            make.height.equalTo(Scale.scaleY(y: 49))
//            make.top.equalTo(dateTitleLabel.snp.bottom).offset(Scale.scaleY(y: 8))
//            make.width.equalTo(Scale.scaleX(x: 183))
//        }
//        dateDownArrow.snp.makeConstraints { (make) in
//            make.trailing.equalTo(Scale.scaleX(x: -12))
//            make.centerY.equalTo(dateLabel)
//            make.height.equalTo(Scale.scaleY(y: 16))
//            make.width.equalTo(Scale.scaleX(x: 10))
//        }
//        dateUpArrow.snp.makeConstraints { (make) in
//            make.edges.equalTo(dateDownArrow)
//        }
//        timeLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(dateLabel.snp.trailing).offset(Scale.scaleX(x: 16))
//            make.centerY.equalTo(dateLabel)
//            make.trailing.equalTo(Scale.scaleX(x: -16))
//            make.height.equalTo(dateLabel)
//        }
//        timeDownArrow.snp.makeConstraints { (make) in
//            make.trailing.equalTo(Scale.scaleX(x: -12))
//            make.centerY.equalTo(timeLabel)
//            make.height.equalTo(Scale.scaleY(y: 16))
//            make.width.equalTo(Scale.scaleX(x: 10))
//        }
//        timeUpArrow.snp.makeConstraints { (make) in
//            make.edges.equalTo(timeDownArrow)
//        }
//        durationTitleLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(dateTitleLabel)
//            make.top.equalTo(dateLabel.snp.bottom).offset(Scale.scaleY(y: 48))
//        }
//        durationLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(dateLabel)
//            make.trailing.equalTo(timeLabel)
//            make.height.equalTo(dateLabel)
//            make.top.equalTo(durationTitleLabel.snp.bottom).offset(Scale.scaleY(y: 8))
//        }
//        durationDownArrow.snp.makeConstraints { (make) in
//            make.trailing.equalTo(Scale.scaleX(x: -12))
//            make.centerY.equalTo(durationLabel)
//            make.height.equalTo(Scale.scaleY(y: 16))
//            make.width.equalTo(Scale.scaleX(x: 10))
//        }
//        durationUpArrow.snp.makeConstraints { (make) in
//            make.edges.equalTo(durationDownArrow)
//        }
//        budgetTitleLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(durationTitleLabel)
//            make.top.equalTo(durationLabel.snp.bottom).offset(Scale.scaleY(y: 48))
//        }
//        pickerView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.top.equalTo(view.snp.bottom)
//            make.height.equalTo(Scale.scaleY(y: 240))
//        }
//        doneBtn.snp.makeConstraints { (make) in
//            make.trailing.equalToSuperview().offset(Scale.scaleX(x: -20))
//            make.top.equalToSuperview()
//            make.height.equalTo(Scale.scaleY(y: 40))
//        }
//        lineView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.height.equalTo(0.5)
//            make.top.equalTo(doneBtn.snp.bottom)
//        }
//        datePickView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.top.equalTo(lineView.snp.bottom)
//        }
//        customizedPickerView.snp.makeConstraints { (make) in
//            make.edges.equalTo(datePickView)
//        }
//        slider.snp.makeConstraints { (make) in
//            make.top.equalTo(budgetTitleLabel.snp.bottom).offset(Scale.scaleY(y: 60))
//            make.leading.equalTo(budgetTitleLabel.snp.leading)
//            make.trailing.equalTo(timeLabel.snp.trailing)
//            make.height.equalTo(Scale.scaleY(y: 44))
//        }
//        priceLabels.snp.makeConstraints { (make) in
//            make.bottom.equalTo(slider.snp.top).offset(Scale.scaleY(y: -5))
//            make.leading.equalTo(budgetTitleLabel.snp.leading)
//            make.trailing.equalTo(timeLabel.snp.trailing)
//            make.height.equalTo(Scale.scaleY(y: 30))
//        }
//        continueBtn.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 16))
//            make.trailing.equalTo(Scale.scaleX(x: -16))
//            make.height.equalTo(Scale.scaleY(y: 50))
//            make.bottom.equalTo(Scale.scaleY(y: -16))
//        }
//    }
//}
//
//extension FooyoSDKNewItineraryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        if let selected = selected {
//            debugPrint(selected)
//            if selected == .Duration || selected == .Time {
//                return 1
//            }
//        }
//        return 0
//    }
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if let selected = selected {
//            debugPrint(selected)
//            switch selected {
//            case .Time:
//                return Constants.tripTimeSource.count
//            default:
//                return Constants.tripDurationSource.count
//            }
//        }
//        return 0
//    }
//    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if let selected = selected {
//            switch selected {
//            case .Time:
//                return Constants.tripTimeSource[row]
//            default:
//                return Constants.tripDurationSource[row]
//            }
//        }
//        return nil
//    }
//    
//    
//    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if let selected = selected {
//            switch selected {
//            case .Time:
//                timeLabel.text = Constants.tripTimeSource[row]
//            case .Duration:
//                durationLabel.text = Constants.tripDurationSource[row]
//            default:
//                break
//            }
//        }
//    }
//    
//    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return Scale.scaleY(y: 30)
//    }
//}
//
////extension NewItineraryViewController: uide
