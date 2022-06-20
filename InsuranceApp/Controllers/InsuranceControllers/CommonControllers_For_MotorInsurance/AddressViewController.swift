//
//  AddressViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 09/12/21.
//

import Foundation
import UIKit

class AddressViewController : UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollVu: UIScrollView!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var continueVu: UIButton!
    @IBOutlet weak var myProgressBar: UIProgressView!

    @IBOutlet weak var houseVu: UIView!
    @IBOutlet weak var house: UITextField!
    @IBOutlet weak var houseLbl: UILabel!

    @IBOutlet weak var streetVu: UIView!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var streetLbl: UILabel!

    @IBOutlet weak var areaVu: UIView!
    @IBOutlet weak var area: UITextField!
    @IBOutlet weak var areaLbl: UILabel!

    @IBOutlet weak var stateVu: UIView!
    @IBOutlet weak var stateT: UITextField!
    @IBOutlet weak var stateLbl: UILabel!

    @IBOutlet weak var cityVu: UIView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var cityLbl: UILabel!

    @IBOutlet weak var pinVu: UIView!
    @IBOutlet weak var pinT: UITextField!
    @IBOutlet weak var pinLbl: UILabel!

    @IBOutlet weak var addressCollect: UICollectionView!
    @IBOutlet weak var permanent: UIView!

    @IBOutlet weak var housePerVu: UIView!
    @IBOutlet weak var housePer: UITextField!
    @IBOutlet weak var housePerLbl: UILabel!

    @IBOutlet weak var streetPerVu: UIView!
    @IBOutlet weak var streetPer: UITextField!
    @IBOutlet weak var streetPerLbl: UILabel!

    @IBOutlet weak var areaPerVu: UIView!
    @IBOutlet weak var areaPer: UITextField!
    @IBOutlet weak var areaPerLbl: UILabel!

    @IBOutlet weak var statePerVu: UIView!
    @IBOutlet weak var stateTPer: UITextField!
    @IBOutlet weak var statePerLbl: UILabel!

    @IBOutlet weak var cityPerVu: UIView!
    @IBOutlet weak var cityPer: UITextField!
    @IBOutlet weak var cityPerLbl: UILabel!

    @IBOutlet weak var pinPerVu: UIView!
    @IBOutlet weak var pinTPer: UITextField!
    @IBOutlet weak var pinPerLbl: UILabel!

    @IBOutlet weak var permanentShow: NSLayoutConstraint!
    @IBOutlet weak var permanentTop: NSLayoutConstraint!
    @IBOutlet weak var apiTableTop : NSLayoutConstraint!
    @IBOutlet weak var keyboardView : NSLayoutConstraint!

    @IBOutlet weak var apiTable: UIView!
    @IBOutlet weak var apiTableView : UITableView!

    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var quotationLabel: UILabel!

    private var keyboardIsOpen = false
    private var tappedPer: Int! = 1
    private let common = Common.sharedCommon
    private var apiArray : NSMutableArray!
    private var stateArray : NSArray!
    private var cityArray : NSArray!
    private let def = Common.sharedCommon.sharedUserDefaults()
    private let CommAddDet = NSMutableDictionary.init()
    private let VehAddDet = NSMutableDictionary.init()

    enum textFi {
        case house
        case street
        case land
        case stat
        case cit
        case pinT
        case houseP
        case streetP
        case landP
        case statP
        case citP
        case pinTP
    }
    private var texFi = textFi.house
    
    override func viewDidLoad() {
        let vehiclName = def.string(forKey: "MakeName")! + " " + def.string(forKey: "ModelName")! + " " + def.string(forKey: "VariantName")!
        vehicleDetails.text = vehiclName
        quotationLabel.text = def.string(forKey: "QuotationNumber")
    
        apiTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        addressCollect.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")

        common.applyShadowToView(apiTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)

        let k = def.string(forKey: "ThisCompany")
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.stateBy+Constant.companyC+k!) { response in
            self.stateArray = response?.object(forKey: "Response") as? NSArray
        }
        
        common.addDoneButtonOnNumpad(textField: pinT)
        common.addDoneButtonOnNumpad(textField: pinTPer)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func getDictionaryForAddress()
    {
        if (def.dictionary(forKey: "CommunicationAddress") != nil)
        {
            CommAddDet.addEntries(from: def.dictionary(forKey: "CommunicationAddress")!)
            
            if (def.dictionary(forKey: "VehicleAddress") != nil)
            {
                VehAddDet.addEntries(from: def.dictionary(forKey: "VehicleAddress")!)
            }
            else
            {
                VehAddDet.addEntries(from: def.dictionary(forKey: "CommunicationAddress")!)
            }
        }
    }
    
    private func setProgressOfProgressBar()
    {
        var v : Int!
        if (def.dictionary(forKey: "PrevPolicyExpiryStatus") != nil)
        {
            let ki = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
            v = Int(ki.object(forKey: "Id") as! String)
        }

        if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
        {
            myProgressBar.setProgress((3/7), animated: true)
        }
        else
        {
            myProgressBar.setProgress((3/6), animated: true)
        }
    }
    
    private func  applyRoundShapeToViews()
    {
        common.applyRoundedShapeToView(house, withRadius: 5)
        common.applyRoundedShapeToView(street, withRadius: 5)
        common.applyRoundedShapeToView(area, withRadius: 5)
        common.applyRoundedShapeToView(stateT, withRadius: 5)
        common.applyRoundedShapeToView(city, withRadius: 5)
        common.applyRoundedShapeToView(pinT, withRadius: 5)
        common.applyRoundedShapeToView(housePer, withRadius: 5)
        common.applyRoundedShapeToView(streetPer, withRadius: 5)
        common.applyRoundedShapeToView(areaPer, withRadius: 5)
        common.applyRoundedShapeToView(stateTPer, withRadius: 5)
        common.applyRoundedShapeToView(cityPer, withRadius: 5)
        common.applyRoundedShapeToView(pinTPer, withRadius: 5)
        common.applyRoundedShapeToView(continueVu, withRadius: 10)
    }
    
    private func setTextFieldValues()
    {
        if ((CommAddDet.object(forKey: "Address1") !=  nil) && !(CommAddDet.object(forKey: "Address1") as! String).isEmpty)
        {
            house.text = (CommAddDet.object(forKey: "Address1") as! String)
            houseLbl.isHidden = false
        }
        
        if ((CommAddDet.object(forKey: "Address2") !=  nil) && !(CommAddDet.object(forKey: "Address2") as! String).isEmpty)
        {
            street.text = (CommAddDet.object(forKey: "Address2") as! String)
            streetLbl.isHidden = false
        }

        if (CommAddDet.object(forKey: "Address3") !=  nil && !(CommAddDet.object(forKey: "Address3") as! String).isEmpty)
        {
            area.text = (CommAddDet.object(forKey: "Address3") as! String)
            areaLbl.isHidden = false
        }

        if (CommAddDet.object(forKey: "Pincode") !=  nil)
        {
            pinT.text = (CommAddDet.object(forKey: "Pincode") as! String)
            pinLbl.isHidden = false
        }
        if ((CommAddDet.object(forKey: "RegistrationAddressSame")) != nil)
        {
            if ((VehAddDet.object(forKey: "Address1") !=  nil) && !(VehAddDet.object(forKey: "Address1") as! String).isEmpty)
            {
                housePer.text = (VehAddDet.object(forKey: "Address1") as! String)
                housePerLbl.isHidden = false
            }

            if ((VehAddDet.object(forKey: "Address2") !=  nil) && !(VehAddDet.object(forKey: "Address1") as! String).isEmpty)
            {
                streetPer.text = (VehAddDet.object(forKey: "Address2") as! String)
                streetPerLbl.isHidden = false
            }

            if ((VehAddDet.object(forKey: "Address3") !=  nil) && !(VehAddDet.object(forKey: "Address1") as! String).isEmpty)
            {
                areaPer.text = (VehAddDet.object(forKey: "Address3") as! String)
                areaPerLbl.isHidden = false
            }

            if (VehAddDet.object(forKey: "Pincode") !=  nil)
            {
                pinTPer.text = (VehAddDet.object(forKey: "Pincode") as! String)
                pinPerLbl.isHidden = false
            }
        }
    }
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        house.resignFirstResponder()
        street.resignFirstResponder()
        area.resignFirstResponder()
        stateT.resignFirstResponder()
        city.resignFirstResponder()
        pinT.resignFirstResponder()
        housePer.resignFirstResponder()
        streetPer.resignFirstResponder()
        areaPer.resignFirstResponder()
        stateTPer.resignFirstResponder()
        cityPer.resignFirstResponder()
        pinPerVu.resignFirstResponder()
        
        saveDataForFurther()
        let bV = CommAddDet.object(forKey: "RegistrationAddressSame") as! Bool
        if (bV)
        {
            if (!house.hasText || !street.hasText || !stateT.hasText || !city.hasText || !pinT.hasText)
            {
                displayAlert()
            }
            else if ((CommAddDet.object(forKey: "Address1") != nil) && (CommAddDet.object(forKey: "Address2") != nil) && (CommAddDet.object(forKey: "CityName") != nil) && (CommAddDet.object(forKey: "Pincode") != nil) && (CommAddDet.object(forKey: "StateName") != nil))
            {
                common.goToNextScreenWith("VehicleRegistrationViewController", self)
            }
        }
        else
        {
            if (!housePer.hasText || !streetPer.hasText || !stateTPer.hasText || !cityPer.hasText || !pinTPer.hasText || !house.hasText || !street.hasText || !stateT.hasText || !city.hasText || !pinT.hasText)
            {
                displayAlert()
            }
            else if ((VehAddDet.object(forKey: "Address1") != nil) && (VehAddDet.object(forKey: "Address2") != nil) && (VehAddDet.object(forKey: "CityName") != nil) && (VehAddDet.object(forKey: "Pincode") != nil) && (VehAddDet.object(forKey: "StateName") != nil) && (CommAddDet.object(forKey: "Address1") != nil) && (CommAddDet.object(forKey: "Address2") != nil) && (CommAddDet.object(forKey: "CityName") != nil) && (CommAddDet.object(forKey: "Pincode") != nil) && (CommAddDet.object(forKey: "StateName") != nil))
            {
                common.goToNextScreenWith("VehicleRegistrationViewController", self)
            }
        }
    }
    
    private func saveDataForFurther()
    {
        CommAddDet.setValue("INDIA", forKey: "Country")
        let bV = CommAddDet.object(forKey: "RegistrationAddressSame") as! Bool
        if (bV)
        {
            def.set(CommAddDet, forKey: "VehicleAddress")
        }
        else
        {
            VehAddDet.setValue("INDIA", forKey: "Country")
            VehAddDet.setValue(false, forKey: "RegistrationAddressSame")
            def.set(VehAddDet, forKey: "VehicleAddress")
        }
        def.set(CommAddDet, forKey: "CommunicationAddress")
        common.sharedUserDefaults().synchronize()
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
    
    override func viewWillAppear(_ animated: Bool) {
        let def = common.sharedUserDefaults()
        if (def.dictionary(forKey: "CommunicationAddress") != nil)
        {
            VehAddDet.addEntries(from: def.dictionary(forKey: "VehicleAddress")!)
            CommAddDet.addEntries(from: def.dictionary(forKey: "CommunicationAddress")!)
        }
        
        setProgressOfProgressBar()
        setTextFieldValues()
        applyRoundShapeToViews()
        textFieldLabel()
        hideMyView(true)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabel()
        keyboardIsOpen = false
        keyboardView.constant = 0
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton)
    {
        saveDataForFurther()
        self.navigationController?.popViewController(animated: true)
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

    func hideMyView(_ hide: Bool) {
        if (hide)
        {
            permanentShow.constant = 0.1
        }
        else
        {
            permanentShow.constant = 500
        }
        (permanentShow.firstItem! as! UIView).isHidden = hide
        permanent.layoutIfNeeded()
        CommAddDet.setValue(hide, forKey: "RegistrationAddressSame")
        def.set(hide, forKey: "RegistrationAddressSame")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldLabel()
        textField.resignFirstResponder()
        return true
    }
    
    private func textFieldLabel()
    {
        common.applyBorderToView(house, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(street, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(area, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(stateT, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyBorderToView(city, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(pinT, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(housePer, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(streetPer, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyBorderToView(areaPer, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(stateTPer, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(cityPer, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(pinTPer, withColor: Colors.textFldColor, ofSize: 1)

        if (!house.hasText)
        {
            common.setTextFieldLabels(house, houseLbl, true, houseLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(house, houseLbl, false, "")
        }
        if (!street.hasText)
        {
            common.setTextFieldLabels(street, streetLbl, true, streetLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(street, streetLbl, false, "")
        }
        if (!area.hasText)
        {
            common.setTextFieldLabels(area, areaLbl, true, areaLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(area, areaLbl, false, "")
        }
        if (!stateT.hasText)
        {
            common.setTextFieldLabels(stateT, stateLbl, true, stateLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(stateT, stateLbl, false, "")
        }


        if (!city.hasText)
        {
            common.setTextFieldLabels(city, cityLbl, true, cityLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(city, cityLbl, false, "")
        }

        if (!pinT.hasText)
        {
            common.setTextFieldLabels(pinT, pinLbl, true, pinLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(pinT, pinLbl, false, "")
        }

        if (!housePer.hasText)
        {
            common.setTextFieldLabels(housePer, housePerLbl, true, housePerLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(housePer, housePerLbl, false, "")
        }
        if (!streetPer.hasText)
        {
            common.setTextFieldLabels(streetPer, streetPerLbl, true, streetPerLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(streetPer, streetPerLbl, false, "")
        }
        if (!areaPer.hasText)
        {
            common.setTextFieldLabels(areaPer, areaPerLbl, true, areaPerLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(areaPer, areaPerLbl, false, "")
        }
        if (!stateTPer.hasText)
        {
            common.setTextFieldLabels(stateTPer, statePerLbl, true, statePerLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(stateTPer, statePerLbl, false, "")
        }
        if (!cityPer.hasText)
        {
            common.setTextFieldLabels(cityPer, cityPerLbl, true, cityPerLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(cityPer, cityPerLbl, false, "")
        }
        if (!pinTPer.hasText)
        {
            common.setTextFieldLabels(pinTPer, pinPerLbl, true, pinPerLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(pinTPer, pinPerLbl, false, "")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        let k = common.sharedUserDefaults().object(forKey: "ThisCompany") as! String

        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)

        let tagValue = textField.tag
        switch(tagValue)
        {
        case 171:
                texFi = textFi.house
                common.setTextFieldLabels(house, houseLbl, false, "")
            break
        case 172:
                texFi = textFi.street
                common.setTextFieldLabels(street, streetLbl, false, "")
            break
        case 173:
                texFi = textFi.land
                common.setTextFieldLabels(area, areaLbl,  false, "")
            break
        case 174:
                texFi = textFi.stat
                common.setTextFieldLabels(stateT, stateLbl, false, "")
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
        case 175:
                texFi = textFi.cit
                common.setTextFieldLabels(city, cityLbl, false, "")
                apiArray = nil
                if ((CommAddDet.object(forKey: "StateCode")) != nil)
                {
                    let ANOTHERSTR = (CommAddDet.object(forKey: "StateCode")) as? String
                    var cmpny : String = Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.cityBy+Constant.companyC+k+Constant.stateCode+ANOTHERSTR!
                    cmpny += Constant._subprod+def.string(forKey: "SubProductCode")!
                    
                    APICallered().fetchData(cmpny) { response in
                        self.cityArray = response?.object(forKey: "Response") as? NSArray

                        if (self.cityArray != nil)
                        {
                            DispatchQueue.main.async {
                                Common.financeCityArray = self.cityArray
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
        case 176:
                texFi = textFi.pinT
                common.setTextFieldLabels(pinT, pinLbl,  false, "")
            break
        case 177:
                texFi = textFi.houseP
                common.setTextFieldLabels(housePer, housePerLbl, false, "")
            break
        case 178:
                texFi = textFi.streetP
                common.setTextFieldLabels(streetPer, streetPerLbl, false, "")
            break
        case 179:
                texFi = textFi.landP
                common.setTextFieldLabels(areaPer, areaPerLbl,  false, "")
            break
        case 180:
                texFi = textFi.statP
                common.setTextFieldLabels(stateTPer, statePerLbl, false, "")
                apiArray = nil
                apiArray = NSMutableArray.init()
                if (stateArray != nil){
                    apiArray.addObjects(from: stateArray as! [Any])
                    apiTableView.reloadData()
                    apiTableView.updateTableContentInset()
                    apiTable.isHidden = false
                }
                placeMyTableViewAround(thisView: statePerVu, andAT_BottomTop: true)
            break
        case 181:
                texFi = textFi.citP
                common.setTextFieldLabels(cityPer, cityPerLbl, false, "")
                apiArray = nil
                if ((VehAddDet.object(forKey: "StateCode")) != nil)
                {
                    let ANOTHERSTR = (VehAddDet.object(forKey: "StateCode")) as? String
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
                                self.placeMyTableViewAround(thisView: self.cityPerVu, andAT_BottomTop: true)
                            }
                        }
                    }
                }
            break
        default:
                texFi = textFi.pinTP
                common.setTextFieldLabels(pinTPer, pinPerLbl, false, "")
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        textFieldLabel()
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)

        var currentString: NSString = textField.text! as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField.tag == 180 || textField.tag == 181 || textField.tag == 174 || textField.tag == 175)
        {
            apiArray = nil
            apiArray = NSMutableArray.init()
            switch texFi
            {
            case .stat:
                apiArray.addObjects(from: stateArray as! [Any])
                break
            case .statP:
                apiArray.addObjects(from: stateArray as! [Any])
                break
            case .cit:
                apiArray.addObjects(from: self.cityArray as! [Any])
                break
            case .citP:
                apiArray.addObjects(from: self.cityArray as! [Any])
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
        }
        
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 171:
                if (textField.text!.count <= 30)
                {
                    CommAddDet.setValue(textField.text!, forKey: "Address1")
                }
                else
                {
                    textField.resignFirstResponder()
                }
                break
        case 172:
                if (textField.text!.count <= 30)
                {
                    CommAddDet.setValue(textField.text!, forKey: "Address2")
                }
                else
                {
                    textField.resignFirstResponder()
                }
            break
        case 173:
                if (textField.text!.count <= 30)
                {
                    CommAddDet.setValue(textField.text!, forKey: "Address3")
                }
                else
                {
                    textField.resignFirstResponder()
                }
            break
        case 176:
                if (textField.text!.count >= 6)
                {
                    let k = Constant.buyAPI+Constant.baseURL+Constant.home+Constant.pin_check+textField.text!
                    APICallered().fetchData(k) { response in
                        DispatchQueue.main.async {
                            self.CommAddDet.setValue(textField.text!, forKey: "Pincode")
                            textField.resignFirstResponder()
                        }
                    }
                }
            break
        case 177:
                if (textField.text!.count <= 30)
                {
                    VehAddDet.setValue(textField.text!, forKey: "Address1")
                }
                else
                {
                    textField.resignFirstResponder()
                }
            break
        case 178:
                if (textField.text!.count <= 30)
                {
                    VehAddDet.setValue(textField.text!, forKey: "Address2")
                }
                else
                {
                    textField.resignFirstResponder()
                }
            break
        case 179:
                if (textField.text!.count <= 30)
                {
                    VehAddDet.setValue(textField.text!, forKey: "Address3")
                }
                else
                {
                    textField.resignFirstResponder()
                }
            break
        case 182:
                if (textField.text!.count >= 6)
                {
                    let k = Constant.buyAPI+Constant.baseURL+Constant.home+Constant.pin_check+textField.text!
                    APICallered().fetchData(k) { response in
                        DispatchQueue.main.async {
                            self.VehAddDet.setValue(textField.text!, forKey: "Pincode")
                            textField.resignFirstResponder()
                        }
                    }
                }
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Common.yesNoBtnArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 12)
        
        if (tappedPer == indexPath.row)
        {
            cell.setSelectedData()
            let k = Bool(truncating: indexPath.row as NSNumber)
            CommAddDet.setValue(k, forKey: "RegistrationAddressSame")
            def.set(k, forKey: "RegistrationAddressSame")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedPer = indexPath.row
        if (tappedPer == 0)
        {
            hideMyView(false)
        }
        else
        {
            hideMyView(true)
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
    
    private func displayAlert()
    {
        common.removeImageForRestriction(house!)
        common.removeImageForRestriction(street!)
        common.removeImageForRestriction(stateT!)
        common.removeImageForRestriction(city!)
        common.removeImageForRestriction(pinT!)

        if (!house.hasText)
        {
            common.displayImageForRestriction(house!)
        }
        if (!street.hasText)
        {
            common.displayImageForRestriction(street!)
        }
        if (!stateT.hasText)
        {
            common.displayImageForRestriction(stateT!)
        }
        if (!city.hasText)
        {
            common.displayImageForRestriction(city!)
        }
        if (!pinT.hasText)
        {
            common.displayImageForRestriction(pinT!)
        }
        let bV = CommAddDet.object(forKey: "RegistrationAddressSame") as! Bool
        if (!bV)
        {
            common.removeImageForRestriction(housePer!)
            common.removeImageForRestriction(streetPer!)
            common.removeImageForRestriction(stateTPer!)
            common.removeImageForRestriction(cityPer!)
            common.removeImageForRestriction(pinTPer!)

            if (!housePer.hasText)
            {
                common.displayImageForRestriction(housePer!)
            }
            if (!streetPer.hasText)
            {
                common.displayImageForRestriction(streetPer!)
            }
            if (!stateTPer.hasText)
            {
                common.displayImageForRestriction(stateTPer!)
            }
            if (!cityPer.hasText)
            {
                common.displayImageForRestriction(cityPer!)
            }
            if (!pinTPer.hasText)
            {
                common.displayImageForRestriction(pinTPer!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameDict = (apiArray[indexPath.row]) as? NSDictionary
        let string = (nameDict?.object(forKey: "Name") as! String)
        switch texFi
        {
        case .stat:
                stateT.text = string
                stateT.resignFirstResponder()
                stateLbl.isHidden = false
                CommAddDet.setValue(nameDict?.object(forKey:"Id") as? String, forKey: "State")
                CommAddDet.setValue(nameDict?.object(forKey:"Id") as? String, forKey: "StateCode")
                CommAddDet.setValue(string, forKey: "StateName")
                
                city.text = ""
                cityLbl.isHidden = true
                CommAddDet.removeObject(forKey:"City")
                CommAddDet.removeObject(forKey:"CityCode")
                CommAddDet.removeObject(forKey:"CityName")
            break
        case .cit:
                city.text = string
                city.resignFirstResponder()
                cityLbl.isHidden = false
                CommAddDet.setValue(nameDict?.object(forKey:"Id") as? String, forKey: "City")
                CommAddDet.setValue(nameDict?.object(forKey:"Id") as? String, forKey: "CityCode")
                CommAddDet.setValue(string, forKey: "CityName")
            break
        case .statP:
                stateTPer.text = string
                stateTPer.resignFirstResponder()
                statePerLbl.isHidden = false
                VehAddDet.setValue(nameDict?.object(forKey:"Id") as? String, forKey: "State")
                VehAddDet.setValue(nameDict?.object(forKey:"Id") as? String, forKey: "StateCode")
                VehAddDet.setValue(string, forKey: "StateName")
                
                cityPer.text = ""
                cityPerLbl.isHidden = true
                VehAddDet.removeObject(forKey:"City")
                VehAddDet.removeObject(forKey:"CityCode")
                VehAddDet.removeObject(forKey:"CityName")
            break
        case .citP:
                cityPer.resignFirstResponder()
                cityPer.text = string
                cityPerLbl.isHidden = false
                VehAddDet.setValue(nameDict?.object(forKey:"Id") as? String, forKey: "City")
                VehAddDet.setValue(nameDict?.object(forKey:"Id") as? String, forKey: "CityCode")
                VehAddDet.setValue(string, forKey: "CityName")
            break
        default:
            break
        }
        apiTable.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
