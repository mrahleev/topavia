//
//  City.swift
//  TopAvia
//
//  Created by Darya Kuliashova on 7/22/19.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

struct City: Decodable {
    let name: String
    let key: Int

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case key = "Key"
    }
}
