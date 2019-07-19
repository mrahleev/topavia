//
//  ViewController.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 09/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager<[Currency]>().load(path: "Currency") { (result) in
            print("")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

