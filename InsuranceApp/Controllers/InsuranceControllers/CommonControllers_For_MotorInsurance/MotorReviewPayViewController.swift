//
//  MotorReviewPayViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 19/01/22.
//

import Foundation
import UIKit
import MBProgressHUD

class MotorReviewPayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var collectionVu : UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var ReviewView: UIView!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var quotationNumber: UILabel!
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet var vehiclePackageLabel: UILabel!
    
    @IBOutlet weak var basicScroll: UIScrollView!
    
    @IBOutlet weak var holderDetailsVu : UIView!
    
    @IBOutlet weak var holderName: UILabel!
    @IBOutlet weak var holderGender: UILabel!
    @IBOutlet weak var holderDOB: UILabel!
    @IBOutlet weak var holderContact: UILabel!
    @IBOutlet weak var holderEmail: UILabel!
    @IBOutlet weak var holderOcc: UILabel!

    @IBOutlet weak var addressDetailsVu : UIView!
    
    @IBOutlet weak var commAddress: UILabel!
    @IBOutlet weak var commCity: UILabel!
    @IBOutlet weak var commState: UILabel!
    @IBOutlet weak var commPin: UILabel!
    @IBOutlet weak var regAddress: UILabel!
    @IBOutlet weak var regCity: UILabel!
    @IBOutlet weak var regState: UILabel!
    @IBOutlet weak var regPin: UILabel!

    @IBOutlet weak var nomineeDetailsVu : UIView!
    
    @IBOutlet weak var nomineeName: UILabel!
    @IBOutlet weak var nomineeDOB: UILabel!
    @IBOutlet weak var nomineeRelation: UILabel!
    @IBOutlet weak var nomineeGender: UILabel!

    @IBOutlet weak var appointeeVu : UIView!
    @IBOutlet weak var appointeeDetailsVu : UIView!
    @IBOutlet weak var appointeeHigh: NSLayoutConstraint!
    @IBOutlet weak var appointeeTop: NSLayoutConstraint!

    @IBOutlet weak var appointeeName: UILabel!
    @IBOutlet weak var appointeeDOB: UILabel!
    @IBOutlet weak var appointeeRelation: UILabel!
    
    @IBOutlet weak var nextBasic: UIButton!

    // vehicle
    
    @IBOutlet weak var vehicleScroll: UIScrollView!
    @IBOutlet weak var vehicleDetailsVu : UIView!
    
    @IBOutlet weak var registrationNumber: UILabel!
    @IBOutlet weak var registrationDate: UILabel!
    @IBOutlet weak var policyStartDate: UILabel!
    @IBOutlet weak var policyEndDate: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var variant: UILabel!
    @IBOutlet weak var customerType: UILabel!
    @IBOutlet weak var engine: UILabel!
    @IBOutlet weak var chassis: UILabel!

    @IBOutlet weak var policyVu : UIView!
    @IBOutlet weak var policyDetailsVu : UIView!
    @IBOutlet weak var policyHigh: NSLayoutConstraint!
    @IBOutlet weak var policyTop: NSLayoutConstraint!

    @IBOutlet weak var policyNumber: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var insurerName: UILabel!

    @IBOutlet weak var hypoVu : UIView!
    @IBOutlet weak var hypoDetailsVu : UIView!
    @IBOutlet weak var hypoHigh: NSLayoutConstraint!
    @IBOutlet weak var hypoTop: NSLayoutConstraint!

    @IBOutlet weak var hypothecation: UILabel!
    @IBOutlet weak var financeCity: UILabel!
    @IBOutlet weak var financeName: UILabel!
    
    @IBOutlet weak var nextVehicle: UIButton!
    
    // premium
        
    @IBOutlet weak var premiumScroll: UIScrollView!

    @IBOutlet weak var premiumDetailVu: UIView!
    @IBOutlet weak var idvValue: UILabel!
    @IBOutlet weak var premiumYr: UILabel!
    @IBOutlet weak var netPremium: UILabel!
    @IBOutlet weak var serviceTax: UILabel!
    @IBOutlet weak var finalPremium: UILabel!
    
    @IBOutlet weak var inspectionSuperVu: UIView!
    @IBOutlet weak var inspectionVu: UIView!
    @IBOutlet weak var inspectionCollection: UICollectionView!//1991
    @IBOutlet weak var inspectionHigh: NSLayoutConstraint!
    @IBOutlet weak var inspectionTop: NSLayoutConstraint!

    @IBOutlet weak var inspectionLocationVu: UIView!
    @IBOutlet weak var LocationLblVu: UIView!
    @IBOutlet weak var Locationlabel: UILabel!
    @IBOutlet weak var LocationHigh: NSLayoutConstraint!

    @IBOutlet weak var inspectionAgencyVu: UIView!
    @IBOutlet weak var AgencyLblVu: UIView!
    @IBOutlet weak var AgencyLabel: UILabel!
    @IBOutlet weak var AgencyHigh: NSLayoutConstraint!

    @IBOutlet weak var paymentVu: UIView!
    @IBOutlet weak var paymentHigh: NSLayoutConstraint!//0.75
    @IBOutlet weak var paymentDetailVu: UIView!
    @IBOutlet weak var paymentCollection: UICollectionView!//1992
    @IBOutlet weak var forwardCollection: UICollectionView!//1993
    
    @IBOutlet weak var emailVu: UIView!
    @IBOutlet weak var emailHigh: NSLayoutConstraint!
    @IBOutlet weak var emailTop: NSLayoutConstraint!
    @IBOutlet weak var email: UITextField!//133333
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var mobileVu: UIView!
    @IBOutlet weak var mobile: UITextField!//133334
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var getOtp: UIButton!
    
    @IBOutlet weak var otpVerifyVu: UIView!
    @IBOutlet weak var otpField: UITextField!//133335
    @IBOutlet weak var otpImage: UIImageView!

    @IBOutlet weak var firstVu: UIView!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondVu: UIView!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var thirdVu: UIView!
    @IBOutlet weak var thirdLbl: UILabel!
    @IBOutlet weak var fourthVu: UIView!
    @IBOutlet weak var fourthLbl: UILabel!
    @IBOutlet weak var fifthVu: UIView!
    @IBOutlet weak var fifthLbl: UILabel!
    @IBOutlet weak var payNowBtn: UIButton!
    
    @IBOutlet weak var tableposition: NSLayoutConstraint!
    @IBOutlet weak var inspectionTable: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyBoardView: NSLayoutConstraint!

    private let holderArr = ["Basic", "Vehicle", "Premium"]
    private var holderTapp : Int! = 0
    private var paymentTapp : Int! = 0
    private var sendTapp : Int! = 1
    private var inspectTapp : Int! = -1
    private let inspectArr = NSMutableArray.init()
    private let payArr = ["Credit/Debit Card", "Net Banking"]
    private var locAgncArr : NSArray! = NSArray.init()
    private var locArr : NSArray!
    private var agncArr : NSArray!
    private let common = Common.sharedCommon
    private let def = Common.sharedCommon.sharedUserDefaults()
    private var keyboardIsOpen = false
    private var locationTapped = false
    private let companyData = Common.sharedCommon.unArchiveMyDataForDictionary("StoredCompany")
    private var payStr : String!
    private var otpDone : String!
    var nextItem : NSIndexPath!
    private let cName = Common.sharedCommon.sharedUserDefaults().string(forKey: "ThisCompany")
    private let specificQuotationRequest = Common.sharedCommon.unArchiveMyDataForDictionary("SpecificQuotationRequest")

    override func viewDidLoad()
    {
        let inspectionObjectArray = ["Self", "Surveyor"]
        inspectArr.addObjects(from: inspectionObjectArray)
        let m = Constant.buyAPI+Constant.baseURL+Constant.companylogo+cName!+".png"
        let d = NSData.init(contentsOf: URL(string: m)!)
        companyLogo.image = UIImage.init(data: d! as Data)
        quotationNumber.text = def.string(forKey: "QuotationNumber")
        vehicleNumber.text = def.string(forKey: "RegistrationNumber")
        vehiclePackageLabel.text = (companyData!.object(forKey: "PlanName") as! String)
        vehicleScroll.isHidden = true
        premiumScroll.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let fp = common.removeOptionalKey("\(String(describing: (companyData!.object(forKey: "FinalPremium")!)))")
        
        payStr = "Pay ₹ "+fp+"/-"
        payNowBtn.titleLabel!.text = payStr
        
        collectionVu.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        paymentCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        forwardCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        inspectionCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        loadTextsForBasicLabels()
        loadTextsForVehicleLabels()
        loadTextsForPremiumLabels()
    }
    
    private func loadTextsForVehicleLabels()
    {
        let vehicleDet = specificQuotationRequest!.object(forKey: "VehicleDetails") as! NSDictionary
        registrationNumber.text = (vehicleDet.object(forKey:"RegistrationNumber") as! String)
        registrationDate.text = (vehicleDet.object(forKey:"RegistrationDate") as! String)
        policyStartDate.text = (specificQuotationRequest!.object(forKey: "PolicyStartDate") as! String)
        policyEndDate.text = (specificQuotationRequest!.object(forKey: "PolicyEndDate") as! String)
        manufacturer.text = (vehicleDet.object(forKey:"MakeName") as! String)
        model.text = (vehicleDet.object(forKey:"ModelName") as! String)
        variant.text = (vehicleDet.object(forKey:"VariantName") as! String)
        customerType.text = (specificQuotationRequest!.object(forKey: "CustomerType") as! String)
        engine.text = (vehicleDet.object(forKey:"EngineNumber") as! String)
        chassis.text = (vehicleDet.object(forKey:"ChassisNumber") as! String)
        
        
        if (!(specificQuotationRequest!.object(forKey: "DontKnowPreviousInsurer") as! Bool))
        {
            let prevPolicyDet = specificQuotationRequest!.object(forKey: "PreviousPolicyDetails") as! NSDictionary

            hideMyPolicyView(false)
            policyNumber.text = (prevPolicyDet.object(forKey: "PolicyNumber")  as! String)
            expiryDate.text = (prevPolicyDet.object(forKey: "PolicyEndDate")  as! String)
            insurerName.text = (prevPolicyDet.object(forKey: "InsurerName")  as! String)
        }
        else
        {
            hideMyPolicyView(true)
        }
                
        if ((specificQuotationRequest!.object(forKey: "IsVehicleFinanced") as! Bool))
        {
            hideMyHypoView(false)
            hypothecation.text = "Yes"
            financeCity.text = (specificQuotationRequest!.object(forKey: "FinancialInstAddress") as! String)
            financeName.text = (specificQuotationRequest!.object(forKey: "FinancialInstName") as! String)
        }
        else
        {
            hideMyHypoView(true)
        }
        applyRoundsAndShadowsForVehicleView()
    }
    
    private func loadTextsForBasicLabels()
    {
        let clientDetails = specificQuotationRequest!.object(forKey: "ClientDetails") as! NSDictionary

        var nameStr = (clientDetails.object(forKey: "FirstName") as! String) + " "
        if (clientDetails.object(forKey: "MidName") != nil)
        {
            nameStr = nameStr + (clientDetails.object(forKey: "MidName") as! String) + " "
        }
        nameStr = nameStr + (clientDetails.object(forKey: "LastName") as! String)
        holderName.text = nameStr
        holderGender.text = (clientDetails.object(forKey:"Gender") as! String)
        holderDOB.text = (clientDetails.object(forKey:"DateOfBirth") as! String)
        holderContact.text = (clientDetails.object(forKey:"MobileNumber") as! String)
        holderEmail.text = (clientDetails.object(forKey:"EmailAddress") as! String)
//        holderOcc.text = ((clientDetails.object(forKey:"Occupation") as! NSDictionary).object(forKey: "Name") as! String)
        holderOcc.text = def.string(forKey:"OccupationName")

        let commAddDict = specificQuotationRequest!.object(forKey: "CommunicationAddressDetails") as! NSDictionary
        let regAddDict = specificQuotationRequest!.object(forKey: "VehicleAddressDetails") as! NSDictionary

        var commAddresssStr = (commAddDict.object(forKey: "Address1") as! String) + " " + (commAddDict.object(forKey: "Address2") as! String)
                
        if (commAddDict.object(forKey: "Address3") != nil)
        {
            commAddresssStr = commAddresssStr + " " + (commAddDict.object(forKey: "Address3") as! String)
        }
        commAddress.text = commAddresssStr
        commCity.text = (commAddDict.object(forKey: "CityName") as! String)
        commState.text = (commAddDict.object(forKey: "StateName") as! String)
        commPin.text = (commAddDict.object(forKey: "Pincode") as! String)

        var regAddresssStr = (regAddDict.object(forKey: "Address1") as! String) + " " + (regAddDict.object(forKey: "Address2") as! String)
                    
        if (regAddDict.object(forKey: "Address3") != nil)
        {
            regAddresssStr = regAddresssStr + " " + (regAddDict.object(forKey: "Address3") as! String)
        }
        regAddress.text = regAddresssStr
        regCity.text = (regAddDict.object(forKey: "CityName") as! String)
        regState.text = (regAddDict.object(forKey: "StateName") as! String)
        regPin.text = (regAddDict.object(forKey: "Pincode") as! String)
        
        nomineeName.text = (specificQuotationRequest!.object(forKey: "NomineeName") as! String)
        nomineeDOB.text = (specificQuotationRequest!.object(forKey: "NomineeDateOfBirth") as! String)
        nomineeRelation.text = (specificQuotationRequest!.object(forKey: "NomineeRelation") as! String)
        nomineeGender.text = (specificQuotationRequest!.object(forKey: "NomineeGender") as! String)

        if (specificQuotationRequest!.object(forKey: "IsApointeeRequired") as! Bool)
        {
            hideMyAppointeeView(false)

            appointeeName.text = (specificQuotationRequest!.object(forKey: "AppointeeName") as! String)
            appointeeDOB.text = (specificQuotationRequest!.object(forKey: "AppointeeDateOfBirth") as! String)
            appointeeRelation.text = (specificQuotationRequest!.object(forKey: "AppointeeRelation") as! String)
        }
        else
        {
            hideMyAppointeeView(true)
        }
        applyRoundsAndShadowsForBasicView()
    }
    
    private func loadTextsForPremiumLabels()
    {
        let clientDetails = specificQuotationRequest!.object(forKey: "ClientDetails") as! NSDictionary

        // Premium
        mobile.text = (clientDetails.object(forKey: "MobileNumber") as! String)
        email.text = (clientDetails.object(forKey: "EmailAddress") as! String)

        var fp = common.removeOptionalKey("\(String(describing: (companyData?.object(forKey: "InsuredDeclaredValue")!)))").components(separatedBy: ".").first
        idvValue.text = "₹ "+fp!
        fp = common.removeOptionalKey("\(String(describing: companyData?.object(forKey: "PremiumYear")!))")
        premiumYr.text = fp!
        fp = common.removeOptionalKey("\(String(describing: (companyData?.object(forKey: "PremiumBreakUpDetails") as! NSDictionary).object(forKey: "NetPremium")!))").components(separatedBy: ".").first
        netPremium.text = "₹ "+fp!
        fp = common.removeOptionalKey("\(String(describing: (companyData?.object(forKey: "PremiumBreakUpDetails") as! NSDictionary).object(forKey: "ServiceTax")!))").components(separatedBy: ".").first
        serviceTax.text = "₹ "+fp!
        fp = common.removeOptionalKey("\(String(describing: (companyData?.object(forKey: "FinalPremium")!)))").components(separatedBy: ".").first
        finalPremium.text = "₹ "+fp!
        applyRoundsAndShadowsForPremiumView()
        common.applyRoundedShapeToView(inspectionAgencyVu, withRadius: 5)
        common.applyRoundedShapeToView(inspectionLocationVu, withRadius: 5)
        common.applyBorderToView(AgencyLblVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(LocationLblVu, withColor: Colors.textFldColor, ofSize: 1)
        self.tableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        
        inspectionViewLoader()
    }
    
    @objc private func inspectionTapped(_ sender: UITapGestureRecognizer? = nil)
    {
        mobile.resignFirstResponder()
        email.resignFirstResponder()
        let vi = sender?.view
        locAgncArr = nil
        locAgncArr = NSMutableArray.init()
        if (vi!.isDescendant(of: inspectionAgencyVu))
        {
            locationTapped = false
            locAgncArr.addingObjects(from: self.agncArr as! [Any])
        }
        else
        {
            locationTapped = true
            locAgncArr.addingObjects(from: self.locArr as! [Any])
        }
        tableView.reloadData()
        tableView.updateTableContentInset()
        positionOfTableView(false)
    }
    
    private func positionOfTableView(_ hide : Bool)
    {
        if (!hide)
        {
            var topConstraint : NSLayoutConstraint!
            if (locationTapped)
            {
                topConstraint = NSLayoutConstraint.init(item: inspectionTop.firstItem as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: inspectionLocationVu, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            }
            else
            {
                topConstraint = NSLayoutConstraint.init(item: inspectionTop.firstItem as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: inspectionAgencyVu, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            }
            inspectionTop.isActive = false
            inspectionTop = nil
            inspectionTop = topConstraint
            topConstraint = nil
            NSLayoutConstraint.activate([inspectionTop])
            inspectionTable.layoutIfNeeded()
        }
        inspectionTable.isHidden = hide
    }
    
    private func inspectionViewLoader()
    { //zero for hide, 1 for only agency, 2 for only location, 3 for agency and location, 4 for complete view Hidden
        switch(def.integer(forKey: "ProductCode"))
        {
        case 2:
            if (!(cName!.elementsEqual("CHOLAMANDLAM")) && def.bool(forKey: "IsBreakingCase") && !def.bool(forKey:"IsThirdPartyOnly"))
            {
    //            payNowBtn.titleLabel!.text = "Generate Inspection"
                payNowBtn.setTitle("Generate Inspection", for: .normal)

                if (cName!.elementsEqual("IFFCOTOKIO"))
                {
                    apiForInspection()
    //                inspectionViewSize(false)
                    //2+agency
                }
                else if (cName!.elementsEqual("DIGIT") || cName!.elementsEqual("ROYALSUNDRAM") || cName!.elementsEqual("BHARTI"))
                {
                    inspectArr.removeObject(at: 1)
    //                inspectTapp = 0
                    apiForInspection()
    //                inspectionViewSize(false)
                    // agency+self
                }
                else if (cName!.elementsEqual("ICICI"))
                {
                    inspectArr.removeObject(at: 1)
    //                inspectTapp = 0
                    apiForInspection()

    //                inspectionViewSize(false)
                    // self
                }
                else if (cName!.elementsEqual("BAJAJ"))
                {
                    inspectArr.removeObject(at: 1)
    //                inspectTapp = 0
                    apiForInspection()
    //                inspectionViewSize(false)
                    //self+agency
                }
                else
                {
                    inspectionViewSize(true)
                }
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.inspectionTapped(_:)))
                let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.inspectionTapped(_:)))
                inspectionAgencyVu.addGestureRecognizer(tap1)
                inspectionLocationVu.addGestureRecognizer(tap2)
            }
            else
            {
                inspectionViewSize(true)
            }
            break
        default:
            inspectionViewSize(true)
            break
        }
    }
    
    private func apiForInspection()
    {
        let urlString = Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor
        let companySubProd = Constant.companyC+cName!+Constant._subprod+def.string(forKey: "SubProductCode")!
        let agencyString = urlString + "InspectionAgency" + companySubProd
        APICallered().fetchData(agencyString) { response in
                self.agncArr = response?.object(forKey: "Response") as? NSArray
                DispatchQueue.main.async {
                    self.inspectionViewSize(false)
                }
            }
        
        let locationString = urlString + "InspectionLocationCodeByCompany" + companySubProd
        APICallered().fetchData(locationString) { response in
                self.locArr = response?.object(forKey: "Response") as? NSArray
                DispatchQueue.main.async {
                    self.inspectionViewSize(false)
                }
            }
    }
    
    private func applyRoundsAndShadowsForPremiumView()
    {
        common.applyRoundedShapeToView(premiumDetailVu, withRadius: 15)
        common.applyRoundedShapeToView(inspectionVu, withRadius: 15)
        common.applyRoundedShapeToView(paymentDetailVu, withRadius: 15)
        common.applyRoundedShapeToView(otpVerifyVu, withRadius: 15)
        common.applyRoundedShapeToView(payNowBtn, withRadius: 10)
        common.applyRoundedShapeToView(getOtp, withRadius: 10)

        common.applyShadowToView(premiumDetailVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(inspectionVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(paymentDetailVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(otpVerifyVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        
        common.applyRoundedShapeToView(mobile, withRadius: 5)
        common.applyRoundedShapeToView(email, withRadius: 5)
        common.applyRoundedShapeToView(firstVu, withRadius: 10.0)
        common.applyRoundedShapeToView(secondVu, withRadius: 10.0)
        common.applyRoundedShapeToView(thirdVu, withRadius: 10.0)
        common.applyRoundedShapeToView(fourthVu, withRadius: 10.0)
        common.applyRoundedShapeToView(fifthVu, withRadius: 10.0)

        common.applyRoundedShapeToView(firstLbl, withRadius: 10.0)
        common.applyRoundedShapeToView(secondLbl, withRadius: 10.0)
        common.applyRoundedShapeToView(thirdLbl, withRadius: 10.0)
        common.applyRoundedShapeToView(fourthLbl, withRadius: 10.0)
        common.applyRoundedShapeToView(fifthLbl, withRadius: 10.0)

        common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
        common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
        common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
        common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
        common.applyBorderToView(fifthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
        textFieldLabel()
    }

    private func applyRoundsAndShadowsForVehicleView()
    {
        common.applyRoundedShapeToView(vehicleDetailsVu, withRadius: 15)
        common.applyRoundedShapeToView(policyDetailsVu, withRadius: 15)
        common.applyRoundedShapeToView(hypoDetailsVu, withRadius: 15)
        common.applyRoundedShapeToView(nextVehicle, withRadius: 10)

        common.applyShadowToView(vehicleDetailsVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(policyDetailsVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(hypoDetailsVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
    }

    private func applyRoundsAndShadowsForBasicView()
    {
        common.applyRoundedShapeToView(holderDetailsVu, withRadius: 15)
        common.applyRoundedShapeToView(addressDetailsVu, withRadius: 15)
        common.applyRoundedShapeToView(nomineeDetailsVu, withRadius: 15)
        common.applyRoundedShapeToView(appointeeDetailsVu, withRadius: 15)
        common.applyRoundedShapeToView(nextBasic, withRadius: 10)

        common.applyShadowToView(holderDetailsVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(addressDetailsVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(nomineeDetailsVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(appointeeDetailsVu.superview!, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if (!keyboardIsOpen)
            {
                keyboardIsOpen = true
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyBoardView.constant = keyboardHeight
            }
        }
    }
    
    func hideMyAppointeeView(_ hide: Bool) {
        if (hide)
        {
            appointeeTop.constant = 0
            appointeeHigh.constant = 0
        }
        else
        {
            appointeeHigh.constant = 120
            appointeeTop.constant = 10
        }
        appointeeVu.layoutIfNeeded()
    }
    
    func hideMyPolicyView(_ hide: Bool) {
        if (hide)
        {
            policyTop.constant = 0
            policyHigh.constant = 0
        }
        else
        {
            policyTop.constant = 10
            let ccc = CGFloat(insurerName.text!.count/30)
            var hhh = 120.0
            if (ccc > 1)
            {
                hhh += ccc*20
            }
            policyHigh.constant = hhh
        }
        policyVu.layoutIfNeeded()
    }
    
    func hideMyHypoView(_ hide: Bool) {
        if (hide)
        {
            hypoTop.constant = 0
            hypoHigh.constant = 0
        }
        else
        {
            hypoTop.constant = 10
            let ccc = CGFloat(financeName.text!.count/30)
            var hhh = 120.0
            if (ccc > 1)
            {
                hhh += ccc*20
            }
            hypoHigh.constant = hhh
        }
        hypoVu.layoutIfNeeded()
    }
    
    private func inspectionViewSize(_ hide : Bool)
    {
        var inspectionHeight : CGFloat!
        var agencyHeight : CGFloat!
        var locationHeight : CGFloat!
        var isAgencyVisible : Bool!
        var isLocationVisible : Bool!

        if (!hide)
        {
            inspectionTop.constant = 10
            inspectionHeight = 85
            if (agncArr != nil)
            {
                inspectionHeight = 215
                agencyHeight = 100
                isAgencyVisible = true
            }
            else
            {
                agencyHeight = 0.1
                isAgencyVisible = false
            }
            
            if (locArr != nil)
            {
                inspectionHeight = 215
                locationHeight = 100
                isLocationVisible = true
            }
            else
            {
                locationHeight = 0.1
                isLocationVisible = false
            }
            
            if (locArr != nil && agncArr != nil)
            {
                inspectionHeight = 315
            }
        }
        else
        {
            isLocationVisible = false
            isAgencyVisible = false
            locationHeight = 0.1
            agencyHeight = 0.1
            inspectionTop.constant = 0
            inspectionHeight = 0.1
        }
        
        LocationHigh.constant = locationHeight
        AgencyHigh.constant = agencyHeight

        inspectionLocationVu.layoutIfNeeded()
        inspectionAgencyVu.layoutIfNeeded()
        inspectionLocationVu.isHidden = !isLocationVisible
        inspectionAgencyVu.isHidden = !isAgencyVisible

        inspectionHigh.constant = inspectionHeight
        inspectionSuperVu.layoutIfNeeded()
        inspectionSuperVu.isHidden = hide
    }
    
    
    @IBAction func nextBtnTapped(_ sender : UIButton)
    {
        holderTapp += 1
        collectionVu.reloadData()
    }

    @IBAction func payNowBtnTapped(_ sender : UIButton)
    {
        if (payAfterInspectionCheckSelected())
        {
            if (otpDone != nil && otpField.hasText)
            {
                if (otpField.text!.elementsEqual(otpDone))
                {
                    var p : String!
                    if (paymentTapp == 1)
                    {
                        p = "DD"
                    }
                    else if (paymentTapp == 0)
                    {
                        p = "CC"
                    }
                    else
                    {
                        p = "EMI"
                    }
                    var agencyName : String!
                    var locationName : String!
                    var modeName : String!
                    if (agncArr != nil)
                    {
                        agencyName = AgencyLabel.text!
                    }
                    if (agncArr != nil)
                    {
                        locationName = Locationlabel.text!
                    }
                    if (!inspectionSuperVu.isHidden)
                    {
                        if (inspectTapp != -1)
                        {
                            let inspectionString = inspectArr.object(at: inspectTapp) as! String
                            if (inspectionString.elementsEqual("Self"))
                            {
                                modeName = "SelfInspection"
                            }
                            else
                            {
                                modeName = "SurveyorInspection"
                            }
                        }
                    }
                    callApiForInspectionOrPayOrForwardQuotation(_Pay: p, _agency: agencyName, _location: locationName, _mode: modeName, _payBtn: sender.titleLabel!.text!)
                }
                else
                {
                    let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                    alertVu.showError("Error!", subTitle: "Kindly enter the sent OTP first.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                }
            }
            else
            {
                let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                alertVu.showError("Alert!", subTitle: "Kindly get the OTP and enter the sent OTP", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
            }
        }
        else if (!inspectionSuperVu.isHidden)
        {
            var msgString = "Kindly select inspection"
            if (Locationlabel.text!.elementsEqual("Select Inspection Location"))
            {
                if (inspectTapp == -1)
                {
                    msgString += ", "
                }
                msgString += "inspection location"
            }
            else if (AgencyLabel.text!.elementsEqual("Select Inspection Agency"))
            {
                if (inspectTapp == -1 || Locationlabel.text!.elementsEqual("Select Inspection Location"))
                {
                    msgString += ", "
                }
                msgString += "inspection agency"
            }
            msgString += " first."
            showAlertWithCancel(msgString)
        }
        
    }
    
    private func showAlertWithCancel(_ msg: String)
    {
        let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
        alertVu.showWarning("Alert!", subTitle: msg, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }
    
    private func payAfterInspectionCheckSelected() -> Bool
    {
        var canPayTap = true
        if (!inspectionSuperVu.isHidden)
        {
            if (inspectTapp == -1)
            {
                canPayTap = false
            }
            else
            {
                canPayTap = payAfterLocationAndAgencyIsSelected(canPayTap)
            }
        }
        return canPayTap
    }
    
    private func payAfterLocationAndAgencyIsSelected(_ canDo : Bool) -> Bool
    {
        var canPayTap = canDo
        if (!inspectionLocationVu.isHidden)
        {
            if (Locationlabel.text!.elementsEqual("Select Inspection Location"))
            {
                canPayTap = false
            }
        }
        if (!inspectionAgencyVu.isHidden)
        {
            if (AgencyLabel.text!.elementsEqual("Select Inspection Agency"))
            {
                canPayTap = false
            }
        }
        return canPayTap
    }
    
    private func callApiForInspectionOrPayOrForwardQuotation(_Pay p: String, _agency agency: String?, _location location: String?, _mode mode: String?, _payBtn btnString : String)
    {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Processing"

        var vehicleType = ""
        var insurance_type = ""
        
        switch(def.integer(forKey: "ProductCode"))
        {
        case 2:
            vehicleType = Constant.privatecar
            insurance_type = Constant.car_insur
            break
        case 1:
            vehicleType = Constant.twowheeler
            insurance_type = Constant.twowheel_insur
            break
        case 10:
            vehicleType = Constant.goodCom
            insurance_type = Constant.comVehInsur + Constant.goodsCarry_insur
            break
        case 9:
            vehicleType = Constant.passCom
            insurance_type = Constant.comVehInsur + Constant.passCarry_insur
            break
        default:
            vehicleType = Constant.miscCom
            insurance_type = Constant.comVehInsur + Constant.miscVeh_insur
            break
        }
        let k = Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+vehicleType+Constant.proposal
        let jsonObj = PostJsonData().proposalData(_mobileNo: mobile.text!, _otpValue: otpField.text!, _paymentMode: p, _response: nil, _agency: agency, _location: location, _mode: mode)
        self.common.archiveMyDataForDictionary(jsonObj, withKey: "ProposalRequest")
        print(jsonObj)
        APICallered().POSTMethodForDataToGet(dataToPass: jsonObj, toURL: k) { response in
            let resp = response?.object(forKey: "Response") as! NSDictionary
            if ((!(resp.object(forKey: "ReferenceId") is NSNull)) && (resp.object(forKey: "Status") as! String).elementsEqual("Success"))
            {
                DispatchQueue.main.async {
                    let refId = resp.object(forKey: "ReferenceId") as! String
                    let proposal = resp.object(forKey: "ProposalNumber") as? String
                    let rmcode = resp.object(forKey: "RMCode") as? String
                    let region = resp.object(forKey: "Region") as? String
                    let posInclude = resp.object(forKey: "IsPOSIncluded") as! Bool
                    let POS = resp.object(forKey: "POSDetails")
                    let paymentAllow = resp.object(forKey: "IsPaymentAllow") as! Bool
                    let BreakinId = resp.object(forKey: "BreakinId")
                    var POSDetails : NSDictionary!
                    if (POS != nil)
                    {
                        POSDetails = resp.object(forKey: "POSDetails") as? NSDictionary
                    }
                    else
                    {
                        POSDetails = nil;
                    }
                    
                    let jsonObjc = PostJsonData().secondProposalRequest(refId, proposal, rmcode, region: region, POSDetails , posInclude, BreakinId as? Int, paymentAllow)
                    print(jsonObjc)
                    let kr = Constant.buyAPI+Constant.baseURL+Constant.insurance+insurance_type+Constant.proposal
                    APICallered().POSTMethodForDataToGet(dataToPass: jsonObjc, toURL: kr) { response in
                        print(response as Any)
                        if (response?.object(forKey: "Success") as! Bool)
                        {
                            let kkk = response?.object(forKey: "Url") as! String
                            DispatchQueue.main.async {
                                if (btnString.elementsEqual("Forward Quotation"))
                                {
                                    let anotherJson = PostJsonData().forwardPaymentDetailsToClient(refId)
                                    print(anotherJson)
                                    
                                    let urlS = Constant.buyAPI+Constant.baseURL+Constant.client+Constant.sendToClient
                                    APICallered().POSTMethodForDataToGet(dataToPass: anotherJson, toURL: urlS) { response in
                                        print(response!)
                                        DispatchQueue.main.async {
                                            MBProgressHUD.hide(for: self.view, animated: true)
                                        }
                                    }
                                }
                                else if (btnString.elementsEqual("Generate Inspection"))
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                                    alertVu.showInfo("Inspection Request Generated.", subTitle: "Kindly check your inspection details on your provided contact details.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                                }
                                else
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                        self.loadNextScreeen(kkk)
                                    }
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let errorMsg = (response?.object(forKey: "Message") as! String)
                                    let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                                    alertVu.showError("Info!", subTitle: errorMsg, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                                    //Message = "Due to some technical issue we are unable to proceed for payment, Please contact support team with your quotation number."
                                }
                            }
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if ((resp.object(forKey: "ErrorMessage") is NSNull) && (resp.object(forKey: "ReferenceId") is NSNull))
                        {
                            let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                            alertVu.showError("Error!", subTitle: "Something went wrong on company's site", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                        }
                        else if ((resp.object(forKey: "Status") as! String).lowercased().elementsEqual("info") || (resp.object(forKey: "Status") as! String).lowercased().elementsEqual("error"))
                        {
                            let errorMsg = (resp.object(forKey: "ErrorMessage") as! String)
                            let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                            alertVu.showError("Error!", subTitle: errorMsg, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                        }
                        else
                        {
                            let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                            alertVu.showError("Error!", subTitle: "Something went wrong.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                        }
                    }
                }
        }
    }
    
    private func loadNextScreeen(_ url : String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier:"MotorWebViewController") as! MotorWebViewController
        secondViewController.urlString = url
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabel()
        keyboardIsOpen = false
        keyBoardView.constant = 0
    }

    // MARK: - COLLECTION METHODS

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tagV = collectionView.tag
        switch(tagV)
        {
        case 1991:
            do {
                return inspectArr.count
            }
        case 1992:
            do {
                return payArr.count
            }
        case 1993:
            do {
                return Common.yesNoBtnArray.count
            }
        default:
            do {
                return holderArr.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        let tagV = collectionView.tag
        switch (tagV)
        {
        case 1991:
                cell.setDataForNormal(inspectArr[indexPath.row] as! String, ofFontSize: 14)
                if (inspectTapp == indexPath.row)
                {
                    cell.setSelectedData()
                }
                break
        case 1992:
                cell.setDataForNormal(payArr[indexPath.row], ofFontSize: 14)
                if (paymentTapp == indexPath.row)
                {
                    cell.setSelectedData()
                }
                break
        case 1993:
                cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 14)
                if (sendTapp == indexPath.row)
                {
                    cell.setSelectedData()
                    let k = Bool(truncating: NSNumber.init(value: indexPath.row))
                    hideMyEmailVu(k)
                }
                break
        default:
                cell.setDataForNormal(holderArr[indexPath.row], ofFontSize: 14)
                if (holderTapp == indexPath.row)
                {
                    cell.setSelectedData()
                    showMyScrollView()
                }
                break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tagV = collectionView.tag
        switch (tagV)
        {
        case 1991:
                if (indexPath.row == inspectTapp)
                {
                    inspectTapp = -1
                }
                else
                {
                    inspectTapp = indexPath.row
                }
                break
        case 1992:
                paymentTapp = indexPath.row
                break
        case 1993:
                sendTapp = indexPath.row
                break
        default:
                holderTapp = indexPath.row
                break
        }
        collectionView.reloadData()
    }

    private func showMyScrollView()
    {
        switch(holderTapp)
        {
        case 1:
               vehicleScroll.isHidden = false
               basicScroll.isHidden = true
               premiumScroll.isHidden = true
               if (keyboardIsOpen)
               {
                   otpField.resignFirstResponder()
               }
               break
        case 2:
               premiumScroll.isHidden = false
               vehicleScroll.isHidden = true
               basicScroll.isHidden = true
               if (keyboardIsOpen)
               {
                   otpField.resignFirstResponder()
               }
               break
        default:
               basicScroll.isHidden = false
               vehicleScroll.isHidden = true
               premiumScroll.isHidden = true
               if (keyboardIsOpen)
               {
                   otpField.resignFirstResponder()
               }
               break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = Common.sharedCommon.getScreenSize(collectionView)
        var CellWidth = widthAndHeight.0
        var CellHeight = widthAndHeight.1
        let tagV = collectionView.tag
        switch (tagV)
        {
        case 1991:
                let c = (inspectArr[indexPath.row] as! String).count*10
                CellWidth = CGFloat(c+50)
                CellHeight *= 0.7
                break
        case 1992:
            var vvv = (payArr[indexPath.row]).count
            if (indexPath.row == 2)
            {
                vvv = 7
            }
                let c = vvv*10
                CellWidth = CGFloat(c)
                CellHeight *= 0.7
                break
        case 1993:
                CellWidth = 50
                CellHeight *= 0.7
                break
        default:
                CellWidth *= 0.3
                CellHeight *= 0.8
                break
        }
        
        let sizes: CGSize = CGSize(width: CellWidth, height: CellHeight)
        return sizes;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
        if (collectionView.tag != 1608)
        {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        }

        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5);
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        textFieldLabel()
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 133333:
            common.setTextFieldLabels(email, emailLbl, false, "")
            break
        case 133334:
            common.setTextFieldLabels(mobile, mobileLbl, false, "")
            break
        default:
            break
        }
        premiumScroll.scrollRectToVisible(textField.superview!.frame, animated: true)
        return true
    }
    
    private func textFieldLabel()
    {
        setLabelFieldMutualVisibility(mobile, mobileLbl.text!, mobileLbl)
        setLabelFieldMutualVisibility(email, emailLbl.text!, emailLbl)
        common.applyBorderToView(email, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(mobile, withColor: Colors.textFldColor, ofSize: 1)
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
        var currentString: NSString = textField.text! as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let tagValue = textField.tag
        switch(tagValue)
        {
//        case 133334:
//            if (textField.text!.count >= 10)
//            {
//                textField.resignFirstResponder()
//            }
//        break
        case 133335:
            otpLabelFilled(textField.text!)
            if (textField.text!.count == 5)
            {
                textField.resignFirstResponder()
            }
            else if (textField.text!.count > 5)
            {
                textField.text = ""
            }
            break
        default:
            break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        keyboardIsOpen = false
        textFieldLabel()
        return true
    }
 
    private func otpLabelFilled(_ string : String)
    {
        let k = string.count
        print(k)
        let variable : [Int] = common.splitStringIntoArrayForOTP(string)
        switch(variable.count)
        {
        case 1:
                firstLbl.text = String(variable[0])
                secondLbl.text = ""
                thirdLbl.text = ""
                fourthLbl.text = ""
                fifthLbl.text = ""
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(fifthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                break
        case 2:
                firstLbl.text = String(variable[0])
                secondLbl.text = String(variable[1])
                thirdLbl.text = ""
                fourthLbl.text = ""
                fifthLbl.text = ""
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                break
        case 3:
                firstLbl.text = String(variable[0])
                secondLbl.text = String(variable[1])
                thirdLbl.text = String(variable[2])
                fourthLbl.text = ""
                fifthLbl.text = ""
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(fifthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                break
        case 4:
                firstLbl.text = String(variable[0])
                secondLbl.text = String(variable[1])
                thirdLbl.text = String(variable[2])
                fourthLbl.text = String(variable[3])
                fifthLbl.text = ""
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(fifthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                break
        case 5:
                firstLbl.text = String(variable[0])
                secondLbl.text = String(variable[1])
                thirdLbl.text = String(variable[2])
                fourthLbl.text = String(variable[3])
                fifthLbl.text = String(variable[4])
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(fifthLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                if (string.elementsEqual(otpDone))
                {
                    otpImage.image = UIImage.init(named: "Confirm")
                }
                else
                {
                    otpImage.image = UIImage.init(systemName: "exclamationmark.triangle.fill")
                }
                break
        default:
                firstLbl.text = ""
                secondLbl.text = ""
                thirdLbl.text = ""
                fourthLbl.text = ""
                fifthLbl.text = ""
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(fifthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                break
        }
    }
    
    @IBAction func backBtnTapped()
    {
        let alertVu = SCLAlertView.init(appearance: common.alertwithCancel)
        alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
            alertVu.hideView()
            self.navigationController?.popViewController(animated: true)
        }
        alertVu.showInfo("Go Back", subTitle: "Do you still want to go on previous screen?", closeButtonTitle: "No", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }
    
    @IBAction func getOTPBtnTapped()
    {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Generating OTP"

        //https://buy.probusinsurance.com/Client/GenerateOTPForMotor?BreakIn=No&Model=MARUTI+BALENO+Alpha+1.2+(1197+CC)+-+PETROL&Premium=8946&RegYear=2020&RenewalNCB=25&clientName=SANNIBHAI&emailId=ab@ab.ab&mobileNumber=7014827016&productCode=Motor&quotationNumber=PIBLMTRPC2022061511065320&subProductCode=MTRPC
        //  https://buy.probusinsurance.com/Client/ConfirmAndValidateOTP?quotationNumber=PIBLMTRPC2022061511065320

        var breakIn : String = Constant.breakin_No
        if (def.bool(forKey: "IsBreakingCase"))
        {
            breakIn = Constant.breakin_Yes
        }
        let veh_model = (manufacturer.text! + " " + model.text! + " " + variant.text!).replacingOccurrences(of: " ", with: "+")
        let newNCB = String(def.integer(forKey: "newNCB"))
        let clientDetails = specificQuotationRequest!.object(forKey: "ClientDetails") as! NSDictionary
        let nameStr = (clientDetails.object(forKey: "FirstName") as! String)

        let _premium = finalPremium.text!.replacingOccurrences(of: "₹ ", with: "")
        
        var generate = Constant.buyAPI+Constant.baseURL+Constant.client+Constant.gen_otp+Constant.for_motor+breakIn+Constant._VehModel+veh_model+Constant._premium+_premium+Constant._regYr+def.string(forKey: "RegistrationYear")!
        
//        generate += Constant._renewNCB + newNCB + Constant._clientName+self.holderName.text!+Constant._emailId+self.email.text!+Constant.mobNumb+self.mobile.text!+Constant._prodCode+"MOTOR" + Constant._quotationNum+def.string(forKey: "QuotationNumber")! + Constant._subProdCode+self.def.string(forKey: "SubProductCode")!

        
        generate += Constant._renewNCB + newNCB + Constant._clientName+nameStr+Constant._emailId+self.email.text!+Constant.mobNumb+self.mobile.text!+Constant._prodCode+"Motor" + Constant._quotationNum+def.string(forKey: "QuotationNumber")! + Constant._subProdCode+self.def.string(forKey: "SubProductCode")!
        

        let confirm = Constant.buyAPI+Constant.baseURL+Constant.client+Constant.conf_val_otp+Constant.quot_Num+def.string(forKey: "QuotationNumber")!

        
        
        APICallered().POSTMethodForDataToGet(dataToPass: nil, toURL: generate) { response in
            DispatchQueue.main.async {
                APICallered().fetchData(confirm) { response in
                    DispatchQueue.main.async {

                let otpVal = response?.object(forKey: "BoolValue")!
                self.otpDone = (otpVal as! String)

                        MBProgressHUD.hide(for: self.view, animated: true)
                        let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                        alertVu.showSuccess("OTP Sent!", subTitle: nil, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                    }
                }
            }
        }
        
        
        
    /*    let k = mainURL+Constant.conf_val_otp+Constant.quot_Num+def.string(forKey: "QuotationNumber")!
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Generating OTP"

        APICallered().fetchData(k) { response in
            print(response!)
                    DispatchQueue.main.async {
                        var sendOTPTo = mainURL+Constant.gen_otp+Constant.mobNumb+self.mobile.text!+Constant._prodCode+String(self.def.integer(forKey: "ProductCode"))
                        sendOTPTo += Constant._subProdCode+self.def.string(forKey: "SubProductCode")!
                        sendOTPTo += Constant.quot_Num+self.def.string(forKey: "QuotationNumber")!
                        sendOTPTo += Constant._clientName+self.holderName.text!+Constant._emailId+self.email.text!
                        APICallered().POSTMethodForDataToGet(dataToPass: nil, toURL: sendOTPTo) { response in
                        DispatchQueue.main.async {
                                    APICallered().fetchData(k) { response in
                                        DispatchQueue.main.async {
                                            MBProgressHUD.hide(for: self.view, animated: true)
                                            let otpVal = response?.object(forKey: "BoolValue")!
                                            self.otpDone = (otpVal as! String)
                                            let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                                            alertVu.showSuccess("OTP Sent!", subTitle: nil, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                                        }
                                    }
                                }
                        }
                    }
        }*/
    }

    func hideMyEmailVu(_ hide: Bool) {
        if (hide)
        {
            emailTop.constant = 0
            emailHigh.constant = 0.1
            paymentHigh.constant = 312

            if (inspectionSuperVu.isHidden)
            {
                payNowBtn.setTitle(payStr, for: .normal)
            }
            else
            {
                payNowBtn.setTitle("Generate Inspection", for: .normal)
            }
        }
        else
        {
            emailTop.constant = 10
            emailHigh.constant = 66
            paymentHigh.constant = 388
            payNowBtn.setTitle("Forward Quotation", for: .normal)
        }

        emailVu.layoutIfNeeded()
        mobileVu.layoutIfNeeded()
        paymentVu.layoutIfNeeded()
        emailVu.isHidden = hide
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locAgncArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
        let nameDict = (locAgncArr[indexPath.row]) as? NSDictionary
        let stringName = nameDict?.object(forKey: "Name") as! String
        cell.setDispaly(stringName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameDict = (locAgncArr[indexPath.row]) as? NSDictionary
        let stringName = nameDict?.object(forKey: "Name") as! String
        if (locationTapped)
        {
            Locationlabel.text = stringName
        }
        else
        {
            AgencyLabel.text = stringName
        }
    }
}
