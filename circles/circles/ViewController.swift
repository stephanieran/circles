//
//  ViewController.swift
//  madhacks
//
//  Created by Stephanie Ran on 3/4/23.
//

import UIKit

// settings bundle UserDefaults
let defaults = UserDefaults.standard
let mySettingValue = defaults.object(forKey: "MySettingKey")


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var button: UIButton!
    
    let searchController = UISearchController()
    
    var filteredPhotos = [CirclePhoto]()
    
    // Circle photo struct
    struct CirclePhoto {
        let title: String
        let imageName: String
    }
    
    // array of photos
    let data: [CirclePhoto] = [
        CirclePhoto(title: "Hibino Fam <3", imageName: "hibinoFam"),
        CirclePhoto(title: "Li Women", imageName: "liWomen"),
        CirclePhoto(title: "Big Ran", imageName: "bigRan"),
        CirclePhoto(title: "KTP Fam", imageName: "ktp")
    ]
    
    var filteredData: [CirclePhoto]!
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "circles."
        self.filteredPhotos = data
        
        button.tintColor = UIColor(red: 157/255, green: 129/255, blue: 137/255, alpha: 1.0) //198, 236, 213
    
        table.dataSource = self
        table.delegate = self
    }
    
    // launch count pop up
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let launchCount = UserDefaults.standard.integer(forKey: "LaunchCount")
        print("launch count = \(launchCount)") // debug
        if launchCount == 3 {
            let alert = UIAlertController(title: "Welcome back!", message: "Please rate this app in the App store if you like it :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    /* Camera Function */
    @IBAction func didTapButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    /* Table Formatting */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.label.text = photo.title
        cell.iconImageView.image = UIImage(named: photo.imageName)
        cell.iconImageView.round()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

/* Camera Extension */
// Attribution: https://www.youtube.com/watch?v=hg-6sOOxeHA&t=329s
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image1 = info[UIImagePickerController.InfoKey.originalImage] as?
        UIImage else{
            return
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Camera") as? CameraViewController {
            vc.img = image1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

public extension UIView {
    func round() {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRectMake(bounds.midX - width / 2, bounds.midY - width / 2, width, width)).cgPath
        self.layer.mask = mask
    }
}
