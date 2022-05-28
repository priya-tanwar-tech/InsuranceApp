//
//  PremiumBreakUpController.swift
//  Probus_Insurance
//
//  Created by Sankalp on 25/03/22.
//

import Foundation
import UIKit

class PremiumBreakUpController : UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var CoverIDVValue: UILabel!
    @IBOutlet weak var finalPremValue: UILabel!
    
    @IBOutlet weak var basicView: UIView!
    @IBOutlet weak var odView: UIView!
    @IBOutlet weak var discountVu: UIView!
    @IBOutlet weak var addonVu: UIView!
    @IBOutlet weak var tpView: UIView!
    
    @IBOutlet weak var exPrice: UILabel!
    @IBOutlet weak var minIDV: UILabel!
    @IBOutlet weak var maxIDV: UILabel!
    @IBOutlet weak var vehicleAGe: UILabel!
    @IBOutlet weak var fuelType: UILabel!
    @IBOutlet weak var cubicCapacity: UILabel!
    @IBOutlet weak var seatingCapacity: UILabel!
    
    @IBOutlet weak var basicODHigh: NSLayoutConstraint!//0.28
    
    @IBOutlet weak var basicODValue: UILabel!
    
    @IBOutlet weak var elecHigh: NSLayoutConstraint!
    @IBOutlet weak var elecTop: NSLayoutConstraint!
    @IBOutlet weak var nonElecHigh: NSLayoutConstraint!
    @IBOutlet weak var nonElecTop: NSLayoutConstraint!
    @IBOutlet weak var cngLpgHigh: NSLayoutConstraint!
    @IBOutlet weak var cngLpgTop: NSLayoutConstraint!
    @IBOutlet weak var inspecHigh: NSLayoutConstraint!
    @IBOutlet weak var inspecTop: NSLayoutConstraint!
    @IBOutlet weak var fibreHigh: NSLayoutConstraint!
    @IBOutlet weak var fibreTop: NSLayoutConstraint!
    @IBOutlet weak var LoadingPremHigh: NSLayoutConstraint!
    @IBOutlet weak var LoadingPremTop: NSLayoutConstraint!

    @IBOutlet weak var elecAccValue: UILabel!
    @IBOutlet weak var nonElecAccValue: UILabel!
    @IBOutlet weak var cngLpgValue: UILabel!
    @IBOutlet weak var inspectionValue: UILabel!
    @IBOutlet weak var fibreValue: UILabel!
    @IBOutlet weak var loadingPremValue: UILabel!
    @IBOutlet weak var TotalODValue: UILabel!
    
    @IBOutlet weak var DiscountHigh: NSLayoutConstraint!//0.25
    
    @IBOutlet weak var antiTheftTop: NSLayoutConstraint!
    @IBOutlet weak var antiTheftHigh: NSLayoutConstraint!
    @IBOutlet weak var aaiTop: NSLayoutConstraint!
    @IBOutlet weak var aaiHigh: NSLayoutConstraint!
    @IBOutlet weak var voluntaryTop: NSLayoutConstraint!
    @IBOutlet weak var voluntaryHigh: NSLayoutConstraint!

    @IBOutlet weak var ncbValue: UILabel!
    @IBOutlet weak var antiTheftValue: UILabel!
    @IBOutlet weak var aaiValue: UILabel!
    @IBOutlet weak var voluntaryValue: UILabel!
    @IBOutlet weak var discountValue: UILabel!
    
    @IBOutlet weak var tpPreemiumHigh: NSLayoutConstraint!//0.4
    
    @IBOutlet weak var restrictedTop: NSLayoutConstraint!
    @IBOutlet weak var restrictedHigh: NSLayoutConstraint!
    @IBOutlet weak var bifuelTop: NSLayoutConstraint!
    @IBOutlet weak var bifuelHigh: NSLayoutConstraint!
    @IBOutlet weak var paOwnDriTop: NSLayoutConstraint!
    @IBOutlet weak var paOwnDriHigh: NSLayoutConstraint!
    @IBOutlet weak var paUnnamedTop: NSLayoutConstraint!
    @IBOutlet weak var paUnnamedHigh: NSLayoutConstraint!
    @IBOutlet weak var llPaidDriTop: NSLayoutConstraint!
    @IBOutlet weak var llPaidDriHigh: NSLayoutConstraint!
    @IBOutlet weak var paPaidDriTop: NSLayoutConstraint!
    @IBOutlet weak var paPaidDriHigh: NSLayoutConstraint!
    @IBOutlet weak var llPaidEmpTop: NSLayoutConstraint!
    @IBOutlet weak var llPaidEmpHigh: NSLayoutConstraint!

    @IBOutlet weak var basicTPValue: UILabel!
    @IBOutlet weak var restrictedTPValue: UILabel!
    @IBOutlet weak var biFuelValue: UILabel!
    @IBOutlet weak var paOwnedDriver: UILabel!
    @IBOutlet weak var paUnnamed: UILabel!
    @IBOutlet weak var llPaidDriver: UILabel!
    @IBOutlet weak var paPaidDriver: UILabel!
    @IBOutlet weak var llPaidEmp: UILabel!
    @IBOutlet weak var totalTPValue: UILabel!
    
    @IBOutlet weak var addonPremHigh: NSLayoutConstraint!//0.2
    @IBOutlet weak var appliedAddonHigh: NSLayoutConstraint!
    @IBOutlet weak var appliedAddonTop: NSLayoutConstraint!

    @IBOutlet weak var appliedAddonsValue: UILabel!
    @IBOutlet weak var totalAddonCost: UILabel!
    
    
    @IBOutlet weak var netPremium: UILabel!
    @IBOutlet weak var gstValue: UILabel!
    @IBOutlet weak var FinalPremiom: UILabel!
    
    private let common = Common.sharedCommon

    override func viewDidLoad() {
        
        let companyDictionary = common.unArchiveMyDataForDictionary("StoredCompany")
        let premBreakUpDict = companyDictionary!.object(forKey: "PremiumBreakUpDetails") as! NSDictionary
        
//        " ₹"

        let m = self.common.buy+self.common.baseURL+self.common.companylogo+(companyDictionary?.object(forKey: "CompanyCode") as! String)+".png"
        let d = NSData.init(contentsOf: URL(string: m)!)
        companyLogo.image = UIImage.init(data: d! as Data)

        
        var idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "InsuredDeclaredValue")!)))")
        CoverIDVValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "FinalPremium")!)))")
        finalPremValue.text = "₹ "+idvV
        common.applyRoundedShapeToView(finalPremValue, withRadius: finalPremValue.frame.size.height/2)
        FinalPremiom.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "NetPremium")!)))")
        netPremium.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "ServiceTax")!)))")
        gstValue.text = "₹ "+idvV

        idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "ExShowroomPrice")!)))")
        exPrice.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "MinInsuredDeclaredValue")!)))")
        minIDV.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "MaxInsuredDeclaredValue")!)))")
        maxIDV.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "VehicleAge")!)))")
        vehicleAGe.text = idvV
        idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "FuelType")!)))")
        fuelType.text = idvV
        idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "CubicCapacity")!)))")
        cubicCapacity.text = idvV
        idvV = common.removeOptionalKey("\(String(describing: (companyDictionary?.object(forKey: "SeatingCapacity")!)))")
        seatingCapacity.text = idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "BasicODPremium")!)))")
        basicODValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "ElecAccessoriesPremium")!)))")
        elecAccValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "ElecAccessoriesPremium")!)))")
        nonElecAccValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "CNGLPGKitPremium")!)))")
        cngLpgValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "InspectionCharges")!)))")
        inspectionValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "LoadingPremium")!)))")
        loadingPremValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "FiberGlassTankPremium")!)))")
        fibreValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "NetODPremium")!)))")
        TotalODValue.text = "₹ "+idvV

        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "NCBDiscount")!)))")
        ncbValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "AntiTheftDiscount")!)))")
        antiTheftValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "AAIDiscount")!)))")
        aaiValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "VoluntaryDiscount")!)))")
        voluntaryValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "NetDiscount")!)))")
        discountValue.text = "₹ "+idvV

        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "BasicThirdPartyLiability")!)))")
        basicTPValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "RestrictLiability")!)))")
        restrictedTPValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "TPCNGLPGPremium")!)))")
        biFuelValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "PACoverToOwnDriver")!)))")
        paOwnedDriver.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "PACoverToUnNamedPerson")!)))")
        paUnnamed.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "LLToPaidDriver")!)))")
        llPaidDriver.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "PAToPaidDriver")!)))")
        paPaidDriver.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "LLToPaidEmployee")!)))")
        llPaidEmp.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "NetTPPremium")!)))")
        totalTPValue.text = "₹ "+idvV
        idvV = common.removeOptionalKey("\(String(describing: (premBreakUpDict.object(forKey: "NetAddonPremium")!)))")
        totalAddonCost.text = "₹ "+idvV
        idvV =  premBreakUpDict.object(forKey: "ApplicableCompanyAddonList")
 as! String
        appliedAddonsValue.text = idvV
    }
        
    @IBAction func backBtnTapped(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
