//
//  LearnMasterCell.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 11/11/21.
//

import Foundation
import UIKit


class LearnMasterCell: UICollectionViewCell {
    var LearnMasterCell: UICollectionViewCell!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var learnView: UILabel!
    @IBOutlet weak var attendView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private let common = Common.sharedCommon

    func displayView()
    {
        common.applyRoundedShapeToView(backView, withRadius: 10.0)
        common.applyRoundedShapeToView(exploreButton, withRadius: 10.0)
        common.applyShadowToView(self, withColor: UIColor.black, opacityValue: 0.3, radiusValue: 1)
    }
}
