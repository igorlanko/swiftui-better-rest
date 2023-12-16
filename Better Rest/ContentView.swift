//
//  ContentView.swift
//  Better Rest
//
//  Created by stranger on 2023-12-08.
//

import CoreML
import SwiftUI

struct ContentView: View {
	@State private var sleepAmount = 8.0
	@State private var wakeUp = defaultWakeTime
	@State private var coffeeAmount = 1
	@State private var sleepTime = Date()
	
	static var defaultWakeTime: Date {
		var components = DateComponents()
		components.hour = 7
		components.minute = 0
		return Calendar.current.date(from: components) ?? .now
	}
	
	var body: some View {
		//		Text(Date.now.formatted(date: .abbreviated, time: .shortened))
		//
		//		DatePicker("Enter a date", selection: $wakeUp, in: Date.now...)
		//			.labelsHidden()
		//		Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
		NavigationStack {
			Form {
				Section {
					Text("\(sleepTime.formatted(date: .omitted, time: .shortened))")
						.font(.largeTitle)
				} header: {
					Text("Go to bed time")
				}
				
				Section {
					VStack(alignment: .leading) {
						Text("When do you want to wake up?")
							.font(.headline)
						
						DatePicker("Enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
							.onChange(of: wakeUp) { oldValue, newValue in
								calculateBedtime()
							}
					}
					
					VStack(alignment: .leading) {
						Text("How much sleep?")
							.font(.headline)
						
						Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
							.onChange(of: sleepAmount) { oldValue, newValue in
								calculateBedtime()
							}
					}
					
					VStack(alignment: .leading) {
						Text("Daily coffee intake")
							.font(.headline)
						
						Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
							ForEach(1...20, id: \.self) {
								Text("^[\($0) cup](inflect: true)")
							}
							.onChange(of: coffeeAmount) { oldValue, newValue in
								calculateBedtime()
							}
							.labelsHidden()
						}
					}
				} header: {
					Text("Set up your routine")
				}
			}
			.navigationTitle("Better Rest")
			//			.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
			//			.background(Color.gray.opacity(0.20))
		}
	}
	
	func calculateBedtime() {
		do {
			let config = MLModelConfiguration()
			let model = try SleepCalculator(configuration: config)
			
			let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
			let hour = (components.hour ?? 0) * 60 * 60
			let minute = (components.minute ?? 0) * 60
			
			let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(Double(coffeeAmount)))
			
			sleepTime = wakeUp - prediction.actualSleep
			
		} catch {
			// something went wrong
		}
	}
	
	//	func exampleDates() {
	////		let tomorrow = Date.now.addingTimeInterval(86400)
	////		let range = Date.now...tomorrow
	//
	////		var components = DateComponents()
	////		components.hour = 8
	////		components.minute = 0
	////		let date = Calendar.current.date(from: components) ?? .now
	//
	//		let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
	//		let hour = components.hour ?? 0
	//		let minute = components.minute ?? 0
	//	}
}

#Preview {
	ContentView()
}
