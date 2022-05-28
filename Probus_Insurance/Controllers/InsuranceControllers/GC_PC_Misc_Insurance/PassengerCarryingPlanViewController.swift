//
//  PassengerCarryingPlanViewController.swift
//  Probus_Insurance
//
//  Created by Sankalp on 05/05/22.
//

import Foundation
import UIKit
import MBProgressHUD

class PassengerCarryingPlanViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIScrollViewDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var emailQuote: UIButton!
    
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
    
    @IBOutlet weak var elecAccAmt: UITextField!//100105
    @IBOutlet weak var nonElecAccAmt: UITextField!//100106
    @IBOutlet weak var biFuelAmt: UITextField!//100107
    @IBOutlet weak var paidDriverSum: UITextField!//100108
    @IBOutlet weak var unnamedPersonSum: UITextField!//100109
    @IBOutlet weak var noOfLLEmp: UITextField!//100110
    @IBOutlet weak var noOFDrivers: UITextField!//100111
    @IBOutlet weak var fppSum: UITextField!//100112
    @IBOutlet weak var nfppSum: UITextField!//100113

    @IBOutlet weak var antiTheftView: UIView!
    @IBOutlet weak var antiTheftHigh: NSLayoutConstraint!
    
    
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

    @IBOutlet weak var fppHigh: NSLayoutConstraint!
    @IBOutlet weak var fppView: UIView!
    @IBOutlet weak var fppAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var nfppHigh: NSLayoutConstraint!
    @IBOutlet weak var nfppView: UIView!
    @IBOutlet weak var nfppAmtHigh: NSLayoutConstraint!
    
    @IBOutlet weak var fibreGlassView: UIView!
    @IBOutlet weak var fibrglassHigh: NSLayoutConstraint!
        
    @IBOutlet weak var keyboardView : NSLayoutConstraint!
        
    @IBOutlet weak var customEntryView: UIView!
    @IBOutlet weak var entryTable: UITableView!
    @IBOutlet weak var entryTablePosition: NSLayoutConstraint!
    
    enum textFi {
        case paDriver
        case paUnname
        case noDriver
    }
    private var texFi = textFi.paDriver
    
    private let voluntaryAmtArray = ["2500", "5000", "7500", "15000"]
    private let paCoverArray = ["10000", "20000", "30000", "40000", "50000", "60000", "70000", "80000", "90000", "100000", "110000", "120000", "130000", "140000", "150000", "160000", "170000", "180000", "190000", "200000"]
    private let driverArray = ["1", "2"]
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
    private var vehicle_type : String!
    
    var modifyPlan : Bool! = false
    private let qualifyApi = Common.sharedCommon.A_P_I+Common.sharedCommon.baseURL+Common.sharedCommon.forApi+Common.sharedCommon.motor
    
    override func viewDidLoad() {
        
        switch(def.integer(forKey: "ProductCode"))
        {
        case 10:
            vehicle_type = common.goodCommercial
            break
        case 9:
            vehicle_type = common.passengerCommercial
            break
        default:
            vehicle_type = common.miscCommercial
            break
        }
        
        loadMyData()
        
        common.addDoneButtonOnNumpad(textField: customIDV)
        common.addDoneButtonOnNumpad(textField: elecAccAmt)
        common.addDoneButtonOnNumpad(textField: nonElecAccAmt)
        common.addDoneButtonOnNumpad(textField: biFuelAmt)
        common.addDoneButtonOnNumpad(textField: noOfLLEmp)
        common.addDoneButtonOnNumpad(textField: fppSum)
        common.addDoneButtonOnNumpad(textField: nfppSum)
        common.applyRoundedShapeToView(emailQuote, withRadius: 5)
        common.applyRoundedShapeToView(modifyQuotes, withRadius: 10)
        common.applyShadowToView(modifyView, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyBorderToView(emailQuote, withColor: common.hexStringToUIColor(hex: "#53C0D4"), ofSize: 1)
        modifyViewVisibility.constant = -(self.view.frame.size.width*0.9)
        planTable.register(UINib.init(nibName: "GetPlansTableViewCell", bundle: nil), forCellReuseIdentifier: "planCell")
        planTable.register(UINib.init(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        
        allGseturedAdded()
        showAndHideDiscountView()
        showAndHideCoverageView()
        
        hideAndShowEntryTable(true)
        textFieldLabel()
        loadCollView()
        getqualifiedList()
        common.applyShadowToView(customEntryView, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyRoundedShapeToView(customEntryView, withRadius: 5)
        entryTable.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
    }
    
    private func hideAndShowEntryTable(_ hide: Bool)
    {
        customEntryView.isHidden = hide
        customEntryView.isUserInteractionEnabled = !hide
    }
    
    private func hideAndShowIDVFieldView(_hide hide: Bool)
    {
        var isTPPolicy = true
        var heightOfMainVu = 0.0000000000000001
        if (!def.bool(forKey: "IsThirdPartyOnly"))
        {
            isTPPolicy = false
            heightOfMainVu = 0.15
            var heightOfFieldVu = 0.0000000000000001
            if (!hide)
            {
                heightOfMainVu = 0.3
                heightOfFieldVu = 0.15
            }
            else
            {
                customIDV.text = ""
                def.removeObject(forKey: "CustomIDVAmount")
                def.synchronize()
            }
            let highField = NSLayoutConstraint.init(item: idvFieldHigh.firstItem as Any, attribute: idvFieldHigh.firstAttribute, relatedBy: idvFieldHigh.relation, toItem: idvFieldHigh.secondItem, attribute: idvFieldHigh.secondAttribute, multiplier: heightOfFieldVu, constant: idvFieldHigh.constant)
            idvFieldHigh.isActive = false
            idvFieldHigh = highField
            NSLayoutConstraint.activate([idvFieldHigh])
            customIDVView.isHidden = hide
            customIDVView.layoutIfNeeded()
        }
        let highMain = NSLayoutConstraint.init(item: idvViewHigh.firstItem as Any, attribute: idvViewHigh.firstAttribute, relatedBy: idvViewHigh.relation, toItem: idvViewHigh.secondItem, attribute: idvViewHigh.secondAttribute, multiplier: heightOfMainVu, constant: idvViewHigh.constant)
        idvViewHigh.isActive = false
        idvViewHigh = highMain
        NSLayoutConstraint.activate([idvViewHigh])
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
        def.removeObject(forKey: "IsNoOfFPP")
        def.removeObject(forKey: "IsNoOfNFPP")
        def.synchronize()
    }
    private func showAndHideDiscountView()
    {
        var height = 0.0000000000000001
        if (!discountViewHidden)
        {
            if (def.bool(forKey: "IsThirdPartyOnly"))
            {
                let anti = NSLayoutConstraint.init(item: antiTheftHigh.firstItem as Any, attribute: antiTheftHigh.firstAttribute, relatedBy: antiTheftHigh.relation, toItem: antiTheftHigh.secondItem, attribute: antiTheftHigh.secondAttribute, multiplier: height, constant: antiTheftHigh.constant)
                antiTheftHigh.isActive = false
                antiTheftHigh = anti
                antiTheftView.isHidden = true
                antiTheftView.isUserInteractionEnabled = false
                def.set(false, forKey: "IsAntiTheftDevice")
                NSLayoutConstraint.activate([antiTheftHigh])
                height = 0.08
            }
            else
            {
                height = 0.16
            }
            def.synchronize()
        }
        let high = NSLayoutConstraint.init(item: discountPlusHigh.firstItem as Any, attribute: discountPlusHigh.firstAttribute, relatedBy: discountPlusHigh.relation, toItem: discountPlusHigh.secondItem, attribute: discountPlusHigh.secondAttribute, multiplier: height, constant: discountPlusHigh.constant)
        discountPlusHigh.isActive = false
        discountPlusHigh = high
        NSLayoutConstraint.activate([discountPlusHigh])
        discountPlus.isHidden = discountViewHidden
        discountPlus.layoutIfNeeded()
    }
    
    private func showAndHideCoverageView()
    {
        var height = 0.0000000000000001
        if (!coverageViewHidden)
        {
            if (def.bool(forKey: "IsThirdPartyOnly"))
            {
                let eleH = NSLayoutConstraint.init(item: electricalAccHigh.firstItem as Any, attribute: electricalAccHigh.firstAttribute, relatedBy: electricalAccHigh.relation, toItem: electricalAccHigh.secondItem, attribute: electricalAccHigh.secondAttribute, multiplier: height, constant: electricalAccHigh.constant)
                electricalAccHigh.isActive = false
                electricalAccHigh = eleH
                (electricalAccHigh.firstItem! as! UIView).isHidden = true
                (electricalAccHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsElectricalAccessories")
                let noneleH = NSLayoutConstraint.init(item: nonElectricalAccHigh.firstItem as Any, attribute: nonElectricalAccHigh.firstAttribute, relatedBy: nonElectricalAccHigh.relation, toItem: nonElectricalAccHigh.secondItem, attribute: nonElectricalAccHigh.secondAttribute, multiplier: height, constant: nonElectricalAccHigh.constant)
                nonElectricalAccHigh.isActive = false
                nonElectricalAccHigh = noneleH
                (nonElectricalAccHigh.firstItem! as! UIView).isHidden = true
                (nonElectricalAccHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsNonElectricalAccessories")
                let fibreH = NSLayoutConstraint.init(item: fibrglassHigh.firstItem as Any, attribute: fibrglassHigh.firstAttribute, relatedBy: fibrglassHigh.relation, toItem: fibrglassHigh.secondItem, attribute: fibrglassHigh.secondAttribute, multiplier: height, constant: fibrglassHigh.constant)
                fibrglassHigh.isActive = false
                fibrglassHigh = fibreH
                (fibrglassHigh.firstItem! as! UIView).isHidden = true
                (fibrglassHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsFiberGlassFuelTank")
                let fppH = NSLayoutConstraint.init(item: fppHigh.firstItem as Any, attribute: fppHigh.firstAttribute, relatedBy: fppHigh.relation, toItem: fppHigh.secondItem, attribute: fppHigh.secondAttribute, multiplier: height, constant: fppHigh.constant)
                fppHigh.isActive = false
                fppHigh = fppH
                (fppHigh.firstItem! as! UIView).isHidden = true
                (fppHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsNoOfFPP")
                let nfppH = NSLayoutConstraint.init(item: nfppHigh.firstItem as Any, attribute: nfppHigh.firstAttribute, relatedBy: nfppHigh.relation, toItem: nfppHigh.secondItem, attribute: nfppHigh.secondAttribute, multiplier: height, constant: nfppHigh.constant)
                nfppHigh.isActive = false
                nfppHigh = nfppH
                (nfppHigh.firstItem! as! UIView).isHidden = true
                (nfppHigh.firstItem! as! UIView).isUserInteractionEnabled = false
                def.set(false, forKey: "IsNoOfNFPP")
                NSLayoutConstraint.activate([electricalAccHigh, fibrglassHigh, nonElectricalAccHigh, fppHigh, nfppHigh])
                def.synchronize()
                height = 0.4
            }
            else
            {
                height = 0.8
            }
            if (def.bool(forKey: "IsElectricalAccessories"))
            {
                height += 0.1
            }
            if (def.bool(forKey: "IsNonElectricalAccessories"))
            {
                height += 0.1
            }
            if (def.bool(forKey: "IsBiFuelKit"))
            {
                height += 0.1
            }
            if (def.bool(forKey: "IsPACoverPaidDriver"))
            {
                height += 0.1
            }
            if (def.bool(forKey: "IsPACoverUnnamedPerson"))
            {
                height += 0.1
            }
            if (def.bool(forKey: "IsEmployeeLiability"))
            {
                height += 0.1
            }
            if (def.bool(forKey: "IsLegalLiablityPaidDriver"))
            {
                height += 0.1
            }
            if (def.bool(forKey: "IsNoOfFPP"))
            {
                height += 0.1
            }
            if (def.bool(forKey: "IsNoOfNFPP"))
            {
                height += 0.1
            }
        }
        let high = NSLayoutConstraint.init(item: coveragePlusHigh.firstItem as Any, attribute: coveragePlusHigh.firstAttribute, relatedBy: coveragePlusHigh.relation, toItem: coveragePlusHigh.secondItem, attribute: coveragePlusHigh.secondAttribute, multiplier: height, constant: coveragePlusHigh.constant)
        coveragePlusHigh.isActive = false
        coveragePlusHigh = high
        NSLayoutConstraint.activate([coveragePlusHigh])
        coveragePlus.isHidden = coverageViewHidden
        coveragePlus.layoutIfNeeded()
    }
    

    @objc private func showDiscount_Coverage_AfddonView(_ sender : UITapGestureRecognizer? = nil)
    {
        let tappedVu = sender?.view
        if (tappedVu!.isDescendant(of: discountView))
        {
            discountViewHidden = !discountViewHidden
            showAndHideDiscountView()
        }
        else
        {
            coverageViewHidden = !coverageViewHidden
            showAndHideCoverageView()
        }
    }
    
    private func allGseturedAdded()
    {
        let discount_tap = UITapGestureRecognizer.init(target: self, action: #selector(showDiscount_Coverage_AfddonView(_:)))
        let coverage_tap = UITapGestureRecognizer.init(target: self, action: #selector(showDiscount_Coverage_AfddonView(_:)))
        
        discountView.addGestureRecognizer(discount_tap)
        coverageView.addGestureRecognizer(coverage_tap)
        
        let discount_tap_2 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let discount_tap_5 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        antiTheftView.addGestureRecognizer(discount_tap_2)
        tppdView.addGestureRecognizer(discount_tap_5)
        
        let coverage_tap_1 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_2 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_3 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_4 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_5 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_6 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_7 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_8 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_9 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        let coverage_tap_10 = UITapGestureRecognizer.init(target: self, action: #selector(showCheckAndUncheck(_:)))
        elecAccView.addGestureRecognizer(coverage_tap_1)
        nonElecAccView.addGestureRecognizer(coverage_tap_2)
        biFuelView.addGestureRecognizer(coverage_tap_3)
        paidDriverView.addGestureRecognizer(coverage_tap_4)
        unnamedPersonView.addGestureRecognizer(coverage_tap_5)
        noOfLLempView.addGestureRecognizer(coverage_tap_6)
        llPaidDriverView.addGestureRecognizer(coverage_tap_7)
        fibreGlassView.addGestureRecognizer(coverage_tap_8)
        fppView.addGestureRecognizer(coverage_tap_9)
        nfppView.addGestureRecognizer(coverage_tap_10)

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
        if (selectedVu!.isDescendant(of: unnamedPersonAmtHigh.firstItem! as! UIView))
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
        let qNo = def.string(forKey: "QuotationNumber")
        quotationLabel.text = qNo
        quotationNumberLbl.text = qNo
        vehicleDetailLbl.text = vehiclName.uppercased()
        
        let vYRTO = "Commercial Vehicle     •  " + def.string(forKey:"RegistrationYear")! + "     •  "+def.string(forKey:"RTOName")!
        VehicleYearRTO.text = vYRTO

        self.toatalPlan.text = "Showing 0 of 0 results"
        declinedListArray = NSMutableArray.init()
        planArray = NSMutableArray.init()
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Processing"
        
        let jsonObject = PostJsonData().createMyDictForPostingData(ToGetQuaotationNumber: false, IfYesThen: "", andDict: NSDictionary.init())
        print(jsonObject)
        
        APICallered().POSTMethodForDataToGet(dataToPass: jsonObject, toURL: qualifyApi+vehicle_type+common.qualifyCompany) { response in
            let planDict = response?.object(forKey: "Response") as? NSDictionary
            if (planDict != nil)
            {
//                if (self.def.object(forKey: "QuotationNumber") == nil)
//                {
                    self.def.set(planDict?.object(forKey:"QuotationNumber") as! String, forKey: "QuotationNumber")
                    self.def.set(planDict?.object(forKey:"PolicyStartDate") as! String, forKey: "PolicyStartDate")
                    self.def.set(planDict?.object(forKey:"PolicyEndDate") as! String, forKey: "PolicyEndDate")
                    self.def.synchronize()
//                }

                DispatchQueue.main.async { [self] in
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
                    declinePlans = (companyDict.object(forKey: "DeclineDetails") as? String)
                    }
                i += 1
                self.loadPlansData(companyDict, i, companyList.count)
            }
        if  (declinePlans != nil)
        {
            let decArray =  declinePlans.components(separatedBy: "#")
            declinedListArray.addObjects(from: decArray)
            self.planArray.addObjects(from: declinedListArray as! [Any])
        }
    }
    
    override func viewDidLayoutSubviews() {
        let rangeValue : String! = String(self.min_IDV!) + " - " + String(self.max_IDV!)
        minMaxRangeLbl.text = rangeValue
    }
    
    func loadPlansData(_ comapnyDictionary : NSDictionary, _ countVal : Int, _ totalVale: Int)
    {
        let comapnyCode = comapnyDictionary.object(forKey: "CompanyCode") as! String
        let jsonD = PostJsonData().createMyDictForPostingData(ToGetQuaotationNumber: true, IfYesThen: common.sharedUserDefaults().string(forKey:"QuotationNumber")!, andDict: comapnyDictionary)
        APICallered().POSTMethodForDataToGet(dataToPass: jsonD, toURL: self.qualifyApi+self.vehicle_type+comapnyCode) { response in
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
                cell.pc_contoller = self
                cell.displayCell(planDict!)
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
                let decString = planArray[indexPath.row] as! String
                let cName = decString.components(separatedBy: "|").first
                let labelString = getLabelForDeclinedPlans(decString)
                let m = self.common.buy+self.common.baseURL+self.common.companylogo+cName!+".png"
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
        default:
            break
        }
        return true
    }
    
    private func textFieldLabel()
    {
        setLabelFieldMutualVisibility(customIDV, customIDVLbl)
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
        common.applyRoundedShapeToView(fppSum, withRadius: 5.0)
        common.applyBorderToView(fppSum, withColor: Colors.textFldColor, ofSize: 1)
        common.applyRoundedShapeToView(nfppSum, withRadius: 5.0)
        common.applyBorderToView(nfppSum, withColor: Colors.textFldColor, ofSize: 1)

        
        loadCheckBoxViews(antiTheftView, isSelected: def.bool(forKey: "IsAntiTheftDevice"))
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
        loadCheckBoxViews(fppView, isSelected: def.bool(forKey: "IsNoOfFPP"))
        loadCheckBoxViews(nfppView, isSelected: def.bool(forKey: "IsNoOfNFPP"))
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
        case 100112:
            def.set(textField.text!, forKey: "NoOfFPP")
            break
        case 100113:
            def.set(textField.text!, forKey: "NoOfNFPP")
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
        if (selectedView.isDescendant(of: elecAccView))
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
        else if (selectedView.isDescendant(of: nfppView))
        {
            nfppSum.text = ""
        }
        else if (selectedView.isDescendant(of: fppView))
        {
            fppSum.text = ""
        }
    }
    
    private func checkBoxSelected(_ selectedVu : UIView, _isSelected isCheck : Bool)
    {
        let viewTag = selectedVu.tag
        switch (viewTag)
        {
        case 100003:
                def.set(isCheck, forKey: "IsAntiTheftDevice")
                showAndHideDiscountView()
            break
        case 100006:
                def.set(isCheck, forKey: "IsTPPDRestrictedto6000")
                showAndHideDiscountView()
            break
        case 100007:
                var elAccHigh = 0.08
                var elAccFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsElectricalAccessories")
                if (isCheck)
                {
                    elAccHigh = 0.18
                    elAccFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: electricalAccHigh.firstItem as Any, attribute: electricalAccHigh.firstAttribute, relatedBy: electricalAccHigh.relation, toItem: electricalAccHigh.secondItem, attribute: electricalAccHigh.secondAttribute, multiplier: elAccHigh, constant: electricalAccHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: elecAmtHigh.firstItem as Any, attribute: elecAmtHigh.firstAttribute, relatedBy: elecAmtHigh.relation, toItem: elecAmtHigh.secondItem, attribute: elecAmtHigh.secondAttribute, multiplier: elAccFldHigh, constant: elecAmtHigh.constant)
                
                electricalAccHigh.isActive = false
                electricalAccHigh = VoluntaryHigh
                elecAmtHigh.isActive = false
                elecAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([electricalAccHigh, elecAmtHigh])
                let hideView = elecAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
            break
        case 100008:
                var nonElAccHigh = 0.08
                var nonElAccFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsNonElectricalAccessories")
                if (isCheck)
                {
                    nonElAccHigh = 0.18
                    nonElAccFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: nonElectricalAccHigh.firstItem as Any, attribute: nonElectricalAccHigh.firstAttribute, relatedBy: nonElectricalAccHigh.relation, toItem: nonElectricalAccHigh.secondItem, attribute: nonElectricalAccHigh.secondAttribute, multiplier: nonElAccHigh, constant: nonElectricalAccHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: nonElecAmtHigh.firstItem as Any, attribute: nonElecAmtHigh.firstAttribute, relatedBy: nonElecAmtHigh.relation, toItem: nonElecAmtHigh.secondItem, attribute: nonElecAmtHigh.secondAttribute, multiplier: nonElAccFldHigh, constant: nonElecAmtHigh.constant)
                
                nonElectricalAccHigh.isActive = false
                nonElectricalAccHigh = VoluntaryHigh
                nonElecAmtHigh.isActive = false
                nonElecAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([nonElectricalAccHigh, nonElecAmtHigh])
                let hideView = nonElecAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
                break
        case 100009:
                var biFuelVHigh = 0.08
                var biFuelVFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsBiFuelKit")
                if (isCheck)
                {
                    biFuelVHigh = 0.18
                    biFuelVFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: biFuelHigh.firstItem as Any, attribute: biFuelHigh.firstAttribute, relatedBy: biFuelHigh.relation, toItem: biFuelHigh.secondItem, attribute: biFuelHigh.secondAttribute, multiplier: biFuelVHigh, constant: biFuelHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: biFuelAmtHigh.firstItem as Any, attribute: biFuelAmtHigh.firstAttribute, relatedBy: biFuelAmtHigh.relation, toItem: biFuelAmtHigh.secondItem, attribute: biFuelAmtHigh.secondAttribute, multiplier: biFuelVFldHigh, constant: biFuelAmtHigh.constant)
                
                biFuelHigh.isActive = false
                biFuelHigh = VoluntaryHigh
                biFuelAmtHigh.isActive = false
                biFuelAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([biFuelHigh, biFuelAmtHigh])
                let hideView = biFuelAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
            break
        case 100010:
                var elAccHigh = 0.08
                var elAccFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsPACoverPaidDriver")
                if (isCheck)
                {
                    elAccHigh = 0.18
                    elAccFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: paidDriverHigh.firstItem as Any, attribute: paidDriverHigh.firstAttribute, relatedBy: paidDriverHigh.relation, toItem: paidDriverHigh.secondItem, attribute: paidDriverHigh.secondAttribute, multiplier: elAccHigh, constant: paidDriverHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: paidDriverAmtHigh.firstItem as Any, attribute: paidDriverAmtHigh.firstAttribute, relatedBy: paidDriverAmtHigh.relation, toItem: paidDriverAmtHigh.secondItem, attribute: paidDriverAmtHigh.secondAttribute, multiplier: elAccFldHigh, constant: paidDriverAmtHigh.constant)
                
                paidDriverHigh.isActive = false
                paidDriverHigh = VoluntaryHigh
                paidDriverAmtHigh.isActive = false
                paidDriverAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([paidDriverHigh, paidDriverAmtHigh])
                let hideView = paidDriverAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
            break
        case 100011:
                var elAccHigh = 0.08
                var elAccFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsPACoverUnnamedPerson")
                if (isCheck)
                {
                    elAccHigh = 0.18
                    elAccFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: unnamedPersonHigh.firstItem as Any, attribute: unnamedPersonHigh.firstAttribute, relatedBy: unnamedPersonHigh.relation, toItem: unnamedPersonHigh.secondItem, attribute: unnamedPersonHigh.secondAttribute, multiplier: elAccHigh, constant: unnamedPersonHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: unnamedPersonAmtHigh.firstItem as Any, attribute: unnamedPersonAmtHigh.firstAttribute, relatedBy: unnamedPersonAmtHigh.relation, toItem: unnamedPersonAmtHigh.secondItem, attribute: unnamedPersonAmtHigh.secondAttribute, multiplier: elAccFldHigh, constant: unnamedPersonAmtHigh.constant)
                
                unnamedPersonHigh.isActive = false
                unnamedPersonHigh = VoluntaryHigh
                unnamedPersonAmtHigh.isActive = false
                unnamedPersonAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([unnamedPersonHigh, unnamedPersonAmtHigh])
                let hideView = unnamedPersonAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
            break
        case 100012:
                var elAccHigh = 0.08
                var elAccFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsEmployeeLiability")
                if (isCheck)
                {
                    elAccHigh = 0.18
                    elAccFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: noOfLLempHigh.firstItem as Any, attribute: noOfLLempHigh.firstAttribute, relatedBy: noOfLLempHigh.relation, toItem: noOfLLempHigh.secondItem, attribute: noOfLLempHigh.secondAttribute, multiplier: elAccHigh, constant: noOfLLempHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: noOfLLempAmtHigh.firstItem as Any, attribute: noOfLLempAmtHigh.firstAttribute, relatedBy: noOfLLempAmtHigh.relation, toItem: noOfLLempAmtHigh.secondItem, attribute: noOfLLempAmtHigh.secondAttribute, multiplier: elAccFldHigh, constant: noOfLLempAmtHigh.constant)
                
                noOfLLempHigh.isActive = false
                noOfLLempHigh = VoluntaryHigh
                noOfLLempAmtHigh.isActive = false
                noOfLLempAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([noOfLLempHigh, noOfLLempAmtHigh])
                let hideView = noOfLLempAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
            break
        case 100013:
                var elAccHigh = 0.08
                var elAccFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsLegalLiablityPaidDriver")
                if (isCheck)
                {
                    elAccHigh = 0.18
                    elAccFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: llPaidDriverHigh.firstItem as Any, attribute: llPaidDriverHigh.firstAttribute, relatedBy: llPaidDriverHigh.relation, toItem: llPaidDriverHigh.secondItem, attribute: llPaidDriverHigh.secondAttribute, multiplier: elAccHigh, constant: llPaidDriverHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: llPaidDriverAmtHigh.firstItem as Any, attribute: llPaidDriverAmtHigh.firstAttribute, relatedBy: llPaidDriverAmtHigh.relation, toItem: llPaidDriverAmtHigh.secondItem, attribute: llPaidDriverAmtHigh.secondAttribute, multiplier: elAccFldHigh, constant: llPaidDriverAmtHigh.constant)
                
                llPaidDriverHigh.isActive = false
                llPaidDriverHigh = VoluntaryHigh
                llPaidDriverAmtHigh.isActive = false
                llPaidDriverAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([llPaidDriverHigh, llPaidDriverAmtHigh])
                let hideView = llPaidDriverAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
            break
        case 100014:
                def.set(isCheck, forKey: "IsFiberGlassFuelTank")
            break
        case 100015:
                var elAccHigh = 0.08
                var elAccFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsNoOfFPP")
                if (isCheck)
                {
                    elAccHigh = 0.18
                    elAccFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: nfppHigh.firstItem as Any, attribute: nfppHigh.firstAttribute, relatedBy: nfppHigh.relation, toItem: nfppHigh.secondItem, attribute: nfppHigh.secondAttribute, multiplier: elAccHigh, constant: nfppHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: fppAmtHigh.firstItem as Any, attribute: fppAmtHigh.firstAttribute, relatedBy: fppAmtHigh.relation, toItem: fppAmtHigh.secondItem, attribute: fppAmtHigh.secondAttribute, multiplier: elAccFldHigh, constant: fppAmtHigh.constant)
                
            nfppHigh.isActive = false
            nfppHigh = VoluntaryHigh
            fppAmtHigh.isActive = false
            fppAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([nfppHigh, fppAmtHigh])
                let hideView = fppAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
            break
        case 100016:
                var elAccHigh = 0.08
                var elAccFldHigh = 0.0000000001
                def.set(isCheck, forKey: "IsNoOfNFPP")
                if (isCheck)
                {
                    elAccHigh = 0.18
                    elAccFldHigh = 0.1
                }
                let VoluntaryHigh = NSLayoutConstraint.init(item: nfppHigh.firstItem as Any, attribute: nfppHigh.firstAttribute, relatedBy: nfppHigh.relation, toItem: nfppHigh.secondItem, attribute: nfppHigh.secondAttribute, multiplier: elAccHigh, constant: nfppHigh.constant)
                let VolExcFieldHigh = NSLayoutConstraint.init(item: nfppAmtHigh.firstItem as Any, attribute: nfppAmtHigh.firstAttribute, relatedBy: nfppAmtHigh.relation, toItem: nfppAmtHigh.secondItem, attribute: nfppAmtHigh.secondAttribute, multiplier: elAccFldHigh, constant: nfppAmtHigh.constant)
                
            nfppHigh.isActive = false
            nfppHigh = VoluntaryHigh
            nfppAmtHigh.isActive = false
            nfppAmtHigh = VolExcFieldHigh
                NSLayoutConstraint.activate([nfppHigh, nfppAmtHigh])
                let hideView = nfppAmtHigh.firstItem as! UIView
                hideView.isHidden = !isCheck
                selectedVu.superview!.layoutIfNeeded()
                showAndHideCoverageView()
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
        return labelString
    }
}

