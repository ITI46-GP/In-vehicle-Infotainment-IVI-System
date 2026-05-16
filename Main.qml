import QtQuick
import QtQuick.Window
import "pages"

Window {
    id: root

    width: 1024
    height: 600
    minimumWidth: 820
    minimumHeight: 480

    visible: true
    title: qsTr("GP IVI")
    color: "#07000E"

    // Final board compatibility:
    // enable this flag on the embedded target for a borderless 7-inch display.
    // flags: Qt.FramelessWindowHint

    property bool splashFinished: false

    // This is our design resolution.
    // All screens/components are drawn inside this surface,
    // then scaled to fit any real window/screen size.
    readonly property int designWidth: 1024
    readonly property int designHeight: 600

    Rectangle {
        anchors.fill: parent
        color: "#07000E"
    }

    Item {
        id: appSurface

        width: root.designWidth
        height: root.designHeight

        anchors.centerIn: parent

        scale: Math.min(root.width / root.designWidth,
                        root.height / root.designHeight)

        transformOrigin: Item.Center


        SplashScreen {
            anchors.fill: parent
            opacity: root.splashFinished ? 0 : 1
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 700
                    easing.type: Easing.InOutQuad
                }
            }

            onFinished: {
                root.splashFinished = true
            }
        }

        DashboardPage {
            anchors.fill: parent
            opacity: root.splashFinished ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    // Test fullscreen quickly
    Shortcut {
        sequence: "F11"

        onActivated: {
            if (root.visibility === Window.FullScreen) {
                root.visibility = Window.Windowed
            } else {
                root.visibility = Window.FullScreen
            }
        }
    }

    // Exit / leave fullscreen
    Shortcut {
        sequence: "Esc"

        onActivated: {
            if (root.visibility === Window.FullScreen) {
                root.visibility = Window.Windowed
            } else {
                Qt.quit()
            }
        }
    }
}
