//
//  ContactDetailsViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 09/12/21.
//

import Foundation
import UIKit

class ContactDetailsViewController : UIViewController, UIScrollViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollVu: UIScrollView!
    @IBOutlet weak var contactView: UIView!

    @IBOutlet weak var continueVu: UIButton!
    @IBOutlet weak var myProgressBar: UIProgressView!

    @IBOutlet weak var mobileVu: UIView!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var mobileLbl: UILabel!

    @IBOutlet weak var mobileOtherVu: UIView!
    @IBOutlet weak var mobileOther: UITextField!
    @IBOutlet weak var mobileOtherLbl: UILabel!

    @IBOutlet weak var emailVu: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailLbl: UILabel!

    @IBOutlet weak var aadhaarVu: UIView!
    @IBOutlet weak var aadhaar: UITextField!
    @IBOutlet weak var aadhaarLbl: UILabel!

    @IBOutlet weak var panVu: UIView!
    @IBOutlet weak var pan: UITextField!
    @IBOutlet weak var panLbl: UILabel!

    @IBOutlet weak var gstVu: UIView!
    @IBOutlet weak var gst: UITextField!
    @IBOutlet weak var gstLbl: UILabel!

    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var quotationLabel: UILabel!

    @IBOutlet weak var keyBoardView: NSLayoutConstraint!

    private let common = Common.sharedCommon
    private var keyboardIsOpen = false
    private let dict = NSMutableDictionary.init()
    
    override func viewDidLoad() {
        let def = common.sharedUserDefaults()
        let vehiclName = def.string(forKey: "MakeName")! + " " + def.string(forKey: "ModelName")! + " " + def.string(forKey: "VariantName")!
        vehicleDetails.text = vehiclName
        quotationLabel.text = def.string(forKey: "QuotationNumber")

        
        var v : Int!
        if (def.dictionary(forKey: "PrevPolicyExpiryStatus") != nil)
        {
            let ki = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
            v = Int(ki.object(forKey: "Id") as! String)
        }

        if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
        {
            myProgressBar.setProgress((2/7), animated: true)
        }
        else
        {
            myProgressBar.setProgress((2/6), animated: true)
        }
        
        common.addDoneButtonOnNumpad(textField: mobile)
        common.addDoneButtonOnNumpad(textField: mobileOther)
        common.addDoneButtonOnNumpad(textField: aadhaar)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let def = common.sharedUserDefaults()
        if (def.dictionary(forKey: "ClientDetails") != nil)
        {
            dict.addEntries(from: def.dictionary(forKey: "ClientDetails")!)
        }
        setTextFieldValues()
        applyRoundedShape()
        textFieldLabel()
    }
    
    private func applyRoundedShape()
    {
        common.applyRoundedShapeToView(mobile, withRadius: 5)
        common.applyRoundedShapeToView(mobileOther, withRadius: 5)
        common.applyRoundedShapeToView(email, withRadius: 5)
        common.applyRoundedShapeToView(aadhaar, withRadius: 5)
        common.applyRoundedShapeToView(pan, withRadius: 5)
        common.applyRoundedShapeToView(gst, withRadius: 5)
        common.applyRoundedShapeToView(continueVu, withRadius: 10)
    }
    
    private func setTextFieldValues()
    {
        if (dict.object(forKey: "MobileNumber") !=  nil)
        {
            mobile.text = (dict.object(forKey: "MobileNumber") as! String)
        }
        if (dict.object(forKey: "AdditionalContactNumber") !=  nil)
        {
            mobileOther.text = (dict.object(forKey: "AdditionalContactNumber") as! String)
        }
        if (dict.object(forKey: "AadhaarNo") !=  nil)
        {
            aadhaar.text = (dict.object(forKey: "AadhaarNo") as! String)
        }
        if (dict.object(forKey: "PanCardNumber") !=  nil)
        {
            pan.text = (dict.object(forKey: "PanCardNumber") as! String)
        }
        if (dict.object(forKey: "GSTIN") !=  nil)
        {
            gst.text = (dict.object(forKey: "GSTIN") as! String)
        }
        if (dict.object(forKey: "EmailAddress") !=  nil)
        {
            email.text = (dict.object(forKey: "EmailAddress") as! String)
        }
    }
        
    @IBAction func continueBtnTapped(_ sender: Any) {
        mobile.resignFirstResponder()
        gst.resignFirstResponder()
        aadhaar.resignFirstResponder()
        pan.resignFirstResponder()
        mobileOther.resignFirstResponder()
        email.resignFirstResponder()

        if (!mobile.hasText && !email.hasText)
        {
            displayAlert()
        }
        else if (((dict.object(forKey: "MobileNumber") != nil) && (dict.object(forKey: "EmailAddress") != nil)) || (dict.object(forKey: "AadhaarNo") != nil) || (dict.object(forKey: "PanCardNumber") != nil) || (dict.object(forKey: "GSTIN") != nil))
        {
            saveMyDetails()
            self.common.goToNextScreenWith("AddressViewController", self)
        }
    }
    
    private func displayAlert()
    {
        common.removeImageForRestriction(mobile!)
        common.removeImageForRestriction(email!)

        if (!mobile.hasText)
        {
            common.displayImageForRestriction(mobile!)
        }
        if (!email.hasText)
        {
            common.displayImageForRestriction(email!)
        }
    }
    
    private func saveMyDetails()
    {
        let def = common.sharedUserDefaults()
        def.set(dict, forKey: "ClientDetails")
        def.synchronize()
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

    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabel()
        keyboardIsOpen = false
        keyBoardView.constant = 0
    }

    private func textFieldLabel()
    {
        common.applyBorderToView(mobile, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(mobileOther, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(email, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(aadhaar, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(pan, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(gst, withColor: Colors.textFldColor, ofSize: 1)

        setLabelFieldMutualVisibility(mobile, mobileLbl.text!, mobileLbl)
        setLabelFieldMutualVisibility(mobileOther, mobileOtherLbl.text!, mobileOtherLbl)
        setLabelFieldMutualVisibility(email, emailLbl.text!, emailLbl)
        setLabelFieldMutualVisibility(aadhaar, aadhaarLbl.text!, aadhaarLbl)
        setLabelFieldMutualVisibility(pan, panLbl.text!, panLbl)
        setLabelFieldMutualVisibility(gst, gstLbl.text!, gstLbl)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 91:
                common.setTextFieldLabels(mobile, mobileLbl, false, "")
            break
        case 92:
                common.setTextFieldLabels(mobileOther, mobileOtherLbl, false, "")
            break
        case 94:
                common.setTextFieldLabels(aadhaar, aadhaarLbl, false, "")
            break
        case 95:
                common.setTextFieldLabels(pan, panLbl, false, "")
            break
        case 96:
                common.setTextFieldLabels(gst, gstLbl, false, "")
            break
        default:
                common.setTextFieldLabels(email, emailLbl, false, "")
            break
        }
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
     
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
     {
         textFieldLabel()
         common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)

         var currentString: NSString = textField.text! as NSString
         let tagValue = textField.tag
         switch(tagValue)
         {
         case 93:
             currentString =
             currentString.replacingCharacters(in: range, with: string.uppercased()) as NSString
             break
         case 95:
             currentString =
             currentString.replacingCharacters(in: range, with: string.uppercased()) as NSString
             break
         case 96:
             currentString =
             currentString.replacingCharacters(in: range, with: string.uppercased()) as NSString
             break
         default:
             if (string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil || string.isEmpty)
             {
                 currentString =
                 currentString.replacingCharacters(in: range, with: string) as NSString
             }
             else
             {
                 let alertVu = SCLAlertView.init(appearance: common.alertwithCancel)
                 alertVu.showError("Alert!", subTitle: "Only numbers are allowed.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                 return false
             }
             break
         }
         return true
     }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let tagValue = textField.tag
        let str = textField.text!
        switch(tagValue)
        {
        case 91:
            if (str.count == 10)
            {
                dict.setValue(str, forKey: "MobileNumber")
                textField.resignFirstResponder()
            }
            break
        case 92:
            if (str.count == 10)
            {
                dict.setValue(str, forKey: "AdditionalContactNumber")
                textField.resignFirstResponder()
            }
            break
        case 94:
            if (str.count >= 12)
            {
                dict.setValue(str, forKey: "AadhaarNo")
                textField.resignFirstResponder()
            }
            break
        case 95:
            let pan = common.isValidPAN(str)
            if (pan)
            {
                dict.setValue(str, forKey: "PanCardNumber")
            }
            break
        case 96:
            let gstV = common.isValidGST(str)
            if (gstV)
            {
                dict.setValue(str, forKey: "GSTIN")
            }
            break
        default:
            let mail = common.isValidEmail(str)
            if (mail)
            {
                dict.setValue(str, forKey: "EmailAddress")
            }
            break
        }
    }

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         textFieldLabel()
         return true
     }

    @IBAction func backBtnAction(_ sender: UIButton)
    {
        saveMyDetails()
        self.navigationController?.popViewController(animated: true)
    }
}
