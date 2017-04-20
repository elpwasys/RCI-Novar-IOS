//
//  Config.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 20/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

protocol Description {
    var label: String? { get }
}

class Config {
    //static let baseURL = "http://wasys-ocr2.wasys.com.br:81/novar/"
    static let baseURL = "https://novar.wasys.com.br/novar/"
    //static let baseURL = "http://192.168.100.12:8080/novar/"
    //static let baseURL = "http://192.168.100.23:8080/novar/"
    //static let baseURL = "http://192.168.1.125:8080/novar/"
    static let mobileURL = "\(baseURL)mb/"
    static let termoUsoURL = "\(baseURL)termo.html"
}

extension Device {
    enum Header: String {
        case userId = "userID"
        case concessionariaid = "concessionariaID"
        case deviceSo = "deviceSO"
        case deviceImei = "deviceIMEI"
        case deviceModel = "deviceModel"
        case deviceWidth = "deviceWidth"
        case deviceHeight = "deviceHeight"
        case deviceSoVersion = "deviceSOVersion"
        case deviceAppVersion = "deviceAppVersion"
    }
    static var headers: [String: String] {
        var headers = [
            Header.deviceSo.rawValue: Device.so,
            Header.deviceImei.rawValue: Device.uuid,
            Header.deviceModel.rawValue: Device.model,
            Header.deviceWidth.rawValue: "\(Device.width)",
            Header.deviceHeight.rawValue: "\(Device.height)",
            Header.deviceSoVersion.rawValue: Device.systemVersion,
            Header.deviceAppVersion.rawValue: Device.appVersion ?? "unknown"
            //Header.deviceAppVersion.rawValue: "5"
        ]
        if let delegate = UIApplication.shared.delegate as? AppDelegate, let usuario = delegate.usuario, let id = usuario.id {
            headers[Header.userId.rawValue] = "\(id)"
        }
        return headers
    }
}
