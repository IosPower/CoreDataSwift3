//
//  EmployeeViewController.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 11/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit
import CoreData

class EmployeeVC: UIViewController {
    
    lazy var arrayEmployee = [Employee]()
    
    @IBOutlet weak var tblDetails: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
       getEmpData()
    }
    
    //MARK:- FetchData From CoreData
    func getEmpData() {
        // Here For Whole Array Data
        //  self.arrayEmployee = Employee.getDataFromEmployee() //uncomment this and check
        
        // Here like get Data where empDepartment = "IOS"
        //seemore Filter option in
        //http://www.learncoredata.com/filtering-data-with-nspredicate/
        
        //let dic = ["empDepartment": "IOS","empName": "PIYUSH"]
        let dic = [String:Any]()
        arrayEmployee = Employee.getFilteredDataFromEmployee(dicForFilter: dic as NSDictionary?)
        
        if arrayEmployee.count > 0 {
            print(arrayEmployee.last ?? "")
        }
        
        tblDetails.reloadData()
    }
    
    //MARK:- Button Action
    @IBAction func btnAddEmpAction(_ sender: Any) {
        let objAddDetails = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailsVC") as! AddDetailsVC
        objAddDetails.empObj = nil
        self.navigationController?.pushViewController(objAddDetails, animated: true)
    }
}

//MARK:- UITableViewDataSource
extension EmployeeVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayEmployee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmpDetailCell", for: indexPath) as! EmpDetailCell
        let dicDetails = self.arrayEmployee[indexPath.row]
        cell.lblName.text = "\(dicDetails.value(forKey: "empName") as! String)  \(dicDetails.value(forKey: "empSurname") as! String)"
        cell.imgView?.image = UIImage(named: "image1")
        cell.imgView.cornerRadius()
        cell.lblDepartment.text = (dicDetails.value(forKey: "empDepartment") as! String)
        return cell
    }
}

//MARK:- UITableViewDelegate
extension EmployeeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objAddDetails = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailsVC") as! AddDetailsVC
        objAddDetails.empObj = arrayEmployee[indexPath.row] as Employee
        self.navigationController?.pushViewController(objAddDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHelper.coreDataHelper.saveContext()
            let managedObjectContext = CoreDataHelper.coreDataHelper.persistentContainer.viewContext
            let deleteObj = arrayEmployee[indexPath.row]
            managedObjectContext.delete(deleteObj)
            CoreDataHelper.coreDataHelper.saveContext()
            getEmpData()
        }
    }
}
