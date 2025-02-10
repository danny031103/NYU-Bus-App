//
//  MainView.swift
//  NYU_BUS_ROUTER
//
//  Created by Daniel Brito on 7/18/24.
//
import Foundation
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            //home tab
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            //route schedule tab
            ScheduleView()
                .tabItem {
                    Image(systemName: "bus")
                    Text("Schedule")
                }
            //maps images tab
            MapsView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Maps")
                }
        }
    }
}

//visualizer
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
