//
//  PhoneOtpViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 20/11/21.
//

import Foundation
import UIKit

class PhoneOtpViewController : UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var phoneEditView: UIView!
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var otpExpireLabel: UILabel!
    
    @IBOutlet weak var verifyBtn: UIButton!

    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    @IBOutlet weak var fourthLbl: UILabel!
    
    @IBOutlet weak var firstLabelView: UIView!
    @IBOutlet weak var secondLabelView: UIView!
    @IBOutlet weak var thirdLabelView: UIView!
    @IBOutlet weak var fourthLabelView: UIView!
    
    private let common = Common.sharedCommon

    override func viewDidLoad()
    {
        otpExpireLabel.highlightMyText(otpExpireLabel.text!, searchedText: "Resend", colorValue: common.hexStringToUIColor(hex: "#009FC2"), withFontName: otpExpireLabel.font!)
        
        common.applyRoundedShapeToView(verifyBtn, withRadius: 10.0)
        common.applyRoundedShapeToView(firstLabelView, withRadius: 10.0)
        common.applyRoundedShapeToView(secondLabelView, withRadius: 10.0)
        common.applyRoundedShapeToView(thirdLabelView, withRadius: 10.0)
        common.applyRoundedShapeToView(fourthLabelView, withRadius: 10.0)
        
        common.applyRoundedShapeToView(firstLbl, withRadius: 10.0)
        common.applyRoundedShapeToView(secondLbl, withRadius: 10.0)
        common.applyRoundedShapeToView(thirdLbl, withRadius: 10.0)
        common.applyRoundedShapeToView(fourthLbl, withRadius: 10.0)
        
        common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
        common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
        common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
        common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)

        phoneEditView.layer.borderWidth = 1.0
        phoneEditView.layer.cornerRadius = 10
        phoneEditView.layer.borderColor = common.hexStringToUIColor(hex: "#CECFDB").cgColor
    }
    
    @IBAction func VerifyBtnTapped(_ sender: UIButton)
    {
        if (textView.hasText && textView.text!.count > 3)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier:"RegisterUserViewController") as! RegisterUserViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString astring: String) -> Bool
    {
        // textfield changed character
        var currentString: NSString = textField.text! as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: astring) as NSString
        return true
        // return NO to not change text
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        // textfield changed
        
        if (textField.text!.count > 3)
        {
            textField.resignFirstResponder()
        }
        
        let variable : [Int] = common.splitStringIntoArrayForOTP(textField.text! as String)

        switch(variable.count)
        {
        case 1:
                firstLbl.text = String(variable[0])
                secondLbl.text = ""
                thirdLbl.text = ""
                fourthLbl.text = ""
                
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                break
        case 2:
                firstLbl.text = String(variable[0])
                secondLbl.text = String(variable[1])
                thirdLbl.text = ""
                fourthLbl.text = ""
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
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
                break
        case 4:
                firstLbl.text = String(variable[0])
                secondLbl.text = String(variable[1])
                thirdLbl.text = String(variable[2])
                fourthLbl.text = String(variable[3])
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(secondLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(thirdLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                common.applyBorderToView(fourthLbl, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2.0)
                break
        default:
                firstLbl.text = ""
                common.applyBorderToView(firstLbl, withColor: common.hexStringToUIColor(hex: "#CECFDB"), ofSize: 1.0)
            break
        }
        
        if (textField.text!.count >= 4)
        {
            verifyBtn.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")
            verifyBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            textField.resignFirstResponder()
        }
        else
        {
            verifyBtn.backgroundColor = common.hexStringToUIColor(hex: "#F2F3FF")
            verifyBtn.setTitleColor( common.hexStringToUIColor(hex: "#172B4D"), for: UIControl.State.normal)
        }
    }
}

