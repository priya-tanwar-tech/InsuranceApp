//
//  MotorAgreementController.swift
//  InsuranceApp
//
//  Created by Sankalp on 07/01/22.
//

import Foundation
import UIKit
import MBProgressHUD

class MotorAgreementController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollVu: UIScrollView!
    
    @IBOutlet weak var continueVu: UIButton!
    @IBOutlet weak var myProgressBar: UIProgressView!

    @IBOutlet weak var smsAlert: UICollectionView!
    @IBOutlet weak var whatsAppAlert: UICollectionView!
    @IBOutlet weak var privacyAlert: UICollectionView!

    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var quotationLabel: UILabel!

    private var tappedSms: Int! = 1
    private var tappedwhatsApp: Int! = 0
    private var tappedprivacy: Int! = 1

    private let common = Common.sharedCommon
    private let def = Common.sharedCommon.sharedUserDefaults()

    override func viewDidLoad() {
        let vehiclName = def.string(forKey: "MakeName")! + " " + def.string(forKey: "ModelName")! + " " + def.string(forKey: "VariantName")!
        vehicleDetails.text = vehiclName
        quotationLabel.text = def.string(forKey: "QuotationNumber")

        myProgressBar.setProgress(1.0, animated: true)
        common.applyRoundedShapeToView(continueVu, withRadius: 10)

        smsAlert.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        whatsAppAlert.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        privacyAlert.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton)
    {
        def.synchronize()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func payTapped(_ sender: UIButton) {
        if (tappedprivacy == 0)
        {
            let jsonObj = PostJsonData().companySpecificQuotation()
            self.common.archiveMyDataForDictionary(jsonObj, withKey: "SpecificQuotationRequest")
            var vehicleType = ""
            switch(def.integer(forKey: "ProductCode"))
            {
            case 2:
                vehicleType = Constant.privatecar
                break
            case 1:
                vehicleType = Constant.twowheeler
                break
            case 10:
                vehicleType = Constant.goodCom
                break
            case 9:
                vehicleType = Constant.passCom
                break
            default:
                vehicleType = Constant.miscCom
                break
            }
            let k = Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+vehicleType+Constant.comp_spec_quote
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Processing"
            def.synchronize()

            APICallered().POSTMethodForDataToGet(dataToPass: jsonObj, toURL: k) { response in
                if (!(response?.object(forKey: "Response") is NSNull))
                {
                    let responseDict = response?.object(forKey: "Response") as! NSDictionary
                    if ((responseDict.object(forKey: "Status") as! String).lowercased().elementsEqual("info") || (responseDict.object(forKey: "Status") as! String).lowercased().elementsEqual("error"))
                    {
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let errorMsg = (responseDict.object(forKey: "ErrorMessage") as? String)
                            let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                            alertVu.showError("Alert!", subTitle: errorMsg!, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            self.common.archiveMyDataForDictionary(responseDict, withKey: "SpecificQuotationResponse")
                            self.common.goToNextScreenWith("MotorReviewPayViewController", self)
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)

                    let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
                    alertVu.showError("Alert!", subTitle: "Something went wrong.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                    }
                }
            }
        }
        else
        {
            let alertVu = SCLAlertView.init(appearance: self.common.alertwithCancel)
            alertVu.showError("Alert!", subTitle: "Kindly agree to policy terms and conditions.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Common.yesNoBtnArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 12)

        switch (collectionView.tag)
        {
        case 1501:
                if (tappedSms == indexPath.row)
                {
                    cell.setSelectedData()
                }
                break
        case 1503:
                if (tappedprivacy == indexPath.row)
                {
                    cell.setSelectedData()
                }
                break
        default:
                if (indexPath.row == 0)
                {
                    def.set(true, forKey: "IsWhatsappMessageAllow")
                }
                if (tappedwhatsApp == indexPath.row)
                {
                    cell.setSelectedData()
                }
                break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (collectionView.tag)
        {
        case 1501:
                tappedSms = indexPath.row
            break
        case 1503:
                tappedprivacy = indexPath.row
            break
        default:
                tappedwhatsApp = indexPath.row
            break
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = common.getScreenSize(collectionView)
        var sizes: CGSize = CGSize.init(width: 0, height: 0)
        let CellHeight = widthAndHeight.1
        let CellWidth = widthAndHeight.0*0.45
        if (collectionView.tag == 1204)
        {
            sizes = CGSize(width: CellWidth, height: CellHeight*0.6)
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
}
/**
 //                        self.alertVu.showError("Error!", subTitle: errorMsg, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)

 */
