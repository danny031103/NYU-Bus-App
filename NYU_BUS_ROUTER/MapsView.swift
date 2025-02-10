//
//  MapsView.swift
//  NYU_BUS_ROUTER
//
//  Created by Daniel Brito on 7/18/24.
//
//imports
import Foundation
import SwiftUI

//maps page
struct MapsView: View {
    @State private var selectedRoute: String = "Route_A"
    private let routes = ["Route_A", "Route_B", "Route_C", "Route_E", "Route_F", "Route_G", "Route_W"]
    
    //user prompted formatting
    var body: some View {
        VStack(spacing: 20) {
            Text("Select a Route to View the Map")
                .font(.title2)
                //.fontWeight(.bold)
                .foregroundColor(Color(red: 82/255, green: 0/255, blue: 99/255))
                .padding(.top, 40)
            
            //select route option menu
            Picker("Select Route", selection: $selectedRoute) {
                ForEach(routes, id: \.self) { route in
                    Text(route.replacingOccurrences(of: "_", with: " "))
                        .font(.body)
                        .foregroundColor(Color(red: 82/255, green: 0/255, blue: 99/255))
                    
                }
            }
            .frame(height: 100)
            .clipped()
            .padding(.horizontal, 20)
            
            //image formatting (maps images)
            if let image = UIImage(named: "\(selectedRoute)_Map") {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
            } 
            else {
                Text("Map unavailable")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
            //space for formatting
            Spacer()
            
            //project details text
            Text("This is an open-source project that can be found at https://github.com/danny031103")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

//visualizer
struct MapsView_Previews: PreviewProvider {
    static var previews: some View {
        MapsView()
    }
}

