//
//  PolicyDetailViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 18/01/22.
//

import Foundation
import UIKit

class PolicyDetailViewController : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var claimAmtVu: UIView!
    @IBOutlet weak var claimValue: UITextField!
    @IBOutlet weak var claimLbl: UILabel!
    @IBOutlet weak var claimHigh: NSLayoutConstraint!
    @IBOutlet weak var claimTop: NSLayoutConstraint!
    
    @IBOutlet weak var policyNumberVu: UIView!
    @IBOutlet weak var policyNumber: UITextField!
    @IBOutlet weak var policyNumberLbl: UILabel!

    @IBOutlet weak var stateVu: UIView!
    @IBOutlet weak var stateName: UITextField!
    @IBOutlet weak var stateLbl: UILabel!
    
    @IBOutlet weak var cityVu: UIView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!

    @IBOutlet weak var policyVu: UIView!
    @IBOutlet weak var policyName: UILabel!
    
    @IBOutlet weak var ncbVu: UIView!
    @IBOutlet weak var ncbValue: UILabel!
    
    @IBOutlet weak var expiryVu: UIView!
    @IBOutlet weak var policyExpiry: UILabel!

    @IBOutlet weak var apiTable: UIView!
    @IBOutlet weak var apiTableView : UITableView!
    @IBOutlet weak var apiTableTop : NSLayoutConstraint!

    @IBOutlet weak var continueVu: UIButton!

    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var quotationLabel: UILabel!
    @IBOutlet weak var keyboardView : NSLayoutConstraint!

    private var keyboardIsOpen = false

    private let common = Common.sharedCommon
    private var apiArray : NSMutableArray!
    private var stateArray : NSArray!
    private var cityArray : NSArray!
    private let def = Common.sharedCommon.sharedUserDefaults()
    
    enum textFi {
        case PolicyCity
        case PolicyState
        case policy
    }
    private var texFi = textFi.policy
        
    override func viewDidLoad() {
     
        let vehiclName = def.string(forKey: "MakeName")! + " " + def.string(forKey: "ModelName")! + " " + def.string(forKey: "VariantName")!
        vehicleDetails.text = vehiclName
        quotationLabel.text = def.string(forKey: "QuotationNumber")
        policyName.text = def.string(forKey: "PrevPolicyInsurerCompanyName")
        policyExpiry.text = def.string(forKey: "ExpiryDate")
        ncbValue.text = String(def.integer(forKey: "PreviousNcbPercentage"))

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
            progressBar.setProgress((5/7), animated: true)
        }
        else
        {
            progressBar.setProgress((5/6), animated: true)
        }
        
        if (def.bool(forKey:"IsPreviousInsuranceClaimed"))
        {
            hideMyView(false)
            claimValue.text = "0"
        }
        else
        {
            hideMyView(true)
        }
        
        applyRoundedShapeToViews()
        textFieldLabel()
        common.addDoneButtonOnNumpad(textField: claimValue)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let k = def.object(forKey: "ThisCompany") as! String
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.stateBy+Constant.companyC+k) { response in
            self.stateArray = response?.object(forKey: "Response") as? NSArray
        }
    }
    
    private func applyRoundedShapeToViews()
    {
        common.applyRoundedShapeToView(policyNumber, withRadius: 5)
        common.applyRoundedShapeToView(stateName, withRadius: 5)
        common.applyRoundedShapeToView(claimValue, withRadius: 5)
        common.applyRoundedShapeToView(city, withRadius: 5)
        common.applyRoundedShapeToView(policyVu, withRadius: 5)
        common.applyRoundedShapeToView(ncbVu, withRadius: 5)
        common.applyRoundedShapeToView(expiryVu, withRadius: 5)
        common.applyRoundedShapeToView(continueVu, withRadius: 10)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if (!keyboardIsOpen)
        {
            keyboardIsOpen = true
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
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
    
    func hideMyView(_ hide: Bool) {
        if (hide)
        {
            claimTop.constant = 0
            claimHigh.constant = 0.1
        }
        else
        {
            claimTop.constant = 10
            claimHigh.constant = 66
        }
        claimAmtVu.layoutIfNeeded()
        claimAmtVu.isHidden = hide
    }
    
    private func displayAlert()
    {
        if (!policyNumber.hasText)
        {
            common.removeImageForRestriction(policyNumber!)
            common.displayImageForRestriction(policyNumber!)
        }
        else
        {
            common.removeImageForRestriction(policyNumber!)
        }

        if (!stateName.hasText)
        {
            common.removeImageForRestriction(stateName!)
            common.displayImageForRestriction(stateName!)
        }
        else
        {
            common.removeImageForRestriction(stateName!)
        }

        if (!city.hasText)
        {
            common.removeImageForRestriction(city!)
            common.displayImageForRestriction(city!)
        }
        else
        {
            common.removeImageForRestriction(city!)
        }
        
        if (!claimValue.hasText && !claimAmtVu.isHidden)
        {
            common.removeImageForRestriction(claimValue!)
            common.displayImageForRestriction(claimValue!)
        }
        else
        {
            common.removeImageForRestriction(claimValue!)
        }
    }
    
    @IBAction func continueTapp(_ sender: UIButton) {
        policyNumber.resignFirstResponder()
        stateName.resignFirstResponder()
        city.resignFirstResponder()
        def.synchronize()

        if (claimAmtVu.isHidden)
        {
            if (policyNumber.hasText && stateName.hasText && city.hasText)
            {
                common.goToNextScreenWith("NomineeAppointeeViewController", self)
            }
            else
            {
                displayAlert()
            }
        }
        else
        {
            if (policyNumber.hasText && stateName.hasText && city.hasText && claimValue.hasText)
            {
                common.goToNextScreenWith("NomineeAppointeeViewController", self)
            }
            else
            {
                displayAlert()
            }
        }
    }

    @IBAction func backBtnTapped(_ sender : UIButton)
    {
        if (claimAmtVu.isHidden)
        {
            def.set(Int(claimValue.text!), forKey: "ClaimedAmount")
        }
        def.set(policyNumber.text!, forKey: "PolicyNumber")
        def.synchronize()
        self.navigationController?.popViewController(animated: true)
    }

    private func textFieldLabel()
    {
        common.applyBorderToView(policyVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(ncbVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(expiryVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(claimValue, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(policyNumber, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(stateName, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(city, withColor: Colors.textFldColor, ofSize: 1)

        if (!policyNumber.hasText)
        {
            common.setTextFieldLabels(policyNumber, policyNumberLbl, true, policyNumberLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(policyNumber, policyNumberLbl, false, "")
        }
        if (!stateName.hasText)
        {
            common.setTextFieldLabels(stateName, stateLbl, true, stateLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(stateName, stateLbl, false, "")
        }

        if (!city.hasText)
        {
            common.setTextFieldLabels(city, cityLbl, true, cityLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(city, cityLbl, false, "")
        }

        if (!claimValue.hasText)
        {
            common.setTextFieldLabels(claimValue, claimLbl, true, claimLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(claimValue, claimLbl, false, "")
        }
    }
    
    private func placeMyTableViewAround(thisView view: UIView,andAT_BottomTop topBottom: Bool)
    {
        let heightConstraint : NSLayoutConstraint! = NSLayoutConstraint.init(item: apiTableTop.firstItem as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 10)
        
        apiTableTop.isActive = false
        apiTableTop = nil
        apiTableTop = heightConstraint
        NSLayoutConstraint.activate([apiTableTop])
        apiTable.layoutIfNeeded()
        view.layoutIfNeeded()
    }

    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)

        let tagValue = textField.tag
        switch(tagValue)
        {
        case 1991:
                texFi = .policy
                common.setTextFieldLabels(policyNumber, policyNumberLbl, false, "")
                break
        case 1992:
                texFi = .PolicyState
                common.setTextFieldLabels(stateName, stateLbl,  false, "")
                apiArray = nil
                apiArray = NSMutableArray.init()
                if (stateArray != nil){
                    apiArray.addObjects(from: stateArray as! [Any])
                    apiTableView.reloadData()
                    apiTableView.updateTableContentInset()
                    apiTable.isHidden = false
                }
                placeMyTableViewAround(thisView: stateVu, andAT_BottomTop: true)
                break
        default:
                texFi = .PolicyCity
                common.setTextFieldLabels(city, cityLbl,  false, "")
                apiArray = nil
                if (def.string(forKey: "PreviousPolicyStateCode") != nil)
                {
                    let k = def.object(forKey: "ThisCompany") as! String
                    let ANOTHERSTR = def.string(forKey: "PreviousPolicyStateCode")
                    var cmpny : String = Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.cityBy+Constant.companyC+k+Constant.stateCode+ANOTHERSTR!
                    cmpny += Constant._subprod+def.string(forKey: "SubProductCode")!
                    APICallered().fetchData(cmpny) { response in
                        self.cityArray = response?.object(forKey: "Response") as? NSArray

                        if (self.cityArray != nil)
                        {
                            DispatchQueue.main.async {
                                self.apiArray = NSMutableArray.init()
                                self.apiArray.addObjects(from: self.cityArray as! [Any])
                                self.apiTableView.reloadData()
                                self.apiTableView.updateTableContentInset()
                                self.apiTable.isHidden = false
                                self.placeMyTableViewAround(thisView: self.cityVu, andAT_BottomTop: true)
                            }
                        }
                    }
                }
                break
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 1991:
                def.set(textField.text!, forKey: "PolicyNumber")
                break
        case 1994:
                def.set(Int(textField.text!), forKey: "ClaimedAmount")
                break
        default:
                apiArray = nil
                apiArray = NSMutableArray.init()
                switch texFi
                {
                case .PolicyCity:
                    apiArray.addObjects(from: cityArray as! [Any])
                    break
                case .PolicyState:
                    apiArray.addObjects(from: stateArray as! [Any])
                    break
                default:
                    break
                }
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
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        textFieldLabel()
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)

        var currentString: NSString = textField.text!.uppercased() as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textFieldLabel()
        return true
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
        case .PolicyState :
            stateName.text = string
            stateName.resignFirstResponder()
            def.set(nameDict?.object(forKey:"Id") as? String, forKey: "PreviousPolicyState")
            def.set(nameDict?.object(forKey:"Id") as? String, forKey: "PreviousPolicyStateCode")
            def.set(string, forKey: "PreviousPolicyStateName")
            def.removeObject(forKey: "PreviousPolicyCity")
            def.removeObject(forKey: "PreviousPolicyCityCode")
            def.removeObject(forKey: "PreviousPolicyCityName")
            city.text = ""
            cityLbl.isHidden = true
            break
        case .PolicyCity :
            city.text = string
            city.resignFirstResponder()
            def.set(nameDict?.object(forKey:"Id") as? String, forKey: "PreviousPolicyCity")
            def.set(nameDict?.object(forKey:"Id") as? String, forKey: "PreviousPolicyCityCode")
            def.set(string, forKey: "PreviousPolicyCityName")
            break
        default:
                policyNumber.resignFirstResponder()
                break
        }
        displayAlert()
        apiTable.isHidden = true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
