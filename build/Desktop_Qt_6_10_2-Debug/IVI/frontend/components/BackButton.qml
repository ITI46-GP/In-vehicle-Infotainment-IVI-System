import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    width: 120
    height: 45
    color: "#7c3aed"
    radius: 8
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.margins: 20
    z: 10

    Text {
        anchors.centerIn: parent
        text: "← Back"
        color: "white"
        font.pixelSize: 14
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: stackView.pop()
    }
}
