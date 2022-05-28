//
//  AgentSignInViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 22/11/21.
//

import Foundation
import UIKit

class AgentSignInViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var userIDLbl : UILabel!
    @IBOutlet weak var createPassLbl : UILabel!
    @IBOutlet weak var confirmPassLbl : UILabel!
    
    @IBOutlet weak var userId : UITextField!
    @IBOutlet weak var createPass : UITextField!
    @IBOutlet weak var confirmPass : UITextField!
    
    @IBOutlet weak var continueBtn : UIButton!
    @IBOutlet weak var backBtn : UIButton!
    
    @IBOutlet weak var confirmView : UIView!
    @IBOutlet weak var passImage : UIImageView!
    @IBOutlet weak var passLbl : UILabel!

    @IBOutlet weak var headerLabel: UILabel!
    
    private let common = Common.sharedCommon
    var stringName : String!
    
    override func viewDidLoad() {
        confirmView.isHidden = true
        userIDLbl.isHidden = true
        createPassLbl.isHidden = true
        confirmPassLbl.isHidden = true
        
        common.applyRoundedShapeToView(userId, withRadius: 5)
        common.applyRoundedShapeToView(createPass, withRadius: 5)
        common.applyRoundedShapeToView(confirmPass, withRadius: 5)
        common.applyRoundedShapeToView(continueBtn, withRadius: 10)

        common.applyBorderToView(userId, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1.0)
        common.applyBorderToView(createPass, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1.0)
        common.applyBorderToView(confirmPass, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1.0)
        
        let myColor = common.hexStringToUIColor(hex: "#929BAA")
        continueBtn.setTitleColor(myColor, for: UIControl.State.normal)

        if (stringName.hasPrefix("Agent"))
        {
            userIDLbl.text = "User Id"
            userId.placeholder = "User Id"
            headerLabel.text = "Agent Sign Up"
        }
        else
        {
            userIDLbl.text = "Employee Id"
            userId.placeholder = "Employee Id"
            headerLabel.text = "Employee Sign Up"
        }
    }
    
    @IBAction func continueTapped (_ sender: UIButton)
    {
        userId.resignFirstResponder()
        createPass.resignFirstResponder()
        confirmPass.resignFirstResponder()
        if (confirmPass.text!.elementsEqual(createPass.text!))
        {
            if (!userId.text!.isEmpty && !createPass.text!.isEmpty && !confirmPass.text!.isEmpty)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var secondViewController : UIViewController
                if (stringName.hasPrefix("Agent"))
                {
                    secondViewController = storyboard.instantiateViewController(withIdentifier:"SecondViewController") as! SecondViewController
                }
                else
                {
                    secondViewController = storyboard.instantiateViewController(withIdentifier:"ViewController") as! ViewController
                }
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
        }
    }

    @IBAction func backBtnTapped (_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 1000:
                userIDLbl.isHidden = false
                userId.placeholder = ""
                if (!createPass.hasText)
                {
                    createPassLbl.isHidden = true
                    createPass.placeholder = "Create Password"
                }
                if (!confirmPass.hasText)
                {
                    confirmPassLbl.isHidden = true
                    confirmPass.placeholder = "Confirm Password"
                }
            break
        case 1001:
                createPassLbl.isHidden = false
                createPass.placeholder = ""
                if (!userId.hasText)
                {
                    userIDLbl.isHidden = true
                    if (stringName.hasPrefix("Agent"))
                    {
                        userId.placeholder = "User Id"
                    }
                    else
                    {
                        userId.placeholder = "Employee Id"
                    }
                }
                if (!confirmPass.hasText)
                {
                    confirmPassLbl.isHidden = true
                    confirmPass.placeholder = "Confirm Password"
                }
            break
        case 1002:
                confirmPassLbl.isHidden = false
                confirmPass.placeholder = ""
                if (!createPass.hasText)
                {
                    createPassLbl.isHidden = true
                    createPass.placeholder = "Create Password"
                }
                if (!userId.hasText)
                {
                    userIDLbl.isHidden = true
                    if (stringName.hasPrefix("Agent"))
                    {
                        userId.placeholder = "User Id"
                    }
                    else
                    {
                        userId.placeholder = "Employee Id"
                    }
                }
                break
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let tagValue = textField.tag
        var currentString: NSString = textField.text! as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: string) as NSString

       switch (tagValue)
        {
       case 1000:
                createPass.resignFirstResponder()
               confirmPass.resignFirstResponder()
           break
       case 1001:
               userId.resignFirstResponder()
               confirmPass.resignFirstResponder()
           break
       case 1002:
              userId.resignFirstResponder()
              createPass.resignFirstResponder()
           break
       default:
           break
       }
        return true
        // return NO to not change text
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (confirmPass.hasText && createPass.hasText)
        {
            if (confirmPass.text!.elementsEqual(createPass.text!))
            {
                confirmView.isHidden = false
                passImage.image = UIImage.init(named: "Confirm")
                passLbl.text = "Password confirmed"
                passLbl.textColor = common.hexStringToUIColor(hex: "#172B4D")
            }
            else
            {
                confirmView.isHidden = false
                passImage.image = UIImage.init(named: "Not Confirm")
                passLbl.text = "Password didn't match"
                passLbl.textColor = UIColor.red
            }
        }
        else
        {
            confirmView.isHidden = true
        }
        if (!userId.text!.isEmpty && !createPass.text!.isEmpty && !confirmPass.text!.isEmpty)
        {
            continueBtn.titleLabel!.font = UIFont.init(name: "Montserrat-SemiBold", size: 14.0)
            continueBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            continueBtn.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")
        }
        else
        {
            continueBtn.titleLabel!.font = UIFont.init(name: "Montserrat-Regular", size: 14.0)
            let myColor = common.hexStringToUIColor(hex: "#929BAA")
            continueBtn.setTitleColor(myColor, for: UIControl.State.normal)
            continueBtn.backgroundColor = common.hexStringToUIColor(hex: "#F2F3FF")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
