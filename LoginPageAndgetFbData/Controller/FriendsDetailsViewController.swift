//
//  FriendsDetailsViewController.swift
//  LoginPageAndgetFbData
//
//  Created by Mac on 30/07/20.
//  Copyright © 2020 Gunde Ramakrishna Goud. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare
import FBSDKShareKit
import FBSDKLoginKit

class FriendsDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var friends = [Friends]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if(AccessToken.current != nil) {
//        self.showFriends()
        }else {
        }
        self.showFriends()

        // Do any additional setup after loading the view.
    }

    func showFriends()
        {
    //        let graphRequest : GraphRequest = GraphRequest(graphPath: "me/friends", parameters: ["fields": "id,name,picture"])
    //        graphRequest.start( completionHandler: { (connection, result, error) -> Void in
    //
    //                   if ((error) != nil)
    //                   {
    //
    //                       print("Error: \(error)")
    //                       return
    //                   }
    //                   else
    //                   {
    //                    print(result!)


    //                    let friends = result.
    //                       var count = 1
    //                       if let array = friends as? [NSDictionary] {
    //                           for friend : NSDictionary in array {
    //                               let name = friend.valueForKey("name") as! String
    //                               frindsFromGlobal.append(name)
    //                               count++
    //                           }
    //                       }


                       //}
           // })
            
//            let fbLoginManager : LoginManager = LoginManager()
//            fbLoginManager.loginBehavior = LoginBehavior.browser
//            fbLoginManager.logIn(permissions: ["email","user_friends","public_profile"], from: self) { (result, error) in
//              if (error == nil) {
//                   print(result)
//                let fbloginresult : LoginManagerLoginResult = result!
//                  if fbloginresult.grantedPermissions != nil {
//                      if (fbloginresult.grantedPermissions.contains("email")) {
//                          // Do the stuff
//                      }
//                      else {
//                      }
//                  }
//                  else {
//                  }
//              }
//                if ((AccessToken.current) != nil) {
//                       GraphRequest(graphPath: "/me/friends", parameters: ["fields" : "id,name"]).start(completionHandler: { (connection, result, error) -> Void in
//                                                 if (error == nil) {
//
//                                                     print(result!)
//                                                 }
//                                             })
//                                         }
//          }
//
//
            let myGraphRequest = GraphRequest(graphPath: "me/friends", parameters: ["fields": "id,name,picture"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: .get)
                      myGraphRequest.start(completionHandler: { (connection, result, error) in
                        
                        if ((error) != nil)
                                           {
                        
                                               print("Error: \(error)")
                                               return
                                           }
                                           else
                                           {
                                            print(result!)
                        }
            })
          
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return friends.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            cell.nameLabel.text = friends[indexPath.row].name
            
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65
        }

}
