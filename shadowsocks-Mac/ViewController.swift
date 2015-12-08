//
//  ViewController.swift
//  shadowsocks-Mac
//
//  Created by taichi on 15/12/8.
//  Copyright © 2015 taichi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        start_proxy()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

