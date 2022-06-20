//
//  LoginScreenController.swift
//  InsuranceApp
//
//  Created by Sankalp on 07/06/22.
//

import UIKit
import MBProgressHUD

class LoginScreenController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userIdLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var showPass: UIButton!
    @IBOutlet weak var keyBoardView: NSLayoutConstraint!

    private let common = Common.sharedCommon
    private var keyboardShow = false
    private var show = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        common.applyRoundedShapeToView(loginBtn, withRadius: 10)
        common.applyRoundedShapeToView(userId, withRadius: 5)
        common.applyRoundedShapeToView(password, withRadius: 5)
        textFieldLabels()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if (!keyboardShow)
            {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyBoardView.constant = keyboardHeight
                keyboardShow = true
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldLabels()
        keyboardShow = false
        keyBoardView.constant = 0
    }
    
    @IBAction func loginUsingIDandPass(_ sender: UIButton)
    {
        userId.resignFirstResponder()
        password.resignFirstResponder()
        keyboardShow = false

        if (!userIdLbl.isHidden && !passwordLbl.isHidden)
        {
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Processing"

            let aDict = NSMutableDictionary.init()
            aDict.setValue(UIDevice.current.identifierForVendor?.uuidString, forKey: "DeviceId")
            aDict.setValue(password.text!, forKey: "Password")
            aDict.setValue(userId.text!, forKey: "UserName")
            aDict.setValue("", forKey: "RefreshToken")
            aDict.setValue(false, forKey: "RememberMe")

            let apiUrl = Constant.buyAPI+Constant.baseURL+"Account/AuthenticateMobileLogin"
            APICallered().POSTMethodForDataToGet(dataToPass: aDict, toURL: apiUrl) { response in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)

                    let success = (response?.object(forKey: "Success") as! Bool)
                    
                    if (!success)
                    {
                        let alert = SCLAlertView.init(appearance: self.common.alertwithCancel)
                        alert.showError("Alert", subTitle: (response?.object(forKey: "Message") as! String), closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                    }
                    else
                    {
                        var logUserId = response?.object(forKey: "UserId") as? String
                        if (logUserId == nil)
                        {
                            logUserId = "0"
                        }
                        let res = response?.object(forKey: "UserDetail") as? NSDictionary
                        let def = self.common.sharedUserDefaults()
                        def.set(logUserId, forKey: "UserId")
                        def.synchronize()
                        self.common.archiveMyDataForDictionary(res!, withKey: "LoginResponse")
                        Common.sharedCommon.goToNextScreenWith("ViewController", self)
                    }
                }
            }
        }
        else
        {
            let alert = SCLAlertView.init(appearance: common.alertwithCancel)
            alert.showError("Alert", subTitle: "Enter valid user-id and password.", closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
        }
    }
    
    @IBAction func skipLogin(_ sender: UIButton)
    {
        let def = self.common.sharedUserDefaults()
        def.set("0", forKey: "UserId")
        def.synchronize()
//        SecondViewController
        Common.sharedCommon.goToNextScreenWith("ViewController", self)
    }

    @IBAction func showAndHidePass(_ sender: UIButton)
    {
        var img : UIImage! = UIImage.init(systemName: "eye.slash.fill")
        if (show)
        {
            img = UIImage.init(systemName: "eye.fill")
        }
        show = !show
        password.isSecureTextEntry = !show
        showPass.setImage(img, for: .normal)
//        Common.sharedCommon.goToNextScreenWith("LoginScreenController", self)
    }
    
    override func viewDidLayoutSubviews() {
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
    
     private func textFieldLabels()
    {
        common.applyBorderToView(password, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(userId, withColor: Colors.textFldColor, ofSize: 1)
        setLabelFieldMutualVisibility(userId, userIdLbl.text!, userIdLbl)
        setLabelFieldMutualVisibility(password, passwordLbl.text!, passwordLbl)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool
    {
        textFieldLabels()
        let tagValue = textField.tag
        switch(tagValue)
        {
        case 1: //lbl, field
            common.setTextFieldLabels(userId, userIdLbl, false, "")
            break
        case 2: //lbl, field
            common.setTextFieldLabels(password, passwordLbl, false, "")
            break
        default:
            break
        }
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        scrollView.scrollRectToVisible(textField.superview!.bounds, animated: true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        textFieldLabels()
        common.applyBorderToView(textField, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 2)
        var currentString: NSString = textField.text! as NSString
        currentString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldLabels()
        textField.resignFirstResponder()
        keyboardShow = false
        return true
    }
}
