//
//  Common.swift
//  InsuranceApp
//
//  Created by Sankalp on 15/11/21.
//

import Foundation
import UIKit
import CommonCrypto
import Security

class Common
{
    static let sharedCommon = Common()
    
    static var registerAreaArr : NSArray!
    static var manufacturerArray : NSArray!
    static var modelArray : NSArray!
    static var variantArray : NSArray!
    static var insurerArray : NSArray!
    static var financeCityArray : NSArray!
    static let genderArray = ["Male", "Female"]//, "Others"]
//    static let genderArray = ["Male", "Female", "Others"]
    static let expiryArray = ["Select expiry status*", "Not Expired", "Expired within 90 days", "Expired more than 90 days"]
    static let prevPolicyArray = ["Comprehensive", "Third Party"]
    static let yesNoBtnArray = ["Yes", "No"]
    static let ncbArray = ["0%", "20%", "25%", "35%", "45%", "50%"]
    
    static let indi_org_Array = ["Individual", "Organisation"]

    //Chassis Number    :    MBLHA11EMB9A05557
//    Engine Number    :    HA11ECB9A32486

    let previousInsurers = "PreviousInsurerFor-Json"
    
//    let colorValue = "#0FACC8"
    let colorValue = 0x0FACC8
    let alertWithoutCancel = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "Montserrat-SemiBold", size: 20)!,
        kTextFont: UIFont(name: "Montserrat-Regular", size: 14)!,
        kButtonFont: UIFont(name: "Montserrat-Medium", size: 16)!
    )
    let alertwithCancel = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "Montserrat-SemiBold", size: 20)!,
        kTextFont: UIFont(name: "Montserrat-Regular", size: 14)!,
        kButtonFont: UIFont(name: "Montserrat-Medium", size: 16)!,
        showCloseButton: true
    )

    func getPlist(withName name: String) -> [String]?
    {
        if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
        }
        return nil
    }
    
    func testCrypt(data:Data, IsEncryption:Bool) -> Data {
    var operation : Int! = kCCDecrypt
    if (IsEncryption)
    {
        operation = kCCEncrypt
    }
    
    let keyData = "P-!nsurance@2022".data(using: .utf8)
    let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
    var cryptData = Data(count:cryptLength)

    let keyLength             = size_t(kCCKeySizeAES128)
    let options   = CCOptions(kCCOptionPKCS7Padding)

    var numBytesEncrypted :size_t = 0
    
    let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
        data.withUnsafeBytes {dataBytes in
            keyData!.withUnsafeBytes {ivBytes in
                keyData!.withUnsafeBytes {keyBytes in
                    CCCrypt(CCOperation(operation),
                              CCAlgorithm(kCCAlgorithmAES),
                              options,
                              keyBytes, keyLength,
                              ivBytes,
                              dataBytes, data.count,
                              cryptBytes, cryptLength,
                              &numBytesEncrypted)

                }
            }
        }
    }

    if UInt16(cryptStatus) == UInt16(kCCSuccess) {
        cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)

    } else {
        print("Error: \(cryptStatus)")
    }

    return cryptData;
}
    
    func getDeductibleArray() ->[Int]
    {
        return [10000, 25000, 50000, 100000, 200000, 300000, 400000, 500000, 600000, 700000, 800000, 900000, 1000000 ]
    }
    
    func getRegisterUserList() -> ([String], [String])
    {
        let userArray : [String] = ["Continue as customer", "Continue as agent", "Continue as employee"]
        let imageArray : [String] = ["Customer", "Agent", "Employee"]
        return (userArray, imageArray)
    }
    
    func circularView(_ view : UIView, cornerRadius radius : CGFloat, colour color : UIColor, borderWide wide : CGFloat )
    {
            let shadowLayer: CAShapeLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath
            shadowLayer.fillColor = color.cgColor
        shadowLayer.borderColor = color.cgColor
        shadowLayer.borderWidth = wide
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            view.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keypadToolbar.items=[
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        textField.inputAccessoryView = keypadToolbar
    }//addDoneToKeyPad
    
    func getAnotherList() -> [String]
    {
        return ["Marketing:Poster", "Advertisement", "My Deal", "Support", "My Customer", "Knowledge:Centre", "Refer & Earn", "Customize"]
    }
    
    func getAccessList() -> [String]
    {
        return ["Marketing:Poster", "Advertisement", "My Deal", "Support", "My Customer", "Knowledge:Centre", "Refer & Earn", "Risk Meter", "Payout Chart", "MIS Report", "Endorsement", "New Products", "Choose:Language", "Blog & Media:Coverage", "Reward Center", "Commission:Structure", "Customize"]
    }
    
    func getFirstAcessList() -> [String]
    {
        var dict : [String] = sharedUserDefaults().object(forKey: "Customize") as? [String] ?? []
        dict.append("Customize")
        
        return dict
    }
        
    func getAgentProductList() -> [String]
    {
        return ["Term:Insurance", "Health:Family", "Car:Insurance", "Two:Wheeler", "Commercial:Insurance", "Health:Insurance", "Tax:Saving Plan", "View More:Products"]
    }
    
    func getEmpOrCustProductList() -> [String]
    {
        return ["Car:Insurance", "Two:Wheeler", "Goods:Carrying", "Passenger:Carrying", "Misc-D:Insurance", "Home:Insurance", "Buisness:Insurance", "Tax:Saving Plan", "Pos:Products", "Health:Family", "Term:Insurance", "Travel:Insurance"]
    }

    func allProductList() -> [String]
    {
        return ["Car:Insurance", "Two:Wheeler", "Goods:Carrying", "Passenger:Carrying", "Misc-D:Insurance", "Home:Insurance", "Buisness:Insurance", "Tax:Saving Plan", "Pos:Products",  "Health:Family", "Term:Insurance", "Travel:Insurance", "Cancer:Insurance", "Super:Top Up", "Health:Insurance", "Life:Insurance", "Investment:Plan", "Group:Mediclaim", "Personal:Accident", "Fire:Burglary", "Premium:Insurance", "Marine:Inurance"]
    }

    /*
     func allProductList() -> [String]
     {
         return ["Term:Insurance", "Health:Family", "Car:Insurance", "Two:Wheeler", "Commercial:Insurance", "Health:Insurance", "Tax:Saving Plan", "Cancer:Insurance", "Travel:Insurance", "Buisness:Insurance", "Home:Insurance", "Super:Top Up", "Pos:Products", "Life:Insurance", "Investment:Plan", "Group:Mediclaim", "Personal:Accident", "Fire:Burglary", "Premium:Insurance", "Marine:Inurance", "Passenger:Carrying", "Misc-D:Insurance", "View Less:Products"]
     }

     
    func getEmpOrCustProductList() -> [String]
    {
        return ["Term:Insurance", "Health:Family", "Car:Insurance", "Two:Wheeler", "Commercial:Insurance", "Health:Insurance", "Tax:Saving Plan", "Cancer:Insurance", "Travel:Insurance", "Buisness:Insurance", "Home:Insurance", "View More:Products"]
    }*/
    /*
    func getSideMenuImageList() -> [String]
    {
        return ["Dashboard", "Profile", "Policy PDF", "My Policies", "Claims", "Poster of the Day", "Call My RM", "Earning Potential", "Current Offers", "Raise Request", "Refer Earn", "Rate Us", "Share App", "Download POS App", "Greivance Redressal", "Privacy Policy", "Log Out"]
    }
  
    func getSideMenuStringList() -> [String]
    {
        return ["Dashboard", "Profile", "Policy PDF", "My Policies", "Claim Support", "Poster of the Day", "Call My RM", "Earning Potential", "Current Offers", "Raise Request", "Refer & Earn", "Rate Us / Feedback", "Share App", "Download POS App", "Greivance Redressal", "Privacy Policy", "Log Out"]
    }
*/
    func getSideMenuImageListWithLogin() -> [String]
    {
        return ["Dashboard", "Profile", "Policy PDF", "My Policies", "Claims", "Poster of the Day", "Call My RM", "Earning Potential", "Current Offers", "Raise Request", "Refer Earn", "Rate Us", "Share App", "Greivance Redressal", "Privacy Policy", "Log Out"]
    }

    
    func getSideMenuStringListWithLogin() -> [String]
    {
        return ["Dashboard", "Profile", "Policy PDF", "My Policies", "Claim Support", "Poster of the Day", "Call My RM", "Earning Potential", "Current Offers", "Raise Request", "Refer & Earn", "Rate Us / Feedback", "Share App", "Greivance Redressal", "Privacy Policy", "Log Out"]
    }

    func getSideMenuImageListWithoutLogin() -> [String]
    {
        return ["Claims", "Poster of the Day", "Current Offers", "Rate Us", "Share App", "Greivance Redressal", "Privacy Policy"]
    }

    
    func getSideMenuStringListWithoutLogin() -> [String]
    {
        return ["Claim Support", "Poster of the Day", "Current Offers", "Rate Us / Feedback", "Share App", "Greivance Redressal", "Privacy Policy"]
    }


    func getStartedViewArrays() -> ([String], [String], [String])
    {
        let headerArray : [String] = ["Insurance on the go", "Enjoy easy policy issuance", "We've got you covered"]
        let descArray : [String] = ["Quickly compare & purchase the best plans customized as per your needs.", "Get instant insurance quotes from the top insurers with our seamless digital journey", "Whatever your concern, we're always here for you! get claim assistance, instant access to your policy, and much more."]
        let imageArray : [String] = ["Start 1", "Start 2", "Start 3"]
        // title , description, imageName
        return (headerArray, descArray, imageArray)
    }
    
    func getOfferArray() -> ([String], [String], [String], [String], [String])
    {
        let hearderArr: [String] = ["Get ₹ 5 Lac *", "Save upto 70%", "Save upto 70%"]
        let coverArr :[String] = ["Health Cover", "", ""]
        let coverImageArr :[String] = ["Family", "Car", "Individual"]
        let colorArr : [String] = ["#D9DFFF", "#FFEEF0", "#FFEED2"]
        let descArr :[String] = ["At just ₹500/Month", "Get quick claim settlement", "Term Insurance"]
        // title , subtitle, description, imageName, color of view
        return (hearderArr, coverArr, descArr, coverImageArr, colorArr)
    }

    func getLearnAndTrainArray() -> ([String], [String], [String], [String], [String])
    {
        let attendArr : [String] = ["Attend Live Webinars", "Welcome new skills"]
        let learnArr : [String] = ["Learn how to sell effectively", "to get the quality leads"]
        let exploreTrainArr : [String] = ["Explore Now", "Start Training"]
        let ImageCellArr : [String] = ["Attend", "New Skills"]
        let aboveCellColorArr :[String] = ["#EAEDFF", "#FFEEF0"]
        // title , subtitle, button text, imageName, color of view
        return (attendArr, learnArr, exploreTrainArr, ImageCellArr, aboveCellColorArr)
    }

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        let color:UIColor = UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
        return color
    }
    
    func getScreenSize(_ view: UIView) -> (CGFloat, CGFloat)
    {
        let screenRect:CGRect = view.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let screenHeight: CGFloat = screenRect.size.height
        return (screenWidth, screenHeight)
    }
    
    func getConstarint(_ firstView: UIView, withMultiplierValue multiplierValue: CGFloat) -> NSLayoutConstraint
    {
        let heightConstraint : NSLayoutConstraint = NSLayoutConstraint.init(item: firstView as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: firstView, attribute: NSLayoutConstraint.Attribute.height, multiplier: (firstView.frame.size.width/(firstView.frame.size.width*multiplierValue)), constant: 0)
        return heightConstraint
    }

    func ShowAndHideView(ConstarintIs cons: NSLayoutConstraint, isHidden hide: Bool, andSize size: CGFloat) -> NSLayoutConstraint
    {        
        var heightConstraint : NSLayoutConstraint!
        if (hide)
        {
            heightConstraint = NSLayoutConstraint.init(item: cons.firstItem as Any, attribute: cons.firstAttribute, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cons.secondItem, attribute: cons.secondAttribute, multiplier: size, constant: cons.constant)
        }
        else
        {
            heightConstraint = NSLayoutConstraint.init(item: cons.firstItem as Any, attribute: cons.firstAttribute, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cons.secondItem, attribute: cons.secondAttribute, multiplier: size, constant: cons.constant)
        }
        return heightConstraint
    }

    func sharedUserDefaults() -> UserDefaults
    {
        return UserDefaults.standard
    }
    
    func splitStringIntoArrayForOTP(_ string: String) -> [Int]
    {
        let digits = string.compactMap{ $0.wholeNumberValue } // [1, 2, 3, 4, 5, 6]
        return digits
    }
    
    func applyShadowToView(_ view: UIView, withColor color: UIColor, opacityValue opac: Float, radiusValue rad: CGFloat)
    {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = opac
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = rad
        view.layoutSubviews()
    }
    
    func applyBorderToView(_ view: UIView, withColor color: UIColor, ofSize size: CGFloat)
    {
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = size
        view.layoutSubviews()
    }
    
    func applyRoundedShapeToView(_ view: UIView, withRadius rad: CGFloat)
    {
        view.layer.cornerRadius = rad
        view.layer.masksToBounds = true
        view.layoutSubviews()
    }
    
    func isValidVehicleNumber(_ vehicleNumber: String) -> Bool
    {
        let k = vehicleNumber.replacingOccurrences(of: "-", with: " ")
        let vehicleRegEx = "^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$"

        let numberPred = NSPredicate(format: "SELF MATCHES %@", vehicleRegEx)
        return numberPred.evaluate(with: k)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidQuotation(_ quotation: String) -> Bool {
        let quotationRegEx = "^[A-Z]{9}\\d{16}$"
        let quotationPred = NSPredicate(format:"SELF MATCHES %@", quotationRegEx)
        return quotationPred.evaluate(with: quotation)
    }

    func isValidPAN(_ panNumber: String) -> Bool {
        let panRegEx = "[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}"
        let panPred = NSPredicate(format:"SELF MATCHES %@", panRegEx)
        return panPred.evaluate(with: panNumber)
    }
    
    func isValidGST(_ gstNumber: String) -> Bool {
        let gstRegEx = "^[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[0-9]{1}[a-zA-Z]{1}[a-zA-Z0-9]{1}$"
        let gstPred = NSPredicate(format:"SELF MATCHES %@", gstRegEx)
        return gstPred.evaluate(with: gstNumber)
    }
    
    func isValidChassis(_ chassis: String) -> Bool {
        let chassisRegEx = "[a-zA-Z0-9]{9}[a-zA-Z0-9-]{2}[0-9]{6}"
        let chassisPred = NSPredicate(format:"SELF MATCHES %@", chassisRegEx)
        return chassisPred.evaluate(with: chassis)
    }

    func aFunction(_ numbers: NSArray, positionStart start: Int, positionEnd end: Int) -> NSArray {
        let theRange = NSRange.init(location: start, length: end)
        let newNumbers = numbers.subarray(with: theRange)
        return newNumbers as NSArray
    }
    
    func goToNextScreenWith(_ identifier: String,_ self: UIViewController)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier:identifier) as UIViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func setTextFieldLabels(_ field: UITextField,_ label: UILabel,_ hide: Bool,_ string: String)
    {
        label.isHidden = hide
        field.placeholder = string
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func showToast(_ view : UIView, WithMessage message : String, andTime time : CGFloat) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75, y: view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = hexStringToUIColor(hex: "#0CB1CA").withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.init(name: "Montserrat-SemiBold", size: 14.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: time, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func setIdAndNameForDict(_valueId id: String, andName name: String) -> NSMutableDictionary
    {
        let dict = NSMutableDictionary.init()
        dict.setValue(id, forKey: "Id")
        dict.setValue(name, forKey: "Name")
        return dict
    }
    
    
    func displayImageForRestriction(_ view : UIView)
    {
        let aVu = view.superview!
        let imgVu = UIImageView.init(image: UIImage.init(systemName: "exclamationmark.triangle.fill"))
        imgVu.frame = CGRect(x: 0, y: 0, width: aVu.frame.size.height*0.4, height: aVu.frame.size.height*0.4)
        imgVu.tintColor = .red
        imgVu.backgroundColor = .clear
        var xx : CGFloat!
        if (view is UILabel)
        {
            xx = view.bounds.size.width - (imgVu.frame.size.width/2)
        }
        else
        {
            xx = aVu.frame.size.width - ((imgVu.frame.size.width/2) + 10)
        }
        imgVu.center = CGPoint(x: xx, y: view.center.y)
        aVu.addSubview(imgVu)
    }
    
    func removeImageForRestriction(_ view : UIView)
    {
            let aVu = view.superview!.subviews.last!
            if (aVu is UIImageView)
            {
                aVu.removeFromSuperview()
            }
    }
  
    func convertStringIntoDate(_ stringDate : String) -> Date
    {
        // Convert string to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.date(from: stringDate)!
        return date
    }
        
    func comaparingDates(_firstDate first: Date, _secondDate second: Date) -> Date
    {
        let result = first.compare(second)
        //First date is greater then the second date i.e second date is older than first date
        if (result == .orderedDescending)
        {
            return second
        }
        return first
    }
    
    func countDigit(num:Int)->Int {
        var n = num
        var count : Int = 0
        while (n != 0)
        {
            n = n / 10
            count += 1
        }
        return count
    }
    
    func removeOptionalKey(_ key : String) -> String
    {
        var str = key
        str = str.replacingOccurrences(of: "Optional(", with: "")
        str = str.replacingOccurrences(of: ")", with: "")
        return str
    }
    
    func adultRelationArray() -> [String]
    {
        return ["Self", "Spouse", "Father", "Mother", "Father-in-law", "Mother-in-law", "Sister", "Brother"]
    }
    
    func childRelationArray() -> [String]
    {
        return ["Son", "Daughter"]
    }
    
    func maleOrFemaleChecker(string : String) -> Bool
    {
        
            return false
    }
    
    func archiveMyDataForDictionary(_ diction : NSDictionary, withKey key : String) {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: diction, requiringSecureCoding: false)
        sharedUserDefaults().set(data, forKey: key)
    }
    
    func unArchiveMyDataForDictionary(_ key : String) -> NSDictionary? {
        let unarchivedObject = UserDefaults.standard.data(forKey: key)
//        let dict = NSMutableDictionary.init()
        if (unarchivedObject != nil)
        {
            let keyDict = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject!) as! NSDictionary
            return keyDict
//            dict.addEntries(from: keyDict as! [AnyHashable : Any])
        }
        return nil
    }
}

