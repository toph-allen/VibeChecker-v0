//
//  ImportFromITunes.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/30/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import iTunesLibrary
import CoreData

// This function should add all songs in the iTunesLibrary to the Core Data object.
func importITunesTracks() -> Void {
    @Environment(\.managedObjectContext) let moc

    let library: ITLibrary
        
    do {
        try library = ITLibrary(apiVersion: "1.0")
    } catch {
        print("Could not load Music library")
        return
    }
    
    let songs = library.allMediaItems.filter {$0.mediaKind == ITLibMediaItemMediaKind.kindSong}
    
    for song in songs {
        Track.createFromiTunesMediaItem(from: song, in: moc)
    }
}
