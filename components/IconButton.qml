import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

Item {
    id: iconButton

    signal clicked

    property bool active: false
    readonly property bool isActive: active || focus || mouseArea.pressed || mouseArea.containsMouse
    property string icon: ""
    property int iconSize: 16
    property color contentColor: "#FFFFFF"
    property color activeContentColor: "#FFFFFF"
    property string label: ""
    property bool showLabel: true
    property string fontFamily: "RedHatDisplay"
    property int fontWeight: 400
    property int fontSize: 12
    property color backgroundColor: "#FFFFFF"
    property double backgroundOpacity: 0.0
    property color activeBackgroundColor: "#FFFFFF"
    property double activeBackgroundOpacity: 0.15
    property string tooltipText: ""
    property int borderRadius: 10
    property int borderRadiusLeft: borderRadius
    property int borderRadiusRight: borderRadius
    property int borderSize: 0
    property color borderColor: isActive ? iconButton.activeContentColor : iconButton.contentColor
    property int preferredWidth: -1

    width: preferredWidth !== -1 ? (preferredWidth * SilentConfig.generalScale) : buttonContentRow.width // childrenRect doesn't update for some reason
    height: iconSize * 2 * SilentConfig.generalScale

    Rectangle {
        id: buttonBackground
        anchors.fill: parent
        color: iconButton.isActive ? iconButton.activeBackgroundColor : iconButton.backgroundColor
        opacity: iconButton.isActive ? iconButton.activeBackgroundOpacity : iconButton.backgroundOpacity
        topLeftRadius: iconButton.borderRadiusLeft * SilentConfig.generalScale
        topRightRadius: iconButton.borderRadiusRight * SilentConfig.generalScale
        bottomLeftRadius: iconButton.borderRadiusLeft * SilentConfig.generalScale
        bottomRightRadius: iconButton.borderRadiusRight * SilentConfig.generalScale

        Behavior on opacity {
            enabled: SilentConfig.enableAnimations
            NumberAnimation {
                duration: 250
            }
        }
    }

    Rectangle {
        id: buttonBorder
        color: "transparent"
        topLeftRadius: iconButton.borderRadiusLeft * SilentConfig.generalScale
        topRightRadius: iconButton.borderRadiusRight * SilentConfig.generalScale
        bottomLeftRadius: iconButton.borderRadiusLeft * SilentConfig.generalScale
        bottomRightRadius: iconButton.borderRadiusRight * SilentConfig.generalScale
        anchors.fill: parent
        visible: iconButton.borderSize > 0 || iconButton.focus
        border {
            color: iconButton.borderColor
            width: iconButton.focus ? (iconButton.borderSize * SilentConfig.generalScale) || 2 : (iconButton.borderSize > 0 ? (iconButton.borderSize * SilentConfig.generalScale) : 0)
        }
    }

    RowLayout {
        id: buttonContentRow
        height: parent.height
        spacing: 0

        Rectangle {
            id: iconContainer
            color: "transparent"
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            Image {
                id: buttonIcon
                source: iconButton.icon
                anchors.centerIn: parent
                width: iconButton.iconSize * SilentConfig.generalScale
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                visible: false // Apparently `MultiEffect.colorization` replaces the Image
            }

            MultiEffect {
                id: iconEffect
                source: buttonIcon
                anchors.fill: buttonIcon
                colorization: 1
                colorizationColor: iconButton.isActive ? iconButton.activeContentColor : iconButton.contentColor
                antialiasing: true
                opacity: iconButton.enabled ? 1.0 : 0.5

                Behavior on opacity {
                    enabled: SilentConfig.enableAnimations
                    NumberAnimation {
                        duration: 250
                    }
                }

                Behavior on colorizationColor {
                    enabled: SilentConfig.enableAnimations
                    ColorAnimation {
                        duration: 250
                    }
                }
            }
        }

        Text {
            id: buttonLabel
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: iconButton.label
            visible: iconButton.showLabel && text !== ""
            font.family: iconButton.fontFamily
            font.pixelSize: iconButton.fontSize * SilentConfig.generalScale
            font.weight: iconButton.fontWeight
            rightPadding: 10
            color: iconButton.isActive ? iconButton.activeContentColor : iconButton.contentColor
            opacity: iconButton.enabled ? 1.0 : 0.5
            Behavior on opacity {
                enabled: SilentConfig.enableAnimations
                NumberAnimation {
                    duration: 250
                }
            }
            Component.onCompleted: {
                if (iconButton.preferredWidth !== -1) {
                    Layout.preferredWidth = iconButton.width - iconContainer.width;
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: parent.enabled
        onClicked: iconButton.clicked()
        cursorShape: Qt.PointingHandCursor

        ToolTip {
            id: toolTipControl
            parent: mouseArea
            enabled: SilentConfig.tooltipsEnable
            property bool shouldShow: enabled && mouseArea.containsMouse && iconButton.tooltipText !== "" || enabled && iconButton.focus && iconButton.tooltipText !== ""
            visible: shouldShow
            delay: 300

            y: -height - 10
            x: (parent.width - width) / 2

            // Explicit sizing breaks the contentWidth ↔ background binding loop
            contentWidth: tooltipTextElement.implicitWidth
            contentHeight: tooltipTextElement.implicitHeight

            contentItem: Text {
                id: tooltipTextElement
                font.family: SilentConfig.tooltipsFontFamily
                font.pixelSize: SilentConfig.tooltipsFontSize * SilentConfig.generalScale
                text: iconButton.tooltipText
                color: SilentConfig.tooltipsContentColor
            }

            background: Rectangle {
                color: SilentConfig.tooltipsBackgroundColor
                opacity: SilentConfig.tooltipsBackgroundOpacity
                border.width: 0
                radius: SilentConfig.tooltipsBorderRadius * SilentConfig.generalScale
            }
        }
    }

    Keys.onPressed: function (event) {
        if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter || event.key === Qt.Key_Space) {
            iconButton.clicked();
        }
    }
}
