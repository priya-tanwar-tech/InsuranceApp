//
//  VehicleRegistrationViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 10/12/21.
//

import Foundation
import UIKit

class VehicleRegistrationViewController : UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollVu: UIScrollView!
    
    @IBOutlet weak var continueVu: UIButton!
    @IBOutlet weak var myProgressBar: UIProgressView!
    
    @IBOutlet weak var vehicleVu: UIView!
    @IBOutlet weak var vehicle: UITextField!
    @IBOutlet weak var vehicleLbl: UILabel!
    
    @IBOutlet weak var registerDVu: UIView!
    @IBOutlet weak var register: UILabel!
    @IBOutlet weak var regDLbl: UILabel!
    
    @IBOutlet weak var engineVu: UIView!
    @IBOutlet weak var engine: UITextField!
    @IBOutlet weak var engineLbl: UILabel!
    
    @IBOutlet weak var chasisVu: UIView!
    @IBOutlet weak var chasis: UITextField!
    @IBOutlet weak var chasisLbl: UILabel!
    
    @IBOutlet weak var financierVu: UIView!
    @IBOutlet weak var financier: UITextField!
    @IBOutlet weak var financierLbl: UILabel!
    
    @IBOutlet weak var cityVu: UIView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var cityLbl: UILabel!
    
    @IBOutlet weak var hypoCollect: UICollectionView!
    @IBOutlet weak var hypo: UIView!
    
    @IBOutlet weak var hypoShow: NSLayoutConstraint!
    @IBOutlet weak var bodyColorShow: NSLayoutConstraint!
    
    @IBOutlet weak var apiTable: UIView!
    @IBOutlet weak var apiTableView : UITableView!
    @IBOutlet weak var apiTableTop : NSLayoutConstraint!
    
    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var quotationLabel: UILabel!
    
    @IBOutlet weak var additional: UIView!
    
    @IBOutlet weak var bodyTypeVu: UIView!
    @IBOutlet weak var bodyType: UILabel!
    @IBOutlet weak var bodyTypeLbl: UILabel!
    
    @IBOutlet weak var bodyColorVu: UIView!
    @IBOutlet weak var bodyColor: UILabel!
    @IBOutlet weak var bodyColorLbl: UILabel!
    
    @IBOutlet weak var vehUsageTypeVu: UIView!
    @IBOutlet weak var vehUsageType: UITextField!
    @IBOutlet weak var vehUsageTypeLbl: UILabel!
    @IBOutlet weak var vehUsageTypeShow: NSLayoutConstraint!
    @IBOutlet weak var vehUsageTypeTop: NSLayoutConstraint!

    @IBOutlet weak var validPucView: UIView!
    @IBOutlet weak var pucView: UIView!
    @IBOutlet weak var pucCollect: UICollectionView!
    @IBOutlet weak var pucShow: NSLayoutConstraint!
    @IBOutlet weak var pucPolShow: NSLayoutConstraint!
    @IBOutlet weak var pucPosition: NSLayoutConstraint!

    @IBOutlet weak var pucNumberVu: UIView!
    @IBOutlet weak var pucNumber: UITextField!
    @IBOutlet weak var pucNumberLbl: UILabel!
    
    @IBOutlet weak var pucStartVu: UIView!
    @IBOutlet weak var pucStart: UILabel!
    @IBOutlet weak var pucStartLbl: UILabel!
    
    @IBOutlet weak var pucEndVu: UIView!
    @IBOutlet weak var pucEnd: UILabel!
    @IBOutlet weak var pucEndLbl: UILabel!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var selectDate: UIButton!

    @IBOutlet weak var keyboardView : NSLayoutConstraint!
    
    private var apiArray : NSMutableArray!
    private var hypoFinArray : NSArray!
    private var typeArray : NSArray!
    private var colorArray : NSArray!
    private var vehicleUsageArray : NSArray!

    private var tappedHypo: Int! = 1
    private var tappedPUC: Int! = 1
    private let common = Common.sharedCommon
    private var keyboardIsOpen = false
    private var vehicleName : String!
    private var isNew : Bool! = false
    private var isValid : Bool! = false
    private let def = Common.sharedCommon.sharedUserDefaults()
    
    enum textFi {
        case finCity
        case finInst
        case bodyTyp
        case bodyCol
        case puc_Num
        case puc_Start
        case puc_End
        case pur_date
        case veh_type
        case none
    }
    private var texFi = textFi.none
    
    override func viewDidLoad() {
        let vehiclName = def.string(forKey: "MakeName")! + " " + def.string(forKey: "ModelName")! + " " + def.string(forKey: "VariantName")!
        vehicleDetails.text = vehiclName
        quotationLabel.text = def.string(forKey: "QuotationNumber")
        
        apiTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        common.applyShadowToView(apiTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        var v : Int!
        if (def.dictionary(forKey: "PrevPolicyExpiryStatus") != nil)
        {
            let ki = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
            v = Int(ki.object(forKey: "Id") as! String)
        }
        if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
        {
            myProgressBar.setProgress((4/7), animated: true)
        }
        else
        {
            myProgressBar.setProgress((4/6), animated: true)
        }
        pickerView.isHidden = true
        loadMyDataIfAvail()
        let companyName = common.sharedUserDefaults().string(forKey: "ThisCompany")
        
        var vehicleCategory = ""
        switch (def.integer(forKey: "ProductCode"))
        {
        case 1:
            vehicleCategory = common.twowheeler
            break
        case 2:
            vehicleCategory = common.privatecar
            break
        case 9:
            vehicleCategory = common.passengerCommercial
            break
        case 10:
            vehicleCategory = common.goodCommercial
            break
        case 17:
            vehicleCategory = common.miscCommercial
            break
        default:
            break
        }
                
        let usageTypeURL = common.A_P_I+common.baseURL+common.forApi+common.motor + vehicleCategory + common.VehicleUsagetype+common.company
        
        APICallered().fetchData(usageTypeURL+companyName!) { response in
            DispatchQueue.main.async {
                if (response?.object(forKey: "Response") != nil)
                {
                    self.vehicleUsageArray = response?.object(forKey: "Response") as? NSArray
                    self.hideVehicleUsageTypeView(hide: false)
                }
                else
                {
                    self.hideVehicleUsageTypeView(hide: true)
                }
            }
        }
        
        let pType = def.string(forKey: "PolicyType")
        if (pType!.elementsEqual("New") || companyName!.uppercased().elementsEqual("NEWINDIA"))
        {
            isNew = true
        }
        else
        {
            hideAdditionalView()
        }
        if (def.integer(forKey: "ProductCode") == 1 && !(def.string(forKey: "FuelType")!.lowercased().contains("electric")))
        {
            pucCollect.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
            hideMyPUCVisibleView(false)
        }
        else
        {
            hideMyPUCVisibleView(true)
        }
        hideMyPUCView(true)
        hypoCollect.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        loadApiArrays(companyName!)
        applyShadowToViews()
        applyRoundToViews()
        textFieldLabel()
        hideMyHypoView(true)
        applyGesturesToViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func hideVehicleUsageTypeView(hide : Bool)
    {
        var high = 0.000000000000000001
        var cons = 0.0
        if (!hide)
        {
            high = 1
            cons = 10.0
        }
        vehUsageTypeTop.constant = cons
        let constraintV = NSLayoutConstraint.init(item: vehUsageTypeShow.firstItem as Any, attribute: vehUsageTypeShow.firstAttribute, relatedBy: vehUsageTypeShow.relation, toItem: vehUsageTypeShow.secondItem, attribute: vehUsageTypeShow.secondAttribute, multiplier: high, constant: vehUsageTypeShow.constant)
        vehUsageTypeShow.isActive = false
        vehUsageTypeShow = nil
        vehUsageTypeShow = constraintV
        NSLayoutConstraint.activate([vehUsageTypeShow])
        vehUsageTypeVu.layoutIfNeeded()
        vehUsageTypeVu.isUserInteractionEnabled = !hide
        vehUsageTypeVu.isHidden = hide
    }
    
    private func applyGesturesToViews()
    {
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.bodyTypeAndColor(_:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.bodyTypeAndColor(_:)))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.pucStartEndSelected(_:)))
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(self.pucStartEndSelected(_:)))
        pucStartVu.addGestureRecognizer(tap5)
        pucEndVu.addGestureRecognizer(tap6)
        bodyTypeVu.addGestureRecognizer(tap3)
        bodyColorVu.addGestureRecognizer(tap4)
    }
    
    private func loadApiArrays(_ companyName : String)
    {
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+common.hypothet+common.company+companyName) { response in
            self.hypoFinArray = response?.object(forKey: "Response") as? NSArray
        }
        var vehicleType = ""
        switch(def.integer(forKey: "ProductCode"))
        {
        case 2:
            vehicleType = common.privatecar
            break
        default:
            vehicleType = common.twowheeler
            break
        }
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+vehicleType+common.vehicleBodyType) { response in
            self.typeArray = response?.object(forKey: "Response") as? NSArray
        }
        
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+common.vehicleColor) { response in
            self.colorArray = response?.object(forKey: "Response") as? NSArray
        }
    }
    
    private func applyShadowToViews()
    {
        common.applyBorderToView(bodyTypeVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(bodyColorVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(pucStartVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(pucEndVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(pucNumber, withColor: Colors.textFldColor, ofSize: 1)
    }
    
    @IBAction func dateIsSelected(_ sender: UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        if (texFi == .puc_Start)
        {
            pucStartLbl.isHidden = false
            pucStart.text = dateString
            def.set(dateString, forKey: "PUCStartDate")//PUCNumber
        }
        else if (texFi == .puc_End)
        {
            pucEndLbl.isHidden = false
            pucEnd.text = dateString
            def.set(dateString, forKey: "PUCEndDate")
        }
        def.synchronize()
        scrollVu.isUserInteractionEnabled = true
        pickerView.isHidden = true
    }

    private func applyRoundToViews()
    {
        common.applyRoundedShapeToView(selectDate, withRadius: 5)
        common.applyRoundedShapeToView(vehicle, withRadius: 5)
        common.applyRoundedShapeToView(registerDVu, withRadius: 5)
        common.applyRoundedShapeToView(pucNumber, withRadius: 5)
        common.applyRoundedShapeToView(pucStartVu, withRadius: 5)
        common.applyRoundedShapeToView(pucEndVu, withRadius: 5)
        common.applyRoundedShapeToView(engine, withRadius: 5)
        common.applyRoundedShapeToView(chasis, withRadius: 5)
        common.applyRoundedShapeToView(financier, withRadius: 5)
        common.applyRoundedShapeToView(city, withRadius: 5)
        common.applyRoundedShapeToView(bodyTypeVu, withRadius: 5)
        common.applyRoundedShapeToView(bodyColorVu, withRadius: 5)
        common.applyRoundedShapeToView(continueVu, withRadius: 10)
    }
    
    private func loadMyDataIfAvail()
    {
        let registerDate = def.string(forKey: "RegistrationDate")
        if (def.string(forKey: "RegistrationNumber") != nil)
        {
            vehicleName = def.string(forKey: "RegistrationNumber")
            validateVehicleNumber()
        }
        else
        {
            let c = " "+def.string(forKey: "RTOCityName")!
            vehicleName = def.string(forKey: "RTOName")?.replacingOccurrences(of: c, with: "-")
        }
        vehicle.text = vehicleName
        register.text = registerDate
        
        let carData = common.unArchiveMyDataForDictionary("carDetails")
        if (carData != nil)
        {
            def.set(carData!.object(forKey:"chasisNo"), forKey: "ChassisNumber")
            def.set(carData!.object(forKey:"engineNo"), forKey: "EngineNumber")
            def.synchronize()
        }
        
        if (def.string(forKey: "ChassisNumber") != nil)
        {
            chasis.text = def.string(forKey: "ChassisNumber")
            chasisLbl.isHidden = false
        }
        if (def.string(forKey: "EngineNumber") != nil)
        {
            engine.text = def.string(forKey: "EngineNumber")
            engineLbl.isHidden = false
        }
    }
    
    private func hideAdditionalView()
    {
        let constraintV = NSLayoutConstraint.init(item: bodyColorShow.firstItem as Any, attribute: bodyColorShow.firstAttribute, relatedBy: bodyColorShow.relation, toItem: bodyColorShow.secondItem, attribute: bodyColorShow.secondAttribute, multiplier: 0, constant: 0)
        bodyColorShow.isActive = false
        bodyColorShow = nil
        bodyColorShow = constraintV
        NSLayoutConstraint.activate([bodyColorShow])
        additional.layoutIfNeeded()
        additional.isHidden = true
    }
    
    @IBAction func continueTapp(_ sender: UIButton) {
        validateVehicleNumber()
        vehicle.resignFirstResponder()
        engine.resignFirstResponder()
        chasis.resignFirstResponder()
        financier.resignFirstResponder()
        city.resignFirstResponder()
        def.synchronize()
        var v : Int!
        if (def.dictionary(forKey: "PrevPolicyExpiryStatus") != nil)
        {
            let ki = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
            v = Int(ki.object(forKey: "Id") as! String)
        }
        
        if ((vehicle.hasText || self.engine.hasText || self.chasis.hasText) && vehicle.text!.count >= 13)
        {
            if (isNew)
            {
                if (hypo.isHidden)
                {
                    if (self.bodyType.text!.elementsEqual("Body Type") || self.bodyColor.text!.elementsEqual("Body Color"))
                    {
                        displayAlert()
                    }
                    else
                    {
                        if (isValid)
                        {
                            if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
                            {
                                self.common.goToNextScreenWith("PolicyDetailViewController", self)
                            }
                            else
                            {
                                self.common.goToNextScreenWith("NomineeAppointeeViewController", self)
                            }
                        }
                        else
                        {
                            validVehicleAlert()
                        }
                    }
                }
                else
                {
                    if (self.bodyType.text!.elementsEqual("Body Type") || self.bodyColor.text!.elementsEqual("Body Color") || !financier.hasText || !city.hasText)
                    {
                        displayAlert()
                    }
                    else
                    {
                        if (isValid)
                        {
                            if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
                            {
                                self.common.goToNextScreenWith("PolicyDetailViewController", self)
                            }
                            else
                            {
                                self.common.goToNextScreenWith("NomineeAppointeeViewController", self)
                            }
                        }
                        else
                        {
                            validVehicleAlert()
                        }
                    }
                }
            }
            else
            {
                if (!hypo.isHidden)
                {
                    if (!financier.hasText || !city.hasText)
                    {
                        displayAlert()
                    }
                    else
                    {
                        if (isValid)
                        {
                            if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
                            {
                                self.common.goToNextScreenWith("PolicyDetailViewController", self)
                            }
                            else
                            {
                                self.common.goToNextScreenWith("NomineeAppointeeViewController", self)
                            }
                        }
                        else
                        {
                            validVehicleAlert()
                        }
                    }
                }
                else
                {
                    if (isValid)
                    {
                        if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
                        {
                            self.common.goToNextScreenWith("PolicyDetailViewController", self)
                        }
                        else
                        {
                            self.common.goToNextScreenWith("NomineeAppointeeViewController", self)
                        }
                    }
                    else
                    {
                        validVehicleAlert()
                    }
                }
            }
        }
        else
        {
            displayAlert()
        }
    }
    
    @objc func pucStartEndSelected(_ sender: UITapGestureRecognizer? = nil) {
        keyboardIsOpen = false
        vehicle.resignFirstResponder()
        engine.resignFirstResponder()
        chasis.resignFirstResponder()
        financier.resignFirstResponder()
        city.resignFirstResponder()
        let vi = sender?.view
        if (vi!.isDescendant(of: pucStartVu))
        {
            texFi = .puc_Start
        }
        else
        {
            texFi = .puc_End
        }
        scrollVu.isUserInteractionEnabled = false
        pickerView.isHidden = false
    }
    
    @objc func bodyTypeAndColor(_ sender: UITapGestureRecognizer? = nil) {
        keyboardIsOpen = false
        vehicle.resignFirstResponder()
        engine.resignFirstResponder()
        chasis.resignFirstResponder()
        financier.resignFirstResponder()
        city.resignFirstResponder()
        let vi = sender?.view
        
        if (vi!.isDescendant(of: bodyTypeVu))
        {
            texFi = .bodyTyp
            apiArray = nil
            apiArray = NSMutableArray.init()
            if (typeArray != nil){
                apiArray.addObjects(from: typeArray as! [Any])
                apiTableView.reloadData()
                apiTableView.updateTableContentInset()
                apiTable.isHidden = false
            }
            placeMyTableViewAround(thisView: bodyTypeVu, andAT_BottomTop: false)
        }
        else
        {
            texFi = .bodyCol
            apiArray = nil
            apiArray = NSMutableArray.init()
            if (typeArray != nil){
                apiArray.addObjects(from: colorArray as! [Any])
                apiTableView.reloadData()
                apiTableView.updateTableContentInset()
                apiTable.isHidden = false
            }
            placeMyTableViewAround(thisView: bodyColorVu, andAT_BottomTop: false)
        }
    }
    
    @objc func registerYearTap(_ sender: UITapGestureRecognizer? = nil) {
        keyboardIsOpen = false
        texFi = .pur_date
        regDLbl.isHidden = false
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
    
    private func validVehicleAlert()
    {
        let alert  = SCLAlertView.init(appearance: common.alertwithCancel)
        alert.showError("Alert!", subTitle: "This is not a valid vehicle number", closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabel()
        keyboardIsOpen = false
        keyboardView.constant = 0
    }
    
    @objc private func handleSelectionPicker(_ sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: sender.date)
        register.text = dateString        //Calculate age
        sender.isHidden = true
        sender.resignFirstResponder()
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton)
    {
        def.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func placeMyTableViewAround(thisView view: UIView,andAT_BottomTop topBottom: Bool)
    {
        let heightConstraint = NSLayoutConstraint.init(item: apiTableTop.firstItem as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -10)
        apiTableTop.isActive = false
        apiTableTop = nil
        apiTableTop = heightConstraint
        NSLayoutConstraint.activate([apiTableTop])
        apiTable.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    private func usageTypeViewShowOrHide(hide : Bool)
    {
        var high = 1.0
        vehUsageTypeTop.constant = 10
        if (hide)
        {
            high = 0.0
            vehUsageTypeTop.constant = 0
        }
        
        let heightConstraint = NSLayoutConstraint.init(item: vehUsageTypeShow.firstItem as Any, attribute: vehUsageTypeShow.firstAttribute, relatedBy: vehUsageTypeShow.relation, toItem: vehUsageTypeShow.secondItem, attribute: vehUsageTypeShow.secondAttribute, multiplier: high, constant: 0)
        vehUsageTypeShow.isActive = false
        vehUsageTypeShow = nil
        vehUsageTypeShow = heightConstraint
        NSLayoutConstraint.activate([vehUsageTypeShow])
        vehUsageType.layoutIfNeeded()
    }

    
    func hideMyHypoView(_ hide: Bool) {
        var constraintV: NSLayoutConstraint!
        if (hide)
        {
            constraintV = common.ShowAndHideView(ConstarintIs: hypoShow, isHidden: hide, andSize: 0.000000000001)
        }
        else
        {
            constraintV = common.ShowAndHideView(ConstarintIs: hypoShow, isHidden: hide, andSize: 0.24)
        }
        def.set(!hide, forKey: "IsVehicleFinanced")
        hypo.isHidden = hide
        hypoShow.isActive = false
        hypoShow = nil
        hypoShow = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([hypoShow])
        hypo.layoutIfNeeded()
    }

    func hideMyPUCView(_ hide: Bool) {
        var constraintV: NSLayoutConstraint!
        if (hide)
        {
            pucPosition.constant = 0
            constraintV = common.ShowAndHideView(ConstarintIs: pucPolShow, isHidden: hide, andSize: 0.000000000001)
        }
        else
        {
            pucPosition.constant = 10
            constraintV = common.ShowAndHideView(ConstarintIs: pucPolShow, isHidden: hide, andSize: 0.32)
        }
        def.set(!hide, forKey: "HasValidPUC")
        pucView.isHidden = hide
        pucPolShow.isActive = false
        pucPolShow = nil
        pucPolShow = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([pucPolShow, pucPosition])
        pucView.layoutIfNeeded()
    }
    
    func hideMyPUCVisibleView(_ hide: Bool) {
        var constraintV: NSLayoutConstraint!
        if (hide)
        {
            constraintV = common.ShowAndHideView(ConstarintIs: pucShow, isHidden: hide, andSize: 0)
        }
        else
        {
            constraintV = common.ShowAndHideView(ConstarintIs: pucShow, isHidden: hide, andSize: 1)
        }
        validPucView.isHidden = hide
        pucShow.isActive = false
        pucShow = nil
        pucShow = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([pucShow])
        validPucView.layoutIfNeeded()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldLabel()
        textField.resignFirstResponder()
        return true
    }
    
    private func validateVehicleNumber()
    {
        let k = vehicle.text?.replacingOccurrences(of: "-", with: "")
        var apiCall = common.buy+common.baseURL+common.home+common.validCheck+common.vNo+k!
        apiCall += common.subproduct+common.sharedUserDefaults().string(forKey: "SubProductCode")!
        APICallered().fetchData(apiCall) { response in
            let valid = Bool(truncating: response!.object(forKey: "Status") as! NSNumber)
            if (valid)
            {
                DispatchQueue.main.async {
                    self.isValid = valid
                    self.def.set(self.vehicle.text!, forKey: "RegistrationNumber")
                }
            }
            else
            {
                DispatchQueue.main.async {
                    let msg = response!.object(forKey: "Message") as! String
                    let alertVu = SCLAlertView(appearance: Common.sharedCommon.alertWithoutCancel)
                    alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
                        alertVu.hideView()
                    }
                    alertVu.showInfo("Alert!", subTitle: msg, closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                }
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 171:
                let c = (def.string(forKey: "RTOName")!).prefix(5)
                if (textField.text!.count < 5 || !textField.text!.contains(c))
                {
                    let alertVu = SCLAlertView.init(appearance:common.alertwithCancel)
                    alertVu.showError("Alert!", subTitle: "Please check the number as RTO is different", closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                }
                break
        case 173:
                let part = textField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                if (part.count >= 6)
                {
                    def.set(textField.text!, forKey: "EngineNumber")
                }
                break
        case 174:
                let part = textField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                if (part.count >= 6)
                {
                    def.set(textField.text!, forKey: "ChassisNumber")
                }
                break
        case 175:
                apiArray = nil
                apiArray = NSMutableArray.init()
                apiArray.addObjects(from: hypoFinArray as! [Any])
                let selectArr: NSArray = apiArray
                let str = textField.text! as String
                let emptyArr = NSMutableArray.init()
                
                for item in selectArr {
                    let nameDict = item as? NSDictionary
                    let string = (nameDict?.object(forKey: "Name") as! String)
                    if (string.lowercased().contains(str.lowercased()))
                    {
                        emptyArr.add(item)
                    }
                }
                if (str.elementsEqual(""))
                {
                    emptyArr.addObjects(from: apiArray as! [Any])
                }
                apiArray = nil
                apiArray = NSMutableArray.init()
                apiArray.addObjects(from: emptyArr as! [Any])
                apiTableView.reloadData()
                apiTableView.updateTableContentInset()
                break
        case 176:
                apiArray = nil
                apiArray = NSMutableArray.init()
                apiArray.addObjects(from: Common.cityArray as! [Any])
                let selectArr: NSArray = apiArray
                let str = textField.text! as String
                let emptyArr = NSMutableArray.init()
                
                for item in selectArr {
                    let nameDict = item as? NSDictionary
                    let string = (nameDict?.object(forKey: "Name") as! String)
                    if (string.lowercased().contains(str.lowercased()))
                    {
                        emptyArr.add(item)
                    }
                }
                if (str.elementsEqual(""))
                {
                    emptyArr.addObjects(from: apiArray as! [Any])
                }
                apiArray = nil
                apiArray = NSMutableArray.init()
                apiArray.addObjects(from: emptyArr as! [Any])
                apiTableView.reloadData()
                apiTableView.updateTableContentInset()
                break
        case 1777:
                def.set(textField.text!, forKey: "PUCNumber")
                break
        default:
            break
        }
    }
    
    private func textFieldLabel()
    {
        common.applyBorderToView(vehicle, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(registerDVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(engine, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(chasis, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(financier, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(city, withColor: Colors.textFldColor, ofSize: 1)
        
        if (!vehicle.hasText)
        {
            common.setTextFieldLabels(vehicle, vehicleLbl, true, vehicleLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(vehicle, vehicleLbl, false, "")
        }
        if (!engine.hasText)
        {
            common.setTextFieldLabels(engine, engineLbl, true, engineLbl.text!)
        }
        else{
            common.setTextFieldLabels(engine, engineLbl, false, "")
        }
        if (!chasis.hasText)
        {
            common.setTextFieldLabels(chasis, chasisLbl, true, chasisLbl.text!)
        }
        else{
            common.setTextFieldLabels(chasis, chasisLbl, false, "")
        }
        if (!financier.hasText)
        {
            common.setTextFieldLabels(financier, financierLbl, true, financierLbl.text!)
        }
        else{
            common.setTextFieldLabels(financier, financierLbl, false, "")
        }
        if (!city.hasText)
        {
            common.setTextFieldLabels(city, cityLbl, true, cityLbl.text!)
        }
        else{
            common.setTextFieldLabels(city, cityLbl, false, "")
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 171:
                common.setTextFieldLabels(vehicle, vehicleLbl, false, "")
                break
        case 173:
                common.setTextFieldLabels(engine, engineLbl,  false, "")
                break
        case 174:
                common.setTextFieldLabels(chasis, chasisLbl, false, "")
                break
        case 175:
                texFi = .finInst
                common.setTextFieldLabels(financier, financierLbl, false, "")
                apiArray = nil
                apiArray = NSMutableArray.init()
                if (hypoFinArray != nil){
                    apiArray.addObjects(from: hypoFinArray as! [Any])
                    apiTableView.reloadData()
                    apiTableView.updateTableContentInset()
                    apiTable.isHidden = false
                }
                placeMyTableViewAround(thisView: financierVu, andAT_BottomTop: false)
                break
        case 1777:
                common.setTextFieldLabels(pucNumber, pucNumberLbl, false, "")
                break
        case 1778:
            texFi = .veh_type
                common.setTextFieldLabels(vehUsageType, vehUsageTypeLbl, false, "")
            apiArray = nil
            apiArray = NSMutableArray.init()
            if (vehicleUsageArray != nil){
                apiArray.addObjects(from: vehicleUsageArray as! [Any])
                apiTableView.reloadData()
                apiTableView.updateTableContentInset()
                apiTable.isHidden = false
            }
            placeMyTableViewAround(thisView: vehUsageTypeVu, andAT_BottomTop: false)
                break
        default:
                texFi = .finCity
                common.setTextFieldLabels(city, cityLbl, false, "")
                apiArray = nil
                apiArray = NSMutableArray.init()
                if (Common.cityArray != nil){
                    apiArray.addObjects(from: Common.cityArray as! [Any])
                    apiTableView.reloadData()
                    apiTableView.updateTableContentInset()
                    apiTable.isHidden = false
                }
                placeMyTableViewAround(thisView: cityVu, andAT_BottomTop: false)
                break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldLabel()
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        
        if let text = textField.text?.uppercased(), let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if (textField.tag == 171)
            {
                if textField.text?.count == 2 && updatedText.count == 3 {
                    textField.text = textField.text! + "-" + string
                    return false
                }
                if textField.text?.count == 5 && updatedText.count == 6 {
                    textField.text = textField.text! + "-" + string
                    return false
                }
                if textField.text?.count == 8 && updatedText.count == 9 {
                    textField.text = textField.text! + "-" + string
                    return false
                }
            }
        }
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        var currentString: NSString = textField.text! as NSString
//        currentString =
//        currentString.replacingCharacters(in: range, with: string) as NSString
//        return true
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Common.yesNoBtnArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 12)
        if (collectionView.tag == 1434)
        {
            if (tappedHypo == indexPath.row)
            {
                cell.setSelectedData()
            }
        }
        else
        {
            if (tappedPUC == indexPath.row)
            {
                cell.setSelectedData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.tag == 1434)
        {
            tappedHypo = indexPath.row
            if (tappedHypo == 0)
            {
                hideMyHypoView(false)
            }
            else
            {
                hideMyHypoView(true)
            }
        }
        else
        {
            tappedPUC = indexPath.row
            if (tappedPUC == 0)
            {
                hideMyPUCView(false)
            }
            else
            {
                hideMyPUCView(true)
            }
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = common.getScreenSize(collectionView)
        return CGSize(width: 50, height: widthAndHeight.1*0.7);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10);
    }
    
    private func displayAlert()
    {
        common.removeImageForRestriction(vehicle!)
        common.removeImageForRestriction(engine!)
        common.removeImageForRestriction(chasis!)
        if (!vehicle.hasText)
        {
            common.displayImageForRestriction(vehicle!)
        }
        if (!engine.hasText)
        {
            common.displayImageForRestriction(engine!)
        }
        if (!chasis.hasText)
        {
            common.displayImageForRestriction(chasis!)
        }
        if (!additional.isHidden)
        {
            common.removeImageForRestriction(bodyType!)
            common.removeImageForRestriction(bodyColor!)
            
            if (bodyType.text!.elementsEqual("Body Type"))
            {
                common.displayImageForRestriction(bodyType!)
            }
            if (bodyColor.text!.elementsEqual("Body Color"))
            {
                common.displayImageForRestriction(bodyColor!)
            }
        }
        if (!hypo.isHidden)
        {
            common.removeImageForRestriction(financier!)
            common.removeImageForRestriction(city!)
            
            if (!financier.hasText)
            {
                common.displayImageForRestriction(financier!)
            }
            if (!city.hasText)
            {
                common.displayImageForRestriction(city!)
            }
        }
        if (!vehUsageTypeVu.isHidden)
        {
            common.removeImageForRestriction(vehUsageType!)
            if (!vehUsageType.text!.elementsEqual(""))
            {
                common.displayImageForRestriction(vehUsageType!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (apiArray == nil)
        {
            return 0
        }
        return apiArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
        let nameDict = (apiArray[indexPath.row]) as? NSDictionary
        let string = (nameDict?.object(forKey: "Name") as! String)
        cell.setDispaly(string)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameDict = (apiArray[indexPath.row]) as? NSDictionary
        let string = (nameDict?.object(forKey: "Name") as! String)
        
        switch (texFi)
        {
        case .finCity :
                city.text = string
                def.set(string, forKey: "FinancialInstAddress")
                city.resignFirstResponder()
                break
        case .finInst :
                financier.text = string
                def.set(string, forKey: "FinancialInstName")
                financier.resignFirstResponder()
                break
        case .bodyCol :
            bodyColor.text = string
            def.set(string, forKey: "BodyColor")
            break
        case .bodyTyp :
            bodyType.text = string
            def.set(string, forKey: "BodyType")
            break
        case .veh_type:
            vehUsageType.text = string
            def.set(nameDict!.object(forKey: "Id"), forKey: "FinancialInstAddress")
            break
        default:
            break
        }
        def.synchronize()
        tableView.superview!.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
