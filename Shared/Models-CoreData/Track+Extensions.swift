//
//  Track.swift
//  VibeChecker
//
//  Created by Toph Allen on 3/27/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import CoreData
import iTunesLibrary

// TODO: Make this only import tracks that are in my library, rather than in any playlist I've saved too.

extension Track: Identifiable {
    class func createFromiTunesMediaItem(from source: ITLibMediaItem, in moc: NSManagedObjectContext) -> Track {
        let track = NSEntityDescription.insertNewObject(forEntityName: "Track", into: moc) as! Track
        print("Creating track from \(source.title)")
        track.addedDate = source.addedDate
        track.artistName = source.artist?.name
        track.albumTitle = source.album.title
        track.title = source.title
        track.beatsPerMinute = Int64(source.beatsPerMinute)
        track.id = UUID.init()
        track.iTunesPersistentID = source.persistentID.int64Value
        if source.locationType == ITLibMediaItemLocationType.file {
            track.location = source.location
        }
        track.title = source.title
        track.trackNumber = Int64(source.trackNumber)
        return track
    }
}
