//
//  iTunesLibraryObjects.swift
//  VibeChecker
//
//  Created by Toph Allen on 3/23/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Cocoa
import iTunesLibrary

func testiTunes() -> String {
    let library: ITLibrary
    
    do {
        try library = ITLibrary(apiVersion: "1.0")
    } catch {
        print("Could not load Music library")
        return "Error!"
    }
    
    let returnString = "Music.app version: \(library.applicationVersion)"
    
    return returnString
}
