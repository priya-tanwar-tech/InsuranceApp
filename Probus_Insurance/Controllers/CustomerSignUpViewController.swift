//
//  CustomerSignUpViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 26/11/21.
//

import Foundation
import UIKit

class CustomerSignUpViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var maleBackgroundView: UIView!
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var maleCenterView: UIView!
    
    @IBOutlet weak var femaleBackgroundView: UIView!
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var femaleCenterView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var dateOFBirthLabel: UILabel!
    @IBOutlet weak var InvalidAgeView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var InvalidMailView: UIView!
    
    @IBOutlet weak var countinueBtn: UIButton!
    
    @IBOutlet weak var invalidAgeLbl: UILabel!
    @IBOutlet weak var invalidMailLbl: UILabel!
    @IBOutlet weak var manufacturePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var selectDate: UIButton!
    
    private let common = Common.sharedCommon
    private var date = Date()
    
    override func viewDidLoad()
    {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationController?.edgesForExtendedLayout = []
        
        dateLabel.text = "Date Of Birth"
        ageLabel.text = "0 years"
        
        nameLabel.isHidden = true
        dateOFBirthLabel.isHidden = true
        emailLabel.isHidden = true
        InvalidAgeView.isHidden = true
        InvalidMailView.isHidden = true
        
        common.applyRoundedShapeToView(countinueBtn, withRadius: 10)
        common.applyRoundedShapeToView(dateBackgroundView, withRadius: 10)
        common.applyRoundedShapeToView(maleBackgroundView, withRadius: 10)
        common.applyRoundedShapeToView(femaleBackgroundView, withRadius: 10)
        common.applyRoundedShapeToView(ageLabel, withRadius: 10)
        common.applyRoundedShapeToView(selectDate, withRadius: 5)

        setRadioButtonValue(true)
        
        common.applyRoundedShapeToView(dateBackgroundView, withRadius: 5)
        common.applyBorderToView(dateBackgroundView, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1.0)
        dateBackgroundView.backgroundColor = UIColor.white

        common.applyRoundedShapeToView(nameTextField, withRadius: 5)
        common.applyBorderToView(nameTextField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1.0)
        
        common.applyRoundedShapeToView(emailTextField, withRadius: 5)
        common.applyBorderToView(emailTextField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1.0)

        manufacturePicker.maximumDate = Date()
//        manufacturePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.GenderSelect(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.GenderSelect(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.dateSelect(_:)))
        maleBackgroundView.addGestureRecognizer(tap1)
        femaleBackgroundView.addGestureRecognizer(tap2)
        dateBackgroundView.addGestureRecognizer(tap3)
    }
    
    func setRadioButtonValue(_ IsMale: Bool)
    {
        if (IsMale)
        {
            common.applyRoundedShapeToView(maleBackgroundView, withRadius: 5)
            common.applyRoundedShapeToView(maleImageView, withRadius: maleImageView.frame.size.height/2)
            common.applyRoundedShapeToView(maleCenterView, withRadius: maleCenterView.frame.size.height/2)
            common.applyBorderToView(maleBackgroundView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)
            common.applyBorderToView(maleImageView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)
            maleCenterView.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")
            
            common.applyRoundedShapeToView(femaleBackgroundView, withRadius: 5)
            common.applyRoundedShapeToView(femaleImageView, withRadius: femaleImageView.frame.size.height/2)
            common.applyRoundedShapeToView(femaleCenterView, withRadius: femaleCenterView.frame.size.height/2)
            common.applyBorderToView(femaleBackgroundView, withColor: Colors.textFldColor, ofSize: 1.0)
            common.applyBorderToView(femaleImageView, withColor: Colors.textFldColor, ofSize: 2.0)
            femaleCenterView.backgroundColor = UIColor.clear
        }
        else
        {
            common.applyRoundedShapeToView(femaleBackgroundView, withRadius: 5)
            common.applyRoundedShapeToView(femaleImageView, withRadius: femaleImageView.frame.size.height/2)
            common.applyRoundedShapeToView(femaleCenterView, withRadius: femaleCenterView.frame.size.height/2)

            common.applyBorderToView(femaleBackgroundView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)
            common.applyBorderToView(femaleImageView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)
            femaleCenterView.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")

            common.applyRoundedShapeToView(maleBackgroundView, withRadius: 5)
            common.applyRoundedShapeToView(maleCenterView, withRadius: maleCenterView.frame.size.height/2)
            common.applyRoundedShapeToView(maleImageView, withRadius: maleImageView.frame.size.height/2)
            
            common.applyBorderToView(maleBackgroundView, withColor: Colors.textFldColor, ofSize: 1.0)
            common.applyBorderToView(maleImageView, withColor: Colors.textFldColor, ofSize: 2.0)
            maleCenterView.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func backBtnTapped()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func GenderSelect(_ sender: UITapGestureRecognizer? = nil) {
        let vi = sender?.view
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        if (vi!.isDescendant(of: maleBackgroundView))
        {
            setRadioButtonValue(true)
        }
        else
        {
            setRadioButtonValue(false)
        }
    }

    @objc func dateSelect(_ sender: UITapGestureRecognizer? = nil) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        pickerView.isHidden = false
    }
    
    @IBAction func continueTapped()
    {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        
        if (nameTextField.hasText && emailTextField.hasText && InvalidAgeView.isHidden && InvalidMailView.isHidden && !(dateLabel.text!.contains("Date Of Birth")))
        {
            common.goToNextScreenWith("ViewController", self)
            // countinue tapped
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 1004:
              common.setTextFieldLabels(nameTextField, nameLabel, false, "")
              if (!emailTextField.hasText)
              {
                  emailLabel.isHidden = true
              }
              else
              {
                  emailLabel.isHidden = false
              }
            break
        default:
                common.setTextFieldLabels(emailTextField, emailLabel, false, "")
                if (!nameTextField.hasText)
                {
                    nameLabel.isHidden = true
                }
                else
                {
                    nameLabel.isHidden = false
                }
            break
        }
         
        return true
    }
    
    @IBAction func dateIsSelected(_ sender: UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: manufacturePicker.date)
        
        let components = manufacturePicker.calendar.dateComponents([.year], from: manufacturePicker.date)
        let dobAge = DateComponents(calendar: .current, year: components.year).date!
        dateLabel.text = dateString
        let ageString = String.init(stringLiteral: String(dobAge.age)+" years")
        ageLabel.text = ageString

        if (dobAge.age > 17)
        {
            InvalidAgeView.isHidden = true
        }
        else
        {
            InvalidAgeView.isHidden = false
            let alertVu = SCLAlertView.init(appearance: common.alertwithCancel)
            alertVu.showInfo("Alert!", subTitle: "Minimum age should be 18", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
        }
        highlightBtn()
        pickerView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (nameTextField.isFirstResponder)
        {
            emailTextField.resignFirstResponder()
        }
        else
        {
            nameTextField.resignFirstResponder()
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
        if (emailTextField.isFirstResponder)
        {
            let boolValue = common.isValidEmail(textField.text!)
            if (!boolValue)
            {
                InvalidMailView.isHidden = false
            }
            else
            {
                InvalidMailView.isHidden = true
            }
        }
        highlightBtn()
    }

    private func highlightBtn()
    {
        if (nameTextField.hasText && !dateLabel.text!.elementsEqual("Date Of Birth") && InvalidAgeView.isHidden && InvalidMailView.isHidden && emailTextField.hasText)
        {
            countinueBtn.titleLabel!.font = UIFont.init(name: "Montserrat-SemiBold", size: 14.0)
            countinueBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            countinueBtn.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")
        }
        else
        {
                countinueBtn.titleLabel!.font = UIFont.init(name: "Montserrat-Regular", size: 14.0)
                let myColor = common.hexStringToUIColor(hex: "#929BAA")
                countinueBtn.setTitleColor(myColor, for: UIControl.State.normal)
                countinueBtn.backgroundColor = common.hexStringToUIColor(hex: "#F2F3FF")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
