//
//  ServerDateFormatter.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 23/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

class RequestDateFormatter: DateFormatter {
    static let shared: DateFormatter = {
        let dateFormatter = RequestDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // 20190726
        return dateFormatter
    }()
}
