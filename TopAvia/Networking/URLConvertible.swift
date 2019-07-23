//
//  URLConvertible.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 23/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}
