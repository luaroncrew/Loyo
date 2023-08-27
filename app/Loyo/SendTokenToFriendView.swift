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
    
    @StateObject var blockchainConnector = BlockchainConnector.shared
    
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
                            Task.init {
                                do {
                                    if let amount = amountToSend {
                                        try await blockchainConnector.sendToFriend(
                                            friendName: name,
                                            amount: amount
                                        )
                                    }
                                    isPresentingConfirm.toggle()
                                } catch {
                                    print("Transaction failed: \(error)")
                                }
                            }
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
                    ForEach(friends) { friend in
                        Divider()
                        Text(friend.ensAddress)
                            .font(.headline)
                            .foregroundColor(Color.init(hex: "1b264f"))
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                            .onTapGesture {
                                chosenFriend = friend.ensAddress
                            }
                    }
                }
            }
        }
    }
}


struct Friend: Identifiable {
    public let id = UUID()
    let ensAddress: String
    
}

let friends = [
        Friend(ensAddress: "kirill.offchaindemo.eth"),
        Friend(ensAddress: "emily.eth"),
        Friend(ensAddress: "michael.eth"),
        Friend(ensAddress: "sarah.eth"),
        Friend(ensAddress: "david.eth")
]
