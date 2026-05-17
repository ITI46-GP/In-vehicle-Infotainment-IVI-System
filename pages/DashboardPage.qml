import QtQuick
import "../components"

Item {
    id: dashboardRoot
    width: 1024
    height: 600

    signal profileRequested()
    signal lightsRequested()
    signal settingsRequested()
    signal mapRequested()
    signal assistantRequested()
    signal mediaRequested()
    signal climateRequested()
    signal weatherRequested()

    readonly property real margin: Math.max(14, Math.min(18, width * 0.016))
    readonly property real gap: Math.max(12, Math.min(16, width * 0.014))
    readonly property real topBarHeight: Math.max(38, Math.min(42, height * 0.067))
    readonly property real bottomBarHeight: Math.max(66, Math.min(74, height * 0.116))
    readonly property real contentTop: topBarHeight + margin
    readonly property real contentBottom: height - margin - bottomBarHeight - gap
    readonly property real contentHeight: contentBottom - contentTop
    readonly property real sideWidth: Math.max(230, Math.min(248, width * 0.232))
    readonly property real centerWidth: Math.max(360, Math.min(390, width * 0.373))
    readonly property real rightWidth: Math.max(250, Math.min(280, width * 0.269))
    readonly property real contentGroupWidth: sideWidth + centerWidth + rightWidth + gap * 2
    readonly property real contentLeft: Math.max(margin, (width - contentGroupWidth) / 2)

    Rectangle {
        anchors.fill: parent
        color: "#07000E"
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.55

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1C162B" }
            GradientStop { position: 0.45; color: "#0A0A1B" }
            GradientStop { position: 1.0; color: "#07000E" }
        }
    }

    TopStatusBar {
        id: topStatusBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: dashboardRoot.topBarHeight
    }

    SideMenu {
        id: sideMenu
        x: dashboardRoot.contentLeft
        y: dashboardRoot.contentTop
        width: dashboardRoot.sideWidth
        height: dashboardRoot.contentHeight

        onProfileClicked:    dashboardRoot.profileRequested()
        onAssistantClicked:  dashboardRoot.assistantRequested()
        onLightsClicked:     dashboardRoot.lightsRequested()
        onClimateClicked:    dashboardRoot.climateRequested()
        onSettingsClicked:   dashboardRoot.settingsRequested()
    }

    VehicleOverviewCard {
        id: vehicleCard
        x: sideMenu.x + sideMenu.width + dashboardRoot.gap
        y: dashboardRoot.contentTop
        width: dashboardRoot.centerWidth
        height: dashboardRoot.contentHeight
    }

    RightPanel {
        id: rightPanel
        x: vehicleCard.x + vehicleCard.width + dashboardRoot.gap
        y: dashboardRoot.contentTop
        width: dashboardRoot.rightWidth
        height: dashboardRoot.contentHeight

        onMediaClicked: {
        console.log("RightPanel mediaClicked!")
        dashboardRoot.mediaRequested()
    }
    onMapClicked: {
        console.log("RightPanel mapClicked!")
        dashboardRoot.mapRequested()
    }
    }

    BottomNavBar {
        id: bottomNav
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: dashboardRoot.margin
        anchors.rightMargin: dashboardRoot.margin
        anchors.bottomMargin: dashboardRoot.margin
        height: dashboardRoot.bottomBarHeight

        onHomeClicked:      console.log("Home clicked")
        onClimateClicked:   dashboardRoot.climateRequested()
        onMediaClicked: {
        console.log("BottomNavBar mediaClicked!")
        dashboardRoot.mediaRequested()
        }
        onWeatherClicked:   dashboardRoot.weatherRequested()
        onSettingsClicked:  dashboardRoot.settingsRequested()
        onAssistantClicked: dashboardRoot.assistantRequested()

        onDriverTempUp:     console.log("Driver temp up")
        onDriverTempDown:   console.log("Driver temp down")
        onPassengerTempUp:  console.log("Passenger temp up")
        onPassengerTempDown: console.log("Passenger temp down")
        onVolumeUp:         console.log("Volume up")
        onVolumeDown:       console.log("Volume down")
    }
}