import QtQuick
import QtQuick.Effects
import QtQuick.Controls

Rectangle {
    id: avatar
    property string shape: SilentConfig.avatarShape
    property string source: ""
    property bool active: false
    property int squareRadius: (shape == "circle") ? this.width : (SilentConfig.avatarBorderRadius === 0 ? 1 : SilentConfig.avatarBorderRadius * SilentConfig.generalScale) // min: 1
    property bool drawStroke: (active && SilentConfig.avatarActiveBorderSize > 0) || (!active && SilentConfig.avatarInactiveBorderSize > 0)
    property color strokeColor: active ? SilentConfig.avatarActiveBorderColor : SilentConfig.avatarInactiveBorderColor
    property int strokeSize: active ? (SilentConfig.avatarActiveBorderSize * SilentConfig.generalScale) : (SilentConfig.avatarInactiveBorderSize * SilentConfig.generalScale)
    property string tooltipText: ""
    property bool showTooltip: false

    signal clicked
    signal clickedOutside

    radius: squareRadius
    color: "transparent"
    antialiasing: true

    // Background
    Rectangle {
        anchors.fill: parent
        radius: avatar.squareRadius
        color: SilentConfig.passwordInputBackgroundColor
        opacity: SilentConfig.passwordInputBackgroundOpacity
        visible: true
    }

    Image {
        id: faceImage
        source: parent.source
        anchors.fill: parent
        mipmap: true
        antialiasing: true
        visible: false
        smooth: true

        fillMode: Image.PreserveAspectCrop
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter

        onStatusChanged: {
            if (status === Image.Error) {
                source = SilentConfig.getIcon("user-default");
                faceEffects.colorization = 1;
            }
        }

        // Border
        Rectangle {
            anchors.fill: parent
            radius: avatar.squareRadius
            color: "transparent"
            border.width: avatar.strokeSize
            border.color: avatar.strokeColor
            antialiasing: true
        }
    }
    MultiEffect {
        id: faceEffects
        anchors.fill: faceImage
        source: faceImage
        antialiasing: true
        maskEnabled: true
        maskSource: faceImageMask
        maskSpreadAtMin: 1.0
        maskThresholdMax: 1.0
        maskThresholdMin: 0.5
        colorization: 0
        colorizationColor: avatar.strokeColor === SilentConfig.passwordInputBackgroundColor && (1.0 - SilentConfig.passwordInputBackgroundOpacity < 0.3) ? SilentConfig.passwordInputContentColor : avatar.strokeColor
    }

    Item {
        id: faceImageMask

        height: this.width
        layer.enabled: true
        layer.smooth: true
        visible: false
        width: faceImage.width

        Rectangle {
            height: this.width
            radius: avatar.squareRadius
            width: faceImage.width
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor

        function isCursorInsideAvatar() {
            if (!mouseArea.containsMouse)
                return false;
            if (avatar.shape === "square")
                return true;

            // Ellipse center and radius
            var centerX = width / 2;
            var centerY = height / 2;
            var radiusX = centerX;
            var radiusY = centerY;

            // Distance from center
            var dx = (mouseArea.mouseX - centerX) / radiusX;
            var dy = (mouseArea.mouseY - centerY) / radiusY;

            // Check if pointer is inside the ellipse
            return (dx * dx + dy * dy) <= 1.0;
        }

        onReleased: function (mouse) {
            var isInside = isCursorInsideAvatar();
            if (isInside) {
                avatar.clicked();
            } else {
                avatar.clickedOutside();
            }
            mouse.accepted = isInside;
        }

        function updateHover() {
            if (isCursorInsideAvatar()) {
                cursorShape = Qt.PointingHandCursor;
            } else {
                cursorShape = Qt.ArrowCursor;
            }
        }

        onMouseXChanged: updateHover()
        onMouseYChanged: updateHover()

        ToolTip {
            id: toolTipControl
            parent: mouseArea
            enabled: SilentConfig.tooltipsEnable && !SilentConfig.tooltipsDisableUser
            property bool shouldShow: enabled && avatar.showTooltip || (enabled && mouseArea.isCursorInsideAvatar() && avatar.tooltipText !== "")
            visible: shouldShow
            delay: 300

            y: -height - 10
            x: (parent.width - width) / 2

            // leftPadding: 12
            // rightPadding: 12
            // topPadding: 6
            // bottomPadding: 6

            contentItem: Text {
                id: tooltipTextElement
                font.family: SilentConfig.tooltipsFontFamily
                font.pixelSize: SilentConfig.tooltipsFontSize * SilentConfig.generalScale
                text: avatar.tooltipText
                color: SilentConfig.tooltipsContentColor
            }
            background: Rectangle {
                // id: backgroundItem
                implicitWidth: tooltipTextElement.implicitWidth + (toolTipControl.leftPadding + toolTipControl.rightPadding)
                implicitHeight: tooltipTextElement.implicitHeight + (toolTipControl.topPadding + toolTipControl.bottomPadding)

                color: SilentConfig.tooltipsBackgroundColor
                opacity: SilentConfig.tooltipsBackgroundOpacity
                border.width: 0
                radius: SilentConfig.tooltipsBorderRadius * SilentConfig.generalScale
            }
        }
    }
}
