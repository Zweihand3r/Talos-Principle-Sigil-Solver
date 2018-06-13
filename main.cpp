#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "helpers.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Helpers>();
    Helpers *helpers = new Helpers();
    engine.rootContext()->setContextProperty("helpers", helpers);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
