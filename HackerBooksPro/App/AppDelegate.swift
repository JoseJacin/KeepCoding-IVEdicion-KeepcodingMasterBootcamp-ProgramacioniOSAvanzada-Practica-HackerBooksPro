//
//  AppDelegate.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 23/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var context: NSManagedObjectContext?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let container = persistentContainer(dbName: constants.dbName) { (error: NSError) in
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        self.context = container.viewContext
        
        if(isFirstTime()){
            loadingViewController()
            JSONInteractor(manager: DownloadAsyncGCD()).execute(urlString: constants.urlFileJSON, context: context!) { (Void) in
                setAppLaunched()
                self.loadViewController()
            }
        }else{
            loadViewController()
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        guard let context = self.context else { return }
        saveContext(context: context, process: true)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let context = self.context else { return }
        saveContext(context: context, process: true)
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        guard let context = self.context else { return }
        saveContext(context: context, process: true)
    }
    
    // Function that the LoadingController displays while loading data
    func loadingViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: constants.main, bundle: nil)
        let loadController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: constants.loadingController)
        
        self.window?.rootViewController = loadController
    }
    
    // Function that displays the NavigationController when data loading is complete
    func loadViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: constants.main, bundle: nil)
        let navController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: constants.navigationController) as! UINavigationController
        
        self.window?.rootViewController = navController
        
        self.injectContextAndFetchToFirstViewController()
        
        self.window?.makeKeyAndVisible()
    }
    
    // Inyect context
    func injectContextAndFetchToFirstViewController(){
        if let navController = window?.rootViewController as? UINavigationController,
            let initialViewController = navController.topViewController as? BooksViewController{
            initialViewController.context = self.context
            initialViewController.fetchedResultsController = BookTag.fetchController(context: context!, text: "")
        }
    }
}

