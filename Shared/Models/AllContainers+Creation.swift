//
//  Playlist.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 4/6/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import CoreData
import iTunesLibrary

enum ContainerCreationError: Error {
    case mismatchedPlaylistKind
    case calledOnAbstractParent
}


extension Container {
    @objc class func createFromITunesPlaylist(_ source: ITLibPlaylist, into moc: NSManagedObjectContext) throws -> Container {
        print("ERROR: TRYING TO CREATE ABSTRACT PARENT CLASS.")
        throw ContainerCreationError.calledOnAbstractParent
    }
}


extension Folder {
    @objc override class func createFromITunesPlaylist(_ source: ITLibPlaylist, into moc: NSManagedObjectContext) throws -> Folder {
        let folder = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: moc) as! Folder
        
        guard source.kind == .folder else {
            throw ContainerCreationError.mismatchedPlaylistKind
        }
        
        print("Creating folder from \(source.name)")
        print(source.distinguishedKind.rawValue)
        
        folder.iTunesPersistentID = source.persistentID.stringValue
        folder.name = source.name
        folder.id = UUID.init()
        
        return folder
    }
}


extension Playlist {
    @objc override class func createFromITunesPlaylist(_ source: ITLibPlaylist, into moc: NSManagedObjectContext) throws -> Playlist {
        let playlist = NSEntityDescription.insertNewObject(forEntityName: "Playlist", into: moc) as! Playlist
        
        guard source.kind == .regular else {
            throw ContainerCreationError.mismatchedPlaylistKind
        }
        
        print("Creating playlist from \(source.name)")
        print(source.distinguishedKind.rawValue)
        
        playlist.iTunesPersistentID = source.persistentID.stringValue
        playlist.name = source.name
        playlist.id = UUID.init()
        
        // MARK: Get tracks for playlist
        // FIXME: This is really slow and super inefficient
        var order: Int64 = 0
        
        for sourceTrack in source.items {
            var track = try! Track.forITunesMediaItem(sourceTrack, in: moc)
            if track == nil {
                track = Track.createFromITunesMediaItem(sourceTrack, in: moc)
            }
            
            let playlistTrack = NSEntityDescription.insertNewObject(forEntityName: "PlaylistTrack", into: moc) as! PlaylistTrack
            playlistTrack.playlist = playlist
            playlistTrack.track = track
            playlistTrack.order = order
            
            order += 1
        }

        return playlist
    }
}


extension Vibe {
    @objc override class func createFromITunesPlaylist(_ source: ITLibPlaylist, into moc: NSManagedObjectContext) throws -> Vibe {
        let vibe = NSEntityDescription.insertNewObject(forEntityName: "Vibe", into: moc) as! Vibe
        
        guard source.kind == .regular else {
            throw ContainerCreationError.mismatchedPlaylistKind
        }
        
        print("Creating playlist from \(source.name)")
        print(source.distinguishedKind.rawValue)
        
        vibe.iTunesPersistentID = source.persistentID.stringValue
        vibe.name = source.name
        vibe.id = UUID.init()
        
        // MARK: Get tracks for vibe

        for sourceTrack in source.items {
            var track = try! Track.forITunesMediaItem(sourceTrack, in: moc)
            if track == nil {
                track = Track.createFromITunesMediaItem(sourceTrack, in: moc)
            }
            
            vibe.addToTracks(track!)
        }
        
        return vibe
    }
}


