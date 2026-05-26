import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: 1024
    height: 600

    // Signal emitted when back button is pressed
    signal backClicked()

    // Main page background color
    readonly property color bgColor: "#07000E"
    // Main card/panel background color
    readonly property color panelColor: "#090613"
    // Lighter panel color for interactive elements
    readonly property color panelColorLight: "#1C162B"
    // Border and divider color
    readonly property color borderColor: "#342544"
    // Primary text color
    readonly property color textColor: "#CBC4CD"
    // Secondary/dim text color
    readonly property color textColorDim: "#8A8294"
    // Main accent/highlight color
    readonly property color accentViolet: "#8B5CF6"
    // Secondary accent/glow color
    readonly property color accentCyan: "#06B6D4"

    Rectangle {
        anchors.fill: parent
        color: root.bgColor
    }

    // Back Button
    Rectangle {
        id: backBtn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 20
        width: 44
        height: 44
        radius: 12
        // Change button color when pressed
        color: backTap.pressed ? Qt.lighter(root.panelColorLight, 1.3) : root.panelColorLight
        border.color: root.borderColor
        border.width: 1

        // Handle touch/click interaction   
        TapHandler {
            id: backTap
            onTapped: root.backClicked()
        }

        Text {
            anchors.centerIn: parent
            text: "‹"
            font.pixelSize: 24
            font.bold: true
            color: root.accentCyan
        }
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 28
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Weather"
        color: root.textColor
        font.pixelSize: 20
        font.bold: true
    }

    // Fetch weather on startup
    Component.onCompleted: {
        // Check if weatherApi exists and no city is loaded yet
        if (weatherApi && weatherApi.cityName === "") {
            // Request weather data for Giza
            weatherApi.fetchWeather("Giza")
        }
    }

    // Update forecast when ready
    Connections {
        target: weatherApi
        function onForecastReady() {
            forecastList.model = weatherApi.forecast
        }
    }

    // Main Content
    Flickable {
        anchors.top: backBtn.bottom
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        contentHeight: mainColumn.height
        clip: true

        ColumnLayout {
            id: mainColumn
            width: parent.width
            spacing: 8

            // Search Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                radius: 22
                color: root.panelColorLight
                border.color: root.borderColor
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 8
                    spacing: 8

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Enter city name..."
                        placeholderTextColor: root.textColorDim
                        color: root.textColor
                        font.pixelSize: 14
                        background: Rectangle { color: "transparent" }

                        Keys.onReturnPressed: {
                            if (text !== "" && weatherApi) {
                                weatherApi.fetchWeather(text)
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        radius: 18
                        color: searchTap.pressed ? Qt.darker(root.accentViolet) : root.accentViolet

                        Text {
                            anchors.centerIn: parent
                            text: "🔍"
                            font.pixelSize: 16
                        }

                        TapHandler {
                            id: searchTap
                            onTapped: {
                                if (searchField.text !== "" && weatherApi) {
                                    weatherApi.fetchWeather(searchField.text)
                                }
                            }
                        }
                    }
                }
            }

            // City Name
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: weatherApi ? (weatherApi.cityName || "Loading...") : "Loading..."
                font.pixelSize: 22
                font.bold: true
                color: root.textColor
            }

            // Temperature
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: weatherApi && weatherApi.temperature ? Math.round(weatherApi.temperature) + "°C" : "--°C"
                font.pixelSize: 48
                font.weight: Font.Light
                color: root.accentCyan
            }

            // Weather Description
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: weatherApi ? (weatherApi.weather || "") : ""
                font.pixelSize: 16
                color: root.textColorDim
                font.capitalization: Font.Capitalize
                visible: weatherApi && weatherApi.weather ? true : false
            }

            // Weather Details
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                radius: 16
                color: root.panelColor
                border.color: root.borderColor
                border.width: 1
                visible: weatherApi && weatherApi.cityName ? true : false

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "💧"
                            font.pixelSize: 22
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: weatherApi ? (weatherApi.humidity + "%") : "--%"
                            font.pixelSize: 16
                            font.bold: true
                            color: root.textColor
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Humidity"
                            font.pixelSize: 11
                            color: root.textColorDim
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 40
                        color: root.borderColor
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "💨"
                            font.pixelSize: 22
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: weatherApi && weatherApi.windSpeed ? weatherApi.windSpeed.toFixed(1) + " m/s" : "-- m/s"
                            font.pixelSize: 16
                            font.bold: true
                            color: root.textColor
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Wind"
                            font.pixelSize: 11
                            color: root.textColorDim
                        }
                    }
                }
            }

            // Forecast Section
            Text {
                text: "5-Day Forecast"
                font.pixelSize: 16
                font.bold: true
                color: root.textColor
                visible: forecastList.count > 0
            }

            // Forecast List
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                radius: 16
                color: root.panelColor
                border.color: root.borderColor
                border.width: 1
                visible: forecastList.count > 0
                clip: true

                ListView {
                    id: forecastList
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 6
                    clip: true
                    interactive: true
                    model: []

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        contentItem: Rectangle {
                            implicitWidth: 6
                            radius: 3
                            color: root.accentViolet
                        }
                        background: Rectangle {
                            implicitWidth: 6
                            color: "transparent"
                        }
                    }

                    delegate: Rectangle {
                        width: forecastList.width
                        height: 52
                        radius: 12
                        color: root.panelColorLight
                        border.color: root.borderColor
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12

                            Text {
                                Layout.preferredWidth: 36
                                text: modelData.dayName || ""
                                font.pixelSize: 13
                                font.bold: true
                                color: root.textColor
                            }

                            Image {
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 32
                                source: modelData.icon ? "https://openweathermap.org/img/wn/" + modelData.icon + "@2x.png" : ""
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.weather || ""
                                font.pixelSize: 12
                                color: root.textColorDim
                                font.capitalization: Font.Capitalize
                                elide: Text.ElideRight
                            }

                            Text {
                                text: modelData.temp ? Math.round(modelData.temp) + "°" : ""
                                font.pixelSize: 16
                                font.bold: true
                                color: root.accentViolet
                            }
                        }
                    }
                }
            }

            Item { height: 20 }
        }
    }
}