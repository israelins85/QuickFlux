QT += qml quick

INCLUDEPATH += \
    $PWD/cpp/

QML_IMPORT_PATH += \
    $$PWD/qml/

RESOURCES += \
    $$PWD/qml/quickflux.qrc

HEADERS += \
    $$PWD/cpp/QuickFlux \
    $$PWD/cpp/quickflux.hpp

SOURCES += \
    $$PWD/cpp/quickflux.cpp

