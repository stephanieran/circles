//
//  AppDelegate.swift
//  circles
//
//  Created by Stephanie Ran on 3/8/23.
//

import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var launchFromTerminated = false

    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        var launchCount = UserDefaults.standard.integer(forKey: "LaunchCount")
        launchCount += 1
        UserDefaults.standard.set(launchCount, forKey: "LaunchCount")
        self.launchFromTerminated = true
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
      print("Entering background")
      showSplashScreen(autoDismiss: false, label: "👀")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
      print("Did become active")
      if launchFromTerminated {
        showSplashScreen(autoDismiss: false, label: "Splash")
        launchFromTerminated = false
      }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// Attribution - Prof Binkowski
extension AppDelegate {
  
  /// Load the SplashViewController from Splash.storyboard
  func showSplashScreen(autoDismiss: Bool, label: String) {
    let storyboard = UIStoryboard(name: "Splash", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
    
    // Control the behavior from suspended to launch
    controller.autoDismiss = autoDismiss
    controller.label = label
    controller.modalPresentationStyle = .fullScreen
    
    // Present the view controller over the top view controller
    let vc = topController()
    vc.present(controller, animated: false, completion: nil)
  }
  
  
  /// Determine the top view controller on the screen
  /// - Returns: UIViewController
  func topController(_ parent:UIViewController? = nil) -> UIViewController {
    if let vc = parent {
      if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
        return topController(selected)
      } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
        return topController(top)
      } else if let presented = vc.presentedViewController {
        return topController(presented)
      } else {
        return vc
      }
    } else {
      return topController(UIApplication.shared.keyWindow!.rootViewController!)
    }
  }
}
