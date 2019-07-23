//
//  City.swift
//  TopAvia
//
//  Created by Darya Kuliashova on 7/22/19.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

struct City: Decodable {
    let key: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case name = "Name"
    }
}
