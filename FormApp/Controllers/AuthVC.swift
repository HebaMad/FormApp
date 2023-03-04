//
//  ViewController.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit
import LocalAuthentication
class AuthVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: - Properties

    
    //MARK: - Life cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthorizeFaceID()
        BindButtons()
    }
    
    func AuthorizeFaceID(){
    let context = LAContext()
        var error:NSError?=nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "please authorize with touch id! "
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, error in
                DispatchQueue.main.async {
                    guard success,error == nil else{
                        let alert = UIAlertController(title: "Failed to Authenticate ", message: "please try Again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel,handler:nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    let nav1 = UINavigationController()
                    let mainView = HomeVC.instantiate()
                    nav1.viewControllers = [mainView]
                    nav1.navigationBar.isHidden = true
                    self?.sceneDelegate.setRootVC(vc: nav1)
                }
               
            }
        }else{
            let alert = UIAlertController(title: "un available ", message: "you can't use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel,handler:nil))
            self.present(alert, animated: true)
        }
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
