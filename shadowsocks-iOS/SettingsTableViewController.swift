//
//  SettingsTableViewController.swift
//  shadowsocks-iOS
//
//  Created by taichi on 15/12/9.
//  Copyright © 2015 taichi. All rights reserved.
//

import UIKit
import ShadowsocksKit

class SettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var remoteHostTextField: UITextField!
    
    @IBOutlet weak var remotePortTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var methodTextField: UITextField!
    
    
    @IBOutlet weak var localHostTextField: UITextField!
    
    @IBOutlet weak var localPortTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remoteHostTextField.text = SettingsModel.sharedInstance.remoteHost
        remotePortTextField.text = "\(SettingsModel.sharedInstance.remotePort)"
        passwordTextField.text = SettingsModel.sharedInstance.password
        methodTextField.text = SettingsModel.sharedInstance.method
        localHostTextField.text = SettingsModel.sharedInstance.localHost
        localPortTextField.text = "\(SettingsModel.sharedInstance.localPort)"
        
        methodTextField.inputView = picker
        picker.dataSource = self
        picker.delegate = self
        
        localHostTextField.inputView = localHostPicker
        localHostPicker.dataSource = self
        localHostPicker.delegate = self
    }
    
    var picker = UIPickerView()
    var localHostPicker = UIPickerView()
    
    let localHostTypes = ["127.0.0.1", "0.0.0.0"]

    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == picker {
            return ShadowsocksKit.method.count
        } else {
            return localHostTypes.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == picker {
            return ShadowsocksKit.method[row]
        } else {
            return localHostTypes[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker {
            methodTextField.text = ShadowsocksKit.method[row]
        } else {
            localHostTextField.text = localHostTypes[row]
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        remoteHostTextField.resignFirstResponder()
        remoteHostTextField.resignFirstResponder()
        remotePortTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        methodTextField.resignFirstResponder()
        localHostTextField.resignFirstResponder()
        localPortTextField.resignFirstResponder()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 2
    }

}
