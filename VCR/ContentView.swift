//
//  ContentView.swift
//  VCR
//
//  Created by Faysal Mahmud on 20/11/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var networkManager = NetworkManager()
    
    @State private var showAddNotice = false
    @State private var showAddCTAnnouncement = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Current Notices Section
                    Text("Current Notices")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(networkManager.notices) { notice in
                        NoticeView(notice: notice)
                            .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // CT Announcements Section
                    Text("CT Announcements")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(networkManager.ctAnnouncements) { announcement in
                        CTAnnouncementView(announcement: announcement)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationBarTitle("VCR", displayMode: .inline)
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        showAddNotice.toggle()
                    }) {
                        Image(systemName: "megaphone")
                    }
                    .sheet(isPresented: $showAddNotice) {
                        AddNoticeView(networkManager: networkManager)
                    }
                    
                    Button(action: {
                        showAddCTAnnouncement.toggle()
                    }) {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    }
                    .sheet(isPresented: $showAddCTAnnouncement) {
                        AddCTAnnouncementView(networkManager: networkManager)
                    }
                }
            )
            .onAppear {
                networkManager.fetchNotices()
                networkManager.fetchCTAnnouncements()
            }
        }
    }
}


struct NoticeView: View {
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(notice.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(notice.day), \(notice.time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text(notice.notice)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}

struct CTAnnouncementView: View {
    let announcement: CTAnnouncement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(announcement.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(announcement.day), \(announcement.time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text("Course: \(announcement.course)")
                .font(.headline)
            Text("Teacher: \(announcement.teacher)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Place: \(announcement.place)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Topic: \(announcement.topic)")
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
