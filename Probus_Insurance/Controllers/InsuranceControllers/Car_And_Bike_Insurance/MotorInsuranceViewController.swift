//
//  MotorInsuranceViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 01/12/21.
//

import Foundation
import UIKit
import MBProgressHUD


class MotorInsuranceViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var insuranceNameLbl: UILabel!
    @IBOutlet weak var insuranceImage: UIImageView!
    @IBOutlet weak var insuranceDescription: UILabel!
    
    @IBOutlet weak var vehicleRegisterOneLbl: UILabel!
    @IBOutlet weak var VehicleregisterOne: UITextField!
    
    @IBOutlet weak var getDetails: UIButton!
    @IBOutlet weak var orView: UIView!
    @IBOutlet weak var orLbl: UILabel!
    
    @IBOutlet weak var dontKnowBtn: UIButton!
    @IBOutlet weak var gotNewCarBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomCardView: UIView!
    @IBOutlet weak var probusRenewLbl: UILabel!
    
    @IBOutlet weak var selectPrivacyView: UIView!
    @IBOutlet weak var selectPrvacyLbl: UILabel!
    @IBOutlet weak var privacyTable: UIView!
    @IBOutlet weak var privacyTableView : UITableView!
    
    @IBOutlet weak var vehicleRegisterTwoField: UITextField!
    @IBOutlet weak var vehicleregisterTwoLbl: UILabel!
    
    @IBOutlet weak var privacyPolicyField: UITextField!
    @IBOutlet weak var privacyPolicyLbl: UILabel!
    @IBOutlet weak var getDetailsOfPolicy: UIButton!
    
    @IBOutlet weak var alreadyQuotationView: UIView!
    @IBOutlet weak var alreadyLbl: UILabel!
    @IBOutlet weak var alreadyCollection: UICollectionView!
    
    @IBOutlet weak var quotationView: UIView!
    @IBOutlet weak var quotationCardView: UIView!
    @IBOutlet weak var probusQuotationLbl: UILabel!
    
    @IBOutlet weak var quotationField: UITextField!
    @IBOutlet weak var quotationLnl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var privacyTableShow: NSLayoutConstraint!
    @IBOutlet weak var quotationViewShow: NSLayoutConstraint!
    @IBOutlet weak var quotationViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardView: NSLayoutConstraint!
    
    private let common = Common.sharedCommon
    private var dict : NSDictionary = NSDictionary.init()
    private var tappedValue: Int! = 1
    private var privacyArray : NSArray!
    private var keyboardIsOpen = false
    private var previousInsurerString : String!
    private var hud: MBProgressHUD = MBProgressHUD()
    
    override func viewDidLoad()
    {
        hud.contentColor = .white
        hud.backgroundColor = common.hexStringToUIColor(hex: "#0FACC8")
        common.applyRoundedShapeToView(orLbl, withRadius: orView.frame.size.height/2)
        common.applyRoundedShapeToView(submitBtn, withRadius: 10)
        common.applyBorderToView(submitBtn, withColor: common.hexStringToUIColor(hex: "#53C0D4"), ofSize: 1)
        
        probusQuotationLbl.highlightMyText(probusQuotationLbl.text!, searchedText: "Quotation", colorValue: common.hexStringToUIColor(hex: "#0FACC8"), withFontName: probusQuotationLbl.font)
        probusRenewLbl.highlightMyText(probusRenewLbl.text!, searchedText: "Renew", colorValue: common.hexStringToUIColor(hex: "#0FACC8"), withFontName: probusRenewLbl.font)
        alreadyLbl.highlightMyText(alreadyLbl.text!, searchedText: "Quotation?", colorValue: common.hexStringToUIColor(hex: "#00B8CD"), withFontName: UIFont.init(name: "Montserrat-Medium", size: 16)!)
        privacyTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        alreadyCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let font = UIFont.init(name: "Montserrat-Medium", size: 16)
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        var attributeString : NSMutableAttributedString!
        switch(common.sharedUserDefaults().integer(forKey: "ProductCode"))
        {
        case 2:
            previousInsurerString = common.previousInsurers.replacingOccurrences(of: "-", with: "Privatecar")
            insuranceNameLbl.text = "Private Car"
            insuranceDescription.text = "Protect you and your vehicle against a number of risks along with third-party liabilities"
            insuranceImage.image = UIImage.init(named: "Car Insurance")
            dontKnowBtn.setTitle("Forgot your car number?", for: .normal)
            attributeString = NSMutableAttributedString(
                string: "Got a new car? Click here.",
                attributes: yourAttributes
            )
            break
        default:
            previousInsurerString = common.previousInsurers.replacingOccurrences(of: "-", with: "TwoWheeler")
            insuranceNameLbl.text = "Two Wheeler"
            insuranceDescription.text = "Protect you and your vehicle against a number of risks along with third-party liabilities"
            insuranceImage.image = UIImage.init(named: "Two Wheeler")
            dontKnowBtn.setTitle("Forgot your bike number?", for: .normal)
            attributeString = NSMutableAttributedString(
                string: "Got a new bike? Click here.",
                attributes: yourAttributes
            )
            break
        }
        gotNewCarBtn.setAttributedTitle(attributeString, for: UIControl.State.normal)
        common.applyRoundedShapeToView(VehicleregisterOne, withRadius: 5)
        common.applyRoundedShapeToView(quotationField, withRadius: 5)
        common.applyRoundedShapeToView(vehicleRegisterTwoField, withRadius: 5)
        common.applyRoundedShapeToView(privacyPolicyField, withRadius: 5)
        common.applyRoundedShapeToView(selectPrivacyView, withRadius: 5)
        
        common.applyBorderToView(VehicleregisterOne, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(quotationField, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(vehicleRegisterTwoField, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(privacyPolicyField, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(selectPrivacyView, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyRoundedShapeToView(getDetails, withRadius: 10)
        common.applyRoundedShapeToView(dontKnowBtn, withRadius: 10)
        common.applyRoundedShapeToView(quotationCardView, withRadius: 15)
        common.applyRoundedShapeToView(bottomCardView, withRadius: 15)
        common.applyShadowToView(quotationView, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(bottomView, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        
        privacyTable.backgroundColor = UIColor.clear
        common.applyShadowToView(privacyTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        selectPrivacyView.addGestureRecognizer(tap)
        
        loadMyCarArrays()
        listViewIsHidden()
    }
    
    
    private func removeAllSavedData()
    {
        let def = common.sharedUserDefaults()
        //        let dict = common.sharedUserDefaults().dictionaryRepresentation()
        //        for item in dict.keys {
        //            common.sharedUserDefaults().removeObject(forKey: item)
        //        }
        
        def.removeObject(forKey: "carDetails")
        def.removeObject(forKey: "CustomIDVAmount")
        def.removeObject(forKey: "ChassisNumber")
        def.removeObject(forKey: "EngineNumber")
        def.removeObject(forKey: "VehicleAddress")
        def.removeObject(forKey: "PolicyNumber")
        def.removeObject(forKey: "CommunicationAddress")
        def.removeObject(forKey: "ClientDetails")
        def.removeObject(forKey: "NomineeAppointeeDetails")
        def.removeObject(forKey: "VehicleAddress")
        def.removeObject(forKey: "CommunicationAddress")
        def.removeObject(forKey: "FinancialInstAddress")
        def.removeObject(forKey: "FinancialInstName")
        def.removeObject(forKey: "PrevPolicyInsurerCompanyCode")
        def.removeObject(forKey: "PrevPolicyInsurerCShortName")
        def.removeObject(forKey: "PrevPolicyInsurerId")
        def.removeObject(forKey: "PrevPolicyInsurerCompanyName")
        def.removeObject(forKey: "PrevPolicyInsurerIndex")
        def.removeObject(forKey: "PrevPolicyInsurerChecked")
        def.removeObject(forKey: "PrevPolicyExpiryStatus")
        def.removeObject(forKey: "ExpiryDate")
        def.removeObject(forKey: "RTOTopCityName")
        def.removeObject(forKey: "RTOZone")
        def.removeObject(forKey: "RTOCityName")
        def.removeObject(forKey: "RTOCityId")
        def.removeObject(forKey: "RTOName")
        def.removeObject(forKey: "RTOTopCity")
        def.removeObject(forKey: "MakeName")
        def.removeObject(forKey: "MakeId")
        def.removeObject(forKey: "MakeTop")
        def.removeObject(forKey: "ModelId")
        def.removeObject(forKey: "ModelName")
        def.removeObject(forKey: "ModelTop")
        def.removeObject(forKey: "IsFullyBuilt")
        def.removeObject(forKey: "VariantTop")
        def.removeObject(forKey: "FuelType")
        def.removeObject(forKey: "VariantId")
        def.removeObject(forKey: "VariantName")
        def.removeObject(forKey: "FuelId")
        def.removeObject(forKey: "RegistrationYear")
        def.removeObject(forKey: "ManufaturingDate")
        def.removeObject(forKey: "RegistrationDate")
        def.removeObject(forKey: "PurchaseDate")
        def.removeObject(forKey: "PreviousPolicyState")
        def.removeObject(forKey: "PreviousPolicyStateCode")
        def.removeObject(forKey: "PreviousPolicyStateName")
        def.removeObject(forKey: "PreviousPolicyCity")
        def.removeObject(forKey: "PreviousPolicyCityCode")
        def.removeObject(forKey: "PreviousPolicyCityName")
        def.synchronize()
    }
    
    private func loadMyCarArrays()
    {

        let sub_prod_id = common.sharedUserDefaults().integer(forKey: "ProductCode")
        var productName = common.twowheeler
        if (sub_prod_id == 2)
        {
            productName = common.privatecar
        }

        // for register Area
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+common.rtoCity) { response in
            Common.registerAreaArr = response?.object(forKey: "Response") as? NSArray
        }
        let vehicle_type = common.sharedUserDefaults().string(forKey: "SubProductCode")!.replacingOccurrences(of: "MTR", with: "")
        // for manufacturer
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+vehicle_type+common.manufacturer) { response in
            Common.manufacturerArray = response?.object(forKey: "Response") as? NSArray
        }

        // for model
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+common.model+common.subProd_ID+String(sub_prod_id)) { response in
            Common.modelArray = response?.object(forKey: "Response") as? NSArray
        }
        
        // for variant
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+common.variant+common.subProd_ID+String(sub_prod_id)) { response in
            Common.variantArray = response?.object(forKey: "Response") as? NSArray
        }
        
        // for previous Insurers
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+previousInsurerString) { response in
            Common.insurerArray = response?.object(forKey: "Response") as? NSArray
        }
        
        APICallered().fetchData(common.A_P_I+common.baseURL+common.forApi+common.motor+productName+common.probusRenewal) { response in
            self.dict = response ?? NSDictionary.init()
            self.privacyArray = self.dict.object(forKey: "Response") as? NSArray
            DispatchQueue.main.async {
                self.privacyTableView.reloadData()
                self.privacyTableView.updateTableContentInset()
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        keyboardIsOpen = false
        if (privacyTable.isHidden && (!(privacyArray==nil)))
        {
            privacyTable.isHidden = false
        }
        
        listViewIsHidden()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        VehicleregisterOne.text = ""
        vehicleRegisterTwoField.text = ""
        privacyPolicyField.text = ""
        selectPrvacyLbl.text = "Select Privacy Policy"
        quotationField.text = ""
        removeAllSavedData()
        textFieldLabel()
    }
    
    private func hideMyView()
    {
        var constraintV: NSLayoutConstraint!
        if (tappedValue == 1)
        {
            constraintV = common.ShowAndHideView(ConstarintIs: quotationViewShow, isHidden: true, andSize: 0.001)
            quotationViewBottom.constant = 0
            quotationView.isHidden = true
        }
        else
        {
            constraintV = common.ShowAndHideView(ConstarintIs: quotationViewShow, isHidden: false, andSize: 0.28)
            quotationViewBottom.constant = 30
            quotationView.isHidden = false
        }
        quotationViewShow.isActive = false
        quotationViewShow = nil
        quotationViewShow = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([quotationViewShow])
        quotationView.layoutIfNeeded()
    }
    
    private func listViewIsHidden()
    {
        var high = 0.41//0.33
        if (privacyTable.isHidden)
        {
            high = 0.000000000001
        }
        
        let constraintV = common.ShowAndHideView(ConstarintIs: privacyTableShow, isHidden: true, andSize: high)
        
        privacyTableShow.isActive = false
        privacyTableShow = nil
        privacyTableShow = constraintV
        NSLayoutConstraint.activate([privacyTableShow])
        privacyTable.layoutIfNeeded()
        privacyTableView.updateTableContentInset()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if (!keyboardIsOpen)
            {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyboardView.constant = keyboardHeight
                keyboardIsOpen = true
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabel()
        keyboardIsOpen = false
        keyboardView.constant = 0
    }
    
    @IBAction func backBtntapped(_ sender: UIButton) {
        hideMyFields()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getDetailsBtnTapped(_ sender: UIButton) {
        hideMyFields()
        if (VehicleregisterOne.hasText)
        {
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Processing"
            var userIdWithVehicleNumber : String! = "0"
            if (common.sharedUserDefaults().object(forKey: "UserId") != nil)
            {
                userIdWithVehicleNumber = String(common.sharedUserDefaults().integer(forKey: "UserId"))
            }
            let vehNumber = VehicleregisterOne.text!.replacingOccurrences(of: "-", with: "")
            
            userIdWithVehicleNumber += "|"+vehNumber
            let msg = userIdWithVehicleNumber.data(using: .utf8)
            let encryptedData = common.testCrypt(data: msg!, IsEncryption: true)
            let token = encryptedData.base64EncodedString()
            let apiCall = common.buy+common.baseURL+common.home+common.validCheck+common.vNo+vehNumber+common.subproduct+common.sharedUserDefaults().string(forKey: "SubProductCode")!
            APICallered().fetchData(apiCall) { response in
                let valid = Bool(truncating: response!.object(forKey: "Status") as! NSNumber)
                if (valid)
                {
                    DispatchQueue.main.async { [self] in
                        let detailURL = self.common.buy+self.common.baseURL+self.common.home+self.common.VehilceRegisterationDetail+self.common.vNo+vehNumber+self.common.tokenNumber+token
                        APICallered().fetchData(detailURL) { response in
                            if ((response?.object(forKey: "data")) != nil)
                            {
                                DispatchQueue.main.async {
                                    let carData = (response?.object(forKey: "data")) as! NSDictionary
                                    self.common.archiveMyDataForDictionary(carData, withKey: "carDetails")
                                    self.loadToNextOne("Renewal", _textField: self.VehicleregisterOne)
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    let msg = ((response?.object(forKey: "errors") as! NSDictionary).object(forKey: "message") as! String)
                                    let alertVu =  SCLAlertView(appearance: Common.sharedCommon.alertWithoutCancel)
                                    alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
                                        alertVu.hideView()
                                        self.loadToNextOne("Renewal", _textField: self.VehicleregisterOne)
                                    }
                                    alertVu.showInfo("Alert", subTitle: msg, closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                                }
                            }
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        let msg = response!.object(forKey: "Message") as! String
                        let alertVu = SCLAlertView(appearance: Common.sharedCommon.alertWithoutCancel)
                        alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            alertVu.hideView()
                        }
                        alertVu.showInfo("Alert!", subTitle: msg, closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                    }
                }
            }
        }
        else
        {
            let alertVu = SCLAlertView(appearance: Common.sharedCommon.alertwithCancel)
            alertVu.showWarning("Please enter the valid vehicle number first", subTitle: nil, closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
        }
    }
    
    func loadToNextOne(_ policyType : String, _textField txtFld : UITextField)
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier:"MotorRegistrationViewController") as! MotorRegistrationViewController
        let def = self.common.sharedUserDefaults()
        def.set(txtFld.text!, forKey: "RegistrationNumber")
        def.setValue(policyType, forKey: "PolicyType")
        def.synchronize()
        secondViewController.enteredVehicleNumber = txtFld.text!
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    private func hideMyFields()
    {
        privacyPolicyField.resignFirstResponder()
        vehicleRegisterTwoField.resignFirstResponder()
        VehicleregisterOne.resignFirstResponder()
        quotationField.resignFirstResponder()
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        hideMyFields()
        let def = common.sharedUserDefaults()
        def.setValue("Renewal", forKey: "PolicyType")
        def.synchronize()
//        let quotationDetails = "PIBLMTRPC2021120813525876"
        let string = quotationField.text!.uppercased() as String
        let v = common.isValidQuotation(string)
        if (v)
        {
            APICallered().fetchData(common.testAPI+common.baseURL+common.forApi+common.motor+common.quotationDetails+common.quot_Number+string) { response in
                if (!((response?.object(forKey: "Message") as! String).elementsEqual("No data found.")))
                {
                    let k = (response?.object(forKey: "Response") as! NSArray).object(at: 0) as? NSDictionary
                    let m = k?.object(forKey: "Request") as! String
                    let r = self.common.convertToDictionary(text: m)
                    print( r ?? "")
                }
                else
                {
                    DispatchQueue.main.async {
                        let alertVu = SCLAlertView(appearance: Common.sharedCommon.alertwithCancel)
                        alertVu.showError("Alert!", subTitle: "Wrong Quotation Number", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                    }
                }
            }
        }
    }
    
    @IBAction func dontKnowTapped(_ sender: UIButton) {
        hideMyFields()
        let def = common.sharedUserDefaults()
        def.setValue("Renewal", forKey: "PolicyType")
        def.removeObject(forKey: "RegistrationNumber")
        def.synchronize()
        common.goToNextScreenWith("MotorRegistrationViewController", self)
    }
    
    @IBAction func gotNewTapped(_ sender: UIButton) {
        hideMyFields()
        let def = common.sharedUserDefaults()
        def.setValue("New", forKey: "PolicyType")
        def.removeObject(forKey: "RegistrationNumber")
        def.set(true, forKey: "DontKnowPreviousInsurer")
        def.synchronize()
        common.goToNextScreenWith("MotorRegistrationViewController", self)
    }
    
    @IBAction func getDetailsOfPolicyTapped(_ sender: UIButton) {
        hideMyFields()
        if (vehicleRegisterTwoField.hasText && privacyPolicyField.hasText && !selectPrvacyLbl.text!.elementsEqual("Select Privacy Policy"))
        {
            let def = common.sharedUserDefaults()
            def.set(self.privacyPolicyField.text!, forKey: "PolicyNumber")
            def.synchronize()
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Processing"
            
            let k = vehicleRegisterTwoField.text?.replacingOccurrences(of: "-", with: "")
            var apiCall = common.buy+common.baseURL+common.home+common.validCheck+common.vNo+k!
            apiCall = apiCall+common.subproduct+def.string(forKey: "SubProductCode")!

            APICallered().fetchData(apiCall) { response in
                let valid = Bool(truncating: response!.object(forKey: "Status") as! NSNumber)
                if (valid)
                {
                    DispatchQueue.main.async { [self] in
                        
                        var productName = self.common.twowheeler
                        if (common.sharedUserDefaults().integer(forKey: "ProductCode") == 2)
                        {
                            productName = self.common.privatecar
                        }
                        var apiurl = self.common.A_P_I+self.common.baseURL+self.common.forApi+self.common.motor+productName+self.common.GetDetailsForProbusRenewal+self.common.brokerId+"PIBL"+self.common.device+"3"+self.common.previousInsurerCode+String(self.common.sharedUserDefaults().integer(forKey: "previousInsurerCode"))
                        apiurl += self.common.prevPolicyNumb+self.privacyPolicyField.text!
                        apiurl += self.common.regNumb+vehicleRegisterTwoField.text!
                        //        https://api.probusinsurance.com/api/Motor/TwoWheeler/GetDetailsForProbusRenewal?BrokerId=PIBL&DeviceId=1&previousInsurerCode=8&previousPolicyNumber=2312101033054400000&registrationNumber=RJ-27-BE-5161

                        APICallered().fetchData(apiurl) { response in
                            
                            if ((response?.object(forKey: "Response")) != nil)
                            {
                                DispatchQueue.main.async {
                                    let carData = (response!.object(forKey: "Response")) as! NSDictionary
                                    self.common.archiveMyDataForDictionary(carData, withKey: "BrokerRenewal")
                                    self.loadToNextOne("BrokerRenewal ", _textField: self.vehicleRegisterTwoField)
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    let msg = ((response?.object(forKey: "errors") as! NSDictionary).object(forKey: "message") as! String)
                                    let alertVu =  SCLAlertView(appearance: Common.sharedCommon.alertWithoutCancel)
                                    alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
                                        alertVu.hideView()
                                        self.loadToNextOne("BrokerRenewal", _textField: self.vehicleRegisterTwoField)
                                    }
                                    alertVu.showInfo("Alert", subTitle: msg, closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                                }
                            }
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        let msg = response!.object(forKey: "Message") as! String
                        let alertVu = SCLAlertView(appearance: Common.sharedCommon.alertWithoutCancel)
                        alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            alertVu.hideView()
                        }
                        alertVu.showInfo("Alert!", subTitle: msg, closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func textFieldLabel()
    {
        common.applyBorderToView(VehicleregisterOne, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(quotationField, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(vehicleRegisterTwoField, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(privacyPolicyField, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(selectPrivacyView, withColor: Colors.textFldColor, ofSize: 1)
        
        if (!vehicleRegisterTwoField.hasText)
        {
            common.setTextFieldLabels(vehicleRegisterTwoField, vehicleregisterTwoLbl, true, "Vehicle Registration Number")
        }
        if (!VehicleregisterOne.hasText)
        {
            common.setTextFieldLabels(VehicleregisterOne, vehicleRegisterOneLbl, true, "Vehicle Registration Number")
        }
        if (!quotationField.hasText)
        {
            common.setTextFieldLabels(quotationField, quotationLnl, true, "Quotation Number")
        }
        if (!privacyPolicyField.hasText)
        {
            common.setTextFieldLabels(privacyPolicyField, privacyPolicyLbl, true, "Previous Policy Number")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 11:
                common.setTextFieldLabels(VehicleregisterOne, vehicleRegisterOneLbl, false, "")
            break
        case 12:
                common.setTextFieldLabels(quotationField, quotationLnl, false, "")
            break
        case 13:
                common.setTextFieldLabels(vehicleRegisterTwoField, vehicleregisterTwoLbl,  false, "")
            break
        default:
                common.setTextFieldLabels(privacyPolicyField, privacyPolicyLbl, false, "")
            break
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField.tag == 11 || textField.tag == 13)
        {
            if (textField.text!.count >= 13)
            {
                textField.resignFirstResponder()
            }
        }
    }
    
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textFieldLabel()
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if (textField.tag == 11 || textField.tag == 13)
            {
                if (textField.text!.count > 13)
                {
                    textField.resignFirstResponder()
                    return false
                }
                else
                {
                    if (range.location == 2)
                    {
                        textField.text = textField.text! + "-" + string
                        return false
                    }
                    var mySubstring : String!
                    if (!textField.text!.isEmpty)
                    {
                        let index = textField.text!.index(textField.text!.startIndex, offsetBy: 2)
                        mySubstring = String(textField.text!.prefix(upTo: index))
                        if (mySubstring.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil)
                        {
                            if (range.location == 5)
                            {
                                textField.text = textField.text! + "-" + string
                                return false
                            }
                            if (range.location == 10)
                            {
                                textField.text = textField.text! + "-" + string
                                return false
                            }
                        }
                        else if (mySubstring.rangeOfCharacter(from: NSCharacterSet.letters) != nil)
                        {
                            if (range.location == 2 || range.location == 4)
                            {
                                if (string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil)
                                {
                                    return true
                                }
                                else if (range.location == 4 && string.rangeOfCharacter(from: NSCharacterSet.letters) != nil)
                                {
                                    textField.text = textField.text! + "-" + string
                                    return false
                                }
                                else
                                {
                                    return false
                                }
                            }
                        }
                    }
                    
                    //                let index = enteredVehicleNumber.index(enteredVehicleNumber.startIndex, offsetBy: 5)
                    //                let mySubstring = enteredVehicleNumber.prefix(upTo: index).uppercased()
                    
                    if textField.text?.count == 2 && updatedText.count == 3 {
                        textField.text = textField.text! + "-" + string
                        return false
                    }
                }
            }
        }
        return true
    }
*/
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textFieldLabel()
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if (textField.tag == 11 || textField.tag == 13)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Common.yesNoBtnArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 12)
        if (tappedValue == indexPath.row)
        {
            cell.setSelectedData()
        }
        hideMyView()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedValue = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = common.getScreenSize(collectionView)
        var sizes: CGSize = CGSize.init(width: 0, height: 0)
        let CellHeight = widthAndHeight.1*0.5
        sizes = CGSize(width: 50, height: CellHeight)
        return sizes;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (privacyArray == nil)
        {
            return 0
        }
        return privacyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
        let nameDict = (privacyArray[indexPath.row]) as? NSDictionary
        let string = nameDict?.object(forKey: "Name") as! String
        cell.setDispaly(string)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameDict = (privacyArray[indexPath.row]) as? NSDictionary
        let string = nameDict?.object(forKey: "Name") as! String
        selectPrvacyLbl.text = string
        common.sharedUserDefaults().set((nameDict?.object(forKey: "Id") as! String), forKey: "previousInsurerCode")
        common.sharedUserDefaults().synchronize()
        privacyTable.isHidden = true
        listViewIsHidden()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
