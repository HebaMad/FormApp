//
//  AppTarget.swift
//  FormApp
//
//  Created by heba isaa on 18/02/2023.
//

import Foundation
import Moya

enum AppTarget:TargetType{
    
    case SignUp(fname:String,lname:String,email:String,password:String)
    case login(email:String,password:String)
    case getCompanies
    case getJob(companyId:String)
    case forms
    case divisions
    case getFormItems(form_type_id:String)
    case logout
    
    
    
    var baseURL: URL {
        return URL(string: "\(AppConfig.apiBaseUrl)")!
    }
  
    var path: String {
        switch self {
        case .SignUp:return "signUp"
        case .login:return "login"
        case .getCompanies:return "companies"
        case .getJob:return "jobs"
        case .forms:return "forms"
        case .divisions:return "divisions"
        case .getFormItems:return "formItems"
        case .logout:return ""
        }
    }
    var method: Moya.Method {
        switch self{
        case .SignUp,.login,.logout:
            return .post
        case .getCompanies,.getJob,.forms,.divisions,.getFormItems:
            return .get
       
        }
    }
    
    var task: Task{
        switch self{
        case .getCompanies,.forms,.divisions:
            return .requestPlain
        case .SignUp,.login,.logout:
            return .requestParameters(parameters: param, encoding: URLEncoding.httpBody)
        case .getJob,.getFormItems:
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)

        }
    }
    
    
    var headers: [String : String]?{
        switch self{
        case .getCompanies,.getJob,.forms,.divisions,.getFormItems,.logout:
            
            do {
                let token = try KeychainWrapper.get(key: AppData.email) ?? ""
                return ["Authorization":token ,"Accept":"application/json","Accept-Language":"en"]
            }
            catch{
                return ["Accept":"application/json","Accept-Language":"en"]
            }
            
        case .SignUp,.login:
            return ["Accept":"application/json","Accept-Language":"en"]

  
        }
    }
    
    var param: [String : Any]{
        
        
        switch self {
        case .SignUp(let fname,let lname,let email,let password):
            return ["fname":fname,"lname":lname,"email":email,"password":password]
        case .login(let email,let password):
            return ["email":email,"password":password]
        case .getJob(let companyId):
            return ["company_id":companyId]
        case .getFormItems(let form_type_id):
            return ["form_type_id":form_type_id]
        default:
            return [ : ]
            
        }
        
        
    }
}
