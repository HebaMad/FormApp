//
//  PickerVC.swift
//  Almnabr
//
//  Created by MacBook on 20/04/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class PickerVC: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var picker: UIPickerView!

    @IBOutlet weak var searchBar: SearchView!
    var arr_data:[String] = []
    var name:String = ""
    var index : Int = 0
    var delegate : ((_ name: String ,_ index:Int) -> Void)?
    //pickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGUI()
        setupSearchProperties()
    }
    
    func  setupSearchProperties(){
     searchBar.btnSearch.addTarget(self, action: #selector(searchActioon), for: .touchUpInside)

     searchBar.startHandler {
     }

     searchBar.endEditingHandler {

     }

     }
     
     @objc func searchActioon(_ sender : UIButton ) {
         print(arr_data.contains(searchBar.text ?? ""))
       
             arr_data=[]
             arr_data.append("testttt")
             picker.delegate=self
             picker.dataSource=self
      
 }
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        self.picker.delegate = self
        self.btnNext.setTitle("Done", for: .normal)
        self.btnCancel.setTitle("Cancel", for: .normal)
        
        
        if arr_data.count > 0 {
            self.name = arr_data[0]
            self.index = 0
        }else{
            self.arr_data.append("No items found")
        }
        
    }
    
    //MARK: - Button Action
    //------------------------------------------------------
    
    @IBAction func btnSubmit_Click(_ sender: UIButton) {
        if arr_data.contains("No items found") && arr_data.count == 1 {
            self.dismiss(animated: true, completion: nil)
        }else{
            delegate!(name, index)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancel_Click(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }

}
extension PickerVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr_data.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
        return arr_data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        let item = arr_data[row]
        attributedString = NSAttributedString(string: item, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        
        return attributedString
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()

            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = arr_data[row]
        

        return pickerLabel!
    }
    

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 35.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView.tag == 0 {

            print(arr_data[row])
            self.name = (arr_data[row])
            self.index = row
            
           
            
        }

   }
}

