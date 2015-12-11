//
//  SettingsModel.swift
//  shadowsocks
//
//  Created by taichi on 15/4/20.
//  Copyright (c) 2015 taichi. All rights reserved.
//

import Foundation
import ShadowsocksKit

class SettingsModel {
    
    var remoteHost: String? {
        get { return NSUserDefaults.standardUserDefaults().stringForKey(KeyNames.remoteHost) }
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KeyNames.remoteHost) }
    }

    var remotePort: Int {
        get {
            let port = NSUserDefaults.standardUserDefaults().integerForKey(KeyNames.remotePort)
            return port == 0 ? 443 : port
        }
        set { NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: KeyNames.remotePort) }
    }
    
    var method: String? {
        get { return NSUserDefaults.standardUserDefaults().stringForKey(KeyNames.method) }
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KeyNames.method) }
    }
    
    var password: String? {
        get { return NSUserDefaults.standardUserDefaults().stringForKey(KeyNames.password) }
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KeyNames.password) }
    }
    
    var localHost: String {
        get { return NSUserDefaults.standardUserDefaults().stringForKey(KeyNames.localHost) ?? "127.0.0.1" }
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KeyNames.localHost) }
    }
    
    var localPort: Int {
        get {
            let port = NSUserDefaults.standardUserDefaults().integerForKey(KeyNames.localPort)
            return port == 0 ? 8986 : port
        }
        set { NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: KeyNames.localPort) }
    }
    
//    var pacPort: Int {
//        get { return NSUserDefaults.standardUserDefaults().integerForKey(KeyNames.pacPort) ?? 8903 }
//        set { NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: KeyNames.pacPort) }
//    }
    
    static let sharedInstance = SettingsModel()
    
    private struct KeyNames {
        static let remoteHost = "shadowsocks.remoteHost"
        static let remotePort = "shadowsocks.remotePort"
        static let method     = "shadowsocks.method"
        static let password   = "shadowsocks.password"
        static let localHost  = "shadowsocks.localHost"
        static let localPort  = "shadowsocks.localPort"
        static let pacPort    = "shadowsocks.pacPort"
    }
    
    func startShadowsocks() {
        guard remoteHost != nil && method != nil && password != nil else { return }
        ShadowsocksKit.startWithConfig(remoteHost!, remotePort: remotePort, method: method!, password: password!, localHost: localHost, localPort: localPort)
    }
    
    func startPacServer() {
        if localHost != "127.0.0.1" {
            PacServer.sharedInstance.allowOtherDevice = true
        }
        do {
            try PacServer.sharedInstance.start(8903, socks5Port: UInt16(localPort))
        } catch {
            
        }
    }
    
}