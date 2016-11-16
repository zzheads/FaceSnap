//
//  PhotoMetadataController.swift
//  FaceSnap
//
//  Created by Alexey Papin on 16.11.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoMetadataController: UITableViewController {

    let photo: UIImage

    init(photo: UIImage) {
        self.photo = photo
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Metadata fields
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(image: self.photo)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var imageViewHeight: CGFloat = {
        let imageFactor = self.photoImageView.frame.size.height/self.photoImageView.frame.size.width
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth * imageFactor
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add location"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var locationManager: LocationManager!
    var location: CLLocation?
    lazy var tagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "summer, vocation"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoMetadataController.savePhotoWithMetadata))
        navigationItem.rightBarButtonItem = saveButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PhotoMetadataController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.contentView.addSubview(photoImageView)
            NSLayoutConstraint.activate([
                photoImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                photoImageView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
                photoImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                photoImageView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor)
                ])
        case(1, 0):
            cell.contentView.addSubview(locationLabel)
            cell.contentView.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                activityIndicator.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0),
                locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                locationLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
                ])
        case(2, 0):
            cell.contentView.addSubview(tagsTextField)
            
            NSLayoutConstraint.activate([
                tagsTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                tagsTextField.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                tagsTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                tagsTextField.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
                ])
            
        default:
            break
        }
        
        return cell
    }
}

// MARK: - Helper Methods

extension PhotoMetadataController {
    func tagsFromTextField() -> [String] {
        guard let tags = tagsTextField.text else {
            return []
        }
        let commaSeparatedSubSequences = tags.characters.split(separator: ",")
        let commaSeparatedString = commaSeparatedSubSequences.map(String.init)
        let lowercaseTag = commaSeparatedString.map { $0.lowercased() }
        return lowercaseTag.map { $0.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) }
    }
}

// MARK - Persistence

extension PhotoMetadataController {
    func savePhotoWithMetadata() {
        let tags = tagsFromTextField()
        Photo.photoWith(image: self.photo, tags: tags, location: self.location)
        CoreDataController.save()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension PhotoMetadataController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0): return imageViewHeight
        default: return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            locationLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            locationManager = LocationManager()
            locationManager.onLocationFix = { placemark, error in
                if let placemark = placemark {
                    self.location = placemark.location
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.locationLabel.isHidden = false
                    
                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea  else {
                        return
                    }
                    self.locationLabel.text = "\(name), \(city), \(area)"
                }
            }
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Photo"
        case 1: return "Location"
        case 2: return "Enter tags"
        default: return nil
        }
    }
}





















