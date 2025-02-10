//
//  HomeView.swift
//  NYU_BUS_ROUTER
//
//  Created by Daniel Brito on 7/18/24.
//
//imports
import Foundation
import SwiftUI

//home page
struct HomeView: View {
    //welcome text+plus formatting
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to the NYU Bus Helper App!")
                .font(.largeTitle)
                //.fontWeight(.bold)
                .foregroundColor(Color(red: 82/255, green: 0/255, blue: 99/255))
                .padding(.top, 30)
            
            //space for format
            Spacer()
            
            //nyu picture for home screen
            Image("NYU_Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
            
            //space for format
            Spacer()
            
            //description text with formatting
            Text("This app is designed to help you navigate the NYU bus routes effortlessly. Use it to find the best routes and check bus schedules. It is not affiliated with NYU.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            //space for format
            Spacer()
            
            //project description+link
            Text("This is an open-source project that can be found at https://github.com/danny031103")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .padding()
    }
}

//visualizer
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

