//
//  Bridge.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 17/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 
 Bridge: separates the abstraction from its implementation and reduces the impact of changes.
 
 Exploding class hierarchy
 - Sign of poorly designed/refactored code
 
 Separate abstraction from implemetation
 - Organize common and specific functionality into different hierarchies.
 - Allows changing abstraction and implementation independently
 */

protocol Messaging {
  func send(message: String, completionHandler: @escaping (Error?)-> Void)
}

class QuickMessanger: Messaging {
  func send(message: String, completionHandler: @escaping (Error?) -> Void) {
    print("Message \"\(message)\" sent via QuickMessanger")
    completionHandler(nil)
  }
}

class VIPMessanger: Messaging {
  func send(message: String, completionHandler: @escaping (Error?) -> Void) {
    print("Message \"\(message)\" sent via VIPMessanger")
    completionHandler(nil)
  }
}

class SecureQuickMessanger: QuickMessanger {
  private func encrype(message: String, key: UInt8) -> String {
    return String(describing: message.utf8.map{$0 ^ key})
  }
  
  public override func send(message: String, completionHandler: @escaping (Error?) -> Void) {
    let secure = self.encrype(message: message, key: 0xcc)
    super.send(message: secure, completionHandler: completionHandler)
  }
}

class SecureVIPMessanger: VIPMessanger {
  private func encrype(message: String, key: UInt8) -> String {
    return String(describing: message.utf8.map{$0 ^ key})
  }
  
  public override func send(message: String, completionHandler: @escaping (Error?) -> Void) {
    let secure = self.encrype(message: message, key: 0xcc)
    super.send(message: secure, completionHandler: completionHandler)
  }
}

class SelfDestructingQuickMessenger: QuickMessanger {
  override func send(message: String, completionHandler: @escaping (Error?) -> Void) {
      let selfDestructingMessage = "👻" + message
      super.send(message: selfDestructingMessage, completionHandler: completionHandler)
  }
}

class SelfDestructingVIPMessenger: VIPMessanger {
  override func send(message: String, completionHandler: @escaping (Error?) -> Void) {
    let selfDestructingMessage = "👽" + message
    super.send(message: selfDestructingMessage, completionHandler: completionHandler)
  }
}

// If we want to add another Messenger
// As following code, we have to adding more classes if the reqirements come.
// This is problem bridge pattern can solove!

class EZMessanger: Messaging {
  func send(message: String, completionHandler: @escaping (Error?) -> Void) {
    print("Message \"\(message)\" sent via EZMessanger")
    completionHandler(nil)
  }
}

class SecureEZMessanger: EZMessanger {
  private func encrype(message: String, key: UInt8) -> String {
    return String(describing: message.utf8.map{$0 ^ key})
  }
  
  public override func send(message: String, completionHandler: @escaping (Error?) -> Void) {
    let secure = self.encrype(message: message, key: 0xcc)
    super.send(message: secure, completionHandler: completionHandler)
  }
}

class SelfDestructingEZMessenger: EZMessanger {
  override func send(message: String, completionHandler: @escaping (Error?) -> Void) {
    let selfDestructingMessage = "🤡" + message
    super.send(message: selfDestructingMessage, completionHandler: completionHandler)
  }
}

//MARK: Applying Bridge pattern

protocol MessageHandling {
  func modify(message: String) -> String
}

protocol MessageSending {
  func send(messangeHandler: MessageHandling, message: String, completionHandler: @escaping (Error?)->Void)
}

class PlainMessageHandler: MessageHandling {
  func modify(message: String) -> String {
    return message
  }
}

class SecureMessageHandler: MessageHandling {
  private func encrype(message: String, key: UInt8) ->String {
    return String(describing: message.utf8.map{$0 ^ key})
  }
  
  func modify(message: String) -> String {
    return encrype(message: message, key: 0xcc)
  }
}

class SelfDestructingMessageHandler: MessageHandling {
  func modify(message: String) -> String {
    return "👻" + message
  }
}

class QuickMessageSender: MessageSending {
  func send(messangeHandler: MessageHandling, message: String, completionHandler: @escaping (Error?) -> Void) {
    let modifiedMessage = messangeHandler.modify(message: message)
    print("Message \"\(modifiedMessage)\" sent via QuickMessanger")
    completionHandler(nil)
  }
}

class VIPMessageSender: MessageSending {
  func send(messangeHandler: MessageHandling, message: String, completionHandler: @escaping (Error?) -> Void) {
    let modifiedMessage = messangeHandler.modify(message: message)
    print("Message \"\(modifiedMessage)\" sent via VIPMessanger")
    completionHandler(nil)
  }
}

class EZMessageSender: MessageSending {
  func send(messangeHandler: MessageHandling, message: String, completionHandler: @escaping (Error?) -> Void) {
    let modifiedMessage = messangeHandler.modify(message: message)
    print("Message \"\(modifiedMessage)\" sent via EZMessanger")
    completionHandler(nil)
  }
}

fileprivate func Sample() {
  let message = "the brige pattern is cool"
  
  let quickMessageSender = QuickMessageSender()
  quickMessageSender.send(messangeHandler: PlainMessageHandler(), message: message) { (error) in
    guard error == nil else {
      print("Could not send message")
      return
    }
  }

  quickMessageSender.send(messangeHandler: SecureMessageHandler(), message: message) { (error) in
    guard error == nil else {
      print("Could not send message")
      return
    }
  }
}
