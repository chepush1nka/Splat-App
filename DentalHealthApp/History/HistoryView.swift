//
//  HistoryView.swift
//  DentalHealthApp
//
//  Created by Pavel Vyaltsev.
//

import SwiftUI

struct HistoryView: View {
    let callback: () -> ()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Анализы")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                        .padding(.leading)
                    TimelineView(callback: {
                        presentationMode.wrappedValue.dismiss()
                        callback()
                    })
                }
            }
        }
    }
}

class TimelineViewModel: ObservableObject {
    @Published var results = UserData.shared.getResults()
}

struct TimelineView: View {

    let dates: [String] = []
    let callback: () -> ()
    @ObservedObject var vm = TimelineViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(vm.results.keys.sorted().reversed(), id: \.self) { key in
                if let result = vm.results[key] {
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.splatRed)
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text(vm.results[key]?.type.rawValue ?? "Анализ")
                                    .bold()
                                Text(UserData.formatDate(key))
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        NavigationLink(destination: ResultsView(callback: {
                            callback()
                        }, result: vm.results[key] ?? AnalysisResult(type: .bite, teethColor: .undefined, bite: .normal)))  {
                            Text("Просмотр")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color.splatRed)
                                .cornerRadius(10)
                        }.padding()
                    }
                    .padding(.leading)
                    Divider()
                        .padding(.leading, 5)
                }
            }
        }
        .toolbar(content: {
            Button {
                vm.results = UserData.shared.getResults()
            } label: {
                Image(systemName: "arrow.circlepath")
                    .foregroundColor(Color.splatRed)

            }
        })
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(callback: {})
    }
}

