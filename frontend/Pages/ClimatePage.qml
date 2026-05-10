import QtQuick 2.15
import QtQuick.Controls 2.15
import IVI

Rectangle {
    anchors.fill: parent
    color: "#1a1a2e"

    Text {
        anchors.centerIn: parent
        text: "❄️ Climate Page"
        color: "white"
        font.pixelSize: 32
    }

    BackButton {}
}
