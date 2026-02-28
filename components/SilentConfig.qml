pragma Singleton

import QtQuick

/*
    SilentConfig — Ported SilentSDDM Config singleton for KDE Plasma 6 lockscreen.

    All properties use the same names as the original SilentSDDM Config.qml so
    that Avatar.qml, Input.qml, IconButton.qml, and Spinner.qml can reference
    them without modification.

    Values are hardcoded from configs/default.conf.  To customize, edit the
    property defaults below.
*/
QtObject {
    // [General]
    readonly property real generalScale: 1.0
    readonly property bool enableAnimations: true
    readonly property string backgroundFillMode: "fill"

    // [LockScreen]
    readonly property bool lockScreenDisplay: true
    readonly property int lockScreenPaddingTop: 0
    readonly property int lockScreenPaddingRight: 0
    readonly property int lockScreenPaddingBottom: 0
    readonly property int lockScreenPaddingLeft: 0
    readonly property int lockScreenBlur: 32
    readonly property real lockScreenBrightness: 0.0
    readonly property real lockScreenSaturation: 0.0

    // [LockScreen.Clock]
    readonly property bool clockDisplay: true
    readonly property string clockPosition: "top-center"
    readonly property string clockAlign: "center"
    readonly property string clockFormat: "hh:mm"
    readonly property string clockFontFamily: "RedHatDisplay"
    readonly property int clockFontSize: 70
    readonly property int clockFontWeight: 900
    readonly property color clockColor: "#FFFFFF"

    // [LockScreen.Date]
    readonly property bool dateDisplay: true
    readonly property string dateFormat: "dddd, MMMM dd, yyyy"
    readonly property string dateLocale: "en_US"
    readonly property string dateFontFamily: "RedHatDisplay"
    readonly property int dateFontSize: 14
    readonly property int dateFontWeight: 600
    readonly property color dateColor: "#FFFFFF"
    readonly property int dateMarginTop: -15

    // [LockScreen.Message]
    readonly property bool lockMessageDisplay: true
    readonly property string lockMessagePosition: "bottom-center"
    readonly property string lockMessageAlign: "center"
    readonly property string lockMessageText: "Press any key"
    readonly property string lockMessageFontFamily: "RedHatDisplay"
    readonly property int lockMessageFontSize: 12
    readonly property int lockMessageFontWeight: 400
    readonly property bool lockMessageDisplayIcon: true
    readonly property string lockMessageIcon: "enter.svg"
    readonly property int lockMessageIconSize: 16
    readonly property color lockMessageColor: "#FFFFFF"
    readonly property bool lockMessagePaintIcon: true
    readonly property int lockMessageSpacing: 0

    // [LoginScreen.LoginArea.Avatar]
    readonly property string avatarShape: "circle"
    readonly property int avatarBorderRadius: 35
    readonly property int avatarActiveSize: 120
    readonly property int avatarInactiveSize: 80
    readonly property real avatarInactiveOpacity: 0.35
    readonly property int avatarActiveBorderSize: 0
    readonly property int avatarInactiveBorderSize: 0
    readonly property color avatarActiveBorderColor: "#FFFFFF"
    readonly property color avatarInactiveBorderColor: "#FFFFFF"

    // [LoginScreen.LoginArea.Username]
    readonly property string usernameFontFamily: "RedHatDisplay"
    readonly property int usernameFontSize: 16
    readonly property int usernameFontWeight: 700
    readonly property color usernameColor: "#FFFFFF"
    readonly property int usernameMargin: 10

    // [LoginScreen.LoginArea.PasswordInput]
    readonly property int passwordInputWidth: 200
    readonly property int passwordInputHeight: 30
    readonly property bool passwordInputDisplayIcon: true
    readonly property string passwordInputFontFamily: "RedHatDisplay"
    readonly property int passwordInputFontSize: 12
    readonly property string passwordInputIcon: "password.svg"
    readonly property int passwordInputIconSize: 16
    readonly property color passwordInputContentColor: "#FFFFFF"
    readonly property color passwordInputBackgroundColor: "#FFFFFF"
    readonly property real passwordInputBackgroundOpacity: 0.15
    readonly property int passwordInputBorderSize: 0
    readonly property color passwordInputBorderColor: "#FFFFFF"
    readonly property int passwordInputBorderRadiusLeft: 10
    readonly property int passwordInputBorderRadiusRight: 10
    readonly property int passwordInputMarginTop: 10
    readonly property string passwordInputMaskedCharacter: "●"

    // [LoginScreen.LoginArea.LoginButton]
    readonly property color loginButtonBackgroundColor: "#FFFFFF"
    readonly property real loginButtonBackgroundOpacity: 0.15
    readonly property color loginButtonActiveBackgroundColor: "#FFFFFF"
    readonly property real loginButtonActiveBackgroundOpacity: 0.30
    readonly property string loginButtonIcon: "arrow-right.svg"
    readonly property int loginButtonIconSize: 18
    readonly property color loginButtonContentColor: "#FFFFFF"
    readonly property color loginButtonActiveContentColor: "#FFFFFF"
    readonly property int loginButtonBorderSize: 0
    readonly property color loginButtonBorderColor: "#FFFFFF"
    readonly property int loginButtonBorderRadiusLeft: 10
    readonly property int loginButtonBorderRadiusRight: 10
    readonly property int loginButtonMarginLeft: 5
    readonly property bool loginButtonShowTextIfNoPassword: true
    readonly property bool loginButtonHideIfNotNeeded: false
    readonly property string loginButtonFontFamily: "RedHatDisplay"
    readonly property int loginButtonFontSize: 12
    readonly property int loginButtonFontWeight: 600

    // [LoginScreen.LoginArea.Spinner]
    readonly property bool spinnerDisplayText: true
    readonly property string spinnerText: "Logging in"
    readonly property string spinnerFontFamily: "RedHatDisplay"
    readonly property int spinnerFontWeight: 600
    readonly property int spinnerFontSize: 14
    readonly property int spinnerIconSize: 30
    readonly property string spinnerIcon: "spinner.svg"
    readonly property color spinnerColor: "#FFFFFF"
    readonly property int spinnerSpacing: 5

    // [LoginScreen.LoginArea.WarningMessage]
    readonly property string warningMessageFontFamily: "RedHatDisplay"
    readonly property int warningMessageFontSize: 11
    readonly property int warningMessageFontWeight: 400
    readonly property color warningMessageNormalColor: "#FFFFFF"
    readonly property color warningMessageWarningColor: "#FFFFFF"
    readonly property color warningMessageErrorColor: "#FFFFFF"
    readonly property int warningMessageMarginTop: 10

    // [Tooltips]
    readonly property bool tooltipsEnable: true
    readonly property string tooltipsFontFamily: "RedHatDisplay"
    readonly property int tooltipsFontSize: 11
    readonly property color tooltipsContentColor: "#FFFFFF"
    readonly property color tooltipsBackgroundColor: "#FFFFFF"
    readonly property real tooltipsBackgroundOpacity: 0.15
    readonly property int tooltipsBorderRadius: 5
    readonly property bool tooltipsDisableUser: false
    readonly property bool tooltipsDisableLoginButton: false

    // LoginArea position (used by Spinner/Input positioning logic)
    readonly property string loginAreaPosition: "center"
    readonly property int loginAreaMargin: -1

    function getIcon(iconName) {
        var ext_arr = iconName.split(".");
        var ext = ext_arr.length > 1 ? ext_arr[ext_arr.length - 1] : "";
        return "../icons/" + iconName + (ext === "" ? ".svg" : "");
    }
}
