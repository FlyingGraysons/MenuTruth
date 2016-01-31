//
//  Menu.swift
//  MenuTruthiOS
//
//  Created by Bradley May on 1/31/16.
//  Copyright © 2016 Henry. All rights reserved.
//

import Foundation
import UIKit
class Menu:UIViewController, UITableViewDataSource{
    var place:GMSPlace!
     var list=[String: String]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=UITableViewCell()
        
        cell.textLabel?.text=(NSDictionary(dictionary: list).allKeys as! [String])[indexPath.item]+"\t($"+list[(NSDictionary(dictionary: list).allKeys as! [String])[indexPath.item]]!+")\t"
        
        
        
        //find calories
        cell.textLabel?.font=UIFont(name: "Avenir-Light", size: 15)
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: "https://www.fatsecret.com/calories-nutrition/search?q=\((NSDictionary(dictionary: list).allKeys as! [String])[indexPath.item])".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!), queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            
            var string=NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
             var textScanner = NSScanner(string: string)
            
            textScanner.scanUpToString("Calories:", intoString: nil)
            
            var toString:NSString?="";
            textScanner.scanUpToString("kcal", intoString: &toString)
            
            if(toString==""){
                
            }else{
            toString=toString?.substringFromIndex(9)
            cell.textLabel?.text=(cell.textLabel?.text)!+(toString! as String)+"kcal"
                print(toString)
                if(toString!.intValue>1000){
                    toString="1000"
                }
                
                if(toString?.intValue==0){
                    toString="1";
                }
                print(toString!.floatValue)
                print(toString!.intValue)
                
                
               // cell.textLabel?.textColor=UIColor(hue: (1-CGFloat((toString!.floatValue)/Float(1000)))/2, saturation: 1, brightness: 1, alpha: 1)
                cell.backgroundColor=UIColor(red: 1, green: 0, blue: 0, alpha: CGFloat((toString!.floatValue)/Float(1000)))
            }
            
            
        }
        return cell;
    }
    
    
    

    @IBOutlet weak var Table: UITableView!
    func initiate(place: GMSPlace){
        self.place=place
   
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        Table.dataSource=self
        var url = NSURL(string: "https://api.locu.com/v1_0/venue/search/?location=\(place.coordinate.latitude),\(place.coordinate.longitude)&name=\(place.name)&api_key=5ab45ec1d07a8febdf0d0880730996e67ea4086c".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        if(url==nil){
            print("NOURL")
        }
        print(url?.absoluteString)
        
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url!), queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            do{
                var parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                
                //print(((parsedData["objects"] as! NSArray)[0] as! NSDictionary)["id"] as! NSString)
                
                
                if((parsedData["objects"] as! NSArray).count>0){
                if(((parsedData["objects"] as! NSArray)[0] as! NSDictionary)["has_menu"] as! Bool==false){
                    
                    var alert=UIAlertView(title: "Sorry", message: "This restaurant's menu is not available", delegate: nil, cancelButtonTitle: "OK")
                   alert.show()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    
                    
                }else{
                
                var request2=NSMutableURLRequest(URL: NSURL(string: "https://api.locu.com/v2/venue/search")!)
                
                var dataInside="{\"api_key\" : \"5ab45ec1d07a8febdf0d0880730996e67ea4086c\",\"fields\" : [ \"menus\" ],\"venue_queries\" : [{\"locu_id\" : \"\(((parsedData["objects"] as! NSArray)[0] as! NSDictionary)["id"] as! NSString)\"}]}".dataUsingEncoding(NSUTF8StringEncoding)
                
                request2.HTTPMethod="POST"
                request2.HTTPBody=dataInside
                
                
                NSURLConnection.sendAsynchronousRequest(request2, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                    
                    
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    
                    
                    
                    
                    do{
                        var parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        for menu in (((parsedData["venues"] as! NSArray)[0] as! NSDictionary)["menus"] as! NSArray){
                            for section in (menu as! NSDictionary)["sections"] as! NSArray{
                                
                                
                                var num=0;
                                for subsection in ((section as! NSDictionary)["subsections"] as! NSArray){
                                    
                                    for content in ((subsection as! NSDictionary)["contents"] as! NSArray){
                                        
                                        if(num==0){
                                            
                                        }else{
                                            if((((content as! NSDictionary).allKeys) as! [NSString]).contains("name")){
                                                print((content as! NSDictionary)["name"] as! NSString)
                                                
                                                if((((content as! NSDictionary).allKeys) as! [NSString]).contains("price")){
                                                    print((content as! NSDictionary)["price"] as! NSString)
                                                    
                                                    self.list[((content as! NSDictionary)["name"] as! NSString) as String]=((content as! NSDictionary)["price"] as! NSString) as String
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        num++;
                                    }
                                }
                                
                                
                            }
                        }
                        self.Table.reloadData()
                    }catch{
                        
                    }
                    
                    
                })
                
                
                    }}else{
                    
                    var alert=UIAlertController(title: "Sorry", message: "We Don't Support this Place", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }catch{
                
                
                
            }
            
            
            
            
            
            
            
            
        }

    }
    
    
}