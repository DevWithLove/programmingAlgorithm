//
//  MementoPattern.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 21/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 
 Memento: captures the important state of an object without exposing its internal data.
 The saved state can be used to reset the object if needed. 
 
 Motivation
 Take a snapshot of an object's state
 - Keep the saved state external to the object
 - Dont break encapsulation
 - Provide the capabilityu to restore the object to a previous state
 
 */

public final class GameSence{
    private var score: UInt
    private var progress: Float
    private var sessionTime: TimeInterval
    
    lazy private var sessionTimer  = Timer.init(timeInterval: 1, repeats: true) { (timer) in
        self.sessionTime += timer.timeInterval
    }
    
    public init() {
        self.score = 0
        self.progress = 0
        self.sessionTime = 0
    }
    
    public func start() {
        RunLoop.current.add(sessionTimer, forMode: .default)
        sessionTimer.fire()
    }
    
    public var levelScore: UInt {
        get { return score }
        set { score = newValue }
    }
    
    public var levelProgress: Float {
        get { return progress }
        set { progress = newValue <= 100 ? newValue : 100 }
    }
}

extension GameSence: CustomStringConvertible {
    public var description: String {
        return "Level progress \(progress), player score: \(score). Play time \(sessionTime) seconds"
    }
}

// Capturesthe info needed to restore the object's state
protocol Memento {
    associatedtype State
    var state: State { get set }
}

// knows how to save and restore itself
protocol Originator {
    associatedtype M: Memento
    func createMemento() -> M
    mutating func apply (memento: M)
}

// Save and restores the originator's state
protocol Caretaker {
    associatedtype O: Originator
    func saveState(originator: O, identifier: AnyHashable)
    func restoreState(originator: O, identifier: AnyHashable)
}

struct GameMemento: Memento {
    var state: ExternalGameState
}

struct ExternalGameState {
    var playerScore: UInt
    var levelProgress: Float
}

extension GameSence: Originator {
    func apply(memento: GameMemento) {
        let restoreState = memento.state
        score = restoreState.playerScore
        progress = restoreState.levelProgress
    }
    
    func createMemento() -> GameMemento {
        let currentState = ExternalGameState(playerScore: score, levelProgress: progress)
        return GameMemento(state: currentState)
    }
}

final class GameSceneManager: Caretaker {
    private lazy var snapshots = [AnyHashable: GameMemento]()
    
    func saveState(originator: GameSence, identifier: AnyHashable) {
        let snapshot = originator.createMemento()
        snapshots[identifier] = snapshot
    }
    
    func restoreState(originator: GameSence, identifier: AnyHashable) {
        if let snapshot = snapshots[identifier]{
            originator.apply(memento: snapshot)
        }
    }
}

