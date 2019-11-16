//
//  ViewController.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 11/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit
import CoreData

class AddDetailsVC: UIViewController {
    @IBOutlet weak var txtName: TextFieldPadding!
    @IBOutlet weak var txtSurname: TextFieldPadding!
    @IBOutlet weak var txtDepartment: TextFieldPadding!
    @IBOutlet weak var txtSalary: TextFieldPadding!
    @IBOutlet weak var txtCity: TextFieldPadding!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSaveAndUpdate: UIButton!
    @IBOutlet weak var segmentDetail: UISegmentedControl!
    
    var strStatus : String = String()
    var strImgpath : String = String()
    
    lazy var arrayEmployee = [Employee]()
    lazy var arrayCategory = [Department]()
    lazy var arrayLocation = [Location]()
    lazy var arrayStatus = [Status]()

    var empObj : Employee!
    
    var activeField: UITextField?
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
         self.displayData()
        
        txtName.autocapitalizationType = .allCharacters
        txtSurname.autocapitalizationType = .allCharacters
        txtDepartment.autocapitalizationType = .allCharacters
        txtCity.autocapitalizationType = .allCharacters
    
        registerForKeyboardNotifications()
        
        btnSaveAndUpdate.cornerRadius(valueRadius: 8.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    //MARK:- Keyboard Methods
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    //MARK:- Button Actions
    @IBAction func btnSave(_ sender: AnyObject){
        if self.validationCheck() {
            if btnSaveAndUpdate.titleLabel?.text == "Save" {
                let empid = getAutoIncremenet()
               
                strImgpath = ""
                
               let dicLoca = ["city": txtCity.text! as NSString]
                
                let objnew =  CoreDataHelper.coreDataHelper.getEntityObjectForRelation(entityName: "Location", dicParameter: dicLoca as NSDictionary)
        
                let dicEmployeeDetails = ["empName": txtName.text!, "empSurname": txtSurname.text! , "empDepartment": txtDepartment.text!, "empSalary": txtSalary.text! as String,"empImage": strImgpath, "empStatus": strStatus, "empId": Int16(empid), "location": objnew] as [String : Any]
                CoreDataHelper.coreDataHelper.saveData(entityName: "Employee", dicParameter: dicEmployeeDetails as NSDictionary)
                _ = self.navigationController?.popViewController(animated: true)
            }
            else {
                if empObj != nil {
                    let empid =  empObj.value(forKey: "empId")
                    
                    let dicLoca = ["city": txtCity.text! as NSString]
                    
                    let objnew =  CoreDataHelper.coreDataHelper.getEntityObjectForRelation(entityName: "Location", dicParameter: dicLoca as NSDictionary)
                    
                    let dicEmployeeDetails = ["empName": txtName.text!, "empSurname": txtSurname.text! , "empDepartment": txtDepartment.text!, "empSalary": txtSalary.text! as String,"empImage": strImgpath, "empStatus": strStatus, "empId": empid ?? "","location": objnew] as [String : Any]
                    CoreDataHelper.coreDataHelper.updateData(entityName: "Employee", dicParameter: dicEmployeeDetails as NSDictionary, objforUpdate: empObj)
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func getAutoIncremenet() -> Int64 {
        if arrayEmployee.count > 0 {
            let nnew = self.arrayEmployee.last
            let obid = nnew?.objectID
            if nnew != nil {
                let url = obid?.uriRepresentation()
                let urlString = url?.absoluteString
                if let pN = urlString?.components(separatedBy: "/").last {
                    let numberPart = pN.replacingOccurrences(of: "p", with: "")
                    if let number = Int64(numberPart) {
                        return number
                    }
                }
            }
        }
        return 0
    }
    
     //MARK:- UISegmentedControl Actions
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch segmentDetail.selectedSegmentIndex {
        case 0:
            strStatus = "Active"
        case 1:
            strStatus = "InActive"
        default:
            break;
        }
    }
    
    //MARK:- ValidationCheck
    func validationCheck() -> Bool {
       return alltextfieldCheck(arrayTextfield: [txtName,txtSurname,txtSalary,txtDepartment,txtCity])
    }
    
    func alltextfieldCheck(arrayTextfield:[UITextField])-> Bool {
        for txtfield in arrayTextfield {
            if (txtfield.text?.isEmpty)! {
                print("ALERT\(txtfield.placeholder!)")
                return false
            }
        }
        if Int(txtSalary.text!)! == 0  {
            print("Salary Must be Grater than 0")
            return false
        }
        return true
    }
    
    //MARK:- DisplayData
    func displayData() {
        if empObj != nil {
            btnSaveAndUpdate.setTitle("Update", for: .normal)
            txtDepartment.text = (empObj.value(forKey: "empDepartment") as? String ?? "")
            txtName.text = (empObj.value(forKey: "empName") as? String  ?? "")
            txtSalary.text = (empObj.value(forKey: "empSalary") as? String  ?? "")
            txtSurname.text = (empObj.value(forKey: "empSurname") as? String  ?? "")
            
            let loca : Location = empObj.value(forKey: "location") as! Location
            
            txtCity.text = (loca.value(forKey: "city") as? String  ?? "")
            
           // txtCity.text = (empObj.value(forKey: "empEmployeeLocation") as? String  ?? "")
            
            if let strStatus = empObj.value(forKey: "empStatus") as? String {
                switch strStatus {
                case "Active":
                    segmentDetail.selectedSegmentIndex = 0
                case "InActive":
                    segmentDetail.selectedSegmentIndex = 1
                default:
                    break
                }
            }
        }
        else {
            btnSaveAndUpdate.setTitle("Save", for: .normal)
        }
    }
}
//MARK:- UITextFieldDelegate
extension AddDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        switch textField {
        case txtName:
            txtSurname.becomeFirstResponder()
        case txtSurname:
            txtDepartment.becomeFirstResponder()
        case txtDepartment:
            txtSalary.becomeFirstResponder()
        case txtSalary:
            txtCity.becomeFirstResponder()
        case txtCity:
            txtCity.resignFirstResponder()
        default:
            print("")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       activeField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string as NSString).rangeOfCharacter(from: .whitespaces).location != NSNotFound {
            return false
        }
        else {
            switch textField {
            case txtSalary:
                let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            default:
                let lowercaseCharRange: NSRange = (string as NSString).rangeOfCharacter(from: .lowercaseLetters)
                if lowercaseCharRange.location != NSNotFound {
                    textField.text = (textField.text! as NSString)
                        .replacingCharacters(in: range, with: string.uppercased())
                    return false
                }
                return true
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK:- UITextField Class
class TextFieldPadding: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
