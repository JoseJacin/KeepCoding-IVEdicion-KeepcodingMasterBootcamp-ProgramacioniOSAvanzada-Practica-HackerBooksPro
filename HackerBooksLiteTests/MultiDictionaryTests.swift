//
//  MultiDictionaryTests.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 7/28/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest

class MultiDictionaryTests: XCTestCase {
    
    var d: MultiDictionary <String, String> = MultiDictionary()
    typealias StringBucket = MultiDictionary<String,String>.Bucket
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmpty(){
        XCTAssertTrue(d.isEmpty)
    }
    
    func testThatAskingForNonExistingValueReturnsNil(){
        XCTAssertNil(d["nothing here for ya"])
    }
    
    func testGetAndSetBucket(){
        
        let bucket : StringBucket = ["Valar Dohaeris"]
        d["Valar Morghulis"] = bucket
        
        XCTAssertEqual(bucket, d["Valar Morghulis"])
        
    }
    func testThatAddingNilBucketIsNOP(){
        
        let nothing : StringBucket? = nil
        
        d["nothing"] = nothing
        
        XCTAssertTrue(d.isEmpty)
        XCTAssertNil(d["nothing"])
        
    }
    
    func testCountBuckets(){
        
        XCTAssertEqual(d.countBuckets, 0)
        d["Stark"] = ["Ned", "Bran", "Robb", "Sansa", "Arya", "Jon"]
        XCTAssertEqual(d.countBuckets, 1)

    }
    
    func testCountUniqueElements(){
    
        XCTAssertEqual(d.countUnique, 0)
        d["Stark"] = ["Ned", "Bran", "Robb", "Sansa", "Arya", "Jon"]
        XCTAssertEqual(d.countUnique, 6)
        d["males"] = ["Ned", "Bran", "Robb", "Jon"]
        XCTAssertEqual(d.countUnique, 6)
        
    }
    
    func testCount(){
        XCTAssertEqual(d.count, 0)
        d["Stark"] = ["Ned", "Bran", "Robb", "Sansa", "Arya", "Jon"]
        XCTAssertEqual(d.count, 6)
        d["males"] = ["Ned", "Bran", "Robb", "Jon"]
        XCTAssertEqual(d.count, 10)
    }
    
    func testKeysAndBuckets(){
        
        d["Stark"] = ["Ned", "Bran", "Robb", "Sansa", "Arya", "Jon"]
        XCTAssertEqual(d.keys.count, 1)
        d["males"] = ["Ned", "Bran", "Robb", "Jon"]
        XCTAssertEqual(d.keys.count, 2)
        
        
    }
    func testInsertionOfValueForKey(){
        
        // if there was nothing, a new bucket is created
        d.insert(value: "Daenerys", forKey: "Targaryen")
        
        XCTAssertEqual(d.countBuckets, 1)
   
    }
    
    
    func testAddItemToBucket(){
        

        d.insert(value: "High Valyrian", forKey: "languages")
        
        XCTAssertTrue(d.count == 1)
        XCTAssertEqual(d.countBuckets, 1)
        XCTAssertTrue((d["languages"]!.contains("High Valyrian")))
        
        
        d.insert(value: "Dothraki", forKey: "languages")
        
        XCTAssertTrue(d.count == 2)
        XCTAssertEqual(d.countBuckets, 1)
        XCTAssertTrue((d["languages"]!.contains("Dothraki")))

        
    }
    
    func testRemoveItems(){
        
        d.insert(value: "High Valyrian", forKey: "languages")
        
        d.remove(value: "Chiquistaní", fromKey: "languages") // NOP
        d.remove(value: "Tyrion", fromKey: "NBA")            // NOP
        XCTAssertTrue(d.count == 1)
        XCTAssertEqual(d.countBuckets, 1)

        d.insert(value: "Dothraki", forKey: "languages")
        
        d.remove(value: "Dothraki", fromKey: "languages")
        XCTAssertTrue(d.count == 1)
        XCTAssertEqual(d.countBuckets, 1)
        XCTAssertFalse((d["languages"]?.contains("Dothraki"))!)
        
        d.remove(value: "High Valyrian", fromKey: "languages")
        XCTAssertTrue(d.count == 0)
        XCTAssertEqual(d.countBuckets, 0)
        
        
    }
    
    
    
    
    
    
    
    
    
}
