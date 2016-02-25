//
//  SinglePhotoViewController.swift
//  SwiftPhotoGallery
//
//  Created by Prashant on 12/09/15.
//  Copyright (c) 2015 PrashantKumar Mangukiya. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    // collection view cell default width, height
    // final width will be calculated based on screen width and height
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    
    // variable keep track that view appear or not.
    // we have to load collection view after view appear so correct cell size achieved.
    var isViewAppear: Bool = false
    
    // clicked photo indexPath (will be set by parent controller)
    var clickedPhotoIndexPath : NSIndexPath?
    
    // photo list (will be set by parent controller)
    var photoList : [Picture] = [Picture]()
    
    
    // outlet - photo collection view
    @IBOutlet var photoCollectionView: UICollectionView!
    
    
    
    
    // MARK: - view function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set collectionview delegate and datasource
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // set view as appear
        self.isViewAppear = true
        
        // Calculate cell width, height based on screen width
        self.calculateCellWidthHeight()
        
        if self.photoList.isEmpty {
            self.showAlertMessage(alertTitle: "Error", alertMessage: "Photo list found empty.")
        }else{
            // reload collection view data
            self.photoCollectionView.reloadData()
            
            // scroll collection view at selected photo
            self.photoCollectionView.scrollToItemAtIndexPath(clickedPhotoIndexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }
    }
    
    
    
    
    // MARK: - Collection view data source
    
    // number of section in collection view
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of photos in collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isViewAppear {
            return self.photoList.count
        }else{
            return 0
        }
    }
    
    // return width and height of cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
    // configure cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get reusable cell
        let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("CellSinglePhoto", forIndexPath: indexPath) as! SinglePhotoCollectionViewCell
        
        // get current photo from list
        let photoRecord = self.photoList[indexPath.row]
        
        newCell.largeImageView.image = photoRecord.getImage()
        
        // return cell
        return  newCell
    }
    
    
    
    
    // MARK: - Utility functions
    
    // calculate collection view cell width same as full screen
    private func calculateCellWidthHeight() {
        
        // find cell width same as screen width
        self.cellWidth = Int(self.photoCollectionView.frame.width)
        
        // find cell height
        self.cellHeight = Int(self.photoCollectionView.frame.height) - 164  // deduct nav bar and status bar height
    }
    
    // show alert with ok button
    private func showAlertMessage(alertTitle alertTitle: String, alertMessage: String ) -> Void {
        
        // create alert controller
        let alertCtrl = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert) as UIAlertController
        
        // create action
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:
            { (action: UIAlertAction) -> Void in
                // you can add code here if needed
        })
        
        // add ok action
        alertCtrl.addAction(okAction)
        
        // present alert
        self.presentViewController(alertCtrl, animated: true, completion: { (void) -> Void in
            // you can add code here if needed
        })
    }
    
    
}
