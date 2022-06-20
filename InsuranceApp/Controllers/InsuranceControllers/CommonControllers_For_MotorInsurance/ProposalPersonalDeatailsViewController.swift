//
//  ProposalPersonalDeatailsViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 09/12/21.
//

import Foundation
import UIKit

class ProposalPersonalDeatailsViewController : UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var myProgressBar: UIProgressView!
    @IBOutlet weak var proposalView: UIView!
    
    @IBOutlet weak var salutationView: UIView!
    @IBOutlet weak var salutationLbl: UILabel!
    @IBOutlet weak var salutation: UILabel!

    @IBOutlet weak var firstNameVu: UIView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var firstName: UITextField!

    @IBOutlet weak var midNameVu: UIView!
    @IBOutlet weak var midNameLbl: UILabel!
    @IBOutlet weak var midName: UITextField!

    @IBOutlet weak var lastNameVu: UIView!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var lastName: UITextField!

    @IBOutlet weak var maleBackgroundView : UIView!
    @IBOutlet weak var maleImageView : UIImageView!
    @IBOutlet weak var maleView : UIView!

    @IBOutlet weak var femaleBackgroundView : UIView!
    @IBOutlet weak var femaleImageView : UIImageView!
    @IBOutlet weak var femaleView : UIView!
    
    @IBOutlet weak var maritalView: UIView!
    @IBOutlet weak var maritalLbl: UILabel!
    @IBOutlet weak var marital: UILabel!

    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var dob: UILabel!

    @IBOutlet weak var educationView: UIView!
    @IBOutlet weak var educationLbl: UILabel!
    @IBOutlet weak var education: UILabel!

    @IBOutlet weak var continueVu: UIButton!

    @IBOutlet weak var saluteTable: UIView!
    @IBOutlet weak var statusTable: UIView!
    @IBOutlet weak var eduTable: UIView!

    @IBOutlet weak var saluteTableView: UITableView!
    @IBOutlet weak var statusTableView: UITableView!
    @IBOutlet weak var eduTableView: UITableView!

    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var quotationLabel: UILabel!
    @IBOutlet weak var proposalTitle: UILabel!

    @IBOutlet weak var saluteTableShow: NSLayoutConstraint!
    @IBOutlet weak var statusTableShow: NSLayoutConstraint!
    @IBOutlet weak var occuTableShow: NSLayoutConstraint!
    
    @IBOutlet weak var manufacturePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var selectDate: UIButton!
    @IBOutlet weak var keyBoardView: NSLayoutConstraint!
    private var keyboardIsOpen = false

    private let common = Common.sharedCommon
    private let dict = NSMutableDictionary.init()
    var status : NSArray!
    var ocupationArray : NSArray!
    var SalutationArr : NSArray!
    
    enum PersonGender {
        case male
        case female
    }
    private var perGender = PersonGender.male
    
    override func viewDidLoad() {
        let def = common.sharedUserDefaults()
        if (def.dictionary(forKey: "ClientDetails") != nil)
        {
            dict.addEntries(from: def.dictionary(forKey: "ClientDetails")!)
        }

        if (def.string(forKey: "CustomerType")!.elementsEqual("Organisation"))
        {
            proposalTitle.text = "Owner/Proprietor Details"
        }
        
        var v : Int!
        if (def.dictionary(forKey: "PrevPolicyExpiryStatus") != nil)
        {
            let ki = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
            v = Int(ki.object(forKey: "Id") as! String)
        }

        if (!def.bool(forKey: "DontKnowPreviousInsurer") && ((v != 2) && v != nil))
        {
            myProgressBar.setProgress((1/7), animated: true)
        }
        else
        {
            myProgressBar.setProgress((1/6), animated: true)
        }
        
        let vehiclName = def.string(forKey: "MakeName")! + " " + def.string(forKey: "ModelName")! + " " + def.string(forKey: "VariantName")!
        vehicleDetails.text = vehiclName
        quotationLabel.text = def.string(forKey: "QuotationNumber")

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let def = common.sharedUserDefaults()
        if (def.dictionary(forKey: "ClientDetails") != nil)
        {
            dict.addEntries(from: def.dictionary(forKey: "ClientDetails")!)
        }
        
        manufacturePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        showAndHideListView(statusTable, true)
        showAndHideListView(saluteTable, true)
        showAndHideListView(eduTable, true)

        loadApiData()
        registerTableViewCells()
        setTextFieldValues()
        addRoundedShapesToViews()
        textFieldLabel()
        addShadowsToViews()
        setRadioButtonValue()
        addTapGesturesToView()
    }
    
    private func addShadowsToViews()
    {
        common.applyShadowToView(statusTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(saluteTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        common.applyShadowToView(eduTable, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
    }
    
    @IBAction func refreshBtnTapped(_ sender: Any) {
        
    }
    
    private func showAndHideListView(_ aVu: UIView, _ hide: Bool)
    {
        let thsiView : UITableView! = aVu.subviews[0] as? UITableView
        var high = 150.0
        if (hide)
        {
            high = 0.1
        }
        switch (thsiView.tag)
        {
        case 71://salute
            saluteTableShow.constant = high
                break
        case 73://status
            statusTableShow.constant = high
                break
        default://occupation
            occuTableShow.constant = high
                break
        }
        aVu.isHidden = hide
        aVu.layoutIfNeeded()
    }
    
    private func loadApiData()
    {
        let def = common.sharedUserDefaults()
        var vehicle_Type = ""
        switch(def.integer(forKey: "ProductCode"))
        {
        case 2:
            vehicle_Type = Constant.privatecar
            break
        default:
            vehicle_Type = Constant.twowheeler
            break
        }
        
        let k = def.string(forKey: "ThisCompany")
        
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+vehicle_Type+Constant.salutation+Constant.companyC+k!) { response in
            self.SalutationArr = response?.object(forKey: "Response") as? NSArray
        DispatchQueue.main.async {
            self.saluteTableView.reloadData()
            }
        }
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+vehicle_Type+Constant.maritalStatus+Constant.companyC+k!) { response in
            self.status = response?.object(forKey: "Response") as? NSArray
        DispatchQueue.main.async {
            self.statusTableView.reloadData()
            self.statusTableView.updateTableContentInset()
            }
        }
        APICallered().fetchData(Constant.apiAPI+Constant.baseURL+Constant.forApi+Constant.motor+vehicle_Type+Constant.occupation+Constant.companyC+k!) { response in
            self.ocupationArray = response?.object(forKey: "Response") as? NSArray
        DispatchQueue.main.async {
            self.eduTableView.reloadData()
            self.eduTableView.updateTableContentInset()
            }
        }
    }
    
    private func registerTableViewCells()
    {
        saluteTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        statusTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        eduTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
    }

    private func addRoundedShapesToViews()
    {
        common.applyRoundedShapeToView(salutationView, withRadius: 5)
        common.applyRoundedShapeToView(firstName, withRadius: 5)
        common.applyRoundedShapeToView(midName, withRadius: 5)
        common.applyRoundedShapeToView(lastName, withRadius: 5)
        common.applyRoundedShapeToView(maritalView, withRadius: 5)
        common.applyRoundedShapeToView(dobView, withRadius: 5)
        common.applyRoundedShapeToView(selectDate, withRadius: 5)
        common.applyRoundedShapeToView(educationView, withRadius: 5)
        common.applyRoundedShapeToView(continueVu, withRadius: 10)
    }

    private func addTapGesturesToView()
    {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.dobTap(_:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.saluteTap(_:)))
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(self.maritalTap(_:)))
        let tap7 = UITapGestureRecognizer(target: self, action: #selector(self.eduTap(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.GenderSelect(_:)))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.GenderSelect(_:)))

        maleBackgroundView.addGestureRecognizer(tap3)
        femaleBackgroundView.addGestureRecognizer(tap5)
        dobView.addGestureRecognizer(tap1)
        salutationView.addGestureRecognizer(tap4)
        maritalView.addGestureRecognizer(tap6)
        educationView.addGestureRecognizer(tap7)
    }
    
    @objc func maritalTap(_ sender: UITapGestureRecognizer? = nil) {
        firstName.resignFirstResponder()
        midName.resignFirstResponder()
        lastName.resignFirstResponder()
        showAndHideListView(statusTable, false)
        showAndHideListView(saluteTable, true)
        showAndHideListView(eduTable, true)
    }
    
    @objc func eduTap(_ sender: UITapGestureRecognizer? = nil) {
        firstName.resignFirstResponder()
        midName.resignFirstResponder()
        lastName.resignFirstResponder()
        showAndHideListView(eduTable, false)
        showAndHideListView(statusTable, true)
        showAndHideListView(saluteTable, true)
    }

    private func setTextFieldValues()
    {
        if (dict.object(forKey: "FirstName") !=  nil)
        {
            firstName.text = (dict.object(forKey: "FirstName") as! String)
        }
        if (dict.object(forKey: "MidName") !=  nil)
        {
            midName.text = (dict.object(forKey: "MidName") as! String)
        }
        if (dict.object(forKey: "LastName") !=  nil)
        {
            lastName.text = (dict.object(forKey: "LastName") as! String)
        }
        if (dict.object(forKey: "DateOfBirth") !=  nil)
        {
            dob.text = (dict.object(forKey: "DateOfBirth") as! String)
            dobLbl.isHidden = false
        }
    }
    
    @IBAction func dateIsSelected(_ sender: UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: manufacturePicker.date)
        dob.text = dateString        //Calculate age
        dict.setValue(dateString, forKey: "DateOfBirth")
