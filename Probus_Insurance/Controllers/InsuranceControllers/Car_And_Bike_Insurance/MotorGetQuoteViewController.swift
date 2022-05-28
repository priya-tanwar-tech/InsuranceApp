//
//  MotorGetQuoteViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 02/12/21.
//

import Foundation
import UIKit

class MotorGetQuoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var insuranceNameLbl: UILabel!
    @IBOutlet weak var insuranceImage: UIImageView!
    @IBOutlet weak var insuranceDescription: UILabel!
    
    @IBOutlet weak var manufactureLbl: UILabel!
    @IBOutlet weak var manufactureDateVu: UIView!
    @IBOutlet weak var manufactureDate: UILabel!
    @IBOutlet weak var manufacturePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var selectDate: UIButton!

    @IBOutlet weak var purchaseLbl: UILabel!
    @IBOutlet weak var purchaseDateVu: UIView!
    @IBOutlet weak var purchaseDate: UILabel!

    @IBOutlet weak var registrationLbl: UILabel!
    @IBOutlet weak var registrationDateVu: UIView!
    @IBOutlet weak var registrationDate: UILabel!

    @IBOutlet weak var expiryLbl: UILabel!
    @IBOutlet weak var expiryDateVu: UIView!
    @IBOutlet weak var expiryDate: UILabel!

    @IBOutlet weak var ownerCollection: UICollectionView!
    @IBOutlet weak var licenseCollection: UICollectionView!
    @IBOutlet weak var paCollection: UICollectionView!
    @IBOutlet weak var claimCollection: UICollectionView!
    @IBOutlet weak var expiryCollection: UICollectionView!
    @IBOutlet weak var ncbCollection: UICollectionView!

    @IBOutlet weak var PAView: UIView!
    @IBOutlet weak var PAShow: NSLayoutConstraint!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerShow: NSLayoutConstraint!
    @IBOutlet weak var ownerTop: NSLayoutConstraint!
    @IBOutlet weak var ncbView: UIView!
    @IBOutlet weak var ncbShow: NSLayoutConstraint!
    @IBOutlet weak var getPlansView: UIButton!
    @IBOutlet weak var claimView: UIView!
    
    @IBOutlet weak var claimHigh: NSLayoutConstraint!
    @IBOutlet weak var claimTop: NSLayoutConstraint!
    @IBOutlet weak var hidePurchase: NSLayoutConstraint!
    @IBOutlet weak var hideRegister: NSLayoutConstraint!
    @IBOutlet weak var hideExpiry: NSLayoutConstraint!
    @IBOutlet weak var hideOrganisation: NSLayoutConstraint!

    @IBOutlet weak var topPurchase: NSLayoutConstraint!
    @IBOutlet weak var topRegister: NSLayoutConstraint!
    @IBOutlet weak var topExpiry: NSLayoutConstraint!
    @IBOutlet weak var topOrganisation: NSLayoutConstraint!

    @IBOutlet weak var organisationView: UIView!
    @IBOutlet weak var organisationLbl: UILabel!
    @IBOutlet weak var organisationField: UITextField!
    @IBOutlet weak var ncbTop: NSLayoutConstraint!
    @IBOutlet weak var keyboardView: NSLayoutConstraint!

    private let common = Common.sharedCommon
    private var tappedexpiry: Int! = 1
    private var tappedPA: Int! = 1
    private var tappedLicense: Int! = 0
    private var tappedNCB: Int! = 0
    private var tappedClaim: Int! = 1
    private var tappedOwner: Int! = 0
    private var years = [String]()
    private let apiDict : NSMutableDictionary = NSMutableDictionary.init()
    let def = Common.sharedCommon.sharedUserDefaults()
    private var keyboardIsOpen = false
    private var show : Int = 1

    enum textFi {
        case man
        case pur
        case reg
        case exp
    }
    
    private var texFi = textFi.man

    override func viewDidLoad() {
        
        var v : Int!
        if (def.dictionary(forKey: "PrevPolicyExpiryStatus") != nil)
        {
            let ki = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
            v = Int(ki.object(forKey: "Id") as! String)
        }

        let k = def.object(forKey: "PolicyType") as! String
        if (k.elementsEqual("Renewal"))
        {
            show = 2
            if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
            {
                show = 0
            }
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
        ownerCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        licenseCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        paCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        expiryCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        ncbCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        claimCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        common.applyRoundedShapeToView(getPlansView, withRadius: 10)
        common.applyRoundedShapeToView(manufactureDateVu, withRadius: 5)
        common.applyRoundedShapeToView(purchaseDateVu, withRadius: 5)
        common.applyRoundedShapeToView(registrationDateVu, withRadius: 5)
        common.applyRoundedShapeToView(expiryDateVu, withRadius: 5)
        common.applyRoundedShapeToView(selectDate, withRadius: 5)
        common.applyRoundedShapeToView(organisationField, withRadius: 5)

        common.applyBorderToView(manufactureDateVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(purchaseDateVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(registrationDateVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(expiryDateVu, withColor: Colors.textFldColor, ofSize: 1)
        manufacturePicker.maximumDate = Date()

        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.getPlansTappeds(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.manTapped(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.purchaseTap(_:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.registerTapp(_:)))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.expiryTapp(_:)))
        getPlansView.addGestureRecognizer(tap1)
        manufactureDateVu.addGestureRecognizer(tap2)
        purchaseDateVu.addGestureRecognizer(tap3)
        registrationDateVu.addGestureRecognizer(tap4)
        expiryDateVu.addGestureRecognizer(tap5)
        hideMyPAShowView(true)
        setTextFieldLabel()
        showTheseViews()
        hideMyOrganisationView(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        def.removeObject(forKey: "IsVoluntaryExcess")
        def.removeObject(forKey: "IsAntiTheftDevice")
        def.removeObject(forKey: "IsMemberOfAutomobileAssociation")
        def.removeObject(forKey: "IsUseForHandicap")
        def.removeObject(forKey: "IsTPPDRestrictedto6000")
        def.removeObject(forKey: "QuotationNumber")

        if (def.string(forKey: "ManufaturingDate") != nil)
        {
            manufactureDate.text = def.string(forKey: "ManufaturingDate")
            registrationDate.text = def.string(forKey: "RegistrationDate")
            purchaseDate.text = def.string(forKey: "PurchaseDate")
            manufactureLbl.isHidden = false

            if (registrationDateVu.isHidden == false)
            {
                registrationLbl.isHidden = false
            }
            if (purchaseDateVu.isHidden == false)
            {
                purchaseLbl.isHidden = false
            }
            if (expiryDateVu.isHidden == false && show == 0)
            {
                expiryLbl.isHidden = false
                expiryDate.text = def.string(forKey: "ExpiryDate")
            }
            setNCB()
        }
        def.synchronize()

    }
    
    private func showTheseViews()
    {
        switch (show)
        {
        case 1:// new car -> man pur
                hideRegisterView()
                hideExpiryView()
                hideMyPAShowView(true)
                hideMyOwnerShowView(true)
                hideMyClaimShowView()
            break
        case 2: // expired more than 90 days -> man reg
                hidePurchaseView()
                hideExpiryView()
                hideMyClaimShowView()
            break
        default: // man reg exp
                hidePurchaseView()
            break
        }
        
        if (def.bool(forKey: "DontKnowPreviousInsurer"))
        {
            hideMyNCBShowView(true)
        }
    }
    
    private func setNCB()
    {
        let vehicleDate = common.convertStringIntoDate(manufactureDate.text!)
        let dateDiff = Calendar.current.dateComponents([.year], from: vehicleDate, to:Date() ).year ?? 0
        if (dateDiff == 2)
        {
            tappedNCB = 1
        }
        else if (dateDiff == 3)
        {
            tappedNCB = 2
        }
        else if (dateDiff == 4)
        {
            tappedNCB = 3
        }
        else if (dateDiff == 5)
        {
            tappedNCB = 4
        }
        else if (dateDiff == 6)
        {
            tappedNCB = 5
        }
        else
        {
            tappedNCB = 0
        }
    }
    
    private func hidePurchaseView()
    {
        topPurchase.constant = 0
        let constraintV = NSLayoutConstraint.init(item: hidePurchase.firstItem as Any, attribute: hidePurchase.firstAttribute, relatedBy: hidePurchase.relation, toItem: hidePurchase.secondItem, attribute: hidePurchase.secondAttribute, multiplier: 0.00000001, constant: 0)
        hidePurchase.isActive = false
        hidePurchase = nil
        hidePurchase = constraintV
        NSLayoutConstraint.activate([hidePurchase, topPurchase])
        purchaseDateVu.isHidden = true
        purchaseLbl.isHidden = true
        purchaseDate.isHidden = true
        purchaseDateVu.superview!.layoutIfNeeded()
    }
    
    private func hideRegisterView()
    {
        topPurchase.constant = 0

        let constraintV = NSLayoutConstraint.init(item: hideRegister.firstItem as Any, attribute: hideRegister.firstAttribute, relatedBy: hideRegister.relation, toItem: hideRegister.secondItem, attribute: hideRegister.secondAttribute, multiplier: 0.00000001, constant: 0)
        hideRegister.isActive = false
        hideRegister = nil
        hideRegister = constraintV
        NSLayoutConstraint.activate([hideRegister, topRegister])
        registrationDateVu.isHidden = true
        registrationLbl.isHidden = true
        registrationDate.isHidden = true
        registrationDateVu.superview!.layoutIfNeeded()
    }
    
    private func hideExpiryView()
    {
        hideExpiry.constant = 0
        let constraintV = NSLayoutConstraint.init(item: hideExpiry.firstItem as Any, attribute: hideExpiry.firstAttribute, relatedBy: hideExpiry.relation, toItem: hideExpiry.secondItem, attribute: hideExpiry.secondAttribute, multiplier: 0.00000001, constant: 0)
        hideExpiry.isActive = false
        hideExpiry = nil
        hideExpiry = constraintV
        NSLayoutConstraint.activate([hideExpiry, topExpiry])
        expiryDateVu.isHidden = true
        expiryLbl.isHidden = true
        expiryDate.isHidden = true
        expiryDateVu.superview!.layoutIfNeeded()
    }

    @IBAction func dateIsSelected(_ sender: UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: manufacturePicker.date)
        switch(texFi)
        {
        case .man:
                manufactureDate.isHidden = false
                manufactureDate.text = dateString
                def.set(dateString.components(separatedBy: "-").last, forKey: "ManufaturingYear")
                //Calculate age
                def.set(dateString, forKey: "ManufaturingDate")
                def.set(dateString, forKey: "PurchaseDate")
                def.set(dateString, forKey: "RegistrationDate")
                manufactureLbl.isHidden = false
            break
        case .pur:
                purchaseDate.isHidden = false
                purchaseDate.text = dateString        //Calculate age
                def.set(dateString, forKey: "PurchaseDate")
                def.set(dateString, forKey: "RegistrationDate")
                purchaseLbl.isHidden = false
            break
        case .reg:
                registrationDate.isHidden = false
                registrationDate.text = dateString        //Calculate age
                def.set(dateString, forKey: "RegistrationDate")
                registrationLbl.isHidden = false
            break
        case .exp:
                expiryDate.isHidden = false
                expiryDate.text = dateString        //Calculate age
                def.set(dateString, forKey: "ExpiryDate")
                expiryLbl.isHidden = false
                break
        }
        def.synchronize()
        pickerView.isHidden = true
    }

    @objc func manTapped(_ sender: UITapGestureRecognizer? = nil) {
        pickerView.isHidden = false
        texFi = textFi.man
        manufacturePicker.date = common.convertStringIntoDate(def.string(forKey: "ManufaturingDate")!)
        scrollView.isUserInteractionEnabled = true
    }

    @objc func purchaseTap(_ sender: UITapGestureRecognizer? = nil) {
        pickerView.isHidden = false
        texFi = textFi.pur
        let minDate = common.convertStringIntoDate(manufactureDate.text!)
        manufacturePicker.minimumDate = minDate
        manufacturePicker.date = common.convertStringIntoDate(def.string(forKey: "PurchaseDate")!)
        scrollView.isUserInteractionEnabled = true
    }

    @objc func registerTapp(_ sender: UITapGestureRecognizer? = nil) {
        pickerView.isHidden = false
        texFi = textFi.reg
        let minDate = common.convertStringIntoDate(purchaseDate.text!)
        manufacturePicker.minimumDate = minDate
        manufacturePicker.date = common.convertStringIntoDate(def.string(forKey: "RegistrationDate")!)
        scrollView.isUserInteractionEnabled = true
    }

    @objc func expiryTapp(_ sender: UITapGestureRecognizer? = nil) {
        pickerView.isHidden = false
        texFi = textFi.exp
        let minDate = common.convertStringIntoDate(registrationDate.text!)
        manufacturePicker.minimumDate = minDate
        manufacturePicker.date = common.convertStringIntoDate(def.string(forKey: "ExpiryDate")!)
        scrollView.isUserInteractionEnabled = true
    }

    @IBAction func getPlansTappeds(_ sender: UIButton) {
        textFieldLabel()
        let str = Date().ISO8601Format()
        def.setValue(str, forKey: "RequestTime")

        switch (show)
        {
        case 1:
            if (manufactureLbl.isHidden || purchaseLbl.isHidden)
            {
                displayAlert()
            }
            else if (((def.object(forKey: "ManufaturingDate")) != nil) && ((def.object(forKey: "PurchaseDate")) != nil))
            {
                def.set((def.object(forKey: "PurchaseDate")), forKey: "RegistrationDate")
                def.synchronize()
                if (common.sharedUserDefaults().integer(forKey: "ProductCode") == 2)
                {
                    common.goToNextScreenWith("GetMotorCarPlansViewController", self)
                }
                else
                {
                    common.goToNextScreenWith("GetMotorBikePlansViewController", self)
                }
            }
            break// new car -> man pur
        case 2:
            if (manufactureLbl.isHidden || registrationLbl.isHidden)
            {
                displayAlert()
            }
            else if (((def.object(forKey: "ManufaturingDate")) != nil) && ((def.object(forKey: "RegistrationDate")) != nil))
            {
                def.set((def.object(forKey: "RegistrationDate")), forKey: "PurchaseDate")
                def.synchronize()
                if (common.sharedUserDefaults().integer(forKey: "ProductCode") == 2)
                {
                    common.goToNextScreenWith("GetMotorCarPlansViewController", self)
                }
                else
                {
                    common.goToNextScreenWith("GetMotorBikePlansViewController", self)
                }            }
            break// expired more than 90 days -> man reg
        default:
                if (manufactureLbl.isHidden || registrationLbl.isHidden || expiryLbl.isHidden)
                {
                    displayAlert()
                }
                else if (((def.object(forKey: "ManufaturingDate")) != nil) && ((def.object(forKey: "RegistrationDate")) != nil) && ((def.object(forKey: "ExpiryDate")) != nil))
                {
                    def.set((def.object(forKey: "RegistrationDate")), forKey: "PurchaseDate")
                    def.synchronize()
                    if (common.sharedUserDefaults().integer(forKey: "ProductCode") == 2)
                    {
                        common.goToNextScreenWith("GetMotorCarPlansViewController", self)
                    }
                    else
                    {
                        common.goToNextScreenWith("GetMotorBikePlansViewController", self)
                    }
                }
            break// man reg exp
        }
    }
    
    private func displayAlert()
    {
        common.removeImageForRestriction(manufactureDate!)
        if (manufactureLbl.isHidden)
        {
            common.displayImageForRestriction(manufactureDate!)
        }
        if (!purchaseDateVu.isHidden)
        {
            common.removeImageForRestriction(purchaseDate!)
            if (purchaseLbl.isHidden)
            {
                common.displayImageForRestriction(purchaseDate!)
            }
        }
        if (!registrationDateVu.isHidden)
        {
            common.removeImageForRestriction(registrationDate!)
            if (registrationLbl.isHidden)
            {
                common.displayImageForRestriction(registrationDate!)
            }
        }
        if (!expiryDateVu.isHidden)
        {
            common.removeImageForRestriction(expiryDate!)
            if (expiryLbl.isHidden)
            {
                common.displayImageForRestriction(expiryDate!)
            }
        }
        
        let alertVu = SCLAlertView.init(appearance: common.alertwithCancel)
        alertVu.showWarning("Alert!", subTitle: "Kindly agree to policy terms and conditions.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }

    @objc private func handleSelectionPicker(_ sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: sender.date)
        
        switch(texFi)
        {
        case .man:
                manufactureDate.isHidden = false
                manufactureDate.text = dateString
                def.set(dateString.components(separatedBy: "-").last, forKey: "ManufaturingYear")
                //Calculate age
                def.set(dateString, forKey: "ManufaturingDate")
                manufactureLbl.isHidden = false
            break
        case .pur:
                purchaseDate.isHidden = false
                purchaseDate.text = dateString        //Calculate age
                def.set(dateString, forKey: "PurchaseDate")
                purchaseLbl.isHidden = false
            break
        case .reg:
                registrationDate.isHidden = false
                registrationDate.text = dateString        //Calculate age
                def.set(dateString, forKey: "RegistrationDate")
                registrationLbl.isHidden = false
            break
        case .exp:
                expiryDate.isHidden = false
                expiryDate.text = dateString        //Calculate age
                def.set(dateString, forKey: "ExpiryDate")
                expiryLbl.isHidden = false
            break
        }
        def.synchronize()
        scrollView.isUserInteractionEnabled = true
        sender.isHidden = true
        sender.resignFirstResponder()
    }

    private func setTextFieldLabel()
    {
        common.applyBorderToView(manufactureDateVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(purchaseDateVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(registrationDateVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(expiryDateVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(organisationField, withColor: Colors.textFldColor, ofSize: 1)
    }

    func hideMyPAShowView(_ hide: Bool) {
        var constraintV: NSLayoutConstraint!
        PAView.isHidden = hide
        if (hide)
        {
            ownerTop.constant = 0
            constraintV = common.ShowAndHideView(ConstarintIs: PAShow, isHidden: hide, andSize: 0.001)
        }
        else
        {
            ownerTop.constant = 10
            constraintV = common.ShowAndHideView(ConstarintIs: PAShow, isHidden: hide, andSize: 1)
            paCollection.reloadData()
        }
        
        PAShow.isActive = false
        PAShow = nil
        PAShow = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([PAShow, ownerTop])
        PAView.layoutIfNeeded()
    }

    func hideMyOwnerShowView(_ hide: Bool) {
        var constraintV: NSLayoutConstraint!
        ownerView.isHidden = hide
        if (hide)
        {
            constraintV = common.ShowAndHideView(ConstarintIs: ownerShow, isHidden: hide, andSize: 0.001)
        }
        else
        {
            constraintV = common.ShowAndHideView(ConstarintIs: ownerShow, isHidden: hide, andSize: 0.15)
        }
        
        ownerShow.isActive = false
        ownerShow = nil
        ownerShow = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([ownerShow])
        ownerView.layoutIfNeeded()
    }

    func hideMyNCBShowView(_ hide: Bool) {
        var constraintV: NSLayoutConstraint!
        if (hide)
        {
            ncbTop.constant = 0
            constraintV = common.ShowAndHideView(ConstarintIs: ncbShow, isHidden: hide, andSize: 0.000001)
        }
        else
        {
            ncbTop.constant = 10
            constraintV = common.ShowAndHideView(ConstarintIs: ncbShow, isHidden: hide, andSize: 0.22)
        }
        ncbShow.isActive = false
        ncbShow = nil
        ncbShow = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([ncbShow, ncbTop])
        ncbView.isHidden = hide
        ncbView.layoutIfNeeded()
    }
    
    private func hideMyClaimShowView()
    {
        claimTop.constant = 0
        let constraintV = NSLayoutConstraint.init(item: claimHigh.firstItem as Any, attribute: claimHigh.firstAttribute, relatedBy: claimHigh.relation, toItem: claimHigh.secondItem, attribute: claimHigh.secondAttribute, multiplier: 0.00000001, constant: 0)
        claimHigh.isActive = false
        claimHigh = nil
        claimHigh = constraintV
        NSLayoutConstraint.activate([claimHigh, claimTop])
        claimView.isHidden = true
        claimView.layoutIfNeeded()
    }

    func hideMyOrganisationView(_ hide: Bool) {
        var constraintV: NSLayoutConstraint!
        organisationView.isHidden = hide
        if (hide)
        {
            topOrganisation.constant = 0
            def.setValue("", forKey: "OrganizationName")
            constraintV = NSLayoutConstraint.init(item: hideOrganisation.firstItem as Any, attribute: hideOrganisation.firstAttribute, relatedBy: hideOrganisation.relation, toItem: hideOrganisation.secondItem, attribute: hideOrganisation.secondAttribute, multiplier: 0.000001, constant: 0)
        }
        else
        {
            topOrganisation.constant = 5
            def.setValue("", forKey: "OrganizationName")
            constraintV = NSLayoutConstraint.init(item: hideOrganisation.firstItem as Any, attribute: hideOrganisation.firstAttribute, relatedBy: hideOrganisation.relation, toItem: hideOrganisation.secondItem, attribute: hideOrganisation.secondAttribute, multiplier: 1, constant: hideOrganisation.constant)
        }
        def.synchronize()

        hideOrganisation.isActive = false
        hideOrganisation = nil
        hideOrganisation = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([hideOrganisation, topOrganisation])
        organisationView.layoutIfNeeded()
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       let t = collectionView.tag
       if (t == 1401)
       {
           return Common.indi_org_Array.count
       }
       else if (t == 1405)
       {
           return Common.ncbArray.count
       }
       return Common.yesNoBtnArray.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
       if (collectionView.tag == 1401)
       {
           cell.setDataForNormal(Common.indi_org_Array[indexPath.row], ofFontSize: 14)
       }
       else if  (collectionView.tag == 1405)
       {
           cell.setDataForNormal(Common.ncbArray[indexPath.row], ofFontSize: 14)
       }
       else
       {
           cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 12)
       }
       switch (collectionView.tag)
       {
       case 1401:
               if (tappedOwner == indexPath.row)
               {
                   cell.setSelectedData()
                   def.set(Common.indi_org_Array[indexPath.row], forKey: "CustomerType")

                   let k = Bool(truncating: indexPath.row as NSNumber)
                   hideMyOrganisationView(!k)
               }
           break
       case 1402:
               if (tappedLicense == indexPath.row)
               {
                   cell.setSelectedData()
                   let k = Bool(truncating: indexPath.row as NSNumber)
                   def.set(!k, forKey: "IsValidLicence")
                   hideMyPAShowView(!k)
               }
           break
       case 1405:
               if (tappedNCB == indexPath.row)
               {
                   cell.setSelectedData()
                   let k =  Int(Common.ncbArray[indexPath.row].replacingOccurrences(of: "%", with: ""))
                   def.set(k, forKey: "PreviousNcbPercentage")
               }
           break
       case 1403:
               if (tappedPA == indexPath.row)
               {
                   cell.setSelectedData()
                   let k = Bool(truncating: indexPath.row as NSNumber)
                   def.set(!k, forKey: "IsOwnerChanged")
               }
           break
       case 1407:
               if (tappedClaim == indexPath.row)
               {
                   cell.setSelectedData()
                   let k = Bool(truncating: indexPath.row as NSNumber)
                   def.set(!k, forKey: "IsPreviousInsuranceClaimed")
                   if (tappedClaim == 0)
                   {
                       tappedNCB = 0
                   }
                   hideMyNCBShowView(!k)
               }
           break
       default:
               if (tappedexpiry == indexPath.row)
               {
                   cell.setSelectedData()
                   if (!def.bool(forKey: "DontKnowPreviousInsurer"))
                   {
                       let k = Bool(truncating: indexPath.row as NSNumber)
                       hideMyNCBShowView(!k)
                   }
               }
           break
       }
       def.synchronize()
       return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       switch (collectionView.tag)
       {
       case 1401:
               tappedOwner = indexPath.row
           break
       case 1402:
               tappedLicense = indexPath.row
           break
       case 1405:
               tappedNCB = indexPath.row
           break
       case 1403:
               tappedPA = indexPath.row
           break
       case 1407:
               tappedClaim = indexPath.row
           break
       default:
               tappedexpiry = indexPath.row
           break
       }
       collectionView.reloadData()
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let widthAndHeight = common.getScreenSize(collectionView)
       var sizes: CGSize = CGSize.init(width: 0, height: 0)
       let CellHeight = widthAndHeight.1
       let CellWidth = widthAndHeight.0*0.45
       if (collectionView.tag == 1401)
       {
           sizes = CGSize(width: CellWidth, height: CellHeight*0.7)
       }
       else if (collectionView.tag == 1405)
       {
           sizes = CGSize(width: 70, height: CellHeight*0.3)
       }
       else
       {
           sizes = CGSize(width: 50, height: CellHeight*0.7)
       }
       return sizes;
   }
       
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10);
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        return true
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
    
    private func textFieldLabel()
    {
        setLabelFieldMutualVisibility(organisationField, organisationLbl.text!, organisationLbl)
        common.applyBorderToView(organisationField, withColor: Colors.textFldColor, ofSize: 1)
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
        def.setValue(textField.text, forKey: "OrganizationName")
        def.synchronize()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardIsOpen = false
        textFieldLabel()
        textField.resignFirstResponder()
        return true
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
}
