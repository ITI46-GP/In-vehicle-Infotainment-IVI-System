import QtQuick 2.15
import QtQuick.Controls 2.15
import IVI

Window {
    id: root
    width: 1280
    height: 720
    visible: true
    title: "Tesla IVI"
    color: "#1a1a2e"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Dashboard {}
    }
}
