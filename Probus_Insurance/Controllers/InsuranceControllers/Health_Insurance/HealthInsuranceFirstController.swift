//
//  HealthInsuranceFirstController.swift
//  Probus_Insurance
//
//  Created by Sankalp on 18/05/22.
//

import UIKit

class HealthInsuranceFirstController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout//, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{

    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var genderCollection : UICollectionView!

    @IBOutlet weak var maleBackgroundView : UIView!
    @IBOutlet weak var maleImageView : UIImageView!
    @IBOutlet weak var maleView : UIView!

    @IBOutlet weak var femaleBackgroundView : UIView!
    @IBOutlet weak var femaleImageView : UIImageView!
    @IBOutlet weak var femaleView : UIView!

    
    @IBOutlet weak var pinCodeVu : UIView!
    @IBOutlet weak var pinCode : UITextField!
    @IBOutlet weak var pinCodeLbl : UILabel!
    
    @IBOutlet weak var adultVu : UIView!
    @IBOutlet weak var adultFld : UITextField!
    @IBOutlet weak var adultLbl : UILabel!

    @IBOutlet weak var childVu : UIView!
    @IBOutlet weak var childFld : UITextField!
    @IBOutlet weak var childLbl : UILabel!

    @IBOutlet weak var continueBtn : UIButton!

    @IBOutlet weak var keyboardView: NSLayoutConstraint!
    
    private var keyboardIsOpen = false

    
    private let qualifyRequest = NSMutableDictionary.init()
    private var genderTapp = 0
    private let common = Common.sharedCommon
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dict = common.unArchiveMyDataForDictionary(Constant.qualifiyReq)
        qualifyRequest.addEntries(from: dict as! [AnyHashable : Any])

        common.applyRoundedShapeToView(continueBtn, withRadius: 10)

//        genderCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyThemOnPinCodeView()
        applyThemOnAdultView()
        applyThemOnChildView()
    }
    
    private func applyThemOnChildView()
    {
        common.applyRoundedShapeToView(childFld, withRadius: 5)
        common.applyBorderToView(childFld, withColor: Colors.textFldColor, ofSize: 1)
        common.addDoneButtonOnNumpad(textField: childFld)
    }
    
    private func applyThemOnPinCodeView()
    {
        common.applyRoundedShapeToView(pinCode, withRadius: 5)
        common.applyBorderToView(pinCode, withColor: Colors.textFldColor, ofSize: 1)
        common.addDoneButtonOnNumpad(textField: pinCode)
    }

    private func applyThemOnAdultView()
    {
        common.applyRoundedShapeToView(adultFld, withRadius: 5)
        common.applyBorderToView(adultFld, withColor: Colors.textFldColor, ofSize: 1)
        common.addDoneButtonOnNumpad(textField: adultFld)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if (!keyboardIsOpen)
            {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyboardView.constant = keyboardHeight
                keyboardIsOpen = true
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardIsOpen = false
        keyboardView.constant = 0
    }
    
    @IBAction func backBtntapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtntapped(_ sender: UIButton) {
        if (pinCode.hasText && pinCode.text!.count == 6 && adultFld.hasText)
        {
            var numOfChild = 0
            let numOfAdult = Int(adultFld.text!)!
            if (childFld.hasText)
            {
                numOfChild = Int(childFld.text!)!
            }

            let totalMem = numOfChild +  numOfAdult
            if (numOfAdult < 2 || numOfAdult > 8)
            {
                alertviewShow(msg: "Kindly enter number of adults (2-8).")
            }
            else if (totalMem > 8)
            {
                alertviewShow(msg: "Total number of members can be 8.")
            }
            else
            {
                self.qualifyRequest.setValue(numOfAdult, forKey: "NoOfAdultCount")
                self.qualifyRequest.setValue(numOfChild, forKey: "NoOfChildCount")
                self.qualifyRequest.setValue(self.pinCode.text!, forKey: "Pincode")
                self.common.archiveMyDataForDictionary(self.qualifyRequest, withKey: Constant.qualifiyReq)
                common.goToNextScreenWith("HealthSecondScreen", self)
            }
        }
        else if (!adultFld.hasText && pinCode.hasText && pinCode.text!.count == 6)
        {
            alertviewShow(msg: "Kindly enter number of adults (2-8).")
        }
        else
        {
            alertviewShow(msg: "Kindly enter valid pincode.")
        }
    }
    

    func alertviewShow(msg : String)
    {
        let alert = SCLAlertView.init(appearance: common.alertwithCancel)
        alert.showError("Alert", subTitle: msg, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 1:
            Common.sharedCommon.setTextFieldLabels(pinCode, pinCodeLbl, false, "")
            break
        case 2:
            Common.sharedCommon.setTextFieldLabels(adultFld, adultLbl, false, "")
            break
        case 3:
            Common.sharedCommon.setTextFieldLabels(childFld, childLbl, false, "")
            break
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tagValue = textField.tag
        let textCount = textField.text!.count + string.count
        if (tagValue == 1 && textCount>6)
        {
            textField.resignFirstResponder()
        }
        else if (tagValue != 1 && textCount>1)
        {
            textField.resignFirstResponder()
        }
        else{
            var currentString: NSString = textField.text!.capitalized as NSString
            currentString =
                currentString.replacingCharacters(in: range, with: string) as NSString
        }
        return true
   }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Common.genderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        cell.setDataForNormal(Common.genderArray[indexPath.row], ofFontSize: 14)
        if (genderTapp == indexPath.row)
        {
            cell.setSelectedData()
            self.qualifyRequest.setValue(Common.genderArray[indexPath.row], forKey: "Gender")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        genderTapp = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = common.getScreenSize(collectionView)
        let sizes = CGSize(width: widthAndHeight.0*0.3, height: widthAndHeight.1*0.8)
        return sizes;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0);
    }
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (privacyArray == nil)
//        {
            return 0
//        }
//        return privacyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
//        let nameDict = (privacyArray[indexPath.row]) as? NSDictionary
//        let string = nameDict?.object(forKey: "Name") as! String
//        cell.setDispaly(string)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let nameDict = (privacyArray[indexPath.row]) as? NSDictionary
//        let string = nameDict?.object(forKey: "Name") as! String
//        selectPrvacyLbl.text = string
//        common.sharedUserDefaults().set((nameDict?.object(forKey: "Id") as! String), forKey: "previousInsurerCode")
//        common.sharedUserDefaults().synchronize()
//        privacyTable.isHidden = true
//        listViewIsHidden()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }*/
}
