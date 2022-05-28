//
//  SecondViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 11/11/21.
//

import Foundation
import UIKit


class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITabBarDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var LearningCollection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionProductView: UIView!
    @IBOutlet weak var productCollection: UICollectionView!
    @IBOutlet weak var productAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var collectionAccessView: UIView!
    @IBOutlet weak var accessCollection: UICollectionView!
    @IBOutlet weak var accessAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var offerCollection: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!

    private let common = Common.sharedCommon
    private var aValue: Bool = false;
    private var arrayList : [String] = []
    private var accessList : [String] = []
    
    private let offerCellArray = Common.sharedCommon.getOfferArray()
    private let learnArray = Common.sharedCommon.getLearnAndTrainArray()
    private var selecteedItemValue = 0

    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuRevealWidth: CGFloat = 260
    private var isExpanded: Bool = false
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    private let paddingForRotation: CGFloat = 150
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var revealSideMenuOnTop: Bool = true

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        accessCollection.register(UINib(nibName: "ViewCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        LearningCollection.register(UINib(nibName: "LearnMasterCell", bundle: nil), forCellWithReuseIdentifier: "learnCell")
        offerCollection.register(UINib(nibName: "offerCell", bundle: nil), forCellWithReuseIdentifier: "offerCell")
        productCollection.register(UINib(nibName: "ViewCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")

        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        sideMenuViewController.delegate = self
        view.insertSubview(sideMenuViewController!.view, at: revealSideMenuOnTop ? 4 : 0)
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

       // Default Main View Controller
       showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
        // Shadow Background View
        
        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
//        panGestureRecognizer.delegate = self
//        view.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
//        if self.revealSideMenuOnTop {
//            view.insertSubview(self.sideMenuShadowView, at: 1)
//        }
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar.selectedItem = tabBar.items![selecteedItemValue]
        aValue = false
        arrayList = common.getAgentProductList()
        accessList = common.getFirstAcessList()
        setSizeOfAccessList()
        setSizeOfProductList()
        accessCollection.reloadData()
        productCollection.reloadData()
    }
    
    func setSizeOfAccessList()
    {
        var val : Int = (accessList.count-1)%4;
        let anotherValue : Int = (accessList.count-1)/4
        val = anotherValue + 1

        collectionAccessView.removeConstraint(accessAspectRatio)
        switch (val)
        {
        case 2:
                accessAspectRatio = common.getConstarint(collectionAccessView, withMultiplierValue: CGFloat(val)*0.28)
               break
        case 1:
               accessAspectRatio = common.getConstarint(collectionAccessView, withMultiplierValue: CGFloat(val)*0.3)
            break
        case 3:
                accessAspectRatio = common.getConstarint(collectionAccessView, withMultiplierValue: CGFloat(val)*0.27)
            break
        default:
               accessAspectRatio = common.getConstarint(collectionAccessView, withMultiplierValue: CGFloat(val)*0.26)
            break
        }
        collectionAccessView.addConstraint(accessAspectRatio)
        collectionAccessView.layoutIfNeeded()
    }
    
    func setSizeOfProductList()
    {
        var val : Int = arrayList.count/4;
        if (val == 0)
        {
            val = 1
        }
        
        collectionProductView.removeConstraint(productAspectRatio)
        productAspectRatio = common.getConstarint(collectionProductView, withMultiplierValue: CGFloat(val)*0.29)
        collectionProductView.addConstraint(productAspectRatio)
        collectionProductView.layoutIfNeeded()
    }
    
    // MARK: - COLLECTION METHODS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tagValue: Int = collectionView.tag
        switch(tagValue)
        {
        case 11:
            return arrayList.count
        case 12:
            return accessList.count
        case 13:
            return offerCellArray.0.count
        default:
            return learnArray.0.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tagValue: Int = collectionView.tag
        switch(tagValue)
        {
        case 11:
            do {
                let Cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! ViewCell)
                Cell.displayData(arrayList[indexPath.row] as NSString)
                collectionView.addSubview(Cell)
                return Cell
            }
        case 12:
            do {
                let Cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! ViewCell)
                let stringValue : String = accessList[indexPath.row]
                Cell.displayData(stringValue as NSString)
                Cell.firstName.textColor = UIColor.white
                Cell.secondName.textColor = UIColor.white;
                if (stringValue.contains(":"))
                {
                    Cell.firstName.lineBreakMode = NSLineBreakMode.byCharWrapping
                    Cell.firstName.numberOfLines = 0
                    Cell.secondName.isHidden = false;
                    let comp = stringValue.components(separatedBy: ":")
                    Cell.firstName.text = comp.first
                    Cell.secondName.text = comp.last
                }
                collectionView.addSubview(Cell)
                return Cell
            }
        case 13:
            do {
                // offerCellArray :  title , subtitle, description, imageName, color of view

                let Cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as! offerCell)
                Cell.imageView.image = UIImage.init(named: offerCellArray.3[indexPath.row])
                Cell.headerLabel.text = offerCellArray.0[indexPath.row]
                Cell.displayData(((offerCellArray.1[indexPath.row] as NSString?)!))
                Cell.desciptionLbl.highlight(offerCellArray.2[indexPath.row], colorValue: common.hexStringToUIColor(hex: "#242B63"))
                Cell.backView.backgroundColor = common.hexStringToUIColor(hex: offerCellArray.4[indexPath.row])
                collectionView.addSubview(Cell)
                return Cell;
            }
        default:
            do {
                //LearnAndTrainArray :  title , subtitle, button text, imageName, color of view
                let Cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "learnCell", for: indexPath) as! LearnMasterCell)
                Cell.imageView.image = UIImage.init(named: learnArray.3[indexPath.row])
                Cell.backView.backgroundColor = common.hexStringToUIColor(hex: learnArray.4[indexPath.row])
                Cell.attendView.text = learnArray.0[indexPath.row]
                Cell.exploreButton.setTitle(learnArray.2[indexPath.row], for: UIControl.State.normal)
                Cell.learnView.text = learnArray.1[indexPath.row]
                Cell.displayView()
                let r: Int = indexPath.row
                if (r == 1)
                {
                    let color :UIColor = common.hexStringToUIColor(hex: "#242B63")
                    Cell.learnView.highlightMyText(learnArray.1[indexPath.row], searchedText: learnArray.1[indexPath.row], colorValue: color, withFontName:  UIFont.init(name: "Montserrat-SemiBold", size: 14)!)
                }
                collectionView.addSubview(Cell)
                return Cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let tagValue: Int = indexPath.row
        switch(tagValue)
        {
        case 11:
            break
        case 12:
            break
        case 13:
            break
        default:
                pageControl.currentPage = tagValue
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthAndHeight = common.getScreenSize(collectionView)
        var sizes: CGSize = CGSize.init(width: 0, height: 0)
        let tagValue: Int = collectionView.tag

        switch(tagValue)
        {
        case 11:
                let CellWidth = widthAndHeight.0/(4.5)
                sizes = CGSize(width: CellWidth, height: CellWidth)
            break
        case 12:
                let CellWidth = widthAndHeight.0/(4.5)
                sizes = CGSize(width: CellWidth, height: CellWidth)
            break
        case 13:
                let CellWidth = widthAndHeight.0/2
                let CellHeight = widthAndHeight.1*0.9
                sizes = CGSize(width: CellWidth, height: CellHeight)
            break
        default:
                let CellHeight = widthAndHeight.1
                let CellWidth = widthAndHeight.0
                sizes = CGSize(width: CellWidth, height: CellHeight)
            break
        }
        return sizes;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tagValue: Int = collectionView.tag
        switch (tagValue)
        {
        case 11:
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
                            arrayList = common.getAgentProductList()
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
                    common.sharedUserDefaults().set("Health".uppercased, forKey: "ProductName")
                    common.sharedUserDefaults().set("Health", forKey: "ProductCode")
                    common.sharedUserDefaults().set(common.HELFM, forKey: "SubProductCode")
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
                break
        case 12:
                let aIn : Int = indexPath.row
                if(aIn == (accessList.count-1))
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let customizeController = storyboard.instantiateViewController(withIdentifier:"CustomizeController") as! CustomizeController
                    self.navigationController?.pushViewController(customizeController, animated: true)
                }
            break
        default:
            break
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        print("I am called")
        if (item.title!.contains("Menu"))
        {
            self.sideMenuState(expanded: true)
        }
        else
        {
            
        }
        
//        tabBar.selectedItem = tabBar.items![selecteedItemValue]

    }
    
}

