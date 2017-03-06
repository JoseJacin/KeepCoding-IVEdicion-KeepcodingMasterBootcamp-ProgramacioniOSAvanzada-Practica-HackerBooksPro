//
//  LibraryTests.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/16/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest

class LibraryTests: XCTestCase {
    
    
    var lib : Library?
    var bundle : Bundle?
    var url : URL?
    var remoteURL : URL?
    var img : Data?
    var pdf : AsyncData?
    var books : [Book]?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        bundle = Bundle.init(for: BookTests.self)
        url = bundle?.url(forResource: "Targaryen", withExtension: "png")
        remoteURL = URL(string: "https://geekandsundry.com/wp-content/uploads/2016/04/Daenerys-Targaryen.jpgg")
        img = try! Data(contentsOf: url!)
        let tags : Tags = [Tag(name: "Fantasy"),
                           Tag(name:"Dragons"),
                           Tag(name: "Knights") ]
        let pdf = AsyncData(url: remoteURL!, defaultData: img!)
        let image = AsyncData(url: remoteURL!, defaultData: img!)
        let authors = ["George R R Martin", "Chiquito de la Calzada"]
        
        let agot = Book(title: "A Game of Thrones", authors: authors, tags: tags, pdf: pdf, image: image)
        
        let acok = Book(title: "A clash of kings", authors: authors, tags: tags, pdf: pdf, image: image)
        
        var favTags = tags
        favTags.insert(Tag.favoriteTag())
        let asos = Book(title: "A storm of swords", authors: authors + ["Lucas Grijander"], tags: favTags, pdf: pdf, image: image)
        
        books = [agot, acok, asos]
        
        lib = Library(books: books!)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBookCount(){
        XCTAssertTrue(lib!.bookCount == 3)
    }
    
    func testBooksPerTag(){
        XCTAssertTrue(lib!.books(forTagName: "Fantasy")!.count == 3)
        XCTAssertTrue(lib!.books(forTagName: "Dragons")!.count == 3)
        XCTAssertTrue(lib!.books(forTagName: "Favorite")!.count == 1)
        
        // Case doesn't matter
        XCTAssertTrue(lib!.books(forTagName: "FAntasy")!.count == 3)
        XCTAssertTrue(lib!.books(forTagName: "drAGons")!.count == 3)
        XCTAssertTrue(lib!.books(forTagName: "fAvoriTe")!.count == 1)
        
        // nonexistent tags return nil
        XCTAssertNil(lib!.books(forTagName: "Grijander")?.count )
        XCTAssertNil(lib!.books(forTagName: "f")?.count)
        
        
    }
    
    func testBookInTagAtIndex(){
        XCTAssertTrue(lib!.book(forTagName: "Fantasy", at: 0)!.title == "A storm of swords")
        
    }
    
    func testTags(){
        
        XCTAssertEqual(lib!.tags.count, 4)
        XCTAssertEqual(lib!.tags, [Tag(name:"Favorite"),
                                   Tag(name:"Dragons"),
                                   Tag(name:"Fantasy"),
                                   Tag(name:"Knights")])
        
    }
}













