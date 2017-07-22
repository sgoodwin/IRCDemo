//
//  IRCServerInputParser.swift
//  IRC
//
//  Created by Samuel Ryan Goodwin on 7/22/17.
//  Copyright © 2017 Roundwall Software. All rights reserved.
//

import Foundation

struct IRCServerInputParser {
    static func parseServerMessage(_ message: String) -> IRCServerInput {
        if message == "PING" {
            return .ping
        }
        
        if message.hasPrefix(":") {
            let split = message.components(separatedBy: ":")
            return .serverMessage(server: split[1].components(separatedBy: " ")[0], message: split[2])
        }
        
        if message.hasPrefix("PRIVMSG") {
            let remaining = message.substring(from: message.index(message.startIndex, offsetBy: 8))
            
            if remaining.hasPrefix("#") {
                let split = remaining.components(separatedBy: ":")
                return .channelMessage(channel: split[0].trimmingCharacters(in: CharacterSet(charactersIn: " #")), message: split[1])
            }
        }
        
        return .unknown(raw: message)
    }
}

enum IRCServerInput: Equatable {
    case unknown(raw: String)
    case ping
    case serverMessage(server: String, message: String)
    case channelMessage(channel: String, message: String)
}

func ==(lhs: IRCServerInput, rhs: IRCServerInput) -> Bool{
    switch (lhs, rhs) {
    case (.ping, .ping):
        return true
    case (.channelMessage(let lhsChannel, let lhsMessage),
          .channelMessage(let rhsChannel, let rhsMessage)):
        return lhsChannel == rhsChannel && lhsMessage == rhsMessage
    case (.serverMessage(let lhsServer, let lhsMessage),
          .serverMessage(let rhsServer, let rhsMessage)):
        return lhsServer == rhsServer && lhsMessage == rhsMessage
    default:
        return false
    }
}
