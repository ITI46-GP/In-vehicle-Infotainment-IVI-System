import QtQuick

Item {
    id: root
    width: 276
    height: 444

    signal mediaClicked()
    signal mapClicked()

    property color bg: "#07000E"
    property color panel: "#090613"
    property color line: "#342544"
    property color text: "#CBC4CD"
    property color muted: "#8F7AA8"
    property color violet: "#8B5CF6"
    property color cyan: "#21D4FD"
    property color red: "#A6080D"
    readonly property bool compact: width < 320 || height < 470
    readonly property real panelSpacing: compact ? 12 : 16
    readonly property real mediaHeight: compact ? 126 : 132

    // Live media mock state
    property int trackIndex: 0

    property var playlist: [
        { "title": "When I Was A Child", "artist": "Jerry Max", "album": "Solar" },
        { "title": "Night Drive", "artist": "Volt Audio", "album": "EV Sessions" },
        { "title": "Electric Roads", "artist": "Nova Lane", "album": "Afterglow" }
    ]
    property bool isPlaying: audioManager ? audioManager.playing : false
    property string songTitle: audioManager ? audioManager.currentSongTitle : "No Media"
    property string songArtist: ""
    property string songAlbum: ""
    property real mediaProgress: audioManager ? (audioManager.position / audioManager.duration) : 0

    // Live navigation mock state
    property bool routeActive: false
    property string currentLocation: "Current location"
    property string destination: ""
    property string etaText: "--"
    property string distanceText: "--"

    property bool childTapActive: false

    Timer {
        id: childTapReleaseTimer
        interval: 90
        repeat: false
        onTriggered: root.childTapActive = false
    }

    function beginChildTap() {
        root.childTapActive = true
        childTapReleaseTimer.stop()
    }

    function endChildTap() {
        childTapReleaseTimer.restart()
    }

    Timer {
        interval: 900
        running: root.isPlaying
        repeat: true

        onTriggered: {
            root.mediaProgress += 0.015

            if (root.mediaProgress >= 1.0) {
                root.mediaProgress = 0.0
                root.nextTrack()
            }
        }
    }

    function playPause() {
        root.isPlaying = !root.isPlaying
    }

    function nextTrack() {
        root.trackIndex = (root.trackIndex + 1) % root.playlist.length
        root.mediaProgress = 0.0
    }

    function previousTrack() {
        root.trackIndex = (root.trackIndex - 1 + root.playlist.length) % root.playlist.length
        root.mediaProgress = 0.0
    }

    function mockSearchDestination() {
        root.destination = "Mountain View"
        root.etaText = "22 min"
        root.distanceText = "14.2 km"
        root.routeActive = true
    }

    Column {
        anchors.fill: parent
        spacing: root.panelSpacing

        // Live Media Widget
        Rectangle {
            id: mediaCard
            width: parent.width
            height: root.mediaHeight
            radius: root.compact ? 22 : 28
            color: root.panel
            border.color: mediaTap.pressed ? root.violet : root.line
            border.width: 1
            scale: mediaTap.pressed ? 0.99 : 1.0
            transformOrigin: Item.Center

            Behavior on scale {
                NumberAnimation {
                    duration: 110
                    easing.type: Easing.OutQuad
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                opacity: mediaTap.pressed ? 0.52 : 0.36

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#2A1742" }
                    GradientStop { position: 0.56; color: "#151023" }
                    GradientStop { position: 1.0; color: "#080512" }
                }
            }

            Rectangle {
                width: root.compact ? 88 : 112
                height: width
                radius: width / 2
                anchors.right: parent.right
                anchors.rightMargin: root.compact ? -24 : -34
                anchors.verticalCenter: parent.verticalCenter
                color: root.violet
                opacity: root.isPlaying ? 0.13 : 0.06
            }

            // album placeholder
            Rectangle {
                id: album
                width: root.compact ? 62 : 76
                height: width
                radius: root.compact ? 20 : 24
                anchors.left: parent.left
                anchors.leftMargin: root.compact ? 14 : 18
                anchors.verticalCenter: parent.verticalCenter
                color: "#171025"
                border.color: root.isPlaying ? root.violet : "#4B2C73"
                border.width: 1

                Rectangle {
                    width: root.compact ? 42 : 48
                    height: width
                    radius: width / 2
                    anchors.centerIn: parent
                    color: "#21152F"
                    border.color: "#4B2C73"
                    border.width: 1

                    Canvas {
                        anchors.fill: parent
                        opacity: 0.92

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)

                            ctx.strokeStyle = "#CBC4CD"
                            ctx.fillStyle = "#CBC4CD"
                            ctx.lineWidth = 1.8
                            ctx.lineCap = "round"

                            ctx.beginPath()
                            ctx.moveTo(18, 13)
                            ctx.lineTo(18, 31)
                            ctx.stroke()

                            ctx.beginPath()
                            ctx.moveTo(18, 13)
                            ctx.lineTo(32, 10)
                            ctx.lineTo(32, 27)
                            ctx.stroke()

                            ctx.beginPath()
                            ctx.arc(15, 32, 4, 0, Math.PI * 2)
                            ctx.fill()

                            ctx.beginPath()
                            ctx.arc(29, 28, 4, 0, Math.PI * 2)
                            ctx.fill()
                        }
                    }
                }
            }

            // song info - top area only
            Column {
                id: songInfo
                anchors.left: album.right
                anchors.leftMargin: root.compact ? 14 : 18
                anchors.right: parent.right
                anchors.rightMargin: root.compact ? 14 : 22
                anchors.top: parent.top
                anchors.topMargin: root.compact ? 16 : 18
                spacing: root.compact ? 3 : 4

                Text {
                    text: root.isPlaying ? "NOW PLAYING" : "PAUSED"
                    color: root.isPlaying ? root.cyan : root.muted
                    font.pixelSize: root.compact ? 9 : 10
                    font.bold: true
                    font.letterSpacing: root.compact ? 1.8 : 2.4
                }

                Text {
                    text: root.songTitle
                    color: "#F4EEF7"
                    font.pixelSize: root.compact ? 14 : 16
                    font.bold: true
                    elide: Text.ElideRight
                    width: parent.width
                }

                Text {
                    text: root.songArtist + " · " + root.songAlbum
                    color: root.muted
                    font.pixelSize: root.compact ? 10 : 11
                    elide: Text.ElideRight
                    width: parent.width
                    opacity: 0.92
                }
            }

            // bottom control strip
            Row {
                id: mediaControls
                anchors.left: album.right
                anchors.leftMargin: root.compact ? 14 : 18
                anchors.bottom: parent.bottom
                anchors.bottomMargin: root.compact ? 14 : 16
                spacing: root.compact ? 9 : 12

                MediaControlButton {
                    icon: "‹"
                    onClicked:{
                        if (audioManager) audioManager.prev()
                        }
                }

                MediaControlButton {
                    icon: root.isPlaying ? "Ⅱ" : "▶"
                    active: true
                    onClicked: {
                        if (audioManager) audioManager.togglePlayPause()
                    }
                }

                MediaControlButton {
                    icon: "›"
                    onClicked: {
                    if (audioManager) audioManager.next()
                }
                }
            }

            // progress bar separated from buttons
            Rectangle {
                width: root.compact ? 52 : 86
                height: 4
                radius: 2
                anchors.right: parent.right
                anchors.rightMargin: root.compact ? 14 : 24
                anchors.verticalCenter: mediaControls.verticalCenter
                color: "#342544"

                Rectangle {
                    width: parent.width * root.mediaProgress
                    height: parent.height
                    radius: 2
                    color: root.isPlaying ? root.cyan : root.muted
                    opacity: root.isPlaying ? 0.9 : 0.45
                }
            }

            TapHandler {
                id: mediaTap
                gesturePolicy: TapHandler.ReleaseWithinBounds

                onTapped: {
                    if (!root.childTapActive) {
                        root.mediaClicked()
                    }
                }
            }
        }

        // Live Navigation Widget
        Rectangle {
            id: mapCard
            width: parent.width
            height: parent.height - mediaCard.height - root.panelSpacing
            radius: root.compact ? 24 : 30
            color: root.panel
            border.color: mapTap.pressed ? root.violet : root.line
            border.width: 1
            clip: true
            scale: mapTap.pressed ? 0.99 : 1.0
            transformOrigin: Item.Center

            Behavior on scale {
                NumberAnimation {
                    duration: 110
                    easing.type: Easing.OutQuad
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                opacity: 0.68

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#101A2A" }
                    GradientStop { position: 0.55; color: "#0A1020" }
                    GradientStop { position: 1.0; color: "#07000E" }
                }
            }

            Canvas {
                id: mapCanvas
                anchors.fill: parent
                opacity: 0.86

                Connections {
                    target: root

                    function onRouteActiveChanged() {
                        mapCanvas.requestPaint()
                    }
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    ctx.strokeStyle = "rgba(139, 92, 246, 0.20)"
                    ctx.lineWidth = 1

                    for (var x = 28; x < width; x += 58) {
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }

                    for (var y = 42; y < height; y += 58) {
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }

                    ctx.strokeStyle = "rgba(203, 196, 205, 0.11)"
                    ctx.lineWidth = 1

                    ctx.beginPath()
                    ctx.moveTo(0, height * 0.28)
                    ctx.lineTo(width, height * 0.18)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(width * 0.12, 0)
                    ctx.lineTo(width * 0.88, height)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(width * 0.85, 0)
                    ctx.lineTo(width * 0.55, height)
                    ctx.stroke()

                    if (root.routeActive) {
                        ctx.strokeStyle = "rgba(33, 212, 253, 0.24)"
                        ctx.lineWidth = 9
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"

                        ctx.beginPath()
                        ctx.moveTo(width * 0.16, height * 0.84)
                        ctx.bezierCurveTo(width * 0.33, height * 0.66,
                                          width * 0.42, height * 0.48,
                                          width * 0.58, height * 0.36)
                        ctx.bezierCurveTo(width * 0.72, height * 0.27,
                                          width * 0.78, height * 0.18,
                                          width * 0.90, height * 0.10)
                        ctx.stroke()

                        ctx.strokeStyle = "#21D4FD"
                        ctx.lineWidth = 4

                        ctx.beginPath()
                        ctx.moveTo(width * 0.16, height * 0.84)
                        ctx.bezierCurveTo(width * 0.33, height * 0.66,
                                          width * 0.42, height * 0.48,
                                          width * 0.58, height * 0.36)
                        ctx.bezierCurveTo(width * 0.72, height * 0.27,
                                          width * 0.78, height * 0.18,
                                          width * 0.90, height * 0.10)
                        ctx.stroke()
                    }
                }
            }

            // Search / destination chip
            Rectangle {
                id: searchBar
                height: root.compact ? 42 : 46
                radius: root.compact ? 16 : 18
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: root.compact ? 14 : 16
                color: searchTap.pressed ? "#171025" : "#080512"
                border.color: searchTap.pressed ? root.violet : "#342544"
                border.width: 1
                opacity: 0.95

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: root.compact ? 14 : 18
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.routeActive ? root.destination : "Search destination"
                    color: root.routeActive ? "#F4EEF7" : root.muted
                    font.pixelSize: root.compact ? 12 : 13
                    font.bold: root.routeActive
                    elide: Text.ElideRight
                    width: parent.width - (root.compact ? 54 : 70)
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: root.compact ? 14 : 18
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.routeActive ? "✓" : "+"
                    color: root.routeActive ? root.cyan : root.text
                    font.pixelSize: 20
                    font.bold: true
                    opacity: 0.9
                }

                TapHandler {
                    id: searchTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds

                    onPressedChanged: {
                        if (pressed) {
                            root.beginChildTap()
                        } else {
                            root.endChildTap()
                        }
                    }

                    onTapped: {
                        root.mockSearchDestination()
                    }
                }
            }

            // current location marker
            Rectangle {
                width: 18
                height: 18
                radius: 9
                x: parent.width * 0.16 - width / 2
                y: parent.height * 0.84 - height / 2
                color: root.cyan
                border.color: "#FFFFFF"
                border.width: 2

                Rectangle {
                    anchors.centerIn: parent
                    width: 38
                    height: 38
                    radius: 19
                    color: root.cyan
                    opacity: 0.16
                }
            }

            // destination marker
            Rectangle {
                visible: root.routeActive
                width: 18
                height: 18
                radius: 9
                x: parent.width * 0.90 - width / 2
                y: parent.height * 0.10 - height / 2
                color: root.red
                border.color: "#FFFFFF"
                border.width: 2
            }

            // Current location label when no route
            Rectangle {
                visible: !root.routeActive
                width: root.compact ? 176 : 190
                height: root.compact ? 48 : 52
                radius: root.compact ? 16 : 18
                anchors.left: parent.left
                anchors.leftMargin: root.compact ? 14 : 18
                anchors.bottom: parent.bottom
                anchors.bottomMargin: root.compact ? 14 : 18
                color: "#080512"
                border.color: "#342544"
                border.width: 1
                opacity: 0.95

                Column {
                    anchors.left: parent.left
                    anchors.leftMargin: root.compact ? 14 : 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: root.compact ? 3 : 4

                    Text {
                        text: "LOCATION"
                        color: root.muted
                        font.pixelSize: root.compact ? 8 : 9
                        font.bold: true
                        font.letterSpacing: root.compact ? 1.3 : 1.8
                    }

                    Text {
                        text: root.currentLocation
                        color: "#F4EEF7"
                        font.pixelSize: root.compact ? 12 : 13
                        font.bold: true
                    }
                }
            }

            // route summary when destination selected
            Rectangle {
                visible: root.routeActive
                height: root.compact ? 50 : 54
                radius: root.compact ? 18 : 20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: root.compact ? 14 : 18
                anchors.rightMargin: root.compact ? 14 : 18
                anchors.bottomMargin: root.compact ? 14 : 18
                color: "#080512"
                border.color: "#342544"
                border.width: 1
                opacity: 0.95

                Row {
                    anchors.centerIn: parent
                    spacing: root.compact ? 10 : 24

                    TripMetric {
                        title: "ETA"
                        value: root.etaText
                    }

                    Rectangle {
                        width: 1
                        height: 22
                        color: "#342544"
                    }

                    TripMetric {
                        title: "DISTANCE"
                        value: root.distanceText
                    }

                    Rectangle {
                        width: 1
                        height: 22
                        color: "#342544"
                    }

                    TripMetric {
                        title: "DEST"
                        value: root.destination
                    }
                }
            }

            TapHandler {
                id: mapTap
                gesturePolicy: TapHandler.ReleaseWithinBounds

                onTapped: {
                    if (!root.childTapActive) {
                        root.mapClicked()
                    }
                }
            }
        }
    }

    component MediaControlButton: Item {
        id: mediaBtn
        width: root.compact ? 32 : 36
        height: width

        property string icon: ""
        property bool active: false

        signal clicked()

        Rectangle {
            anchors.fill: parent
            radius: 18
            color: mediaTapButton.pressed
                   ? root.violet
                   : (mediaBtn.active ? "#F4EEF7" : "#171025")
            border.color: mediaTapButton.pressed
                          ? "#B99CFF"
                          : (mediaBtn.active ? "#F4EEF7" : "#4B2C73")
            border.width: 1
            scale: mediaTapButton.pressed ? 0.92 : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutQuad
                }
            }

            Text {
                anchors.centerIn: parent
                text: mediaBtn.icon
                color: mediaTapButton.pressed
                       ? "#FFFFFF"
                       : (mediaBtn.active ? "#080512" : "#CBC4CD")
                font.pixelSize: mediaBtn.active ? (root.compact ? 12 : 13) : (root.compact ? 18 : 20)
                font.bold: true
            }
        }

        TapHandler {
            id: mediaTapButton
            gesturePolicy: TapHandler.ReleaseWithinBounds

            onPressedChanged: {
                if (pressed) {
                    root.beginChildTap()
                } else {
                    root.endChildTap()
                }
            }

            onTapped: {
                mediaBtn.clicked()
            }
        }
    }

    component TripMetric: Column {
        id: metric
        width: root.compact ? 62 : 78
        spacing: root.compact ? 2 : 3

        property string title: ""
        property string value: ""

        Text {
            text: metric.title
            color: root.muted
            font.pixelSize: root.compact ? 8 : 9
            font.bold: true
            font.letterSpacing: root.compact ? 1.2 : 1.8
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: metric.value
            color: "#F4EEF7"
            font.pixelSize: root.compact ? 11 : 13
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            elide: Text.ElideRight
            width: metric.width
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
