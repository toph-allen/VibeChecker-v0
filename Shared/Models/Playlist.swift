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


extension Playlist: Identifiable {}


// MARK: PlaylistKind Enum

enum PlaylistKind: Int32 {
    case folder, regular, smart, other
    
    func simpleDescription() -> String {
        switch self {
        case .folder:
            return "folder"
        case .regular:
            return "regular"
        case .smart:
            return "smart"
        case .other:
            return "other"
        }
    }
    
    func imageName() -> String {
        switch self {
        case .folder:
            return "folder"
        default:
            return "music.note.list"
        }
    }
}

extension Playlist {
    var kind: PlaylistKind {
        get { return PlaylistKind(rawValue: self.kindValue) ?? .other }
        set { self.kindValue = newValue.rawValue }
    }
}


// MARK: iTunesLibrary playlists IDs

// This is probably a bad design pattern.
extension Playlist {
    class func forITunesPlaylist(_ iTunesPlaylist: ITLibPlaylist, in moc: NSManagedObjectContext) -> Playlist? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Playlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "iTunesPersistentID == \(iTunesPlaylist.persistentID.stringValue)")

        let result = try! moc.fetch(fetchRequest)

        switch result.count {
        case 0:
            return Playlist.createFromiTunesMediaItem(from: iTunesPlaylist, in: moc)
        case 1:
            print("Found playlist for iTunes playlist \(iTunesPlaylist.name)")
            return (result[0] as! Playlist)
        default:
            // TODO: Reconcile if this error ever occurs
            print("Found multiple playlists for iTunes playlist \(iTunesPlaylist.name)")
            return nil
        }
    }
    
    
    class func forITunesPersistentID(_ iTunesPersistentID: String, in moc: NSManagedObjectContext) -> Playlist? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Playlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "iTunesPersistentID == %@", iTunesPersistentID)
        
        let result = try! moc.fetch(fetchRequest)
        
        switch result.count {
        case 0:
            // TODO: Create a playlist from that ID if one exists?
            print("Could not find a playlist for \(iTunesPersistentID)")
            return nil
        case 1:
            print("Found playlist for iTunes playlist \(iTunesPersistentID)")
            return (result[0] as! Playlist)
        default:
            // TODO: Reconcile if this error ever occurs
            print("Found multiple playlists for iTunes playlist \(iTunesPersistentID)")
            return nil
        }
    }


    var associatedITunesPlaylist: ITLibPlaylist? {
        get {
            if let library = try? ITLibrary(apiVersion: "1.0") {
                let playlist = library.allPlaylists.filter {
                    $0.persistentID.stringValue == iTunesPersistentID
                }
                return playlist[0]
            } else {
                return nil
            }
        }

    }
}

extension Playlist {
    var childList: [Playlist]? {
        get {
            return Array(childPlaylists ?? [])
        }
    }
}




extension Playlist {
    class func createFromiTunesMediaItem(from source: ITLibPlaylist, in moc: NSManagedObjectContext) -> Playlist {
        let playlist = NSEntityDescription.insertNewObject(forEntityName: "Playlist", into: moc) as! Playlist
        
        print("Creating playlist from \(source.name)")
        print(source.distinguishedKind.rawValue)

        switch source.kind {
        case .folder:
            playlist.kind = .folder
        case .regular:
            playlist.kind = .regular
        case .smart:
            playlist.kind = .smart
        default:
            playlist.kind = .other
        }
        playlist.iTunesPersistentID = source.persistentID.stringValue
        playlist.name = source.name
        playlist.id = UUID.init()
        
        // MARK: Get tracks for playlist
        // FIXME: This is really slow and super inefficient
        if playlist.kind == .regular {
            var order = 0
            let trackFetchRequest: NSFetchRequest<Track> = Track.fetchRequest()

            for sourceTrack in source.items {
                var track: Track?

                trackFetchRequest.predicate = NSPredicate(format: "iTunesPersistentID == \(sourceTrack.persistentID.int64Value)")
                let trackArray = try! moc.fetch(trackFetchRequest)
                if trackArray.count != 1 {
                    print("ERROR")
                    print(sourceTrack.title)
                    continue
                } else {
                    track = trackArray[0]
                }
                
                let playlistTrack = NSEntityDescription.insertNewObject(forEntityName: "PlaylistTrack", into: moc) as! PlaylistTrack
                playlistTrack.playlist = playlist
                playlistTrack.track = track
                
                order += 1
            }
            
        }
        return playlist
    }
}


extension Playlist {
    var tracks: [Track] {
        get {
            if let playlistTracks = self.tracksRelationships {
                let tracks = playlistTracks.sorted(by: {
                    $0.order < $1.order
                }).compactMap({ $0.track ?? nil }) as [Track?]
                return tracks.map { $0! }
            } else {
                return []
            }
        }
    }
}


extension Playlist: OutlineRepresentable {
    var children: [Playlist]? {
        return Array(childPlaylists ?? [])
    }
    
    var parent: Playlist? {
        return parentPlaylist
    }
    
    var hasContent: Bool {
        get {
            if self.children == nil {
                return true
            } else {
                return self.children!.count == 0
            }
        }
    }
}


