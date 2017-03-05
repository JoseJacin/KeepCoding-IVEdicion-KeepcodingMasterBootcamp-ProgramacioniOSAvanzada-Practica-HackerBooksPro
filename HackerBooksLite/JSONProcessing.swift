//
//  JSONProcessing.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/19/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//MARK: - Functions
// Function that load JSON from data
func jsonLoadFromData(dataInput data: Data) throws -> JSONArray{
    
    if let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
       let array = maybeArray {
        return array
    }else{
        throw JSONError.wrongJSONFormat
    }
}

//MARK: - Decodification
// Function that decodes a JSONArray containing JSONDictionary with Books
func decode(books dicts: JSONArray, context: NSManagedObjectContext) throws {
    
    let _ = try dicts.flatMap{
        try decode(book:$0, context: context)
    }
}

// Function that decode a JSONArray Optional containing JSONDictionary with Books
func decode(books dicts: JSONArray?, context: NSManagedObjectContext) throws {
    guard let ds = dicts else {
        throw JSONError.emptyJSONArray
    }
    try decode(books: ds, context: context)
}

// Function that decode a JSONDictionary containing Books
func decode(book dict: JSONDictionary, context: NSManagedObjectContext) throws {
    
    // Validate first
    try validate(dictionary: dict)
    
    // Parsing
    var cover = constants.defaultBookCover+constants.pngExtension
    if let urlCoverString = dict["image_url"] as? String {
        cover = urlCoverString
    }
    
    var pdf = constants.defaultPdf+constants.pdfExtension
    if let urlPDFString = dict["pdf_url"] as? String{
        pdf = urlPDFString
    }
    
    guard let title = dict["title"] as? String else{
        throw JSONError.wrongJSONFormat
    }
    
    let book = Book.get(title: title, coverUrl: cover, pdfUrl: pdf, context: context)
    
    if let authorsString = dict["authors"] as? String{
        let authors = Author.fromStringToSet(s: authorsString, context: context) as NSSet
        book.authors = authors
    }
    
    if let tagsString = dict["tags"] as? String{
        //let arr = tagsString.characters.split{$0 == ","}.map(String.init)
        let arr = parseCommaSeparated(string: tagsString)
        for each in arr{
            let tag = Tag.get(name: each, context: context)
            let _ = BookTag.get(book: book, tag: tag, context: context)
        }
    }
}

// Function that decode a JSONDictionary Optional containing Books
func decode(book dict: JSONDictionary?, context: NSManagedObjectContext) throws -> Book_old{
    
    guard let d = dict else {
        throw JSONError.emptyJSONObject
    }
    return try decode(book:d, context: context)
}

//MARK: - Validation
// Validation should be kept waya from processing to
// insure the single responsability principle
// https://medium.com/swift-programming/why-swift-guard-should-be-avoided-484cfc2603c5#.bd8d7ad91
private
func validate(dictionary dict: JSONDictionary) throws{
    func isMissing() throws{
        for key in dict.keys{
            guard let value = dict[key] else{
                throw JSONError.missingField(name: key)
            }
            guard value.length > 0  else {
                throw JSONError.incorrectValue(name: key, value: value as! String)
            }
        }
    }
    
    try isMissing()
}

