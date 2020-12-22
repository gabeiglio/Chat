//
//  Message.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/1/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import Foundation

struct Message: Hashable {
    let id: String
    let sender: String
    let receiver: String
    let payload: String
}

extension Message {
    static public func getDummyMessages() -> [Message] {
        var messages = [Message]()
        
        messages.append(Message(id: "1", sender: "0", receiver: "1", payload: "Hello"))
        messages.append(Message(id: "2", sender: "0", receiver: "1", payload: "Hello"))
        messages.append(Message(id: "3", sender: "1", receiver: "0", payload: "How are you?"))
        messages.append(Message(id: "4", sender: "1", receiver: "0", payload: "Good and you"))
        messages.append(Message(id: "5", sender: "0", receiver: "1", payload: "segqeoigaeoimjvoioewfjioi"))

        return messages
    }
}
