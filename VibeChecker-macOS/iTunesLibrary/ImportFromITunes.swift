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

// This function should add all songs in the iTunesLibrary to the Core Data moc.
func importITunesTracks() -> Void {
    print("Trying to import tracks from iTunes")
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    
    let allTracksRequest: NSFetchRequest<Track> = Track.fetchRequest()
    var trackCount: Int
    
    do {
        try trackCount = moc.count(for: allTracksRequest)
    } catch {
        print("Could not count tracks.")
        trackCount = 0
    }
    
    guard trackCount == 0 else {
        print("There are already \(trackCount) tracks in VibeChecker's library. Not importing from Music.")
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
    let iTunesSongs = library.allMediaItems.filter {$0.mediaKind == ITLibMediaItemMediaKind.kindSong}
    
    for song in iTunesSongs {
        _ = Track.createFromiTunesMediaItem(from: song, in: moc)
    }
    
    do {
        try moc.save()
        print("Saved library.")
    } catch {
        print("Could not import library.")
    }
    
    let tracks = try! moc.fetch(allTracksRequest)
    
    print(tracks.count)
}


func importITunesPlaylists() -> Void {
    print("Trying to import playlists from iTunes")
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
    
    for song in iTunesPlaylists {
        _ = Playlist.createFromiTunesMediaItem(from: song, in: moc)
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

