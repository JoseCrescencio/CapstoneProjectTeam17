//
//  WebDisplayViewController.swift
//  MeasureARPusher
//
//  Created by Angel on 4/30/19.
//  Copyright © 2019 Celina. All rights reserved.
//

import UIKit
import WebKit
import Foundation

class WebDisplayViewController: UIViewController, WKScriptMessageHandler{

    var webView: WKWebView?
    var data: Any!
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()

        
//        data = readJSONFromFile(fileName: "data") as! String
        
        data = "{\"kitchen\":[{\"x\":105,\"y\":105},{\"x\":300,\"y\":105},{\"x\":300,\"y\":210},{\"x\":105,\"y\":210},{\"x\":105,\"y\":105}]}"
        
        let userScript = WKUserScript(source: "var jsonString='\(data as! String)';drawRoom(jsonString);", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        contentController.addUserScript(userScript)
        
        
        config.userContentController = contentController
        self.webView = WKWebView(frame: .zero, configuration: config)
        self.view = self.webView!
        
    }
    
    func readJSONFromFile(fileName: String) -> Any?
    {
        var json: Any!
        if let path = Bundle.main.path(forResource: fileName, ofType: "json", inDirectory: "website") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                json = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
            } catch {
                // Handle error here
            }
        }
        return json
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "website")!
        self.webView!.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        self.webView!.load(request)
        
        }
    
        
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if (message.name == "callbackHandler") {
                print("JavaScript is sending a message \(message.body)")
            }
        }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

}
