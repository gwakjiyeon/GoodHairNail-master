//
//  A0_Prefix.swift
//  test_web_view_001
//
//  Created by sai on 2016/10/28.
//  Copyright © 2016年 sai. All rights reserved.
//

import Foundation

//フッターボタンを押した際にWebView表示するアドレス
var URL_TAB1:String = "http://apritest.fanfan.in/tab1"
var URL_TAB2:String = "http://apritest.fanfan.in/tab2"
var URL_TAB3:String = "http://apritest.fanfan.in/tab3"
var URL_TAB4:String = "http://apritest.fanfan.in/tab4"
var POPUP_STATE = "once"  //always, once, none
var STAMP_SHOW = true   // stamp and anket button show, hide  true , false
//アンケートURL
var URL_ENQUETE:String = "http://apritest.fanfan.in/tab1"
let URL_JSON = "http://sai.vc/111.json"


class A0_Prefix{
    
    // header back button show/hide
    let show_back_tab1:Bool = true
    let show_back_tab2:Bool = true
    let show_back_tab3:Bool = true
    let show_back_tab4:Bool = true
    
       //パノラボ画像「360VR」の有無
    let VR360_select_Status:String = "Use the VR360"//360VRデータを使用します。
    //internal let VR360_select_Status:String = "Do not use the VR360"//360VRデータを使用しません
    
    //360VRテスト用アドレス
    let url_headerSpace:String = "http://static.panolabo.com/74/692/93413160016102/index.html"
    

    //ログ出力用各クラスの名前
    let tag_ViewController:String = "ViewController:"
    let tag_A0_Prefix     :String = "A0_Prefix_____:"
    let tag_A2_SecondViewC:String = "A2_SecondViewC:"
    let tag_A3_A3_ThirdVie:String = "A3_ThirdViewCo:"
    let tag_AppDelegate___:String = "AppDelegate___:"
    
    
    //電話の使用・未使用
    let phone_check:String = "used_phone"
    //internal let phone_check:String = "unused_phone"
    
    
    //電話番号：通常、ヘッダータブ4ボタンで使用されます。
    let phone_number:String = "090-9950-1018"
    
    
    //アプリ内部で表示させたいアドレス
    //使用しない部分には"nil"を記載します。
    let url_base_App_Internal_Action1:String = "http://apritest.fanfan.in/"
    let url_base_App_Internal_Action2:String = "http://static.panolabo.com/"
    let url_base_App_Internal_Action3:String = "nil"
    let url_base_App_Internal_Action4:String = "nil"
    
    
    //WebView表示を「アプリ外に強制的に送る（外部Webビューワー作動）」ための判定アドレスを記載します。
    //例えば、WordPressでお客様HPにリンクを張り、外部Webビューワーで動作させたい場合に使用します。
    //使用しない部分には"nil"を記載します。
    let url_base_App_External_Action1:String = "nil"
    let url_base_App_External_Action2:String = "nil"
    let url_base_App_External_Action3:String = "nil"
    let url_base_App_External_Action4:String = "nil"
    
    //ユーザーエージェント
    internal let userAgent:String = "Sai corp"

    
    //Push通知関連の設定
    let username_Push:String = "saitestygugujjkvg17587587"
    let password_Push:String = "5678818jhfggkugyiuuihoki"
    
    //Push通知で使用するSAI株式会社データベースの登録用PHPのアドレスを記載します。
    let url_push_server_Register:String = "http://sai.vc/push_sai001Beautyofthesample2_fanfan_in/global/register.php"
    //http://token-uuid/register.php

}
