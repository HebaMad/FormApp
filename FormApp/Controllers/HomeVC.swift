//
//  HomeVC.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var qcFormBtn: UIButton!
    @IBOutlet weak var emailSupportBtn: UIButton!
    
    //MARK: - Properties

    
    //MARK: - Life cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
    }
    

}
extension HomeVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        qcFormBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        emailSupportBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
}


extension HomeVC:Storyboarded{
    static var storyboardName: StoryboardName = .main

}

extension HomeVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case qcFormBtn:
            let vc = QCFormVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case emailSupportBtn:print("")
        default:
            print("")
        }
        
    }
}
