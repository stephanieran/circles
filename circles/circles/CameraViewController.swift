//
//  CameraViewController.swift
//  circles
//
//  Created by Stephanie Ran on 3/8/23.
//

import UIKit
import FirebaseDatabase //Attribution: https://www.youtube.com/watch?v=9zdvmgGsww0&list=PL4cUxeGkcC9jERUGvbudErNCeSZHWUVlb
import FirebaseStorage //Attribution: https://www.youtube.com/watch?v=BZEluKixqDA

// Define user class
class User {
    var name: String?
    
    init(name: String?) {
        self.name = name
    }
    
    func toDictionary() -> [String:Any] {
        return [
            "name": name ?? "",
        ]
    }
    
    static func fromDictionary(_ dict: [String: Any]) -> User? {
        guard let name = dict["name"] as? String
        else {
            return nil
        }
            
        return User(name: name)
    }
}

// Define Upload class
class Upload {
    var uploadID: String?
    var groupID: String?
    var creatorID: String?
    var date: Date?
    var caption: String?
    var photo: String?
    
    init(uploadID: String?, groupID: String?, creatorID: String?, date: Date?, caption: String?, photo: String?) {
            self.uploadID = uploadID
            self.groupID = groupID
            self.creatorID = creatorID
            self.date = date
            self.caption = caption
            self.photo = photo
        }
    
    // Convert upload object to dictionary for Firebase
    func toDictionary() -> [String:Any] {
        return [
            "uploadID": uploadID ?? "",
            "groupID": groupID ?? "",
            "creatorID": creatorID ?? "",
            "date": date?.timeIntervalSince1970 ?? 0,
            "caption": caption ?? "",
            "photo": photo ?? ""
        ]
    }
    
    static func fromDictionary(_ dict: [String: Any]) -> Upload? {
        guard let uploadID = dict["uploadID"] as? String,
              let groupID = dict["groupID"] as? String,
              let creatorID = dict["creatorID"] as? String,
              let date: Date? = Date.init(timeIntervalSince1970: dict["date"] as! TimeInterval),
              let caption = dict["caption"] as? String,
              let photo = dict["photo"] as? String
        else {
            return nil
        }
        
        return Upload(uploadID: uploadID, groupID: groupID, creatorID: creatorID, date: date, caption: caption, photo: photo)
    }
    
}

class CameraViewController: UIViewController, UITextFieldDelegate {
    var img: UIImage!
    var caption: String!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.image = img
        sendButton.tintColor = UIColor(red: 157/255, green: 129/255, blue: 137/255, alpha: 1.0) //198, 236, 213
    }
    
    // stores photo to Firebase after tapping the "Send button"
    @IBAction func didTapButton() {
        // Get references to Firebase Storage.
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child("photos/\(UUID().uuidString).png")
        
        // Get reference to Firebase Realtime Databse.
        let ref = Database.database().reference()
        
        // Upload photo. Convert to PNG.
        photoRef.putData(img.pngData()!, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading photo: \(error.localizedDescription)")
            } else {
                // Successfully uploaded.
                
                // Get link to photo.
                let photoLink = "photos/\(metadata?.name! ?? "")"
                
                // Photo upload information.
                let newUpload = Upload(uploadID: "12345", groupID: "123", creatorID: "789", date: Date(), caption: "hi", photo: photoLink)
                
                // Upload information about photo to Firebase Realtime Database.
                let messageRef = ref.child("uploads").childByAutoId()
                messageRef.setValue(newUpload.toDictionary()) { error, ref in
                    if let error = error {
                        print("Error writing message: \(error)")
                    } else {
                        print("Message written to database")
                    }
                }
            }
        }
        
        // go back to the main view controller
        navigationController?.popViewController(animated: true)
    }
}
