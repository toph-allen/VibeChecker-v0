//
//  iTunesLibrary+Extensions.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 6/4/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import iTunesLibrary
import CoreData

extension NSNumber {
    var uint64String: String {
        return String(format: "%llX", self.uint64Value)
    }
}

/// This class gives access to the iTunes Library. Specifically, it lets you access playlists by their ID in a hash table, which is much faster than filtering the list of playlists each time we want to look one up by ID.
class ITLibraryInterface {
    let library: ITLibrary
    let vibeFolder: ITLibPlaylist // Can be deleted if there's another way of determining which playlists are vibes. It's here because otherwise it would have to be determined on the fly each time, which qould require filtering the playlist library each
    let allPlaylists: [ITLibPlaylist]
    let allTracks: [ITLibMediaItem]
    var playlistsByID: [String: ITLibPlaylist] = [:]
    var tracksByID: [String: ITLibMediaItem] = [:]
    
    init() {
        library = try! ITLibrary(apiVersion: "1.0")
        vibeFolder = library.allPlaylists.filter { $0.name == "2. Vibes" }[0]
        
        allPlaylists = library.allPlaylists.filter {$0.isVisible == true && $0.isMaster == false && $0.distinguishedKind == ITLibDistinguishedPlaylistKind.kindNone}
        allTracks = library.allMediaItems.filter {$0.mediaKind == ITLibMediaItemMediaKind.kindSong}

        for playlist in allPlaylists {
            playlistsByID[playlist.persistentID.uint64String] = playlist
        }
        for track in allTracks.filter({$0.mediaKind == ITLibMediaItemMediaKind.kindSong}) {
            tracksByID[track.persistentID.uint64String] = track
        }
    }
    
    func parentPlaylist(of playlist: ITLibPlaylist) -> ITLibPlaylist? {
        guard playlist.parentID != nil else {
            return nil
        }
        return self.playlistsByID[playlist.parentID!.uint64String]
    }
    
    func ancestorPlaylists(of playlist: ITLibPlaylist) -> [ITLibPlaylist] {
        var ancestors: [ITLibPlaylist] = []
        if let parent = parentPlaylist(of: playlist) {
            ancestors.append(parent)
            ancestors.append(contentsOf: ancestorPlaylists(of: parent))
        }
        return ancestors
    }
    
    func vibeFolderInAncestors(of playlist: ITLibPlaylist) -> Bool {
        return ancestorPlaylists(of: playlist).contains(vibeFolder)
    }
    
    func associatedITunesPlaylist(for container: Container) -> ITLibPlaylist? {
        if let id = container.iTunesPersistentID {
            return self.playlistsByID[id]
        } else {
            return nil
        }
    }
    
    func associatedITunesTrack(for track: Track) -> ITLibMediaItem? {
        if let id = track.iTunesPersistentID {
            return self.tracksByID[id]
        } else {
            return nil
        }
    }
}
