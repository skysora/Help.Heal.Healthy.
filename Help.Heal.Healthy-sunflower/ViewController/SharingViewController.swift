//
//  SharingViewController.swift
//  Help.Heal.Healthy
//
//  Created by YuMIng Haung on 2019/7/2.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import FacebookShare

class SharingViewController: UIViewController{

    
    var shareImage:UIImage = UIImage()
    var shareImageButtonList:[UIButton] = []
    @IBOutlet weak var shareImageScrollView: UIScrollView!
  
    
    @IBOutlet weak var shareBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        shareBtn.layer.cornerRadius = 20
        setUpShareImageScrollView()
        // Do any additional setup after loading the view.
    }
    
    func setUpShareImageScrollView(){
        shareImageScrollView.contentSize.width = 1250
        //shareImageScrollView.contentOffset.x = 400
        //shareImageScrollView.isPagingEnabled = true
        let image:[UIImage] = [UIImage(named: "shareTestImage_0")!, UIImage(named: "shareTestImage_1")!, UIImage(named: "shareTestImage_2")!]
        for index in 0...2{
            let imageViewButton = UIButton()
            imageViewButton.frame = CGRect(x: (index*250 + 10), y: 50, width: 200, height: 400)
            imageViewButton.setImage(image[index], for: .normal)
            imageViewButton.addTarget(self, action: #selector(imageViewButtonClicked(_:)), for: .touchUpInside)
            imageViewButton.tag = index
            shareImageScrollView.addSubview(imageViewButton)
            shareImageButtonList.append(imageViewButton)
        }

    }
    func resetShareImageButton(){
        for button in shareImageButtonList{
            button.frame = CGRect(x: button.tag*270, y: 50, width: 200, height: 400)
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
            
        }
    }
    
    @objc func imageViewButtonClicked(_ sender:UIButton){
        resetShareImageButton()
        shareImage = (sender.imageView?.image!)!
            sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.blue.cgColor
        sender.frame = CGRect(x: sender.tag*270, y: 0, width: 250, height: 500)
        
    }
    
    @IBAction func shareClick(_ sender: Any) {
//        let actionSheet = UIAlertController(title: "", message: "Share your Note", preferredStyle: UIAlertController.Style.actionSheet)
//        // 設定分享筆記至 Twitter 的新動作
//        let twitterAction = UIAlertAction(title: "Share on Twitter", style: UIAlertAction.Style.default) { (action) -> Void in
//
//        }
//
//
//        // 設定分享至 Facebook 的新動作
//        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertAction.Style.default) { (action) -> Void in
//
//        }
//        // 設定顯示 UIActivityViewController 的新動作
//        let moreAction = UIAlertAction(title: "More", style: UIAlertAction.Style.default) {
//            (action) -> Void in
//
//        }
//
//
//        let dismissAction = UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel) { (action) -> Void in
//
//        }
//
//        
//        actionSheet.addAction(twitterAction)
//        actionSheet.addAction(facebookPostAction)
//        actionSheet.addAction(moreAction)
//        actionSheet.addAction(dismissAction)
        
                //present(actionSheet, animated: true, completion: nil)
        let share = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        present(share, animated: true, completion: nil)
        
        
    }

    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func shareWithFacebook(){
        let content = SharePhotoContent()
        content.photos = [SharePhoto(image: #imageLiteral(resourceName: "AppIcon"), userGenerated: true)]
        ShareAPI(content: content, delegate: self).share()
        
    }
   
}
extension SharingViewController:SharingDelegate{
    //when the facebook share complete
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
         print("facebook share complete")
     }
     
    // when the facebook share error
     func sharer(_ sharer: Sharing, didFailWithError error: Error) {
         print("facebook share error")
     }
     
    //when the facebook share cancel
     func sharerDidCancel(_ sharer: Sharing) {
         print("facebook share cancel")
     }
}
