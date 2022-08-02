//
//  ViewController.swift
//  Test
//
//  Created by Miles Wilson on 7/30/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate,MKMapViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var MapView: MKMapView!
    let manager = CLLocationManager()
    let newPin = MKPointAnnotation()
    var jimmy = UIImage()
    var contact = ""
    var desc = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MapView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongTapGesture(gestrueRecognizer:)))
        
        self.MapView.addGestureRecognizer(longTapGesture)
        
    }
    @objc func handleLongTapGesture(gestrueRecognizer: UILongPressGestureRecognizer)
    {
        //var contact = ""
        //var desc = ""
        if gestrueRecognizer.state != UIGestureRecognizer.State.ended
        {
            let touchLocation = gestrueRecognizer.location(in: MapView)
            let locationCoordinate = MapView.convert(touchLocation, toCoordinateFrom: MapView)
            print("Tapped at latitude: \(locationCoordinate.latitude), Longitude:\(locationCoordinate.longitude) )")
            
            let alert = UIAlertController(title: "Pin creation:", message: "Please fill out info about your lost pet", preferredStyle: .alert)
            alert.addTextField { field in
                field.placeholder = "Description of your pet"
            }
            alert.addTextField { field in
                field.placeholder = "Contact information"
            }
            
            alert.addAction(UIAlertAction(title:"Upload image from library", style: .default, handler: {[self] _ in
            let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                
                
                guard let fields = alert.textFields, fields.count == 2 else {
                    return
                }
                let description = fields[0]
                let contactInfo = fields[1]
                desc = description.text ?? ""
                if (description.text == "")
                {
                    return
                }
                contact = contactInfo.text ?? ""
                if(contactInfo.text == "")
                {
                    return
                }
                let myPin = MKPointAnnotation()
                myPin.coordinate = locationCoordinate
                print(desc)
                print("test")
                myPin.title = desc
                //myPin.description =contact
                self.MapView.addAnnotation(myPin)
                present(vc, animated: true)
            }))
             
            
            //alert.addAction(UIAlertAction(title:"Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title:"Submit", style: .default, handler: { [self] _ in
                //read text to var here
                guard let fields = alert.textFields, fields.count == 2 else {
                    return
                }
                let description = fields[0]
                let contactInfo = fields[1]
                desc = description.text ?? ""
                if (description.text == "")
                {
                    return
                }
                contact = contactInfo.text ?? ""
                if(contactInfo.text == "")
                {
                    return
                }
                let myPin = MKPointAnnotation()
                myPin.coordinate = locationCoordinate
                print(desc)
                print("test")
                myPin.title = desc
                //myPin.description =contact
                self.MapView.addAnnotation(myPin)
            }))
            self.present(alert, animated: true, completion: nil)
            
            
        }
            
        if gestrueRecognizer.state != UIGestureRecognizer.State.began
        {
            return
        }
    }
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
        {
            let test = MKPointAnnotation()
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "newsAnnotationView")

                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: test, reuseIdentifier: "test")
                }
            annotationView?.image = UIImage(named: "Bone")
            annotationView?.canShowCallout = true
            return annotationView
        }
     */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    func render(_ location: CLLocation)
    {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        MapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pet"
        var annotationView = MapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        }
        else
        {
            annotationView?.annotation = annotation
        }
        let image = UIImage(named: "bone1.png")
        let resize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(resize)
        image!.draw(in: CGRect(x:0, y:0, width: resize.width, height: resize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let ac = UIAlertController(title: desc, message: "Contact: \(contact)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .default))
        //let imageTitle = UIImage(named: jimmy)
        let imageViewTitle = UIImageView(frame: CGRect(x:0, y:-200, width: 270, height: 200))
        imageViewTitle.image = jimmy
        imageViewTitle.layer.masksToBounds = true
        imageViewTitle.layer.borderWidth = 3
        imageViewTitle.layer.borderColor = UIColor.white.cgColor
        ac.view.addSubview(imageViewTitle)
        present(ac, animated: true)
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
        {
            print("User tapped on annotation with title!")
        }
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("\(info)")
        jimmy = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as! UIImage
        //if ((jimmy as? UIImage) != nil) {
            //imageView.image = image
        //}
        picker.dismiss(animated: true, completion: nil)
         
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
