//
//  JSONTests.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/19/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest

class JSONTests: XCTestCase {
    
    let testBundle = Bundle(for: JSONTests.self)
    
    var url : URL?
    var book : JSONDictionary?
    var books : JSONArray?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        url = testBundle.url(forResource: "book", withExtension: "json")
        let bookData = try! Data(contentsOf: url!)
        book = try! JSONSerialization.jsonObject(with: bookData,
                                                 options: .allowFragments)
            as! JSONDictionary
        
        url = testBundle.url(forResource: "books_readable", withExtension: "json")
        let booksData = try! Data(contentsOf: url!)
        books = try! JSONSerialization.jsonObject(with: booksData,
                                                  options: .allowFragments)
            as! JSONArray
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsingCommaSeparatedValues(){
        
        let raw = "Scott Chacon,    Ben Straub, "
        let tokens = parseCommaSeparated(string: raw)
        
        XCTAssertEqual(tokens, ["Scott Chacon", "Ben Straub"])
    }
    
    func testDecodingBook(){
        
        let b = try! decode(book: book)
        XCTAssertTrue(b.formattedListOfAuthors() == "Ben Straub, Scott Chacon")
        XCTAssertTrue(b.formattedListOfTags() == "Git, Version Control")
        
    }
    
    func testDecodingBooks(){
        
        let bs : [Book] = try! decode(books: books)
        XCTAssertEqual(bs.count, 30)
        

    }
    
    
}
