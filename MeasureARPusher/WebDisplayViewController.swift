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

struct Floorplan: Codable {
    var plan: [Room]
    
    enum CodingKeys: String, CodingKey {
        case plan
    }
}


struct Room: Codable {
    var name: String
    var points: [Point]
    
    enum CodingKeys: String, CodingKey {
        case name
        case points
    }
}

struct Point: Codable {
    var x : Int
    var y : Int
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
}

class WebDisplayViewController: UIViewController, WKScriptMessageHandler{

    //var webView: WKWebView
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()

        
        let jsonData = readJSONFromFile(fileName: "data") as! Floorplan
        
        for i in jsonData.plan {
            for j in i.points {
                print (j.x)
                print (j.y)
            }
        }
        
        // "{\"kitchen\":[{\"x\":105,\"y\":105},{\"x\":300,\"y\":105},{\"x\":300,\"y\":210},{\"x\":105,\"y\":210},{\"x\":105,\"y\":105}]}"
        
        let userScript = WKUserScript(source: "var jsonString='\(data as! String)';drawRoom(jsonString);", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        contentController.addUserScript(userScript)
        
        self.edgesForExtendedLayout = []
        
        config.userContentController = contentController
        self.webView = WKWebView(frame: self.view.bounds
            , configuration: config)
        self.view = self.webView!
        
    }
    
    func concat<T1, T2>(a: T1, b: T2) -> String {
        return "\(a)" + "\(b)"
    }
    
    @IBAction func onSave(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func readJSONFromFile(fileName: String) -> Any?
    {
        var json: Floorplan?
        var jsonDecoder = JSONDecoder()
        if let path = Bundle.main.path(forResource: fileName, ofType: "json", inDirectory: "website") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl)
                json = try jsonDecoder.decode(Floorplan.self, from: data)
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
