//
//  ResultsView.swift
//  DentalHealthApp
//
//  Created by Pavel Vyaltsev.
//

import SwiftUI

struct ResultsView: View {
    let callback: () -> ()
    let result: AnalysisResult
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 20) {
                VStack {
                    if result.type == .teethColor {
                        ResultView(title: "Цвет зубов", value: result.teethColor.toString())
                        Text("Анализ цвета ваших зубов показывает, что их отенок - \(result.teethColor.toString()).")
                            .padding(.vertical)
                    } else if result.type == .bite {
                        ResultView(title: "Прикус", value: result.bite.rawValue)
                        Text("Анализ вашего прикуса показывает, что он \(result.bite.rawValue).")
                            .padding(.vertical)
                    }
                }
                Spacer()
                NavigationLink(destination: CareRecommendationsView(callback: {
                    presentationMode.wrappedValue.dismiss()
                    callback()
                }, showBackButton: false)) {
                    Text("Перейти к рекомендациям")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.splatRed)
                        .cornerRadius(10)
                }.padding(.bottom)
            }
            .padding()
        }.navigationBarBackButtonHidden(true)
    }
}

struct ResultView: View {
    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(callback: {}, result: AnalysisResult(type: .bite, teethColor: .undefined, bite: .normal))
    }
}

