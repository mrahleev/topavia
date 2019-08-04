//
//  URL+Utils.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 10/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

extension URL {

    mutating func appendQueryParams(_ params: [String: String]) {
        var urlComps = URLComponents(url: self, resolvingAgainstBaseURL: false)
        
        urlComps?.queryItems = params.compactMap { (key, value) in
            URLQueryItem(name: key, value: value)
        }

        self = urlComps?.url ?? self
    }
}
