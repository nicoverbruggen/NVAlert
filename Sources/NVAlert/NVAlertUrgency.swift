//
//  NVAlertUrgency.swift
//  NVAlert
//
//  Created by Nico Verbruggen on 27/11/2025.
//

public enum NVAlertUrgency {
    /// This is low urgency.
    /// The user will not be prompted for attention.
    case none

    /// The application requests attention.
    /// The default for alerts.
    case normalRequestAttention

    /// The application urgently demands attention.
    case urgentRequestAttention

    /// The application will steal focus.
    /// Don't do this unless necessary!
    case alwaysBringToFront
}
