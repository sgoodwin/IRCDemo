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
            let firstSpaceIndex = message.index(of: " ")!
            let source = message.substring(to: firstSpaceIndex)
            let rest = message.substring(from: firstSpaceIndex).trimmingCharacters(in: .whitespacesAndNewlines)
            print(source)
            
            if rest.hasPrefix("PRIVMSG") {
                let remaining = rest.substring(from: rest.index(message.startIndex, offsetBy: 8))
                
                if remaining.hasPrefix("#") {
                    let split = remaining.components(separatedBy: ":")
                    let channel = split[0].trimmingCharacters(in: CharacterSet(charactersIn: " #"))
                    let user = source.components(separatedBy: "!")[0].trimmingCharacters(in: CharacterSet(charactersIn: ":"))
                    let message = split[1]
                    
                    return .channelMessage(channel: channel, user: user, message: message)
                }
            } else if rest.hasPrefix("JOIN") {
                let user = source.components(separatedBy: "!")[0].trimmingCharacters(in: CharacterSet(charactersIn: ":"))
                let channel = rest.substring(from: rest.index(message.startIndex, offsetBy: 5)).trimmingCharacters(in: CharacterSet(charactersIn: "# "))
                return .joinMessage(user: user, channel: channel)
            } else{
                let server = source.trimmingCharacters(in: CharacterSet(charactersIn: ": "))
                let message = rest.components(separatedBy: ":")[1]
                return .serverMessage(server: server, message: message)
            }
        }
        
        return .unknown(raw: message)
    }
}

enum IRCServerInput: Equatable {
    case unknown(raw: String)
    case ping
    case serverMessage(server: String, message: String)
    case channelMessage(channel: String, user: String, message: String)
    case joinMessage(user: String, channel: String)
}

func ==(lhs: IRCServerInput, rhs: IRCServerInput) -> Bool{
    switch (lhs, rhs) {
    case (.ping, .ping):
        return true
    case (.channelMessage(let lhsChannel, let lhsUser, let lhsMessage),
          .channelMessage(let rhsChannel, let rhsUser, let rhsMessage)):
        return lhsChannel == rhsChannel && lhsMessage == rhsMessage && lhsUser == rhsUser
    case (.serverMessage(let lhsServer, let lhsMessage),
          .serverMessage(let rhsServer, let rhsMessage)):
        return lhsServer == rhsServer && lhsMessage == rhsMessage
    case (.joinMessage(let lhsUser, let lhsChannel), .joinMessage(let rhsUser, let rhsChannel)):
        return lhsUser == rhsUser && lhsChannel == rhsChannel
    default:
        return false
    }
}
