//
//  ViewController.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 09/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    private let fetchService: FetchServiceProtocol = FetchService()
    
    private let sema = DispatchSemaphore(value: 0)
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            // self.test()
            self.getCitiesGraph()
        }
    }
    
    // MARK: - Helpers
    
    private func getCitiesGraph() {
        var citiesA = [CityA]()
        
        fetchService.getDepartureCities { (result) in
            let cities = try! result.get()
            cities.forEach { citiesA.append(.init(city: $0)) }
            self.sema.signal()
        }
        sema.wait()
        
        var countriesB = [CountryB]()
        citiesA.forEach { (cityA) in
            fetchService.getArrivalCountries(departureCityId: cityA.city.key) { (result) in
                let countries = try! result.get()
                countries.forEach { countriesB.append(.init(cityA: cityA, country: $0)) }
                self.sema.signal()
            }
            sema.wait()
        }
        
        var citiesB = [CityB]()
        countriesB.forEach { (countryB) in
            fetchService.getArrivalCities(departureCityId: countryB.cityA.city.key, arrivalCountryId: countryB.country.key) { (result) in
                let cities = try! result.get()
                cities.forEach { citiesB.append(.init(countryB: countryB, city: $0)) }
                self.sema.signal()
            }
            sema.wait()
        }
        
        var datesAB = [DateAB]()
        citiesB.forEach { (cityB) in
            fetchService.getDatesAtoB(aId: cityB.countryB.cityA.city.key, bId: cityB.city.key) { (result) in
                let dates = try! result.get()
                dates.forEach { datesAB.append(.init(cityB: cityB, date: $0)) }
                self.sema.signal()
            }
            sema.wait()
        }
        
        var datesBA = [DateBA]()
        datesAB.forEach { (dateAB) in
            fetchService.getDatesBtoA(aId: dateAB.cityB.countryB.cityA.city.key, bId: dateAB.cityB.city.key, abDate: dateAB.date) { (result) in
                let dates = try! result.get()
                dates.forEach { datesBA.append(.init(dateAB: dateAB, date: $0)) }
                self.sema.signal()
            }
            sema.wait()
        }
        
        var flightsResults = [FlightResult]()
        datesBA.forEach { (dateBA) in
            fetchService.getFlight(
                aId: dateBA.dateAB.cityB.countryB.cityA.city.key,
                bId: dateBA.dateAB.cityB.city.key,
                abDate: dateBA.dateAB.date,
                baDate: dateBA.date) { (result) in
                    let flightResults = try! result.get()
                    flightsResults.append(flightResults)
                    self.sema.signal()
            }
            sema.wait()
        }
        
        var flights = flightsResults.flatMap { $0.flights }
        flights.sort { $0.cost < $1.cost }
        
        print("")
    }
}
