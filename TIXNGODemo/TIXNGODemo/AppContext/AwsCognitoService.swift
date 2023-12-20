//
//  AwsCognitoService.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import Foundation
import AWSCognitoIdentityProvider

class AwsCognitoService: NSObject {
    static var instance: AwsCognitoService?
    private let timeout: TimeInterval = 15
    private var pool: AWSCognitoIdentityUserPool
    
    init(region: AWSRegionType, clientId: String, poolId: String) {
        let serviceConfiguration = AWSServiceConfiguration(region: region, credentialsProvider: nil)
        serviceConfiguration!.maxRetryCount = 0
        serviceConfiguration!.timeoutIntervalForRequest = timeout
        serviceConfiguration!.timeoutIntervalForResource = timeout
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: clientId, clientSecret: nil, poolId: poolId)
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: "userPool")
        pool = AWSCognitoIdentityUserPool.init(forKey: "userPool")!
        super.init()
        pool.delegate = self
    }
    
    func login(_ username: String, password: String, completion: @escaping (_ error: Error?, _ token: String?) -> Void) {
        pool.getUser().getSession(username, password: password, validationData: nil).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                completion(task.error, task.result?.idToken?.tokenString)
            }
            return task
        }
    }
    
    func signup(_ username: String, password: String, completion: @escaping (_ error: Error?, _ codeDeliveryDetails: AWSCognitoIdentityProviderCodeDeliveryDetailsType?) -> Void) {
        pool.signUp(username, password: password, userAttributes: nil, validationData: nil).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                completion(task.error, task.result?.codeDeliveryDetails)
            }
            return task
        }
    }
    
    func confirmSignUp(_ username: String, code: String, completion: @escaping (_ error: Error?) -> Void) {
        pool.getUser(username).confirmSignUp(code).continueWith{ (task) -> Any? in
            DispatchQueue.main.async {
                completion(task.error)
            }
            return task
        }
    }
    
    func forgotPassword(_ username: String, completion: @escaping (_ error: Error?, _ codeDeliveryDetails: AWSCognitoIdentityProviderCodeDeliveryDetailsType?) -> Void) {
        pool.getUser(username).forgotPassword().continueWith{ (task) -> Any? in
            DispatchQueue.main.async {
                completion(task.error, task.result?.codeDeliveryDetails)
            }
            return task
        }
    }
    
    func confirmForgotPassword(_ username: String, code: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        pool.getUser(username).confirmForgotPassword(code, password: password).continueWith{ (task) -> Any? in
            DispatchQueue.main.async {
                completion(task.error)
            }
            return task
        }
    }
    
    func getToken(_ completion: @escaping (_ error: Error?, _ token: String?) -> Void) {
        if let currentUser = self.pool.currentUser() {
            currentUser.getSession().continueWith(block: { (task) -> Any? in
                DispatchQueue.main.async {
                    completion(task.error, task.result?.idToken?.tokenString)
                }
                return task
            })
        } else {
            completion(NSError.init(domain: AWSCognitoIdentityProviderErrorDomain, code: 404, userInfo: ["message": "User not found"]), nil)
        }
    }
}

extension AwsCognitoService: AWSCognitoIdentityCustomAuthentication, AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func getCustomChallengeDetails(_ authenticationInput: AWSCognitoIdentityCustomAuthenticationInput, customAuthCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>) {
        
    }
    
    func didCompleteStepWithError(_ error: Error?) {
        debugPrint("Native ==> \(error?.localizedDescription)")
    }
    
    func startCustomAuthentication() -> AWSCognitoIdentityCustomAuthentication {
        return self
    }
}
