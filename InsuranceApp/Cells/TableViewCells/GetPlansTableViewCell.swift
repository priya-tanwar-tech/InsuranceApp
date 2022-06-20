//
//  GetPlansTableViewCell.swift
//  InsuranceApp
//
//  Created by Sankalp on 03/12/21.
//

import Foundation
import UIKit

class GetPlansTableViewCell: UITableViewCell
{
    var GetPlansTableViewCell: UITableViewCell!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var claimSettled: UILabel!
    
    @IBOutlet weak var planValue: UIButton!
    @IBOutlet weak var includeTax: UILabel!
    
    @IBOutlet weak var packagePolicy: UILabel!
    @IBOutlet weak var coverLbl: UILabel!

    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var idvValue: UILabel!
   
    var car_contoller : GetMotorCarPlansViewController!
    var bike_contoller : GetMotorBikePlansViewController!
    var other_contoller : PCGCMiscPlansViewController!
    var pc_contoller : PassengerCarryingPlanViewController!
    private var myDict : NSDictionary!
    private let common = Common.sharedCommon

    func displayCell(_ dict : NSDictionary)
    {
        myDict = dict
        self.selectionStyle = .none
        // ₹ 8888/-
        
        common.applyRoundedShapeToView(planValue, withRadius: 10)
        common.applyShadowToView(self.contentView, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        enterDetails()
        common.applyRoundedShapeToView(reviewBtn, withRadius: 10)
    }
    
    private func enterDetails()
    {
        let pbd = (myDict.object(forKey: "PremiumBreakUpDetails") as! NSDictionary)
        let str = String(myDict.object(forKey: "PremiumYear") as! Int)
        coverLbl.text = "Cover for " + str + " Year"
        packagePolicy.text = myDict.object(forKey: "PlanName") as? String
        let np = pbd.object(forKey: "NetPremium") as? CGFloat
        let netPrem = NSString.init(format: "₹%.2f", np!).components(separatedBy: ".").first
        let idv = myDict.object(forKey: "InsuredDeclaredValue") as? CGFloat
        let idvVal = NSString.init(format: "₹%.2f", idv!).components(separatedBy: ".").first
        idvValue.text = idvVal!
        let abcstr = myDict.object(forKey: "CompanyCode") as! String
        let m = Constant.buyAPI+Constant.baseURL+Constant.companylogo+abcstr+".png"
        let d = NSData.init(contentsOf: URL(string: m)!)
        planValue.setTitle(netPrem!, for: .normal)
        companyImage.image = UIImage.init(data: d! as Data)
    }
    
    @IBAction func planTapped(_ sender: UIButton) {
        let def = common.sharedUserDefaults()
        common.archiveMyDataForDictionary(self.myDict, withKey: "StoredCompany")
        if (myDict.object(forKey:"CarryingCapacity") != nil)
        {
            def.set(myDict.object(forKey:"CarryingCapacity"), forKey: "CarryingCapacity")
        }
        def.set(myDict.object(forKey:"CubicCapacity"), forKey: "CubicCapacity")
        def.set(myDict.object(forKey:"SeatingCapacity"), forKey: "SeatingCapacity")
        def.set(self.myDict.object(forKey: "CompanyCode"), forKey: "ThisCompany")
        def.synchronize()

        if (car_contoller != nil && !car_contoller.modifyPlan && bike_contoller == nil && other_contoller == nil && pc_contoller == nil)
        {
            common.goToNextScreenWith("ProposalPersonalDeatailsViewController", car_contoller)
        }
        else if (bike_contoller != nil && !bike_contoller.modifyPlan && car_contoller == nil && other_contoller == nil && pc_contoller == nil)
        {
            common.goToNextScreenWith("ProposalPersonalDeatailsViewController", bike_contoller)
        }
        else if (other_contoller != nil && !other_contoller.modifyPlan && car_contoller == nil && car_contoller == nil && pc_contoller == nil)
        {
            common.goToNextScreenWith("ProposalPersonalDeatailsViewController", other_contoller)
        }
        else if (pc_contoller != nil && !pc_contoller.modifyPlan && car_contoller == nil && car_contoller == nil && other_contoller == nil)
        {
            common.goToNextScreenWith("ProposalPersonalDeatailsViewController", pc_contoller)
        }
        else
        {
            let alert = SCLAlertView.init(appearance: common.alertwithCancel)
            alert.showError("Alert!", subTitle: "It seems you have changed your details, so please re-calculate again.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
        }
    }
    
    @IBAction func reviewBtnTapped()
    {
        common.archiveMyDataForDictionary(self.myDict, withKey: "StoredCompany")
        if (car_contoller == nil && other_contoller == nil && pc_contoller == nil)
        {
            common.goToNextScreenWith("PremiumBreakUpController", bike_contoller)
        }
        else if (bike_contoller == nil && other_contoller == nil && pc_contoller == nil)
        {
            common.goToNextScreenWith("PremiumBreakUpController", car_contoller)
        }
        else if (car_contoller == nil && other_contoller == nil && bike_contoller == nil)
        {
            common.goToNextScreenWith("PremiumBreakUpController", pc_contoller)
        }
        else
        {
            common.goToNextScreenWith("PremiumBreakUpController", other_contoller)
        }
    }
}
