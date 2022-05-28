//
//  ThirdViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 13/11/21.
//

import Foundation
import UIKit
import EventKit

class ThirdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collection : UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartBtn: UIButton!
    let startArray = Common.sharedCommon.getStartedViewArrays();
    var nextItem : NSIndexPath!
    
    override func viewDidLoad()
    {
        Common.sharedCommon.applyRoundedShapeToView(getStartBtn, withRadius: 10.0)

        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationController?.edgesForExtendedLayout = []
        collection.register(UINib.init(nibName: "GetStartCell", bundle: nil), forCellWithReuseIdentifier: "getStartCell")
        pageControl.numberOfPages = startArray.0.count
    }
    
    // MARK: - OTHER METHODS

    @IBAction func pageChangeForLoad(_ sender: Any)
    {
        let pgCntrl = sender as! UIPageControl
        nextItem = NSIndexPath(row: pgCntrl.currentPage, section: 0)
        collection.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        changePage(nextItem.row)
    }
    
    func changePage(_ index: Int)
    {
        pageControl.currentPage = index;
    }
   
    @IBAction func changePageControlIndexWithSatrtBtn(_ sender: Any)
    {
        let pageIndex: Int = pageControl.currentPage
        if (pageIndex == (startArray.0.count - 1))
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier:"ViewController") as! ViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
//            Common.sharedCommon.goToNextScreenWith("SignInNumberViewController", self)
        }
        else
        {
            nextItem = NSIndexPath(row: pageIndex + 1, section: 0)
            collection.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
            changePage(nextItem.row)
        }
    }
    
    // MARK: - COLLECTION METHODS

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return startArray.0.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "getStartCell", for: indexPath) as! GetStartCell
        cell.displayData(startArray.0[indexPath.row], description: startArray.1[indexPath.row], withImageName: startArray.2[indexPath.row])
        if (indexPath.row == 2)
        {
            cell.imageView.contentMode = UIView.ContentMode.scaleAspectFill
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthAndHeight = Common.sharedCommon.getScreenSize(collectionView)
        let CellWidth = widthAndHeight.0/1
        let CellHeight = widthAndHeight.1/1
        let sizes: CGSize = CGSize(width: CellWidth, height: CellHeight)
        return sizes;
    }
}
