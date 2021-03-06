//
//  Document.swift
//  VocalTextEdit
//
//  Created by Brigitte Michau on 2016/03/09.
//  Copyright © 2016 BigNerdRanch. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    var contents: String = ""
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        
        let viewController = windowController.contentViewController as! ViewController
        viewController.contents = contents
        
        self.addWindowController(windowController)
    }
    
    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        
        let windowController = windowControllers[0]
        let viewController = windowController.contentViewController as! ViewController
        
        let contents = viewController.contents ?? ""
        
        if let data = contents.dataUsingEncoding(NSUTF8StringEncoding) {
            return data
        } else {
            let userInfo = [
                NSLocalizedRecoverySuggestionErrorKey: "File cannot be encoded with UTF-8"
            ]
            throw NSError(domain: "com.bignerdranch.VocalTextEdit",
                code: 0,
                userInfo: userInfo)
        }
        
        
        
    }
    
    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        
        if let contents = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
            self.contents = contents
        } else {
            let userInfo = [
                NSLocalizedRecoverySuggestionErrorKey : "File is not valid UTF-8"
            ]
            throw NSError(domain: "com.bignerdranch",
                code: 0,
                userInfo: userInfo)
        }
        
    }
}

