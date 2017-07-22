//
//  ViewController.swift
//  IRC
//
//  Created by Samuel Ryan Goodwin on 7/18/17.
//  Copyright © 2017 Roundwall Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {

    let session = URLSession.shared
    var task: URLSessionStreamTask!
    
    private func send(_ message: String) {
        print("queing message \(message)")
        task.write((message + "\r\n").data(using: .utf8)!, timeout: 0) { (error) in
            if let error = error {
                print("Failed to send: \(String(describing: error))")
            } else {
                print("Sent!")
            }
        }
    }
    
    private func read() {
        task.readData(ofMinLength: 0, maxLength: 9999, timeout: 0) { (data, atEOF, error) in
            if atEOF {
                print("Connection's done!")
                return
            }
            
            guard let data = data, let message = String(data: data, encoding: .utf8) else {
                print("No data!")
                return
            }
            
            print(message)
            self.read()
        }
    }
    
    @IBAction func connect(_ sender: Any) {
        task = session.streamTask(withHostName: "irc.freenode.org", port: 6667)
        task.resume()
        read()
        send("NICK mukman")
        send("USER sgoodwin 0 * :Samuel Goodwin")
    }
    
    @IBAction func userTyped(_ sender: NSTextField) {
        send(sender.stringValue)
        // send("JOIN :#clearlynotarealchannel")
    }
}

