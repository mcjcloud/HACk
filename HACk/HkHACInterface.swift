//
//  HkHACInterface.swift
//  HACk
//
//  Created by Brayden Cloud on 12/5/16.
//  Copyright © 2016 Brayden Cloud. All rights reserved.
//

import Foundation
import UIKit
import Kanna

class HkHACInterface {
    
    // constants
    struct URLs {
        static let login = "https://homeaccess.kellerisd.net/HomeAccess/Account/LogOn?ReturnUrl=%2fHomeAccess%2fClasses%2fClasswork"
        static let classwork = "https://homeaccess.kellerisd.net/HomeAccess/Classes/Classwork"
        
        static let iframe = "https://homeaccess.kellerisd.net/HomeAccess/Content/Student/Assignments.aspx"
    }
    struct Commands {
        // index count
        static let classCount = "$(\".AssignmentClass\").count"
        static func assignmentCount(classIndex: Int) -> String {
            return "$(\".AssignmentClass:eq(\(classIndex))\").find(\"table:eq(0)\").find(\".sg-asp-table-data-row\").size()"
        }
        
        // username and password injection commands
        static func injectUsername(_ username: String) -> String {
            return "$(\"#LogOnDetails_UserName\").val(\"\(username)\")"
        }
        static func injectPassword(_ password: String) -> String {
            return "$(\"#LogOnDetails_Password\").val(\"\(password)\")"
        }
    }
    
    /*
     *  Data GET
     */
    
    static func classes(with webView: UIWebView) -> [Class] {
        
        print()
        print("GETTING CLASSES")
        print()
        
        var classes = [Class]()
        
        // function to perform the stringByEvaluatingJavaScript function in the main thread.
        func execute(script: String, completion: @escaping (_ result: String?) -> Void) {
            var result: String?
            print("evaluating in main thread")
            DispatchQueue.main.async {
                result = webView.stringByEvaluatingJavaScript(from: script)
            }
            
            // complete method
            while result?.characters.count ?? 0 < 1 { /* print("waiting for result") */ }
            completion(result)
        }
        
        // clear all tokens/cache load the login screen
        URLCache.shared.removeAllCachedResponses()
        let _ = HTTPCookieStorage.removeCookies(HTTPCookieStorage.shared)
        
        // reload the webView
        AppDelegate.classworkFlag = true
        webView.loadRequest(URLRequest(url: URL(string: URLs.login)!))
        while(AppDelegate.classworkFlag) { /* do nothing */ }
        print("flags all good, continuing")
        
        // load iframe
        AppDelegate.iframeFlag = true
        webView.loadRequest(URLRequest(url: URL(string: URLs.iframe)!))
        while(AppDelegate.iframeFlag) { /* do nothing */ }
        print("iframe loaded")
        
        // make a GET request to the classwork URL since we're verified to be on the write page
        execute(script: "document.documentElement.outerHTML") { result in
            // use Kanna to scrape HTML
            if let rawHTML = result {
                //print("HTML: \(rawHTML)")
                if let doc = Kanna.HTML(html: rawHTML, encoding: .utf8) {
                    for assignmentClass in doc.xpath("//div[@class='AssignmentClass']") {
                        let assignmentDoc = Kanna.HTML(html: assignmentClass.innerHTML!, encoding: .utf8)

                        // get class data
                        let rawName = assignmentDoc!.css("a").first?.innerHTML?.trimmingCharacters(in: .whitespacesAndNewlines)
                        print("rawName: \(rawName ?? "nil")")
                        let className = rawName?.components(separatedBy: "    ")[1]
                        //print("final: \(className)")
                        let rawAverage = assignmentDoc!.xpath("//span[@class='sg-header-heading sg-right']")[0].innerHTML
                        let average = Double(rawAverage?.components(separatedBy: " ")[2].replacingOccurrences(of: "%", with: "") ?? "") // parse the string and caste to Double?
                        
                        // get the assignments.
                        let asgnments = assignments(for: assignmentClass)
                        
                        // append to classes
                        classes.append(Class(name: className!, average: average, formative: asgnments.formative, summative: asgnments.summative, assignments: asgnments.assignments))
                    }
                }
            }
            else {
                print("error getting rawHTML")
            }
        }
        
        // return classes
        return classes
    }
    
    static func assignments(for assignmentClass: XMLElement) -> (assignments: [Assignment], formative: Double, summative: Double) {
        
        print("getting assignments")
        
        var formSum = 0.0
        var summSum = 0.0
        
        var formCount = 0
        var summCount = 0
        
        var assignments: [Assignment] = [Assignment]()
        let classDoc = Kanna.HTML(html: assignmentClass.innerHTML!, encoding: .utf8)
        let table = classDoc?.xpath("//table[@class='sg-asp-table']")
        let tableDoc = Kanna.HTML(html: table![0].innerHTML!, encoding: .utf8)
        for assignment in tableDoc!.xpath("//tr[@class='sg-asp-table-data-row']") {
            let assignmentDoc = Kanna.HTML(html: assignment.innerHTML!, encoding: .utf8)
            
            let tableData = assignmentDoc!.xpath("//td")    // get all the table data for that assignemnts
            
            let name = tableData[2].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let category = tableData[3].text!
            let grade = Double(tableData[4].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            let dueDate = tableData[0].text
            let assgnDate = tableData[1].text
            
            // due form/summ calculations
            switch(category) {
            case "Formative Assessment":
                formSum += grade ?? 0.0
                if let _ = grade { formCount += 1 }
            case "Summative Assessment":
                summSum += grade ?? 0.0
                if let _ = grade { summCount += 1 }
            default: break
            }
            
            assignments.append(Assignment(name: name, category: category, assignedDate: assgnDate, dueDate: dueDate, grade: grade))
        }
        
        let formative = formSum / Double(formCount)
        let summative = summSum / Double(summCount)
        
        // return the tuple
        return (assignments, formative, summative)
    }
}





