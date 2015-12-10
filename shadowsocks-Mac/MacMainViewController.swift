//
//  MacMainViewController.swift
//  shadowsocks-Mac
//
//  Created by taichi on 15/12/9.
//  Copyright © 2015 taichi. All rights reserved.
//

import Cocoa
import ShadowsocksKit

class MacMainViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteHostTextField.stringValue = SettingsModel.sharedInstance.remoteHost ?? ""
        remotePortTextField.stringValue = "\(SettingsModel.sharedInstance.remotePort)"
        passwordTextField.stringValue = SettingsModel.sharedInstance.password ?? ""
        localHostTextField.stringValue = SettingsModel.sharedInstance.localHost
        localPortTextField.stringValue = "\(SettingsModel.sharedInstance.localPort)"
        autoProxyTextField.stringValue = PacServer.sharedInstance.audoProxyAddress

        methodSelector.removeAllItems()
        methodSelector.addItemsWithTitles(ShadowsocksKit.method)
        for i in 0..<methodSelector.numberOfItems {
            if methodSelector.itemTitleAtIndex(i) == SettingsModel.sharedInstance.method {
                methodSelector.selectItemAtIndex(i)
                break
            }
        }
    }
    
    @IBAction func okClick(sender: NSButton) {
        SettingsModel.sharedInstance.remoteHost = remoteHostTextField.stringValue
        SettingsModel.sharedInstance.remotePort = remotePortTextField.integerValue
        SettingsModel.sharedInstance.password = passwordTextField.stringValue
        SettingsModel.sharedInstance.method = methodSelector.titleOfSelectedItem
        SettingsModel.sharedInstance.localPort = localPortTextField.integerValue
        SettingsModel.sharedInstance.localHost = localHostTextField.stringValue

        NSApplication.sharedApplication().relaunch(sender)
    }
    
    @IBOutlet weak var remoteHostTextField: NSTextField!
    
    @IBOutlet weak var remotePortTextField: NSTextField!
    
    @IBOutlet weak var methodSelector: NSPopUpButton!
    
    @IBOutlet weak var passwordTextField: NSTextField!
    
    @IBOutlet weak var localHostTextField: NSTextField!
    
    @IBOutlet weak var localPortTextField: NSTextField!
    
    @IBOutlet weak var autoProxyTextField: NSTextField!
    
    @IBAction func importConfig(sender: AnyObject) {
        alertMsg("Not implement")
    }
    
    @IBAction func export(sender: AnyObject) {
        alertMsg("Not implement")
    }
    
    func alertMsg(msg: String) {
        let alert = NSAlert()
        alert.messageText = msg
        alert.runModal()
    }
}
