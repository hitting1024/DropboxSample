//
//  ViewController.swift
//  DropboxSample
//
//  Created by hitting on 2017/04/29.
//  Copyright © 2017年 hitting. All rights reserved.
//

import UIKit

import SwiftyDropbox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {

    @IBAction func login(_ sender: UIBarButtonItem) {
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: { url in
            UIApplication.shared.openURL(url)
        }, browserAuth: false)
    }
    
}
