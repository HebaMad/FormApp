//
//  QCFormVC.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit
import SVProgressHUD

class QCFormVC: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet weak var formTypeNoteTableview: UITableView!
    
    @IBOutlet weak var jobView: UIViewDesignable!

    @IBOutlet weak var companyBtn: UIButton!
    
    @IBOutlet weak var formTypeBtn: UIButton!
    @IBOutlet weak var divisionBtn: UIButton!
    @IBOutlet weak var jobBtn: UIButton!
    
    @IBOutlet weak var diviosnLeaderData: UITextField!
    @IBOutlet weak var formTypeData: UITextField!
    @IBOutlet weak var jobData: UITextField!
    @IBOutlet weak var companiesData: UITextField!
    
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
    var requestSubmitted:Bool = false
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
        BtnStatus()
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.show(withStatus: "please wait")
        presenter.getCompanies()
        presenter.delegate=self
        
        presenter.getDivision()
        presenter.delegate=self
        
        presenter.getForms()
        presenter.delegate=self
        
        setupTableview()
    }
    
    func BtnStatus(){
        formTypeBtn.isEnabled=false
        companyBtn.isEnabled=false
        jobBtn.isEnabled=false
        divisionBtn.isEnabled=false
        
        jobView.backgroundColor = .systemGray5
        
        diviosnLeaderData.isEnabled=false
        jobData.isEnabled=false
        companiesData.isEnabled=false
        formTypeData.isEnabled=false
        
    }
    
    func setupTableview(){
        formTypeNoteTableview.register(FormTypeNoteCell.self)
        formTypeNoteTableview.delegate=self
        formTypeNoteTableview.dataSource = self
        
        //        diviosnLeaderData.pickerDelegate=self
        //        diviosnLeaderData.dataSource=self
        //
        //        formTypeData.pickerDelegate=self
        //        formTypeData.dataSource=self
        //
        //        diviosnLeaderData.pickerDelegate=self
        //        diviosnLeaderData.dataSource=self
        //
        //        jobData.pickerDelegate=self
        //        jobData.dataSource=self
        
    }
    
    
    @IBAction func companyAction(_ sender: Any) {
        let vc = PickerVC.instantiate()
        vc.arr_data = companies
        vc.searchBarHiddenStatus = true
        
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.companiesData.text = name
            self.companyID = index
            
            //            self.jobBtn.isEnabled=true
            self.jobView.backgroundColor = .black
            
            self.jobs = []
            self.jobData.text=""
            self.presenter.getJobs(companyID: "\(self.companyID)", search: "")
            self.presenter.delegate=self
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func jobAction(_ sender: Any) {
        let vc = PickerVC.instantiate()
        vc.arr_data = jobs
        vc.companyId = self.companyID
        vc.searchBarHiddenStatus = false
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.jobData.text = name
            self.jobID = index
            
            
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func divisionLeaderAction(_ sender: Any) {
        let vc = PickerVC.instantiate()
        vc.arr_data = division
        vc.searchBarHiddenStatus = true
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.diviosnLeaderData.text = name
            self.divisionID = index
            
            
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func FormTypeAction(_ sender: Any) {
        let vc = PickerVC.instantiate()
        vc.arr_data = forms
        vc.searchBarHiddenStatus = true
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.formTypeData.text = name
            self.formTypeID = index
            self.presenter.getFormItem(formTypeID:"\(self.formTypeID)" )
            self.presenter.delegate=self
            
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
}
extension QCFormVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        submitBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
    
    @objc func AddFormData( _ sender:UITextField){
            
            
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
            let cell:FormTypeNoteCell = formTypeNoteTableview.cellForRow(at: indexPath as IndexPath) as! FormTypeNoteCell
            if cell.formTitleNote.text != "" {
                
//                if itemNote.keys.contains(sender.tag) {
//                    itemNote[sender.tag] = cell.formTitleNote.text ?? ""
//                    let indx = itemNote.keys.firstIndex(of:sender.tag)
//
//                    ItemNotes.remove(at: indx)
//                    ItemNotes.insert(cell.formTitleNote.text ?? "", at: indx)
//
//
//                }else{
                    ItemID.append("\(formsItem[indexPath.row].id ?? 0)")
                    ItemNotes.append(cell.formTitleNote.text ?? "")
                    Itemstatus.append(cell.formTypeStatus.text ?? "")
                    itemStatus[sender.tag] = cell.formTypeStatus.text ?? ""
                    itemNote[sender.tag] = cell.formTitleNote.text ?? ""
//                }
                
       
                
//                requestSubmitted=true
            
        }
        
    }
    
    @objc func checkStatusForm(_ sender:UITextFieldDataPicker){
////        if requestSubmitted == false{
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
            let cell:FormTypeNoteCell = formTypeNoteTableview.cellForRow(at: indexPath as IndexPath) as! FormTypeNoteCell


                ItemID.append("\(formsItem[indexPath.row].id ?? 0)")
                ItemNotes.append(cell.formTitleNote.text ?? "")
                Itemstatus.append(cell.formTypeStatus.text ?? "")
                itemStatus[sender.tag] = cell.formTypeStatus.text ?? ""
                itemNote[sender.tag] = cell.formTitleNote.text ?? ""

////                requestSubmitted=true
//
//
////        }
//
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
                        if self.ItemNotes.count != 0{
                            SVProgressHUD.setBackgroundColor(.white)
                            SVProgressHUD.show(withStatus: "please wait")
                            self.submitForm(formsDetails: self.FormDetailsParameter(itemNotes: self.ItemNotes, itemIDs: self.ItemID, itemStatus: self.Itemstatus))
                        }else{
                            Alert.showErrorAlert(message:  "Add your form Item Data" )
                        }
                         
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
//            cell.addBtn.setTitle("Added", for: .normal)
//            cell.addBtn.isEnabled = false
            
//            cell.addBtn.alpha = 0.5
        }else{
            cell.formTitleNote.text = ""
            cell.formTypeStatus.text = ""
//            cell.addBtn.setTitle("Add", for: .normal)
//            cell.addBtn.isEnabled = true
//
//            cell.addBtn.alpha = 1
        }
        
        cell.formTypeStatus.tag=indexPath.row
        cell.formTypeStatus.addTarget(self, action: #selector(checkStatusForm), for: .editingDidEnd)


        cell.formTitleNote.addTarget(self, action: #selector(AddFormData), for: .editingDidEnd)
        cell.formTitleNote.tag=indexPath.row

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    
}

extension QCFormVC:FormDelegate{
    func showAlerts(title: String, message: String) {
        Alert.showSuccessAlert(message: message)
        SVProgressHUD.dismiss()
        formsItem=[]
        formTypeNoteTableview.reloadData()
        companiesData.text=""
        jobData.text=""
        diviosnLeaderData.text=""
        formTypeData.text=""
        jobBtn.isEnabled=false
        jobView.backgroundColor = .systemGray5
        
        
        
    }
    
    func getUserData(user: User) {}
    
    func getCompanyData(data: CompaniesData) {
        companies=data.companies
        companyBtn.isEnabled=true
        SVProgressHUD.dismiss()
    }
    
    func getJobData(data: JobData) {
        jobs=data.jobs
        jobBtn.isEnabled=true
        
        
        
    }
    
    func getFormsData(data: FormsData) {
        forms=data.forms
        formTypeBtn.isEnabled=true
        
        
        
    }
    
    func getDivition(data: DiviosnData) {
        division=data.divisions
        divisionBtn.isEnabled=true
        
        
        
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


extension QCFormVC:UITextFieldDataPickerDelegate,UITextFieldDelegate{
    func textFieldDataPicker(_ textField: UITextFieldDataPicker, didSelectRow row: Int, inComponent component: Int) {
        let indexPath = NSIndexPath(row: row, section: 0)
        let cell:FormTypeNoteCell = formTypeNoteTableview.cellForRow(at: indexPath as IndexPath) as! FormTypeNoteCell


            ItemID.append("\(formsItem[indexPath.row].id ?? 0)")
            ItemNotes.append(cell.formTitleNote.text ?? "")
            Itemstatus.append(cell.formTypeStatus.text ?? "")
            itemStatus[row] = cell.formTypeStatus.text ?? ""
            itemNote[row] = cell.formTitleNote.text ?? ""

    }
    

    
    
}
