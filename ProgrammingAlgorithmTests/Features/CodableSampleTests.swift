//
//  CodableSampleTests.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 20/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import XCTest
import Nimble

class CodableSampleTests: XCTestCase {

    func testEncode_to_JSON() {
        // Arrange
        let carObj = Car()
        carObj.name = "City ZX"
        carObj.isNew = true
        carObj.yearOfManufacture = 2018
        carObj.companyURL = URL(string: "www.honda.com")
        carObj.carType = .Sedan
        carObj.otherDetailsData = ["color":"Red","fuelType":"Petrol"]
        carObj.carSize = CarSize(height: 100, length: 200)
        
        // Act
        // Assert
        let encodeObject = try? JSONEncoder().encode(carObj)
        if let encodeJsonString = String(data: encodeObject!, encoding: .utf8) {
            print(encodeJsonString)
        }
    }
    
    func testDecode_to_model() {
        
        // Arrange
        let jsonString = """
                        {"name":"City ZX",
                            "isNew":true,
                            "yearOfManufacture":2018,
                            "companyURL":"www.honda.com",
                            "carType":"Sedan",
                            "carSize":{
                                       "height":200,
                                       "length":100
                                   },
                            "otherDetailsData":{
                                       "color":"Red",
                                       "fuelType":"Petrol"
                                   },
                        }
                        """
        
        if let jsonData = jsonString.data(using: .utf8)
        {
            //And here you get the Car object back
            do {
                let carObject = try JSONDecoder().decode(Car.self, from: jsonData)
                expect(carObject.name).to(equal("City ZX"))
            }
            catch {
                print(error)
            }
        }
    }
    
    func testEncoding_to_Json_for_specific_properties(){
        
        let personObj = CodablePerson()
        personObj.name = "Singh, Viresh"
        personObj.age = 30
        personObj.gender = .Male
        personObj.phone = "9999999999"
        personObj.country = "India"
        let encodedObject = try? JSONEncoder().encode(personObj)
        
        if let encodedObjectJsonString = String(data: encodedObject!, encoding: .utf8)
        {
            //It will encode only selected properties - name, age, gender as we have defined CodingKeys enum in Person class.
            //'Phone' and 'Country' values will not be included in JSON
            print(encodedObjectJsonString)
        }
    }
    
    func testDecode_to_model_for_specific_properties() {
        
        // Arrange
        let jsonString = """
                    {       "personName":"Singh, Viresh",
                            "age":30,
                            "gender":"Male",
                            "phone":"9999999999",
                            "country":"India" }
                  """
        
        if let jsonData = jsonString.data(using: .utf8)
        {
            //And here you get the Car object back
            do {
                let person = try JSONDecoder().decode(CodablePerson.self, from: jsonData)
                expect(person.name).to(equal("Singh, Viresh"))
                expect(person.country).to(beEmpty())
            }
            catch {
                print(error)
            }
        }
    }
    
    func testEncode_nested_model() {
        
        //Lets create a product
        let product = Product()
        product.name = "Apple iPad Pro"
        product.points = 100
        product.productDescription = "iPad Gold, 256 GB, 10.5 Inch"
        product.price = 850
        
        //And put it into a shelf
        let shelf = Shelf()
        shelf.name = "Electronics"
        shelf.product.append(product)
        
        //Assigned to particular aisle
        let aisle = Aisle()
        aisle.name = "New Arrivals"
        aisle.shelves.append(shelf)
        
        //In some supermarket
        let superMarket = Supermarket()
        superMarket.name = "Wallmart"
        superMarket.phone = "9999999999"
        superMarket.address = "Melville, NY"
        superMarket.aisles.append(aisle)
        
        let encodedData = try? JSONEncoder().encode(superMarket)
        if let encodedObjectJsonString = String(data: encodedData!, encoding: .utf8)
        {
            print(encodedObjectJsonString)
        }
    }
    
    func testDecode_nested_JSON() {
        
        let json = """
                   {"phone":"9999999999","aisles":[{"name":"New Arrivals","shelves":[{"name":"Electronics","product":[{"points":100,"productDescription":"iPad Gold, 256 GB, 10.5 Inch","name":"Apple iPad Pro","price":850}]}]}],"name":"Wallmart","address":"Melville, NY"}
                   """
        
        
        if let jsonData = json.data(using: .utf8)
        {
            do {
                //And here you get the Supermarket object back
                let superMarketObject = try JSONDecoder().decode(Supermarket.self, from: jsonData)
                
                print(superMarketObject.aisles.count)
                print(superMarketObject.aisles[0].shelves.count)
                print(superMarketObject.aisles[0].shelves[0].product.count)
                
            }catch {
                print(error)
            }
         
        }
        
    }
}
