//
//  TagTests.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/14/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest

class TagTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testFavoriteCreation(){
        
        let f = Tag.favoriteTag()
        
        XCTAssert(f.isFavorite())
    }
    
    func testSortedTags(){
        // Favorite must come first, everything else in lexicographic order
        let tags = [Tag(name:"OpenGL"), Tag(name:"Algorithms"), Tag.favoriteTag() ].sorted()
        
        XCTAssert(tags[0].isFavorite())
        XCTAssert(tags[1] == Tag(name:"Algorithms"))
        XCTAssert(tags[2] == Tag(name:"OpenGL"))
    }
    
    
}
