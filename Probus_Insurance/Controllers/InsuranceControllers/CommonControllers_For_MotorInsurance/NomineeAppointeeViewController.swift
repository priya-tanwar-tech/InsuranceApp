//
//  NomineeAppointeeViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 10/12/21.
//

import Foundation
import UIKit

class NomineeAppointeeViewController : UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollVu: UIScrollView!
    
    @IBOutlet weak var continueVu: UIButton!
    @IBOutlet weak var myProgressBar: UIProgressView!

    @IBOutlet weak var nomineeVu: UIView!
    @IBOutlet weak var nominee: UITextField!
    @IBOutlet weak var nomineeLbl: UILabel!

    @IBOutlet weak var RelationVu: UIView!
    @IBOutlet weak var relation: UILabel!
    @IBOutlet weak var relationLbl: UILabel!

    @IBOutlet weak var dobVu: UIView!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var dobLbl: UILabel!

    @IBOutlet weak var appointeeContainer: UIView!

    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var quotationLabel: UILabel!

    @IBOutlet weak var manufacturePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var selectDate: UIButton!

    @IBOutlet weak var maleBackgroundView : UIView!
    @IBOutlet weak var maleImageView : UIImageView!
    @IBOutlet weak var maleView : UIView!

    @IBOutlet weak var femaleBackgroundView : UIView!
    @IBOutlet weak var femaleImageView : UIImageView!
    @IBOutlet weak var femaleView : UIView!

    @IBOutlet weak var appointeeVu: UIView!
    @IBOutlet weak var appointee: UITextField!
    @IBOutlet weak var appointeeLbl: UILabel!

    @IBOutlet weak var RelateVu: UIView!
    @IBOutlet weak var relate: UILabel!
    @IBOutlet weak var relateLbl: UILabel!

    @IBOutlet weak var dobAppVu: UIView!
    @IBOutlet weak var dobApp: UILabel!
    @IBOutlet weak var dobAppLbl: UILabel!

    @IBOutlet weak var appoShow: NSLayoutConstraint!
    @IBOutlet weak var appTop: NSLayoutConstraint!
    
    @IBOutlet weak var apiTable: UIView!
    @IBOutlet weak var apiTableView : UITableView!
    @IBOutlet weak var apiTableTop: NSLayoutConstraint!
    @IBOutlet weak var keyboardView : NSLayoutConstraint!

    private var RelationArray : NSArray!
    private let dict = NSMutableDictionary.init()

    private let common = Common.sharedCommon
    private var isNominee = true // dobapp
    private var keyboardIsOpen = false
    private let def = Common.sharedCommon.sharedUserDefaults()

    enum PersonGender {
        case male
        case female
    }
    private var perGender = PersonGender.male
    
    override func viewDidLoad() {
        let vehiclName = def.string(forKey: "MakeName")! + " " + def.string(forKey: "ModelName")! + " " + def.string(forKey: "VariantName")!
        vehicleDetails.text = vehiclName
        quotationLabel.text = def.string(forKey: "QuotationNumber")
        if (def.dictionary(forKey: "NomineeAppointeeDetails") != nil)
        {
            dict.addEntries(from: def.dictionary(forKey: "NomineeAppointeeDetails")!)
        }

        apiTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        common.applyShadowToView(apiTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)

        var v : Int!
        if (def.dictionary(forKey: "PrevPolicyExpiryStatus") != nil)
        {
            let ki = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
            v = Int(ki.object(forKey: "Id") as! String)
        }

        if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
        {
            myProgressBar.setProgress((6/7), animated: true)
        }
        else
        {
            myProgressBar.setProgress((5/6), animated: true)
        }
        var vehicleType = ""
        switch(def.integer(forKey: "ProductCode"))
        {
        case 2:
            vehicleType = common.privatecar
            break
        default:
            vehicleType = common.twowheeler
            break
        }
        let url = common.A_P_I+common.baseURL+common.forApi+common.motor+vehicleType+common.Relationship+common.company+def.string(forKey: "ThisCompany")!
        APICallered().fetchData(url) { response in
            self.RelationArray = response?.object(forKey: "Response") as? NSArray
            DispatchQueue.main.async {
                self.apiTableView.reloadData()
            }
        }

        common.applyRoundedShapeToView(nominee, withRadius: 5)
        common.applyRoundedShapeToView(RelationVu, withRadius: 5)
        common.applyRoundedShapeToView(dobVu, withRadius: 5)
        common.applyRoundedShapeToView(appointee, withRadius: 5)
        common.applyRoundedShapeToView(RelateVu, withRadius: 5)
        common.applyRoundedShapeToView(dobAppVu, withRadius: 5)
        common.applyRoundedShapeToView(continueVu, withRadius: 10)
        common.applyRoundedShapeToView(selectDate, withRadius: 5)

        setTextFieldValues()
        visibilityOFAppointee()
        textFieldLabel()
        setRadioButtonValue()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
   
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.continueTapp(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        continueVu.addGestureRecognizer(tap1)
        dobVu.addGestureRecognizer(tap2)
        dobAppVu.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.RelationTapped(_:)))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.RelationTapped(_:)))
        RelationVu.addGestureRecognizer(tap4)
        RelateVu.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(self.GenderSelect(_:)))
        let tap7 = UITapGestureRecognizer(target: self, action: #selector(self.GenderSelect(_:)))
        maleBackgroundView.addGestureRecognizer(tap6)
        femaleBackgroundView.addGestureRecognizer(tap7)
    }
    
    
    @objc func GenderSelect(_ sender: UITapGestureRecognizer? = nil) {
        let vi = sender?.view
        apiTable.isHidden = true
        nominee.resignFirstResponder()
        appointee.resignFirstResponder()

        if (vi!.isDescendant(of: maleBackgroundView))
        {
            perGender = .male
        }
        else
        {
            perGender = .female
        }
        setRadioButtonValue()
    }

    func setRadioButtonValue()
    {
        var k = "Male"
        switch(perGender)
        {
        case .male:
                common.applyRoundedShapeToView(maleBackgroundView, withRadius: 5)
                common.applyBorderToView(maleBackgroundView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)

                common.applyRoundedShapeToView(maleImageView, withRadius: maleImageView.frame.size.height/2)
                common.applyBorderToView(maleImageView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)

                common.applyRoundedShapeToView(maleView, withRadius: maleView.frame.size.height/2)
                maleView.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")
                
                
                common.applyRoundedShapeToView(femaleBackgroundView, withRadius: 5)
                common.applyBorderToView(femaleBackgroundView, withColor: Colors.textFldColor, ofSize: 1.0)

                common.applyRoundedShapeToView(femaleImageView, withRadius: femaleImageView.frame.size.height/2)
                common.applyBorderToView(femaleImageView, withColor: Colors.textFldColor, ofSize: 2.0)

                common.applyRoundedShapeToView(femaleView, withRadius: femaleView.frame.size.height/2)
                femaleView.backgroundColor = UIColor.clear
                break
        case .female:
                k = "Female"
                common.applyRoundedShapeToView(femaleBackgroundView, withRadius: 5)
                common.applyBorderToView(femaleBackgroundView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)

                common.applyRoundedShapeToView(femaleImageView, withRadius: femaleImageView.frame.size.height/2)
                common.applyBorderToView(femaleImageView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)

                common.applyRoundedShapeToView(femaleView, withRadius: femaleView.frame.size.height/2)
                femaleView.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")


                common.applyRoundedShapeToView(maleBackgroundView, withRadius: 5)
                common.applyBorderToView(maleBackgroundView, withColor: Colors.textFldColor, ofSize: 1.0)

                common.applyRoundedShapeToView(maleView, withRadius: maleView.frame.size.height/2)
                common.applyBorderToView(maleImageView, withColor: Colors.textFldColor, ofSize: 2.0)

                common.applyRoundedShapeToView(maleImageView, withRadius: maleImageView.frame.size.height/2)
                maleView.backgroundColor = UIColor.clear
                break
        }
        dict.setValue(k, forKey: "NomineeGender")
    }
    
    
    @IBAction func continueTapp(_ sender: UIButton) {
        keyboardIsOpen = false
        nominee.resignFirstResponder()
        appointee.resignFirstResponder()
        visibilityOFAppointee()
        
            if (nominee.hasText || !dobLbl.isHidden || !relationLbl.isHidden)
            {
                if (!appointeeContainer.isHidden)
                {
                    if (!appointee.hasText || dobAppLbl.isHidden || relateLbl.isHidden)
                    {
                        displayAlert()
                    }
                    else
                    {
                        def.set(dict, forKey: "NomineeAppointeeDetails")
                        def.synchronize()

                        common.goToNextScreenWith("MotorAgreementController", self)
                    }
                }
                else
                {
                    def.set(dict, forKey: "NomineeAppointeeDetails")
                    def.synchronize()

                    common.goToNextScreenWith("MotorAgreementController", self)
                }
            }
            else
            {
                displayAlert()
            }
    }
    
    private func setTextFieldValues()
    {
        if (dict.object(forKey: "NomineeName") !=  nil)
        {
            nominee.text = (dict.object(forKey: "NomineeName") as! String)
        }
        if (dict.object(forKey: "NomineeDateOfBirth") !=  nil)
        {
            dob.text = (dict.object(forKey: "NomineeDateOfBirth") as! String)
            dobLbl.isHidden = false
        }
        if (!appointeeContainer.isHidden)
        {
            if (dict.object(forKey: "AppointeeName") !=  nil)
            {
                appointee.text = (dict.object(forKey: "AppointeeName") as! String)
            }
            if (dict.object(forKey: "AppointeeDateOfBirth") !=  nil)
            {
                dobApp.text = (dict.object(forKey: "AppointeeDateOfBirth") as! String)
                dobAppLbl.isHidden = false
            }
        }
    }
    
    private func displayAlert()
    {
        common.removeImageForRestriction(nominee!)
        common.removeImageForRestriction(dob!)
        common.removeImageForRestriction(relation!)
        if (!nominee.hasText)
        {
            common.displayImageForRestriction(nominee!)
        }
        if (dobLbl.isHidden)
        {
            common.displayImageForRestriction(dob!)
        }
        if (relationLbl.isHidden)
        {
            common.displayImageForRestriction(relation!)
        }

        if (!appointeeContainer.isHidden)
        {
            common.removeImageForRestriction(dobApp!)
            common.removeImageForRestriction(appointee!)
            common.removeImageForRestriction(relate!)
            if (!appointee.hasText)
            {
                common.displayImageForRestriction(appointee!)
            }
            if (dobAppLbl.isHidden)
            {
                common.displayImageForRestriction(dobApp!)
            }
            if (relateLbl.isHidden)
            {
                common.displayImageForRestriction(relate!)
            }
        }
    }
    
    @IBAction func dateIsSelected(_ sender: UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: manufacturePicker.date)
        
        let k = def.object(forKey: "ThisCompany") as! String
        var checkAge = 21
        if (k.elementsEqual("CHOLAMANDLAM"))
        {
            checkAge = 18
        }
        
        if (isNominee)
        {
            let components = manufacturePicker.calendar.dateComponents([.year], from: manufacturePicker.date)
            let dobAge = DateComponents(calendar: .current, year: components.year).date!
            dob.text = dateString
            dobLbl.isHidden = false
            dict.setValue(dateString, forKey: "NomineeDateOfBirth")

            if (dobAge.age > checkAge)
            {
                hideMyView(true)
            }
            else
            {
                hideMyView(false)
            }
        }
        else
        {
//            let components = manufacturePicker.calendar.dateComponents([.year], from: manufacturePicker.date)
            dobApp.text = dateString
            dobAppLbl.isHidden = false
            dict.setValue(dateString, forKey: "AppointeeDateOfBirth")
        }
        pickerView.isHidden = true
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        nominee.resignFirstResponder()
        appointee.resignFirstResponder()
        manufacturePicker.maximumDate = Date()
        let vi = sender?.view
        if (vi!.isDescendant(of: dobVu))
        {
            isNominee = true
            if (!dob.text!.isEmpty && !dob.text!.elementsEqual("Date of Birth*"))
            {
                manufacturePicker.date = common.convertStringIntoDate(dob.text!)
            }
            manufacturePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -5, to: Date())
        }
        else
        {
            isNominee = false
            let k = def.object(forKey: "ThisCompany") as! String
            var checkAge = 21
            if (k.elementsEqual("CHOLAMANDLAM"))
            {
                checkAge = 18
            }
            if (!dobApp.text!.isEmpty && !dobApp.text!.elementsEqual("Date of Birth*"))
            {
                manufacturePicker.date = common.convertStringIntoDate(dobApp.text!)
            }
            manufacturePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -checkAge, to: Date())
        }
        pickerView.isHidden = false
    }
    
    @objc func RelationTapped(_ sender: UITapGestureRecognizer? = nil) {
        nominee.resignFirstResponder()
        appointee.resignFirstResponder()
        let vi = sender?.view
        apiTable.isHidden = false

        if (vi!.isDescendant(of: RelationVu))
        {
            placeMyTableViewAround(thisView: RelationVu, andAT_BottomTop: false)
            isNominee = true
        }
        else
        {
            placeMyTableViewAround(thisView: RelateVu, andAT_BottomTop: true)
            isNominee = false
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if (!keyboardIsOpen)
            {
                keyboardIsOpen = true
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyboardView.constant = keyboardHeight
            }
        }
    }

    private func visibilityOFAppointee()
    {
        let k = def.object(forKey: "ThisCompany") as! String
        var checkAge = 21
        if (k.elementsEqual("CHOLAMANDLAM"))
        {
            checkAge = 18
        }

        hideMyView(true)

        if (!(dob.text!.contains("Date of Birth")))
        {
            let dateNom = common.convertStringIntoDate(dob.text!).age
            if (!(dateNom > checkAge))
            {
                hideMyView(false)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabel()
        keyboardIsOpen = false
        keyboardView.constant = 0
    }

    @IBAction func backBtnTapped(_ sender: UIButton)
    {
        def.synchronize()

        self.navigationController?.popViewController(animated: true)
    }
    
    func hideMyView(_ hide: Bool) {
        var constraintV: NSLayoutConstraint!
        if (hide)
        {
            constraintV = common.ShowAndHideView(ConstarintIs: appoShow, isHidden: hide, andSize: 0.0001)
        }
        else
        {
            constraintV = common.ShowAndHideView(ConstarintIs: appoShow, isHidden: hide, andSize: 0.4)
        }
        dict.setValue(!hide, forKey: "IsApointeeRequired")
        appointeeContainer.isHidden = hide
        appoShow.isActive = false
        appoShow = nil
        appoShow = constraintV
        constraintV = nil
        NSLayoutConstraint.activate([appoShow])
        appointeeContainer.layoutIfNeeded()
    }
    
    private func placeMyTableViewAround(thisView view: UIView,andAT_BottomTop topBottom: Bool)
    {
        var heightConstraint : NSLayoutConstraint!
        if (topBottom) // bottom
        {
            heightConstraint = NSLayoutConstraint.init(item: apiTableTop.firstItem as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 10)
        }
        else
        {
            heightConstraint = NSLayoutConstraint.init(item: apiTableTop.firstItem as Any, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 10)
        }
        apiTableTop.isActive = false
        apiTableTop = nil
        apiTableTop = heightConstraint
        heightConstraint = nil
        NSLayoutConstraint.activate([apiTableTop])
        apiTable.layoutIfNeeded()
        view.layoutIfNeeded()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textFieldLabel()
        textField.resignFirstResponder()
        return true
    }
    
    private func textFieldLabel()
    {
        common.applyBorderToView(nominee, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(RelationVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(dobVu, withColor: Colors.textFldColor, ofSize: 1)
        
        common.applyBorderToView(appointee, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(RelateVu, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(dobAppVu, withColor: Colors.textFldColor, ofSize: 1)

        if (!appointee.hasText)
        {
            common.setTextFieldLabels(appointee, appointeeLbl, true, appointeeLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(appointee, appointeeLbl, false, "")
        }
        if (!nominee.hasText)
        {
            common.setTextFieldLabels(nominee, nomineeLbl, true, nomineeLbl.text!)
        }
        else
        {
            common.setTextFieldLabels(nominee, nomineeLbl, false, "")
        }

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 7:
                common.setTextFieldLabels(nominee, nomineeLbl, false, "")
                break
        default:
                common.setTextFieldLabels(appointee, appointeeLbl, false, "")
                break
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 7:
                dict.setValue(textField.text!, forKey: "NomineeName")
                break
        default:
                dict.setValue(textField.text!, forKey: "AppointeeName")
                break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        textFieldLabel()
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)

        var currentString: NSString = textField.text!.capitalized as NSString
        if ((string.rangeOfCharacter(from: NSCharacterSet.letters) != nil) || (string.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil) || string.isEmpty)
        {
            currentString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return true
        }
        else
        {
            let alertVu = SCLAlertView.init(appearance: common.alertwithCancel)
            alertVu.showError("Alert!", subTitle: "Only letters are allowed.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (RelationArray == nil)
        {
            return 0
        }
        return RelationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
        let nameDict = (RelationArray[indexPath.row]) as? NSDictionary
        let string = (nameDict?.object(forKey: "Name") as! String)
        cell.setDispaly(string)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nominee.resignFirstResponder()
        appointee.resignFirstResponder()

        let nameDict = (RelationArray[indexPath.row]) as? NSDictionary
        if (isNominee)
        {
            relation.text = (nameDict!.object(forKey: "Name") as! String)
            dict.setValue(nameDict!.object(forKey: "Id"), forKey: "NomineeRelation")
            relationLbl.isHidden = false
        }
        else
        {
            dict.setValue(nameDict!.object(forKey: "Id"), forKey: "AppointeeRelation")
            relate.text = (nameDict!.object(forKey: "Name") as! String)
            relateLbl.isHidden = false
        }
        tableView.superview!.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

