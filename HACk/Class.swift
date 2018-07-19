//
//  Class.swift
//  HACk
//
//  Created by Brayden Cloud on 12/5/16.
//  Copyright © 2016 Brayden Cloud. All rights reserved.
//

import Foundation

class Class {
    
    // Data
    var name: String                                        // the name of the class
    var average: Double?                                    // the grade in the class (stored as string)
    var formativeGrade: Double?                             // the average of formative assignments
    var summativeGrade: Double?                             // the average of summative assignments
    var assignments: [Assignment]?                          // a list of the assignments in that class
    
    init(name: String, average: Double?, formative: Double?, summative: Double?, assignments: [Assignment]?) {
        self.name = name
        self.average = average
        self.formativeGrade = formative
        self.summativeGrade = summative
        self.assignments = assignments
    }
}
