import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: "#16213e"
    radius: 10

    // ── TOP BAR ──────────────────────────────
    Rectangle {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        color: "transparent"

        Row {
            anchors.centerIn: parent
            spacing: 12

            // Tesla Logo
            Text {
                text: "T"
                color: "white"
                font.pixelSize: 28
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            // Model name
            Text {
                text: "Tesla Model 3"
                color: "#aaaacc"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }

            // Battery indicator
            Rectangle {
                width: 60
                height: 24
                color: "#1a5c1a"
                radius: 4
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        text: "60%"
                        color: "#44ff44"
                        font.pixelSize: 12
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    // ── SPEED DISPLAY ────────────────────────
    Column {
        id: speedDisplay
        anchors.top: topBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "132"
            color: "white"
            font.pixelSize: 72
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "mph"
            color: "#aaaacc"
            font.pixelSize: 18
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "344 miles range"
            color: "#44ff44"
            font.pixelSize: 13
        }
    }

    // ── SPEED LIMIT SIGNS ───────────────────
    Column {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: topBar.bottom
        anchors.topMargin: 20
        spacing: 8

        // Speed limit sign 1
        Rectangle {
            width: 44
            height: 44
            radius: 22
            color: "white"
            border.color: "red"
            border.width: 4

            Text {
                anchors.centerIn: parent
                text: "110"
                color: "black"
                font.pixelSize: 12
                font.bold: true
            }
        }

        // Speed limit sign 2
        Rectangle {
            width: 44
            height: 44
            radius: 22
            color: "white"
            border.color: "red"
            border.width: 4

            Text {
                anchors.centerIn: parent
                text: "80"
                color: "black"
                font.pixelSize: 12
                font.bold: true
            }
        }
    }

    // ── CAR IMAGE ───────────────────────────
    Rectangle {
        id: carContainer
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 30
        width: 160
        height: 280
        color: "transparent"

        // Glow effect under car
        Rectangle {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 20
            width: 120
            height: 200
            radius: 60
            color: "#1a3a1a"
            opacity: 0.6
        }

        // Car placeholder (replace with Image when you have asset)
        Rectangle {
            anchors.centerIn: parent
            width: 100
            height: 220
            color: "#e8e8e8"
            radius: 30

            // Car body shape simulation
            Column {
                anchors.centerIn: parent
                spacing: 5

                Rectangle {
                    width: 70
                    height: 60
                    color: "#cccccc"
                    radius: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: 90
                    height: 100
                    color: "#dddddd"
                    radius: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: 80
                    height: 40
                    color: "#cccccc"
                    radius: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Text {
                anchors.centerIn: parent
                text: "🚗"
                font.pixelSize: 60
            }
        }

        // Red brake indicator at bottom of car
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 80
            height: 8
            color: "#ff3333"
            radius: 4
            opacity: 0.8
        }
    }

    // ── GEAR SELECTOR ───────────────────────
    Rectangle {
        id: gearSelector
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 20
        height: 50
        color: "transparent"

        Row {
            anchors.centerIn: parent
            spacing: 20

            // P
            Text {
                text: "P"
                color: "#aaaacc"
                font.pixelSize: 22
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            // E
            Text {
                text: "E"
                color: "#aaaacc"
                font.pixelSize: 22
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            // D - Active (highlighted)
            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: "#44ff44"
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "D"
                    color: "#1a1a2e"
                    font.pixelSize: 22
                    font.bold: true
                }
            }

            // N
            Text {
                text: "N"
                color: "#aaaacc"
                font.pixelSize: 22
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            // M
            Text {
                text: "M"
                color: "#aaaacc"
                font.pixelSize: 22
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // ── AUTOPILOT ICONS ─────────────────────
    Row {
        anchors.bottom: gearSelector.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15

        // Lane icon
        Rectangle {
            width: 32
            height: 32
            radius: 16
            color: "#2d2d55"

            Text {
                anchors.centerIn: parent
                text: "≡"
                color: "white"
                font.pixelSize: 16
            }
        }

        // Auto icon
        Rectangle {
            width: 32
            height: 32
            radius: 16
            color: "#2d2d55"

            Text {
                anchors.centerIn: parent
                text: "◎"
                color: "white"
                font.pixelSize: 14
            }
        }
    }
}
