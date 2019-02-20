//
//  CodableSample.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 20/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 refer : https://hackernoon.com/codable-in-swift4-e24f7cc253da
 
 Encodable: For Encoding model to external representation of data like JSON or plist
 Decodable: For decoding the external representation of data to your model.
 Codable:For both encoding and decoding. Apple defines it as:
    typealias Codable = Encodable & Decodable
 
 There are two encoders available to encode your data to required format:
    PropertyListEncoder — Encode your type to plist format
    JSONEncoder — Encode your type to JSON format
 */

struct CarSize:Codable
{
    var height: Double
    var length: Double
}

enum CarType: String, Codable
{
    case Unknown
    case SUV
    case Sedan
}

class Car: NSObject, Codable
{
    var name: String = ""
    var companyURL: URL? = nil
    var yearOfManufacture: Int = 0
    var isNew:Bool = true
    var otherDetailsData: [String:String]? = nil
    var carType: CarType = .Unknown
    var carSize: CarSize = CarSize(height: 0, length: 0)
}


/*
 Choosing specific properties to Encode/Decode (Skipping unnecessary properties)
 Its very unlikely that you will need to all of the class/struct properties to be encoded or to decode all the fields of JSON to your native model.
 Codable types can declare a special nested enumeration named CodingKeys that conforms to the CodingKey protocol. When this enumeration is present, its cases serve as the authoritative list of properties that must be included when instances of a codable type are encoded or decoded. The names of the enumeration cases should match the names you’ve given to the corresponding properties in your type. Omit properties from the CodingKeys enumeration if they won’t be present when decoding instances, or if certain properties shouldn’t be included in an encoded representation.
 CodingKey Enum — While using CodingKey enum, it has few rule which needs to be followed while using. CodingKey has RawType as String and Enum values must match case with the JSON key names.
 */

enum CodableGender: String, Codable
{
    case Male
    case Female
}

class CodablePerson: NSObject, Codable
{
    var name: String    = ""
    var age: Int        = 0
    var gender:CodableGender   = .Male
    var phone:String    = ""
    var country:String  = ""
    
    enum CodingKeys:String,CodingKey
    {
        //Encoding/decoding will only include the properties defined in this enum, rest will be ignored
        case name = "personName" //Handling different key names in JSON
        case age
        case gender
    }
}


//MARK: Encoding/Decoding Nested JSON data

class Aisle: NSObject, Codable
{
    var name:String = ""
    var shelves:[Shelf] = [Shelf]()
}

class Shelf: NSObject, Codable
{
    var name:String = ""
    var product:[Product] = [Product]()
}

class Product: NSObject, Codable
{
    var name:String = ""
    var points:Int = 0
    var productDescription: String = ""
    var price:Double = 0.0
}

class Supermarket: NSObject, Codable
{
    var name: String    = ""
    var address:String  = ""
    var phone:String    = ""
    var aisles:[Aisle]  = [Aisle]()
}


//MARK: Merging the multiple nesting level while encoding and decoding

struct PhotoSize:Codable
{
    var height: Double
    var width: Double
}
class Photo: NSObject, Codable
{
    var name: String        = ""
    var url: URL?           = nil
    var size:PhotoSize?     = nil
}

/*
 When you encode it to JSON, you will get something like:
 {
     "name":"Some Image",
     "url":"www.someurl.com/someimage.jpg",
     "size":{
         "width":200,
         "height":100
         }
 }
 
 But actually you want to to be something like:
 
 {
     "name":"Some Image",
     "url":"www.someurl.com/someimage.jpg",
     "width":200,
     "height":100
 }
 
 Lets update our Photo class as below:
 
 class Photo: NSObject, Codable
 {
     var name: String        = ""
     var url: URL?           = nil
     var size:PhotoSize?     = nil
 
     enum CodingKeys:String,CodingKey
     {
         case name
         case url
         case height
         case width
     }
 }
 
 Notice that CodingKeys enum includes height and width enum values rather than Size as we were following till now.
 Now, You need to implement encode(to:) and init(from:) methods of Encodable and Decodable protocols explicitly in your class:
 
 class Photo: NSObject, Codable
 {
     //Consider remaining class properties and CodingKey enum to be declared as above
     func encode(to encoder: Encoder) throws
     {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(name, forKey: .name)
         try container.encode(url, forKey: .url)
         try container.encode(size.width, forKey: .width)
         try container.encode(size.height, forKey: .height)
     }
 
     override init() {
 
     }
 
     convenience required init(from decoder: Decoder) throws
     {
         self.init()
         let values = try decoder.container(keyedBy: CodingKeys.self)
         name = try values.decode(String.self, forKey: .name)
         url = try values.decode(URL.self, forKey: .url)
         let width = try values.decode(Double.self, forKey: .width)
         let height = try values.decode(Double.self, forKey: .height)
         size = PhotoSize(height: height, width: width)
     }
 }
 
 */
