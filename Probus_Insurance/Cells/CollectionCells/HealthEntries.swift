//
//  HealthEntries.swift
//  Probus_Insurance
//
//  Created by Sankalp on 26/05/22.
//

import UIKit

class HealthEntries: UICollectionViewCell {
    var HealthEntries: UICollectionViewCell!
    
    @IBOutlet weak var serialLbl: UILabel!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var RelationView: UIView!
    @IBOutlet weak var RelationLbl: UILabel!
    @IBOutlet weak var GenderView: UIView!
    @IBOutlet weak var GenderLbl: UILabel!

    var controller : UIViewController!
    private let common = Common.sharedCommon
    
    func displayData(index : Int)
    {
        serialLbl.text = String(index + 1)
        common.applyRoundedShapeToView(ageView, withRadius: 5)
        common.applyRoundedShapeToView(RelationView, withRadius: 5)
        common.applyRoundedShapeToView(GenderView, withRadius: 5)
        
        common.applyBorderToView(ageView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(RelationView, withColor: Colors.textFldColor, ofSize: 1)
        common.applyBorderToView(GenderView, withColor: Colors.textFldColor, ofSize: 1)
        
        let ageTap = UITapGestureRecognizer.init(target: self, action: #selector(gestureTapped(_:)))
        ageView.addGestureRecognizer(ageTap)
        let relationTap = UITapGestureRecognizer.init(target: self, action: #selector(gestureTapped(_:)))
        RelationView.addGestureRecognizer(relationTap)
    }
    
    @objc func gestureTapped(_ sender: UITapGestureRecognizer? = nil) {
        let vi = sender?.view
        var IsAge = false
        if (vi!.isDescendant(of: ageView))
        {
            IsAge = true
        }
        
        if (controller is HealthSecondScreen)
        {
            (controller as! HealthSecondScreen).openingAgeAndRelationTable(IsAge: IsAge)
        }
    }
}
