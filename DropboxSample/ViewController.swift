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

    @IBOutlet weak var tableView: UITableView!

    fileprivate var list: Array<String> = Array<String>()
    
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
    
    @IBAction func load(_ sender: UIBarButtonItem) {
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropboxCell", for: indexPath)
        cell.textLabel?.text = self.list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
