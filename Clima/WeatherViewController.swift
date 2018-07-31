//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation // 1. Import the module/framework that allows you to tap into the GPS functionality of the device.
import Alamofire // 8. Import the module/framework that allows you to send a http request to web servers.
import SwiftyJSON //

// 2. Add the CLLocationManagerDelegate protocol. This makes the WeatherViewController subclass comforms to the rules of the CLLocationManagerDelegate. Now the subclass can handle location data.
class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "5ffb3a5902fd87537287ad950dad42e5"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager() // 3. Create the location manager object. With this manager, we can set our WeatherViewController subclass as the core location delegate, get the GPS data etc.

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self // 4. Access the delegate property of the location manager. Set it to self. This now makes the WeatherViewController subclass the delegate i.e. "ambassador" of the location manager. We must first do this to be able to get GPS data etc.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // 5. Set the accuracy of the GPS signal. First think of what your app needs. For example a weather app doesn't need to be as accurate as a sport app (turn-by-turn navigations, nearest 5 meters) that tries to trace every single movement of the user.
        locationManager.requestWhenInUseAuthorization() // 6. Set the method that ask the user for authorization. For this method to popup the "allow authorization message", you need to edit the property list.
        locationManager.startUpdatingLocation() // 7.1. Set the asynchronous method that starts the process (in the background) where the location manager starts looking for the GPS coordinates.
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    // 10. Create the getWeatherData method. This method will use Alamofire to make a HTTP request to the web server and handle the response from the web server.
    func getWeatherData(url: String, parameters: [String : String]) {
        // Use the Alamofire request method with the parameters for the HTTP request. You use the "get request" for requesting data.
        // This Alamofire request is asynchrone
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in // Once the HTTP request is complete, it responds with some data and the method checks if the response (using a closure) result is success or otherwise.
            if response.result.isSuccess {
                print("Succes! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!) // 11. Assign the response/value you get from the Alamofire request to a constant of type JSON.
                self.updateWeatherData(json: weatherJSON) // 12.2 Call the method that updates the specified weather data.
            
                
            } else {
                print("Error \(response.result.error!)")
                self.cityLabel.text = "Connection Issues" // Allow the user to know if there are issues. Must use "self" because we are in a closure.
            }
        }
        
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
    // 12.1 Create a method that will use the weatherJSON constant from step 11 as its parameter to specify the weather data you only need.
    func updateWeatherData(json: JSON) {
        
        let tempResult = json["main"]["temp"]
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    // 7.2. This method gets activated once the location manager has found a location with the startUpdatingLocation() method in step 7.1.
    // https://www.udemy.com/ios-11-app-development-bootcamp/learn/v4/t/lecture/7556122?start=195
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1] // 7.2.1 Get the last position in the array that gathers the locations founded by the startUpdatingLocation() method. The last position is most likely the most accurate position.
        
        if location.horizontalAccuracy > 0 { // 7.2.2 Check if the value received by the startUpdatingLocation() method is useful
            locationManager.stopUpdatingLocation() // 7.2.3 If the value is useful immediately stop searching for GPS because it drains the battery very quick
            locationManager.delegate = nil // 7.2.4 Immediately stop the delegate from receiving data from the web server
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")// 7.2.4 (Optional, for testing)
            
            // 7.2.5 Construct the parameters for the API.
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let locationParameters: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID] // Call the keys lat, long and appid because the API requiers it.
            
            getWeatherData(url: WEATHER_URL, parameters: locationParameters) // 9. Call the getWeatherData method although it has not been created. Create the method after this step.
            
            
        }
    }
    
    
    //Write the didFailWithError method here:
    // 7.3. This method gets activated if the startUpdatingLocation() method in step 7.1 was unable to retrieve GPS value.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) // 7.3.1
        cityLabel.text = "Location Unavailable" // 7.3.2
        
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


