//
//  SendTokenToFriendView.swift
//  Loyo
//
//  Created by Kirill on 5/8/23.
//

import SwiftUI


struct SendTokenToFriendView: View {
    @State var chosenFriend: String? = nil
    @State var amountToSend: Int? = nil
    @State var isPresentingConfirm: Bool = false
    @State var transactionPending: Bool = false
    @State var transactionSuccess: Bool = false
    var body: some View {
        VStack {
            HStack {
                if let name = self.chosenFriend {
                    
                    Text("\(name)")
                    TextField("0", value: $amountToSend, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 55)
                    
                    if transactionPending == false {
                        Button (action: {
                            // send
                        }, label: {
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                Text("Send")
                            }
                            .fixedSize()
                        })
                            .buttonStyle(.borderedProminent)
                            .tint(Color.init(hex: "99edcc"))
                            .foregroundColor(Color.black)
                            .confirmationDialog("Are you sure?",
                              isPresented: $isPresentingConfirm) {
                                Button("Send tokens?") {
                                    transactionPending = true
                                    let timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { _ in
                                        transactionPending = false
                                        transactionSuccess = true
                                        let timer2 = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { __ in
                                            transactionSuccess = false
                                        }
                                    }
                               }
                            }
                    }
                    else if transactionSuccess == true {
                        Text("Success")
                    }
                    else {
                        Text("Pending")
                    }
                    
                    
                }
            }
            Text("Who do we gift?")
            ScrollView {
                VStack {
                    ForEach(friends, id: \.id) { friend in
                        Divider()
                        Text(friend.name)
                            .font(.headline)
                            .foregroundColor(Color.init(hex: "1b264f"))
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                            .onTapGesture {
                                chosenFriend = friend.name
                            }
                    }
                }
            }
        }
    }
}


struct Friend: Identifiable {
    let id = UUID()
    let name: String
}

let friends = [
        Friend(name: "Nikita"),
        Friend(name: "Emily"),
        Friend(name: "Michael"),
        Friend(name: "Sarah"),
        Friend(name: "David")
]

struct SendTokenToFriendView_Previews: PreviewProvider {
    static var previews: some View {
        SendTokenToFriendView()
    }
}
