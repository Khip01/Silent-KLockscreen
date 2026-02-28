/*
    SilentFonts.qml — FontLoader set for the Red Hat Display font family
    used by the SilentSDDM-ported lockscreen theme.
*/
import QtQuick

Item {
    id: fontRoot
    visible: false

    // Red Hat Display — all weights
    FontLoader { source: "fonts/redhat/RedHatDisplay-Light.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-LightItalic.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-Regular.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-Italic.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-Medium.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-MediumItalic.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-SemiBold.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-SemiBoldItalic.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-Bold.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-BoldItalic.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-ExtraBold.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-ExtraBoldItalic.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-Black.otf" }
    FontLoader { source: "fonts/redhat/RedHatDisplay-BlackItalic.otf" }

    // Red Hat Mono (optional, for any monospace UI)
    FontLoader { source: "fonts/redhat/RedHatMono-Regular.otf" }
    FontLoader { source: "fonts/redhat/RedHatMono-Medium.otf" }
    FontLoader { source: "fonts/redhat/RedHatMono-SemiBold.otf" }
    FontLoader { source: "fonts/redhat/RedHatMono-Bold.otf" }

    // Red Hat Text
    FontLoader { source: "fonts/redhat/RedHatText-Regular.otf" }
    FontLoader { source: "fonts/redhat/RedHatText-Medium.otf" }
    FontLoader { source: "fonts/redhat/RedHatText-SemiBold.otf" }
    FontLoader { source: "fonts/redhat/RedHatText-Bold.otf" }
}
