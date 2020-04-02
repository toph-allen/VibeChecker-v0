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

extension Track {
    class func createFromiTunesMediaItem(from source: ITLibMediaItem, in moc: NSManagedObjectContext) -> Track {
        let track = NSEntityDescription.insertNewObject(forEntityName: "Track", into: moc) as! Track
        track.addedDate = source.addedDate
        track.artistName = source.artist?.name
        track.albumTitle = source.album.title
        track.title = source.title
        track.beatsPerMinute = Int64(source.beatsPerMinute)
        track.id = UUID.init()
        track.iTunesPersistentID = source.persistentID.int64Value
        track.location = source.location
        track.title = source.title
        track.trackNumber = Int64(source.trackNumber)
        return track
    }
}
