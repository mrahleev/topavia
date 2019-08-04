//
//  Flight.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 11/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

///{
///    ...
///    "Results":
///    [
///    {
///        "Key": 100000202,
///        "Name": "D Минск - Измир- Минск",
///        "Cost": 630,
///        "Services": [
///            {
///                "DepartureCity": {
///                    "Key": 630,
///                    "Value": "Минск"
///                },
///                "DepartureCountry": {
///                    "Key": 375,
///                    "Value": "Беларусь"
///                },
///                "ArrivalCity": {
///                    "Key": 629,
///                    "Value": "Измир"
///                },
///                "ArrivalCountry": {
///                    "Key": 5,
///                    "Value": "Турция"
///                },
///                "EndDateTime": "2019-07-26T20:40:00",
///                "BeginDateTime": "2019-07-26T18:00:00",
///                "FlightDetails": [
///                    {
///                        "QuotaStatus": {
///                            "PlacesStatus": 1,
///                        },
///                    }
///                ],
///            }, ...
///        ],
///    }, ...
///    ]
///}

struct FlightResult: Decodable {
    let flights: [Flight]
    
    enum CodingKeys: String, CodingKey {
        case flights = "Result"
    }
}

struct Flight: Decodable {
    let key: Int
    let name: String
    let cost: Int
    let services: [Service]
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case name = "Name"
        case cost = "Cost"
        case services = "Services"
    }
    
    var description: String {
        let sortedServices = services.sorted { $0.beginDateTime < $1.beginDateTime }
        let hasABPlaces = sortedServices.safe(at: 0)?.detail.first?.quotaStatus.placesStatus.hasPlaces ?? false
        let hasBAPlaces = sortedServices.safe(at: 1)?.detail.first?.quotaStatus.placesStatus.hasPlaces ?? false

        return "\(name) \(cost)$, abPlaces? \(hasABPlaces), baPlaces? \(hasBAPlaces)"
    }
    
    // MARK: - Service
    
    struct Service: Decodable {
        let departureCity: City
        let departureCountry: Country
        let arrivalCity: City
        let arrivalCountry: Country
        let beginDateTime: Date
        let endDateTime: Date
        let detail: [Detail]
        
        enum CodingKeys: String, CodingKey {
            case departureCity = "DepartureCity"
            case departureCountry = "DepartureCountry"
            case arrivalCity = "ArrivalCity"
            case arrivalCountry = "ArrivalCountry"
            case beginDateTime = "BeginDateTime"
            case endDateTime =  "EndDateTime"
            case detail = "FlightDetails"
        }
        
        // MARK: - Detail
        
        struct Detail: Decodable {
            let quotaStatus: QuotaStatus
            
            enum CodingKeys: String, CodingKey {
                case quotaStatus = "QuotaStatus"
            }
            
            // MARK: - QuotaStatus
            
            struct QuotaStatus: Decodable {
                let placesStatus: PlacesStatus
                
                enum CodingKeys: String, CodingKey {
                    case placesStatus = "PlacesStatus"
                }
                
                enum PlacesStatus: Int, Decodable {
                    /// Есть места
                    case places = 1
                    /// Нет мест
                    case noPlaces = 2
                    /// Запрос
                    case request = 4
                    /// Мало мест
                    case fewPlaces = 5
                    
                    var hasPlaces: Bool {
                        return self == .places || self == .fewPlaces
                    }
                }
            }
        }
    }
}
