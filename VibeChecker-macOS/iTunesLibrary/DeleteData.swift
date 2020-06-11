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


// This version doesn't update the view but does delete things
// TODO: This should also delete the relations of that playlist? Unless Core Data is set to do that automatically.
func deleteContainers() -> Void {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let moc = appDelegate.persistentContainer.viewContext
    
    let allContainersRequest: NSFetchRequest<NSFetchRequestResult> = Container.fetchRequest()
    
    // Create Batch Delete Request
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: allContainersRequest)
    
    do {
        try moc.execute(batchDeleteRequest)
        try moc.save()
    } catch {
        print("Could not delete playlists.")
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

