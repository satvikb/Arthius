//
//  File.swift
//  Arthius
//
//  Created by Satvik Borra on 3/23/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

let CAMPAIGN_LEVEL_FOLDER = "CampaignLevels"
let CAMPAIGN_SAVES_FOLDER = "CampaignSaves"
let PUBLIC_LEVELS_FOLDER = "PublicLevels"
let USER_LEVELS_FOLDER = "UserLevels"
let USER_SAVES_FOLDER = "UserSave"

let LEVEL_EXTENSION = ".gws"
enum LevelType : String{
    case Campaign
    case CampaignSave
    case PublicMade
    case UserMade
    case UserSave
}

class File {
    
    
    static func getAllLevels(type : LevelType) -> [LevelData]{
        var levels : [LevelData] = []
        
        //get all files in directory
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.getFolderForLevelType(type: type), isDirectory: true)
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            for url in fileURLs {
                
                if(url.pathExtension == "gws"){
                    let fileName = url.lastPathComponent
                    let level : LevelData = try Disk.retrieve(self.getFolderForLevelType(type: type)+"/\(fileName)", from: .documents, as: LevelData.self)
                    levels.append(level)
                    
                    let attr = try fileManager.attributesOfItem(atPath: url.path);
                    print("Loaded \(type.rawValue) level: \(url.lastPathComponent) \(attr[FileAttributeKey.size] as! UInt64) bytes")
                }
            }
            
        } catch let error as NSError {
            //            print("Error Loading Campaign Levels")
            
            print("""
                ERROR GETTING \(type.rawValue) LEVELS
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
        return levels;
    }
    
    static func getLevelPath(uuid: String, type : LevelType) -> URL{
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.getFolderForLevelType(type: type), isDirectory: true).appendingPathComponent("\(uuid).gws")
        print("got lv "+documentsURL.path)
        return documentsURL
    }
    
//    static func getAllCampaignLevels() -> [LevelData]{
//        var levels : [LevelData] = []
//
//        //get all files in CampaignLevels
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(CAMPAIGN_LEVEL_FOLDER, isDirectory: true)
//
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            // process files
//            for url in fileURLs {
//
//                if(url.pathExtension == "gws"){
//                    let fileName = url.lastPathComponent
//                    let level : LevelData = try Disk.retrieve(self.getFolderForLevelType(type: .Campaign)+"/\(fileName)", from: .documents, as: LevelData.self)
//                    levels.append(level)
//
//                    let attr = try fileManager.attributesOfItem(atPath: url.path);
//                    print("Loaded campaign level: \(url.lastPathComponent) \(attr[FileAttributeKey.size] as! UInt64) bytes")
//                }
//            }
//
//        } catch let error as NSError {
//            //            print("Error Loading Campaign Levels")
//
//            print("""
//                ERROR GETTING CAMPAIGN LEVELS
//                Domain: \(error.domain)
//                Code: \(error.code)
//                Description: \(error.localizedDescription)
//                Failure Reason: \(error.localizedFailureReason ?? "")
//                Suggestions: \(error.localizedRecoverySuggestion ?? "")
//                """)
//        }
//
//        return levels;
//    }
//
//    static func getAllUserCreatedLevels() -> [LevelData]{
//        var levels : [LevelData] = []
//
//        //get all files in CampaignLevels
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(USER_LEVELS_FOLDER, isDirectory: true)
//
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            // process files
//            for url in fileURLs {
//
//                if(url.pathExtension == "gws"){
//                    let fileName = url.lastPathComponent
//                    let level : LevelData = try Disk.retrieve(self.getFolderForLevelType(type: .UserMade)+"/\(fileName)", from: .documents, as: LevelData.self)
//                    levels.append(level)
//
//                    let attr = try fileManager.attributesOfItem(atPath: url.path);
//                    print("Loaded created level: \(url.lastPathComponent) \(attr[FileAttributeKey.size] as! UInt64) bytes")
//                }
//            }
//
//        } catch let error as NSError {
//            //            print("Error Loading Campaign Levels")
//            
//            print("""
//                ERROR GETTING CREATED LEVELS
//                Domain: \(error.domain)
//                Code: \(error.code)
//                Description: \(error.localizedDescription)
//                Failure Reason: \(error.localizedFailureReason ?? "")
//                Suggestions: \(error.localizedRecoverySuggestion ?? "")
//                """)
//        }
//
//        return levels;
//    }
    
    
    static func saveLevel(level: LevelData, levelType : LevelType) {
        do {
            try Disk.save(level, to: .documents, as: self.getFolderForLevelType(type: levelType)+"/"+level.levelMetadata.levelUUID+LEVEL_EXTENSION)
        } catch let error as NSError {
            print("""
                ERROR SAVING LEVEL
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
    }
    
    static func getFolderForLevelType(type : LevelType) -> String {
        switch type {
        case .Campaign:
            return CAMPAIGN_LEVEL_FOLDER;
        case .CampaignSave:
            return CAMPAIGN_SAVES_FOLDER;
        case .PublicMade:
            return PUBLIC_LEVELS_FOLDER;
        case .UserMade:
            return USER_LEVELS_FOLDER;
        case .UserSave:
            return USER_SAVES_FOLDER;
        }
    }
    
    
    
    static func copyLevelsFromBundleToDocuments(){
    
        func copyFolders() {
            let filemgr = FileManager.default
            //            filemgr.delegate = self
            let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
            let docsURL = dirPaths[0]
            
            let folderPath = Bundle.main.resourceURL!.appendingPathComponent("Levels").path
            let docsFolder = docsURL.appendingPathComponent(CAMPAIGN_LEVEL_FOLDER).path
            copyFiles(pathFromBundle: folderPath, pathDestDocs: docsFolder)
        }
        
        func copyFiles(pathFromBundle : String, pathDestDocs: String) {
            let fileManagerIs = FileManager.default
            //            fileManagerIs.delegate = self
            
            let tempPath = fileManagerIs.temporaryDirectory.path
            
            do {
                let filelist = try fileManagerIs.contentsOfDirectory(atPath: pathFromBundle)
                try? fileManagerIs.copyItem(atPath: pathFromBundle, toPath: pathDestDocs)
                
                for filename in filelist {
                    let bundlePath = "\(pathFromBundle)/\(filename)"
                    let docPath = "\(pathDestDocs)/\(filename)";
                    
                    if(fileManagerIs.fileExists(atPath: docPath)){
                        let docFileEqualToBundleFile = fileManagerIs.contentsEqual(atPath: docPath, andPath: bundlePath)
                        
                        if(docFileEqualToBundleFile == false){
                            let fileTemp = "\(tempPath)/\(filename)";
                            try? fileManagerIs.copyItem(atPath: bundlePath, toPath: fileTemp)
                            
                            // fileManagerIs.replaceitem(URL(string: docPath)!, withItemAt: URL(string: tempPath)!)
                            let replace = try fileManagerIs.replaceItemAt(URL(string: docPath)!, withItemAt: URL(string: fileTemp)!, backupItemName: "BU.gws", options: []);
                            if(replace != nil){
                                print("Lv \(filename) NOT equal. Replacing with original.")
                            }
                        }
                    }else{
                        try? fileManagerIs.copyItem(atPath: bundlePath, toPath: docPath)
                        print("Copying \(pathFromBundle)/\(filename) to \(pathDestDocs)/\(filename)")
                    }
                    
                }
            } catch let error as NSError{
                print("\nError \(error.localizedDescription)\n")
            }
        }
    
        copyFolders()
    }
    
}
