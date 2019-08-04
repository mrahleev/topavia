//
//  Array+Utils.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 02/08/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

extension Array {
    
    func safe(at index: Int) -> Element? {
        if isEmpty {
            return nil
        } else if count < index {
            return self[index]
        } else {
            return nil
        }
    }
}
