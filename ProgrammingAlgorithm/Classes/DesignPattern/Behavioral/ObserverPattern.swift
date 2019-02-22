//
//  ObserverPattern.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 22/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation


/*
 
 Allow subscribers to get notified about changes in another object, without being tightly coupled to the sender
 
 Motivation:
 Broadcast notifications to observers
 - Objects subscribe to receive notification about changes in another object
 - Notify observers when changes occur
 - No dependency between the sender and receiver(s)
 
 */

struct Bidder {
    var id: String
    init(id: String) {
        self.id = id
        NotificationCenter.default.addObserver(forName: Notification.Name(BidNotificationNames.bidNotification), object: nil, queue: nil) { (notification) in
            if let userInfo = notification.userInfo,
               let bidValue = userInfo["bid"] as? Float,
                let message = userInfo["message"] as? String {
                print("\(id) new bid is \(bidValue) \(message)")
            }
        }
    }
}

struct BidNotificationNames {
    static let bidNotification = "bidNotification"
}

struct Auctioneer {
    private var bidders = [Bidder]()

    private var auctionEnded: Bool = false
    private var currentBid: Float = 0
    private var reservePrice: Float = 0

    var bid: Float {
        set {
            if auctionEnded {
                print("auction ended")
            } else if newValue > currentBid {
                print("\nNew bid $\(newValue) accepted")
                if newValue >= reservePrice {
                    print("Reserve price met! Auction ended.")
                    auctionEnded = true
                }
                currentBid = newValue
                
                let message = bid > reservePrice ? "Reserve met, item sold!": ""
                let notification = Notification(name: Notification.Name(rawValue: BidNotificationNames.bidNotification), object: nil, userInfo: ["bid": bid, "message": message])
                NotificationCenter.default.post(notification)
            }
        }
        get {
            return currentBid
        }
    }

    init(initialBid: Float = 0, reservePrice: Float) {
        self.bid = initialBid
        self.reservePrice = reservePrice
    }
}


private func sample() {

    var auctioneer = Auctioneer(reservePrice: 500)

    let bidder1 = Bidder(id: "Joe")
    let bidder2 = Bidder(id: "Quinn")
    let bidder3 = Bidder(id: "Sal")

    auctioneer.bid = 100 // will send notify to all bidder
    
    NotificationCenter.default.removeObserver(bidder1)
}


// Following is custom way without use notificationCenter
//protocol Observer {
//    associatedtype Notification
//    func update(notification: Notification)
//}
//
//protocol Subject {
//    associatedtype O: Observer
//    mutating func attach(observer: O)
//    mutating func detech(observer: O)
//    func notifyObservers()
//}
//
//struct Bidder: Observer {
//    var id: String
//    func update(notification: BidNotification) {
//        print("Id: \(id) new bid is: \(notification.bid) \(notification.message ?? "")")
//    }
//}
//
//struct BidNotification {
//    var bid: Float
//    var message: String?
//}
//
//struct Auctioneer: Subject {
//    private var bidders = [Bidder]()
//
//    private var auctionEnded: Bool = false
//    private var currentBid: Float = 0
//    private var reservePrice: Float = 0
//
//    var bid: Float {
//        set {
//            if auctionEnded {
//                print("auction ended")
//            } else if newValue > currentBid {
//                print("\nNew bid $\(newValue) accepted")
//                if newValue >= reservePrice {
//                    print("Reserve price met! Auction ended.")
//                    auctionEnded = true
//                }
//                currentBid = newValue
//                notifyObservers()
//            }
//        }
//        get {
//            return currentBid
//        }
//    }
//
//    mutating func attach(observer: Bidder) {
//        bidders.append(observer)
//    }
//
//    mutating func detech(observer: Bidder) {
//        self.bidders = bidders.filter{ $0.id != observer.id}
//    }
//
//    func notifyObservers() {
//        let message = bid > reservePrice ? "Reserve met, item sold" : nil
//        let notification = BidNotification(bid: bid, message: message)
//
//        bidders.forEach { (bidder) in
//            bidder.update(notification: notification)
//        }
//    }
//
//    init(initialBid: Float = 0, reservePrice: Float) {
//        self.bid = initialBid
//        self.reservePrice = reservePrice
//    }
//}
//
//
//private func sample() {
//
//    var auctioneer = Auctioneer(reservePrice: 500)
//
//    let bidder1 = Bidder(id: "Joe")
//    let bidder2 = Bidder(id: "Quinn")
//    let bidder3 = Bidder(id: "Sal")
//
//    auctioneer.attach(observer: bidder1)
//    auctioneer.attach(observer: bidder2)
//    auctioneer.attach(observer: bidder3)
//
//    auctioneer.bid = 100 // will send notify to all bidder
//
//}
