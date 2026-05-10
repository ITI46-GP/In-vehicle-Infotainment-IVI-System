import QtQuick 2.15
import QtQuick.Controls 2.15
import IVI

Rectangle {
    anchors.fill: parent
    color: "#1a1a2e"

    Row {
        id: mainContent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomBar.top
        spacing: 4

        LeftPanel {
            id: leftPanel
            width: parent.width * 0.25
            height: parent.height
        }

        CenterPanel {
            id: centerPanel
            width: parent.width * 0.40
            height: parent.height
        }

        RightPanel {
            id: rightPanel
            width: parent.width * 0.35
            height: parent.height
        }
    }

    BottomBar {
        id: bottomBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
    }
}
