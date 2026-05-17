pragma ComponentBehavior: Bound

import QtQuick

Item {
    id: root
    width: 1024
    height: 600

    signal backClicked()
    signal keyboardRequested(var textInput)

    property color bg: "#07000E"
    property color panel: "#090613"
    property color line: "#342544"
    property color text: "#CBC4CD"
    property color muted: "#8F7AA8"
    property color violet: "#8B5CF6"
    property color cyan: "#21D4FD"
    property color red: "#A6080D"

    property string currentLocation: "Current Location"
    property string destination: "Smart Village"
    property bool routeActive: false
    property bool trafficOn: true
    property int zoomLevel: 120
    property int etaMinutes: 18
    property real distanceKm: 12.4

    Rectangle {
        anchors.fill: parent
        color: root.bg

        Rectangle {
            anchors.fill: parent
            opacity: 0.65
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#10081A" }
                GradientStop { position: 0.55; color: "#07000E" }
                GradientStop { position: 1.0; color: "#050009" }
            }
        }

        Rectangle {
            width: 360
            height: 360
            radius: 180
            x: -130
            y: 120
            color: root.violet
            opacity: 0.055
        }

        Rectangle {
            width: 460
            height: 460
            radius: 230
            anchors.right: parent.right
            anchors.rightMargin: -180
            anchors.top: parent.top
            anchors.topMargin: 58
            color: root.cyan
            opacity: 0.035
        }
    }

    Row {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        anchors.topMargin: 22
        height: 52
        spacing: 18

        TouchIconButton {
            width: 52
            height: 52
            iconText: "‹"
            onClicked: root.backClicked()
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Text {
                text: "LIVE NAVIGATION"
                color: root.muted
                font.pixelSize: 11
                font.bold: true
                font.letterSpacing: 2.4
            }

            Text {
                text: "Map & Route Planner"
                color: "#F4EEF7"
                font.pixelSize: 24
                font.bold: true
            }
        }
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        anchors.topMargin: 22
        anchors.bottomMargin: 26
        spacing: 22

        Rectangle {
            width: 292
            height: parent.height
            radius: 30
            color: root.panel
            border.color: root.line
            border.width: 1
            clip: true

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                opacity: 0.42
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#241238" }
                    GradientStop { position: 0.52; color: "#111023" }
                    GradientStop { position: 1.0; color: "#07000E" }
                }
            }

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                Text {
                    text: "DESTINATION"
                    color: root.muted
                    font.pixelSize: 11
                    font.bold: true
                    font.letterSpacing: 2.2
                }

                Rectangle {
                    width: parent.width
                    height: 48
                    radius: 17
                    color: "#080512"
                    border.color: destinationInput.activeFocus ? root.cyan : root.line
                    border.width: 1

                    TextInput {
                        id: destinationInput
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15

                        text: root.destination
                        color: "#F4EEF7"
                        selectionColor: root.violet
                        selectedTextColor: "#FFFFFF"
                        font.pixelSize: 15
                        clip: true

                        onActiveFocusChanged: {
                            if (activeFocus) {
                                root.keyboardRequested(destinationInput)
                            }
                        }

                        onTextChanged: {
                            root.destination = text
                        }

                        onAccepted: {
                            root.setRoute(destinationInput.text)
                        }
                    }
                }

                Row {
                    width: parent.width
                    height: 40
                    spacing: 10

                    TouchPillButton {
                        width: (parent.width - 10) / 2
                        height: 40
                        text: root.routeActive ? "UPDATE" : "SET ROUTE"

                        onClicked: {
                            root.setRoute(destinationInput.text)
                        }
                    }

                    TouchPillButton {
                        width: (parent.width - 10) / 2
                        height: 40
                        text: "CLEAR"

                        onClicked: {
                            root.routeActive = false
                            mapCanvas.requestPaint()
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 94
                    radius: 20
                    color: "#080512"
                    border.color: root.routeActive ? root.violet : root.line
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 7

                        Text {
                            text: root.routeActive ? "ACTIVE ROUTE" : "ROUTE PREVIEW"
                            color: root.routeActive ? root.cyan : root.muted
                            font.pixelSize: 10
                            font.bold: true
                            font.letterSpacing: 1.8
                        }

                        Text {
                            width: parent.width
                            text: root.routeActive ? root.destination : "Set destination to preview"
                            color: "#F4EEF7"
                            font.pixelSize: 15
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Row {
                            width: parent.width
                            height: 34
                            spacing: 8

                            RouteMiniMetric {
                                width: (parent.width - 16) / 3
                                title: "ETA"
                                value: root.routeActive ? root.etaMinutes + "m" : "--"
                            }

                            RouteMiniMetric {
                                width: (parent.width - 16) / 3
                                title: "DIST"
                                value: root.routeActive ? root.distanceKm + "km" : "--"
                            }

                            RouteMiniMetric {
                                width: (parent.width - 16) / 3
                                title: "MODE"
                                value: "EV"
                            }
                        }
                    }
                }

                Text {
                    text: "QUICK DESTINATIONS"
                    color: root.muted
                    font.pixelSize: 11
                    font.bold: true
                    font.letterSpacing: 2.0
                }

                DestinationButton {
                    width: parent.width
                    height: 42
                    title: "Home"
                    subtitle: "Saved place · 8 min"

                    onClicked: {
                        destinationInput.text = "Home"
                        root.destination = "Home"
                        root.etaMinutes = 8
                        root.distanceKm = 4.2
                        root.routeActive = true
                        mapCanvas.requestPaint()
                    }
                }

                DestinationButton {
                    width: parent.width
                    height: 42
                    title: "ITI Campus"
                    subtitle: "Training destination · 22 min"

                    onClicked: {
                        destinationInput.text = "ITI Campus"
                        root.destination = "ITI Campus"
                        root.etaMinutes = 22
                        root.distanceKm = 16.8
                        root.routeActive = true
                        mapCanvas.requestPaint()
                    }
                }

                DestinationButton {
                    width: parent.width
                    height: 42
                    title: "Charging Station"
                    subtitle: "Nearest charger · 11 min"

                    onClicked: {
                        destinationInput.text = "Charging Station"
                        root.destination = "Charging Station"
                        root.etaMinutes = 11
                        root.distanceKm = 7.6
                        root.routeActive = true
                        mapCanvas.requestPaint()
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 38
                    radius: 16
                    color: "#080512"
                    border.color: root.line
                    border.width: 1

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        text: "GPS"
                        color: root.muted
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1.5
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        text: "LOCKED"
                        color: root.cyan
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 1.4
                    }
                }
            }
        }

        Rectangle {
            width: parent.width - 292 - 22
            height: parent.height
            radius: 30
            color: root.panel
            border.color: root.line
            border.width: 1
            clip: true

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "#05020B"
            }

            Canvas {
                id: mapCanvas
                anchors.fill: parent

                Connections {
                    target: root

                    function onRouteActiveChanged() {
                        mapCanvas.requestPaint()
                    }

                    function onTrafficOnChanged() {
                        mapCanvas.requestPaint()
                    }

                    function onZoomLevelChanged() {
                        mapCanvas.requestPaint()
                    }
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"

                    var cx = width / 2
                    var cy = height / 2

                    function strokeRoundedRect(x, y, rectWidth, rectHeight, radius) {
                        ctx.beginPath()
                        ctx.moveTo(x + radius, y)
                        ctx.lineTo(x + rectWidth - radius, y)
                        ctx.quadraticCurveTo(x + rectWidth, y, x + rectWidth, y + radius)
                        ctx.lineTo(x + rectWidth, y + rectHeight - radius)
                        ctx.quadraticCurveTo(x + rectWidth, y + rectHeight,
                                             x + rectWidth - radius, y + rectHeight)
                        ctx.lineTo(x + radius, y + rectHeight)
                        ctx.quadraticCurveTo(x, y + rectHeight, x, y + rectHeight - radius)
                        ctx.lineTo(x, y + radius)
                        ctx.quadraticCurveTo(x, y, x + radius, y)
                        ctx.closePath()
                        ctx.stroke()
                    }

                    // soft map glow
                    var glow = ctx.createRadialGradient(cx, cy, 10, cx, cy, width * 0.75)
                    glow.addColorStop(0, "rgba(33, 212, 253, 0.06)")
                    glow.addColorStop(0.45, "rgba(139, 92, 246, 0.04)")
                    glow.addColorStop(1, "rgba(0, 0, 0, 0)")
                    ctx.fillStyle = glow
                    ctx.fillRect(0, 0, width, height)

                    // grid
                    ctx.strokeStyle = "rgba(139, 92, 246, 0.12)"
                    ctx.lineWidth = 1

                    for (var x = -80; x < width + 160; x += 72) {
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x - 95, height)
                        ctx.stroke()
                    }

                    for (var y = 30; y < height; y += 58) {
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y + 42)
                        ctx.stroke()
                    }

                    // district blocks
                    ctx.strokeStyle = "rgba(52, 37, 68, 0.30)"
                    ctx.lineWidth = 1.4

                    for (var i = 0; i < 5; ++i) {
                        strokeRoundedRect(80 + i * 110, 72 + (i % 2) * 34, 88, 54, 12)
                    }

                    for (var j = 0; j < 4; ++j) {
                        strokeRoundedRect(120 + j * 118, height - 160 - (j % 2) * 38, 92, 52, 12)
                    }

                    // secondary roads
                    ctx.strokeStyle = "rgba(203, 196, 205, 0.10)"
                    ctx.lineWidth = 5

                    ctx.beginPath()
                    ctx.moveTo(70, 86)
                    ctx.bezierCurveTo(190, 155, 340, 252, width - 95, height - 88)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(86, height - 54)
                    ctx.bezierCurveTo(190, 350, 360, 330, width - 130, 238)
                    ctx.stroke()

                    // main road shadow
                    ctx.strokeStyle = "rgba(203, 196, 205, 0.15)"
                    ctx.lineWidth = 10
                    ctx.beginPath()
                    ctx.moveTo(80, height - 110)
                    ctx.bezierCurveTo(200, height - 190, 350, height - 160, width - 105, 90)
                    ctx.stroke()

                    // main road core
                    ctx.strokeStyle = "rgba(203, 196, 205, 0.10)"
                    ctx.lineWidth = 5
                    ctx.beginPath()
                    ctx.moveTo(80, height - 110)
                    ctx.bezierCurveTo(200, height - 190, 350, height - 160, width - 105, 90)
                    ctx.stroke()

                    if (root.routeActive) {
                        // route outer glow
                        ctx.strokeStyle = "rgba(33, 212, 253, 0.26)"
                        ctx.lineWidth = 15
                        ctx.beginPath()
                        ctx.moveTo(90, height - 118)
                        ctx.bezierCurveTo(205, height - 196, 352, height - 160, width - 112, 100)
                        ctx.stroke()

                        // route line
                        ctx.strokeStyle = "rgba(33, 212, 253, 0.95)"
                        ctx.lineWidth = 6
                        ctx.beginPath()
                        ctx.moveTo(90, height - 118)
                        ctx.bezierCurveTo(205, height - 196, 352, height - 160, width - 112, 100)
                        ctx.stroke()

                        // violet highlight
                        ctx.strokeStyle = "rgba(139, 92, 246, 0.82)"
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(90, height - 118)
                        ctx.bezierCurveTo(205, height - 196, 352, height - 160, width - 112, 100)
                        ctx.stroke()
                    }

                    if (root.trafficOn) {
                        ctx.strokeStyle = "rgba(166, 8, 13, 0.85)"
                        ctx.lineWidth = 5
                        ctx.beginPath()
                        ctx.moveTo(width - 260, 178)
                        ctx.lineTo(width - 200, 150)
                        ctx.stroke()
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 22
                anchors.topMargin: 20
                width: 246
                height: 68
                radius: 22
                color: "#090613"
                border.color: root.line
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 3

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.routeActive ? "ROUTE TO" : "CURRENT MAP"
                        color: root.muted
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1.8
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 210
                        text: root.routeActive ? root.destination : root.currentLocation
                        color: "#F4EEF7"
                        font.pixelSize: 16
                        font.bold: true
                        elide: Text.ElideRight
                    }
                }
            }

            Row {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 22
                anchors.topMargin: 20
                spacing: 10

                MapChip {
                    text: root.trafficOn ? "TRAFFIC ON" : "TRAFFIC OFF"
                    active: root.trafficOn

                    onClicked: {
                        root.trafficOn = !root.trafficOn
                    }
                }

                MapChip {
                    text: root.zoomLevel + "%"
                    active: true

                    onClicked: {
                        root.zoomLevel = root.zoomLevel >= 160 ? 100 : root.zoomLevel + 10
                    }
                }
            }

            Rectangle {
                width: 18
                height: 18
                radius: 9
                x: 84
                y: parent.height - 126
                color: root.cyan
                border.color: "#FFFFFF"
                border.width: 3
            }

            Text {
                x: 112
                y: parent.height - 130
                text: "You"
                color: "#F4EEF7"
                font.pixelSize: 13
                font.bold: true
            }

            Rectangle {
                visible: root.routeActive
                width: 18
                height: 18
                radius: 9
                x: parent.width - 124
                y: 92
                color: root.violet
                border.color: "#FFFFFF"
                border.width: 3
            }

            Text {
                visible: root.routeActive
                x: parent.width - 220
                y: 118
                width: 190
                horizontalAlignment: Text.AlignRight
                text: root.destination
                color: "#F4EEF7"
                font.pixelSize: 13
                font.bold: true
                elide: Text.ElideRight
            }

            Column {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 22
                spacing: 10

                MapRoundButton {
                    text: "+"
                    onClicked: root.zoomLevel = Math.min(180, root.zoomLevel + 10)
                }

                MapRoundButton {
                    text: "-"
                    onClicked: root.zoomLevel = Math.max(80, root.zoomLevel - 10)
                }

                MapRoundButton {
                    text: "⌖"
                    onClicked: {
                        root.routeActive = false
                        mapCanvas.requestPaint()
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 22
                anchors.rightMargin: 104
                anchors.bottomMargin: 22
                height: 58
                radius: 21
                color: "#090613"
                border.color: root.routeActive ? root.violet : root.line
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 14

                    RouteFooterMetric {
                        width: 90
                        anchors.verticalCenter: parent.verticalCenter
                        title: "ETA"
                        value: root.routeActive ? root.etaMinutes + " min" : "--"
                    }

                    RouteFooterMetric {
                        width: 110
                        anchors.verticalCenter: parent.verticalCenter
                        title: "DIST"
                        value: root.routeActive ? root.distanceKm + " km" : "--"
                    }

                    Rectangle {
                        width: 1
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter
                        color: root.line
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 245
                        text: root.routeActive ? "Route ready · traffic monitored · EV mode" : "Set a destination to preview route."
                        color: root.muted
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    function setRoute(name) {
        if (name.length <= 0)
            return

        root.destination = name
        root.routeActive = true

        if (name.toLowerCase() === "home") {
            root.etaMinutes = 8
            root.distanceKm = 4.2
        } else if (name.toLowerCase().indexOf("iti") !== -1) {
            root.etaMinutes = 22
            root.distanceKm = 16.8
        } else if (name.toLowerCase().indexOf("charging") !== -1) {
            root.etaMinutes = 11
            root.distanceKm = 7.6
        } else {
            root.etaMinutes = 18
            root.distanceKm = 12.4
        }

        mapCanvas.requestPaint()
    }

    component TouchIconButton: Item {
        id: iconBtn
        property string iconText: ""
        signal clicked()

        Rectangle {
            anchors.fill: parent
            radius: 18
            color: tap.pressed ? "#171025" : "#090613"
            border.color: tap.pressed ? root.violet : root.line
            border.width: 1
            scale: tap.pressed ? 0.94 : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: 110
                    easing.type: Easing.OutQuad
                }
            }

            Text {
                anchors.centerIn: parent
                text: iconBtn.iconText
                color: tap.pressed ? "#FFFFFF" : root.text
                font.pixelSize: 34
                font.bold: true
            }
        }

        TapHandler {
            id: tap
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: iconBtn.clicked()
        }
    }

    component TouchPillButton: Item {
        id: pill
        property string text: ""
        signal clicked()

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: tap.pressed ? root.violet : "#171025"
            border.color: tap.pressed ? "#B99CFF" : "#352347"
            border.width: 1
            scale: tap.pressed ? 0.96 : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: 110
                    easing.type: Easing.OutQuad
                }
            }

            Text {
                anchors.centerIn: parent
                text: pill.text
                color: tap.pressed ? "#FFFFFF" : root.text
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1.4
            }
        }

        TapHandler {
            id: tap
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: pill.clicked()
        }
    }

    component DestinationButton: Item {
        id: dest
        property string title: ""
        property string subtitle: ""
        signal clicked()

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: tap.pressed ? "#171025" : "#080512"
            border.color: tap.pressed ? root.violet : root.line
            border.width: 1
            scale: tap.pressed ? 0.98 : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: 110
                    easing.type: Easing.OutQuad
                }
            }

            Column {
                anchors.left: parent.left
                anchors.leftMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: dest.title
                    color: "#F4EEF7"
                    font.pixelSize: 13
                    font.bold: true
                }

                Text {
                    text: dest.subtitle
                    color: root.muted
                    font.pixelSize: 9
                }
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                text: "›"
                color: tap.pressed ? root.cyan : root.muted
                font.pixelSize: 21
            }
        }

        TapHandler {
            id: tap
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: dest.clicked()
        }
    }

    component RouteMiniMetric: Rectangle {
        id: metric
        property string title: ""
        property string value: ""

        height: 34
        radius: 12
        color: "#06030B"
        border.color: root.line
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: metric.title
                color: root.muted
                font.pixelSize: 7
                font.bold: true
                font.letterSpacing: 1.1
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: metric.value
                color: "#F4EEF7"
                font.pixelSize: 10
                font.bold: true
            }
        }
    }

    component RouteFooterMetric: Item {
        id: metric
        property string title: ""
        property string value: ""

        height: 42

        Column {
            anchors.centerIn: parent
            spacing: 3

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: metric.title
                color: root.muted
                font.pixelSize: 8
                font.bold: true
                font.letterSpacing: 1.2
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: metric.value
                color: "#F4EEF7"
                font.pixelSize: 12
                font.bold: true
            }
        }
    }

    component MapChip: Item {
        id: chip
        property string text: ""
        property bool active: false
        signal clicked()

        width: 112
        height: 34

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: tap.pressed ? "#171025" : "#090613"
            border.color: chip.active ? root.cyan : root.line
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: chip.text
                color: chip.active ? root.cyan : root.muted
                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 1.2
            }
        }

        TapHandler {
            id: tap
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: chip.clicked()
        }
    }

    component MapRoundButton: Item {
        id: roundBtn
        property string text: ""
        signal clicked()

        width: 42
        height: 42

        Rectangle {
            anchors.fill: parent
            radius: 21
            color: tap.pressed ? root.violet : "#090613"
            border.color: tap.pressed ? "#B99CFF" : root.line
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: roundBtn.text
                color: "#F4EEF7"
                font.pixelSize: roundBtn.text === "⌖" ? 18 : 20
                font.bold: true
            }
        }

        TapHandler {
            id: tap
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: roundBtn.clicked()
        }
    }
}
