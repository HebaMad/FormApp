//
//  AppPresenter.swift
//  FormApp
//
//  Created by heba isaa on 19/02/2023.
//

import Foundation
import UIKit
protocol FormDelegate{
    
    func showAlerts(title:String,message:String)
    func getUserData(user:User)
    func getCompanyData(data:CompaniesData)
    func getJobData(data:JobData)
    func getFormsData(data:FormsData)
    func getDivition(data:DiviosnData)
    func getFormItemsData(data:FormItemData)


    
}
typealias FormsDelegate = FormDelegate & UIViewController

class AppPresenter:NSObject{
    weak var delegate:FormsDelegate?
    
 
    func signup(firstName:String,lastName:String,email:String,password:String){
        AppManager.shared.signUpUser(fname: firstName, lname: lastName, email: email, password: password) { Response in
            switch Response{
                
            case let .success(response):
                if response.status == true{
                    self.delegate?.getUserData(user: response.data!)
                }else{
                    self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                }
            case  .failure(_):
                self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                
        }
        }
    }
    
    func login(email:String,password:String){
        AppManager.shared.login(email: email, password: password) { Response in
            switch Response{
                
            case let .success(response):
                if response.status == true{
                    self.delegate?.getUserData(user: response.data!)

                }else{
                    self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                }
            case  .failure(_):
                self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                
        }
        }
    }
    
    func getCompanies(){
        AppManager.shared.getCompanies { Response in
            switch Response{
                
            case let .success(response):
                if response.status == true{
                    self.delegate?.getCompanyData(data: response.data!)
                }else{
                    self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                }
            case  .failure(_):
                self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                
        }
        }
    }
    
    func getJobs(companyID:String){
        AppManager.shared.getJob(companyId:companyID ) { Response in
                
                switch Response{
                    
                case let .success(response):
                    if response.status == true{
                        self.delegate?.getJobData(data: response.data!)

                    }else{
                        self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                    }
                case  .failure(_):
                    self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                    
            }
        }
    }
    
    func getForms(){
        AppManager.shared.forms{ Response in
                
                switch Response{
                    
                case let .success(response):
                    if response.status == true{
                        self.delegate?.getFormsData(data: response.data!)

                    }else{
                        self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                    }
                case  .failure(_):
                    self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                    
            }
        }
    }
    
    func getDivision(){
        AppManager.shared.division{ Response in
                
                switch Response{
                    
                case let .success(response):
                    if response.status == true{
                        self.delegate?.getDivition(data: response.data!)

                    }else{
                        self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                    }
                case  .failure(_):
                    self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                    
            }
        }
    }
    
    func logout(){
        AppManager.shared.logout{ Response in
                
                switch Response{
                    
                case let .success(response):
                    if response.status == true{
                        self.delegate?.showAlerts(title:"Success", message: response.message ?? "")

                    }else{
                        self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                    }
                case  .failure(_):
                    self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                    
            }
        }
    }
    func getFormItem(formTypeID:String){
        AppManager.shared.getFormItems(form_type_id:formTypeID ){ Response in
                
                switch Response{
                    
                case let .success(response):
                    if response.status == true{
                        self.delegate?.getFormItemsData(data: response.data!)

                        
                    }else{
                        self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                    }
                case  .failure(_):
                    self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                    
            }
        }
    }
    
    func submitFormData(formsDetails:[String : Any]){
        AppManager.shared.submitForms(formsDetails: formsDetails) { Response in
            switch Response{
                
            case let .success(response):
                if response.status == true{

                    self.delegate?.showAlerts(title:"Success", message: response.message ?? "")

                }else{
                    self.delegate?.showAlerts(title:"Failure", message: response.message ?? "")
                }
            case  .failure(_):
                self.delegate?.showAlerts(title:"Failure", message: "something wrong try again")
                
        }
        }
    }
    
    
}
