//
//  Facade.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 17/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 
 Facade: simplifies the use of complex APIs, by providing a higher-level, simplified interface
 
 Motivation:
 Simplifies the interface
 - The facade class provides one straightforward interface
 - May wrap a single or multiple classes
 - Subsystem classes can still be accessed for lower-level functionality
 */

enum DownloaderError: Error {
  case fileCopyError
}

extension DownloaderError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .fileCopyError:
        return NSLocalizedString("File copy error!", comment: "")
    }
  }
}

struct Downloader {
  private static let session = URLSession(configuration: URLSessionConfiguration.default)
  private static let syncDownloadToFileQueue = DispatchQueue(label: "Downloader.downloadToFile.syncQueue")
  
  public static func download(from url: URL, to localURL: URL, completionHandler: @escaping (URLResponse?, Error?)->Void) {
    
    syncDownloadToFileQueue.sync {
      
        let request = URLRequest(url: url)
      
        let downloadTask = session.downloadTask(with: request) { (tempURL, response, error) in
          
          guard error == nil else {
            print("Failed to download")
            completionHandler(response, error)
            return
          }
          
          if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            print("Download successful ")
          }
          
          if let tempLocalURL = tempURL {
            do {
              if let fileExists = try? localURL.checkResourceIsReachable() {
                if fileExists {
                   print("Warning! File exists ")
                  
                  do {
                     try FileManager.default.removeItem(at: localURL)
                  }catch let deleteError {
                    print("Faile delete file")
                    completionHandler(response, deleteError)
                  }
                }
              }
              
              try FileManager.default.copyItem(at: tempLocalURL, to: localURL)
              completionHandler(response, nil)
            } catch let copyError {
              print("Error copying file")
              completionHandler(response, copyError)
            }
          } else {
            completionHandler(response, DownloaderError.fileCopyError)
          }
        }
      
        downloadTask.resume()
    }
  }
}

