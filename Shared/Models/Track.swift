//
//  Track.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 5/18/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import RealmSwift
import iTunesLibrary

class Track: Object {
    @objc dynamic var id = UUID().uuidString
    
    // Core metadata
    @objc dynamic var title: String = ""
    @objc dynamic var artist: String? = nil
    @objc dynamic var album: String? = nil
    let trackNumber = RealmOptional<Int>()
    
    // Files and corresponding objects
    @objc dynamic var location: URL? = nil
    @objc dynamic var iTunesPersistentID: String? = nil
    
    // Other metadata
    @objc dynamic var addedDate: Date? = nil
    var beatsPerMinute = RealmOptional<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(title: String, artist: String? = nil, album: String? = nil) {
        self.init()
        self.title = title
        self.artist = artist
        self.album = album
    }
    
    convenience init(_ source: ITLibMediaItem) {
        self.init()
        self.title = source.title
        self.artist = source.artist?.name
        self.album = source.album.title
        self.trackNumber.value = source.trackNumber
        self.location = source.location
        self.iTunesPersistentID = source.persistentID.stringValue
    }
}


/// `Track.forITunesTrack()` returns the VibeChecker Track object that corresponds to a given ITLibMediaItem, creating it if it does not exist.
extension Track {
    class func forITunesTrack(_ source: ITLibMediaItem, in realm: Realm) -> Track {
        let predicate = NSPredicate(format: "iTunesPersistentID == %@", source.persistentID)
        let existingTracks = realm.objects(Track.self).filter(predicate)
        
        let track: Track
        switch existingTracks.count {
        case 0:
            // TODO May need extra code here to actually save it.
            track = Track.init(source)
            realm.add(track)
            return Track.init(source)
        case 1:
            track = existingTracks[0]
        default:
            print("Found more than one track for iTunes track \(source.title)")
            track = existingTracks[0]
        }
        return track
    }
}
