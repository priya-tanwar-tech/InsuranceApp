//
//  ViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 08/11/21.
//

import UIKit
import Foundation


class ViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var aspectRatioConstaint: NSLayoutConstraint!
    @IBOutlet weak var collectionProductView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var offerCollection: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var cornerRoundView: UIView!
    
    private let common = Common.sharedCommon
    private let offerArray = Common.sharedCommon.getOfferArray()
    private var arrayList : [String] = []
    private var aValue: Bool = false;
    private var sideMenuViewController : SideMenuViewController!
    private var revealSideMenuOnTop: Bool = true
    private var isExpanded: Bool = false
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    private var sideMenuRevealWidth: CGFloat = 260

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        common.applyRoundedShapeToView(cornerRoundView, withRadius: 10.0)

        tabBar.selectedItem = tabBar.items![0]
        collectionVu.register(UINib(nibName: "ViewCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        offerCollection.register(UINib(nibName: "offerCell", bundle: nil), forCellWithReuseIdentifier: "offerCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        aValue = false
        arrayList = common.getEmpOrCustProductList()
        setSizeOfProductList()
        collectionVu.reloadData()
    }
            
    func setSizeOfProductList()
    {
        var val : Int = arrayList.count/4;
        if (val == 0)
        {
            val = 1
        }
        
        collectionProductView.removeConstraint(aspectRatioConstaint)
        if (aValue)
        {
            aspectRatioConstaint = common.getConstarint(collectionProductView, withMultiplierValue: CGFloat(val)*0.28)
        }
        else
        {
            aspectRatioConstaint = common.getConstarint(collectionProductView, withMultiplierValue: CGFloat(val)*0.25)
        }
        collectionProductView.addConstraint(aspectRatioConstaint)
        collectionProductView.layoutIfNeeded()
    }
    

    // MARK: - COLLECTION METHODS

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView.tag != 10)
        {
            return arrayList.count
        }
        else
        {
            return offerArray.0.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView.tag != 10)
        {
            let myCustomView = (collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! ViewCell)
            myCustomView.displayData(((arrayList[indexPath.row] as NSString?)!))
            collectionView.addSubview(myCustomView)
            return myCustomView
        }
        else
        {
            // offerCellArray :  title , subtitle, description, imageName, color of view

            let Cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as! offerCell)
            Cell.imageView.image = UIImage.init(named: offerArray.3[indexPath.row])
            Cell.headerLabel.text = offerArray.0[indexPath.row]
            Cell.displayData(((offerArray.1[indexPath.row] as NSString?)!))
            Cell.desciptionLbl.highlight(offerArray.2[indexPath.row], colorValue: common.hexStringToUIColor(hex: "#242B63"))
            Cell.backView.backgroundColor = common.hexStringToUIColor(hex: offerArray.4[indexPath.row])
            collectionView.addSubview(Cell)
            return Cell;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.tag != 10)
        {
            let aIn : Int = indexPath.row
            switch (aIn)
            {
            case (arrayList.count-1):
                    if (!aValue)
                    {
                        aValue = true;
                        arrayList = common.allProductList()
                    }
                    else
                    {
                        aValue = false;
                        arrayList = common.getEmpOrCustProductList()
                    }
                    setSizeOfProductList()
                    collectionView.reloadData()
                break
            case 0:
                    common.goToNextScreenWith("TermInsuranceViewController", self)
                break
            case 1:
                break
            case 2:
                    common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                    common.sharedUserDefaults().set("2", forKey: "ProductCode")
                    common.sharedUserDefaults().set(common.MTRPC, forKey: "SubProductCode")
                    common.goToNextScreenWith("MotorInsuranceViewController", self)
                break
            case 3:
                    common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                    common.sharedUserDefaults().set("1", forKey: "ProductCode")
                    common.sharedUserDefaults().set(common.MTRTW, forKey: "SubProductCode")
                    common.goToNextScreenWith("MotorInsuranceViewController", self)
                break
            case 4:
                    common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                    common.sharedUserDefaults().set("10", forKey: "ProductCode")
                    common.sharedUserDefaults().set(common.MTRGV, forKey: "SubProductCode")
                    common.goToNextScreenWith("GC_PC_MiscViewController", self)
                break
            case 5:

                let healthDictionary = NSMutableDictionary.init()
                let anyDict = common.unArchiveMyDataForDictionary(Constant.qualifiyReq)
                if (anyDict != nil)
                {
                    healthDictionary.addEntries(from:anyDict  as! [AnyHashable : Any])
                }
                healthDictionary.setValue("Health", forKey: "ProductCode")
                healthDictionary.setValue(Constant.HELFM, forKey: "SubProductCode")
                healthDictionary.setValue(Constant.PIBL, forKey: "BrokerId")
                healthDictionary.setValue(Constant.DeviceId, forKey: "DeviceId")
                common.archiveMyDataForDictionary(healthDictionary, withKey: Constant.qualifiyReq)
                common.goToNextScreenWith("HealthInsuranceFirstController", self)
                break
            case 12:
                break
            case 20:
                common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                common.sharedUserDefaults().set("9", forKey: "ProductCode")
                common.sharedUserDefaults().set(common.MTRPV, forKey: "SubProductCode")
                common.goToNextScreenWith("GC_PC_MiscViewController", self)
                break

            case 21:
                common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                common.sharedUserDefaults().set("17", forKey: "ProductCode")
                common.sharedUserDefaults().set(common.MTRMV, forKey: "SubProductCode")
                common.goToNextScreenWith("GC_PC_MiscViewController", self)
                break
            default:
                break
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthAndHeight = common.getScreenSize(collectionView)
        var sizes: CGSize = CGSize.init(width: 0, height: 0)

        if (collectionView.tag != 10)
        {
            let CellWidth = widthAndHeight.0/(4.5)
            sizes = CGSize(width: CellWidth, height: CellWidth)
        }
        else
        {
            let CellWidth = widthAndHeight.0/1.8
            let CellHeight = widthAndHeight.1*0.9
            sizes = CGSize(width: CellWidth, height: CellHeight)
        }
        return sizes;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
    }
}
