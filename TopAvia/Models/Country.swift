//
//  Country.swift
//  TopAvia
//
//  Created by Darya Kuliashova on 7/22/19.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

struct Country: Decodable {
    let name: String
    let key: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case value = "Value"
        case key = "Key"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decode(Int.self, forKey: .key)
        do {
            name = try values.decode(String.self, forKey: .name)
        } catch {
            name = try values.decode(String.self, forKey: .value)
        }
    }
}

extension Country: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}
