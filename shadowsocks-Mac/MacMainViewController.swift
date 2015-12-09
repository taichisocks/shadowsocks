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
        SettingsModel.sharedInstance.startShadowsocks()
        SettingsModel.sharedInstance.startPacServer()
    }
    
    @IBAction func relaunchClick(sender: NSButton) {
        NSApplication.sharedApplication().relaunch(sender)
    }
    
    
}
