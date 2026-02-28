import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: spinnerContainer
    width: (spinner.width + SilentConfig.spinnerSpacing + spinnerText.width) * SilentConfig.generalScale
    height: childrenRect.height * SilentConfig.generalScale

    Behavior on opacity {
        enabled: SilentConfig.enableAnimations
        NumberAnimation {
            duration: 150
        }
    }
    Behavior on visible {
        enabled: SilentConfig.enableAnimations && SilentConfig.spinnerDisplayText
        ParallelAnimation {
            running: spinnerContainer.visible && SilentConfig.spinnerDisplayText
            NumberAnimation {
                target: spinnerText
                property: SilentConfig.loginAreaPosition === "left" ? "anchors.leftMargin" : (SilentConfig.loginAreaPosition === "right" ? "anchors.rightMargin" : "anchors.topMargin")
                from: -spinner.height
                to: SilentConfig.spinnerSpacing
                duration: 300
                easing.type: Easing.OutQuart
            }
            NumberAnimation {
                target: spinnerEffect
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
        }
    }

    Image {
        id: spinner
        source: SilentConfig.getIcon(SilentConfig.spinnerIcon)
        width: SilentConfig.spinnerIconSize * SilentConfig.generalScale
        height: width
        sourceSize.width: width
        sourceSize.height: height
        visible: false

        Component.onCompleted: {
            if (SilentConfig.loginAreaPosition === "left") {
                anchors.left = parent.left;
                anchors.verticalCenter = parent.verticalCenter;
            } else if (SilentConfig.loginAreaPosition === "right") {
                anchors.right = parent.right;
                anchors.verticalCenter = parent.verticalCenter;
            } else {
                anchors.top = parent.top;
                anchors.horizontalCenter = parent.horizontalCenter;
            }
        }
    }
    MultiEffect {
        id: spinnerEffect
        source: spinner
        anchors.fill: spinner
        colorization: 1
        colorizationColor: SilentConfig.spinnerColor
        opacity: SilentConfig.spinnerDisplayText ? 0.0 : 1.0
        antialiasing: true
    }
    RotationAnimation {
        target: spinnerEffect
        running: spinnerContainer.visible && SilentConfig.enableAnimations
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 1200
    }

    Text {
        id: spinnerText
        visible: SilentConfig.spinnerDisplayText
        text: SilentConfig.spinnerText
        color: SilentConfig.spinnerColor
        font.pixelSize: SilentConfig.spinnerFontSize * SilentConfig.generalScale
        font.weight: SilentConfig.spinnerFontWeight
        font.family: SilentConfig.spinnerFontFamily

        Component.onCompleted: {
            if (SilentConfig.loginAreaPosition === "left") {
                anchors.left = spinner.right;
                anchors.leftMargin = SilentConfig.spinnerSpacing;
                anchors.verticalCenter = parent.verticalCenter;
            } else if (SilentConfig.loginAreaPosition === "right") {
                anchors.right = spinner.left;
                anchors.rightMargin = SilentConfig.spinnerSpacing;
                anchors.verticalCenter = parent.verticalCenter;
            } else {
                anchors.top = spinner.bottom;
                anchors.topMargin = SilentConfig.spinnerSpacing;
                anchors.horizontalCenter = parent.horizontalCenter;
            }
        }

        onVisibleChanged: {
            if (visible && SilentConfig.enableAnimations && SilentConfig.spinnerDisplayText) {
                spinnerTextInterval.running = true;
            } else {
                spinnerTextAnimation.running = false;
                spinnerTextInterval.running = false;
            }
        }

        SequentialAnimation on scale {
            id: spinnerTextAnimation
            running: false
            loops: Animation.Infinite
            NumberAnimation {
                from: 1.0
                to: 1.05
                duration: 900
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                from: 1.05
                to: 1.0
                duration: 900
                easing.type: Easing.InOutQuad
            }
        }
    }

    Timer {
        id: spinnerTextInterval
        interval: 3500
        repeat: false
        running: false
        onTriggered: {
            spinnerTextAnimation.running = true;
        }
    }

    Component.onDestruction: {
        if (spinnerTextInterval) {
            spinnerTextInterval.running = false;
            spinnerTextInterval.stop();
        }
        if (spinnerTextAnimation) {
            spinnerTextAnimation.running = false;
            spinnerTextAnimation.stop();
        }
    }
}
