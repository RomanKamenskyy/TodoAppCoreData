//
//  model.swift
//  Todoey
//
//  Created by roman on 13.07.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

class ItemUserDefault: Encodable, Decodable {
    let title: String
    var done: Bool = false
    
    init(title: String) {
        self.title = title
    }
}
