//
//  FirebaseHandler.swift
//  Arthius
//
//  Created by Satvik Borra on 3/25/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirebaseHandler {
    
    
}

let DOWNLOAD_COUNTER_SHARDS = 5;

class DownloadCounter {
    
    static func addDownloadCounterTo(uuid : String){
        let ref = getCounterRefFromUUID(uuid: uuid)
        print(ref.path)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                incrementCounter(ref: ref)
            } else {
                print("Counter does not exist, creating")
                createCounter(ref: ref, completion: {
                    incrementCounter(ref: ref)
                })
            }
        }

    }
    
    static func getDownloadCountFor(uuid : String, completion: @escaping (_ count : Int) -> Void){
        self.getCount(ref: self.getCounterRefFromUUID(uuid: uuid), completion: completion)
    }
    
    private static func getCount(ref: DocumentReference, completion: @escaping (_ count : Int) -> Void){
        ref.collection("shards").getDocuments() { (querySnapshot, err) in
            var totalCount = 0
            if err != nil {
                // Error getting shards
                // ...
            } else {
                for document in querySnapshot!.documents {
                    let count = document.data()["count"] as! Int
                    totalCount += count
                }
            }
            
            print("Total count is \(totalCount)")
            completion(totalCount)
        }
    }
    
    private static func getCounterRefFromUUID(uuid : String) -> DocumentReference {
        return db.collection("counters").document(uuid)
    }
    
    private static func createCounter(ref: DocumentReference, completion: @escaping () -> Void) {
        var num = 0
        ref.setData(["numShards": DOWNLOAD_COUNTER_SHARDS]){ (err) in
            if(err != nil){
                print("T "+(err?.localizedDescription)!)
            }
            for i in 0...DOWNLOAD_COUNTER_SHARDS {
                ref.collection("shards").document(String(i)).setData(["count": 0], completion: {(error : Error?) in
                    if(error != nil){
                        print("\(error?.localizedDescription)")
                    }
                    num += 1
                    if(num == DOWNLOAD_COUNTER_SHARDS){
                        completion()
                    }
                })
                
            }
        }
    }
    
    private static func incrementCounter(ref: DocumentReference) {
        // Select a shard of the counter at random
        let shardId = Int(arc4random_uniform(UInt32(DOWNLOAD_COUNTER_SHARDS)))
        let shardRef = ref.collection("shards").document(String(shardId))
        
        // Update count in a transaction
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                print("P \(shardRef.path)")
                let shardData = try transaction.getDocument(shardRef).data() ?? [:]
                let shardCount = shardData["count"] as! Int
                transaction.updateData(["count": shardCount + 1], forDocument: shardRef)
            } catch {
                // Error getting shard data
                // ...
                print(errorPointer.debugDescription)
            }
            
            return nil
        }) { (object, err) in
            // ...
            print("Completed incrementing download Error: \(String(describing: err?.localizedDescription))")
        }
    }
}
