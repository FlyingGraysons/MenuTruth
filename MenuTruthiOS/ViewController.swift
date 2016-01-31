//
//  ViewController.swift
//  MenuTruthiOS
//
//  Created by Henry on 1/31/16.
//  Copyright © 2016 Henry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // print(locations[0])
        CLGeocoder().reverseGeocodeLocation(locations[0]) { (placemark, error) -> Void in
            let pm:[CLPlacemark] = placemark! as [CLPlacemark]
            var lines:NSArray=pm[0].addressDictionary!["FormattedAddressLines"] as! NSArray;
            print(lines.componentsJoinedByString(", "))
        }
        
        
        
        
        
    }
    func refresh(){
        Table.reloadData()
        
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.description)
    }
    var list=[GMSPlace]();
    
    
    func GoToOne(){
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=UITableViewCell();
        
        if(indexPath.item==0){
            var place=list[indexPath.item];
            NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(list[indexPath.item].placeID)&key=AIzaSyDXCHr_HRaLUX8ZDLJ0jvkuSv_e0GoJ-Is")!), queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                do{
                    var parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    
                    
                    var textView=UITextView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 500)))
                    textView.backgroundColor=UIColor.clearColor()
                    textView.textColor=UIColor.redColor()
                    textView.editable=false;
                    textView.textAlignment=NSTextAlignment.Center
                    textView.font=UIFont(name: "Arial", size: 50)
                   
                    
                    
                    if(place.rating==0){
                        textView.text="\(place.name)\n"
                    }else{
                        textView.text="\(place.name)"
                    }
                    
                    
                    
                    cell.addSubview(textView)
                    //
                    var textView2=UITextView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 500)))
                    textView2.backgroundColor=UIColor.clearColor()
                    textView2.textColor=UIColor.redColor()
                    textView2.editable=false;
                    textView2.textAlignment=NSTextAlignment.Center
                    textView2.font=UIFont(name: "Arial", size: 25)
                    
                    
                    
                    if(place.rating==0){
                        textView2.text="\n\n\n\n\n\n\n\nPhoneNumber:\(place.phoneNumber)\n"
                    }else{
                        textView2.text="\n\n\n\n\n\n\n\n\(place.name)\nPhoneNumber:\(place.phoneNumber)\nRating:\(place.rating)/5"
                    }
                    
                    
                    
                    cell.addSubview(textView2)

                    
                    
                    var button=UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width/2-(self.view.frame.width/4), y: 400), size: CGSize(width: self.view.frame.width/2, height: 50)))
                    button.setTitle("Show Menu", forState: UIControlState.Normal)
                    button.backgroundColor=UIColor.whiteColor()
                    button.layer.cornerRadius=20;
                    button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                    button.layer.borderColor=UIColor.blueColor().CGColor
                    button.layer.borderWidth=3;
                    button.addTarget(self, action: "GoToOne", forControlEvents: UIControlEvents.TouchUpInside)
                    cell.addSubview(button)
                    
                    
                    if (((parsedData["result"] as! NSDictionary).allKeys as! [NSString]).contains("photos")){
                        if (((parsedData["result"] as! NSDictionary)["photos"] as! NSArray).count>0){
                            //(((parsedData["result"] as! NSDictionary)["photos"] as! NSArray)[0] as! NSDictionary)["photo_reference"]
                            print("https://maps.googleapis.com/maps/api/place/photo?photoreference=\((((parsedData["result"] as! NSDictionary)["photos"] as! NSArray)[0] as! NSDictionary)["photo_reference"])&sensor=false&maxheight=1600&maxwidth=1600&key=AIzaSyDXCHr_HRaLUX8ZDLJ0jvkuSv_e0GoJ-Is")
                            NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?photoreference=\((((parsedData["result"] as! NSDictionary)["photos"] as! NSArray)[0] as! NSDictionary)["photo_reference"]!)&sensor=false&maxheight=1600&maxwidth=1600&key=AIzaSyDXCHr_HRaLUX8ZDLJ0jvkuSv_e0GoJ-Is")!), queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                                
                                print("final Return")
                                if let image=UIImage(data: data!){
                                    print("its a real iamge")
                                    var imageView=UIImageView(image: image)
                                    imageView.contentMode = .ScaleAspectFill
                                    imageView.frame=CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 500))
                                    cell.insertSubview(imageView, atIndex: 0)
                                    
                                    
                                }
                                
                                
                                
                            })
                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                }catch{
                    
                }
                
                
            })
            
            
            
            
        }else{
            cell.textLabel!.text=list[indexPath.item].name;
            cell.backgroundColor=UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        if((list[indexPath.item].types as! [NSString]).contains("restaurant")){
            cell.backgroundColor=UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 0.5)
        }
        
        return cell;
        
        
        
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.item==0){
            return 500
        }else{
            return 40
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count;
    }
    @IBOutlet weak var Table: UITableView!
    func again(){
         list=[GMSPlace]()
        GMSPlacesClient().currentPlaceWithCallback {(placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            print("IM BACK")
            if let placeLikelihoodList=placeLikelihoodList{
                for p in placeLikelihoodList.likelihoods{
                    if let likelihood = p as? GMSPlaceLikelihood {
                        let place = likelihood.place
                        //print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                        // if((place.types as! [NSString]).contains("restaurant")){
                        
                        self.list.append(place)
                        //}
                        self.refresh();
                        
                        
                    }
                    
                    
                }
            }}
    }
    override func viewDidLoad() {
        
        
        
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "again")
        Table.dataSource=self;
        Table.delegate=self;
        manager.requestAlwaysAuthorization()
        GMSServices.provideAPIKey("AIzaSyBW5Fw8mRDuMKbOi4gEncmEeFZRg3v35w0")
        GMSPlacesClient().currentPlaceWithCallback {(placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            print("IM BACK")
            if let placeLikelihoodList=placeLikelihoodList{
                for p in placeLikelihoodList.likelihoods{
                    if let likelihood = p as? GMSPlaceLikelihood {
                        let place = likelihood.place
                        //print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                        // if((place.types as! [NSString]).contains("restaurant")){
                        
                        self.list.append(place)
                        //}
                        self.refresh();
                        
                        
                    }
                    
                    
                }
            }}
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        manager.delegate=self
        
        if(!(CLLocationManager.authorizationStatus().hashValue==4||CLLocationManager.authorizationStatus().hashValue==0)){
            manager.requestLocation()
            
        }else{
            
            print("DECLINED")
        }
        
        
        
        
        
    }
    var manager=CLLocationManager()
}