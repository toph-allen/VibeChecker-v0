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

class ITunesImporter {
    var library = ITLibraryInterface()
    
    func createNewContainer(for source: ITLibPlaylist, in moc: NSManagedObjectContext) throws -> Container? {
        var newContainer: Container?
        switch source.kind {
        case .genius, .geniusMix, .smart:
            newContainer = nil
        case .folder:
            try newContainer = Folder.createFromITunesPlaylist(source, into: moc)
        case .regular:
            if library.vibeFolderInAncestors(of: source) {
                newContainer = nil // TODO: Implement Vibe initializer
                //                try newContainer = Vibe.self
            } else {
                try newContainer = Playlist.createFromITunesPlaylist(source, into: moc)
            }
        default:
            fatalError("Unknown ITLibPlaylistKind type.")
        }
        
        // MARK: Getting an item's Folder here so we can look up with libraryInterface
        var parent: Folder?
        if let sourceParent = library.parentPlaylist(of: source) {
            parent = try! Folder.forITunesPlaylist(sourceParent, in: moc)
            if parent == nil {
                parent = try Folder.createFromITunesPlaylist(sourceParent, into: moc)
            }
            newContainer?.parent = parent
        }
        
        return newContainer
    }
    
    
    func createOrFetchContainer(for source: ITLibPlaylist, in moc: NSManagedObjectContext) throws -> Container? {
        if let existingContainer = try! Container.forITunesPlaylist(source, in: moc) {
            return existingContainer
        } else {
            return try! createNewContainer(for: source, in: moc)
        }
    }
    
    
    func createOrFetchTrack(for source: ITLibMediaItem, in moc: NSManagedObjectContext) throws -> Track? {
        if let existingTrack = try! Track.forITunesMediaItem(source, in: moc) {
            return existingTrack
        } else {
            return Track.createFromITunesMediaItem(source, in: moc)
        }
    }
    
    
    func importITunesLibrary(in moc: NSManagedObjectContext) -> Void {
        // This should only run if the library's empty. We could also check for existence every time we try to create.
        for track in library.allTracks {
            _ = try! createOrFetchTrack(for: track, in: moc)
        }
        for playlist in library.allPlaylists {
            _ = try! createOrFetchContainer(for: playlist, in: moc)
        }
        try! moc.save()
    }
}

func importEverything() -> Void {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    let importer = ITunesImporter()
    importer.importITunesLibrary(in: moc)
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
