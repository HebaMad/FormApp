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
    var jobID=0
    var divisionID=0
    
    var ItemID:[String]=[]
    var Itemstatus:[String]=[]
    var ItemNotes:[String]=[]
    var selectedIndex = -1
    
    var itemNote:[Int:String] = [:]
    var itemStatus:[Int:String] = [:]
    
    var formData:[String : Any] = [:]
    
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
    
    @objc func AddFormData( _ sender:UIButton){
        print(sender.tag)
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell:FormTypeNoteCell = formTypeNoteTableview.cellForRow(at: indexPath as IndexPath) as! FormTypeNoteCell
        if cell.formTitleNote.text != "" || cell.formTypeStatus.text != ""{
        ItemID.append("\(formsItem[indexPath.row].id ?? 0)")
        ItemNotes.append(cell.formTitleNote.text ?? "")
        Itemstatus.append(cell.formTypeStatus.text ?? "")
        itemStatus[sender.tag] = cell.formTypeStatus.text ?? ""
        itemNote[sender.tag] = cell.formTitleNote.text ?? ""
        
       
            cell.addBtn.isEnabled = false
            cell.addBtn.alpha = 0.5
            cell.addBtn.setTitle("Added", for: .normal)
        }
     
        
    }
}

extension QCFormVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
            
        case submitBtn:
            do{
                
                let divisionleader = try diviosnLeaderData.validatedText(validationType: .requiredField(field: " Select Division leader please"))
                let formType = try formTypeData.validatedText(validationType: .requiredField(field: "Select form type please"))
                let job = try jobData.validatedText(validationType: .requiredField(field: "Select job please"))
                let companies = try companiesData.validatedText(validationType: .requiredField(field: "Select company please"))
           
                Alert.showAlert(viewController: self, title: "Do you  want to send the form", message: "") { Value in
                    if Value == true{
                        self.ItemNotes.count != 0 ? self.submitForm(formsDetails: self.FormDetailsParameter(itemNotes: self.ItemNotes, itemIDs: self.ItemID, itemStatus: self.Itemstatus)) : Alert.showErrorAlert(message:  "Add your form Item Data" )
                    }
                    
                   
                    
                }
              
                
            }catch{
                Alert.showErrorAlert(message: (error as! ValidationError).message)
                
            }
            
            
            
            
            
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
        
        
        if itemStatus.keys.contains(indexPath.row){
            cell.formTitleNote.text = itemNote[indexPath.row]
            cell.formTypeStatus.text = itemStatus[indexPath.row]
            cell.addBtn.setTitle("Added", for: .normal)
            cell.addBtn.isEnabled = false

            cell.addBtn.alpha = 0.5
        }else{
            cell.formTitleNote.text = ""
            cell.formTypeStatus.text = ""
            cell.addBtn.setTitle("Add", for: .normal)
            cell.addBtn.isEnabled = true

            cell.addBtn.alpha = 1
        }
        
        
        
        cell.addBtn.tag=indexPath.row
        cell.addBtn.addTarget(self, action: #selector(AddFormData), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
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
            jobID = jobs[row].id ?? 0
            
        case diviosnLeaderData :
            diviosnLeaderData.setTextFieldTitle(title: division[row].title ?? "")
            divisionID = division[row].id ?? 0
            
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
        Alert.showSuccessAlert(message: message)
        formsItem=[]
        formTypeNoteTableview.reloadData()
        companiesData.text=""
        jobData.text=""
        diviosnLeaderData.text=""
        formTypeData.text=""


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

extension QCFormVC{
    func submitForm(formsDetails:[String:Any]){
        presenter.submitFormData(formsDetails: formsDetails)
    }
    
    func FormDetailsParameter(itemNotes:[String],itemIDs:[String],itemStatus:[String]) -> [String:Any]{
        
        
        formData["company_id"] = "\(companyID)"
        formData["job_id"] = "\(jobID)"
        formData["division_id"] = "\(divisionID)"
        formData["form_type_id"] = "\(formTypeID)"
        
        
        for index in 0 ..< itemNotes.count{
            formData["form_items[\(index)][item_id]"] = itemIDs[index]
            formData["form_items[\(index)][pass]"] = itemStatus[index]
            formData["form_items[\(index)][notes]"] = itemNotes[index]
            
        }
        
        
        return formData
    }
    
}
