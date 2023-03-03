//
//  FormTypeNoteCell.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit

class FormTypeNoteCell: UITableViewCell,NibLoadableView {
    
    @IBOutlet weak var FormTypeSubtitle: UILabel!
    
    @IBOutlet weak var formTypeStatus: UITextFieldDataPicker!
    @IBOutlet weak var formTitleNote: UITextField!
    
    var status:[String] = ["pass","fail"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formTypeStatus.pickerDelegate=self
        formTypeStatus.dataSource=self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
           // invoke superclass implementation
           super.prepareForReuse()
           
    

       }
    
    func  configureCell(obj:DataDetails){
        FormTypeSubtitle.text = obj.title
    }
    //MARK: - confirm to DatePickerDelegate
}
    extension FormTypeNoteCell:UITextFieldDataPickerDelegate,UITextFieldDataPickerDataSource{
        
        
        func textFieldDataPicker(_ textField: UITextFieldDataPicker, numberOfRowsInComponent component: Int) -> Int {
            status.count
        }
        
        func textFieldDataPicker(_ textField: UITextFieldDataPicker, titleForRow row: Int, forComponent component: Int) -> String? {
            return status[row]
        }
        
        func numberOfComponents(in textField: UITextFieldDataPicker) -> Int {
            1
        }
        
        func textFieldDataPicker(_ textField: UITextFieldDataPicker, didSelectRow row: Int, inComponent component: Int) {
            
            formTypeStatus.setTextFieldTitle(title: status[row])
           
        }
        
    }
    

