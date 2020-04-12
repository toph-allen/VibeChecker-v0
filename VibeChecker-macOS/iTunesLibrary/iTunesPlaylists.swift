//
//  ImportFromITunes.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 3/30/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Cocoa
import Foundation
import iTunesLibrary
import CoreData


func importITunesPlaylists() -> Void {
    print("Trying to import playlists from iTunes...")
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    
    let allPlaylistsRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
    var playlistCount: Int
    
    do {
        try playlistCount = moc.count(for: allPlaylistsRequest)
    } catch {
        print("Could not count playlists.")
        playlistCount = 0
    }
    
    guard playlistCount == 0 else {
        print("There are already \(playlistCount) playlists in VibeChecker's library. Not importing from Music.")
        return
    }
    
    // Import tracks from iTunes library.
    let library: ITLibrary
    
    do {
        try library = ITLibrary(apiVersion: "1.0")
    } catch {
        print("Music library not available.")
        return
    }
    
    // TODO: This should look only at items in the master library playlist, not use the allMediaItems query, because that query also includes tracks which are in saved playlists but not saved to the library.
    let iTunesPlaylists = library.allPlaylists.filter {$0.isVisible == true}
    
    for playlist in iTunesPlaylists {
        _ = Playlist.createFromiTunesMediaItem(from: playlist, in: moc)
    }
    
    do {
        try moc.save()
        print("Saved library.")
    } catch {
        print("Could not import library.")
    }
    
    let tracks = try! moc.fetch(allPlaylistsRequest)
    
    print(tracks.count)
}



// This version doesn't update the view but does delete things
func deleteITunesPlaylists() -> Void {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    
    let allPlaylistsRequest: NSFetchRequest<NSFetchRequestResult> = Playlist.fetchRequest()
    
    // Create Batch Delete Request
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: allPlaylistsRequest)
    
    do {
        try moc.execute(batchDeleteRequest)
        try moc.save()
    } catch {
        print("Could not delete playlists.")
    }
}

