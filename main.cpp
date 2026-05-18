#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext> 
#include "src/audio/audioplayer.h"
#include "src/weather/WeatherAPI.h"
#include "src/climate/hvaccontroller.h" 

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    AudioPlayer audioPlayer;
    engine.rootContext()->setContextProperty("audioManager", &audioPlayer);

    WeatherAPI weatherApi;
    engine.rootContext()->setContextProperty("weatherApi", &weatherApi);

    HvacController hvacBackend;
    engine.rootContext()->setContextProperty("HvacBackend", &hvacBackend);


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("GP_IVI", "Main");

    return app.exec();
}
