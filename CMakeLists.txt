cmake_minimum_required(VERSION 3.16)

project(GP_IVI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia QuickEffects Bluetooth DBus QuickControls2)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appGP_IVI
    main.cpp
)

target_include_directories(appGP_IVI PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src/audio
    ${CMAKE_CURRENT_SOURCE_DIR}/src/weather
    ${CMAKE_CURRENT_SOURCE_DIR}/src/climate 
)

qt_add_qml_module(appGP_IVI
    URI GP_IVI
    VERSION 1.0

    QML_FILES
        Main.qml
        pages/DashboardPage.qml
        pages/ProfilePage.qml
        pages/LightsPage.qml
        pages/SettingsPage.qml
        pages/MapPage.qml
        pages/AssistantPage.qml
        pages/MediaPage.qml
        components/TopStatusBar.qml
        components/SideMenu.qml
        components/VehicleOverviewCard.qml
        components/RightPanel.qml
        components/BottomNavBar.qml
        components/OnScreenKeyboard.qml
        components/BluetoothSheet.qml
        components/RadioView.qml
        components/UsbView.qml
        pages/WeatherPage.qml
        pages/ClimatePage.qml

    RESOURCES
        assets/images/iti_logo.png
        assets/images/tesla.png
        assets/images/iti.png
        assets/images/iti1.png
        assets/images/map.png
        assets/icons/car_home.svg
        assets/icons/ai_assistant.svg
        assets/icons/climate_fan.svg
        assets/icons/settings_gear.svg
        assets/icons/weather.png
        assets/icons/light.png
        assets/icons/audio.png
        assets/icons/Bluetooth.png
        assets/icons/mute.png
        assets/icons/next.png
        assets/icons/pause.png
        assets/icons/play.png
        assets/icons/prev.png
        assets/icons/radio.png
        assets/icons/stop.png
        assets/icons/unmute.png
        assets/icons/usb.png
        assets/icons/volume.png
        assets/icons/phone.png
        assets/icons/home.png
        assets/images/car_climate.png            
        assets/images/metallicBlue.png           
        assets/images/Pastedimage1111.png         
        assets/images/Pastedimage2222.png         
        assets/images/Pastedimage_2.png          
        assets/images/Pastedimage_3.png
        assets/icons/vent.png                    
        assets/icons/vent_blow.png               
        assets/icons/windscreen-air.png 

    SOURCES
        src/audio/audioplayer.h
        src/audio/audioplayer.cpp
        src/audio/audiosourcebase.h
        src/audio/audiosourcebase.cpp
        src/audio/radioplayer.h
        src/audio/radioplayer.cpp
        src/audio/usbplayer.h
        src/audio/usbplayer.cpp
        src/audio/btplayer.h
        src/audio/btplayer.cpp
        src/audio/bluetoothmanager.h
        src/audio/bluetoothmanager.cpp
        src/weather/WeatherAPI.h         
        src/weather/WeatherAPI.cpp
        src/climate/hvaccontroller.h             
        src/climate/hvaccontroller.cpp
)

set_target_properties(appGP_IVI PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGP_IVI PRIVATE
    Qt6::Quick
    Qt6::Multimedia
    Qt6::QuickEffects
    Qt6::Bluetooth
    Qt6::DBus
    Qt6::Network
     Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appGP_IVI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)