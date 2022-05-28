//
//  HealthSecondScreen.swift
//  Probus_Insurance
//
//  Created by Sankalp on 25/05/22.
//

import UIKit

class HealthSecondScreen : UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout//, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var tenureCollection : UICollectionView!
    @IBOutlet weak var diseaseCollection : UICollectionView!
    @IBOutlet weak var childCollection : UICollectionView!
    @IBOutlet weak var adultCollection : UICollectionView!

    @IBOutlet weak var continueBtn : UIButton!
    @IBOutlet weak var adultView: UIView!
    @IBOutlet weak var adultViewHeight: NSLayoutConstraint!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var childViewHeight: NSLayoutConstraint!

    @IBOutlet weak var coverageView : UIView!
    @IBOutlet weak var coverAmt : UILabel!
    @IBOutlet weak var deductibleView : UIView!
    @IBOutlet weak var deductAmt : UILabel!
    
    private let qualifyRequest = NSMutableDictionary.init()
    private var diseaseTapp = 1
    private var tenureTapp = 0
    private let common = Common.sharedCommon
    private let tenureArray = ["1 Year", "2 Year", "3 Year"]
    private var childCount = 0
    private var adultCount = 0
    private var adultRelArray : NSArray!
    private var childRelArray : NSArray!
    private var relationArray : NSMutableArray!
    private var ageArray : NSMutableArray!
    private var adultAgeArray : NSArray!
    private var childAgeArray : NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dict = common.unArchiveMyDataForDictionary(Constant.qualifiyReq)
        qualifyRequest.addEntries(from: dict as! [AnyHashable : Any])
        childCount = qualifyRequest.object(forKey: "NoOfChildCount") as! Int
        adultCount = qualifyRequest.object(forKey: "NoOfAdultCount") as! Int
        tenureCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        diseaseCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        adultCollection.register(UINib.init(nibName: "HealthEntries", bundle: nil), forCellWithReuseIdentifier: "HealthEntries")
        childCollection.register(UINib.init(nibName: "HealthEntries", bundle: nil), forCellWithReuseIdentifier: "HealthEntries")

        changeAdultViewHeight()
        changeChildViewHeight()
        
        common.applyRoundedShapeToView(continueBtn, withRadius: 10)
        common.applyRoundedShapeToView(coverageView, withRadius: 5)
        common.applyRoundedShapeToView(deductibleView, withRadius: 5)
        
        common.applyBorderToView(coverageView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(deductibleView, withColor: Colors.textFldColor, ofSize: 1)
        
    }
    
    @IBAction func backBtntapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtntapped(_ sender: UIButton) {
        
    }
    
    func changeAdultViewHeight()
    {
        let heightValue = 0.1+(0.1*0.7*Double((adultCount-1)))
        let high = NSLayoutConstraint.init(item: adultViewHeight.firstItem as Any, attribute: adultViewHeight.firstAttribute, relatedBy: adultViewHeight.relation, toItem: adultViewHeight.secondItem, attribute: adultViewHeight.secondAttribute, multiplier: heightValue, constant: adultViewHeight.constant)
        adultViewHeight.isActive = false
        adultViewHeight = high
        NSLayoutConstraint.activate([adultViewHeight])
        adultView.layoutIfNeeded()
    }
    
    
    func changeChildViewHeight()
    {
        var heightValue = 0.0000000000001
        var hide = true
        
        if (childCount > 0)
        {
            hide = false
            heightValue = 0.1+(0.1*0.7*Double((childCount-1)))
        }
        let high = NSLayoutConstraint.init(item: childViewHeight.firstItem as Any, attribute: childViewHeight.firstAttribute, relatedBy: childViewHeight.relation, toItem: childViewHeight.secondItem, attribute: childViewHeight.secondAttribute, multiplier: heightValue, constant: childViewHeight.constant)
        childViewHeight.isActive = false
        childViewHeight = high
        NSLayoutConstraint.activate([childViewHeight])
        childView.layoutIfNeeded()
        childView.isHidden = hide
        childView.isUserInteractionEnabled = !hide
    }
    
    func alertviewShow(msg : String)
    {
        let alert = SCLAlertView.init(appearance: common.alertwithCancel)
        alert.showError("Alert", subTitle: msg, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }
    
    func openingAgeAndRelationTable(IsAge : Bool)
    {
        if (IsAge)
        {
                // age table to be shown
        }
        else
        {
            // relation table to be shown
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(collectionView.tag)
        {
        case 1:do {
            return Common.yesNoBtnArray.count}
        case 2:do {
            return tenureArray.count}
        case 3: do {
            return adultCount}
        case 4: do {
            return childCount}
        default:do {
            return 0}
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch(collectionView.tag)
        {
        case 1:            do {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
            cell.setDataForNormal(Common.yesNoBtnArray[indexPath.row], ofFontSize: 12)
            if (diseaseTapp == indexPath.row)
            {
                cell.setSelectedData()
                let boolValue = Bool(truncating: indexPath.row as NSNumber)
                self.qualifyRequest.setValue(!boolValue, forKey: "HasAnyDisease")
            }
            return cell
        }
        case 2:            do {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
            let tenure = tenureArray[indexPath.row]
            cell.setDataForNormal(tenure, ofFontSize: 14)
            if (tenureTapp == indexPath.row)
            {
                cell.setSelectedData()
                self.qualifyRequest.setValue(tenure, forKey: "TenureYear")
            }
            return cell
        }
        default:
            do {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HealthEntries", for: indexPath) as! HealthEntries
                cell.controller = self
                cell.displayData(index: indexPath.row)
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(collectionView.tag)
        {
        case 1:
            diseaseTapp = indexPath.row
            collectionView.reloadData()
            break
        case 2:
            tenureTapp = indexPath.row
            collectionView.reloadData()
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = common.getScreenSize(collectionView)
        var sizes = CGSize(width: 0, height: 0)
        switch(collectionView.tag)
        {
        case 1:
            sizes = CGSize(width: 50, height: widthAndHeight.1*0.7)
            break
        case 2:
            sizes = CGSize(width: widthAndHeight.0*0.3, height: widthAndHeight.1*0.8)
            break
        case 3:
            sizes = CGSize(width: widthAndHeight.0, height: (widthAndHeight.1*0.8)/CGFloat(adultCount))
            break
        default:
            if (childCount > 0)
            {
                sizes = CGSize(width: widthAndHeight.0, height: (widthAndHeight.1*0.8)/CGFloat(childCount))
            }
            break
        }
        return sizes;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
        var edgeInsets = UIEdgeInsets.zero
        switch (collectionView.tag)
        {
        case 1:            do{
            edgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0);
        }
        case 2:            do{
            edgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0);
        }
        default:
            break
        }
        return edgeInsets
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

