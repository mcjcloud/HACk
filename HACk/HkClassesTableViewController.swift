//
//  HkClassesTableViewController.swift
//  HACk
//
//  Created by Brayden Cloud on 12/2/16.
//  Copyright © 2016 Brayden Cloud. All rights reserved.
//

import UIKit

class HkClassesTableViewController: UITableViewController {

    // instance passed with segue
    var webView: UIWebView!
    
    // Data
    var classes: [Class] = [Class]()
    var sourceClass: Class!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Classes"

        // refresh control
        self.refreshControl = UIRefreshControl()
        //self.tableView.tableHeaderView = self.refreshControl
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        // load classes
        self.handleRefresh(self.refreshControl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! HkClassTableViewCell

        // Configure the cell...
        let clss = classes[indexPath.row]
        let nameText = String(format: "\(clss.name) - \(clss.average != nil ? "%.2f" : "N/A")", clss.average ?? 0)
        let formText = String(format: "Formative Avg: \(clss.formativeGrade != nil ? "%.2f" : "N/A")", clss.formativeGrade ?? 0)
        let summText = String(format: "Summative Avg: \(clss.summativeGrade != nil ? "%.2f" : "N/A")", clss.summativeGrade ?? 0)
        
        cell.classNameLabel.text = nameText
        cell.formativeLabel.text = formText
        cell.summativeLabel.text = summText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sourceClass = classes[indexPath.row]
        
        self.performSegue(withIdentifier: "classesToClass", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destination = segue.destination as! HkAssignmentsTableViewController
        destination.navigationItem.title = sourceClass.name
        destination.course = sourceClass
    }
    
    // MARK: Refresh
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        
        let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
        concurrentQueue.async {
            // reload the table in the main thread
            self.classes = HkHACInterface.classes(with: self.webView)
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}
