//
//  AddCTAnnouncementView.swift
//  VCR
//
//  Created by Faysal Mahmud on 20/11/24.
//

import SwiftUI

struct AddCTAnnouncementView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var networkManager: NetworkManager
    
    @State private var date = Date()
    @State private var time = ""
    @State private var place = ""
    @State private var selectedCourseIndex = 0
    @State private var topic = ""
    @State private var selectedTeacherIndex = 0
    @State private var pass = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("CT Announcement Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    TextField("Time (HH:MM)", text: $time)
                        .keyboardType(.numbersAndPunctuation)
                    
                    TextField("Place", text: $place)
                    
                    Picker("Course", selection: $selectedCourseIndex) {
                        ForEach(0..<courses.count, id: \.self) { index in
                            Text(courses[index]).tag(index)
                        }
                    }
                    
                    TextField("Topic", text: $topic)
                }
                
                Section(header: Text("Teacher")) {
                    Picker("Select Teacher", selection: $selectedTeacherIndex) {
                        ForEach(0..<teachers.count, id: \.self) { index in
                            Text(teachers[index]).tag(index)
                        }
                    }
                }
                
                Section(header: Text("Authentication")) {
                    SecureField("Password", text: $pass)
                }
            }
            .navigationBarTitle("Add CT Announcement", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing:
                Button("Save") {
                    addCTAnnouncement()
                }
                .disabled(!isFormValid())
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if alertMessage == "Success" {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
    }
    
    func isFormValid() -> Bool {
        return !place.isEmpty && !time.isEmpty && !topic.isEmpty && !pass.isEmpty
    }
    
    func addCTAnnouncement() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let dayString = dayFormatter.string(from: date)
        
        networkManager.addCTAnnouncement(
            date: dateString,
            day: dayString,
            time: time,
            place: place,
            course_id: selectedCourseIndex + 1,
            topic: topic,
            teacher_id: selectedTeacherIndex + 1,
            pass: pass
        ) { success in
            if success {
                alertMessage = "Success"
                networkManager.fetchCTAnnouncements()
            } else {
                alertMessage = "Failed to add CT Announcement"
            }
            showingAlert = true
        }
    }
}
