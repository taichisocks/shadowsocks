//
//  ShadowsocksKit.swift
//  shadowsocksKit
//
//  Created by taichi on 15/12/8.
//  Copyright © 2015 taichi. All rights reserved.
//

public let method = [
    "table",
    "rc4",
    "rc4-md5",
    "aes-128-cfb",
    "aes-192-cfb",
    "aes-256-cfb",
    "bf-cfb",
    "camellia-128-cfb",
    "camellia-192-cfb",
    "camellia-256-cfb",
    "cast5-cfb",
    "des-cfb",
    "idea-cfb",
    "rc2-cfb",
    "seed-cfb",
]

public let ShadowsocksServerStoppedNotification = "ShadowsocksServerStoppedNotification"

public func startWithConfig(remoteHost: String, remotePort: Int, method: String, password: String, localHost: String, localPort: Int, serverStopped : (() -> Void)? = nil) {
    
    let c_remote_host = remoteHost.cStringUsingEncoding(NSUTF8StringEncoding)!
    let c_remote_port = CInt(remotePort)
    let c_method = method.cStringUsingEncoding(NSUTF8StringEncoding)!
    let c_password = password.cStringUsingEncoding(NSUTF8StringEncoding)!
    let c_local_host = localHost.cStringUsingEncoding(NSUTF8StringEncoding)!
    let c_local_port = CInt(localPort)
    
    let queue = dispatch_queue_create("shadowsocks", nil)
    dispatch_async(queue) {
        startLocalServerWithConfig(c_remote_host, c_remote_port, c_method, c_password, c_local_host, c_local_port)
        dispatch_async(dispatch_get_main_queue()) {
            serverStopped?()
            NSNotificationCenter.defaultCenter().postNotificationName(ShadowsocksServerStoppedNotification, object: nil)
        }
    }
}
