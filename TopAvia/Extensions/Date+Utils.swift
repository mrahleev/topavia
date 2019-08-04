//
//  Date+Utils.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 02/08/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

extension Date {
    private static let dateFormatter = DateFormatter()
    
    func toString(_ format: String = "dd.MM.YYYY") -> String {
        Date.dateFormatter.dateFormat = format
        return Date.dateFormatter.string(from: self)
    }
}
