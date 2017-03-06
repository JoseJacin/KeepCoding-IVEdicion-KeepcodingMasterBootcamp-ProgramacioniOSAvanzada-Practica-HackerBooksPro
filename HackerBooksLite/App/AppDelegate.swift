//
//  AppDelegate.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 7/12/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    var context: NSManagedObjectContext?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Clean up all local caches
        AsyncData.removeAllLocalFiles()
        
        // Context instance
        let container = persistentContainer(dbName: constants.dbName) { (error: NSError) in
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        self.context = container.viewContext
        
        // Validate if the app is run for the first time
        if(isFirstTimeLaunched()){
            
            loadingViewController()
            JSONInteractor(manager: DownloadAsyncGCD()).execute(urlString: constants.urlFileJSON, context: context!) { (Void) in
                setLaunched()
                //self.loadViewController()
            }
        }else{
//            loadViewController()
        }
        
        return true
        
        // Create the window
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        // Create the model
        do{
            guard let url = Bundle.main.url(forResource: "books_readable", withExtension: "json") else{
                fatalError("Unable to read json file!")
            }
            
            let data = try Data(contentsOf: url)
            let jsonDicts = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONArray
            
            //let books = try decode(books: jsonDicts)
            //model = Library_old(books: books)
            
        }catch {
            fatalError("Error while loading model")
        }
        
        
        // Create the rootVC
       // let rootVC = LibraryViewController(model: model!, style: .plain)
        //window?.rootViewController = rootVC.wrappedInNavigationController()
        
        // Display
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func loadingViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loadController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoadingController")
        
        self.window?.rootViewController = loadController
    }
    
    func loadViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        
        self.window?.rootViewController = navController
        
        self.injectContextAndFetchToFirstViewController()
        
        self.window?.makeKeyAndVisible()
    }
    
    func injectContextAndFetchToFirstViewController(){
        if let navController = window?.rootViewController as? UINavigationController,
            let initialViewController = navController.topViewController as? LibraryViewController{
            initialViewController.context = self.context
            initialViewController.fetchedResultsController = BookTag.fetchController(context: context!, text: "")
        }
    }
    
}

