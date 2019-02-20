//
//  Command.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 20/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

/*
 Command: encapsulates a request into an object. Allows performing requests without knowing the actions or the receiver.
 
 Motivation:
 Encapsulate method invocation
 - Package method invocation and receiver in a command object
 - Decouple request invoker from receiver
 - Support for undoable operations
 - Create macro commands.
 */

protocol Command {
    func execute()
    func undo()
}

protocol EnhancedAnimationCommand: Command {
    
    associatedtype Arguments
    
    var receiver: UIView { get }
    var arguments: Arguments? { get }
    
    init(receiver: UIView, arguments: Arguments?)
}


//Provide default implementation in the protocol extension
extension EnhancedAnimationCommand {
    var arguments: Arguments? { return nil }
}

struct FadeOutCommand: EnhancedAnimationCommand {
    internal let receiver: UIView
    internal let arguments: TimeInterval?
    
    
    init(receiver: UIView, arguments: TimeInterval? = 0.3){ // 300 ms
        self.receiver = receiver
        self.arguments = arguments
    }
    
    func execute() {
        UIView.animate(withDuration: arguments ?? 0.3) {
            self.receiver.alpha = 0 // must done on main thread
        }
    }
    
    func undo() {
        UIView.animate(withDuration: arguments ?? 0.3) {
            self.receiver.alpha = 1
        }
    }
}

struct FadeInCommand: EnhancedAnimationCommand {
    internal let receiver: UIView
    internal let arguments: TimeInterval?
    
    
    init(receiver: UIView, arguments: TimeInterval? = 0.3){ // 300 ms
        self.receiver = receiver
        self.arguments = arguments
    }
    
    func execute() {
        UIView.animate(withDuration: arguments ?? 0.3) {
            self.receiver.alpha = 1 // must done on main thread
        }
    }
    
    func undo() {
        UIView.animate(withDuration: arguments ?? 0.3) {
            self.receiver.alpha = 0 // must done on main thread
        }
    }
}

// This just for demo, not need to do this for animation in real life
class AnimationController {
    private var commandsById = [String : Command]()
    private var undoStack = [Command]()
    
    func setCommand(_ command: Command, id: String) {
        commandsById[id] = command
    }
    
    func performCommand(id: String) {
        guard let command = commandsById[id] else {
            print("No Command Found for \(id)")
            return
        }
        
        undoStack.append(command)
        command.execute()
    }
    
    func undo() {
        guard undoStack.isEmpty == false else {
            return
        }
        
        let lastCommand = undoStack.removeLast()
        lastCommand.undo()
    }
}

fileprivate func animationCommandSample() {
    
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
    view.backgroundColor = .red
    
    let invoker = AnimationController()
    invoker.setCommand(FadeOutCommand(receiver: view),id: "FadeOut")
    invoker.setCommand(FadeInCommand(receiver: view), id: "FadeIn")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        invoker.performCommand(id: "FadeOut")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            invoker.performCommand(id: "FadeIn")
        })
    }
}

//MARK: Macro: run mutiple commands at once

struct ScaleArgs{
    var duration: TimeInterval
    var scale: Float
}

struct ScaleCommand: EnhancedAnimationCommand {
    let receiver: UIView
    let arguments: ScaleArgs?
    
    init(receiver: UIView, arguments: ScaleArgs? = ScaleArgs(duration: 0.3, scale: 1)) {
        self.receiver = receiver
        self.arguments = arguments
    }
    
    func execute() {
        if let scale = arguments?.scale {
            UIView.animate(withDuration: arguments?.duration ?? 0.3) {
                self.receiver.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
            }
        }
    }
    
    func undo() {
        UIView.animate(withDuration: arguments?.duration ?? 0.3) {
            self.receiver.transform = CGAffineTransform(scaleX: CGFloat(0), y: CGFloat(0))
        }
    }
}

struct RotateArgs{
    var duration: TimeInterval
    var degrees: Float
}

struct RotateCommand: EnhancedAnimationCommand {
    let receiver: UIView
    let arguments: RotateArgs?
    
    init(receiver: UIView, arguments: RotateArgs? = RotateArgs(duration: 0.3, degrees: 1)) {
        self.receiver = receiver
        self.arguments = arguments
    }
    
    func execute() {
        if let rotate = arguments?.degrees {
            let angleRadians = CGFloat(rotate * .pi / 180)
            UIView.animate(withDuration: arguments?.duration ?? 0.3) {
                self.receiver.transform = CGAffineTransform(rotationAngle: angleRadians)
            }
        }
    }
    
    func undo() {
        UIView.animate(withDuration: arguments?.duration ?? 0.3) {
            self.receiver.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}

class MacroAnimationCommands {
    private var commands = [Command]()
    
    func addCommands( _ commands: [Command]) {
        self.commands.append(contentsOf: commands)
    }
    
    func execute() {
        for command in commands {
            command.execute()
        }
    }
}

fileprivate func macroAnimationCommands() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
    view.backgroundColor = .red
    
    let scaleUpCommand = ScaleCommand(receiver: view)
    let fadeOutCommand = FadeOutCommand(receiver: view)
    let rotateCommand = RotateCommand(receiver: view)
    
    let macro = MacroAnimationCommands()
    
    macro.addCommands([scaleUpCommand,fadeOutCommand,rotateCommand])
    macro.execute()
}






