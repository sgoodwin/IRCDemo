//
//  ViewController.swift
//  IRC
//
//  Created by Samuel Ryan Goodwin on 7/18/17.
//  Copyright © 2017 Roundwall Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate, URLSessionDelegate, IRCServerDelegate {

    var server: IRCServer? = nil
    
    @IBAction func connect(_ sender: Any) {
        let user = IRCUser(username: "sgoodwin", realName: "Samuel Goodwin", nick: "mukman")
        server = IRCServer.connect("127.0.0.1", port: 6667, user: user)
        server?.delegate = self
    }
    
    func didRecieveMessage(_ server: IRCServer, message: String) {
        print(message)
    }
    
    @IBAction func userTyped(_ sender: NSTextField) {
        server?.send(sender.stringValue)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("Session error: \(error)")
    }
}

