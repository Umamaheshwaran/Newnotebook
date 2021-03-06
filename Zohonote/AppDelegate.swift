//
//  AppDelegate.swift
//  Zohonote
//
//  Created by Rajesh on 23/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchedShortcutItem: UIApplicationShortcutItem? = nil


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // If a shortcut was launched, display its information and take the appropriate action
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
                
                launchedShortcutItem = shortcutItem
            }
        } else {
            // Fallback on earlier versions
        }

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
        
        if #available(iOS 9.0, *) {
            guard let shortcut = launchedShortcutItem else { return }
            _ = handleShortCutItem(shortcut)
            launchedShortcutItem = nil
        } else {
            // Fallback on earlier versions
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
//MARK: - ShortcutItem Stack
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
        
        switch (shortCutType) {
        case ShortcutIdentifier.First.type:
            //search
         selectedShortCutItemConfig.selectedPage = .search
            // Handle shortcut 1
            handled = true
            break
        case ShortcutIdentifier.Second.type:
            // Handle shortcut 2
            selectedShortCutItemConfig.selectedPage = .notebooksList

            
            handled = true
            break
        case ShortcutIdentifier.Third.type:
            // Handle shortcut 3
            selectedShortCutItemConfig.selectedPage = .newNote

            handled = true
            break
        default:
            break
        }
        
        let customNav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController  = customNav

        // Display the selected view controller
       
        
        return handled
    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        
        completionHandler(handledShortCutItem)
        
        
        
        
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Zohonote")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