//        let components = manufacturePicker.calendar.dateComponents([.year], from: self.manufacturePicker.date)
//        let dob = DateComponents(calendar: .current, year: components.year).date!
//        let ageString = String.init(stringLiteral: String(dob.age)+" years")
        dobLbl.isHidden = false
        pickerView.isHidden = true
        common.removeImageForRestriction(dob.superview!)
    }
    
    @objc func dobTap(_ sender: UITapGestureRecognizer? = nil) {
        firstName.resignFirstResponder()
        midName.resignFirstResponder()
        lastName.resignFirstResponder()
        pickerView.isHidden = false
        showAndHideListView(statusTable, true)
        showAndHideListView(saluteTable, true)
        showAndHideListView(eduTable, true)
    }
    
    @objc func GenderSelect(_ sender: UITapGestureRecognizer? = nil) {
        let vi = sender?.view
        firstName.resignFirstResponder()
        midName.resignFirstResponder()
        lastName.resignFirstResponder()

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
        showAndHideListView(statusTable, true)
        showAndHideListView(saluteTable, true)
        showAndHideListView(eduTable, true)

        firstName.resignFirstResponder()
        midName.resignFirstResponder()
        lastName.resignFirstResponder()
        
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
        dict.setValue(k, forKey: "Gender")
    }
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        keyboardIsOpen = false
        firstName.resignFirstResponder()
        midName.resignFirstResponder()
        lastName.resignFirstResponder()
        showAndHideListView(statusTable, true)
        showAndHideListView(saluteTable, true)
        showAndHideListView(eduTable, true)

        if (salutationLbl.isHidden || maritalLbl.isHidden || dobLbl.isHidden || educationLbl.isHidden || !lastName.hasText || !firstName.hasText)
        {
            displayAlert()
        }
        else if ((dict.object(forKey: "DateOfBirth") != nil) && (dict.object(forKey: "FirstName") != nil) && (dict.object(forKey: "Gender") != nil) && (dict.object(forKey: "LastName") != nil) && (dict.object(forKey: "MaritalStatus") != nil) && (dict.object(forKey: "Occupation") != nil) && (dict.object(forKey: "Title") != nil))
        {
            saveMyDetails()
            common.goToNextScreenWith("ContactDetailsViewController", self)
        }
    }
    
    private func displayAlert()
    {
        common.removeImageForRestriction(dob.superview!)
        common.removeImageForRestriction(firstName!)
        common.removeImageForRestriction(lastName!)
        common.removeImageForRestriction(salutation!)
        common.removeImageForRestriction(education!)
        common.removeImageForRestriction(marital!)
        if (!firstName.hasText)
        {
            common.displayImageForRestriction(firstName!)
        }
        if (!lastName.hasText)
        {
            common.displayImageForRestriction(lastName!)
        }
        if (salutationLbl.isHidden)
        {
            common.displayImageForRestriction(salutation!)
        }
        if (dobLbl.isHidden)
        {
            common.displayImageForRestriction(dob.superview!)
        }
        if (educationLbl.isHidden)
        {
            common.displayImageForRestriction(education!)
        }
        if (maritalLbl.isHidden)
        {
            common.displayImageForRestriction(marital!)
        }
    }
    
    @objc func saluteTap(_ sender: UITapGestureRecognizer? = nil) {
        firstName.resignFirstResponder()
        midName.resignFirstResponder()
        lastName.resignFirstResponder()
        showAndHideListView(statusTable, true)
        showAndHideListView(saluteTable, false)
        showAndHideListView(eduTable, true)
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
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            keyBoardView.constant = 0
//        }
        keyBoardView.constant = 0
    }
    
    private func saveMyDetails()
    {
        dict.setValue(false, forKey: "disabled")
        common.sharedUserDefaults().set(dict, forKey: "ClientDetails")
        common.sharedUserDefaults().synchronize()
    }
    
    @IBAction func backbtnTapped(_ sender: UIButton) {
        saveMyDetails()
        self.navigationController?.popViewController(animated: true)
    }

    private func textFieldLabel()
    {
        setLabelFieldMutualVisibility(firstName, firstNameLbl.text!, firstNameLbl)
        setLabelFieldMutualVisibility(midName, midNameLbl.text!, midNameLbl)
        setLabelFieldMutualVisibility(lastName, lastNameLbl.text!, lastNameLbl)

        common.applyBorderToView(salutationView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(firstName, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(midName, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(lastName, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(maritalView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(dobView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(educationView, withColor: Colors.textFldColor, ofSize: 1)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 81:
                common.setTextFieldLabels(firstName, firstNameLbl, false, "")
                dict.setValue("", forKey: "FirstName")
            break
        case 82:
                common.setTextFieldLabels(midName, midNameLbl, false, "")
                dict.setValue("", forKey: "MidName")
            break
        default:
                common.setTextFieldLabels(lastName, lastNameLbl, false, "")
                dict.setValue("", forKey: "LastName")
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
         var currentString: NSString = textField.text!.capitalized as NSString
         common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)         
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

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         textFieldLabel()
         return true
     }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let tagValue = textField.tag
        switch(tagValue)
        {
            case 81:
                dict.setValue(textField.text!.capitalized, forKey: "FirstName")
            break
            case 82:
                dict.setValue(textField.text!.capitalized, forKey: "MidName")
            break
            default:
                dict.setValue(textField.text!.capitalized, forKey: "LastName")
            break
        }
        common.removeImageForRestriction(textField)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (tableView.tag)
        {
        case 71:
            do {
                if (SalutationArr == nil)
                {
                    return 0
                }
                return SalutationArr.count
            }
        case 73:
            do {
                if (status == nil)
                {
                    return 0
                }
                return status.count
            }
        default:
            do {
                if (ocupationArray == nil)
                {
                    return 0
                }
                return ocupationArray.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
        switch (tableView.tag)
        {
        case 71:
                let nameDict = (SalutationArr[indexPath.row]) as? NSDictionary
                let string = (nameDict?.object(forKey: "Name") as! String)
                cell.setDispaly(string)
            break
        case 73:
                let nameDict = (status[indexPath.row]) as? NSDictionary
                let string = (nameDict?.object(forKey: "Name") as! String)
                cell.setDispaly(string)
            break
        default:
                let nameDict = (ocupationArray[indexPath.row]) as? NSDictionary
                let string = (nameDict?.object(forKey: "Name") as! String)
                cell.setDispaly(string)
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (tableView.tag)
        {
        case 71:
                let nameDict = (SalutationArr[indexPath.row]) as? NSDictionary
                salutation.text = nameDict?.object(forKey: "Name") as? String
                let string =  NSString.init(format: "%@", nameDict?.object(forKey: "Id") as! CVarArg) as String
                dict.setValue(string, forKey: "Title")
                salutationLbl.isHidden = false
                common.removeImageForRestriction(salutation)
            break
        case 73:
                let nameDict = (status[indexPath.row]) as? NSDictionary
                marital.text = nameDict?.object(forKey: "Name") as? String
                let string =  NSString.init(format: "%@", nameDict?.object(forKey: "Id") as! CVarArg) as String
                dict.setValue(string, forKey: "MaritalStatus")
                maritalLbl.isHidden = false
                common.removeImageForRestriction(marital)
            break
        default:
                let nameDict = (ocupationArray[indexPath.row]) as? NSDictionary
                let string = (nameDict?.object(forKey: "Name") as! String)
            common.sharedUserDefaults().set(string, forKey: "OccupationName")
                education.text = string
//                let kkk = nameDict?.object(forKey: "Id") as! String
//                let ddd = common.setIdAndNameForDict(_valueId: kkk, andName: string)
                dict.setValue(nameDict!.object(forKey: "Id"), forKey: "Occupation")
                educationLbl.isHidden = false
                common.removeImageForRestriction(education)
            break
        }
        showAndHideListView(tableView.superview!, true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
