//
//  CustomizeController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 16/11/21.
//

import Foundation
import UIKit

class CustomizeController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private let listArray = Common.sharedCommon.getAccessList()
    private let sharedDef = Common.sharedCommon.sharedUserDefaults()
    private var myDictionary = Common.sharedCommon.getFirstAcessList()
    private var cellCustom : CustomizeCell!
    private var ThisDict = Common.sharedCommon.sharedUserDefaults().object(forKey: "Custom") as? [String] ?? Common.sharedCommon.getFirstAcessList()

    override func viewDidLoad() {
        tableView.register(UINib.init(nibName: "CustomizeCell", bundle: nil), forCellReuseIdentifier: "CustomizeCell")

        Common.sharedCommon.applyRoundedShapeToView(tableView, withRadius: 20.0)

        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true

        if let index = myDictionary.firstIndex(of: "Customize")
        {
            myDictionary.remove(at: index)
        }
    }
        
    @IBAction func backBtnAction(_ sender: Any)
    {
        sharedDef.removeObject(forKey: "Custom")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        ThisDict = Common.sharedCommon.sharedUserDefaults().object(forKey: "Custom") as? [String] ?? []
        sharedDef.set(ThisDict, forKey: "Customize")
        self.navigationController?.popViewController(animated: true)
    }
        
    // MARK: - TABLEVIEW METHODS

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count-1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.view.frame.size.height*0.08;
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellCustom = tableView.dequeueReusableCell(withIdentifier: "CustomizeCell") as? CustomizeCell
        let stringValuee = listArray[indexPath.row]
        var switchVal : Bool! = false
        if (myDictionary.contains(stringValuee))
        {
            switchVal = true
        }
        cellCustom.switchBtn.restorationIdentifier = stringValuee
        cellCustom.displayData(stringValuee, withSwitchValue: switchVal)
        let aView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
        aView.backgroundColor = Common.sharedCommon.hexStringToUIColor(hex: "#DADEEA")
        cellCustom.addSubview(aView)
        return cellCustom;
    }
        
    func updateMyArray(_ stringValuee : String)
    {
        myDictionary = ThisDict
        if let index = myDictionary.firstIndex(of: "Customize")
        {
            myDictionary.remove(at: index)
        }

        if (myDictionary.contains(stringValuee))
        {
            if let index = myDictionary.firstIndex(of: stringValuee)
            {
                myDictionary.remove(at: index)
            }
        }
        else
        {
            myDictionary.append(stringValuee)
        }
        
        sharedDef.set(myDictionary, forKey: "Custom")
    }
}
