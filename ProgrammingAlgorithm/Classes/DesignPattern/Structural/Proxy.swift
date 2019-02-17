//
//  Proxy.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 17/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

/*
 Proxy: provides a placeholder for another object to control the way the underlying resource is accessed.
 
 Motivation
 Control object access
 - Define a proxy which references an underlying resource
 - Cinets use the proxy (not the real object)
 - The proxy forwards and adapts client requests
 
 Proxy types:
 - Remote proxy
 - Virtual Proxy: can be used to minimize the cost of creating expensive objects.
 - Protective Proxy
 */

//MARK: Remote proxy

protocol RemoteData {
  func data(url: URL, completionHandler: @escaping(Error?, Data?)->Void) -> RemoteData
  func run()
}

class RemoteDataProxy: RemoteData {
  
  private var callBack: ((Error?, Data?)->Void)?
  private var url: URL?
  
  func data(url: URL, completionHandler: @escaping (Error?, Data?) -> Void) -> RemoteData {
    self.url = url
    self.callBack = completionHandler
    return self
  }
  
  func run() {
    if let callback = self.callBack, let url = self.url {
      
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else {
          print("Error")
          callback(error, nil)
          return
        }
        // success
        callback(nil, data)
      }.resume()
    }else {
      print("run called before invoking data(url: completionHandler)")
    }
  }
}

fileprivate func remoteSample() {
  
  guard let dataURL = URL(string: "https://dev.test") else {
    fatalError("cannot create url")
  }
  
  // NO network calls involved at this point
  let dataProxy = RemoteDataProxy().data(url: dataURL) { (error, data) in
    guard error == nil else {
      // error
      return
    }
    print("Success")
  }
  
  dataProxy.run()
}


// MARK: Virtual Proxy
protocol  RemoteImage: CustomStringConvertible {
  init(url: URL)
  var image: UIImage? {get}
  var url: URL {get}
  var hasContent: Bool {get}
}

class ImageProxy: RemoteImage {
  required init(url: URL) {
    self.url = url
  }
  // this image only inital once
  lazy var image: UIImage? = { [unowned self] in
    var result: UIImage?
    if let img = try? UIImage(data: Data(contentsOf: self.url)) {
      result = img
      self.hasContent = true
    }
    return result
  }()
  
  var url: URL
  var hasContent: Bool = false
}

// use extensions allow us to define behavior on the protocol itself rather than in each confroming type.
extension RemoteImage {
  var description: String {
    let description = hasContent ? "Image Availabel" : "No Image"
    return description
  }
}


fileprivate func virtualSample() {
  guard let imageUrl = URL(string: "test") else {
    fatalError("")
  }
  let imageProxy = ImageProxy(url: imageUrl)
  print(imageProxy)
}


//MARK: Protective Proxy

protocol Authenticating {
  var isAuthenticated: Bool {get}
  func authenticate(user: String)->Bool
}

class Authenticator: Authenticating {
  var isAuthenticated: Bool = false
  private let userWhiteList = ["John", "Mary", "Steve"]
  private let syncQueue = DispatchQueue(label: "com.leakka.authQueue")
  static let shared = Authenticator()
  
  func authenticate(user: String) -> Bool {
    var result = false
    syncQueue.sync {
      result = userWhiteList.contains(user)
    }
    isAuthenticated = result
    return result
  }
}

class SecureImageProxy: RemoteImage {
  var url: URL
  var hasContent: Bool = false
  private lazy var imageProxy: ImageProxy = ImageProxy(url: self.url)
  
  required init(url: URL) {
    self.url = url
  }
  
  var image: UIImage? {
    get {
      return Authenticator.shared.isAuthenticated ? self.imageProxy.image: nil
    }
  }
}

fileprivate func protectiveSample () {
  guard let imageUrl = URL(string: "test") else {
    fatalError("")
  }
  let secureImageProxy = SecureImageProxy(url: imageUrl)
  print(secureImageProxy)
  
  Authenticator.shared.authenticate(user: "Jim")
  if let image = secureImageProxy.image {
    // has image
  }
}