/*
//MARK: - Parsing
func parseCommaSeparated(string s: String)->[String]{
    return s.components(separatedBy: ",").map({ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}).filter({ $0.characters.count > 0})
}






//MARK: - Constants
let nameFileJSON = "books_readable.json"
let bookJSONDataKey = "BookJSONDataKey"

//MARK: - Decodification
// Función que decodifica un diccionario JSON en un objeto del tipo Books. Actualmente no se usa, pero se deja por si se tiene que usar en un futuro desarrollo
func decode(book json: JSONDictionary) throws -> Book {
    // Se valida el diccionario
    // Se comprueba el campo authors
    guard let authorsString = json["authors"] as? String else {
        // Erorr. El campo authors es nil
        throw BookError.nilJSONObject
    }
    
    // Se comprueba el campo image_url
    guard let imageURLString = json["image_url"] as? String,
        let imageUrl = URL(string: imageURLString) else {
            // Error. El recurso apuntado por el campo image_url no está accesible
            throw BookError.resourcePointedByURLNotReachable
    }
    
    // Se comprueba el campo pdf_url
    guard let pdfURLString = json["pdf_url"] as? String,
        let pdfUrl = URL(string: pdfURLString) else {
            // Error. El recurso apuntado por el campo image_url no está accesible
            throw BookError.resourcePointedByURLNotReachable
    }
    
    // Se comprueba el campo tag
    guard let tagsString = json["tags"] as? String else {
        // Erorr. El campo tags es nil
        throw BookError.nilJSONObject
    }
    
    // Se comprueba el campo title
    guard let title = json["title"] as? String else {
        // Erorr. El campo title es nil
        throw BookError.nilJSONObject
    }
    
    // Se ha recuperado todo correctamente
    // Se separan los valores de authors y tags en varios elementos.
    let authors = authorsString.components(separatedBy: ", ").flatMap({ $0 as Author })
    let tags = tagsString.components(separatedBy: ", ").flatMap({ Tag(rawValue: $0.capitalized) })
    
    // Se retorna el Book
    return Book(title: title,
                authors: authors,
                tags: tags,
                imageUrl: imageUrl,
                pdfUrl: pdfUrl)
}

// Función que decodifica un diccionario opcional JSON en un objeto del tipo Books
func decode(book json: JSONDictionary?) throws -> Book {
    // Se valida que
    guard let json = json else {
        throw BookError.nilJSONObject
    }
    return try decode(book: json)
}

//MARK: - FileManager
// Función que retorna la URL del path Documents
func getMyDocumentsURL() -> URL {
    let sourcePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return sourcePath[0]
}

//MARK: - Download JSON
// Función que descarga el fichero JSON (si aplica) y lo guarda en Local en el path de Documents
func downloadAndSaveJSONFile() throws -> Data {
    // Se comprueba si la aplicación se ha ejecutado anteriormente en algún momento mediante la carga del fichero desde NSUserDefaults
    guard let bookJSONData: Data = UserDefaults.standard.data(forKey: bookJSONDataKey) else {
        // No se ha podido obtener el fichero JSON, por lo que se procede a su descarga
        // Se recupera la URL del JSON
        guard let jsonUrl = URL(string: constants.urlFileJSON) else {
            throw BookError.wrongURLFormatForJSONResource
        }
        
        // Se recupera el JSON referenciado por la URL
        guard let jsonDownloadedData = try? Data(contentsOf: jsonUrl) else {
            throw BookError.dataCollectionPointedByURLNotReachable
        }
        
        // Se almacena el fichero JSON en NSUserDefaults
        UserDefaults.standard.set(jsonDownloadedData, forKey: bookJSONDataKey)
        
        // Se retorna el fichero JSON
        return jsonDownloadedData
    }
    
    // Se ha podido obtener el fichero desde NSUserDefaults
    return bookJSONData
}

//MARK: - Loading JSON from local file (SandBox)
// Función que carga un fichero en local y retorna un array de JSON
func loadJSONFromSandBox() throws -> [Book] {
    do {
        // Se carga el fichero desde NSUserDefauls
        let jsonData = try downloadAndSaveJSONFile()
        
        // Se descarga la información del fichero JSON y se parsea a un array de JSON
        guard let maybeArray = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [[String: String]],
            let array = maybeArray else {
                throw BookError.jsonParsingError
        }
        
        // Se ha descargado correctamente el fichero a local y se ha transformado el diccionario JSON a Books
        return array.flatMap({ (dict: [String : String]) -> Book? in
            guard let title: String = dict["title"],
                let authorsString: String = dict["authors"],
                let tagsString: String = dict["tags"],
                let imageUrlString: String = dict["image_url"],
                let pdfUrlString: String = dict["pdf_url"] else {
                    return nil
            }
            
            // Se ha recuperado todo correctamente
            let book = Book(title: title,
                            authors: authorsString,
                            tags: tagsString,
                            imageUrlString: imageUrlString,
                            pdfUrlString: pdfUrlString)
            
            // Se recupera de NSUserDefaults si el Book es Favorito o no
            if UserDefaults.standard.bool(forKey: String(book.hashValue)) {
                // Se ha encontrado la clave del libro, lo que indica que el libro está marcado como Favorito.
                // Se añade el Book al Tag de Favoritos
                book.toggleFavoriteState()
            }
            
            return book
        })
    } catch {
        throw BookError.dataCollectionPointedByURLNotReachable
    }
}
*/

