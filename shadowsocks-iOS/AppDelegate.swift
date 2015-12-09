//
//  AppDelegate.swift
//  shadowsocks-iOS
//
//  Created by taichi on 15/12/8.
//  Copyright © 2015 taichi. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?

    var player: AVAudioPlayer?
    func notifyNSDefaultDidChanged(notification: NSNotification) {
        PacServer.sharedInstance.proxyAllConnection = NSUserDefaults.standardUserDefaults().boolForKey("enabled_proxy_all")
        let background = NSUserDefaults.standardUserDefaults().boolForKey("enabled_background_mode")
        if background {
            player?.stop()
            player = nil
            play()
        } else {
            player?.stop()
            player = nil
        }
    }
    
    func play() {
        let background = NSUserDefaults.standardUserDefaults().boolForKey("enabled_background_mode")
        guard background && player == nil else { return }
        let url = NSBundle.mainBundle().URLForResource("song", withExtension: "mp3")
        do {
            player = try AVAudioPlayer(contentsOfURL: url!)
            player?.delegate = self
            player?.play()
        } catch {
            print("error")
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
        play()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)
        } catch {
            
        }
        NSUserDefaults.standardUserDefaults().registerDefaults(["enabled_background_mode": true, "enabled_proxy_all": false])

        play()
        SettingsModel.sharedInstance.startShadowsocks()
        SettingsModel.sharedInstance.startPacServer()
        PacServer.sharedInstance.proxyAllConnection = NSUserDefaults.standardUserDefaults().boolForKey("enabled_proxy_all")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyNSDefaultDidChanged:", name: NSUserDefaultsDidChangeNotification, object: nil)

        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

