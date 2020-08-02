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
    let sender: User
    let receiver: User
    let payload: String
}
