#include "quickflux.hpp"

#include <QQmlApplicationEngine>
#include <QUrl>

void qmlRegisterQuickFluxTypes() {
    qmlRegisterType(QUrl("qrc:///QuickFluxStore.qml"), "QuickFlux", 1, 0, "QuickFluxStore");
    qmlRegisterType(QUrl("qrc:///QuickFluxActionCreator.qml"), "QuickFlux", 1, 0, "QuickFluxActionCreator");
    qmlRegisterSingletonType(QUrl("qrc:///QuickFluxDispatcher.qml"), "QuickFlux", 1, 0, "QuickFluxDispatcher");
}
