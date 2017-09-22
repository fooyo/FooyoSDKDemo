//
//  CreatePlanViewController.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 28/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import JVFloatLabeledText
import CoreActionSheetPicker
import TPKeyboardAvoidingKit

public protocol FooyoCreatePlanViewControllerDelegate: class {
    func fooyoCreatePlanViewController(didSaved success: Bool)
    func fooyoCreatePlanViewController(didCanceled success: Bool)
}

public class FooyoCreatePlanViewController: UIViewController {

    weak public var delegate: FooyoCreatePlanViewControllerDelegate?
    
    
    var mustGoPlaces: [FooyoItem]?
    fileprivate var planTitle: String?
    fileprivate var planBudget: Double?
    fileprivate var planTime: String?
    fileprivate var planType: String?
    
    fileprivate var container: TPKeyboardAvoidingScrollView! = {
        let t = TPKeyboardAvoidingScrollView()
        t.backgroundColor = .white
        return t
    }()
    fileprivate var titleField: JVFloatLabeledTextField! = {
        let t = JVFloatLabeledTextField()
        t.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Set a title (eg. Fun day out)", comment: ""), attributes: [NSForegroundColorAttributeName: UIColor.ospDarkGrey, NSFontAttributeName: UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))])
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.floatingLabelFont = UIFont.DefaultRegularWithSize(size: 10)
        t.floatingLabelTextColor = UIColor.ospDarkGrey
        t.floatingLabelActiveTextColor = UIColor.ospDarkGrey
        t.clearButtonMode = .whileEditing
        t.translatesAutoresizingMaskIntoConstraints = false
        t.keepBaseline = true
        return t
    }()
    fileprivate var titleLine: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    
    fileprivate var dateField: JVFloatLabeledTextField! = {
        let t = JVFloatLabeledTextField()
        t.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("When will you arrive?", comment: ""), attributes: [NSForegroundColorAttributeName: UIColor.ospDarkGrey, NSFontAttributeName: UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))])

        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.floatingLabelFont = UIFont.DefaultRegularWithSize(size: 10)
        t.floatingLabelTextColor = UIColor.ospDarkGrey
        t.floatingLabelActiveTextColor = UIColor.ospDarkGrey
        t.clearButtonMode = .whileEditing
        t.translatesAutoresizingMaskIntoConstraints = false
        t.keepBaseline = true
        t.isUserInteractionEnabled = false
        return t
    }()
    fileprivate var dateFakeView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        return t
    }()
    
    fileprivate var dateLine: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    
    fileprivate var budgetField: JVFloatLabeledTextField! = {
        let t = JVFloatLabeledTextField()
        t.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Budget per person?", comment: ""), attributes: [NSForegroundColorAttributeName: UIColor.ospDarkGrey, NSFontAttributeName: UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))])
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.floatingLabelFont = UIFont.DefaultRegularWithSize(size: 10)
        t.floatingLabelTextColor = UIColor.ospDarkGrey
        t.floatingLabelActiveTextColor = UIColor.ospDarkGrey
        t.clearButtonMode = .whileEditing
        t.translatesAutoresizingMaskIntoConstraints = false
        t.keepBaseline = true
        t.isUserInteractionEnabled = false
        return t
    }()
    
    fileprivate var budgetFakeView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        t.isUserInteractionEnabled = true
        return t
    }()
    
    fileprivate var budgetLine: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    
    fileprivate var budgetLabel: UILabel! = {
        let t = UILabel()
        t.numberOfLines = 0
        t.text = "These information will help us generate relevant recommendations for your needs."
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 10))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    
    fileprivate var pillIndex = 0
    fileprivate var pillTitle: UILabel! = {
        let t = UILabel()
        t.textColor = .black
        t.text = "How long will you be there for?"
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    
    fileprivate var pillView: UIView! = {
        let t = UIView()
        t.clipsToBounds = true
        t.layer.cornerRadius = Scale.scaleY(y: 28) / 2
        return t
    }()
    
    fileprivate var pillOne: UIButton! = {
        let t = UIButton()
        t.setTitle("Morning", for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.setTitleColor(.white, for: .normal)
        t.backgroundColor = UIColor.ospSentosaBlue
        t.tag = 0
        return t
    }()
    fileprivate var pillTwo: UIButton! = {
        let t = UIButton()
        t.setTitle("Afternoon", for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.setTitleColor(.white, for: .normal)
        t.backgroundColor = UIColor.ospSentosaBlue
        t.tag = 1
        return t
    }()
    fileprivate var pillThree: UIButton! = {
        let t = UIButton()
        t.setTitle("Full day", for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.setTitleColor(.white, for: .normal)
        t.backgroundColor = UIColor.ospSentosaBlue
        t.tag = 2
        return t
    }()
    fileprivate var pillLineOne: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    fileprivate var pillLineTwo: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    fileprivate var continueBtn: UIButton! = {
        let t = UIButton()
        t.backgroundColor = UIColor.ospSentosaGreen
        t.layer.cornerRadius = Scale.scaleY(y: 40) / 2
        t.setTitle("NEXT", for: .normal)
        t.setTitleColor(.white, for: .normal)
        t.titleLabel?.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        return t
    }()
    
    // MARK: - Life Cycle
    public init(userId: String) {
        super.init(nibName: nil, bundle: nil)
        FooyoUser.currentUser.userId = userId
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(itinerarySaved), name: FooyoConstants.notifications.FooyoSavedItinerary, object: nil)

        let leftBtn = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.applyGeneralVCSettings(vc: self)
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)), name: FooyoConstants.notifications.FooyoDisplayAlert, object: nil)

        self.navigationItem.title = "Create your day plan"
        view.addSubview(container)

        container.addSubview(titleField)
        titleField.addTarget(self, action: #selector(titleHandler), for: .editingChanged)
        titleField.addSubview(titleLine)
        container.addSubview(dateField)
        container.addSubview(dateFakeView)
        let dateGesture = UITapGestureRecognizer(target: self, action: #selector(dateHandler))
        dateFakeView.addGestureRecognizer(dateGesture)
        dateField.addSubview(dateLine)
        container.addSubview(pillTitle)
        container.addSubview(pillView)
        pillView.addSubview(pillOne)
        pillView.addSubview(pillLineOne)
        pillView.addSubview(pillTwo)
        pillView.addSubview(pillLineTwo)
        pillView.addSubview(pillThree)
        pillOne.addTarget(self, action: #selector(pillHandler(sender:)), for: .touchUpInside)
        pillTwo.addTarget(self, action: #selector(pillHandler(sender:)), for: .touchUpInside)
        pillThree.addTarget(self, action: #selector(pillHandler(sender:)), for: .touchUpInside)
        pillHandler()   
        container.addSubview(budgetField)
        container.addSubview(budgetFakeView)
        let budgetGesture = UITapGestureRecognizer(target: self, action: #selector(budgetHandler))
        budgetFakeView.addGestureRecognizer(budgetGesture)
        
        budgetField.addSubview(budgetLine)
        container.addSubview(budgetLabel)
        container.addSubview(continueBtn)
        continueBtn.addTarget(self, action: #selector(continueHandler), for: .touchUpInside)
        titleField.delegate = self
        setConstraints()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func titleHandler() {
        let text = titleField.text
        if text != "" {
            planTitle = text
        } else {
            planTitle = nil
        }
    }
    
    
    func pillHandler(sender: UIButton? = nil) {
        if let sender = sender {
            pillIndex = sender.tag
        }
        switch pillIndex {
        case 0:
            pillOne.backgroundColor = UIColor.ospSentosaBlue
            pillOne.setTitleColor(UIColor.white, for: .normal)
            pillLineOne.backgroundColor = UIColor.ospSentosaBlue
            pillTwo.backgroundColor = UIColor.ospGrey20
            pillTwo.setTitleColor(UIColor.ospDarkGrey, for: .normal)
            pillLineTwo.backgroundColor = UIColor.ospGrey
            pillThree.backgroundColor = UIColor.ospGrey20
            pillThree.setTitleColor(UIColor.ospDarkGrey, for: .normal)
            planType = FooyoConstants.tripType.HalfDayMorning.rawValue
        case 1:
            pillOne.backgroundColor = UIColor.ospGrey20
            pillOne.setTitleColor(UIColor.ospDarkGrey, for: .normal)
            pillLineOne.backgroundColor = UIColor.ospSentosaBlue
            pillTwo.backgroundColor = UIColor.ospSentosaBlue
            pillTwo.setTitleColor(UIColor.white, for: .normal)
            pillLineTwo.backgroundColor = UIColor.ospSentosaBlue
            pillThree.backgroundColor = UIColor.ospGrey20
            pillThree.setTitleColor(UIColor.ospDarkGrey, for: .normal)
            planType = FooyoConstants.tripType.HalfDayAfternoon.rawValue
        default:
            pillOne.backgroundColor = UIColor.ospGrey20
            pillOne.setTitleColor(UIColor.ospDarkGrey, for: .normal)
            pillLineOne.backgroundColor = UIColor.ospGrey
            pillTwo.backgroundColor = UIColor.ospGrey20
            pillTwo.setTitleColor(UIColor.ospDarkGrey, for: .normal)
            pillLineTwo.backgroundColor = UIColor.ospSentosaBlue
            pillThree.backgroundColor = UIColor.ospSentosaBlue
            pillThree.setTitleColor(UIColor.white, for: .normal)
            planType = FooyoConstants.tripType.FullDay.rawValue
        }
        
    }
    
    func viewHandler() {
        featureUnavailable()
    }
    
    func cancelHandler() {
        delegate?.fooyoCreatePlanViewController(didCanceled: true)
        _ = dismiss(animated: true, completion: nil)
    }
    func continueHandler() {
//        guard planTitle != nil else {
//            displayAlert(title: "Reminder", message: "The title cannot be empty.", complete: nil)
//            return
//        }
//        guard planTime != nil else {
//            displayAlert(title: "Reminder", message: "The arrival date cannot be empty.", complete: nil)
//            return
//        }
//        guard planBudget != nil else {
//            displayAlert(title: "Reminder", message: "The budget cannot be empty.", complete: nil)
//            return
//        }
//        FooyoItinerary.newItinerary.name = planTitle
//        FooyoItinerary.newItinerary.budget = planBudget
//        FooyoItinerary.newItinerary.time = planTime
//        FooyoItinerary.newItinerary.tripType = planType

        FooyoItinerary.newItinerary = FooyoItinerary()
        FooyoItinerary.newItinerary.items = mustGoPlaces
        FooyoItinerary.newItinerary.name = "TEST"
        FooyoItinerary.newItinerary.budget = 50
        FooyoItinerary.newItinerary.tripType = FooyoConstants.tripType.FullDay.rawValue
        FooyoItinerary.newItinerary.time = DateTimeTool.fromDateToFormatThree(date: Date())
        let vc = ChooseThemeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dateHandler() {
        view.endEditing(true)
        let startDate = Date()
        let datePicker = ActionSheetDatePicker(title: "Arrival Date", datePickerMode: .date, selectedDate: startDate, doneBlock: {
            picker, value, index in
            
            if let value = value as? Date {
                self.dateField.text = DateTimeTool.fromDateToFormatFive(date: value)
                self.planTime = DateTimeTool.fromDateToFormatThree(date: value)
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: view)
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        cancel.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.ospBlack], for: .normal)
        let done = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
        done.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.ospBlack], for: .normal)
        
        datePicker?.setCancelButton(cancel)
        datePicker?.setDoneButton(done)
        datePicker?.show()

    }
    
    func budgetHandler() {
        view.endEditing(true)
        let picker = ActionSheetStringPicker(title: "Select Budget", rows: ["Less than $50", "$50-$150", "$150 and above"], initialSelection: 0, doneBlock: { (picker, index, value) in
            self.budgetField.text = value as? String
            switch index {
            case 0:
                self.planBudget = 50
            case 1:
                self.planBudget = 150
            default:
                self.planBudget = 10000
            }
        }, cancel: { (picker) in
            return
        }, origin: view)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        cancel.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.ospBlack], for: .normal)
        let done = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
        done.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.ospBlack], for: .normal)
        
        picker?.setCancelButton(cancel)
        picker?.setDoneButton(done)
        picker?.show()
    }
    
    func displayAlert(notification: Notification) {
        if let info = notification.object as? [String: String] {
            let title = info["title"] ?? ""
            let msg = info["message"] ?? ""
            displayAlert(title: title, message: msg, complete: nil)
        }
    }
    func setConstraints() {
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleField.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(Scale.scaleY(y: 20))
            make.leading.equalTo(view).offset(Scale.scaleX(x: 20))
            make.trailing.equalTo(view).offset(Scale.scaleX(x: -20))
            make.height.equalTo(Scale.scaleY(y: 40))
        }
        titleLine.snp.makeConstraints { (make) in
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        dateField.snp.makeConstraints { (make) in
            make.top.equalTo(titleField.snp.bottom).offset(Scale.scaleY(y: 35))
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.height.equalTo(Scale.scaleY(y: 40))
        }
        dateFakeView.snp.makeConstraints { (make) in
            make.edges.equalTo(dateField)
        }
        dateLine.snp.makeConstraints { (make) in
            make.leading.equalTo(dateField)
            make.trailing.equalTo(dateField)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        pillTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.top.equalTo(dateLine.snp.bottom).offset(Scale.scaleY(y: 35))
        }
        pillView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.top.equalTo(pillTitle.snp.bottom).offset(Scale.scaleY(y: 5))
            make.height.equalTo(Scale.scaleY(y: 28))
        }
        pillOne.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        pillLineOne.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(pillOne.snp.trailing)
            make.width.equalTo(1)
        }
        pillTwo.snp.makeConstraints { (make) in
            make.leading.equalTo(pillLineOne.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(pillOne)
        }
        pillLineTwo.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
            make.leading.equalTo(pillTwo.snp.trailing)
        }
        pillThree.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(pillOne)
            make.leading.equalTo(pillLineTwo.snp.trailing)
        }
        budgetField.snp.makeConstraints { (make) in
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.top.equalTo(pillView.snp.bottom).offset(Scale.scaleY(y: 35))
            make.height.equalTo(Scale.scaleY(y: 40))
        }
        budgetFakeView.snp.makeConstraints { (make) in
            make.edges.equalTo(budgetField)
        }
        budgetLine.snp.makeConstraints { (make) in
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        budgetLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.top.equalTo(budgetLine.snp.bottom).offset(Scale.scaleY(y: 5))
        }
        continueBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(Scale.scaleX(x: 22))
            make.trailing.equalTo(view).offset(Scale.scaleX(x: -22))
            make.height.equalTo(Scale.scaleY(y: 40))
            make.bottom.equalTo(view).offset(Scale.scaleY(y: -10))
        }

    }
    
}

extension FooyoCreatePlanViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
}

extension FooyoCreatePlanViewController {
    func itinerarySaved() {
        delegate?.fooyoCreatePlanViewController(didSaved: true)
    }
}