extension SecondViewController: SideMenuViewControllerDelegate {
    func selectedCell() {
        self.sideMenuState(expanded: false)
        // Collapse side menu with animation
//        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
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
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
//            if self.sideMenuShadowView != nil {
//                vc.view.addSubview(self.sideMenuShadowView)
//            }
        }
        vc.didMove(toParent: self)
    }

    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
//            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
//            UIView.animate(withDuration: 0.5) {self.sideMenuShadowView.alpha = 0.0 }
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
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
}


extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> SecondViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is SecondViewController {
            return viewController! as? SecondViewController
        }
        while (!(viewController is SecondViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is SecondViewController {
            return viewController as? SecondViewController
        }
        return nil
    }
    
}

extension SecondViewController: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
                if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (self.isExpanded)
        {
            if (!((touch.view?.isDescendant(of: self.sideMenuViewController.view))!)) {
                return true
            }
        }
        return false
    }
    /*
    // Dragging Side Menu
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        // ...

        let position: CGFloat = sender.translation(in: self.scrollView).x
        let velocity: CGFloat = sender.velocity(in: self.scrollView).x

        switch sender.state {
        case .began:

            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }

            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }

            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }

                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }

        case .changed:

            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                       // Show/Hide shadow background view while dragging

                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }*/
    
}
