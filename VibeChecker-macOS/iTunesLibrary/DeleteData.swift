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


extension NSManagedObjectContext {
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes
    /// to bring the given managed object context up to date.`
    /// Taken from https://www.avanderlee.com/swift/nsbatchdeleterequest-core-data/
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs // Looks like this is saying, for your results, give us the IDs of the objects you deleted
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}


// This version doesn't update the view but does delete things
// TODO: This should also delete the relations of that playlist? Unless Core Data is set to do that automatically.
func deleteContainers() -> Void {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    
    let allContainersFetchRequest: NSFetchRequest<NSFetchRequestResult> = Container.fetchRequest()
    
    // Create Batch Delete Request
    let allContainersBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: allContainersFetchRequest)
    
    do {
//        try moc.execute(allContainersBatchDeleteRequest)
        try moc.executeAndMergeChanges(using: allContainersBatchDeleteRequest)
        try moc.save()
    } catch {
        print("Could not delete playlists.")
    }
    
    let allPlaylistTracksFetchRequest: NSFetchRequest<NSFetchRequestResult> = PlaylistTrack.fetchRequest()
    
    // Create Batch Delete Request
    let allPlaylistTracksBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: allPlaylistTracksFetchRequest)
    
    do {
//        try moc.execute(allPlaylistTracksBatchDeleteRequest)
        try moc.executeAndMergeChanges(using: allPlaylistTracksBatchDeleteRequest)
        try moc.save()
    } catch {
        print("Could not delete playlist track associations.")
    }
}

func deleteTracks() -> Void {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    
    let allTracksRequest: NSFetchRequest<NSFetchRequestResult> = Track.fetchRequest()
    
    // Create Batch Delete Request
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: allTracksRequest)
    
    do {
        try moc.execute(batchDeleteRequest)
        try moc.save()
    } catch {
        print("Could not delete tracks.")
    }
}

func deleteEverything() -> Void {
    deleteContainers()
    deleteTracks()
}

