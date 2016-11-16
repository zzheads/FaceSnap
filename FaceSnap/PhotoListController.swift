//
//  ViewController.swift
//  FaceSnap
//
//  Created by Alexey Papin on 16.11.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import UIKit

class PhotoListController: UIViewController {

    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Camera", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)
        
        button.addTarget(self, action: #selector(PhotoListController.presentImagePickerController), for: .touchUpInside)
        return button
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    lazy var dataSource: PhotoDataSource = {
        return PhotoDataSource(fetchRequest: Photo.allPhotosRequest, collectionView: self.collectionView)
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let paddingDistance: CGFloat = 16.0
        let itemSize = (screenWidth - paddingDistance)/2.0
        
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.dataSource = dataSource
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
            ])
    }
    
    // MARK: - Image Picker Controller
    
    @objc private func presentImagePickerController() {
        mediaPickerManager.presentImagePickerController(animated: true)
    }
}

// MARK: - MediaPickerManagerDelegate
extension PhotoListController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        let eaglContext = EAGLContext(api: .openGLES3)!
        let ciContext = CIContext(eaglContext: eaglContext)
        
        let photoFilterController = PhotoFilterController(context: ciContext, eaglContext: eaglContext, image: image)
        let navigationController = UINavigationController(rootViewController: photoFilterController)
        manager.dismissImagePickerController(animated: true) {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

























