//
//  AppPickedSheet.swift
//  Push It!
//
//  Created by Veikko Arvonen on 9.2.2026.
//

import SwiftUI
import FamilyControls

struct AppPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: FamilyActivitySelection

    var body: some View {
        NavigationView {
            FamilyActivityPicker(selection: $selection)
                .navigationTitle("Choose Apps")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

