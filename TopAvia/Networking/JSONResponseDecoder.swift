//
//  JSONResponseDecoder.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 23/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

class JSONResponseDecoder: JSONDecoder {
    private static let decoderDateFormatter = DateFormatter()

    class func decoder(dateFormat: String?) -> JSONDecoder {
        let decoder = JSONDecoder()
        if let dateFormat = dateFormat {
            decoderDateFormatter.dateFormat = dateFormat
            decoder.dateDecodingStrategy = .formatted(decoderDateFormatter)
        }
        return decoder
    }
}
