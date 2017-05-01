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
    
    fileprivate func login() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: { url in
            UIApplication.shared.openURL(url)
        }, browserAuth: false)
    }
    
    fileprivate func loadData() {
        guard let client = DropboxClientsManager.authorizedClient else {
            self.login()
            return
        }
        
        client.files.listFolder(path: "").response(completionHandler: { response, error in
            guard let result = response else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            self.list.removeAll()
            for entry in result.entries {
                self.list.append(entry.name)
            }
            self.tableView.reloadData()
        })
    }
    
    fileprivate func download(filename: String) {
        guard let client = DropboxClientsManager.authorizedClient else {
            self.login()
            return
        }
        
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            let tempPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(filename)
            return URL(fileURLWithPath: tempPath)
        }
        
        client.files.download(path: "/\(filename)", destination: destination)
            .response(completionHandler: {(response, error) in
                guard let result = response else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                
                print(result)
            })
            .progress({ progressData in
                print(progressData)
            })
    }
    
    fileprivate class func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        return formatter.string(from: date)
    }

}

extension ViewController {
    
    @IBAction func load(_ sender: UIBarButtonItem) {
        self.loadData()
    }

    @IBAction func upload(_ sender: UIBarButtonItem) {
        guard let client = DropboxClientsManager.authorizedClient else {
            self.login()
            return
        }
        
        let filename = ViewController.string(from: Date()) + ".txt"
        let fileData = "test data: \(filename)".data(using: .utf8, allowLossyConversion: false)!
        _ = client.files.upload(path: "/\(filename)", input: fileData)
            .response(completionHandler: { response, error in
                guard let result = response else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                
                print(result)
                
                self.loadData()
            })
            .progress({ progressData in
                print(progressData)
            })
    }

    @IBAction func logout(_ sender: Any) {
        DropboxClientsManager.unlinkClients()
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
        let cell = tableView.cellForRow(at: indexPath)!
        self.download(filename: cell.textLabel!.text!)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
