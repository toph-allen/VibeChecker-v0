//
//  ITunesImporter.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 6/8/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Cocoa
import Foundation
import iTunesLibrary
import CoreData


enum ImportError: Error {
    case moreThanOne(iTunesPersistentID: String)
}

enum ContainerCreationError: Error {
    case mismatchedPlaylistKind
    case calledOnAbstractParent
}


class ITunesImporter {
    var library = ITLibraryInterface()
    var moc: NSManagedObjectContext
    
    init(_ moc: NSManagedObjectContext) {
        self.moc = moc
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    
    func createContainerSubclass(from source: ITLibPlaylist) throws -> Container? {
        print("Creating container for: \(source.name)")
        var newContainer: Container?
        switch source.kind {
        case .genius, .geniusMix, .smart:
            print("Skipping container creation for \(source.name)")
            return nil
        case .folder:
            print("This is a folder.")
            try newContainer = createFolder(from: source)
        case .regular:
            if library.vibeFolderInAncestors(of: source) {
                print("This is a vibe.")
                try newContainer = createVibe(from: source)
            } else {
                print("This is a playlist.")
                try newContainer = createPlaylist(from: source)
            }
        default:
            fatalError("Unknown ITLibPlaylistKind type.")
        }
        
        guard newContainer != nil else {
            print("Failed to create container for \(source.name)")
            return nil
        }
        
        // Getting an item's Folder here so we can look up with libraryInterface
        var parent: Folder?
        if let sourceParent = library.parentPlaylist(of: source) {
            print("This playlist has a parent.")
            parent = try! createContainerSubclass(from: sourceParent) as! Folder?
            print("Parent's name is \(String(describing: parent?.name)).")
            newContainer!.parent = parent
        }
        
        return newContainer
    }
    
    
    // MARK: Container creation
    
    func createFolder(from source: ITLibPlaylist) throws -> Folder {
        print("in createFolder()")
        let folder = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: moc) as! Folder
        
        guard source.kind == .folder else {
            throw ContainerCreationError.mismatchedPlaylistKind
        }
        
        print(source.distinguishedKind.rawValue)
        
        folder.iTunesPersistentID = source.persistentID.stringValue
        folder.name = source.name
        folder.id = UUID.init()
        
        return folder
    }
    
    func createPlaylist(from source: ITLibPlaylist) throws -> Playlist {
        print("in createPlaylist()")
        let playlist = NSEntityDescription.insertNewObject(forEntityName: "Playlist", into: moc) as! Playlist
        
        guard source.kind == .regular else {
            throw ContainerCreationError.mismatchedPlaylistKind
        }
        
        print(source.distinguishedKind.rawValue)
        
        playlist.iTunesPersistentID = source.persistentID.stringValue
        playlist.name = source.name
        playlist.id = UUID.init()
        
//        Get tracks for playlist
//        FIXME: This is really slow and super inefficient
        
        var order: Int64 = 0
        for sourceTrack in source.items {
            let track = createTrack(from: sourceTrack)

            let playlistTrack = NSEntityDescription.insertNewObject(forEntityName: "PlaylistTrack", into: moc) as! PlaylistTrack
            playlistTrack.playlist = playlist
            playlistTrack.track = track
            playlistTrack.order = order

            order += 1
        }
        
        return playlist
    }
    
    func createVibe(from source: ITLibPlaylist) throws -> Vibe {
        print("in createVibe()")
        let vibe = NSEntityDescription.insertNewObject(forEntityName: "Vibe", into: moc) as! Vibe
        
        guard source.kind == .regular else {
            throw ContainerCreationError.mismatchedPlaylistKind
        }
        
        print("Creating playlist from \(source.name)")
        print(source.distinguishedKind.rawValue)
        
        vibe.iTunesPersistentID = source.persistentID.stringValue
        vibe.name = source.name
        vibe.id = UUID.init()
        
        // Get tracks for vibe
        
        for sourceTrack in source.items {
            let track = createTrack(from: sourceTrack)
            vibe.addToTracks(track)
        }
        
        return vibe
    }
    
    func createTrack(from source: ITLibMediaItem) -> Track {
        let track = NSEntityDescription.insertNewObject(forEntityName: "Track", into: moc) as! Track
        print("Creating track from \(source.title)")
        track.addedDate = source.addedDate
        track.artistName = source.artist?.name
        track.albumTitle = source.album.title
        track.title = source.title
        track.beatsPerMinute = Int64(source.beatsPerMinute)
        track.id = UUID.init()
        track.iTunesPersistentID = source.persistentID.uint64String
        if source.locationType == ITLibMediaItemLocationType.file {
            track.location = source.location
        }
        track.title = source.title
        track.trackNumber = Int64(source.trackNumber)
        return track
    }
    
    
    
    
    
//    func createOrFetchContainer(for source: ITLibPlaylist) throws -> Container? {
//        if let existingContainer = try! Container.forITunesPlaylist(source, in: moc) {
//            return existingContainer
//        } else {
//            return try! createContainerSubclass(for: source)
//        }
//    }
//
//
//    func createOrFetchTrack(for source: ITLibMediaItem) throws -> Track? {
//        if let existingTrack = try! Track.forITunesMediaItem(source, in: moc) {
//            return existingTrack
//        } else {
//            return createTrack(from: source)
//        }
//    }
    
    
    func importITunesPlaylists() {
        for playlist in library.allPlaylists {
            _ = try! createContainerSubclass(from: playlist)
        }
        try! moc.save()
    }
    
    
    func importITunesTracks() {
        for track in library.allTracks {
            _ = try! createTrack(from: track)
        }
        try! moc.save()
    }
    
    
    func importITunesLibrary() -> Void {
        // This should only run if the library's empty. We could also check for existence every time we try to create.
        importITunesTracks()
        importITunesPlaylists()
        try! moc.save()
    }
}

func importEverything() -> Void {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    let importer = ITunesImporter(moc)
    importer.importITunesLibrary()
}

//        let entityType: Container.Type
//        switch source.kind {
//        case .genius, .geniusMix, .smart:
//            return nil
//        case .folder:
//            entityType = Folder.self
//        case .regular:
//            if libraryInterface.vibeFolderInAncestors(of: source) {
//                entityType = Vibe.self
//            } else {
//                entityType = Playlist.self
//            }
//        default:
//            fatalError("Unknown ITLibPlaylistKind type")
//        }
////        let entityName: String = entityType.entity().name!
//        let entityName = String(describing: entityType)
//        print(entityName)

//        let newContainer: entityType
//        do {
//            newContainer = try entityType.createFromITunesMediaItem(source, into: moc)
//        } catch ContainerCreationError.calledOnAbstractParent {
//            print("ERROR: CREATION METHOD CALLED ON ABSTRACT PARENT.")
//        } catch ContainerCreationError.mismatchedPlaylistKind {
//            print("ERROR: MISMATCHED PLAYLIST KIND.")
//        } catch {
//            print("Unexpected error: \(error).")
//        }
//
//        return newContainer
