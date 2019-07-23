//
//  Flight.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 11/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

struct Flight: Decodable {
    let aId: Int
    let bId: Int
    let abDate: Date
    let baDate: Date
}
