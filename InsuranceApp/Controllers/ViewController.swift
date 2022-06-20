//
//  ViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 08/11/21.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, SideMenuViewControllerDelegate
{
    @IBOutlet weak var aspectRatioConstaint: NSLayoutConstraint!
    @IBOutlet weak var collectionProductView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var offerCollection: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var hiName: UILabel!
    
    private let common = Common.sharedCommon
    private let offerArray = Common.sharedCommon.getOfferArray()
    private let arrayList = Common.sharedCommon.allProductList()

    private var sideMenuViewController : SideMenuViewController!
    private var sideMenuRevealWidth: CGFloat = 260
    private var isExpanded: Bool = false
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    private let paddingForRotation: CGFloat = 150
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var revealSideMenuOnTop: Bool = true
    private var selecteedItemValue = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let userID = (common.sharedUserDefaults().object(forKey: "UserId") as? String)
        var name : String! = "Hi, "
        
        if (userID != nil && !userID!.elementsEqual("0"))
        {
            let logInResp = common.unArchiveMyDataForDictionary("LoginResponse")
            
            if (logInResp != nil)
            {
                let FName = logInResp?.object(forKey: "FirstName") as? String
                let LName = logInResp?.object(forKey: "LastName") as? String
                
                if (FName != nil)
                {
                    name += FName!
                }
                if (FName != nil && LName != nil)
                {
                    name += " "+LName!
                }
            }
        }
        
        hiName.text = name
        
        collectionVu.register(UINib(nibName: "ViewCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        offerCollection.register(UINib(nibName: "offerCell", bundle: nil), forCellWithReuseIdentifier: "offerCell")
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        sideMenuViewController.delegate = self
        view.insertSubview(sideMenuViewController!.view, at: revealSideMenuOnTop ? 3 : 0)
        addChild(sideMenuViewController!)
        sideMenuViewController!.didMove(toParent: self)

        // Side Menu AutoLayout

        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        if revealSideMenuOnTop {
            sideMenuTrailingConstraint = sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -sideMenuRevealWidth - paddingForRotation)
            sideMenuTrailingConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate([
            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: sideMenuRevealWidth),
            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])

       showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        if (item.title!.contains("Menu"))
        {
            sideMenuState(expanded: true)
        }
        else
        {
            selecteedItemValue = 0
            viewWillAppear(false)
        }
//        else if (item.title!.contains("Home"))
//        {
//            selecteedItemValue = 0
//            viewWillAppear(false)
//        }
//        else
//        {
//            let alert = SCLAlertView.init(appearance: common.alertwithCancel)
//            alert.showInfo("Coming Soon", subTitle: nil, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
//            selecteedItemValue = 0
//            viewWillAppear(false)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBar.selectedItem = tabBar.items![selecteedItemValue]
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
        aspectRatioConstaint = common.getConstarint(collectionProductView, withMultiplierValue: CGFloat(val)*0.28)
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
            case 0:
                common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                common.sharedUserDefaults().set("2", forKey: "ProductCode")
                common.sharedUserDefaults().set(Constant.MTRPC, forKey: "SubProductCode")
                common.goToNextScreenWith("MotorInsuranceViewController", self)
                break
            case 1:
                common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                common.sharedUserDefaults().set("1", forKey: "ProductCode")
                common.sharedUserDefaults().set(Constant.MTRTW, forKey: "SubProductCode")
                common.goToNextScreenWith("MotorInsuranceViewController", self)
                break
            case 2:
                common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                common.sharedUserDefaults().set("10", forKey: "ProductCode")
                common.sharedUserDefaults().set(Constant.MTRGV, forKey: "SubProductCode")
                common.goToNextScreenWith("GC_PC_MiscViewController", self)
                break
                //            case 12:
                //                break
            case 3:
                common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                common.sharedUserDefaults().set("9", forKey: "ProductCode")
                common.sharedUserDefaults().set(Constant.MTRPV, forKey: "SubProductCode")
                common.goToNextScreenWith("GC_PC_MiscViewController", self)
                break
            case 4:
                common.sharedUserDefaults().set("MOTOR", forKey: "ProductName")
                common.sharedUserDefaults().set("17", forKey: "ProductCode")
                common.sharedUserDefaults().set(Constant.MTRMV, forKey: "SubProductCode")
                common.goToNextScreenWith("GC_PC_MiscViewController", self)
                break
            case 5:
                let userId = common.sharedUserDefaults().object(forKey: "UserId") as? String
                let urlStr = Constant.buyAPI+Constant.baseURL+Constant.insurance+Constant.homeInsur+Constant.indexx+Constant.user_ID+userId!
                let titleStr = arrayList[indexPath.row].replacingOccurrences(of: ":", with: " ")
                openUrlInNextScreen(urlString: urlStr, title: titleStr)
                break
            case 6:
                let userId = common.sharedUserDefaults().object(forKey: "UserId") as? String
                let urlStr = Constant.buyAPI+Constant.baseURL+Constant.insurance+Constant.buisnessInsur+Constant.indexx+Constant.user_ID+userId!
                let titleStr = arrayList[indexPath.row].replacingOccurrences(of: ":", with: " ")
                openUrlInNextScreen(urlString: urlStr, title: titleStr)
                break
            case 7:
                let userId = common.sharedUserDefaults().object(forKey: "UserId") as? String

                let urlStr = Constant.buyAPI+Constant.baseURL+Constant.insurance+Constant.lifeInsur+Constant.indexx+Constant.user_ID+userId!
                let titleStr = arrayList[indexPath.row].replacingOccurrences(of: ":", with: " ")
                openUrlInNextScreen(urlString: urlStr, title: titleStr)
                break
            case 8:
                let titleStr = arrayList[indexPath.row].replacingOccurrences(of: ":", with: " ")
                openUrlInNextScreen(urlString: "https://pos.hdfclife.com/login", title: titleStr)
                break
            default:
                let alert = SCLAlertView.init(appearance: common.alertwithCancel)
                alert.showInfo("Coming Soon", subTitle: nil, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(self.common.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
                break
            }
        }
    }
    
    @IBAction func whatsAppLink(_ sender: UIButton)
    {
        let myURL = URL(string:"https://api.whatsapp.com/send?phone=917304332968")!
        UIApplication.shared.open(myURL)
    }
    
    func openUrlInNextScreen(urlString url: String, title lbl : String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webView = storyboard.instantiateViewController(withIdentifier:"WebViewController") as! WebViewController
        webView.urlString = url
        webView.titleString = lbl
        self.navigationController?.pushViewController(webView, animated: true)
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
    
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
                if isExpanded {
                sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (isExpanded)
        {
            if (!((touch.view?.isDescendant(of: sideMenuViewController.view))!)) {
                return true
            }
        }
        return false
    }
    
    func selectedCell() {
        sideMenuState(expanded: false)
        selecteedItemValue = 0
        viewWillAppear(false)
    }

    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        self.view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        self.addChild(vc)
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
        }
        vc.didMove(toParent: self)
    }

    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: revealSideMenuOnTop ? 0 : sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
        }
        else {
            self.animateSideMenu(targetPosition: revealSideMenuOnTop ? (-sideMenuRevealWidth - paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
        }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
            }
        }
    }
    
    func revealSideMenu() {
        sideMenuState(expanded: isExpanded ? false : true)
    }
}

