//
//  AppDelegate.swift
//  shadowsocks-Mac
//
//  Created by taichi on 15/12/8.
//  Copyright © 2015 taichi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

extension NSApplication {
    func relaunch(sender: AnyObject?) {
        let task = NSTask()
        // helper tool path
        task.launchPath = NSBundle.mainBundle().pathForResource("relaunch", ofType: nil)!
        // self PID as a argument
        task.arguments = [String(NSProcessInfo.processInfo().processIdentifier)]
        task.launch()
    }
}