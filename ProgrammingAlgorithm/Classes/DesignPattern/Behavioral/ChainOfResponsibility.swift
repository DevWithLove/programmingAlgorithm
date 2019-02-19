//
//  ChainOfResponsibility.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 18/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 Chain of responsibility
 Organizes potential request processors in a sequence and decouples responders from callers.
 
 Motivation:
 Decouple request sender from receiver (such as responder chain)
 - Send requests throught a chain of objects
 - Candidates mya or may not handle the request
 - The request travels until it's processed or it reacheds the end of the chain
 */

//MARK: MessageProcessor Demo

protocol Message {
    var name: String {get}
}

protocol MessageProcessing: CustomStringConvertible {
    var nextProcessor: MessageProcessing? {get}
    init(next: MessageProcessing?)
    func process(message: Message)
    
    var messageIDs: [String]? {get}
}

struct ResponseMessage: Message {
    var name: String
}

// Use protocol extension to define default value for stored property and implemention of func
extension MessageProcessing {
    func process(message: Message) {
        if let shouldProcess = messageIDs?.contains(where: {$0 == message.name}), shouldProcess == true {
            print("Message processed by \(self)")
        } else if let next = nextProcessor {
            print("\(self) could not process message \(message)")
            next.process(message: message)
        } else {
            print("Next responder not set. Reached the end")
        }
    }
}

struct XMLProcessor: MessageProcessing {
    var nextProcessor: MessageProcessing?
    
    
    init(next: MessageProcessing?) {
        self.nextProcessor = next
    }
    
    var messageIDs: [String]? {
        return ["XML"]
    }
    
    var description: String {
        return "XMLProcessor"
    }
}

struct JSONProcessor: MessageProcessing {
    
    var nextProcessor: MessageProcessing?
    
    init(next: MessageProcessing?) {
        self.nextProcessor = next
    }
    
    var messageIDs: [String]? {
        return ["JSON"]
    }
    
    var description: String {
        return "JSONProcessor"
    }
}

struct ResponderChainEnd: MessageProcessing {
    var nextProcessor: MessageProcessing?
    
    init (next: MessageProcessing?) {}
    
    func process(message: Message) {
        print("Reached the end of the responder chain")
    }
    
    var messageIDs: [String]? {
        return nil
    }
    
    var description: String {
        return "ResponderChainEnd"
    }
}

fileprivate func MessageProcessorSample() {
    let message = ResponseMessage (name: "text")
    
    let responderChainEnd = ResponderChainEnd(next: nil)
    let jsonProcessor = JSONProcessor(next: responderChainEnd)
    let xmlProcessor = XMLProcessor(next: jsonProcessor)
    
    xmlProcessor.process(message: message)
    
}

//MARK: BackupService Demo

protocol WeatherService {
    var backupService: WeatherService? { get }
    init (backupService: WeatherService?)
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void)
}

struct WeatherData {
    let city: String
    let countryCode: String
    let weather: String
    let temp: Float
    let unit: TempUnit
}

enum TempUnit: CustomStringConvertible{
    case scientific
    case metric
    case imperial
    
    var description: String{
        switch self {
            case .scientific: return "Kelvin"
            case .metric: return "Celsius"
            case .imperial: return "Fahrenheit"
        }
    }
}

extension WeatherService {
    var backupService: WeatherService? {
        return nil
    }
}

enum WeatherServiceError: Error {
    case serviceDown
    case noData
    case unknown
}

extension WeatherServiceError: LocalizedError {
    var errorDescription: String {
        switch self {
        case .serviceDown: return "Service unavailable"
        case .noData: return "Could not retireve weather data"
        case .unknown: return "Unknown error occured"
        }
    }
}

struct OpenWeatherService: WeatherService, CustomStringConvertible {
    internal var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil ) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        // if has error, try the backup service
        backupService?.fetchCurrentWeather(city: city, countyCode: countyCode, completionHandler: completionHandler)
    }
    
    var description: String {
        return "OpenWeatherService"
    }
}

