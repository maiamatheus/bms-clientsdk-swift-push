/*
*     Copyright 2015 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/

import XCTest

@testable import BMSPush
import BMSCore

class testBMSPushClient: XCTestCase {
    
    // MARK: Register device
    
    var expectation:XCTestExpectation?
    var responseHasArrived:Bool = false
    var timeoutDate = NSDate(timeIntervalSinceNow: 30.0)
    
    func testRegister () {
        
        BMSClient.sharedInstance.initializeWithBluemixAppRoute("http://sdktestdonotdelete.mybluemix.net", bluemixAppGUID: "e1ddf4f7-63b2-4df3-9e20-39e408f816e6", bluemixRegion: BMSClient.REGION_US_SOUTH)
        
        let clientInstance = BMSPushClient.sharedInstance
        let string = "46f5b4fde98a7013ebeb189a3be65e585fc7eccd310af99359c7c6b40b25d267"
        //XCTAssertEqual(string,"46f5b4fde98a7013ebeb189a3be65e585fc7eccd310af99359c7c6b40b25d267")
        let token = string.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientInstance.registerDeviceToken(token!,completionHandler:  { (response, statusCode, error) -> Void in
            
            
            NSLog("the status code for registartion is \(statusCode)");
            
            if error.isEmpty{
                
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(statusCode)")
            }
            else {
                
                print( "Error during device registration \(error) ")
                XCTFail("Failed to register")
            }
            
            self.responseHasArrived = true
        })
        
        
        while (responseHasArrived == false && (timeoutDate.timeIntervalSinceNow > 0)){
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true)
        }
        if responseHasArrived {
            
            NSLog("Success Execution")
        }
        else{
            XCTFail("Test timed out");
        }
    }
    
    func testSubscribeToTags () {
        
        
        let clientInstance = BMSPushClient.sharedInstance
        
        var tagsArray = NSMutableArray()
        
        // self.responseHasArrived = false
        
        clientInstance.retrieveAvailableTagsWithCompletionHandler { (response, statusCode, error) -> Void in
            
            NSLog("the status code for retrieving available tags is \(statusCode)");
            
            if error.isEmpty{
                
                print( "Response during retrive tags : \(response)")
                
                print( "status code during retrieve tags : \(statusCode)")
                
                
                if let tags = response {
                    
                    tagsArray = tags
                    NSLog("\n\n\n\nTgas array \(tagsArray)\n\n\n")
                }
                
            }
            else {
                print( "Error during retrieve tags \(error) ")
                XCTFail("Failed to get tags")
            }
            
            self.responseHasArrived = true
        }
        
        
        while (responseHasArrived == false && (timeoutDate.timeIntervalSinceNow > 0)){
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true)
        }
        if responseHasArrived && (tagsArray.count > 0) {
            
            NSLog("Success Execution")
            
            self.responseHasArrived = false
            
            clientInstance.subscribeToTags(tagsArray) { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    print( "Response during Subscribing to tags : \(response?.description)")
                    
                    print( "status code during Subscribing tags : \(statusCode)")
                }
                else {
                    print( "Error during subscribing tags \(error) ")
                    XCTFail("Failed to subscribe tags")
                }
                
                self.responseHasArrived = true
            }
            
            
            while (responseHasArrived == false && (timeoutDate.timeIntervalSinceNow > 0)){
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true)
            }
            if responseHasArrived {
                
                NSLog("Success Execution")
            }
            else{
                XCTFail("Test timed out");
            }
            
        }
        else{
            if tagsArray.count == 0 {
                XCTFail("Emty tag array");
                
            }
            else {
                XCTFail("Test timed out");
            }
        }
    }
    
    func testUnregisterDevice () {
        
        // MARK: retrieve subscibed tags
        
        BMSClient.sharedInstance.initializeWithBluemixAppRoute("http://sdktestdonotdelete.mybluemix.net", bluemixAppGUID: "e1ddf4f7-63b2-4df3-9e20-39e408f816e6", bluemixRegion: BMSClient.REGION_US_SOUTH)
        let clientInstance = BMSPushClient.sharedInstance
        
        var tagsArray = NSMutableArray()
        
        clientInstance.retrieveSubscriptionsWithCompletionHandler { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during retrieving subscribed tags : \(response)")
                
                print( "status code during retrieving subscribed tags : \(statusCode)")
                
                if let tags = response {
                    
                    tagsArray = tags
                }
                
            }
            else {
                print( "Error during retrieving subscribed tags \(error) ")
                XCTFail("Failed to etrieving subscribed tags")
            }
            
            self.responseHasArrived = true
        }
        
        
        while (responseHasArrived == false && (timeoutDate.timeIntervalSinceNow > 0)){
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true)
        }
        if responseHasArrived {
            
            NSLog("Success Execution")
            
            // MARK: Unsubscribe from tags
            
            self.responseHasArrived = false
            
            clientInstance.unsubscribeFromTags(tagsArray) { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    print( "Response during unsubscribing tags : \(response?.description)")
                    
                    print( "status code during unsubscribing tags : \(statusCode)")
                }
                else {
                    print( "Error during  unsubscribing tags \(error) ")
                    XCTFail("Failed to unsubscribing tags")
                }
                
                self.responseHasArrived = true
            }
            
            
            while (responseHasArrived == false && (timeoutDate.timeIntervalSinceNow > 0)){
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true)
            }
            if responseHasArrived {
                
                NSLog("Success Execution")
                
                // MARK: Unregister device
                self.responseHasArrived = false
                
                clientInstance.unregisterDevice { (response, statusCode, error) -> Void in
                    
                    if error.isEmpty {
                        
                        print( "Response during unregistering device : \(response)")
                        
                        print( "status code during unregistering device : \(statusCode)")
                    }
                    else {
                        print( "Error during unregistering device \(error) ")
                        XCTFail("Failed to unregistering  device")
                    }
                    
                    self.responseHasArrived = true
                }
                
                
                while (responseHasArrived == false && (timeoutDate.timeIntervalSinceNow > 0)){
                    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true)
                }
                if responseHasArrived {
                    
                    NSLog("Success Execution")
                }
                else{
                    XCTFail("Test timed out");
                }
            }
            else{
                XCTFail("Test timed out");
            }
            
        }
        else{
            XCTFail("Test timed out");
        }
    }
    
    
}
