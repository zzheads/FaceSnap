//
//  PhotoFilterController.swift
//  FaceSnap
//
//  Created by Alexey Papin on 16.11.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    
    var mainImage: UIImage {
        didSet {
            photoImageView.image = mainImage
        }
    }
    let context: CIContext
    let eaglContext: EAGLContext
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .center
        return label
    }()
    
    lazy var filtersCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 100
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(FilteredImageCell.self, forCellWithReuseIdentifier: FilteredImageCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var filteredImages: [CIImage] = {
        let filteredImageBulder = FilteredImageBuilder(context: self.context, image: self.mainImage)
        return filteredImageBulder.imageWithDefaultFilters()
    }()
    
    init(context: CIContext, eaglContext: EAGLContext,image: UIImage) {
        self.context = context
        self.eaglContext = eaglContext
        self.mainImage = image
        self.photoImageView.image = self.mainImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoFilterController.dismissPhotoFilterController))
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PhotoFilterController.presentMetadataController))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
    }

    override func viewWillLayoutSubviews() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        filterHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterHeaderLabel)
        
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersCollectionView)
        
        NSLayoutConstraint.activate([
            filtersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filtersCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            filtersCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            filtersCollectionView.heightAnchor.constraint(equalToConstant: 200.0),
            filtersCollectionView.topAnchor.constraint(equalTo: filterHeaderLabel.bottomAnchor),
            filterHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            filterHeaderLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: filtersCollectionView.topAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoFilterController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell
        
        let ciImage = filteredImages[indexPath.row]
        cell.ciContext = self.context
        cell.eaglContext = eaglContext
        cell.image = ciImage
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoFilterController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = filteredImages[indexPath.row]
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        self.mainImage = UIImage(cgImage: cgImage)
    }
}

// MARK: - Navigation 

extension PhotoFilterController {
    @objc func dismissPhotoFilterController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func presentMetadataController() {
        let photoMetadataController = PhotoMetadataController(photo: self.mainImage)
        self.navigationController?.pushViewController(photoMetadataController, animated: true)
    }
}











