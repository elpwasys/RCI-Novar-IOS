//
//  App.swift
//  Self
//
//  Created by Everton Luiz Pascke on 06/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper
import SystemConfiguration

class Throuble: Error {
    let reason: String
    init(_ reason: String) {
        self.reason = reason
    }
    var message: String {
        return reason
    }
}

enum Status: String {
    case update = "UPDATE"
    case failure = "FAILURE"
    case success = "SUCCESS"
}

class HttpThrouble: Throuble {
    var status: Status
    var messages: [String]
    init(_ status: Status, _ messages: String...) {
        self.status = status
        self.messages = messages
        super.init(status.rawValue)
    }
    override var message: String {
        guard messages.count > 0 else {
            return reason
        }
        var message = ""
        for (index, value) in messages.enumerated() {
            if index > 0 {
                message += ", "
            }
            message += value
        }
        return message
    }
}

class Reachability {
    static func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

class DateTransformType: TransformType {
    
    typealias JSON = String
    typealias Object = Date
    
    var dateType: DateUtils.DateType
    
    init(dateType: DateUtils.DateType? = .dateBr) {
        self.dateType = dateType!
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        guard let value = value else {
            return nil
        }
        return DateUtils.format(value, pattern: dateType.pattern)
    }
    
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let value = value as? String else {
            return nil
        }
        return DateUtils.parse(value)
    }
}

class IdentifierTransform: TransformType {
    
    typealias JSON = Int
    typealias Object = Int
    
    public init() {}
    
    func transformFromJSON(_ value: Any?) -> Int? {
        if let value = value as? Int {
            return value
        }
        if let text = value as? String, let id = Int(text) {
            return id
        }
        return nil
    }
    
    func transformToJSON(_ value: Int?) -> Int? {
        return value
    }
}

class Device {
    
    static var so: String {
        return "IOS"
    }
    
    static var uuid: String {
        return UUID().uuidString
    }
    
    static var model: String {
        return UIDevice().model
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    static var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary, let version = dictionary["CFBundleVersion"] as? String else {
            return nil
        }
        return version
    }
}

extension DataRequest {
    
    static func validate(default: DefaultDataResponse) throws {
        let data = `default`.data
        let error = `default`.error
        let request = `default`.request
        let response = `default`.response
        try validate(request: request, response: response, data: data, error: error)
    }
    
    static func validate(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws {
        if let error = error {
            throw error
        }
        guard let data = data else {
            throw HttpThrouble(.failure, "Data could not be serialized. Input data is nil.")
        }
        guard let response = response else {
            throw HttpThrouble(.failure, "Data could not be serialized. Input response is nil.")
        }
        guard let httpStatus = HttpStatus(rawValue: response.statusCode) else {
            throw HttpThrouble(.failure)
        }
        guard httpStatus.is2xxSuccessful() else {
            throw HttpThrouble(.failure)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]
            guard let rawValue = json?["status"] as? String, let status = Status.init(rawValue: rawValue), status == .success else {
                let throuble = HttpThrouble(.failure)
                if let messages = json?["messages"] as? [String] {
                    throuble.messages = messages
                }
                throw throuble
            }
        } catch {
            throw error
        }
    }
    
    static func serializer<T: BaseMappable>(_ path: String?) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            do {
                try validate(request: request, response: response, data: data, error: error)
                let serializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
                let result = serializer.serializeResponse(request, response, data, error)
                let json: Any?
                if let path = path, path.isEmpty == false {
                    json = (result.value as AnyObject?)?.value(forKeyPath: path)
                } else {
                    json = result.value
                }
                if json == nil {
                    throw HttpThrouble(.failure, "Nenhuma retorno do servidor.")
                }
                if let mapper = Mapper<T>().mapArray(JSONObject: json) {
                    return .success(mapper)
                }
                throw HttpThrouble(.failure, "ObjectMapper failed to serialize response.")
            } catch {
                return .failure(error)
            }
        }
    }
    
    static func serializer<T: BaseMappable>(_ path: String?, object: T? = nil) -> DataResponseSerializer<T> {
        return DataResponseSerializer { request, response, data, error in
            do {
                try validate(request: request, response: response, data: data, error: error)
                let serializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
                let result = serializer.serializeResponse(request, response, data, error)
                let json: Any?
                if let path = path, path.isEmpty == false {
                    json = (result.value as AnyObject?)?.value(forKeyPath: path)
                } else {
                    json = result.value
                }
                if json == nil {
                    throw HttpThrouble(.failure, "Nenhuma retorno do servidor.")
                }
                if let mapper = Mapper<T>().map(JSONObject: json) {
                    return .success(mapper)
                }
                throw HttpThrouble(.failure, "ObjectMapper failed to serialize response.")
            } catch {
                return .failure(error)
            }
        }
    }
    
    @discardableResult
    public func parse<T: BaseMappable>(path: String? = "data", handler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        let queue = DispatchQueue(label: "br.com.wasys.novar-response", attributes: [.concurrent])
        return response(queue: queue, responseSerializer: DataRequest.serializer(path), completionHandler: handler)
    }
    
    @discardableResult
    public func parse<T: BaseMappable>(path: String? = "data", object: T? = nil, handler: @escaping (DataResponse<T>) -> Void) -> Self {
        let queue = DispatchQueue(label: "br.com.wasys.novar-response", attributes: [.concurrent])
        return response(queue: queue, responseSerializer: DataRequest.serializer(path, object: object), completionHandler: handler)
    }
}
