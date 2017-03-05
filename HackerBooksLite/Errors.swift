//
//  BookError.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 4/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation

// In order to be used as an "exception" you have to use the error protocol
//MARK: - Book Errors
enum FilesError : Error {
    case resourcePointedByURLNotReachable // Recurso señalado por URL no accesible
    case dataCollectionPointedByURLNotReachable // La colección de datos señalado por URL no accesible
}

//MARK: - JSON Errors
enum JSONError : Error {
    case wrongURLFormatForJSONResource // Formato de URL del recurso JSON erróneo
    case emptyJSONObject // Objeto JSON vacío
    case emptyJSONArray // Array JSON vacío
    case jsonParsingError // Error al parsear el JSON
    case wrongJSONFormat // Formato de JSON erróneo
    case missingField(name:String) // Campo perdido
    case incorrectValue(name: String, value: String) // Valor incorrecto
}
