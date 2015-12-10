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


    @IBOutlet weak var menu: NSMenu!
    
    @IBAction func QuitClick(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) // NSVariableStatusItemLength
        statusItem.toolTip = "shadowsocks"
        statusItem.image = NSImage(named: "menu_icon")
        statusItem.menu = menu
        
        SettingsModel.sharedInstance.startShadowsocks()
        SettingsModel.sharedInstance.startPacServer()
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