//
//  BusStopTime.swift
//  NYU_Bus_Helper
//
//  Created by Daniel Brito on 7/18/24.
//
//imports
import SwiftUI

struct ScheduleView: View {
    //initialize variables for data reading and output
    @State private var routes: [String] = []
    @State private var selectedRoute: String? = nil
    @State private var selectedDay: String? = nil
    @State private var selectedStop: String? = nil
    @State private var schedule: [BusStopTime] = []
    @State private var stops: [String] = []
    @State private var showError: Bool = false
    private let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    private let nyuPurple = Color(red: 82/255, green: 0/255, blue: 99/255)

    //schedule display+logic for missing data
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)

                VStack {
                    if showError {
                        errorView
                    } 
                    else if selectedRoute==nil{
                        routeSelectionView
                    } 
                    else if selectedDay==nil{
                        daySelectionView
                    }
                    else if selectedStop==nil{
                        stopSelectionView
                    }
                    else{
                        scheduleView
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    var routeSelectionView: some View {
        VStack {
            Text("NYU Bus Schedule")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(nyuPurple)
                .padding(.top, 40)
            
            Text("Select a Route")
                .font(.title2)
                .foregroundColor(nyuPurple)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(routes, id: \.self) { route in
                        Button(action: {
                            selectedRoute = route
                        }) {
                            CustomCard(text: route.replacingOccurrences(of: "_", with: " "))
                        }
                    }
                }
                .padding()
            }
            .onAppear(perform: loadRoutes)
        }
    }
    
    //choose day formatting
    var daySelectionView: some View {
        VStack {
            backButton
                .padding()

            Text("Select a Day")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(nyuPurple)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Button(action: {
                            selectedDay=day
                            loadSchedule(for: selectedRoute!, day: day)
                        }) {
                            CustomCard(text: day)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    //choose stop formatting
    var stopSelectionView: some View {
        VStack {
            backButton
                .padding()

            Text("Select a Stop")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(nyuPurple)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(stops, id: \.self) { stop in
                        Button(action: {
                            selectedStop = stop
                        }) {
                            CustomCard(text: stop)
                        }
                    }
                }
                .padding()
            }
            .onAppear(perform: loadStops)
        }
    }
    
    //times formatting
    var scheduleView: some View {
        VStack {
            backButton
                .padding()

            Text("Schedule for \(selectedStop!)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(nyuPurple)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(filteredSchedule()) { stopTime in
                        CustomCard(text: stopTime.time)
                    }
                }
                .padding()
            }
        }
    }

    //error formatting
    var errorView: some View {
        VStack {
            backButton
                .padding()
            
            Text("Sorry, this bus doesn't run today!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(nyuPurple)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }

    //navigation button (back)
    var backButton: some View {
        Button(action: {
            if showError {
                resetSelection()
            } 
            else if selectedStop != nil {
                selectedStop=nil
            } 
            else if selectedDay != nil {
                selectedDay = nil
                schedule=[]
                stops=[]
            } 
            else if selectedRoute != nil {
                selectedRoute=nil
            }
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
            .padding()
            .background(nyuPurple.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
    
    //refresh user choices
    func resetSelection() {
        selectedRoute = nil
        selectedDay = nil
        selectedStop = nil
        schedule = []
        stops = []
        showError = false
    }

    //route names based on data files
    func loadRoutes() {
        routes = ["Route_A", "Route_B", "Route_C", "Route_E", "Route_F", "Route_G", "Route_W"]
    }

    //schedule groupings:
    //1.Monday-Thursday
    //2.Friday
    //3.Weekend(Saturday/Sunday)
    func loadSchedule(for route: String, day: String) {
        let dayGroup: String
        switch day {
        case "Monday", "Tuesday", "Wednesday", "Thursday":
            dayGroup = "Monday-Thursday"
        case "Friday":
            dayGroup = "Friday"
        case "Saturday", "Sunday":
            dayGroup = "Weekend"
        default:
            dayGroup = ""
        }

        let fileName = "\(route)_Schedule_\(dayGroup)"
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                if let decodedData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                    schedule = decodedData.flatMap { dict in
                        dict.map { BusStopTime(stop: $0.key, time: $0.value) }
                    }
                    stops = Array(Set(schedule.map { $0.stop })).sorted()
                }
            } catch {
                print("Error loading file: \(error)")
                showError = true
            }
        } else {
            showError = true
        }
    }
    
    //stops for each bus
    func loadStops() {
        stops = Array(Set(schedule.map { $0.stop })).sorted()
    }

    //depending on time it currently is
    func filteredSchedule() -> [BusStopTime] {
        let currentTime = getCurrentTime()
        return schedule.filter { $0.stop == selectedStop && isTimeLater(time1: $0.time, time2: currentTime) }
    }
    
    //check current time of day for the user
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: Date())
    }

    //comparison to time of day and scheduled time
    func isTimeLater(time1: String, time2: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        if let t1 = dateFormatter.date(from: time1), let t2 = dateFormatter.date(from: time2) {
            return t1 > t2
        }
        return false
    }
}
//formatting
struct CustomCard: View {
    let text: String
    let showMap: (() -> Void)?

    init(text: String, showMap: (() -> Void)? = nil) {
        self.text = text.replacingOccurrences(of: "_", with: " ")
        self.showMap = showMap
    }

    var body: some View {
        VStack {
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 82/255, green: 0/255, blue: 99/255), Color(red: 123/255, green: 0/255, blue: 149/255)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 20)
            if let showMap = showMap {
                Button(action: {
                    showMap()
                }) {
                    Text("Show Map")
                        .font(.subheadline)
                        .padding(8)
                        .background(Color.white)
                        .foregroundColor(Color(red: 82/255, green: 0/255, blue: 99/255))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 5)
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
