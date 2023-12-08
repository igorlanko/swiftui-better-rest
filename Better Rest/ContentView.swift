//
//  ContentView.swift
//  Better Rest
//
//  Created by stranger on 2023-12-08.
//

import SwiftUI

struct ContentView: View {
	@State private var sleepAmount = 8.0
	@State private var wakeUp = Date.now
	
    var body: some View {
		Text(Date.now.formatted(date: .abbreviated, time: .shortened))
		
		DatePicker("Enter a date", selection: $wakeUp, in: Date.now...)
			.labelsHidden()
		Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
    }
	
	func exampleDates() {
//		let tomorrow = Date.now.addingTimeInterval(86400)
//		let range = Date.now...tomorrow
		
//		var components = DateComponents()
//		components.hour = 8
//		components.minute = 0
//		let date = Calendar.current.date(from: components) ?? .now
		
		let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
		let hour = components.hour ?? 0
		let minute = components.minute ?? 0
	}
}

#Preview {
    ContentView()
}
