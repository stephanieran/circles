//
//  SplashViewController.swift
//  circles
//
//  Created by Stephanie Ran on 3/9/23.
//

import UIKit
import SceneKit

class SplashViewController: UIViewController {
    
    @IBOutlet var iconView: UIImageView!
    //
    // MARK: - Properties
    //
    var autoDismiss = false
    var label = "Welcome to Circles"
    
    //
    // MARK: - IBOutlets
    //
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet var screenLabel: UILabel!
    
    //
    // MARK: - IBActions
    //
    
    @IBAction func tapContinue(_ sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
    }
    

    //
    // MARK: - Lifecyle
    //
    
    override func viewWillAppear(_ animated: Bool) {
      print("ViewWillAppear")

      self.screenLabel.text = self.label
        iconView.image = UIImage(named: "icon")
      
      // If auto-dismissing hide the button and rely on tap to dismiss
      if self.autoDismiss {
        self.dismissButton.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          self.dismiss(animated: true, completion: {
            print("done")
          })
        }
      }
    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Display Splash Screen
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//            // Navigate to the main view controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                let delegate = windowScene.delegate as? SceneDelegate {
//                delegate.window?.rootViewController = mainVC
//                delegate.window?.makeKeyAndVisible()
//            }
//        }
//
//        iconView.image = UIImage(named: "icon")
//    }
}
