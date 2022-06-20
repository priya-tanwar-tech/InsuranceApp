//
//  offerCell.swift
//  InsuranceApp
//
//  Created by Sankalp on 10/11/21.
//

import Foundation
import UIKit

class offerCell: UICollectionViewCell {
    var offerCell: UICollectionViewCell!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var coverLbl: UILabel!
    @IBOutlet weak var desciptionLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descConst: NSLayoutConstraint!
    @IBOutlet weak var coverConst: NSLayoutConstraint!
    
    private let common = Common.sharedCommon

    func displayData(_ string : NSString)
    {
        coverLbl.isHidden = true
        if (string.description.isEmpty)
        {
            coverConst.constant = -10
            descConst.constant = -5
        }
        else
        {
            coverLbl.isHidden = false
            coverLbl.text = string as String
        }
        common.applyRoundedShapeToView(backView, withRadius: 10.0)
        common.applyShadowToView(self, withColor: UIColor.black, opacityValue: 0.3, radiusValue: 1)
    }
}
