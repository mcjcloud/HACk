//
//  HkLoginViewController.swift
//  HACk
//
//  Created by Brayden Cloud on 12/2/16.
//  Copyright © 2016 Brayden Cloud. All rights reserved.
//

import UIKit

class HkLoginViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var studentIdField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!

    @IBOutlet var webView: UIWebView!
    
    // constants
    let loginURL = "https://homeaccess.kellerisd.net/HomeAccess/Account/LogOn?ReturnUrl=%2fHomeAccess%2fClasses%2fClasswork"
    let classworkURL = "https://homeaccess.kellerisd.net/HomeAccess/Classes/Classwork"
    let iframeURL = "https://homeaccess.kellerisd.net/HomeAccess/Content/Student/Assignments.aspx"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // preset GUI
        loginButton.isEnabled = false                                                       // the login button starts disabled until the login page is loaded.
        studentIdField.text = ""                                                            // empty the text in the fields
        passwordField.text = ""
        
        // add target for typing occuring
        studentIdField.addTarget(self, action: #selector(textUpdated), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textUpdated), for: .editingChanged)
        
        // Assign delegates
        webView.delegate = self
        
        studentIdField.delegate = self
        passwordField.delegate = self
        
        print("requesting login page")
        // clear all tokens/cache load the login screen
        URLCache.shared.removeAllCachedResponses()
        let _ = HTTPCookieStorage.removeCookies(HTTPCookieStorage.shared)
        
        let request = URLRequest(url: URL(string: loginURL)!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // check if login should be enabled
        loginButton.isEnabled = shouldEnableLogin()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // check if login should be enabled
        loginButton.isEnabled = shouldEnableLogin()
    }
    
    // MARK: WebViewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("web view loaded: \(webView.request?.url?.absoluteString)")
        // check if login button should be enabled
        loginButton.isEnabled = shouldEnableLogin()
        
        // check if we're on the classes page.
        if webView.request?.url?.absoluteString == classworkURL {
            // save credentials and segue to classesTableVC
            AppDelegate.username = studentIdField.text
            AppDelegate.password = passwordField.text
        
            // if not logged in to next VC, do so.
            if !AppDelegate.loggedIn {
                print("not logged in")
                AppDelegate.loggedIn = true
                self.performSegue(withIdentifier: "loginToClasses", sender: self)
            }
            // we are logged in
            else {
                // set all flags to false, since we're in the right url and the page isn't timed out.
                print()
                print("set flag false")
                print()
                AppDelegate.classworkFlag = false
                
                // load the iframe if we're on the classwordk.
                webView.loadRequest(URLRequest(url: URL(string: iframeURL)!))
            }
        }
        // else if we're on the login page
        else if webView.request?.url?.absoluteString == loginURL {
            // check if we should be logged in, and log in
            if AppDelegate.loggedIn {
                // inject credentials and load page.
                webView.stringByEvaluatingJavaScript(from: HkHACInterface.Commands.injectUsername(AppDelegate.username!))
                webView.stringByEvaluatingJavaScript(from: HkHACInterface.Commands.injectPassword(AppDelegate.password!))
                webView.stringByEvaluatingJavaScript(from: "$(\"button\").click()") // click log in button with jQuery
            }
        }
        // if we're on the iframe page
        else if webView.request?.url?.absoluteString == iframeURL {
            print("setting iframeFlag false")
            AppDelegate.iframeFlag = false
        }
        else {  // if we're on a random, unwanted url
            print()
            print("reloading login from arbitrary url")
            webView.loadRequest(URLRequest(url: URL(string: loginURL)!))
        }
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        // load failed
        print("error loading url with error: \(error)")
    }
    
    // login button pressed.
    @IBAction func login(_ sender: UIButton) {
        
        // inject credentials and load page.
        webView.stringByEvaluatingJavaScript(from: HkHACInterface.Commands.injectUsername(studentIdField.text!))
        webView.stringByEvaluatingJavaScript(from: HkHACInterface.Commands.injectPassword(passwordField.text!))
        webView.stringByEvaluatingJavaScript(from: "$(\"button\").click()") // click log in button with jQuery
        print("logging in")
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // prepate for transition to HkClassesTableVC
        let destination = segue.destination.childViewControllers[0] as! HkClassesTableViewController
        
        // pass data to new VC
        destination.webView = self.webView
    }
    
    // MARK: Helper Functions
    func shouldEnableLogin() -> Bool {
        return (webView.request?.url?.absoluteString == loginURL && studentIdField.text! != "" && passwordField.text! != "")
    }
    func textUpdated() {
        loginButton.isEnabled = shouldEnableLogin()
    }
}

