//
//  EmpDetailCell.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 12/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit

class EmpDetailCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
