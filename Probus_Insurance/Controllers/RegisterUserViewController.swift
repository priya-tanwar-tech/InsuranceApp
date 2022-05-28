//
//  RegisterUserViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 22/11/21.
//

import Foundation
import UIKit

class RegisterUserViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var backBtn : UIButton!
    
    private let userArray = Common.sharedCommon.getRegisterUserList()
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        tableView.register(UINib.init(nibName: "RegisterCell", bundle: nil), forCellReuseIdentifier: "RegisterCell")
    }
    
    // MARK: - TABLEVIEW METHODS

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.0.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.view.frame.size.height*0.12;
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "RegisterCell") as! RegisterCell
        Cell.display(userArray.0[indexPath.row], andImage: userArray.1[indexPath.row])
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch (indexPath.row)
        {
        case 1:
                let secondViewController = storyboard.instantiateViewController(withIdentifier:"AgentSignInViewController") as! AgentSignInViewController
                secondViewController.stringName = "Agent"
                self.navigationController?.pushViewController(secondViewController, animated: true)
            break
        case 2:
                let secondViewController = storyboard.instantiateViewController(withIdentifier:"AgentSignInViewController") as! AgentSignInViewController
                secondViewController.stringName = "Employee"
                self.navigationController?.pushViewController(secondViewController, animated: true)
            break
        default:
                let secondViewController = storyboard.instantiateViewController(withIdentifier:"CustomerSignUpViewController") as! CustomerSignUpViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            break
        }
    }
        
    @IBAction func backButtonTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
