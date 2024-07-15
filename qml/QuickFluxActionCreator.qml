import QtQuick

QtObject {
    function dispatch(topic, payload, timeout = 0) {
        QuickFluxDispatcher.dispatch(topic, payload, timeout)
    }
}
