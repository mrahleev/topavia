//
//  ViewController.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 09/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak private var outlineView: NSOutlineView!
    
    private let fetchService: FetchServiceProtocol = FetchService()
    private var map = [CityA]()
    private let sema = DispatchSemaphore(value: 0)
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outlineView.dataSource = self
        outlineView.delegate = self
        
        DispatchQueue.global().async {
            self.getCitiesGraph()
        }
    }
    
    // MARK: - Helpers
    
    private func getCitiesGraph() {
        
        fetchService.getDepartureCities { (result) in
            let cities = try! result.get()
            self.map = cities.map { .init(city: $0) }
            self.sema.signal()
        }
        sema.wait()
        
        map
            .forEach { (cityA) in
                fetchService.getArrivalCountries(departureCityId: cityA.city.key) { (result) in
                    let countries = try! result.get()
                    cityA.countriesB = countries.map { .init(cityA: cityA, country: $0) }
                    self.sema.signal()
                }
                sema.wait()
        }
        
        map
            .flatMap { $0.countriesB }
            .forEach { (countryB) in
                fetchService.getArrivalCities(departureCityId: countryB.cityA.city.key, arrivalCountryId: countryB.country.key) { (result) in
                    let cities = try! result.get()
                    countryB.citiesB = cities.map { .init(countryB: countryB, city: $0) }
                    self.sema.signal()
                }
                sema.wait()
        }
        
        DispatchQueue.main.async {
            self.outlineView.reloadData()
            self.outlineView.expandItem(nil, expandChildren: true)
        }
        return
        
        map
            .flatMap { $0.countriesB }
            .flatMap { $0.citiesB }
            .forEach { (cityB) in
                fetchService.getDatesAtoB(aId: cityB.countryB.cityA.city.key, bId: cityB.city.key) { (result) in
                    let dates = try! result.get()
                    cityB.datesAB = dates.map { .init(cityB: cityB, date: $0) }
                    self.sema.signal()
                }
                sema.wait()
        }
        
        map
            .flatMap { $0.countriesB }
            .flatMap { $0.citiesB }
            .flatMap { $0.datesAB }
            .forEach { (dateAB) in
                fetchService.getDatesBtoA(aId: dateAB.cityB.countryB.cityA.city.key, bId: dateAB.cityB.city.key, abDate: dateAB.date) { (result) in
                    let dates = try! result.get()
                    dateAB.datesBA = dates.map { .init(dateAB: dateAB, date: $0) }
                    self.sema.signal()
                }
                sema.wait()
        }
        
        var flightsResults = [FlightResult]()
        map
            .flatMap { $0.countriesB }
            .flatMap { $0.citiesB }
            .flatMap { $0.datesAB }
            .flatMap { $0.datesBA }
            .forEach { (dateBA) in
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
        
        let flightsWithPlaces = flightsResults.flatMap { $0.flights }.filter { $0.hasPlaces }
        let cheapestFlights = flightsWithPlaces.sorted { $0.cost < $1.cost }
        print("")
        
        DispatchQueue.main.async {
            self.outlineView.reloadData()
        }
    }
}

extension ViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item = item else {
            /// root
            return map.count
        }
        
        if let cityA = item as? CityA {
            return cityA.countriesB.count
        } else if let countryB = item as? CountryB {
            return countryB.citiesB.count
        } else {
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item is CityA || item is CountryB
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item = item else {
            /// root
            return map[index]
        }
        
        if let cityA = item as? CityA {
            return cityA.countriesB[index]
        } else if let countryB = item as? CountryB {
            return countryB.citiesB[index]
        } else {
            fatalError("No child item exists")
        }
    }
}

extension ViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let textCellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "TextCell")
        let textCell = outlineView.makeView(withIdentifier: textCellIdentifier, owner: self)
        guard let cellView = textCell as? NSTableCellView else {
            return nil
        }
        
        var text = ""
        if let cityA = item as? CityA {
            text = cityA.city.name
        } else if let countryB = item as? CountryB {
            text = countryB.country.name
        } else if let cityB = item as? CityB {
            text = cityB.city.name
        }
        
        cellView.textField?.stringValue = text
        
        return cellView
    }
}
