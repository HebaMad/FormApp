//
//  ViewController.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit

class AuthVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: - Properties

    
    //MARK: - Life cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
    }
    

}
extension AuthVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        signupBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
}

//MARK: - Life cycle

extension AuthVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case signupBtn:
            let vc = SignUpVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case loginBtn:
            let vc = LoginVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
        
    }
}

extension AuthVC:Storyboarded{
    static var storyboardName: StoryboardName = .main

}
