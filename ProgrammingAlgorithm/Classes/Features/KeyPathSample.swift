//
//  KeyPathSample.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 1/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

struct Person: Identifiable {
    static let idKeyPath = \Person.socialSecurityNumberr
    var socialSecurityNumberr: String
    var name: String
}

struct Book: Identifiable {
    static let idKeyPath = \Book.isbn
    var isbn: String
    var title: String
}

protocol Identifiable {
    associatedtype ID
    static var idKeyPath: WritableKeyPath<Self,ID> { get }
}