// MARK: - EXTENSIONS
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension UITableView
{
    func updateTableContentInset() {
        let numRows = self.numberOfRows(inSection: 0)
        var contentInsetTop = self.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
}


extension UIColor {

    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}

extension UILabel {
    func highlight(_ text: String, colorValue color: UIColor)
    {
        let s = text as NSString
        let att = NSMutableAttributedString(string: s as String)
        let r = s.range(of: "₹\\w.*", options: NSString.CompareOptions.regularExpression, range: NSMakeRange(0,s.length))
        if r.length > 0 {
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: r)
            att.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Montserrat-SemiBold", size: 14) as Any, range: r)
        }
        self.attributedText = att;
    }
        
    func highlightMyText(_ text: String, searchedText search: String, colorValue color: UIColor, withFontName fontName: UIFont)
    {
        let s = text as NSString
        let att = NSMutableAttributedString(string: s as String)
        let r = s.range(of: search, options: NSString.CompareOptions.literal, range: NSMakeRange(0,s.length))
        if r.length > 0 {
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: r)
            att.addAttribute(NSAttributedString.Key.font, value:fontName as Any, range: r)
        }
        self.attributedText = att;
    }
}

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }

}


extension UIView {
    func setWidth(_ w:CGFloat) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: w, height: self.frame.size.height)
        self.layoutIfNeeded()
        self.superview?.layoutIfNeeded()
    }
}
