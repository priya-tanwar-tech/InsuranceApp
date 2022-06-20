//
//  GC_PC_MiscViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 11/04/22.
//

import Foundation
import UIKit
import MBProgressHUD

class GC_PC_MiscViewController : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var scrollVu: UIScrollView!
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
        
    @IBOutlet weak var selectCompanyView: UIView!
    @IBOutlet weak var selectCompanyLbl: UILabel!
    @IBOutlet weak var privacyTable: UIView!
    @IBOutlet weak var privacyTableView : UITableView!
    
    @IBOutlet weak var privacyTableShow: NSLayoutConstraint!
    @IBOutlet weak var keyboardView: NSLayoutConstraint!
    
    private let common = Common.sharedCommon
    private var dict : NSDictionary = NSDictionary.init()
    private var privacyArray : NSArray!
    private var keyboardIsOpen = false
    private var previousInsurerString : String!
    private var hud: MBProgressHUD = MBProgressHUD()
    
    override func viewDidLoad()
    {        
        hud.contentColor = .white
        hud.backgroundColor = common.hexStringToUIColor(hex: "#0FACC8")
        
        common.applyRoundedShapeToView(orLbl, withRadius: orLbl.frame.size.height/2)
        common.applyRoundedShapeToView(orView, withRadius: orView.frame.size.height/2)
        
        privacyTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let font = UIFont.init(name: "Montserrat-Medium", size: 16)
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        var api_url = Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.gc_pc_misc_insur+Constant.subProd_id

        switch(common.sharedUserDefaults().integer(forKey: "ProductCode"))
        {
        case 10:
            previousInsurerString = common.previousInsurers.replacingOccurrences(of: "-", with: "GoodsVehicle")

            api_url += String(common.sharedUserDefaults().integer(forKey: "ProductCode"))
            insuranceNameLbl.text = "Goods Vehicle"
            insuranceImage.image = UIImage.init(named: "Commercial Insurance")
            break
        case 9:
            previousInsurerString = common.previousInsurers.replacingOccurrences(of: "-", with: "PassengerVehicle")

            api_url += String(common.sharedUserDefaults().integer(forKey: "ProductCode"))
            insuranceNameLbl.text = "Passenger Vehicle"
            insuranceImage.image = UIImage.init(named: "Passenger Carrying")
            break
        default:
            previousInsurerString = common.previousInsurers.replacingOccurrences(of: "-", with: "MiscDVehicle")
            api_url += String(common.sharedUserDefaults().integer(forKey: "ProductCode"))
            insuranceNameLbl.text = "Miscellaneous Vehicle"
            insuranceImage.image = UIImage.init(named: "Misc Vehicle")
            break
        }
        insuranceDescription.text = "Protect you and your vehicle against a number of risks along with third-party liabilities"
        dontKnowBtn.setTitle("Forgot your vehicle number?", for: .normal)
        let attributeString = NSMutableAttributedString(
            string: "Got a new vehicle? Click here.",
            attributes: yourAttributes)
        gotNewCarBtn.setAttributedTitle(attributeString, for: UIControl.State.normal)
        common.applyRoundedShapeToView(VehicleregisterOne, withRadius: 5)
        common.applyRoundedShapeToView(selectCompanyView, withRadius: 5)
        
        common.applyBorderToView(VehicleregisterOne, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(selectCompanyView, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyRoundedShapeToView(getDetails, withRadius: 10)
        common.applyRoundedShapeToView(dontKnowBtn, withRadius: 10)

        privacyTable.backgroundColor = UIColor.clear
        common.applyShadowToView(privacyTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        selectCompanyView.addGestureRecognizer(tap)
        APICallered().fetchData(api_url) { response in
            self.dict = response ?? NSDictionary.init()
            DispatchQueue.main.async {
                self.privacyArray = self.dict.object(forKey: "Response") as? NSArray
                self.privacyTableView.reloadData()
            }
        }
        listViewIsHidden()
    }

    private func removeAllSavedData()
    {
        let def = common.sharedUserDefaults()
        def.removeObject(forKey: "VehicleSubType")
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
        let sub_prod_id = String(common.sharedUserDefaults().integer(forKey: "ProductCode"))
        // for register Area
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.rtoCity) { response in
            Common.registerAreaArr = response?.object(forKey: "Response") as? NSArray
        }
        let vehicle_type = common.sharedUserDefaults().string(forKey: "SubProductCode")!.replacingOccurrences(of: "MTR", with: "")
        let companyId = String(common.sharedUserDefaults().integer(forKey: "selectedCompany"))
        // for manufacturer

        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+vehicle_type+Constant.manufacturer+Constant.companyId+companyId) { response in
            Common.manufacturerArray = response?.object(forKey: "Response") as? NSArray
        }
        // for model
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.model+Constant.subProd_id+sub_prod_id+Constant._companyId+companyId) { response in
            Common.modelArray = response?.object(forKey: "Response") as? NSArray
        }
        // for variant
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.variant+Constant.subProd_id+sub_prod_id+Constant._companyId+companyId) { response in
            Common.variantArray = response?.object(forKey: "Response") as? NSArray
        }
        
        // for previous Insurers
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+previousInsurerString) { response in
            Common.insurerArray = response?.object(forKey: "Response") as? NSArray
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
        removeAllSavedData()
        selectCompanyLbl.text = "Select Company"
        VehicleregisterOne.text = ""
        textFieldLabel()
    }
    
    private func listViewIsHidden()
    {
        var high = 160.0
        if (privacyTable.isHidden)
        {
            high = 0.1
        }
        privacyTableShow.constant = high
        privacyTable.layoutIfNeeded()
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
        if (selectCompanyLbl.text!.elementsEqual("Select Company"))
        {
            selectCompanyAlert()
        }
        else if (VehicleregisterOne.hasText)
        {
            
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Processing"
            loadMyCarArrays()
            var userIdWithVehicleNumber : String! = common.sharedUserDefaults().string(forKey: "UserId")
            
            let vehNumber = VehicleregisterOne.text!.replacingOccurrences(of: "-", with: "")
            
            userIdWithVehicleNumber += "|"+vehNumber
            let msg = userIdWithVehicleNumber.data(using: .utf8)
            let encryptedData = common.testCrypt(data: msg!, IsEncryption: true)
            let token = encryptedData.base64EncodedString()
            let apiCall = Constant.buyAPI+Constant.baseURL+Constant.home+Constant.validVehCheck+Constant.vehNo+vehNumber+Constant._subprod+common.sharedUserDefaults().string(forKey: "SubProductCode")!
            APICallered().fetchData(apiCall) { response in
                let mn : NSDictionary = response!
                let valid : Bool = (mn.object(forKey: "Status") != nil)
                if (valid)
                {
                    DispatchQueue.main.async { [self] in
                        APICallered().fetchData(Constant.buyAPI+Constant.baseURL+Constant.home+Constant.VehRegiDetail+Constant.vehNo+vehNumber+Constant.tokenNum+token) { response in
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
                                    let kkkk = (response?.object(forKey: "errors") as! NSDictionary)
                                    let msg = (kkkk.object(forKey: "message") as! String)
                                    print(msg)
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
                        let alertVu = SCLAlertView(appearance: Common.sharedCommon.alertWithoutCancel)
                        alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
                            alertVu.hideView()
                        }
                        alertVu.showInfo("Alert!", subTitle: "Entered vehicle number is not correct. Kindly check the number", closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                    }
                }
            }
        }
        else
        {
            let alertVu = SCLAlertView(appearance: Common.sharedCommon.alertwithCancel)
            alertVu.showWarning("Kindly enter the valid vehicle number.", subTitle: nil, closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
        }
    }
    
    func selectCompanyAlert()
    {
        let alertVu = SCLAlertView(appearance: Common.sharedCommon.alertWithoutCancel)
        alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
            alertVu.hideView()
        }
        alertVu.showInfo("Alert!", subTitle: "Kindly select the company first.", closeButtonTitle: nil, timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }
    
    func loadToNextOne(_ policyType : String, _textField txtFld : UITextField)
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let secondViewController = storyboard.instantiateViewController(withIdentifier:"GCPCMiscRegistrationViewController") as! GCPCMiscRegistrationViewController
        let def = self.common.sharedUserDefaults()
        def.set(txtFld.text!, forKey: "RegistrationNumber")
        def.setValue(policyType, forKey: "PolicyType")
        def.synchronize()
        secondViewController.enteredVehicleNumber = txtFld.text!
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    private func hideMyFields()
    {
        VehicleregisterOne.resignFirstResponder()
    }
    
    @IBAction func dontKnowTapped(_ sender: UIButton) {
        if (!selectCompanyLbl.text!.elementsEqual("Select Company"))
        {
            hideMyFields()
            self.loadMyCarArrays()
            let def = common.sharedUserDefaults()
            def.setValue("Renewal", forKey: "PolicyType")
            def.removeObject(forKey: "RegistrationNumber")
            def.synchronize()
            common.goToNextScreenWith("GCPCMiscRegistrationViewController", self)
        }
        else
        {
            selectCompanyAlert()
        }
    }
    
    @IBAction func gotNewTapped(_ sender: UIButton) {
        if (!selectCompanyLbl.text!.elementsEqual("Select Company"))
        {
            hideMyFields()
            self.loadMyCarArrays()
            let def = common.sharedUserDefaults()
            def.setValue("New", forKey: "PolicyType")
            def.removeObject(forKey: "RegistrationNumber")
            def.set(true, forKey: "DontKnowPreviousInsurer")
            def.synchronize()
            common.goToNextScreenWith("GCPCMiscRegistrationViewController", self)
        }
        else
        {
            selectCompanyAlert()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func textFieldLabel()
    {
        common.applyBorderToView(VehicleregisterOne, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(selectCompanyView, withColor: Colors.textFldColor, ofSize: 1)
        
        if (!VehicleregisterOne.hasText)
        {
            common.setTextFieldLabels(VehicleregisterOne, vehicleRegisterOneLbl, true, "Vehicle Registration Number")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        common.setTextFieldLabels(VehicleregisterOne, vehicleRegisterOneLbl, false, "")
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField.text!.count > 12)
        {
            if ((textField.text!.suffix(4).rangeOfCharacter(from: NSCharacterSet.decimalDigits)) != nil)
            {
                textField.resignFirstResponder()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldLabel()
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
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
        return true
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
        selectCompanyLbl.text = string
        common.sharedUserDefaults().set((nameDict?.object(forKey: "Id") as! String), forKey: "selectedCompany")
        common.sharedUserDefaults().synchronize()
        privacyTable.isHidden = true
        listViewIsHidden()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
