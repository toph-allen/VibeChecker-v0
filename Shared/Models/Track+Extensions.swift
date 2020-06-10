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

extension Track {
    class func createFromITunesMediaItem(_ source: ITLibMediaItem, in moc: NSManagedObjectContext) -> Track? {
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
}

extension Track {
    /// Returns the track for a given iTunes object.
    class func forITunesPersistentID(_ persistentID: String, in moc: NSManagedObjectContext) throws -> Track? {
        let request: NSFetchRequest<NSFetchRequestResult> = fetchRequest()
        request.predicate = NSPredicate(format: "iTunesPersistentID == %@", persistentID)
        
        do {
            let results = try moc.fetch(request) as! [Track]
            guard results.count == 1 else {
                if results.count > 1 {
                    throw FetchError.moreThanOne(iTunesPersistentID: persistentID)
                } else { // results.count == 0
                    return nil
                }
            }
            return results.first
        }
    }
    
    class func forITunesMediaItem(_ mediaItem: ITLibMediaItem, in moc: NSManagedObjectContext) throws -> Track? {
        return try forITunesPersistentID(mediaItem.persistentID.uint64String, in: moc)
    }
}

