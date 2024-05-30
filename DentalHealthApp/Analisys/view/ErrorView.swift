//
//  ErrorView.swift
//  DentalHealthApp
//
//  Created by Pavel Vyaltsev on 26.03.2024.
//

import SwiftUI

struct ErrorView: View {
    let callback: () -> ()
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 20) {

                Text("Не удалось распознать заруженные вами фото, повтирите попытку, пожалуйста")
                    .padding(.vertical)
                Spacer()
                Button {
                    callback()
                } label: {
                    Text("На главный экран")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.splatRed)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
            .padding()
        }.navigationBarBackButtonHidden(true)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(callback: {})
    }
}

