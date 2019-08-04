//
//  FlightMap.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 23/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

class CityA: NSObject {
    var city: City
    
    override var description: String {
        return city.name
    }
    
    // MARK: -
    
    init(city: City) {
        self.city = city
    }
}

class CountryB: NSObject {
    var cityA: CityA
    var country: Country
    
    override var description: String {
        return "From \(cityA.description) to \(country.name)"
    }
    
    // MARK: -
    
    init(cityA: CityA, country: Country) {
        self.cityA = cityA
        self.country = country
    }
}

class CityB: NSObject {
    var countryB: CountryB
    var city: City

    override var description: String {
        return "\(countryB.description) to \(city.name)"
    }
    
    // MARK: -
    
    init(countryB: CountryB, city: City) {
        self.countryB = countryB
        self.city = city
    }
}

class DateAB: NSObject {
    var cityB: CityB
    var date: Date
    
    override var description: String {
        return "\(cityB.description) on \(date.toString())"
    }
    
    // MARK: -
    
    init(cityB: CityB, date: Date) {
        self.cityB = cityB
        self.date = date
    }
}

class DateBA: NSObject {
    var dateAB: DateAB
    var date: Date

    override var description: String {
        return "\(dateAB.description) and return \(date.toString())"
    }
    
    // MARK: -
    
    init(dateAB: DateAB, date: Date) {
        self.dateAB = dateAB
        self.date = date
    }
}
