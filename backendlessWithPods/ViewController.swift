//
//  ViewController.swift
//  backendlessWithPods
//
//  Created by Paul Vana on 4/21/16.
//  Copyright © 2016 Little Chief Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let backendless = Backendless.sharedInstance()
    var currentUser: BackendlessUser?
    let isStayLoggedIn:Bool  = false
    
    class Accounts : NSObject {
        
        var objectId : String?
        var user : String?
        var NumberOrNickname : String?
        var type : String?
        var Balance : Double = 0.00 // must initialize int/double/boolean values or it won't save on the backend
        var InitialBalance : Double = 0.00
    }
    
    class Users : NSObject{
        var objectID : String?
        var email : String?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // var to hold curent user to use
        //var currentUser: BackendlessUser?
        currentUser = backendless.userService.currentUser
        let isStayLoggedIn = backendless.userService.isStayLoggedIn  // var check to see if user it still login
        
        //let user = BackendlessUser()
        
        //user.email = "test@outlook.com"
        //user.password = "1234"
        
        //backendless.userService.registering(user)
        //print("registered")
        
        //loginUserAsync()
        
        // check to see if keep logged in is turned on.
        if isStayLoggedIn == true{
            print("Current user \(currentUser!.email) is still logged in")
        }
        else{
            loginUserAsync()
        }
        
        
        
        //addRecord()
        queryData()
        queryData2()
        singleStepRetrieval()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addRecord(){
        
        let backendless = Backendless.sharedInstance()
        
        
        let newAccount = Accounts()
        newAccount.user = "plv_2002@msn.com"
        newAccount.NumberOrNickname = "Checking3"
        newAccount.type = "Checking"
        newAccount.Balance = 200.05
        newAccount.InitialBalance = 1000.54
        
        backendless.persistenceService.save(newAccount)
        print("Saved Data")
        
        
        
        //        let backendless = Backendless.sharedInstance()
        //        let dataStore = backendless.data.of(Accounts.ofClass())
        //        var error: Fault?
        //
        //        let result = dataStore.findFault(&error)
        //        if error == nil {
        //            let contacts = result.getCurrentPage()
        //            for obj in contacts {
        //                print("\(obj)")
        //            }
        //        }
        //        else {
        //            print("Server reported an error: \(error)")
        //        }
    }
    
    func queryData(){
        
        //let queryAccount = Accounts()
        
        let dataQuery = BackendlessDataQuery()
        
        //dataQuery.queryOptions = queryOptions;
        dataQuery.whereClause = "type = 'Checking'"
        
        let accounts = backendless.persistenceService.find(Accounts.ofClass(), dataQuery:dataQuery) as BackendlessCollection
        for account in accounts.data as! [Accounts] {
            
            print("\(account.NumberOrNickname!)")
        }
        
    }
    
    func queryData2(){
        
        //let queryAccount = Accounts()
        
        let dataQuery = BackendlessDataQuery()
        
        //dataQuery.queryOptions = queryOptions;
        dataQuery.whereClause = "User = '\(currentUser!.email)'" // where clause for data backend
        
        let accounts = backendless.persistenceService.find(Accounts.ofClass(), dataQuery:dataQuery) as BackendlessCollection
        print("Query Data 2***********")
        print("Loaded \(accounts.data.count) for user \(currentUser!.email)")
//        for account in accounts.data as! [Accounts] {
//            
//            print("Loaded \")
//            //print("\(account.NumberOrNickname!)")
//        }
        
    }

    
    
    
    func loginUserAsync() {
        
        //let backendless = Backendless.sharedInstance()
        
        //        backendless.userService.login("test@outlook.com", password:"1234", response: { ( user : BackendlessUser!) -> () in
        //                    print("User has been logged in (ASYNC): \(user)")
        //            },
        //            error: { ( fault : Fault!) -> () in
        //                print("Server reported an error: \(fault)")
        //            }
        //        )
        
        Types.tryblock({ () -> Void in
            
            let user = self.backendless.userService.login("plv_2002@msn.com", password: "1234")
            print("User has been logged in (SYNC): \(user.email)")
            self.backendless.userService.setStayLoggedIn( true )  // this is where I could check to see if they check the box to remember login
            },
                       catchblock: { (exception) -> Void in
                        print("Server reported an error: \(exception as! Fault)")
        })
    }
    
    
    func singleStepRetrieval() {
        
        let dataQuery = BackendlessDataQuery()
        //let queryOptions = QueryOptions()
        //queryOptions.related = ["relAccounts"]
        //queryOptions.addRelated("relAccounts")
        //dataQuery.queryOptions = queryOptions
        dataQuery.whereClause = "email = '\(currentUser!.email)'"
        
        print("Relations   **************'")
        
        var error: Fault?
        let bc = backendless.persistenceService.of(Users.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            let currentAccount = bc.getCurrentPage()
            print("Total Objects \(bc.totalObjects)")
            print("Loaded \(currentAccount.count) acccounts for user \(currentUser!.email!)")
            
            
            for relatedAccount in currentAccount as! [Accounts]{
                print("Account name: \(relatedAccount.NumberOrNickname)" )
                //print("Account name <\(relatedAccount.ofClass())> Balance = \(relatedAccount.Balance)")
            }
            
            //print("Accounts have been retrieved: \(bc.data)")
        }
        else {
            print("Server reported an error: \(error)")
        }
    }


}

