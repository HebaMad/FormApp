//
//  QCFormVC.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit

class QCFormVC: UIViewController {
    //MARK: - Outlet

    @IBOutlet weak var formTypeNoteTableview: UITableView!
    
    @IBOutlet weak var diviosnLeaderData: UITextFieldDataPicker!
    @IBOutlet weak var formTypeData: UITextFieldDataPicker!
    @IBOutlet weak var jobData: UITextFieldDataPicker!
    @IBOutlet weak var companiesData: UITextFieldDataPicker!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    //MARK: - Properties
    let presenter = AppPresenter()
    var companies:[DataDetails]=[]
    var jobs:[DataDetails]=[]
    var division:[DataDetails]=[]
    var forms:[DataDetails]=[]
    var formsItem:[DataDetails]=[]

    var companyID=0
    var formTypeID=0

    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
        jobData.isEnabled=false
        presenter.getCompanies()
        presenter.getDivision()
        presenter.getForms()
        presenter.delegate=self
        setupTableview()
    }

    func setupTableview(){
        formTypeNoteTableview.register(FormTypeNoteCell.self)
        formTypeNoteTableview.delegate=self
        formTypeNoteTableview.dataSource = self
    }

}
extension QCFormVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        submitBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
}

extension QCFormVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
  
        case submitBtn:
            print("")
        case backBtn :
            navigationController?.popViewController(animated: true)

        default:
            print("")
        }
        
    }
}
extension QCFormVC:Storyboarded{
    static var storyboardName: StoryboardName = .main

}
extension QCFormVC:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formsItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FormTypeNoteCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(obj: formsItem[indexPath.row])
        return cell
    }
    
}
extension QCFormVC:UITextFieldDataPickerDelegate,UITextFieldDataPickerDataSource{
 
 
 func textFieldDataPicker(_ textField: UITextFieldDataPicker, numberOfRowsInComponent component: Int) -> Int {
     switch textField{
     case companiesData:return companies.count
     case jobData :return jobs.count
     case diviosnLeaderData :return division.count
     case formTypeData:return forms.count
         
     default:
         return 0
     }
     
 }
 
 func textFieldDataPicker(_ textField: UITextFieldDataPicker, titleForRow row: Int, forComponent component: Int) -> String? {

     switch textField{
     case companiesData:return companies[row].title ?? ""
     case jobData :return jobs[row].title ?? ""
     case diviosnLeaderData :return division[row].title ?? ""
     case formTypeData:return forms[row].title ?? ""
         
     default:
         return ""
     }
 }
 
 func numberOfComponents(in textField: UITextFieldDataPicker) -> Int {
     1
 }
 
 func textFieldDataPicker(_ textField: UITextFieldDataPicker, didSelectRow row: Int, inComponent component: Int) {
     switch textField{
     case companiesData:
         companiesData.setTextFieldTitle(title: companies[row].title ?? "")
         companyID = companies[row].id ?? 0
         jobData.isEnabled=true
         presenter.getJobs(companyID: "\(companyID)")
         presenter.delegate=self
         jobData.dataSource=self
         
     case jobData :
         jobData.setTextFieldTitle(title: jobs[row].title ?? "")

     case diviosnLeaderData :
         diviosnLeaderData.setTextFieldTitle(title: division[row].title ?? "")

     case formTypeData:
         
         formTypeData.setTextFieldTitle(title: forms[row].title ?? "")
         formTypeID = forms[row].id ?? 0
         presenter.getFormItem(formTypeID:"\(formTypeID)" )
         presenter.delegate=self

     default:
         print("")
     }
 }
 
 
}

extension QCFormVC:FormDelegate{
    func showAlerts(title: String, message: String) {
        
    }
    
    func getUserData(user: User) {}
    
    func getCompanyData(data: CompaniesData) {
        companies=data.companies
        companiesData.pickerDelegate=self
        companiesData.dataSource=self
    }
    
    func getJobData(data: JobData) {
        jobs=data.jobs
        jobData.pickerDelegate=self


    }
    
    func getFormsData(data: FormsData) {
        forms=data.forms
        formTypeData.pickerDelegate=self
        formTypeData.dataSource=self

    }
    
    func getDivition(data: DiviosnData) {
        division=data.divisions
        diviosnLeaderData.pickerDelegate=self
        diviosnLeaderData.dataSource=self

    }
    
    func getFormItemsData(data: FormItemData) {
        formsItem=data.form_items
        formTypeNoteTableview.reloadData()
        
    }
    
    
}
