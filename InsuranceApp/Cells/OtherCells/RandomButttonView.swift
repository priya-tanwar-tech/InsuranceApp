//
//  RandomButttonView.swift
//  PETTest
//
//  Created by Sankalp on 29/11/21.
//

import Foundation
import UIKit


class RandomButttonView : UICollectionViewCell
{
    var RandomButttonView:UICollectionViewCell!
    private let common = Common.sharedCommon
    private var size: CGFloat!
    
    private let fontName = "Montserrat-Medium"
    private let txt_Color = Common.sharedCommon.hexStringToUIColor(hex: "#252C63")
    private let selected_txt_Color = UIColor.white
    private let select_Color = Common.sharedCommon.hexStringToUIColor(hex: "#00B8CD")
    private let unselect_Color = Common.sharedCommon.hexStringToUIColor(hex: "#00B8CD")

    @IBOutlet weak var titleLbl: UILabel!
    
    func setDataForNormal(_ string: String, ofFontSize fontSize: CGFloat)
    {
        size = fontSize
        common.applyRoundedShapeToView(self, withRadius: self.frame.size.height/2)
        titleLbl.text = string
        titleLbl.textColor = txt_Color
        titleLbl.font = UIFont.init(name: fontName, size: size)
        self.backgroundColor = selected_txt_Color
        common.applyBorderToView(self, withColor: common.hexStringToUIColor(hex: "#BEBEBE"), ofSize: 1)
    }
    
    func setSelectedData()
    {
        common.applyRoundedShapeToView(self, withRadius: self.frame.size.height/2)
        titleLbl.textColor = selected_txt_Color
        titleLbl.font = UIFont.init(name: fontName, size: size)
        self.backgroundColor = select_Color
        common.applyBorderToView(self, withColor: select_Color, ofSize: 1)
    }
}
