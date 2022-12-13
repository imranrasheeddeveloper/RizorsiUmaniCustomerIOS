//
//  Socket.swift
//  IamHere
//
//  Created by Imran Rasheed on 22/10/2022.
//

import SocketIO

class SocketHelper {
    
    static let shared = SocketHelper()
    var socket: SocketIOClient!
    //var chatSocketDelegate : VCChatDeletgate?
    let manager = SocketManager(socketURL: URL(string: Constants.URLs.baseUrl)!, config: [.log(false), .compress , .secure(false) , .forceWebsockets(true)])
    init() {
        socket = manager.defaultSocket
    }
    
    func connectSocket(completion: @escaping(Bool) -> () ) {
        let user = UserDefaults.standard.retrieve(object: UserResponseModel.self, fromKey: "UserProfile")
        //let id = user?.data.user?.id
//        socket.on(clientEvent: .connect) {(data, ack) in
//            print("socket connected")
//            self.socket.emit("online",id!)
//            completion(true)
//        }
//        socket.on(clientEvent: .error) { (data, ack) in
//            print(data)
//            completion(false)
//        }
//        socket.on(clientEvent: .error) { (data, ack) in
//            print(data)
//            completion(false)
//        }
//        socket.on(clientEvent: .error) { (data, ack) in
//            print(data)
//            completion(false)
//        }
//        self.socket.on("messageReceived", callback: { [self] data, ack in
//           // chatSocketDelegate?.socketMessageReceived()
//        })
//
//        socket.connect()
    }
    
    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }
    
    func sendMessage(_ toUser:Int) {
//        let user = UserDefaults.standard.retrieve(object: UserResponseModel.self, fromKey: "UserProfile")
//        if let id = user?.data.user?.id{
//            let payload = ["toUserId" : toUser , "fromUserId" : id]
//            self.socket.emit("new_message",payload)
//        }
    }
    
    
    func emit(emit:String , data: Any) {
       // socket.emit(emit, data as! SocketData)
    }
    func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
            return true
        }
        return false
        
    }
    
}
