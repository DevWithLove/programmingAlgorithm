//
//  KeyPathSampleTest.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 1/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import XCTest
import Nimble

class KeyPathSampleTest: XCTestCase {
    
    func test_Print_Identifiable() {
        
        // Arrange
        let person = Person(socialSecurityNumberr: "111-11-11",name: "Tom Smith")
        let book = Book(isbn: "1212",title: "TestBook")
        
        // Act
        let personId = person[keyPath: Person.idKeyPath]
        let bookId = book[keyPath: Book.idKeyPath]
        
        // Assert
        expect(personId).to(equal(person.socialSecurityNumberr))
        expect(bookId).to(equal(book.isbn))
    }
}
