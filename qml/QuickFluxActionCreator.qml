import QtQuick

QtObject {
    function dispatch(topic, payload) {
        QuickFluxDispatcher.dispatch(topic, payload)
    }
}
