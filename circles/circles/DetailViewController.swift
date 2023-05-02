//
//  DetailViewController.swift
//  circles
//
//  Created by Stephanie Ran on 3/9/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

// struct for each user's post
struct Post {
    var image: UIImage
    var user: String
    var caption: String?
}

// dummy data, enough images to get random photos in each group
let allImages = [
    UIImage(named: "image1"),
    UIImage(named: "image2"),
    UIImage(named: "image3"),
    UIImage(named: "image4"),
    UIImage(named: "image5"),
    UIImage(named: "image6"),
    UIImage(named: "image7"),
    UIImage(named: "image8"),
    UIImage(named: "image9"),
    UIImage(named: "image10"),
    UIImage(named: "image11"),
    UIImage(named: "image12"),
    UIImage(named: "image13"),
    UIImage(named: "image14"),
    UIImage(named: "image15"),
    UIImage(named: "image16"),
    UIImage(named: "image17"),
    UIImage(named: "image18")
]

// gets three random images from the image array
func getThreeRandomImages() -> [UIImage] {
    var randomImages: [UIImage] = []
    
    for _ in 0..<3 {
        if let randomElement = allImages.randomElement() {
            randomImages.append(randomElement!)
        }
    }
    
    return randomImages
}

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    var idx = 0
    var images = getThreeRandomImages()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        // adding label
        let label = UILabel(frame: CGRect(x: 124, y: 100, width: 200, height: 30))
        label.text = "Today's Photos"
        label.font = UIFont.boldSystemFont(ofSize: 22)

        self.view.addSubview(label)
        
        // Get reference to Firebase Realtime Database.
        let ref = Database.database().reference()

        // Get the photo that you uploaded. And listen to future uploads (using .observe()).
        ref.child("uploads").observe(.childAdded) { snapshot, secondarg in
            // One by one, get the entries in the 'upload' folder.

            // Convert the entry into a "Upload" object.
            let upload = Upload.fromDictionary(snapshot.value as! [String: Any])

            // Get reference to the actual photo file in Firebase Storage.
            let storageRef = Storage.storage().reference(withPath: upload?.photo ?? "")

            // Get the photo from Firebase Storage.
            storageRef.getData(maxSize: 1000 * 1024 * 1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print("Error downloading image: \(error)")
              } else {
                // Convert the image into a UIImage.
                let image_ = UIImage(data: data!)

                // Rotate image (because the image is somehow rotated).
                let rotatedImage: UIImage = UIImage(cgImage: (image_?.cgImage)!, scale: image_!.scale, orientation: .right)

                // Add the image to the data.
                self.images.append(rotatedImage)

                print("Done Getting Photos")
                  
                  self.idx = 0
                  self.collectionView.reloadData()
              }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: view.frame.height - 200)
    }
    
    /* CollectionView Customization */
    // Attribution: https://www.youtube.com/watch?v=_OkriRP8Vx8
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Wrong cell class dequeued")
        }

        if (self.idx >= self.images.count) {
            return cell
        }

        cell.img = self.images[self.idx]
        self.idx += 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 90, height: view.frame.size.height - 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
