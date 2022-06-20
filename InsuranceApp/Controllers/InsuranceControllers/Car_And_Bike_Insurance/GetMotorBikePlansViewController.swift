//
//  GetMotorBikePlansViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 03/12/21.
//

import Foundation
import UIKit
import MBProgressHUD

class GetMotorBikePlansViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIScrollViewDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var emailQuote: UIButton!
    
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var planTable: UITableView!
    
    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var quotationLabel: UILabel!
    
    @IBOutlet weak var toatalPlan: UILabel!
    @IBOutlet weak var modifyQuotes: UIButton!
    @IBOutlet weak var modifyView: UIView!
    @IBOutlet weak var modifyViewVisibility: NSLayoutConstraint!
    @IBOutlet weak var closeModify: UIButton!
    
    @IBOutlet weak var quotationNumberLbl: UILabel!
    @IBOutlet weak var vehicleDetailLbl: UILabel!
    @IBOutlet weak var VehicleYearRTO: UILabel!
    //Private Car     •  2018     •  GJ-01 Ahmedabad
    
    @IBOutlet weak var idvViewHigh: NSLayoutConstraint!
    @IBOutlet weak var idvFieldHigh: NSLayoutConstraint!
    @IBOutlet weak var idvView: UIView!
    @IBOutlet weak var idvCollection: UICollectionView!//100001
    @IBOutlet weak var customIDVView: UIView!
    @IBOutlet weak var customIDV: UITextField!
    @IBOutlet weak var customIDVLbl: UILabel!
    @IBOutlet weak var minMaxRangeLbl: UILabel!
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountImg: UIImageView!
    @IBOutlet weak var discountPlus: UIView!
    @IBOutlet weak var discountPlusHigh: NSLayoutConstraint!
    
    @IBOutlet weak var coverageView: UIView!
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var coveragePlus: UIView!
    @IBOutlet weak var coveragePlusHigh: NSLayoutConstraint!//1.36
    
    @IBOutlet weak var addonPosition: NSLayoutConstraint!//10
    @IBOutlet weak var addonHigh: NSLayoutConstraint!
    @IBOutlet weak var addonView: UIView!
    @IBOutlet weak var addonImg: UIImageView!
    @IBOutlet weak var addonPlus: UIView!
    @IBOutlet weak var addonPlusHigh: NSLayoutConstraint!
    
    @IBOutlet weak var VoluntryExcAmt: UITextField!//100101
    @IBOutlet weak var associationName: UITextField!//100102
    @IBOutlet weak var membershipNumber: UITextField!//100103
    @IBOutlet weak var membershipExpiry: UITextField!//100104
    @IBOutlet weak var elecAccAmt: UITextField!//100105
    @IBOutlet weak var nonElecAccAmt: UITextField!//100106
    @IBOutlet weak var biFuelAmt: UITextField!//100107
    @IBOutlet weak var paidDriverSum: UITextField!//100108
    @IBOutlet weak var unnamedPersonSum: UITextField!//100109
    @IBOutlet weak var noOfLLEmp: UITextField!//100110
    @IBOutlet weak var noOFDrivers: UITextField!//100111
    
    @IBOutlet weak var voluntaryExcessView: UIView!
    @IBOutlet weak var voluntaryExcessHigh: NSLayoutConstraint!
    @IBOutlet weak var volExcAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var antiTheftView: UIView!
    @IBOutlet weak var antiTheftHigh: NSLayoutConstraint!
    
    @IBOutlet weak var AAIView: UIView!//0.44
    @IBOutlet weak var AAIHigh: NSLayoutConstraint!
    @IBOutlet weak var AAIMembersHigh: NSLayoutConstraint!//0.34
    
    @IBOutlet weak var modifyHandicapView: UIView!
    @IBOutlet weak var handicapHigh: NSLayoutConstraint!
    
    @IBOutlet weak var tppdView: UIView!
    
    @IBOutlet weak var electricalAccHigh: NSLayoutConstraint!
    @IBOutlet weak var elecAccView: UIView!
    @IBOutlet weak var elecAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var nonElectricalAccHigh: NSLayoutConstraint!
    @IBOutlet weak var nonElecAccView: UIView!
    @IBOutlet weak var nonElecAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var biFuelHigh: NSLayoutConstraint!
    @IBOutlet weak var biFuelView: UIView!
    @IBOutlet weak var biFuelAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var paidDriverHigh: NSLayoutConstraint!
    @IBOutlet weak var paidDriverView: UIView!
    @IBOutlet weak var paidDriverAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var unnamedPersonHigh: NSLayoutConstraint!
    @IBOutlet weak var unnamedPersonView: UIView!
    @IBOutlet weak var unnamedPersonAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var noOfLLempHigh: NSLayoutConstraint!
    @IBOutlet weak var noOfLLempView: UIView!
    @IBOutlet weak var noOfLLempAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var llPaidDriverHigh: NSLayoutConstraint!
    @IBOutlet weak var llPaidDriverView: UIView!
    @IBOutlet weak var llPaidDriverAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var fibreGlassView: UIView!
    @IBOutlet weak var fibrglassHigh: NSLayoutConstraint!
    
    @IBOutlet weak var zeroDepView: UIView!//100016
    @IBOutlet weak var consumableView: UIView!//100017
    @IBOutlet weak var engineProtView: UIView!//100020
    @IBOutlet weak var invoiceView: UIView!//100021
    @IBOutlet weak var roadSideAssistView: UIView!//100028
    
    @IBOutlet weak var volExcLbl: UILabel!
    @IBOutlet weak var associationLbl: UILabel!
    @IBOutlet weak var membershipLbl: UILabel!
    @IBOutlet weak var memberShipExpLbl: UILabel!
    
    @IBOutlet weak var keyboardView : NSLayoutConstraint!
    
    @IBOutlet weak var manufacturePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var selectDate: UIButton!
    
    @IBOutlet weak var customEntryView: UIView!
    @IBOutlet weak var entryTable: UITableView!
    @IBOutlet weak var entryTablePosition: NSLayoutConstraint!
    
    enum textFi {
        case VolAmt
        case paDriver
        case paUnname
        case noDriver
    }
    private var texFi = textFi.VolAmt
    
    private let voluntaryAmtArray = ["2500", "5000", "7500", "15000"]
    private let paCoverArray = ["10000", "20000", "30000", "40000", "50000", "60000", "70000", "80000", "90000", "100000", "110000", "120000", "130000", "140000", "150000", "160000", "170000", "180000", "190000", "200000"]
    private let driverArray = ["1", "2"]
    var addonArray : NSMutableArray!
    private var idvTapped : Int! = 0
    private var keyboardIsOpen = false
    private var planArray : NSMutableArray!
    var addonListArray : NSArray!
    private var min_IDV : Int! = 0
    private var max_IDV : Int! = 0
    private let common = Common.sharedCommon
    private let def = Common.sharedCommon.sharedUserDefaults()
    private let idvCollArray = ["Automatic (For best quotes)", "Set your own IDV"]
    private var declinedListArray : NSMutableArray!
    private var thisTextField : UITextField!
    private var discountViewHidden = true
    private var coverageViewHidden = true
    private var addonViewHidden = true
    
    var modifyPlan : Bool! = false
    private let qualifyApi = Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor
    
    override func viewDidLoad() {
        
        loadMyData()
        
        common.addDoneButtonOnNumpad(textField: customIDV)
        common.addDoneButtonOnNumpad(textField: membershipNumber)
        common.addDoneButtonOnNumpad(textField: elecAccAmt)
        common.addDoneButtonOnNumpad(textField: nonElecAccAmt)
        common.addDoneButtonOnNumpad(textField: biFuelAmt)
        common.addDoneButtonOnNumpad(textField: noOfLLEmp)
        common.applyRoundedShapeToView(selectDate, withRadius: 5)
        common.applyRoundedShapeToView(emailQuote, withRadius: 5)
        common.applyRoundedShapeToView(modifyQuotes, withRadius: 10)
        common.applyShadowToView(modifyView, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyBorderToView(emailQuote, withColor: common.hexStringToUIColor(hex: "#53C0D4"), ofSize: 1)
        modifyViewVisibility.constant = -(self.view.frame.size.width*0.9)
        
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+Constant.twowheeler+Constant.addon) { response in
            DispatchQueue.main.async {
                self.addonListArray = response?.object(forKey: "Response") as? NSArray
            }
        }
        planTable.register(UINib.init(nibName: "GetPlansTableViewCell", bundle: nil), forCellReuseIdentifier: "planCell")
        planTable.register(UINib.init(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        
        allGseturedAdded()
        showAndHideDiscountView()
        showAndHideCoverageView()
        showAndHideAddonView()
        
        hideAndShowEntryTable(true)
        loadCollView()
        getqualifiedList()
        common.applyShadowToView(customEntryView, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyRoundedShapeToView(customEntryView, withRadius: 5)
        entryTable.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldLabel()
        loadCheckBoxes()
    }
    
    @IBAction func dateIsSelected(_ sender: UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: manufacturePicker.date)
        membershipExpiry.text = dateString        //Calculate age
        def.set(dateString, forKey: "MembershipExpiryDate")
        def.synchronize()
        pickerView.isHidden = true
    }
    
    @objc func pickerTap(_ sender: UITapGestureRecognizer? = nil) {
        if (thisTextField != nil)
        {
            thisTextField.resignFirstResponder()
        }
        pickerView.isHidden = false
    }
    
    private func hideAndShowEntryTable(_ hide: Bool)
    {
        customEntryView.isHidden = hide
        customEntryView.isUserInteractionEnabled = !hide
    }
    
    private func hideAndShowIDVFieldView(_hide hide: Bool)
    {
        var isTPPolicy = true
        var heightOfMainVu = 0.1
        if (!def.bool(forKey: "IsThirdPartyOnly"))
        {
            isTPPolicy = false
            heightOfMainVu = 81
            var heightOfFieldVu = 0.1
            if (!hide)
            {
                heightOfMainVu = 181
                heightOfFieldVu = 100
            }
            else
            {
                customIDV.text = ""
                def.removeObject(forKey: "CustomIDVAmount")
                def.synchronize()
            }
            idvFieldHigh.constant = heightOfFieldVu
            customIDVView.isHidden = hide
            customIDVView.layoutIfNeeded()
        }
        idvViewHigh.constant = heightOfMainVu
        idvView.isHidden = isTPPolicy
        idvView.layoutIfNeeded()
    }
    
    private func placeMyTableViewAround(thisView view: UIView)
    {
        let heightConstraint = NSLayoutConstraint.init(item: entryTablePosition.firstItem as Any, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        entryTablePosition.isActive = false
        entryTablePosition = heightConstraint
        NSLayoutConstraint.activate([entryTablePosition])
        customEntryView.layoutIfNeeded()
    }
    
    private func loadMyData()
    {
        def.removeObject(forKey: "CustomIDVAmount")
        def.removeObject(forKey: "IsVoluntaryExcess")
        def.removeObject(forKey: "IsAntiTheftDevice")
        def.removeObject(forKey: "IsMemberOfAutomobileAssociation")
        def.removeObject(forKey: "IsUseForHandicap")
        def.removeObject(forKey: "IsTPPDRestrictedto6000")
        def.removeObject(forKey: "IsFiberGlassFuelTank")
        def.removeObject(forKey: "IsElectricalAccessories")
        def.removeObject(forKey: "IsNonElectricalAccessories")
        def.removeObject(forKey: "IsBiFuelKit")
        def.removeObject(forKey: "IsPACoverPaidDriver")
        def.removeObject(forKey: "IsPACoverUnnamedPerson")
        def.removeObject(forKey: "IsEmployeeLiability")
        def.removeObject(forKey: "IsLegalLiablityPaidDriver")
        def.synchronize()
    }
    private func showAndHideDiscountView()
    {
        var height = 0.1
        if (!discountViewHidden)
        {
            if (def.bool(forKey: "IsThirdPartyOnly"))
            {
                antiTheftHigh.constant = height
                AAIHigh.constant = height
                handicapHigh.constant = height
                handicapHigh.constant = height
                antiTheftView.isHidden = true
                antiTheftView.isUserInteractionEnabled = false
                def.set(false, forKey: "IsAntiTheftDevice")
                AAIView.isHidden = true
                AAIView.isUserInteractionEnabled = false
                def.set(false, forKey: "IsMemberOfAutomobileAssociation")
                modifyHandicapView.isHidden = true
                modifyHandicapView.isUserInteractionEnabled = false
                def.set(false, forKey: "IsUseForHandicap")
                height = 100
            }
            else
            {
                height = 250
            }
            def.synchronize()
            
            if (def.bool(forKey: "IsVoluntaryExcess"))
            {
                height += 66
            }
            if (def.bool(forKey: "IsMemberOfAutomobileAssociation"))
            {
                height += 200
            }
        }
        discountPlusHigh.constant = height
        discountPlus.isHidden = discountViewHidden
        discountPlus.layoutIfNeeded()
    }
    
    private func showAndHideCoverageView()
    {
        var height = 0.1
        if (!coverageViewHidden)
        {
            if (def.bool(forKey: "IsThirdPartyOnly"))
            {
                electricalAccHigh.constant = height
                fibrglassHigh.constant = height
                (electricalAccHigh.firstItem! as! UIView).isHidden = true
                (electricalAccHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsElectricalAccessories")
                (fibrglassHigh.firstItem! as! UIView).isHidden = true
                (fibrglassHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsFiberGlassFuelTank")
                height = 300
            }
            else if (def.bool(forKey: "IsODOnly"))
            {
                unnamedPersonHigh.constant = height
                noOfLLempHigh.constant = height
                llPaidDriverHigh.constant = height
                (unnamedPersonHigh.firstItem! as! UIView).isHidden = true
                (unnamedPersonHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsPACoverUnnamedPerson")
                (noOfLLempHigh.firstItem! as! UIView).isHidden = true
                (noOfLLempHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsEmployeeLiability")
                (llPaidDriverHigh.firstItem! as! UIView).isHidden = true
                (llPaidDriverHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsLegalLiablityPaidDriver")
                height = 250
            }
            else
            {
                height = 400
            }
            def.synchronize()
            if (def.bool(forKey: "IsElectricalAccessories"))
            {
                height += 66
            }
            if (def.bool(forKey: "IsNonElectricalAccessories"))
            {
                height += 66
            }
            if (def.bool(forKey: "IsBiFuelKit"))
            {
                height += 66
            }
            if (def.bool(forKey: "IsPACoverPaidDriver"))
            {
                height += 66
            }
            if (def.bool(forKey: "IsPACoverUnnamedPerson"))
            {
                height += 66
            }
            if (def.bool(forKey: "IsEmployeeLiability"))
            {
                height += 66
            }
            if (def.bool(forKey: "IsLegalLiablityPaidDriver"))
            {
                height += 66
            }
        }
        coveragePlusHigh.constant = height
        coveragePlus.isHidden = coverageViewHidden
        coveragePlus.layoutIfNeeded()
    }
    
    private func showAndHideAddonView()
    {
        addonPosition.constant = 0
        var height = 0.1
        var heightPlus = 0.1
        var plusHide = true
        if (!def.bool(forKey: "IsThirdPartyOnly"))
        {
            plusHide = false
            addonPosition.constant = 10
            height = 44
            if (!addonViewHidden)
            {
                heightPlus = 250
            }
        }
        addonHigh.constant = height
        addonPlusHigh.constant = heightPlus
        addonPlus.isHidden = addonViewHidden
        addonView.isHidden = plusHide
        addonView.layoutIfNeeded()
        addonPlus.layoutIfNeeded()
    }
    
    @objc private func showDiscount_Coverage_AfddonView(_ sender : UITapGestureRecognizer? = nil)
    {
        let tappedVu = sender?.view
        if (tappedVu!.isDescendant(of: discountView))
        {
            discountViewHidden = !discountViewHidden
            showAndHideDiscountView()
        }
        else if (tappedVu!.isDescendant(of: coverageView))
        {
            coverageViewHidden = !coverageViewHidden
            showAndHideCoverageView()
        }
        else
        {
            addonViewHidden = !addonViewHidden
            showAndHideAddonView()
        }
    }
    
    private func allGseturedAdded()
    {
        let pickerTap = UITapGestureRecognizer(target: self, action: #selector(pickerTap(_:)))
        (membershipExpiry.superview)!.addGestureRecognizer(pickerTap)
        
        let discount_tap = UITapGestureRecognizer.init(target: self, action: #selector(showDiscount_Coverage_AfddonView(_:)))
        let coverage_tap = UITapGestureRecognizer.init(target: self, action: #selector(showDiscount_Coverage_AfddonView(_:)))
        let addon_tap = UITapGestureRecognizer.init(target: self, action: #selector(showDiscount_Coverage_AfddonView(_:)))
        
        discountView.addGestureRecognizer(discount_tap)
        coverageView.addGestureRecognizer(coverage_tap)
        addonView.addGestureRecognizer(addon_tap)
        
        let discount_tap_1 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let discount_tap_2 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let discount_tap_3 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let discount_tap_4 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let discount_tap_5 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        voluntaryExcessView.addGestureRecognizer(discount_tap_1)
        antiTheftView.addGestureRecognizer(discount_tap_2)
        AAIView.addGestureRecognizer(discount_tap_3)
        modifyHandicapView.addGestureRecognizer(discount_tap_4)
        tppdView.addGestureRecognizer(discount_tap_5)
        
        let coverage_tap_1 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_2 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_3 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_4 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_5 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_6 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_7 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_8 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        elecAccView.addGestureRecognizer(coverage_tap_1)
        nonElecAccView.addGestureRecognizer(coverage_tap_2)
        biFuelView.addGestureRecognizer(coverage_tap_3)
        paidDriverView.addGestureRecognizer(coverage_tap_4)
        unnamedPersonView.addGestureRecognizer(coverage_tap_5)
        noOfLLempView.addGestureRecognizer(coverage_tap_6)
        llPaidDriverView.addGestureRecognizer(coverage_tap_7)
        fibreGlassView.addGestureRecognizer(coverage_tap_8)
        
        let addon_tap_2 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let addon_tap_3 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let addon_tap_6 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let addon_tap_7 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let addon_tap_14 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        zeroDepView.addGestureRecognizer(addon_tap_2)
        consumableView.addGestureRecognizer(addon_tap_3)
        engineProtView.addGestureRecognizer(addon_tap_6)
        invoiceView.addGestureRecognizer(addon_tap_7)
        roadSideAssistView.addGestureRecognizer(addon_tap_14)
        
        
        let discountExcTapped = UITapGestureRecognizer.init(target: self, action: #selector(entryTableToBeShown(_:)))
        volExcAmtHigh.firstItem!.addGestureRecognizer(discountExcTapped)
        
        let paCoverPDriverTapp = UITapGestureRecognizer.init(target: self, action: #selector(entryTableToBeShown(_:)))
        paidDriverAmtHigh.firstItem!.addGestureRecognizer(paCoverPDriverTapp)
        
        let paCoverUPersonTapp = UITapGestureRecognizer.init(target: self, action: #selector(entryTableToBeShown(_:)))
        unnamedPersonAmtHigh.firstItem!.addGestureRecognizer(paCoverUPersonTapp)
        let noDriverTapp = UITapGestureRecognizer.init(target: self, action: #selector(entryTableToBeShown(_:)))
        llPaidDriverAmtHigh.firstItem!.addGestureRecognizer(noDriverTapp)
    }
    
    @objc func entryTableToBeShown(_ sender : UITapGestureRecognizer? = nil)
    {
        let selectedVu = sender?.view!
        if (selectedVu!.isDescendant(of: volExcAmtHigh.firstItem! as! UIView))
        {
            texFi = textFi.VolAmt
        }
        else if (selectedVu!.isDescendant(of: unnamedPersonAmtHigh.firstItem! as! UIView))
        {
            texFi = textFi.paUnname
        }
        else if (selectedVu!.isDescendant(of: llPaidDriverAmtHigh.firstItem! as! UIView))
        {
            texFi = textFi.noDriver
        }
        else
        {
            texFi = textFi.paDriver
        }
        placeMyTableViewAround(thisView: selectedVu!)
        hideAndShowEntryTable(false)
        entryTable.reloadData()
    }
    
    private func loadCollView()
    {
        idvCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
    }
    
    private func getqualifiedList()
    {
        let def = common.sharedUserDefaults()
        let vehiclName = def.string(forKey: "MakeName")! + " " + def.string(forKey: "ModelName")! + " " + def.string(forKey: "VariantName")!
        vehicleDetails.text = vehiclName
        vehicleDetailLbl.text = vehiclName.uppercased()
        
        let vYRTO = "Private Car     •  " + def.string(forKey:"RegistrationYear")! + "     •  "+def.string(forKey:"RTOName")!
        VehicleYearRTO.text = vYRTO
        
        self.toatalPlan.text = "Showing 0 of 0 results"
        def.set(addonArray, forKey: "RequestedAddOnList")
        def.synchronize()
        
        declinedListArray = NSMutableArray.init()
        planArray = NSMutableArray.init()
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Processing"
        
        let jsonObject = PostJsonData().createMyDictForPostingData(ToGetQuaotationNumber: false, IfYesThen: "", andDict: NSDictionary.init())
        print(jsonObject)
        
        APICallered().POSTMethodForDataToGet(dataToPass: jsonObject, toURL: qualifyApi+Constant.twowheeler+Constant.qualifyComp) { response in
            let planDict = response?.object(forKey: "Response") as? NSDictionary
            if (planDict != nil)
            {
                self.def.set(planDict?.object(forKey:"QuotationNumber") as! String, forKey: "QuotationNumber")
                self.def.set(planDict?.object(forKey:"PolicyStartDate") as! String, forKey: "PolicyStartDate")
                self.def.set(planDict?.object(forKey:"PolicyEndDate") as! String, forKey: "PolicyEndDate")
                self.def.synchronize()
                
                DispatchQueue.main.async { [self] in
                    let qNo = self.def.string(forKey: "QuotationNumber")
                    self.quotationLabel.text = qNo
                    self.quotationNumberLbl.text = qNo

                    if (!(planDict?.object(forKey:"QualifiedPlanList") is NSNull))
                    {
                        let companyList = planDict?.object(forKey: "QualifiedPlanList") as? NSArray
                        qualifiedCompaanyList(companyList!)
                    }
                    else if (planDict?.object(forKey:"QualifiedPlanList") is NSNull)
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let errorMsg = "There is no qualified plan for this vehicle."
                        let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                        alertVu.showError("Alert!", subTitle: errorMsg, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                        print(planDict?.description as Any)
                        
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let errorMsg = "Something is not right."
                    let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                    alertVu.showError("Alert!", subTitle: errorMsg, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                }
            }
        }
    }
    
    func qualifiedCompaanyList(_ companyList : NSArray)
    {
        var declinePlans : String! = ""
        var i = 0
        while(i < companyList.count)
        {
            let companyDict = companyList[i] as! NSDictionary
            if (i == 0)
            {
                declinePlans = (companyDict.object(forKey: "DeclineDetails") as! String)
            }
            i += 1
            self.loadPlansData(companyDict, i, companyList.count)
        }
        let decArray =  declinePlans.components(separatedBy: "#")
        declinedListArray.addObjects(from: decArray)
        self.planArray.addObjects(from: declinedListArray as! [Any])
    }
    
    override func viewDidLayoutSubviews() {
        let rangeValue : String! = String(self.min_IDV!) + " - " + String(self.max_IDV!)
        minMaxRangeLbl.text = rangeValue
    }
    
    func loadPlansData(_ comapnyDictionary : NSDictionary, _ countVal : Int, _ totalVale: Int)
    {
        let comapnyCode = comapnyDictionary.object(forKey: "CompanyCode") as! String
        let jsonD = PostJsonData().createMyDictForPostingData(ToGetQuaotationNumber: true, IfYesThen: common.sharedUserDefaults().string(forKey:"QuotationNumber")!, andDict: comapnyDictionary)
        APICallered().POSTMethodForDataToGet(dataToPass: jsonD, toURL: self.qualifyApi+Constant.twowheeler+comapnyCode) { response in
            DispatchQueue.main.async {
                
                if (countVal == totalVale)
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                if ((response) != nil)
                {
                    let k = (response?.object(forKey: "Response") as? NSArray)
                    if (k!.count > 0 && k != nil)
                    {
                        let respnseDict = (k?.lastObject as! NSDictionary )
                        let pbd = (respnseDict.object(forKey: "PremiumBreakUpDetails") as! NSDictionary)
                        let np = pbd.object(forKey: "NetPremium") as? CGFloat
                        if (np! > 0.0)
                        {
                            let minDV = respnseDict.object(forKey: "MinInsuredDeclaredValue") as! Int
                            let maxDV = respnseDict.object(forKey: "MaxInsuredDeclaredValue") as! Int
                            if (self.min_IDV == 0)
                            {
                                self.min_IDV = minDV
                            }
                            else
                            {
                                self.min_IDV = min(minDV, self.min_IDV)
                            }
                            if (self.max_IDV == 0)
                            {
                                self.max_IDV = maxDV
                            }
                            else
                            {
                                self.max_IDV = max(maxDV, self.max_IDV)
                            }
                            
                            self.planArray.addObjects(from: (response?.object(forKey: "Response") as? NSArray) as! [Any])
                            let noOfPlans = Int(self.toatalPlan.text!.components(separatedBy: " ")[1])! + 1
                            let planValue : String = "Showing " + String(noOfPlans) + " of "  + String(totalVale) + " results"
                            self.toatalPlan.text = planValue as String
                        }
                        else if (respnseDict.object(forKey: "ErrorMessage") != nil)
                        {
                            let decString = (respnseDict.object(forKey: "CompanyCode") as! String)+"|0|0|0|0|0|0|0|"+(respnseDict.object(forKey: "ErrorMessage") as? String ?? "")
                            self.declinedListArray.add(decString)
                        }
                        else
                        {
                            let decString = (respnseDict.object(forKey: "CompanyCode") as! String)+"|0|0|0|0|0|0|0|"+""
                            self.declinedListArray.add(decString)
                        }
                    }
                }
                self.planTable.reloadData()
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton)
    {
        loadMyData()
        MBProgressHUD.hide(for: self.view, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func recalculateTapped(_ sender: Any)
    {
        if (thisTextField != nil)
        {
            thisTextField.resignFirstResponder()
        }
        
        modifyPlan = false
        modifyViewVisibility.constant = -(self.view.frame.size.width*0.9)
        getqualifiedList()
    }
    
    @IBAction func editBtnTapped(_ sender : UIButton)
    {
        
    }
    
    @IBAction func emailBtnTapped(_ sender : UIButton)
    {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView.tag == 12021)
        {
            if (planArray.count > 0)
            {
                let planDict = planArray[indexPath.row] as? NSDictionary
                if (planDict == nil)
                {
                    return 90
                }
                return 150
            }
        }
        else
        {
            return 30
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.isDescendant(of: planTable))
        {
            if (planArray.count < 1)
            {
                return 0
            }
            return planArray.count
        }
        else
        {
            switch(texFi)
            {
            case .noDriver:
                return driverArray.count
            case .paDriver:
                return paCoverArray.count
            case .paUnname:
                return paCoverArray.count
            case .VolAmt:
                return voluntaryAmtArray.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.isDescendant(of: planTable))
        {
            let planDict = planArray[indexPath.row] as? NSDictionary
            if (planDict != nil)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "planCell") as! GetPlansTableViewCell
                cell.bike_contoller = self
                cell.displayCell(planDict!)
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
                let decString = planArray[indexPath.row] as! String
                let cName = decString.components(separatedBy: "|").first
                let labelString = getLabelForDeclinedPlans(decString)
                let m = Constant.buyAPI+Constant.baseURL+Constant.companylogo+cName!+".png"
                let d = NSData.init(contentsOf: URL(string: m)!)
                cell.displayCellWithImage(labelString, _image: UIImage.init(data: d! as Data)!)
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
            var string : String! = ""
            switch(texFi)
            {
            case .noDriver:
                string = driverArray[indexPath.row]
                break
            case .paDriver:
                string = paCoverArray[indexPath.row]
                break
            case .paUnname:
                string = paCoverArray[indexPath.row]
                break
            case .VolAmt:
                string = voluntaryAmtArray[indexPath.row]
                break
            }
            cell.setDispaly(string)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isDescendant(of: entryTable))
        {
            switch(texFi)
            {
            case .noDriver:
                let string = driverArray[indexPath.row]
                noOFDrivers.text = string
                break
            case .paDriver:
                let string = paCoverArray[indexPath.row]
                paidDriverSum.text = string
                break
            case .paUnname:
                let string = paCoverArray[indexPath.row]
                unnamedPersonSum.text = string
                break
            case .VolAmt:
                //100101
                let string = voluntaryAmtArray[indexPath.row]
                VoluntryExcAmt.text = string
                break
            }
            hideAndShowEntryTable(true)
        }
    }
    
    @IBAction func modifyQuoteTapped(_ sender: UIButton) {
        modifyViewVisibility.constant=0
    }
    
    @IBAction func closeModifyTapped(_ sender: UIButton) {
        if (thisTextField != nil)
        {
            thisTextField.resignFirstResponder()
        }
        modifyViewVisibility.constant = -(self.view.frame.size.width*0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView.tag == 100001)
        {
            return idvCollArray.count
        }
        return Common.yesNoBtnArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        let collTag = collectionView.tag
        if (collectionView.tag == 100001)
        {
            cell.setDataForNormal(idvCollArray[indexPath.row], ofFontSize: 14)
            cell.titleLbl.numberOfLines = 0
        }
        else
        {
            cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 12)
        }
        
        switch (collTag)
        {
        case 100001:
            if (idvTapped == indexPath.row)
            {
                cell.setSelectedData()
                let k = Bool(truncating: indexPath.row as NSNumber)
                hideAndShowIDVFieldView(_hide: !k)
            }
            break//idvCollection
        default :
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        modifyPlan = true
        let collTag = collectionView.tag
        switch (collTag)
        {
        case 100001:
            idvTapped = indexPath.row
            break//idvCollection
        default :
            break
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = common.getScreenSize(collectionView)
        let CellHeight = widthAndHeight.1*0.7
        var CellWidth = 0.0
        if (collectionView.tag == 100001)
        {
            CellWidth = widthAndHeight.0*0.45
        }
        else
        {
            CellWidth = 50
        }
        let sizes: CGSize = CGSize.init(width: CellWidth, height: CellHeight)
        return sizes;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10);
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if (!keyboardIsOpen)
            {
                keyboardIsOpen = true
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyboardView.constant = -keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabel()
        keyboardIsOpen = false
        keyboardView.constant = 0
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        textFieldLabel()
        thisTextField = textField
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        let tagValue = textField.tag
        
        switch(tagValue)
        {
        case 10001111111:
            common.setTextFieldLabels(customIDV, customIDVLbl, false, "")
            break
        case 100101: //lbl, field
            common.setTextFieldLabels(VoluntryExcAmt, volExcLbl, false, "")
            break
        case 100102:
            common.setTextFieldLabels(associationName, associationLbl, false, "")
            break
        case 100103:
            common.setTextFieldLabels(membershipNumber, membershipLbl, false, "")
            break
        case 100104:
            common.setTextFieldLabels(membershipExpiry, memberShipExpLbl, false, "")
        default:
            break
        }
        return true
    }
    
    private func textFieldLabel()
    {
        setLabelFieldMutualVisibility(customIDV, customIDVLbl)
        setLabelFieldMutualVisibility(VoluntryExcAmt, volExcLbl)
        setLabelFieldMutualVisibility(associationName, associationLbl)
        setLabelFieldMutualVisibility(membershipNumber, membershipLbl)
        setLabelFieldMutualVisibility(membershipExpiry, memberShipExpLbl)
        
        common.applyRoundedShapeToView(VoluntryExcAmt, withRadius: 5.0)
        common.applyBorderToView(VoluntryExcAmt, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyRoundedShapeToView(associationName, withRadius: 5.0)
        common.applyBorderToView(associationName, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyRoundedShapeToView(membershipNumber, withRadius: 5.0)
        common.applyBorderToView(membershipNumber, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyRoundedShapeToView(membershipExpiry, withRadius: 5.0)
        common.applyBorderToView(membershipExpiry, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyRoundedShapeToView(customIDV, withRadius: 5.0)
        common.applyBorderToView(customIDV, withColor: Colors.textFldColor, ofSize: 1)
        common.applyRoundedShapeToView(elecAccAmt, withRadius: 5.0)
        common.applyBorderToView(elecAccAmt, withColor: Colors.textFldColor, ofSize: 1)
        common.applyRoundedShapeToView(nonElecAccAmt, withRadius: 5.0)
        common.applyBorderToView(nonElecAccAmt, withColor: Colors.textFldColor, ofSize: 1)
        common.applyRoundedShapeToView(biFuelAmt, withRadius: 5.0)
        common.applyBorderToView(biFuelAmt, withColor: Colors.textFldColor, ofSize: 1)
        common.applyRoundedShapeToView(paidDriverSum, withRadius: 5.0)
        common.applyBorderToView(paidDriverSum, withColor: Colors.textFldColor, ofSize: 1)
        common.applyRoundedShapeToView(unnamedPersonSum, withRadius: 5.0)
        common.applyBorderToView(unnamedPersonSum, withColor: Colors.textFldColor, ofSize: 1)
        common.applyRoundedShapeToView(noOfLLEmp, withRadius: 5.0)
        common.applyBorderToView(noOfLLEmp, withColor: Colors.textFldColor, ofSize: 1)
        common.applyRoundedShapeToView(noOFDrivers, withRadius: 5.0)
        common.applyBorderToView(noOFDrivers, withColor: Colors.textFldColor, ofSize: 1)
    }
    
    private func loadCheckBoxes()
    {
        loadCheckBoxViews(voluntaryExcessView, isSelected: def.bool(forKey: "IsVoluntaryExcess"))
        loadCheckBoxViews(antiTheftView, isSelected: def.bool(forKey: "IsAntiTheftDevice"))
        loadCheckBoxViews(AAIView, isSelected: def.bool(forKey: "IsMemberOfAutomobileAssociation"))
        loadCheckBoxViews(modifyHandicapView, isSelected: def.bool(forKey: "IsUseForHandicap"))
        loadCheckBoxViews(tppdView, isSelected: def.bool(forKey: "IsTPPDRestrictedto6000"))
        loadCheckBoxViews(elecAccView, isSelected: def.bool(forKey: "IsElectricalAccessories"))
        loadCheckBoxViews(nonElecAccView, isSelected: def.bool(forKey: "IsNonElectricalAccessories"))
        loadCheckBoxViews(elecAccView, isSelected: def.bool(forKey: "IsNonElectricalAccessories"))
        loadCheckBoxViews(biFuelView, isSelected: def.bool(forKey: "IsBiFuelKit"))
        loadCheckBoxViews(paidDriverView, isSelected: def.bool(forKey: "IsPACoverPaidDriver"))
        loadCheckBoxViews(unnamedPersonView, isSelected: def.bool(forKey: "IsPACoverUnnamedPerson"))
        loadCheckBoxViews(noOfLLempView, isSelected: def.bool(forKey: "IsEmployeeLiability"))
        loadCheckBoxViews(llPaidDriverView, isSelected: def.bool(forKey: "IsLegalLiablityPaidDriver"))
        loadCheckBoxViews(fibreGlassView, isSelected: def.bool(forKey: "IsFiberGlassFuelTank"))
        loadCheckBoxViews(zeroDepView, isSelected: def.bool(forKey: "IsZeroDepreciation"))
        loadCheckBoxViews(consumableView, isSelected: def.bool(forKey: "IsConsumables"))
        loadCheckBoxViews(engineProtView, isSelected: def.bool(forKey: "IsEngineProtector"))
        loadCheckBoxViews(invoiceView, isSelected: def.bool(forKey: "IsReturnToInvoice"))
        loadCheckBoxViews(roadSideAssistView, isSelected: def.bool(forKey: "IsRoadSideAssistance"))
        
    }
    
    private func setLabelFieldMutualVisibility(_ field: UITextField,_ lbl: UILabel)
    {
        if (field.hasText)
        {
            lbl.isHidden = false
        }
        else
        {
            lbl.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        var currentString: NSString = textField.text! as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 100101:
            def.set(textField.text!, forKey: "VoluntaryExcessAmount")
            break
        case 100102:
            def.set(textField.text!, forKey: "AssociationName")
            break
        case 100103:
            def.set(textField.text!, forKey: "MembershipNumber")
            break
        case 100104:
            def.set(textField.text!, forKey: "MembershipExpiryDate")
            break
        case 100105:
            def.set(textField.text!, forKey: "ElectricalAccessoryAmount")
            break
        case 100106:
            def.set(textField.text!, forKey: "NonElectricalAccessoryAmount")
            break
        case 100107:
            def.set(textField.text!, forKey: "BiFuelKitValue")
            break
        case 100108:
            def.set(textField.text!, forKey: "PaidDriverSumInsured")
            break
        case 100109:
            def.set(textField.text!, forKey: "UnNamedSumInsured")
            break
        case 100110:
            def.set(textField.text!, forKey: "NoOfLegalLiablityEmployee")
            break
        case 10001111111:
            var enteredValue = Int( textField.text!)
            if (enteredValue == nil)
            {
                enteredValue = 0
            }
            minMaxRangeLbl.textColor = common.hexStringToUIColor(hex: "#242B63")
            if ((enteredValue! >= min_IDV) && (enteredValue! <= max_IDV))
            {
                def.set(enteredValue!, forKey: "CustomIDVAmount")
            }
            else
            {
                minMaxRangeLbl.textColor = .red
            }
            break
        default:
            def.set(textField.text!, forKey: "NoOfLLPaidDriver")
            break
        }
        def.synchronize()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldLabel()
        textField.resignFirstResponder()
        return true
    }
    
    private func loadCheckBoxViews(_ selectedVu : UIView, isSelected select: Bool)
    {
        let firstVu = selectedVu.subviews.first!
        common.applyBorderToView(firstVu, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 1)
        checkBoxSelected(selectedVu, _isSelected: select)
    }
    
    @objc private func showCheckAndUncheck(_ sender: UITapGestureRecognizer? = nil) {
        if (thisTextField != nil)
        {
            thisTextField.resignFirstResponder()
        }
        let selectedVu = sender?.view
        var isCheck = false
        let firstVu = selectedVu!.subviews.first!
        let chkBoxVu = firstVu.subviews.last
        if (!chkBoxVu!.isHidden)
        {
            isCheck = false
            chkBoxVu!.isHidden = true
            setValueForTextfiled(selectedVu!)
            hideAndShowEntryTable(true)
        }
        else
        {
            isCheck = true
            chkBoxVu!.isHidden = false
        }
        checkBoxSelected(selectedVu!, _isSelected: isCheck)
    }
    
    private func setValueForTextfiled(_ selectedView : UIView)
    {
        if (selectedView.isDescendant(of: voluntaryExcessView))
        {
            VoluntryExcAmt.text = ""
        }
        else if (selectedView.isDescendant(of: AAIView))
        {
            membershipNumber.text = ""
            membershipExpiry.text = ""
            associationName.text = ""
        }
        else if (selectedView.isDescendant(of: elecAccView))
        {
            elecAccAmt.text = ""
        }
        else if (selectedView.isDescendant(of: nonElecAccView))
        {
            nonElecAccAmt.text = ""
        }
        else if (selectedView.isDescendant(of: biFuelView))
        {
            biFuelAmt.text = ""
        }
        else if (selectedView.isDescendant(of: paidDriverView))
        {
            paidDriverSum.text = ""
        }
        else if (selectedView.isDescendant(of: unnamedPersonView))
        {
            unnamedPersonSum.text = ""
        }
        else if (selectedView.isDescendant(of: noOfLLempView))
        {
            noOfLLEmp.text = ""
        }
        else if (selectedView.isDescendant(of: llPaidDriverView))
        {
            noOFDrivers.text = ""
        }
    }
    
    private func checkBoxSelected(_ selectedVu : UIView, _isSelected isCheck : Bool)
    {
        let viewTag = selectedVu.tag
        switch (viewTag)
        {
        case 100002:
            var volExcHigh = 50.0
            var VolExcFldHigh = 0.1
            def.set(isCheck, forKey: "IsVoluntaryExcess")
            if (isCheck)
            {
                volExcHigh = 116
                VolExcFldHigh = 66
            }
            voluntaryExcessHigh.constant = volExcHigh
            volExcAmtHigh.constant = VolExcFldHigh
            let hideView = volExcAmtHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideDiscountView()
            break
        case 100003:
            def.set(isCheck, forKey: "IsAntiTheftDevice")
            showAndHideDiscountView()
            break
        case 100004:
            var aaiHigh = 50.0
            var aaiMembHigh = 0.1
            def.set(isCheck, forKey: "IsMemberOfAutomobileAssociation")
            if (isCheck)
            {
                aaiHigh = 250
                aaiMembHigh = 218
            }
            AAIHigh.constant = aaiHigh
            AAIMembersHigh.constant = aaiMembHigh
            let hideView = AAIMembersHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideDiscountView()
            break
        case 100005:
            def.set(isCheck, forKey: "IsUseForHandicap")
            showAndHideDiscountView()
            break
        case 100006:
            def.set(isCheck, forKey: "IsTPPDRestrictedto6000")
            showAndHideDiscountView()
            break
        case 100007:
            def.set(isCheck, forKey: "IsElectricalAccessories")
            var elAccHigh = 50.0
            var elAccFldHigh = 0.1
            if (isCheck)
            {
                elAccHigh = 116
                elAccFldHigh = 66
            }
            electricalAccHigh.constant = elAccHigh
            elecAmtHigh.constant = elAccFldHigh
            let hideView = elecAmtHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideCoverageView()
            break
        case 100008:
            var nonElAccHigh = 50.0
            var nonElAccFldHigh = 0.1
            def.set(isCheck, forKey: "IsNonElectricalAccessories")
            if (isCheck)
            {
                nonElAccHigh = 116
                nonElAccFldHigh = 66
            }
            nonElectricalAccHigh.constant = nonElAccHigh
            nonElecAmtHigh.constant = nonElAccFldHigh
            let hideView = nonElecAmtHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideCoverageView()
            break
        case 100009:
            var biFuelVHigh = 50.0
            var biFuelVFldHigh = 0.1
            def.set(isCheck, forKey: "IsBiFuelKit")
            if (isCheck)
            {
                biFuelVHigh = 116
                biFuelVFldHigh = 66
            }
            
            biFuelHigh.constant = biFuelVHigh
            biFuelAmtHigh.constant = biFuelVFldHigh
            let hideView = biFuelAmtHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideCoverageView()
            break
        case 100010:
            def.set(isCheck, forKey: "IsPACoverPaidDriver")
            var elAccHigh = 50.0
            var elAccFldHigh = 0.1
            if (isCheck)
            {
                elAccHigh = 116
                elAccFldHigh = 66
            }
            paidDriverHigh.constant = elAccHigh
            paidDriverAmtHigh.constant = elAccFldHigh
            let hideView = paidDriverAmtHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideCoverageView()
            break
        case 100011:
            def.set(isCheck, forKey: "IsPACoverUnnamedPerson")
            var elAccHigh = 50.0
            var elAccFldHigh = 0.1
            if (isCheck)
            {
                elAccHigh = 116
                elAccFldHigh = 66
            }
            unnamedPersonHigh.constant = elAccHigh
            unnamedPersonAmtHigh.constant = elAccFldHigh
            let hideView = unnamedPersonAmtHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideCoverageView()
            break
        case 100012:
            def.set(isCheck, forKey: "IsEmployeeLiability")
            var elAccHigh = 50.0
            var elAccFldHigh = 0.1
            if (isCheck)
            {
                elAccHigh = 116
                elAccFldHigh = 66
            }
            noOfLLempHigh.constant = elAccHigh
            noOfLLempAmtHigh.constant = elAccFldHigh
            let hideView = noOfLLempAmtHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideCoverageView()
            break
        case 100013:
            def.set(isCheck, forKey: "IsLegalLiablityPaidDriver")
            var elAccHigh = 50.0
            var elAccFldHigh = 0.1
            if (isCheck)
            {
                elAccHigh = 116
                elAccFldHigh = 66
            }
            llPaidDriverHigh.constant = elAccHigh
            llPaidDriverAmtHigh.constant = elAccFldHigh
            let hideView = llPaidDriverAmtHigh.firstItem as! UIView
            hideView.isHidden = !isCheck
            selectedVu.superview!.layoutIfNeeded()
            showAndHideCoverageView()
            break
        case 100014:
            def.set(isCheck, forKey: "IsFiberGlassFuelTank")
            break
        case 100016:
            if (addonArray == nil)
            {
                addonArray = NSMutableArray.init()
            }
            if (addonListArray != nil)
            {
                var i : Int = 0
                while(i < addonListArray!.count)
                {
                    let aDict = addonListArray![i] as! NSDictionary
                    if ((aDict.object(forKey: "Name") as! String).elementsEqual("Zero Depreciation Cover"))
                    {
                        if (isCheck)
                        {
                            addonArray.add((aDict.object(forKey: "Id") as? String)!)
                        }
                        else if (addonArray.contains((aDict.object(forKey: "Id") as? String)!))
                        {
                            addonArray.remove((aDict.object(forKey: "Id") as? String)!)
                        }
                    }
                    i += 1
                }
            }
            //                def.set(isCheck, forKey: "IsZeroDepreciation")
            break
        case 100017:
            if (addonArray == nil)
            {
                addonArray = NSMutableArray.init()
            }
            if (addonListArray != nil)
            {
                var i : Int = 0
                while(i < addonListArray!.count)
                {
                    let aDict = addonListArray![i] as! NSDictionary
                    if ((aDict.object(forKey: "Name") as! String).elementsEqual("Consumables"))
                    {
                        if (isCheck)
                        {
                            addonArray.add((aDict.object(forKey: "Id") as? String)!)
                        }
                        else if (addonArray.contains((aDict.object(forKey: "Id") as? String)!))
                        {
                            addonArray.remove((aDict.object(forKey: "Id") as? String)!)
                        }
                    }
                    i += 1
                }
            }
            //                def.set(isCheck, forKey: "IsConsumables")
            break
        case 100020:
            if (addonArray == nil)
            {
                addonArray = NSMutableArray.init()
            }
            if (addonListArray != nil)
            {
                var i : Int = 0
                while(i < addonListArray!.count)
                {
                    let aDict = addonListArray![i] as! NSDictionary
                    if ((aDict.object(forKey: "Name") as! String).elementsEqual("Engine Protector"))
                    {
                        if (isCheck)
                        {
                            addonArray.add((aDict.object(forKey: "Id") as? String)!)
                        }
                        else if (addonArray.contains((aDict.object(forKey: "Id") as? String)!))
                        {
                            addonArray.remove((aDict.object(forKey: "Id") as? String)!)
                        }
                    }
                    i += 1
                }
            }
            //                def.set(isCheck, forKey: "IsEngineProtector")
            break
        case 100021:
            if (addonArray == nil)
            {
                addonArray = NSMutableArray.init()
            }
            if (addonListArray != nil)
            {
                var i : Int = 0
                while(i < addonListArray!.count)
                {
                    let aDict = addonListArray![i] as! NSDictionary
                    if ((aDict.object(forKey: "Name") as! String).elementsEqual("Return to Invoice"))
                    {
                        if (isCheck)
                        {
                            addonArray.add((aDict.object(forKey: "Id") as? String)!)
                        }
                        else if (addonArray.contains((aDict.object(forKey: "Id") as? String)!))
                        {
                            addonArray.remove((aDict.object(forKey: "Id") as? String)!)
                        }
                    }
                    i += 1
                }
            }
            //                def.set(isCheck, forKey: "IsReturnToInvoice")
            break
        case 100028:
            if (addonArray == nil)
            {
                addonArray = NSMutableArray.init()
            }
            if (addonListArray != nil)
            {
                var i : Int = 0
                while(i < addonListArray!.count)
                {
                    let aDict = addonListArray![i] as! NSDictionary
                    if ((aDict.object(forKey: "Name") as! String).elementsEqual("Road Side Assistance"))
                    {
                        if (isCheck)
                        {
                            addonArray.add((aDict.object(forKey: "Id") as? String)!)
                        }
                        else if (addonArray.contains((aDict.object(forKey: "Id") as? String)!))
                        {
                            addonArray.remove((aDict.object(forKey: "Id") as? String)!)
                        }
                    }
                    i += 1
                }
            }
            
            //                def.set(isCheck, forKey: "IsRoadSideAssistance")
            break
        default :
            break
        }
        def.synchronize()
    }
    
    private func getLabelForDeclinedPlans(_ decString : String) -> String
    {
        var labelString : String! = ""
        let declineArr = decString.components(separatedBy: "|")
        
        if (!declineArr[1].isEmpty)
        {
            let IsMMVDecline : Bool = Bool.init(truncating: Int(declineArr[1])! as NSNumber)
            let IsPlanDisable : Bool = Bool.init(truncating: Int(declineArr[2])! as NSNumber)
            let IsMMVMapped : Bool = Bool.init(truncating: Int(declineArr[3])! as NSNumber)
            let IsRTOMapped : Bool = Bool.init(truncating: Int(declineArr[4])! as NSNumber)
            let IsAddonAllowed : Bool = Bool.init(truncating: Int(declineArr[5])! as NSNumber)
            let IsBreakinAllowed : Bool = Bool.init(truncating: Int(declineArr[6])! as NSNumber)
            let IsVehcileAgeExceed : Bool = Bool.init(truncating: Int(declineArr[7])! as NSNumber)
            
            if (IsPlanDisable)
            {
                labelString = "Plan is not active."
            }
            else if (IsRTOMapped)
            {
                if (IsMMVMapped)
                {
                    if (IsMMVDecline)
                    {
                        labelString = "Declined at our end."
                    }
                    else
                    {
                        if (IsAddonAllowed)
                        {
                            if (IsBreakinAllowed)
                            {
                                labelString = "Break-In is not allowed."
                            }
                            else
                            {
                                labelString = "Addon is not allowed."
                            }
                        }
                        else
                        {
                            labelString = "MMV is not mapped."
                        }
                    }
                }
                else
                {
                    labelString = "RTO is not mapped."
                }
            }
            if (IsVehcileAgeExceed)
            {
                labelString = "Vehicle age is exceed."
            }
            if (declineArr.count > 8)
            {
                labelString = declineArr[8]
            }
        }
        return labelString
    }
}
