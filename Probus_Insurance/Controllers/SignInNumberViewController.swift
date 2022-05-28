//
//  SignInNumberViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 19/11/21.
//

import Foundation
import UIKit


class SignInNumberViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var txtLbl: UILabel!
    @IBOutlet weak var textfieldVu: UITextField!
    @IBOutlet weak var continueBtn: UIButton!

    @IBOutlet weak var welcomeTopView: NSLayoutConstraint!
    @IBOutlet weak var topView: NSLayoutConstraint!
    @IBOutlet weak var mobileTopView: NSLayoutConstraint!
    @IBOutlet weak var descTopView: NSLayoutConstraint!
    
    private let common = Common.sharedCommon

    override func viewDidLoad()
    {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationController?.edgesForExtendedLayout = []
        
        common.applyRoundedShapeToView(continueBtn, withRadius: 10.0)
        common.applyRoundedShapeToView(textfieldVu, withRadius: 5)
        common.applyBorderToView(textfieldVu, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        welcomeTopView.constant = 5
        mobileTopView.constant = 5
        descTopView.constant = 0
        topView.constant = 10
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        welcomeTopView.constant = 50
        mobileTopView.constant = 23
        descTopView.constant = 5
        topView.constant = 30
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // textfield changed character
        var currentString: NSString = textField.text! as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: string.trimmingCharacters(in: .whitespacesAndNewlines)) as NSString
        
        return true
        // return NO to not change text
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        // textfield changed
        let contval : Int = textField.text!.count

        if (contval > 13)
        {
            continueBtn.backgroundColor = common.hexStringToUIColor(hex: "#0FACC8")
            continueBtn.titleLabel?.font = UIFont.init(name: "Montserrat-SemiBold", size: 14.0)
            continueBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            textField.resignFirstResponder()
        }
        else
        {
            continueBtn.backgroundColor = common.hexStringToUIColor(hex: "#EFEFEF")
            continueBtn.setTitleColor(common.hexStringToUIColor(hex: "#172B4D"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func contineMyWork(_ sender: UIButton)
    {
        let countVal : Int = textfieldVu.text!.count
        if(countVal > 13)
        {
            textfieldVu.resignFirstResponder()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier:"PhoneOtpViewController") as! PhoneOtpViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    
    @IBAction func showMyPrivacyPolicy(_ sender: UIButton)
    {
        
    }
}

