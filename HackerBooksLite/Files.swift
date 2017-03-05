//
//  Files.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 4/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation


//Function that receives a URL and checks if the file exists. If it exists, it returns it. 
//If it does not exist, it downloads it, saves it to Documents Folder and returns the Data value
public func getFileFrom(urlString sUrl: String) throws -> Data{
    if(!fileAlreadyExists(urlString: sUrl)){
        return try saveToLocalStorage(stringUrl: sUrl)
    }else{
        return try dataFromStringUrl(stringUrl: sUrl)
    }
}

//Function that check if a file exists on the documents folder
private func fileAlreadyExists(urlString sUrl: String) -> Bool{
    
    let fileManager = FileManager.default
    let fileName = fileNameFromStringUrl(urlString: sUrl)
    
    //The documents folder url
    let docsurl = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let dataUrl = docsurl.appendingPathComponent(fileName)
    
    // Check if file exists
    if fileManager.fileExists(atPath: dataUrl.path){
        return true
    } else {
        return false
    }
    
}

//Function that saves a file on a external url to the Documents Folder and returns the Data value
private func saveToLocalStorage(stringUrl sUrl: String) throws -> Data{
    
    let fileData = try? Data(contentsOf: URL(string: sUrl)!)
    guard let downloadedData = fileData else {
        throw FilesError.resourcePointedByURLNotReachable
    }
    
    let fileName = fileNameFromStringUrl(urlString: sUrl)
    
    let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let path = sourcePaths[0]
    let file: URL = URL(fileURLWithPath: fileName, relativeTo: path)
    let fileManager = FileManager.default
    fileManager.createFile(atPath: file.path, contents: downloadedData, attributes: nil)
    
    return try dataFromStringUrl(stringUrl: sUrl)
}

//Function that returns the Data value of a file that exists on the Documents Fytrolder.
private func dataFromStringUrl(stringUrl sUrl: String) throws -> Data{
    
    let fileManager = FileManager.default
    let docsurl = try! fileManager.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    let fileName = fileNameFromStringUrl(urlString: sUrl)
    let dataUrl = docsurl.appendingPathComponent(fileName)
    
    if let dataFromUrl = try? Data.init(contentsOf: dataUrl) {
        return dataFromUrl
    }else{
        throw FilesError.resourcePointedByURLNotReachable
    }
}

//Get the name of the file in the document folder. The name of a file is the url hashed
private func fileNameFromStringUrl(urlString sUrl: String) -> String{
    return String(sUrl.hashValue)
}
