//
//  HkAssignmentsTableViewController.swift
//  HACk
//
//  Created by Brayden Cloud on 12/5/16.
//  Copyright © 2016 Brayden Cloud. All rights reserved.
//

import UIKit

class HkAssignmentsTableViewController: UITableViewController {

    var course: Class! {
        didSet {
            for assign in course.assignments! {
                if assign.category == "Formative Assessment" {
                    formative.append(assign)
                }
                else {
                    summative.append(assign)
                }
            }
        }
    }
    var formative = [Assignment]()
    var summative = [Assignment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2    // one for formative and one for summative
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // first will show the summative grades, then the formative grades.
        return section == 0 ? summative.count : formative.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Summative" : "Formative"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! HkAssignmentTableViewCell

        // Configure the cell...
        if indexPath.section == 0 { // summative
            let assignment = summative[indexPath.row]
            
            cell.nameLabel.text = assignment.name!
            cell.dueLabel.text = "due: \(assignment.dueDate != nil ? assignment.dueDate! : "nan")"
            cell.assignedLabel.text = "assigned: \(assignment.assignedDate != nil ? assignment.dueDate! : "nan")"
            cell.gradeLabel.text = "\(assignment.grade != nil ? "\(assignment.grade!)" : "nan")"
        }
        else {
            let assignment = formative[indexPath.row]
            
            cell.nameLabel.text = assignment.name!
            cell.dueLabel.text = "due: \(assignment.dueDate != nil ? assignment.dueDate! : "nan")"
            cell.assignedLabel.text = "assigned: \(assignment.assignedDate != nil ? assignment.dueDate! : "nan")"
            cell.gradeLabel.text = "\(assignment.grade != nil ? "\(assignment.grade!)" : "nan")"
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
