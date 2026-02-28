/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2024 SilentSDDM port for KDE Plasma 6 lockscreen

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Effects

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami
import org.kde.kscreenlocker 1.0 as ScreenLocker

import org.kde.breeze.components

import "components" as SilentComponents

SessionManagementScreen {
    id: sessionManager

    /*
     * SessionManagementScreen's default property routes children into a
     * ColumnLayout (innerLayout).  Only visual Items may live there.
     * Non-visual objects (Binding, Connections, Timer, etc.) are therefore
     * tucked inside an invisible Item wrapper below.
     */

    readonly property alias mainPasswordBox: passwordBox
    property bool lockScreenUiVisible: false
    property alias showPassword: passwordBox.showPassword

    // Explicit sizing so the StackView / FocusScope has valid geometry
    implicitWidth: parent ? parent.width : 800
    implicitHeight: parent ? parent.height : 600

    // The y position that should be ensured visible when the on-screen keyboard is visible
    property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + Kirigami.Units.smallSpacing

    signal passwordResult(string password)

    onUserSelected: {
        const nextControl = (silentPasswordInput.visible ? silentPasswordInput.input : loginButton);
        nextControl.forceActiveFocus(Qt.TabFocusReason);
    }

    function startLogin() {
        const password = passwordBox.text;
        loginButton.forceActiveFocus();
        passwordResult(password);
    }

    // ── SilentSDDM-styled password row ──────────────────────────────────
    //    This RowLayout is a visual Item → safe inside the ColumnLayout.
    RowLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        spacing: SilentConfig.loginButtonMarginLeft

        // Password input — SilentSDDM's Input.qml component
        SilentComponents.Input {
            id: silentPasswordInput
            isPassword: true
            placeholder: i18nd("plasma_shell_org.kde.plasma.desktop", "Password")
            icon: SilentConfig.getIcon(SilentConfig.passwordInputIcon)
            enabled: !authenticator.graceLocked
            splitBorderRadius: true

            onTextChanged: {
                if (passwordBox.text !== text) {
                    passwordBox.text = text;
                }
            }
            onAccepted: {
                if (lockScreenUiVisible) {
                    startLogin();
                }
            }

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Left && !text) {
                    userList.decrementCurrentIndex();
                    event.accepted = true;
                }
                if (event.key === Qt.Key_Right && !text) {
                    userList.incrementCurrentIndex();
                    event.accepted = true;
                }
            }
        }

        // Login button — SilentSDDM IconButton style
        SilentComponents.IconButton {
            id: loginButton
            icon: SilentConfig.getIcon(SilentConfig.loginButtonIcon)
            iconSize: SilentConfig.loginButtonIconSize
            contentColor: SilentConfig.loginButtonContentColor
            activeContentColor: SilentConfig.loginButtonActiveContentColor
            backgroundColor: SilentConfig.loginButtonBackgroundColor
            backgroundOpacity: SilentConfig.loginButtonBackgroundOpacity
            activeBackgroundColor: SilentConfig.loginButtonActiveBackgroundColor
            activeBackgroundOpacity: SilentConfig.loginButtonActiveBackgroundOpacity
            borderSize: SilentConfig.loginButtonBorderSize
            borderColor: SilentConfig.loginButtonBorderColor
            borderRadiusLeft: SilentConfig.loginButtonBorderRadiusLeft
            borderRadiusRight: SilentConfig.loginButtonBorderRadiusRight
            preferredWidth: SilentConfig.passwordInputHeight
            height: SilentConfig.passwordInputHeight * SilentConfig.generalScale
            showLabel: false
            tooltipText: i18nd("plasma_shell_org.kde.plasma.desktop", "Unlock")

            Accessible.name: i18nd("plasma_shell_org.kde.plasma.desktop", "Unlock")

            onClicked: startLogin()
            Keys.onEnterPressed: clicked()
            Keys.onReturnPressed: clicked()
        }
    }

    // ── Non-visual helper container ─────────────────────────────────────
    //    This Item is a valid visual child of the ColumnLayout but has zero
    //    size and holds all non-visual objects that cannot live directly
    //    inside a Layout (Binding, Connections, hidden field).
    Item {
        id: nonVisualContainer
        visible: false
        width: 0
        height: 0
        Layout.preferredWidth: 0
        Layout.preferredHeight: 0
        Layout.maximumWidth: 0
        Layout.maximumHeight: 0

        // Hidden PasswordField — preserves the PasswordSync binding
        PlasmaExtras.PasswordField {
            id: passwordBox
            visible: false
            width: 0
            height: 0
            text: PasswordSync.password
            focus: false
        }

        // Binding: sync passwordBox.text → PasswordSync.password
        Binding {
            target: PasswordSync
            property: "password"
            value: passwordBox.text
        }

        // Connections: clear-password & notification-repeated from root
        Connections {
            target: root
            function onClearPassword() {
                passwordBox.forceActiveFocus();
                passwordBox.text = "";
                passwordBox.text = Qt.binding(() => PasswordSync.password);
                silentPasswordInput.text = "";
            }
            function onNotificationRepeated() {
                sessionManager.playHighlightAnimation();
            }
        }

        // Connections: sync hidden passwordBox → visible silentPasswordInput
        Connections {
            target: passwordBox
            function onTextChanged() {
                if (silentPasswordInput.text !== passwordBox.text) {
                    silentPasswordInput.text = passwordBox.text;
                }
            }
        }
    }

    // ── Warning / notification label (SilentSDDM typography) ────────────
    Text {
        id: warningLabel
        Layout.fillWidth: true
        Layout.topMargin: SilentConfig.warningMessageMarginTop
        horizontalAlignment: Text.AlignHCenter
        font.family: SilentConfig.warningMessageFontFamily
        font.pixelSize: Math.max(8, SilentConfig.warningMessageFontSize * SilentConfig.generalScale)
        font.weight: SilentConfig.warningMessageFontWeight
        color: SilentConfig.warningMessageNormalColor
        visible: text.length > 0
        text: sessionManager.notificationMessage || ""
    }

    // ── Biometric / non-interactive authenticator labels ────────────────
    component FailableLabel : PlasmaComponents3.Label {
        id: _failableLabel
        required property int kind
        required property string label

        visible: authenticator.authenticatorTypes & kind
        text: label
        textFormat: Text.PlainText
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true

        font.family: SilentConfig.warningMessageFontFamily
        font.pixelSize: Math.max(8, SilentConfig.warningMessageFontSize * SilentConfig.generalScale)
        color: SilentConfig.warningMessageNormalColor

        RejectPasswordAnimation {
            id: _rejectAnimation
            target: _failableLabel
            onFinished: _timer.restart()
        }

        Connections {
            target: authenticator
            function onNoninteractiveError(kind, authenticator) {
                if (kind & _failableLabel.kind) {
                    _failableLabel.text = Qt.binding(() => authenticator.errorMessage);
                    _rejectAnimation.start();
                }
            }
        }
        Timer {
            id: _timer
            interval: Kirigami.Units.humanMoment
            onTriggered: {
                _failableLabel.text = Qt.binding(() => _failableLabel.label);
            }
        }
    }

    FailableLabel {
        kind: ScreenLocker.Authenticator.Fingerprint
        label: i18nd("plasma_shell_org.kde.plasma.desktop", "(or scan your fingerprint on the reader)")
    }
    FailableLabel {
        kind: ScreenLocker.Authenticator.Smartcard
        label: i18nd("plasma_shell_org.kde.plasma.desktop", "(or scan your smartcard)")
    }
}
