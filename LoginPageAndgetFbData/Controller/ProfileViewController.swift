//
//  ProfileViewController.swift
//  LoginPageAndgetFbData
//
//  Created by Mac on 30/07/20.
//  Copyright © 2020 Gunde Ramakrishna Goud. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare
import SDWebImage
import DropDown
import MobileCoreServices

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var DobLabel: UILabel!
    let picker = UIImagePickerController()
    
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyProfileData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(openDropDown))
        // Do any additional setup after loading the view.
    }
    @objc func openDropDown(){
        dropDown.anchorView = self.navigationItem.rightBarButtonItem
        dropDown.dataSource = ["Link", "Photo", "Video","Friends"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch index {
                case 0:
                     self.shareLink(url: URL(string: "https://cocoapods.org/pods/FacebookShare")!)
                     print("Link Sharing")
                case 1:
                     self.shareImage()
                     print("Photo Sharing")
                case 2:
                    self.shareVideo()
                    print("Video Sharing")
                case 3:
                    self.friendsDetails()

            default:
                break;
            }
        }
        dropDown.width = 100
        dropDown.show()
    }
    func friendsDetails()
    {
        let FDVC = self.storyboard?.instantiateViewController(identifier: "FriendsDetailsViewController") as! FriendsDetailsViewController
        present(FDVC, animated: true, completion: nil)
       
        
    }
    func shareLink(url: URL)
    {
        let contents = ShareLinkContent()
        contents.contentURL = url
        contents.quote = "This is my url"
        let shareDialoge = ShareDialog.init(fromViewController: self, content: contents, delegate: self as? SharingDelegate)
        shareDialoge.mode = .browser
        shareDialoge.show()
        
    }
    func shareImage()
    {
    picker.delegate = self
    picker.mediaTypes = [String(kUTTypeImage)]
    picker.allowsEditing = false
    picker.sourceType = .photoLibrary
    self.present(picker, animated: true, completion: nil)
    }
    func shareVideo()
      {
       picker.delegate = self
       picker.mediaTypes = [String(kUTTypeMovie)]
       picker.allowsEditing = false
       picker.sourceType = .photoLibrary
       self.present(picker, animated: true, completion: nil)
       }
    
    @IBAction func OnLogOutBtn(_ sender: UIButton)
    {
        if let token = AccessToken.current{
                   AccessToken.current = nil
                   let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                   self.present(loginVC, animated: true, completion: nil)
               }
    }
    
    func getMyProfileData()
        {
            let myGraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, birthday, age_range, picture.width(400), gender"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: .get)
            myGraphRequest.start(completionHandler: { (connection, result, error) in
                //print(result)
                if let res = result {
                    var responseDict = res as! [String:Any]
                    let fullName = responseDict["name"] as! String
                    let firstName = responseDict["first_name"] as! String
                    let lastName = responseDict["last_name"] as! String
                    let email = responseDict["email"] as! String
                    let gender = responseDict["gender"] as! String
                    let birthday = responseDict["birthday"] as! String
                    let idFb = responseDict["id"] as! String
                    let pictureDict = responseDict["picture"] as! [String:Any]
                    let imageDict = pictureDict["data"] as! [String:Any]
                    let imageUrl = imageDict["url"] as! String
                    let url = URL(string: imageUrl)
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.profileImage.image = image
                    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
                    self.namelabel.text = fullName
                    self.emailLabel.text = email
                    self.genderLabel.text = gender
                    self.DobLabel.text = birthday
                    //print("user id: \(idFb) \n, firstName: \(firstName) \n, fullname: \(fullName) \n, lastname: \(lastName) \n, picture: \(imageUrl) \n, email: \(email)")
            }
            })
        }
    }
    extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
    {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                //use editing here
            }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                //use original image here
                dismiss(animated: true){
                        let photo = SharePhoto()
                        photo.image = originalImage
                        photo.isUserGenerated = true
                        let contents = SharePhotoContent()
                        contents.photos = [photo]
                let shareDialoge = ShareDialog.init(fromViewController: self, content: contents, delegate: self as? SharingDelegate)
                    shareDialoge.mode = .browser
                        shareDialoge.show()
             }
            }
            else if let videoURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            {
                picker.dismiss(animated: true){
                    if UIApplication.shared.canOpenURL(URL(string: "fb://")!)
                    {
                        let shareVideo = ShareVideo()
                        shareVideo.videoURL  = videoURL
                        let content = ShareVideoContent()
                        content.video = shareVideo
                        let shareDialoge = ShareDialog.init(fromViewController: self, content: content, delegate: self as? SharingDelegate )
                        shareDialoge.mode = .browser
                        shareDialoge.show()
                    }else{
                        print("app not installed")
                    }
                }
            }
        }
        

}
