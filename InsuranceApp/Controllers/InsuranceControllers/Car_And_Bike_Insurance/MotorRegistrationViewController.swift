//
//  MotorRegistrationViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 02/12/21.
//

import Foundation
import UIKit

class MotorRegistrationViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var refreshBtn: UIButton!
    
    @IBOutlet weak var insuranceNameLbl: UILabel!
    @IBOutlet weak var insuranceImage: UIImageView!
    @IBOutlet weak var insuranceDescription: UILabel!
    
    @IBOutlet weak var registerAreaView: UIView!
    @IBOutlet weak var registerAreaLbl: UILabel!
    @IBOutlet weak var registerAreaField: UITextField!
    
    @IBOutlet weak var manufactureView: UIView!
    @IBOutlet weak var manufactureLbl: UILabel!
    @IBOutlet weak var manufactureField: UITextField!
    
    @IBOutlet weak var modelView: UIView!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var modelField: UITextField!
    
    @IBOutlet weak var variantView: UIView!
    @IBOutlet weak var variantLbl: UILabel!
    @IBOutlet weak var variantField: UITextField!
    
    @IBOutlet weak var registerYearView: UIView!
    @IBOutlet weak var registerYearLbl: UILabel!
    @IBOutlet weak var registerYearField: UITextField!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomCardView: UIView!
    @IBOutlet weak var policyDetailLbl: UILabel!
    
    @IBOutlet weak var continueVu: UIButton!
    
    @IBOutlet weak var thirdPartyCollection: UICollectionView!
    @IBOutlet weak var ODPolicyCollection: UICollectionView!
    @IBOutlet weak var policyCollection: UICollectionView!
    @IBOutlet weak var comprehensiveCollection: UICollectionView!
    
    @IBOutlet weak var bottomViewShowHide: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var selectInsurerVu: UIView!
    @IBOutlet weak var selectInsurerLbl: UILabel!
    @IBOutlet weak var insurerTable: UIView!
    @IBOutlet weak var insurerTableView : UITableView!
    @IBOutlet weak var insuTableHigh : NSLayoutConstraint!

    @IBOutlet weak var selectExpiryView: UIView!
    @IBOutlet weak var selectExpiryLbl: UILabel!
    @IBOutlet weak var expiryTable: UIView!
    @IBOutlet weak var expiryTableView : UITableView!
    @IBOutlet weak var expTableHigh : NSLayoutConstraint!

    @IBOutlet weak var apiTable: UIView!
    @IBOutlet weak var apiTableView : UITableView!
    @IBOutlet weak var apiTableHigh : NSLayoutConstraint!

    @IBOutlet weak var regisTable: UIView!
    @IBOutlet weak var regisTableView : UITableView!
    @IBOutlet weak var regisTableHigh : NSLayoutConstraint!

    @IBOutlet weak var apiTableTop : NSLayoutConstraint!
    
    @IBOutlet weak var heightForNew : NSLayoutConstraint!
    @IBOutlet weak var showView: UIView!
    
    @IBOutlet weak var yearsBeforeTxt: UILabel!
    @IBOutlet weak var keyboardView : NSLayoutConstraint!
    
    private var tappedThird: Int! = 1
    private var tappedOD: Int! = 1
    private var tappedPolicy: Int! = 1
    private var tappedComprehensive: Int! = 0
    
    private let common = Common.sharedCommon
    private let def = Common.sharedCommon.sharedUserDefaults()
    var enteredVehicleNumber : String!
    
    private var dict : NSDictionary = NSDictionary.init()
    private var vehicleData : NSArray!
    private var apiArray : NSMutableArray!
    
    private var keyboardIsOpen = false
    private var isNew : Bool! = false
    
    enum textFi {
        case reg
        case man
        case mod
        case vara
    }
    private var texFi = textFi.reg
    private var yearArray = NSMutableArray.init()
    
    override func viewDidLoad() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let dd = common.convertStringIntoDate("01-Jan-"+String(currentYear))
        let k = def.object(forKey: "PolicyType") as! String
        let currentDay = currentDate.interval(ofComponent: .day, fromDate: dd)

        if (k.elementsEqual("New"))
        {
            isNew = true

            //            let currentDay = calendar.component(.day, from: currentDate)
            if (currentDay < 16)
            {
                let years = ((currentYear-1)...currentYear).map { String($0) }
                yearArray.addObjects(from: years.reversed() as [Any])
            }
            else
            {
                yearArray.add(String(currentYear))
            }
        }
        else //if (k.elementsEqual("Renewal"))
        {
            var mx = currentYear
//            let currentDay = calendar.component(.day, from: currentDate)
            if (currentDay < 16)
            {
                mx = (currentYear-1)
            }

            let years = (1990...mx).map { String($0) }
            yearArray.addObjects(from: years.reversed() as [Any])
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let dateString = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: -14, to: Date())!)
            isNew = false
            let txt = "Years before "+dateString.components(separatedBy: "-").last!+" is only applicable for third party only policy"
            yearsBeforeTxt.text = txt as String
        }
        
        thirdPartyCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        apiTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        regisTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        comprehensiveCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        policyCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        ODPolicyCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")

        if (enteredVehicleNumber != nil && enteredVehicleNumber.count > 4)
        {
            let index = enteredVehicleNumber.index(enteredVehicleNumber.startIndex, offsetBy: 5)
            let mySubstring = enteredVehicleNumber.prefix(upTo: index).uppercased()
            for listV in Common.registerAreaArr
            {
                let item = listV as! NSDictionary
                let name = item.object(forKey: "Name") as! String
                if (name.contains(mySubstring))
                {
                    def.set(item.object(forKey: "TopCityName"), forKey: "RTOTopCityName")
                    def.set(item.object(forKey: "Zone"), forKey: "RTOZone")
                    def.set(item.object(forKey: "CityName"), forKey: "RTOCityName")
                    def.set(item.object(forKey: "Id"), forKey: "RTOCityId")
                    def.set(item.object(forKey: "Name"), forKey: "RTOName")
                    def.set(item.object(forKey: "IsTopCity"), forKey: "RTOTopCity")
                    
                    registerAreaField.text = name
                }
            }
            
            let carData = common.unArchiveMyDataForDictionary("carDetails")
            
            if (carData != nil)
            {
                let makeName = carData?.object(forKey: "car") as? NSDictionary
                let registrationDate = carData?.object(forKey: "registDate") as! String
                let regYear = registrationDate.components(separatedBy: "-").last
                registerYearField.text = regYear
                def.set(regYear, forKey: "RegistrationYear")
                def.set(registrationDate, forKey: "ManufaturingDate")
                def.set(registrationDate, forKey: "RegistrationDate")
                def.set(registrationDate, forKey: "PurchaseDate")
                
                if (makeName != nil)
                {
                    let makeV = makeName!.object(forKey: "companyName") as! String
                    let modelV = makeName!.object(forKey: "modelName") as! String
                    for makelist in Common.manufacturerArray {
                        let item = makelist as! NSDictionary
                        let name = item.object(forKey: "Name") as! String
                        if (name.lowercased().contains(makeV.lowercased()))
                        {
                            def.set(item.object(forKey: "Name"), forKey: "MakeName")
                            def.set(item.object(forKey: "Id"), forKey: "MakeId")
                            def.set(item.object(forKey: "IsTop"), forKey: "MakeTop")
                            manufactureField.text = name
                        }
                    }
                    
                    for modellist in Common.modelArray {
                        let item = modellist as! NSDictionary
                        let name = item.object(forKey: "Name") as! String
                        if (name.lowercased().contains(modelV.lowercased()))
                        {
                            def.set(item.object(forKey: "Name"), forKey: "ModelName")
                            def.set(item.object(forKey: "Id"), forKey: "ModelId")
                            def.set(item.object(forKey: "IsTop"), forKey: "ModelTop")
                            modelField.text = name
                        }
                    }
                }
            }
            def.synchronize()
        }
        switch(common.sharedUserDefaults().integer(forKey: "ProductCode"))
        {
        case 2:
            insuranceNameLbl.text = "Private Car"
            insuranceDescription.text = "Protect you and your vehicle against a number of risks along with third-party liabilities"
            insuranceImage.image = UIImage.init(named: "Car Insurance")
            break
        default:
            insuranceNameLbl.text = "Two Wheeler"
            insuranceDescription.text = "Protect you and your vehicle against a number of risks along with third-party liabilities"
            insuranceImage.image = UIImage.init(named: "Two Wheeler")
            break
        }
        
        insurerTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        expiryTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")

        displayPreviousTableViewOrNot(isExpiryTable: true, toBeHidden: true)
        displayPreviousTableViewOrNot(isExpiryTable: false, toBeHidden: true)

        if (!self.isNew)
        {
            self.insurerTableView.reloadData()
            self.insurerTableView.updateTableContentInset()
            self.expiryTableView.reloadData()
            self.expiryTableView.updateTableContentInset()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textFieldLabel()
        applyRoundedShapeToViews()
        apiTable.backgroundColor = UIColor.clear
        regisTable.backgroundColor = UIColor.clear
        common.applyShadowToView(apiTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(regisTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
    }
    
    private func applyRoundedShapeToViews()
    {
        common.applyRoundedShapeToView(bottomCardView, withRadius: 15)
        common.applyRoundedShapeToView(registerAreaView, withRadius: 5)
        common.applyRoundedShapeToView(manufactureView, withRadius: 5)
        common.applyRoundedShapeToView(modelView, withRadius: 5)
        common.applyRoundedShapeToView(variantView, withRadius: 5)
        common.applyRoundedShapeToView(registerYearView, withRadius: 5)
        common.applyRoundedShapeToView(continueVu, withRadius: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeDataFromApp()
        if (!isNew)
        {
            if (enteredVehicleNumber != nil)
            {
                loadDetails()
            }
            showViewForRenewal()
        }
        displayTableViewOrNot(isRegistrationTable: false, toBeHidden: true)
        displayTableViewOrNot(isRegistrationTable: true, toBeHidden: true)
        displayForNewOrRenewal()
    }
    
    private func loadDetails()
    {
        if (def.string(forKey: "RegistrationYear") != nil)
        {
            registerYearField.text = def.string(forKey: "RegistrationYear")
        }
        
        if (def.string(forKey: "RTOName") != nil)
        {
            registerAreaField.text = def.string(forKey: "RTOName")
        }
        if (def.string(forKey: "MakeName") != nil)
        {
            manufactureField.text = def.string(forKey: "MakeName")
        }
        if (def.string(forKey: "ModelName") != nil)
        {
            modelField.text = def.string(forKey: "ModelName")
        }
        if (def.string(forKey: "VariantName") != nil)
        {
            variantField.text = def.string(forKey: "VariantName")
        }
    }
    
    private func displayForNewOrRenewal()
    {
        if (isNew) // bottom
        {
            tappedPolicy = 0
            heightForNew.constant = 0.1
        }
        else
        {
            heightForNew.constant = 172
        }
        showView.isHidden = isNew
        hideMyView(isNew)
    }
    
    private func displayTableViewOrNot(isRegistrationTable : Bool, toBeHidden hide : Bool)
    {
        var high = 180.0
        if (isRegistrationTable)
        {
            if (hide)
            {
                high = 0.1
            }

            regisTableHigh.constant = high
            regisTable.isHidden = hide
            regisTable.layoutIfNeeded()
        }
        else
        {
            if (hide)
            {
                high = 0.1
            }
            apiTableHigh.constant = high
            apiTable.isHidden = hide
            apiTable.layoutIfNeeded()
        }
    }
    
    private func displayPreviousTableViewOrNot(isExpiryTable : Bool, toBeHidden hide : Bool)
    {
        var high = 160.0
        if (isExpiryTable)
        {
            if (hide)
            {
                high = 0.1
            }

            expTableHigh.constant = high
            expiryTable.isHidden = hide
            expiryTable.layoutIfNeeded()
        }
        else
        {
            if (hide)
            {
                high = 0.1
            }
            insuTableHigh.constant = high
            insurerTable.isHidden = hide
            insurerTable.layoutIfNeeded()
        }
    }

    private func showViewForRenewal()
    {
        common.applyShadowToView(bottomView, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        policyDetailLbl.highlightMyText(policyDetailLbl.text!, searchedText: "Details", colorValue: common.hexStringToUIColor(hex: "#0FACC8"), withFontName: policyDetailLbl.font)
        
        common.applyRoundedShapeToView(selectInsurerVu, withRadius: 5)
        common.applyRoundedShapeToView(selectExpiryView, withRadius: 5)
        common.applyBorderToView(selectInsurerVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(selectExpiryView, withColor: Colors.textFldColor, ofSize: 1)
        insurerTable.backgroundColor = UIColor.clear
        common.applyShadowToView(insurerTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        expiryTable.backgroundColor = UIColor.clear
        common.applyShadowToView(expiryTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        selectInsurerVu.addGestureRecognizer(tap1)
        selectExpiryView.addGestureRecognizer(tap2)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let vi = sender?.view
        if (vi!.isDescendant(of: selectInsurerVu))
        {
            keyboardIsOpen = false
            if (insurerTable.isHidden )
            {
                displayPreviousTableViewOrNot(isExpiryTable: true, toBeHidden: true)
                displayPreviousTableViewOrNot(isExpiryTable: false, toBeHidden: false)
            }
        }
        else
        {
            keyboardIsOpen = false
            if (expiryTable.isHidden && !(Common.insurerArray==nil))
            {
                displayPreviousTableViewOrNot(isExpiryTable: true, toBeHidden: false)
                displayPreviousTableViewOrNot(isExpiryTable: false, toBeHidden: true)
            }
        }
    }
    
    @IBAction func continueTapp(_ sender: UIButton) {
        keyboardIsOpen = false
        manufactureField.resignFirstResponder()
        registerAreaField.resignFirstResponder()
        modelField.resignFirstResponder()
        variantField.resignFirstResponder()
        registerYearField.resignFirstResponder()
        
        let k = def.bool(forKey: "DontKnowPreviousInsurer")
        var isBreaking : Bool! = true
        if (!k)
        {
            var v : Int!
            if (def.dictionary(forKey: "PrevPolicyExpiryStatus") != nil)
            {
                let ki = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
                v = Int(ki.object(forKey: "Id") as! String)
            }
            if (v != nil)
            {
                if (v != 0 && v != nil)
                {
                    isBreaking = true
                }
                else
                {
                    isBreaking = false
                }
            }
            else
            {
                isBreaking = true
            }
        }
        else
        {
            isBreaking = true
        }
        
        def.set(isBreaking, forKey: "IsBreakingCase")
        def.synchronize()
        
        if (k)
        {
            if (!manufactureField.hasText || !registerAreaField.hasText || !modelField.hasText || !variantField.hasText || !registerYearField.hasText)
            {
                displayAlert()
            }
            else
            {
                common.goToNextScreenWith("MotorGetQuoteViewController", self)
            }
        }
        else
        {
            if (!manufactureField.hasText || !registerAreaField.hasText || !modelField.hasText || !variantField.hasText || !registerYearField.hasText || selectExpiryLbl.text!.elementsEqual("Select expiry status*") || selectInsurerLbl.text!.elementsEqual("Select Previous Insurer*"))
            {
                displayAlert()
            }
            else
            {
                common.goToNextScreenWith("MotorGetQuoteViewController", self)
            }
        }
    }
    
    private func displayAlert()
    {
        common.removeImageForRestriction(manufactureField)
        common.removeImageForRestriction(registerAreaField)
        common.removeImageForRestriction(modelField)
        common.removeImageForRestriction(variantField)
        common.removeImageForRestriction(registerYearField)
        
        var alertString = "Please select the "
        if (!manufactureField.hasText)
        {
            common.displayImageForRestriction(manufactureField!)
            alertString += "Manufacturer "
        }
        if (!registerAreaField.hasText)
        {
            common.displayImageForRestriction(registerAreaField!)
            if (!manufactureField.hasText)
            {
                alertString += ", "
            }
            alertString += "RTO Area "
        }
        if (!modelField.hasText)
        {
            common.displayImageForRestriction(modelField!)
            if (!registerAreaField.hasText)
            {
                alertString += ", "
            }
            alertString += "Vehicle Model "
        }
        if (!variantField.hasText)
        {
            common.displayImageForRestriction(variantField!)
            if (!modelField.hasText)
            {
                alertString += ", "
            }
            alertString += "Variant of vehicle "
        }
        if (!registerYearField.hasText)
        {
            common.displayImageForRestriction(registerYearField!)
            if (!variantField.hasText)
            {
                alertString += ", "
            }
            alertString += "Registration Year "
        }
        
        if (!def.bool(forKey: "DontKnowPreviousInsurer"))
        {
            common.removeImageForRestriction(selectInsurerLbl)
            common.removeImageForRestriction(selectExpiryLbl)
            
            if (selectInsurerLbl.text!.elementsEqual("Select Previous Insurer*"))
            {
                common.displayImageForRestriction(selectInsurerLbl!)
                if (!registerYearField.hasText)
                {
                    alertString += ", "
                }
                alertString += "Previous Insurer "
            }
            if (selectExpiryLbl.text!.elementsEqual("Select expiry status*"))
            {
                common.displayImageForRestriction(selectExpiryLbl!)
                if (selectInsurerLbl.text!.elementsEqual("Select Previous Insurer*"))
                {
                    alertString += ", "
                }
                alertString += "Expiry Status "
            }
        }
        
        let displayAlert = alertString.lowercased().replacingOccurrences(of: "Please select the ", with: "")
        if (!displayAlert.isEmpty)
        {
            showAlertView(alertString)
        }
    }
    
    private func showAlertView(_ alertString : String)
    {
        let alertVu = SCLAlertView.init(appearance: common.alertwithCancel)
        alertVu.showInfo("Warning!", subTitle: alertString, closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }
    
    private func placeMyTableViewAround(thisView view: UIView,andAT_BottomTop topBottom: Bool)
    {
        var heightConstraint : NSLayoutConstraint!
        if (topBottom) // bottom
        {
            heightConstraint = NSLayoutConstraint.init(item: apiTableTop.firstItem as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 10)
        }
        else
        {
            heightConstraint = NSLayoutConstraint.init(item: apiTableTop.firstItem as Any, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 10)
        }
        apiTableTop.isActive = false
        apiTableTop = nil
        apiTableTop = heightConstraint
        heightConstraint = nil
        NSLayoutConstraint.activate([apiTableTop])
        apiTable.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if (!keyboardIsOpen)
            {
                keyboardIsOpen = true
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyboardView.constant = keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabel()
        keyboardIsOpen = false
        keyboardView.constant = 0
    }
    
    @IBAction func backbtnTapped(_ sender: UIButton) {
        registerAreaField.resignFirstResponder()
        manufactureField.resignFirstResponder()
        modelField.resignFirstResponder()
        variantField.resignFirstResponder()
        registerYearField.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func removeDataFromApp()
    {
        let def = common.sharedUserDefaults()
        def.removeObject(forKey: "ChassisNumber")
        def.removeObject(forKey: "EngineNumber")
        def.removeObject(forKey: "VehicleAddress")
        if(!(def.string(forKey: "PolicyType")!.elementsEqual("BrokerRenewal")))
        {
            def.removeObject(forKey: "PolicyNumber")
            if (enteredVehicleNumber == nil)
            {
                def.removeObject(forKey: "RegistrationNumber")
            }
        }
        def.removeObject(forKey: "GVW")
        def.removeObject(forKey: "MVW")
        def.removeObject(forKey: "SeatingCapacity")
        def.removeObject(forKey: "CommunicationAddress")
        def.removeObject(forKey: "ClientDetails")
        def.removeObject(forKey: "NomineeAppointeeDetails")
        def.removeObject(forKey: "VehicleAddress")
        def.removeObject(forKey: "CommunicationAddress")
        def.removeObject(forKey: "FinancialInstAddress")
        def.removeObject(forKey: "FinancialInstName")
        def.removeObject(forKey: "PreviousPolicyState")
        def.removeObject(forKey: "PreviousPolicyStateCode")
        def.removeObject(forKey: "PreviousPolicyStateName")
        def.removeObject(forKey: "PreviousPolicyCity")
        def.removeObject(forKey: "PreviousPolicyCityCode")
        def.removeObject(forKey: "PreviousPolicyCityName")
        def.synchronize()
    }
    
    @IBAction func refreshbtnTapped(_ sender: UIButton) {
        registerAreaField.text = ""
        manufactureField.text = ""
        modelField.text = ""
        variantField.text = ""
        registerYearField.text = ""
        selectInsurerLbl.text = "Select Previous Insurer*"
        selectExpiryLbl.text = "Select expiry status*"
        tappedThird = 1
        tappedOD = 1
        tappedPolicy = 1
        tappedComprehensive = 0
        viewWillAppear(true)
    }
    
    func hideMyView(_ hide: Bool) {
        if (hide)
        {
            bottomViewTop.constant = 0
            bottomViewShowHide.constant = 0.1
        }
        else
        {
            bottomViewTop.constant = 20
            bottomViewShowHide.constant = 270
        }
        bottomView.isHidden = hide
        bottomView.layoutIfNeeded()
        comprehensiveCollection.reloadData()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView((textField.superview)!, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        let tagValue = textField.tag
        scrollView.scrollRectToVisible(textField.superview!.bounds, animated: true)
        
        switch(tagValue)
        {
        case 1: //lbl, field
            texFi = textFi.reg
            common.setTextFieldLabels(registerAreaField, registerAreaLbl, false, "")
            apiArray = nil
            apiArray = NSMutableArray.init()
            displayTableViewOrNot(isRegistrationTable: false, toBeHidden: true)
            if (Common.registerAreaArr != nil){
                apiArray.addObjects(from: Common.registerAreaArr as! [Any])
                displayTableViewOrNot(isRegistrationTable: false, toBeHidden: false)
            }
            apiTableView.reloadData()
            placeMyTableViewAround(thisView: registerAreaView, andAT_BottomTop: false)
            break
        case 2:
            texFi = textFi.man
            common.setTextFieldLabels(manufactureField, manufactureLbl, false, "")
            apiArray = nil
            apiArray = NSMutableArray.init()
            displayTableViewOrNot(isRegistrationTable: false, toBeHidden: true)
            if (Common.manufacturerArray != nil){
                apiArray.addObjects(from: Common.manufacturerArray as! [Any])
                displayTableViewOrNot(isRegistrationTable: false, toBeHidden: false)
            }
            apiTableView.reloadData()
            placeMyTableViewAround(thisView: manufactureView, andAT_BottomTop: false)
            displayTableViewOrNot(isRegistrationTable: true, toBeHidden: true)
            break
        case 3:
            texFi = textFi.mod
            common.setTextFieldLabels(modelField, modelLbl, false, "")
            apiArray = nil
            apiArray = NSMutableArray.init()
            displayTableViewOrNot(isRegistrationTable: false, toBeHidden: true)
            if ((def.object(forKey: "MakeId")) != nil)
            {
                if (Common.modelArray != nil) {
                    for item in Common.modelArray {
                        let nameDict = item as? NSDictionary
                        let string = nameDict?.object(forKey: "MakeId") as! String
                        let anootherDict = (def.value(forKey: "MakeId")) as? String
                        if (string.elementsEqual(anootherDict ?? ""))
                        {
                            apiArray.add(item)
                        }
                    }
                }
                displayTableViewOrNot(isRegistrationTable: false, toBeHidden: false)
            }
            apiTableView.reloadData()
            placeMyTableViewAround(thisView: modelView, andAT_BottomTop: false)
            displayTableViewOrNot(isRegistrationTable: true, toBeHidden: true)
            break
        case 4:
            texFi = textFi.vara
            common.setTextFieldLabels(variantField, variantLbl, false, "")
            apiArray = nil
            apiArray = NSMutableArray.init()
            displayTableViewOrNot(isRegistrationTable: false, toBeHidden: true)
            if ((def.object(forKey: "ModelId")) != nil)
            {
                if (Common.variantArray != nil){
                    for item in Common.variantArray {
                        let nameDict = item as? NSDictionary
                        let string = nameDict?.object(forKey: "ModelId") as! String
                        let anootherDict = (def.value(forKey: "ModelId")) as! String
                        if (string.elementsEqual(anootherDict))
                        {
                            apiArray.add(item)
                        }
                    }
                }
                displayTableViewOrNot(isRegistrationTable: false, toBeHidden: false)
            }
            apiTableView.reloadData()
            placeMyTableViewAround(thisView: variantView, andAT_BottomTop: false)
            displayTableViewOrNot(isRegistrationTable: true, toBeHidden: true)
            break
        case 5:
            apiArray = nil
            apiArray = NSMutableArray.init()
            apiArray.addObjects(from: yearArray as! [Any])
            common.setTextFieldLabels(registerYearField, registerYearLbl, false, "")
            regisTableView.reloadData()
            self.regisTableView.updateTableContentInset()
            displayTableViewOrNot(isRegistrationTable: true, toBeHidden: false)
            displayTableViewOrNot(isRegistrationTable: false, toBeHidden: true)
            break
        default:
            break
        }
        return true
    }
    
    //    override func viewDidLayoutSubviews() {
    //        print("mein call hua hu")
    //    }
    //
    
    private func textFieldLabel()
    {
        setLabelFieldMutualVisibility(registerAreaField, registerAreaLbl.text!, registerAreaLbl)
        setLabelFieldMutualVisibility(manufactureField, manufactureLbl.text!, manufactureLbl)
        setLabelFieldMutualVisibility(modelField, modelLbl.text!, modelLbl)
        setLabelFieldMutualVisibility(variantField, variantLbl.text!, variantLbl)
        setLabelFieldMutualVisibility(registerYearField, registerYearLbl.text!, registerYearLbl)
        common.applyBorderToView(registerAreaView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(manufactureView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(modelView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(variantView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(registerYearView, withColor: Colors.textFldColor, ofSize: 1)
    }
    
    private func setLabelFieldMutualVisibility(_ field: UITextField,_ string: String,_ lbl: UILabel)
    {
        if (!field.hasText)
        {
            common.setTextFieldLabels(field, lbl, true, string)
        }
        else
        {
            common.setTextFieldLabels(field, lbl, false, string)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        textFieldLabel()
        common.applyBorderToView((textField.superview)!, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        var currentString: NSString = textField.text! as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        apiArray = nil
        apiArray = NSMutableArray.init()

        if(textField.tag != 5)
        {
            switch texFi
            {
            case .reg:
                apiArray.addObjects(from: Common.registerAreaArr as! [Any])
                break
            case .man:
                apiArray.addObjects(from: Common.manufacturerArray as! [Any])
                break
            case .mod:
                if ((def.object(forKey: "MakeId")) != nil)
                {
                    if (Common.modelArray != nil){
                        for item in Common.modelArray {
                            let nameDict = item as? NSDictionary
                            let string = nameDict?.object(forKey: "MakeId") as! String
                            let anootherDict = (def.value(forKey: "MakeId")) as? String
                            if (string.elementsEqual(anootherDict ?? ""))
                            {
                                apiArray.add(item)
                            }
                        }
                    }
                }
                break
            case .vara:
                if ((def.object(forKey: "ModelId")) != nil)
                {
                    if (Common.variantArray != nil){
                        for item in Common.variantArray {
                            let nameDict = item as? NSDictionary
                            let string = nameDict?.object(forKey: "ModelId") as! String
                            let anootherDict = (def.value(forKey: "ModelId")) as! String
                            if (string.elementsEqual(anootherDict))
                            {
                                apiArray.add(item)
                            }
                        }
                    }
                }
                break
            }
        }
        else
        {
            apiArray.addObjects(from: yearArray as! [Any])
        }
        let selectArr: NSArray = apiArray
        let str = textField.text! as String
        let emptyArr = NSMutableArray.init()
        for item in selectArr {
            var string: String!
            if (textField.tag != 5)
            {
                let nameDict = item as? NSDictionary
                if (nameDict?["VariantName"] != nil)
                {
                    string = (nameDict?.object(forKey: "VariantName") as! String)
                }
                else
                {
                    string = (nameDict?.object(forKey: "Name") as! String)
                }
            }
            else
            {
                string = (item as! String)
            }
            if (string.lowercased().contains(str.lowercased()))
            {
                emptyArr.add(item)
            }
        }
        if (str.elementsEqual(""))
        {
            if (textField.tag != 5)
            {
                emptyArr.addObjects(from: apiArray as! [Any])
            }
            else
            {
                emptyArr.addObjects(from: yearArray as! [Any])
            }
        }
        apiArray = nil
        apiArray = NSMutableArray.init()
        apiArray.addObjects(from: emptyArr as! [Any])
        if (textField.tag != 5)
        {
            apiTableView.reloadData()
        }
        else
        {
            regisTableView.reloadData()
            regisTableView.updateTableContentInset()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        keyboardIsOpen = false
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView.tag == 1204)
        {
            return Common.prevPolicyArray.count
        }
        return Common.yesNoBtnArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        if (collectionView.tag == 1204)
        {
            cell.setDataForNormal(Common.prevPolicyArray[indexPath.row], ofFontSize: 14)
        }
        else
        {
            cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 12)
        }
        switch (collectionView.tag)
        {
        case 1201:
            if (tappedThird == indexPath.row)
            {
                cell.setSelectedData()
                let k = Bool(truncating: indexPath.row as NSNumber)
                def.set(!k, forKey: "IsThirdPartyOnly")
                def.synchronize()
            }
            break
        case 1204:
            if (tappedComprehensive == indexPath.row)
            {
                cell.setSelectedData()
                let dd = common.setIdAndNameForDict(_valueId: String(indexPath.row+1), andName: Common.prevPolicyArray[indexPath.row])
                dd.setValue(true, forKey: "Checked")
                def.set(dd, forKey: "PreviousPolicyType")
                def.synchronize()
            }
            break
        case 1203:
            if (tappedPolicy == indexPath.row)
            {
                cell.setSelectedData()
                let k = Bool(truncating: indexPath.row as NSNumber)
                def.set(!k, forKey: "DontKnowPreviousInsurer")
                def.set(k, forKey: "PreviousPolicyDetailsRequired")
                def.synchronize()
                hideMyView(!k)
            }
            break
        default:
            if (tappedOD == indexPath.row)
            {
                cell.setSelectedData()
                let k = Bool(truncating: indexPath.row as NSNumber)
                def.set(!k, forKey: "IsODOnly")
                def.synchronize()
            }
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (collectionView.tag)
        {
        case 1201:
            tappedThird = indexPath.row
            tappedOD = 1
            break
        case 1204:
            tappedComprehensive = indexPath.row
            if (!isNew)
            {
                def.set(indexPath.row+1, forKey: "PreviousPolicyType")
                def.synchronize()
            }
            break
        case 1203:
            tappedPolicy = indexPath.row
            break
        default:
            tappedOD = indexPath.row
            tappedThird = 1
            break
        }
        thirdPartyCollection.reloadData()
        ODPolicyCollection.reloadData()
        policyCollection.reloadData()
        comprehensiveCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = common.getScreenSize(collectionView)
        var sizes: CGSize = CGSize.init(width: 0, height: 0)
        let CellHeight = widthAndHeight.1
        let CellWidth = widthAndHeight.0*0.45
        if (collectionView.tag == 1204)
        {
            sizes = CGSize(width: CellWidth, height: CellHeight*0.6)
        }
        else
        {
            sizes = CGSize(width: 50, height: CellHeight*0.7)
        }
        return sizes;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
//        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10);
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (tableView.tag)
        {
        case 1301:
            if (Common.insurerArray != nil)
            {
                return Common.insurerArray.count
            }
            break
        case 1303:
            if (apiArray != nil)
            {
                return apiArray.count
            }
            break
        case 1302:
            if (Common.insurerArray != nil)
            {
                return Common.expiryArray.count
            }
            break
        case 1304:
            if (apiArray != nil)
            {
                return apiArray.count
            }
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
        var string: String! = ""
        
        switch (tableView.tag)
        {
        case 1301:
            let nameDict = (Common.insurerArray[indexPath.row]) as? NSDictionary
            string = (nameDict?.object(forKey: "Name") as! String)
            break
        case 1303:
            let nameDict = (apiArray[indexPath.row]) as? NSDictionary
            if (nameDict?["VariantName"] != nil)
            {
                string = (nameDict?.object(forKey: "VariantName") as! String)
                let fTy = nameDict?.object(forKey: "FuelType") as! String
                string += " - " + fTy
            }
            else
            {
                string = (nameDict?.object(forKey: "Name") as! String)
            }
            break
        case 1304:
            string = (apiArray[indexPath.row] as! String)
            break
        case 1302:
            let nameDict = Common.expiryArray[indexPath.row]
            string = nameDict
            break
        default:
            break
        }
        cell.setDispaly(string)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (tableView.tag)
        {
        case 1301:
            let nameDict = (Common.insurerArray[indexPath.row]) as? NSDictionary
            let string = (nameDict?.object(forKey: "Name") as! String)
            def.set(nameDict?.object(forKey: "CompanyCode"), forKey: "PrevPolicyInsurerCompanyCode")
            def.set(nameDict?.object(forKey: "CShortName"), forKey: "PrevPolicyInsurerCShortName")
            def.set(nameDict?.object(forKey: "Id"), forKey: "PrevPolicyInsurerId")
            def.set(string, forKey: "PrevPolicyInsurerCompanyName")
            def.set(nameDict?.object(forKey: "Id"), forKey: "PrevPolicyInsurerIndex")
            def.set(def.bool(forKey: "DontKnowPreviousInsurer"), forKey: "PrevPolicyInsurerChecked")
            def.synchronize()
            selectInsurerLbl.text = string
            displayPreviousTableViewOrNot(isExpiryTable: false, toBeHidden: true)
            common.removeImageForRestriction(selectInsurerLbl)
            break
        case 1304:
            let string = apiArray[indexPath.row] as! String
            registerYearField.text = string        //Calculate age
            def.set(string, forKey: "RegistrationYear")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            let nameOfMonth = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "dd"
            let dateNum = dateFormatter.string(from: Date())
            let dateString = dateNum+"-"+nameOfMonth+"-"+string
            def.set(dateString, forKey: "ManufaturingDate")
            def.set(dateString, forKey: "RegistrationDate")
            def.set(dateString, forKey: "PurchaseDate")
            def.synchronize()
            registerYearLbl.isHidden = false
            common.removeImageForRestriction(registerYearField)
            tableView.superview!.isHidden = true
            break
        case 1303:
            switch texFi
            {
            case .reg:
                let nameDict = (apiArray[indexPath.row]) as? NSDictionary
                let string = (nameDict?.object(forKey: "Name") as! String)
                def.set(nameDict?.object(forKey: "TopCityName"), forKey: "RTOTopCityName")
                def.set(nameDict?.object(forKey: "Zone"), forKey: "RTOZone")
                def.set(nameDict?.object(forKey: "CityName"), forKey: "RTOCityName")
                def.set(nameDict?.object(forKey: "Id"), forKey: "RTOCityId")
                def.set(nameDict?.object(forKey: "Name"), forKey: "RTOName")
                def.set(nameDict?.object(forKey: "IsTopCity"), forKey: "RTOTopCity")
                def.synchronize()
                registerAreaField.text = string
                registerAreaLbl.isHidden = false
                common.removeImageForRestriction(manufactureField)
                break
            case .man:
                let nameDict = (apiArray[indexPath.row]) as? NSDictionary
                let string = (nameDict?.object(forKey: "Name") as! String)
                
                def.set(nameDict?.object(forKey: "Name"), forKey: "MakeName")
                def.set(nameDict?.object(forKey: "Id"), forKey: "MakeId")
                def.set(nameDict?.object(forKey: "IsTop"), forKey: "MakeTop")
                manufactureField.text = string
                manufactureLbl.isHidden = false
                
                def.removeObject(forKey: "ModelId")
                def.removeObject(forKey: "ModelName")
                def.removeObject(forKey: "ModelTop")
                modelField.text = ""
                modelLbl.isHidden = true
                
                def.removeObject(forKey: "IsFullyBuilt")
                def.removeObject(forKey: "VariantTop")
                def.removeObject(forKey: "FuelType")
                def.removeObject(forKey: "VariantId")
                def.removeObject(forKey: "VariantName")
                def.removeObject(forKey: "FuelId")
                def.synchronize()
                variantField.text = ""
                variantLbl.isHidden = true
                common.removeImageForRestriction(registerAreaField)
                break
            case .mod:
                let nameDict = (apiArray[indexPath.row]) as? NSDictionary
                let string = (nameDict?.object(forKey: "Name") as! String)
                
                def.set(nameDict?.object(forKey: "Id"), forKey: "ModelId")
                def.set(nameDict?.object(forKey: "Name"), forKey: "ModelName")
                def.set(nameDict?.object(forKey: "IsTop"), forKey: "ModelTop")
                modelField.text = string
                modelLbl.isHidden = false
                
                def.removeObject(forKey: "IsFullyBuilt")
                def.removeObject(forKey: "VariantTop")
                def.removeObject(forKey: "FuelType")
                def.removeObject(forKey: "VariantId")
                def.removeObject(forKey: "VariantName")
                def.removeObject(forKey: "FuelId")
                def.synchronize()
                variantField.text = ""
                variantLbl.isHidden = true
                common.removeImageForRestriction(modelField)
                break
            case .vara:
                let nameDict = (apiArray[indexPath.row]) as? NSDictionary
                let string = (nameDict?.object(forKey: "VariantName") as! String)
                
                if (nameDict?.object(forKey: "IsFullyBuilt") is NSNull)
                {
                    def.set("", forKey: "IsFullyBuilt")
                }
                else
                {
                    def.set(nameDict?.object(forKey: "IsFullyBuilt"), forKey: "IsFullyBuilt")
                }
                def.set(nameDict?.object(forKey: "IsTop"), forKey: "VariantTop")
                let fTy = nameDict?.object(forKey: "FuelType") as! String
                def.set(fTy, forKey: "FuelType")
                def.set(nameDict?.object(forKey: "VariantId"), forKey: "VariantId")
                
                let variantName = nameDict?.object(forKey: "VariantName") as! String + " - " + fTy
                def.set(variantName, forKey: "VariantName")
                def.set(nameDict?.object(forKey: "FuelId"), forKey: "FuelId")
                def.synchronize()
                variantField.text = string + " - " + fTy
                variantLbl.isHidden = false
                common.removeImageForRestriction(variantField)
                break
            }
            registerAreaField.resignFirstResponder()
            manufactureField.resignFirstResponder()
            modelField.resignFirstResponder()
            variantField.resignFirstResponder()
            registerYearField.resignFirstResponder()
            tableView.superview!.isHidden = true
            break
        case 1302:
            let nameDict = Common.expiryArray[indexPath.row]
            let string = nameDict
            selectExpiryLbl.text = string
            if (indexPath.row > 0 && !def.bool(forKey: "DontKnowPreviousInsurer"))
            {
                let dd = common.setIdAndNameForDict(_valueId: String(indexPath.row-1), andName: string)
                def.set(dd, forKey: "PrevPolicyExpiryStatus")
                def.synchronize()
                
                setExpiryDate(indexPath.row-1)
            }
            displayPreviousTableViewOrNot(isExpiryTable: true, toBeHidden: true)
            common.removeImageForRestriction(selectExpiryLbl)
            thirdPartyCollection.reloadData()
            ODPolicyCollection.reloadData()
            policyCollection.reloadData()
            comprehensiveCollection.reloadData()
            break
        default:
            break
        }
    }
    
    private func setExpiryDate(_ index : Int)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: Date())
        switch(index)
        {
        case 0:
            def.set(dateString, forKey: "ExpiryDate")
            def.synchronize()
            break
        case 1:
            let dateString = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -45, to: Date())!)
            def.set(dateString, forKey: "ExpiryDate")
            def.synchronize()
            break
        default:
            let dateString = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -90, to: Date())!)
            def.set(dateString, forKey: "ExpiryDate")
            def.synchronize()
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView.tag == 1301)
        {
            return 50
        }
        return 40
    }
}
