//
//  MementoTests.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 22/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import XCTest

class MementoTests: XCTestCase {
    
    func testMemento() {

        let gameScene = GameSence()
        gameScene.start()
        
        let sceneManager = GameSceneManager()
        sceneManager.saveState(originator: gameScene, identifier: "initial")
        print(gameScene)
        
        let expect = expectation(description: "Finished all async call")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            gameScene.levelProgress = 55
            gameScene.levelScore = 2500
            
            sceneManager.saveState(originator: gameScene, identifier: "snapshot_1")
            print(gameScene)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                gameScene.levelProgress = 80
                gameScene.levelScore = 10000
                
                sceneManager.saveState(originator: gameScene, identifier: "snapshot_2")
                print(gameScene)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    sceneManager.restoreState(originator: gameScene, identifier: "initial")
                    print("Rescoring initial")
                    print(gameScene)
                    expect.fulfill()
                }
            }
            
        }
        
        waitForExpectations(timeout: 15) { (error) in
            XCTAssertNil(error, "Test expection failed")
        }
        
    }
    
}
