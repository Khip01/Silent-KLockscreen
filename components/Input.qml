import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: input

    signal accepted

    property string placeholder: ""
    property alias input: textField
    property bool isPassword: false
    property bool splitBorderRadius: false
    property alias text: textField.text
    property string icon: ""
    property bool enabled: true

    width: SilentConfig.passwordInputWidth * SilentConfig.generalScale
    height: SilentConfig.passwordInputHeight * SilentConfig.generalScale

    TextField {
        id: textField
        anchors.fill: parent
        color: SilentConfig.passwordInputContentColor
        enabled: input.enabled
        echoMode: input.isPassword ? TextInput.Password : TextInput.Normal
        passwordCharacter: SilentConfig.passwordInputMaskedCharacter
        activeFocusOnTab: true
        selectByMouse: true
        verticalAlignment: TextField.AlignVCenter
        font.family: SilentConfig.passwordInputFontFamily
        font.pixelSize: Math.max(8, SilentConfig.passwordInputFontSize * SilentConfig.generalScale)
        background: Rectangle {
            anchors.fill: parent
            color: SilentConfig.passwordInputBackgroundColor
            opacity: SilentConfig.passwordInputBackgroundOpacity
            topLeftRadius: SilentConfig.passwordInputBorderRadiusLeft * SilentConfig.generalScale
            bottomLeftRadius: SilentConfig.passwordInputBorderRadiusLeft * SilentConfig.generalScale
            topRightRadius: input.splitBorderRadius ? SilentConfig.passwordInputBorderRadiusRight * SilentConfig.generalScale : SilentConfig.passwordInputBorderRadiusLeft * SilentConfig.generalScale
            bottomRightRadius: input.splitBorderRadius ? SilentConfig.passwordInputBorderRadiusRight * SilentConfig.generalScale : SilentConfig.passwordInputBorderRadiusLeft * SilentConfig.generalScale
        }
        leftPadding: placeholderLabel.x
        rightPadding: 10
        onAccepted: input.accepted()

        Rectangle {
            anchors.fill: parent
            border.width: SilentConfig.passwordInputBorderSize * SilentConfig.generalScale
            border.color: SilentConfig.passwordInputBorderColor
            color: "transparent"
            topLeftRadius: SilentConfig.passwordInputBorderRadiusLeft * SilentConfig.generalScale
            bottomLeftRadius: SilentConfig.passwordInputBorderRadiusLeft * SilentConfig.generalScale
            topRightRadius: input.splitBorderRadius ? SilentConfig.passwordInputBorderRadiusRight * SilentConfig.generalScale : SilentConfig.passwordInputBorderRadiusLeft * SilentConfig.generalScale
            bottomRightRadius: input.splitBorderRadius ? SilentConfig.passwordInputBorderRadiusRight * SilentConfig.generalScale : SilentConfig.passwordInputBorderRadiusLeft * SilentConfig.generalScale
        }

        Row {
            anchors.fill: parent
            spacing: 0
            leftPadding: SilentConfig.passwordInputDisplayIcon ? 2 : 10

            Rectangle {
                id: iconContainer
                color: "transparent"
                visible: SilentConfig.passwordInputDisplayIcon
                height: parent.height
                width: height

                Image {
                    id: icon
                    source: input.icon
                    anchors.centerIn: parent
                    width: Math.max(1, SilentConfig.passwordInputIconSize * SilentConfig.generalScale)
                    height: width
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                    opacity: input.enabled ? 1.0 : 0.3
                    Behavior on opacity {
                        enabled: SilentConfig.enableAnimations
                        NumberAnimation {
                            duration: 250
                        }
                    }

                    MultiEffect {
                        source: parent
                        anchors.fill: parent
                        colorization: 1
                        colorizationColor: textField.color
                    }
                }
            }

            Text {
                id: placeholderLabel
                anchors {
                    verticalCenter: parent.verticalCenter
                }
                padding: 0
                visible: textField.text.length === 0 && (!textField.preeditText || textField.preeditText.length === 0)
                text: input.placeholder
                color: textField.color
                font.pixelSize: Math.max(8, textField.font.pixelSize || 12)
                font.family: textField.font.family || "sans-serif"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: textField.verticalAlignment
                font.italic: true
            }
        }
    }
}
