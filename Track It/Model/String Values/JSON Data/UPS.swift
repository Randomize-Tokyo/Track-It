//
//  File.swift
//  Track It
//
//  Created by Adebayo Sotannde on 1/18/22.
//
import Foundation

// MARK: - Welcome
struct UPSJSONDATA: Codable
{
    let trackResponse: TrackResponse
}

// MARK: - TrackResponse
struct TrackResponse: Codable
{
    let shipment: [Shipment]
}

// MARK: - Shipment
struct Shipment: Codable
{
    let package: [Package]
}

// MARK: - Package
struct Package: Codable
{
    let trackingNumber: String
    let deliveryDate: [DeliveryDate]?
    let deliveryTime: DeliveryTime?
    let activity: [Activity]?
}

// MARK: - DeliveryDate
struct DeliveryDate: Codable
{
    let type: String
    let date: String
}

// MARK: - DeliveryTime
struct DeliveryTime: Codable
{
    let startTime:String?
    let endTime: String?
    let `Type`: String?

}

// MARK: - Activity
struct Activity: Codable
{
  let location: Location?
    let status: Status
   let date, time: String
}

// MARK: - Location
struct Location: Codable
{

    let address: Address?
}

// MARK: - Address
struct Address: Codable
{
    let city, stateProvince, postalCode, country: String?
}

// MARK: - Status
struct Status: Codable
{
    let type, statusDescription, code: String

    enum CodingKeys: String, CodingKey {
        case type
        case statusDescription = "description"
        case code
    }
}





