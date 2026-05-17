#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext> 
#include "audioplayer.h" 

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    AudioPlayer audioPlayer;
    engine.rootContext()->setContextProperty("audioManager", &audioPlayer);


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("GP_IVI", "Main");

    return app.exec();
}
