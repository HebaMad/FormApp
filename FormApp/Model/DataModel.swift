//
//  DataModel.swift
//  FormApp
//
//  Created by heba isaa on 18/02/2023.
//

import Foundation

struct User:Decodable{
    let fname:String?
    let lname:String?
    let email:String?
    let status:String?
    let api_token:String?
    let id:Int?

}
struct Empty:Decodable{}

struct CompaniesData:Decodable{
  
    let companies:[DataDetails]
    
}
struct JobData:Decodable{
    let jobs:[DataDetails]

}
struct FormsData:Decodable{
    let forms:[DataDetails]

}

struct DiviosnData:Decodable{
    let divisions:[DataDetails]

}
struct FormItemData:Decodable{
    let form_items:[DataDetails]

}
struct DataDetails:Codable{
    
    let id:Int?
    let title:String?
    let email:String?
    let company_id:String?
    let created_at:String?

}
