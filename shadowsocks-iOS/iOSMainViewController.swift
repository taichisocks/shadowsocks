//
//  iOSMainViewController.swift
//  shadowsocks-iOS
//
//  Created by taichi on 15/12/9.
//  Copyright © 2015 taichi. All rights reserved.
//

import UIKit
import AVFoundation

class iOSMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text =  "auto proxy address: \(PacServer.sharedInstance.audoProxyAddress)"
    }
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func copyAddress(sender: UIButton) {
        UIPasteboard.generalPasteboard().string = PacServer.sharedInstance.audoProxyAddress
    }
    
    @IBAction func segueFromSettingsDone(segue: UIStoryboardSegue) {
        if let svc = segue.sourceViewController as? SettingsTableViewController {
            SettingsModel.sharedInstance.remoteHost = svc.remoteHostTextField.text
            SettingsModel.sharedInstance.remotePort = Int(svc.remotePortTextField.text!) ?? 9999
            SettingsModel.sharedInstance.password = svc.passwordTextField.text
            SettingsModel.sharedInstance.method = svc.methodTextField.text
            SettingsModel.sharedInstance.localPort = Int(svc.localPortTextField.text!) ?? 1080
            SettingsModel.sharedInstance.localHost = svc.localHostTextField.text ?? svc.localHostTypes[0]
            
            PacServer.sharedInstance.socks5Port = UInt16(SettingsModel.sharedInstance.localPort)
            if SettingsModel.sharedInstance.localHost != svc.localHostTypes[0] {
                PacServer.sharedInstance.allowOtherDevice = true
            }
            SettingsModel.sharedInstance.startPacServer()
        }
    }
}
