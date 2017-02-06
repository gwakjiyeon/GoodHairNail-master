//
//  AppDelegate.swift
//  test_web_view_001
//
//  Created by sai on 2016/10/04.
//  Copyright © 2016年 sai. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var rootVC:RootViewController!
    var tab1VC:Tab1ViewController!
    var tab2VC:Tab2ViewController!
    var tab3VC:Tab3ViewController!
    var tab4VC:Tab4ViewController!
    
    //ログ出力用ワード
    private let tag = A0_Prefix().tag_AppDelegate___
    
    private let username_Push_string = A0_Prefix().username_Push
    private let password_Push_string = A0_Prefix().password_Push
    
    //********** APIキーの設定 **********
    let applicationkey = ""
    let clientkey      = ""
    
    let gcmMessageIDKey = "gcm.message_id"
    
   //テスト
   var message:String?

    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(tag+"デバイストークンの要求を開始します。")
        
        //NCMB.setApplicationKey(applicationkey, clientKey: clientkey)
        
//        // デバイストークンの要求
//        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1){
//            
//            print(tag+"iOS_8以上を確認しました。")
//            /** iOS8以上 **/
//            //通知のタイプを設定したsettingを用意
//            let type : UIUserNotificationType = [.alert, .badge, .sound]
//            let setting = UIUserNotificationSettings(types: type, categories: nil)
//            //通知のタイプを設定
//            application.registerUserNotificationSettings(setting)
//            //DevoceTokenを要求
//            application.registerForRemoteNotifications()
//            print(tag+"DevoceTokenを要求しました。")
//        }
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        
        FIRApp.configure()
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)

        

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print(tag+"applicationWillResignActiveが呼び出されました。")
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print(tag+"applicationDidEnterBackgroundが呼び出されました。")
        
    }
 
    
    // [START disconnect_from_fcm]
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print(tag+"applicationWillEnterForegroundが呼び出されました。")
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    // [END disconnect_from_fcm]


    // [START connect_on_active]
    func applicationDidBecomeActive(_ application: UIApplication) {
         print(tag+"applicationDidBecomeActiveが呼び出されました。")
        connectToFcm()
        application.applicationIconBadgeNumber = 0
    }
    // [END connect_on_active]
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print(tag+"applicationWillTerminateが呼び出されました。")
        
    }
    
    
    
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.

    // Push通知の登録が完了した場合、deviceTokenが返される
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)

        
        print(tag+"Push通知の登録が完了しdeviceTokenが返されました　サイズ確認(32 bytesなら正常）："+String(describing: deviceToken))
        
        /*
        
        //deviceTokenを16進数文字列（64文字）に変換します。
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        
        print(tag+"Push通知の登録が完了しdeviceTokenが返されました　16進数文字列（64文字）に変換　："+token)
        
    
        
        //デバイストークンをサーバに送信し、登録する
        //キー「device_token」にtokenを設定します。Swiftでは「\()」を使用することでStringの途中に他の情報を入れることができます。
        let postString = "device_token=\(token)"
    
        
        //PUsh通知のアドレスにユーザー名とパスワードを組み込みます。
        let str_push:String = A0_Prefix().url_push_server_Register
        
        //まず、アドレスから「http://」以降のテキストを分割します。以下のコードでは arr_push[0]は　空白　となり　arr_push[1]にその他のテキストが記入されます。
        let arr_push:[String] = str_push.components(separatedBy: "http://")
        print(tag+"Push通知　トークン登録用アドレスをhttp://で分割した内容:"+arr_push[1])
        
        //トークン登録用最終アドレスを整形します。
        let last_push_adress_check:String = "http://"+username_Push_string+":"+password_Push_string+"@"+arr_push[1]
        print(tag+"Push通知　トークン登録用最終アドレス:"+last_push_adress_check)

        //requestにトークン登録用最終アドレスを設定しあｍす。
        var request = URLRequest(url: URL(string:last_push_adress_check)!)
        
    
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(self.tag+"エラーが発生しています。")
                
                print(error)
                return
            }
            
            print(self.tag+"response: \(response!)")
            
            let phpOutput = String(data: data!, encoding: .utf8)!
            print(self.tag+"php output: \(phpOutput)")
        })
        task.resume()
        
        
        
        
        
        /*
         通信が終了したときに呼び出されるデリゲート.
         */
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            // 帰ってきたデータを文字列に変換.
            let getData:NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
            
            
            print(tag+"帰ってきたデータを文字列に変換し表示します。："+(getData as String))
            
            
        }
        
        /*
         バックグラウンドからフォアグラウンドの復帰時に呼び出されるデリゲート.
         */
        func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
            print(tag+"URLSessionDidFinishEventsForBackgroundURLSessionが呼び出されました。")
        }
         */
    }
    
    
    
    // Push通知が利用不可であればerrorが返ってくる
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(tag+"didFailToRegisterForRemoteNotificationsWithErrorが呼び出されました。 Push通知が利用不可のようです。")
        print(tag+"error: " + "\(error.localizedDescription)")
    }
    
    
//    // Push通知受信時とPush通知をタッチして起動したときに呼ばれる
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        switch application.applicationState {
//        case .inactive:
//            // アプリがバックグラウンドにいる状態で、Push通知から起動したとき
//            print(tag+"アプリがバックグラウンドにいる状態で、Push通知から起動を行いました。")
//            
//            break
//        case .active:
//            // アプリ起動時にPush通知を受信したとき
//            print(tag+"アプリ起動時にPush通知を受信しました。")
//            
//            break
//        case .background:
//            // アプリがバックグラウンドにいる状態でPush通知を受信したとき
//            print(tag+"アプリがバックグラウンドにいる状態でPush通知を受信しました。")
//            
//            break
//        }
//    }
    
    
    
    
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        print("didReceiveRemoteNotification1")
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID 1: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        print("didReceiveRemoteNotification2")
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID 2: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            // [START subscribe_topic]
            FIRMessaging.messaging().subscribe(toTopic: "/topics/allDevice")
            print("Subscribed to allDevice topic")
            // [END subscribe_topic]
            
            
            //デバイストークンをサーバに送信し、登録する
            //キー「device_token」にtokenを設定します。Swiftでは「\()」を使用することでStringの途中に他の情報を入れることができます。
            let postString = "device_token=\(refreshedToken)"
            
            
            //PUsh通知のアドレスにユーザー名とパスワードを組み込みます。
            let str_push:String = A0_Prefix().url_push_server_Register
            
            //まず、アドレスから「http://」以降のテキストを分割します。以下のコードでは arr_push[0]は　空白　となり　arr_push[1]にその他のテキストが記入されます。
            let arr_push:[String] = str_push.components(separatedBy: "http://")
            print(tag+"Push通知　トークン登録用アドレスをhttp://で分割した内容:"+arr_push[1])
            
            //トークン登録用最終アドレスを整形します。
            let last_push_adress_check:String = "http://"+username_Push_string+":"+password_Push_string+"@"+arr_push[1]
            print(tag+"Push通知　トークン登録用最終アドレス:"+last_push_adress_check)
            
            //requestにトークン登録用最終アドレスを設定しあｍす。
            var request = URLRequest(url: URL(string:last_push_adress_check)!)
            
            
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    
                    print(self.tag+"エラーが発生しています。")
                    
                    print(error ?? "error defualt value")
                    return
                }
                
                print(self.tag+"response: \(response!)")
                
                let phpOutput = String(data: data!, encoding: .utf8)!
                print(self.tag+"php output: \(phpOutput)")
            })
            task.resume()
            

        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
   
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID app neelttei uyd: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID notifi click uyd: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]



