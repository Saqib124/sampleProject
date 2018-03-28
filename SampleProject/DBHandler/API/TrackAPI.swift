//
//  TrackAPI.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/28/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import Foundation
import CoreData

class TrackAPI {
    fileprivate let persistenceManager: PersistenceManager
    fileprivate var mainContextInstance: NSManagedObjectContext!
    
    fileprivate let artistId       = TrackAttributes.artistId.rawValue
    fileprivate let artistName     = TrackAttributes.artistName.rawValue
    fileprivate let artistViewUrl  = TrackAttributes.artistViewUrl.rawValue
    fileprivate let artworkUrl60   = TrackAttributes.artworkUrl60.rawValue
    fileprivate let collectionName = TrackAttributes.collectionName.rawValue
    fileprivate let id             = TrackAttributes.id.rawValue
    fileprivate let kind           = TrackAttributes.kind.rawValue
    fileprivate let previewUrl     = TrackAttributes.previewUrl.rawValue
    fileprivate let trackId        = TrackAttributes.trackId.rawValue
    fileprivate let trackName      = TrackAttributes.trackName.rawValue
    
    //Utilize Singleton pattern by instanciating EventAPI only once.
    class var sharedInstance: TrackAPI {
        struct Singleton {
            static let instance = TrackAPI()
        }
        return Singleton.instance
    }
    
    init() {
        self.persistenceManager = PersistenceManager.sharedInstance
        self.mainContextInstance = persistenceManager.getMainContextInstance()
    }
    
    
    
    // MARK: Create
    
    /**
     Create a single track and persist it to Datastore,
     that synchronizes with Main context.
     
     - Parameter trackInfo: <Dictionary<String, AnyObject> A single track to be persisted to the Datastore.
     - Returns: Void
     */
    func saveTrackInfo(_ trackInfo: Dictionary<String, AnyObject>) {
        
        let managedObjectContext: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.parent = self.mainContextInstance
        
        //Create new Object of Event entity
        let friend = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.TrackInfo.rawValue,
                                                         into: managedObjectContext) as! TrackInfo
        //Assign field values
        for (key, value) in trackInfo {
            for attribute in TrackAttributes.getAll {
                if (key == attribute.rawValue) {
                    friend.setValue(value, forKey: key)
                }
            }
        }
        
        //Save current tracks
        self.persistenceManager.saveWorkerContext(managedObjectContext)
        
        //Save and merge changes from managedObjectContext with Main context
        self.persistenceManager.mergeWithMainContext()
    }
    
    
    
    /**
     Retrieves all tracks in the persistence layer, default (overridable)
     - Returns: Array<Event> with found events in datastore
     */
    func getAllTrackInfo() -> Array<TrackInfo> {
        var fetchedResults: Array<TrackInfo> = Array<TrackInfo>()
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.TrackInfo.rawValue)
        
        //Execute Fetch request
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [TrackInfo]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<TrackInfo>()
        }
        return fetchedResults
    }
    
    
    /**
     Create new tracks from a given list, and persist it to Datastore via Worker(minion),
     that synchronizes with Main context.
     
     - Parameter eventsList: Array<AnyObject> Contains tracksInfo to be persisted to the Datastore.
     - Returns: Void
     */
    func saveTracksList(_ tracksList: Array<Track>) {
        DispatchQueue.global().async {
            
            //manage Context with Private Concurrency type.
            let managedObjectContext: NSManagedObjectContext =
                NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            managedObjectContext.parent = self.mainContextInstance
            
            //Create trackEntity, process member field values
            for index in 0..<tracksList.count {
                let trackItem: Track = tracksList[index]
                
                
                let item = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.TrackInfo.rawValue,
                                                               into: managedObjectContext) as! TrackInfo
                
                //Add member field values
                item.setValue(trackItem.artistId,       forKey: self.artistId)
                item.setValue(trackItem.artistName,     forKey: self.artistName)
                item.setValue(trackItem.artistViewUrl,  forKey: self.artistViewUrl)
                item.setValue(trackItem.artworkUrl60,   forKey: self.artworkUrl60)
                item.setValue(trackItem.collectionName, forKey: self.collectionName)
                item.setValue(trackItem.id,             forKey: self.id)
                item.setValue(trackItem.kind,           forKey: self.kind)
                item.setValue(trackItem.previewUrl,     forKey: self.previewUrl)
                item.setValue(trackItem.trackId,        forKey: self.trackId)
                item.setValue(trackItem.trackName,      forKey: self.trackName)
                
                //Save current work on track workers
                self.persistenceManager.saveWorkerContext(managedObjectContext)
                
            }
            
            //Save and merge changes from Minion workers with Main context
            self.persistenceManager.mergeWithMainContext()
            
            //Post notification to update datasource of a given Viewcontroller/UITableView
            DispatchQueue.main.async {
                self.postUpdateNotification()
            }
        }
    }
    
    /**
     Post update notification to let the registered listeners refresh it's datasource.
     
     - Returns: Void
     */
    fileprivate func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateTrackTableData"), object: nil)
    }
}
