//
//  InputField.swift
//  X-Wind EFB
//
//  Purpose:
//  Provides a reusable numeric input field with a fixed unit label.
//  Selects all existing text whenever the field gains focus.
//

import SwiftUI
import UIKit


struct InputField: View {

    // MARK: - Properties

    let title: String

    let placeholder: String

    @Binding
    var text: String

    let keyboard: UIKeyboardType

    let unit: String


    // MARK: - Body

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: title.isEmpty ? 0 : 6
        ) {
            if !title.isEmpty {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }

            HStack(spacing: 6) {
                SelectAllTextField(
                    text: $text,
                    placeholder: placeholder,
                    keyboardType: keyboard
                )

                Text(unit)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 28, alignment: .trailing)
            }
            .padding(.horizontal, AppSpacing.small)
            .frame(height: 50)
            .background {
                RoundedRectangle(
                    cornerRadius: 8
                )
                .fill(AppColor.background)
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: 8
                )
                .stroke(
                    AppColor.border,
                    lineWidth: 1
                )
            }
        }
    }
}


// MARK: - UIKit Text Field

private struct SelectAllTextField: UIViewRepresentable {

    @Binding
    var text: String

    let placeholder: String

    let keyboardType: UIKeyboardType


    func makeUIView(
        context: Context
    ) -> UITextField {
        let textField = UITextField()

        textField.delegate =
            context.coordinator

        textField.keyboardType =
            keyboardType

        textField.textAlignment =
            .center

        textField.textColor =
            .white

        textField.font =
            UIFont.monospacedDigitSystemFont(
                ofSize: 20,
                weight: .semibold
            )

        textField.attributedPlaceholder =
            NSAttributedString(
                string: placeholder,
                attributes: [
                    .foregroundColor:
                        UIColor.secondaryLabel
                ]
            )

        textField.addTarget(
            context.coordinator,
            action: #selector(
                Coordinator.textDidChange
            ),
            for: .editingChanged
        )

        return textField
    }


    func updateUIView(
        _ uiView: UITextField,
        context: Context
    ) {
        if uiView.text != text {
            uiView.text = text
        }

        uiView.keyboardType =
            keyboardType
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }


    final class Coordinator:
        NSObject,
        UITextFieldDelegate {

        private let parent:
            SelectAllTextField


        init(
            _ parent: SelectAllTextField
        ) {
            self.parent = parent
        }


        @objc
        func textDidChange(
            _ textField: UITextField
        ) {
            parent.text =
                textField.text ?? ""
        }


        func textFieldDidBeginEditing(
            _ textField: UITextField
        ) {
            DispatchQueue.main.async {
                textField.selectAll(nil)
            }
        }
    }
}


// MARK: - Previews

#Preview("Heading Input") {
    InputField(
        title: "",
        placeholder: "000",
        text: .constant("250"),
        keyboard: .numberPad,
        unit: "°"
    )
    .padding()
    .background(AppColor.panel)
    .preferredColorScheme(.dark)
}


#Preview("Speed Input") {
    InputField(
        title: "",
        placeholder: "00",
        text: .constant("20"),
        keyboard: .numberPad,
        unit: "kt"
    )
    .padding()
    .background(AppColor.panel)
    .preferredColorScheme(.dark)
}
