//
//  TextFieldView.swift
//  InsuranceApp
//
//  Created by Sankalp on 15/06/22.
//

import UIKit

class TextFieldView: UIView {

    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var textField : UITextField!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialize()
    }
    
    func commonInitialize()
    {
        
        visibilityOFLabel()
    }
    
    func visibilityOFLabel()
    {
        if (textField.hasText)
        {
            label.isHidden = false
        }
        else
        {
            label.isHidden = true
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
