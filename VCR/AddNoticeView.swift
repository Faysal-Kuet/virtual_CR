//
//  AddNoticeView.swift
//  VCR
//
//  Created by Faysal Mahmud on 20/11/24.
//

import SwiftUI

struct AddNoticeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var networkManager: NetworkManager
    
    @State private var date = ""
    @State private var day = ""
    @State private var time = ""
    @State private var noticeText = ""
    @State private var pass = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notice Details")) {
                    DatePicker("Date", selection: Binding(
                        get: {
                            // Convert string to Date or use current date
                            if let date = ISO8601DateFormatter().date(from: date) {
                                return date
                            }
                            return Date()
                        },
                        set: { newDate in
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            self.date = formatter.string(from: newDate)
                            
                            let dayFormatter = DateFormatter()
                            dayFormatter.dateFormat = "EEEE"
                            self.day = dayFormatter.string(from: newDate)
                        }
                    ), displayedComponents: .date)
                    
                    TextField("Time (HH:MM)", text: $time)
                        .keyboardType(.numbersAndPunctuation)
                    
                    TextField("Notice", text: $noticeText)
                }
                
                Section(header: Text("Authentication")) {
                    SecureField("Password", text: $pass)
                }
            }
            .navigationBarTitle("Add Notice", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing:
                Button("Save") {
                    addNotice()
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
        return !date.isEmpty && !day.isEmpty && !time.isEmpty && !noticeText.isEmpty && !pass.isEmpty
    }
    
    func addNotice() {
        networkManager.addNotice(date: date, day: day, time: time, noticeText: noticeText, pass: pass) { success in
            if success {
                alertMessage = "Success"
                networkManager.fetchNotices()
            } else {
                alertMessage = "Failed to add notice"
            }
            showingAlert = true
        }
    }
}
