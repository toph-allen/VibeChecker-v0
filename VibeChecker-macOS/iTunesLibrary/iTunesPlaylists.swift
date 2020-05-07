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
    
    // Import tracks from iTunes library.
    let library: ITLibrary
    
    do {
        try library = ITLibrary(apiVersion: "1.0")
    } catch {
        print("Music library not available.")
        return
    }
    
    // TODO: This should look only at items in the master library playlist, not use the allMediaItems query, because that query also includes tracks which are in saved playlists but not saved to the library.
    // We import Smart Playlists but we don't give them tracks (handled elsewhere).
    let iTunesPlaylists = library.allPlaylists.filter {$0.isVisible == true && $0.isMaster == false && $0.distinguishedKind == ITLibDistinguishedPlaylistKind.kindNone}
    
    for playlist in iTunesPlaylists {
        _ = Playlist.forITunesPlaylist(playlist, in: moc)
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



func addParentsToPlaylists() -> Void {
    print("Trying to import playlists from iTunes...")
    
    // Set up playlists
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    
    let playlists: [Playlist]?
    let allPlaylistsRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
    do {
        playlists = try moc.fetch(allPlaylistsRequest)
    } catch {
        print("Could not find playlists to add parents to.")
        playlists = nil
    }
    
    guard playlists != nil else {
        print("Could not find any playlists.")
        return
    }
    
    for playlist in playlists! {
        let iTunesPlaylist = playlist.associatedITunesPlaylist
        print("Getting parent playlist for \(playlist.name) – iTunesPersistentID: \(playlist.iTunesPersistentID ?? "")")
        if let iTunesParentID = iTunesPlaylist?.parentID?.stringValue {
            playlist.parentPlaylist = Playlist.forITunesPersistentID(iTunesParentID, in: moc)
            print("Parent playlist: \(playlist.parentPlaylist?.name ?? "UNNAMED PARENT") – iTunesPersistentID: \(playlist.parentPlaylist?.iTunesPersistentID ?? "")")
        } else {
            print("Could not find a parent for \(playlist.name).")
            
        }
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
// TODO: This should also delete the relations of that playlist? Unless Core Data is set to do that automatically.
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

