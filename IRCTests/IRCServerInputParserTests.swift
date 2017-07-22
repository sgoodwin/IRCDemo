//
//  IRCServerInputParser.swift
//  IRCTests
//
//  Created by Samuel Ryan Goodwin on 7/22/17.
//  Copyright © 2017 Roundwall Software. All rights reserved.
//

import XCTest

func parseServerMessage(_ message: String) -> IRCServerInput {
    if message == "PING" {
        return .ping
    }
    
    return .channelMessage(channel: "sup", message: "bro")
}

enum IRCServerInput: Equatable {
    case ping
    case channelMessage(channel: String, message: String)
}

func ==(lhs: IRCServerInput, rhs: IRCServerInput) -> Bool{
    switch (lhs, rhs) {
    case (.ping, .ping):
        return true
    case (.channelMessage(let lhsChannel, let lhsMessage),
          .channelMessage(let rhsChannel, let rhsMessage)):
        return lhsChannel == rhsChannel && lhsMessage == rhsMessage
    default:
        return false
    }
}

class IRCServerInputParserTests: XCTestCase {

    func testPingMessage() {
        let input = parseServerMessage("PING")
        
        XCTAssertEqual(input, .ping)
    }
    
    func testChannelMessage() {
        let input = parseServerMessage("PRIVMSG #clearlynotarealchannel :this is so cool")
        
        XCTAssertEqual(input, IRCServerInput.channelMessage(channel: "clearlynotarealchannel", message: "this is so cool"))
    }

}