struct AccuWeatherService: WeatherService, CustomStringConvertible {
    internal var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        // if has error, try the backup service
        backupService?.fetchCurrentWeather(city: city, countyCode: countyCode, completionHandler: completionHandler)
    }
    
    var description: String {
        return "OpenWeatherService"
    }
}

struct DarkWeatherService: WeatherService, CustomStringConvertible {
    internal var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        // if has error, try the backup service
        backupService?.fetchCurrentWeather(city: city, countyCode: countyCode, completionHandler: completionHandler)
    }
    
    var description: String {
        return "OpenWeatherService"
    }
}

struct WeatherServiceWrapper: WeatherService {
    init(backupService: WeatherService? = nil) {
    }
    
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        let darkService = DarkWeatherService()
        let accuService = AccuWeatherService(backupService: darkService)
        let openService = OpenWeatherService(backupService: accuService)
        
        openService.fetchCurrentWeather(city: city, countyCode: countyCode) { (data, error) in
            guard error == nil else {
                print("Error ...")
                return
            }
            
            print(data ?? "NoData")
        }
        
    }

}

//MARK: Cocoa Touch responder chain

// See the AppDelegate file

//MARK: MoneyPile Example

protocol MoneyPile {
    var value: Int {get}
    var quantity: Int {get set}
    var nextPile: MoneyPile? {get set}
    // designated initializer which will ensure that your class or structer type will instantiate correctly
    init()
    func canWithdraw(amount: Int) -> Bool
}

extension MoneyPile {
// variable cannot be initialized in the protocol extenstion because its declared as constant {get}
// Because the protocol is not concrete type, you cannot initialize an instance of P. you can only initialize a concrete type, an associated type or generic type.
    
    init(quantity:Int, nextPile: MoneyPile?) {
        self.init()
        self.quantity = quantity
        self.nextPile = nextPile
    }
    
    func canWithdraw(amount: Int) -> Bool {
        var amount = amount
        var quantity = self.quantity
  
        func canTakeSomeBill(want: Int) -> Bool {
            return ( want / value ) > 0
        }
        
        while canTakeSomeBill(want: amount) {
            if quantity == 0 {
                break
            }
            
            amount -= self.value
            quantity -= 1
        }
        
        guard amount > 0 else {
            return true
        }
        
        if let next = self.nextPile {
            return next.canWithdraw(amount: amount)
        }
        
        return false
    }
}

final class MoneyPileFor10: MoneyPile {
    let value: Int = 10
    var quantity: Int = 0
    var nextPile: MoneyPile?
}

final class MoneyPileFor20: MoneyPile {
    let value: Int = 20
    var quantity: Int = 0
    var nextPile: MoneyPile?
}

final class MoneyPileFor50: MoneyPile {
    let value: Int = 50
    var quantity: Int = 0
    var nextPile: MoneyPile?
}

final class MoneyPileFor100: MoneyPile {
    let value: Int = 100
    var quantity: Int = 0
    var nextPile: MoneyPile?
}

final class ATM {
    private var hundred: MoneyPile
    private var fifty: MoneyPile
    private var twenty: MoneyPile
    private var ten: MoneyPile
    
    private var startPile: MoneyPile {
        return self.hundred
    }
    
    init(hundred: MoneyPile,
         fifty: MoneyPile,
         twenty: MoneyPile,
         ten: MoneyPile) {
        
        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }
    
    func canWithdraw(amount: Int) -> String {
        return "Can withdraw: \(self.startPile.canWithdraw(amount: amount))"
    }
}


fileprivate func MoneyPileUsage(){
    let ten = MoneyPileFor10(quantity: 6, nextPile: nil)
    let twenty = MoneyPileFor20(quantity: 2, nextPile: ten)
    let fifty = MoneyPileFor50(quantity: 2, nextPile: twenty)
    let hundred = MoneyPileFor100(quantity: 1, nextPile: fifty)
    
    let atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
    _ = atm.canWithdraw(amount: 310)
    _ = atm.canWithdraw(amount: 100)
}
