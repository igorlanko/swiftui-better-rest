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
				Section() {
					VStack(alignment: .leading) {
						Text("When do you want to wake up?")
							.font(.headline)
						
						DatePicker("Enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
					}
					//					.padding(.vertical, 12)
					//					.padding(.horizontal, 12)
					//					.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
					//					.background(.white)
					//					.clipShape(.rect(cornerRadius: 16))
					
					VStack(alignment: .leading) {
						Text("How much sleep?")
							.font(.headline)
						
						Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
					}
					
					VStack(alignment: .leading) {
						Text("Daily coffee intake")
							.font(.headline)
						
						Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
					}
				}
				Section() {
					VStack {
						Spacer()
						Button {
							//
						} label: {
							Text("Calculate")
						}
						.buttonStyle(.borderedProminent)
						Spacer()
					}
					
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
			
			let sleepTime = wakeUp - prediction.actualSleep
			
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
