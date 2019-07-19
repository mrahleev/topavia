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

        params.forEach { (key, value) in
            let queryItem = URLQueryItem(name: key, value: value)
            urlComps?.queryItems?.append(queryItem)
        }

        self = urlComps?.url ?? self
    }
}
