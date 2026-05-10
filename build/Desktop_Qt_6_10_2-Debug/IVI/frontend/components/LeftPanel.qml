import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: "#22223b"
    radius: 10

    // Navigation component creators
    Component { id: profileComp;       ProfilePage       {} }
    Component { id: lightsComp;        LightsPage        {} }
    Component { id: climateComp;       ClimatePage       {} }
    Component { id: settingsComp;      SettingsPage      {} }
    Component { id: voiceComp;         VoiceAssistantPage{} }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // ── Profile Section ──────────────────
        Rectangle {
            width: parent.width
            height: 70
            color: "#2d2d44"
            radius: 8

            Row {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Rectangle {
                    width: 45
                    height: 45
                    radius: 22
                    color: "#7c3aed"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "R"
                        color: "white"
                        font.pixelSize: 20
                        font.bold: true
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Text {
                        text: "Hi, Abdelfattah"
                        color: "white"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Text {
                        text: "0 Messages Today"
                        color: "#888899"
                        font.pixelSize: 11
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push(profileComp)
            }
        }

        // ── Divider ──────────────────────────
        Rectangle {
            width: parent.width
            height: 1
            color: "#333355"
        }

        // ── Lights Button ─────────────────────
        Rectangle {
            width: parent.width
            height: 45
            color: "#2d2d44"
            radius: 8

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Text {
                    text: "💡"
                    font.pixelSize: 18
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "LIGHTS"
                    color: "white"
                    font.pixelSize: 13
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push(lightsComp)
            }
        }

        // ── Climate Button ───────────────────
        Rectangle {
            width: parent.width
            height: 45
            color: "#2d2d44"
            radius: 8

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Text {
                    text: "❄️"
                    font.pixelSize: 18
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "CLIMATE"
                    color: "white"
                    font.pixelSize: 13
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push(climateComp)
            }
        }

        // ── Settings Button ──────────────────
        Rectangle {
            width: parent.width
            height: 45
            color: "#2d2d44"
            radius: 8

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Text {
                    text: "⚙️"
                    font.pixelSize: 18
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "SETTINGS"
                    color: "white"
                    font.pixelSize: 13
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push(settingsComp)
            }
        }

        // ── Voice Button ─────────────────────
        Rectangle {
            width: parent.width
            height: 45
            color: "#7c3aed"
            radius: 8

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Text {
                    text: "🎤"
                    font.pixelSize: 18
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "VOICE"
                    color: "white"
                    font.pixelSize: 13
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push(voiceComp)
            }
        }
    }
}
