//
//  TermInsuranceViewController.swift
//  PETTest
//
//  Created by Sankalp on 29/11/21.
//

import Foundation
import UIKit

class TermInsuranceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var countinueBtn : UIButton!
    
    @IBOutlet weak var maleBackgroundView : UIView!
    @IBOutlet weak var maleImageView : UIImageView!
    @IBOutlet weak var maleView : UIView!

    @IBOutlet weak var femaleBackgroundView : UIView!
    @IBOutlet weak var femaleImageView : UIImageView!
    @IBOutlet weak var femaleView : UIView!

    @IBOutlet weak var datePicker : UIDatePicker!
    @IBOutlet weak var dateView : UIView!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var ageLabel : UILabel!
    
    @IBOutlet weak var incomeView : UIView!
    @IBOutlet weak var incomeLabel : UILabel!
    @IBOutlet weak var incomeCollection : UICollectionView!
    
    @IBOutlet weak var incomeTable : UIView!
    @IBOutlet weak var incomeTableView : UITableView!
    
    private let common = Common.sharedCommon
    private var tappedValue: Int!
    private var buttonArray : NSArray!
    private var dict : NSDictionary = NSDictionary.init()
    private var incomeArray : NSArray!
    
    override func viewDidLoad()
    {
        common.applyBorderToView(incomeView, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1)
        common.applyBorderToView(dateView, withColor: common.hexStringToUIColor(hex: "#052576"), ofSize: 1)
        
        common.applyRoundedShapeToView(countinueBtn, withRadius: 10)
        common.applyRoundedShapeToView(incomeView, withRadius: 5)
        common.applyRoundedShapeToView(dateView, withRadius: 5)
        common.applyRoundedShapeToView(ageLabel, withRadius: 10)

        incomeTable.backgroundColor = UIColor.clear
        incomeCollection.register(UINib.init(nibName: "RandomButtonView", bundle: nil), forCellWithReuseIdentifier: "RandomButtonView")
        incomeTableView.register(UINib.init(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableCell")
        setRadioButtonValue(true)
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.GenderSelect(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.GenderSelect(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.dateSelect(_:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.incomeSelect(_:)))
        
        maleBackgroundView.addGestureRecognizer(tap1)
        femaleBackgroundView.addGestureRecognizer(tap2)
        dateView.addGestureRecognizer(tap3)
        incomeView.addGestureRecognizer(tap4)

        dateLabel.text = "01-01-2004"
        ageLabel.text = "18 years"
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)

        APICallered().fetchData(common.testAPI+common.baseURL+common.forApi+common.termLife+common.coverageAmount) { response in
            self.dict = response ?? NSDictionary.init()
            self.incomeArray = self.dict.object(forKey: "Response") as? NSArray
            if (self.incomeArray != nil)
            {
                self.buttonArray = self.common.aFunction(self.incomeArray, positionStart: 2, positionEnd: 10)
            }
            DispatchQueue.main.async {
                self.incomeTableView.reloadData()
                self.incomeCollection.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (incomeArray == nil)
        {
            return 0
        }
        return incomeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableCell") as! IncomeTableViewCell
        let nameDict = (incomeArray[indexPath.row]) as? NSDictionary
        let string = nameDict?.object(forKey: "Name") as! String
        cell.setDispaly(string)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameDict = (incomeArray[indexPath.row]) as? NSDictionary
        let string = nameDict?.object(forKey: "Name") as! String
        tappedValue = nil;
        incomeLabel.text = string
        incomeTable.isHidden = true
        incomeCollection.isHidden = false
        incomeCollection.reloadData()
    }
    
    @IBAction private func backBtnTapped(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func countinueBtnTapped(_ sender : UIButton)
    {
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if (buttonArray == nil)
        {
            return 0
        }
        return buttonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomButtonView", for: indexPath) as! RandomButttonView
        let nameDict = (buttonArray[indexPath.row]) as? NSDictionary
        let string = nameDict?.object(forKey: "Name") as! String
        cell.setDataForNormal(string, ofFontSize: 12)
        if (tappedValue != nil && tappedValue == indexPath.row)
        {
            cell.setSelectedData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedValue = indexPath.row
        let nameDict = (buttonArray[indexPath.row]) as? NSDictionary
        let string = nameDict?.object(forKey: "Name") as! String
        incomeLabel.text = string
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let nameDict = (buttonArray[indexPath.row]) as? NSDictionary
        let string = nameDict?.object(forKey: "Name") as! String
        let widthOfCell = string.count
        
        let widthAndHeight = common.getScreenSize(collectionView)
        var sizes: CGSize = CGSize.init(width: 0, height: 0)
        let CellHeight = widthAndHeight.1*0.17
        let CellWidth = CGFloat(widthOfCell*10)
        sizes = CGSize(width: CellWidth, height: CellHeight)
        return sizes;
    }
        
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
    }
    
    func setRadioButtonValue(_ IsMale: Bool)
    {
        if (IsMale)
        {

            common.applyRoundedShapeToView(maleBackgroundView, withRadius: 5)
            common.applyBorderToView(maleBackgroundView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)
            common.applyRoundedShapeToView(maleImageView, withRadius: 12)
            common.applyBorderToView(maleImageView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)
            common.applyRoundedShapeToView(maleView, withRadius: 12)
            maleView.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")
            
            common.applyRoundedShapeToView(femaleBackgroundView, withRadius: 5)
            common.applyBorderToView(femaleBackgroundView, withColor: Colors.textFldColor, ofSize: 1.0)
            common.applyRoundedShapeToView(femaleImageView, withRadius: 12)
            common.applyBorderToView(femaleImageView, withColor: Colors.textFldColor, ofSize: 2.0)
            common.applyRoundedShapeToView(femaleView, withRadius: 12)
            femaleView.backgroundColor = UIColor.clear
        }
        else
        {

            common.applyRoundedShapeToView(femaleBackgroundView, withRadius: 5)
            common.applyBorderToView(femaleBackgroundView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)
            common.applyRoundedShapeToView(femaleImageView, withRadius: 12)
            common.applyBorderToView(femaleImageView, withColor: common.hexStringToUIColor(hex: "#00B8CD"), ofSize: 2.0)
            common.applyRoundedShapeToView(femaleView, withRadius: 12)
            femaleView.backgroundColor = common.hexStringToUIColor(hex: "#00B8CD")

            common.applyRoundedShapeToView(maleBackgroundView, withRadius: 5)
            common.applyBorderToView(maleBackgroundView, withColor: Colors.textFldColor, ofSize: 1.0)
            common.applyRoundedShapeToView(maleImageView, withRadius: 12)
            common.applyBorderToView(maleImageView, withColor: Colors.textFldColor, ofSize: 2.0)
            common.applyRoundedShapeToView(maleView, withRadius: 12)
            maleView.backgroundColor = UIColor.clear
        }
    }
    
    @objc private func handleDateSelection()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        dateLabel.text = dateString        //Calculate age
        
        let components = datePicker.calendar.dateComponents([.year], from: self.datePicker.date)
        let dob = DateComponents(calendar: .current, year: components.year).date!
        let ageString = String.init(stringLiteral: String(dob.age)+" years")
        
        ageLabel.text = ageString
        datePicker.resignFirstResponder()
    }
   
    
    @objc func GenderSelect(_ sender: UITapGestureRecognizer? = nil) {
        let vi = sender?.view
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
        datePicker.isHidden = false
        datePicker.becomeFirstResponder()
    }
    
    

    @objc func incomeSelect(_ sender: UITapGestureRecognizer? = nil) {
        if (incomeTable.isHidden && (!(incomeArray==nil)))
        {
            incomeTable.isHidden = false
            incomeCollection.isHidden = true
        }
    }
}
