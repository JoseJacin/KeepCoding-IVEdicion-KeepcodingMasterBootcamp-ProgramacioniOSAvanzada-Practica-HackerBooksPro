//
//  BookTests.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/14/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest

class BookTests: XCTestCase {
    
    
    var bundle : Bundle?
    var url : URL?
    var remoteURL : URL?
    var img : Data?
    var book : Book?
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        bundle = Bundle.init(for: BookTests.self)
        url = bundle?.url(forResource: "Targaryen", withExtension: "png")
        remoteURL = URL(string: "https://geekandsundry.com/wp-content/uploads/2016/04/Daenerys-Targaryen.jpgg")
        img = try! Data(contentsOf: url!)
        let tags : Tags = [Tag(name: "Fantasy"), Tag(name:"Dragons"), Tag.favoriteTag() ]
        let pdf = AsyncData(url: remoteURL!, defaultData: img!)
        let image = AsyncData(url: remoteURL!, defaultData: img!)
        
        book = Book(title: "GoT", authors: ["Jon Snow", "Arya Stark", "Gregor Clegane"], tags: tags, pdf: pdf , image: image)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFormattedListOfAuthors(){
        
        XCTAssertEqual(book?.formattedListOfAuthors(), "Arya Stark, Gregor Clegane, Jon Snow")
    }
    
    func testFormattedListOfTags(){
        
        XCTAssertEqual(book?.formattedListOfTags(), "Favorite, Dragons, Fantasy")
    }
    
    func testFavorite(){
        
        XCTAssertTrue((book?.isFavorite)!)
        book?.isFavorite = false
        XCTAssertFalse((book?.isFavorite)!)
        book?.isFavorite = true
        XCTAssertTrue((book?.isFavorite)!)
        
    }
}




