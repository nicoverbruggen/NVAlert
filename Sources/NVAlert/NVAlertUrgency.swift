//
//  NVAlertUrgency.swift
//  NVAlert
//
//  Created by Nico Verbruggen on 27/11/2025.
//

public enum NVAlertUrgency {
    /// Use for background alerts.
    /// No user attention is requested.
    case none

    /// The application requests attention.
    /// Use for background alerts.
    /// Requests user attention w/ `.informationalRequest`
    case normalRequestAttention

    /// The application urgently demands attention.
    /// Use for background alerts.
    /// Requests user attention w/ `.criticalRequest`
    case urgentRequestAttention

    /// The application will be focused.
    /// Use when immediate user interaction is expected.
    case bringToFront
}
