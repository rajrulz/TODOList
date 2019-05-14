//
//  Task.swift
//  TODO
//
//  Created by rajneesh on 14/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import Foundation

class Task: Codable {
    var title: String
    var time: Date
    
    init(title: String, time: Date) {
        self.title = title
        self.time = time
    }
    
}
