//
//  Assignment.swift
//  HACk
//
//  Created by Brayden Cloud on 12/5/16.
//  Copyright © 2016 Brayden Cloud. All rights reserved.
//

import Foundation

class Assignment {
    
    // Data
    var name: String?                                       // the name of the assignment
    var category: String                                    // the category (form or summ)
    var assignedDate: String?                               // date assigned
    var dueDate: String?                                    // date due
    var grade: Double?                                      // grade received
    
    init(name: String?, category: String, assignedDate: String?, dueDate: String?, grade: Double?) {
        self.name = name
        self.category = category
        self.assignedDate = assignedDate
        self.dueDate = dueDate
        self.grade = grade
    }
}
