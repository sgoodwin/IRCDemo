//
//  ViewController.swift
//  IRC
//
//  Created by Samuel Ryan Goodwin on 7/18/17.
//  Copyright © 2017 Roundwall Software. All rights reserved.
//

import Cocoa
import IRC

class ViewController: NSViewController, NSTextFieldDelegate, URLSessionDelegate, IRCServerDelegate, IRCChannelDelegate {
    var server: IRCServer? = nil
    var channel: IRCChannel? = nil
    
    @IBAction func connect(_ sender: Any) {
        let user = IRCUser(username: "sgoodwin", realName: "Samuel Goodwin", nick: "mukman")
        server = IRCServer.connect("127.0.0.1", port: 6667, user: user)
        server?.delegate = self
    }
    
    func didRecieveMessage(_ server: IRCServer, message: String) {
        print(message)
    }
    
    func didRecieveMessage(_ channel: IRCChannel, message: String) {
        print("\(channel): \(message)")
    }
    
    @IBAction func userTyped(_ sender: NSTextField) {
        if let channel = channel {
            channel.send(sender.stringValue)
        } else {
            server?.send(sender.stringValue)
        }
    }
    
    @IBAction func newDocument(_ sender: Any) {
        if channel != nil {
            return // Can only join one for now
        }
        
        // I just assume you wanna join #totallyafakechannel
        print("sup")
        
        channel = server?.join("totallyafakechannel")
        channel?.delegate = self
    }
}
