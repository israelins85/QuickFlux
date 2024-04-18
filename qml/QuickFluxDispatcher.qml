pragma Singleton

import QtQuick

QtObject {
    property variant stores: ([])
    property var pending: ([])

    readonly property var t: Timer {
        id: timer
        repeat: true
        interval: 1
        onTriggered: {
            _exec()
        }
    }

    function subscribe(store) {
        unsubscribe(store)
        stores.push(store)
    }

    function unsubscribe(store) {
        stores = stores.filter(function (e) {
            return (e !== store)
        })
    }

    function _exec() {
        if (pending.length === 0) {
            timer.stop()
            return
        }

        const next = pending[0]
        pending = pending.slice(1)
        _dispatch(next.action, next.payload)
    }

    function _dispatch(action, payload) {
        var handled = false

        for (var i = 0; i < stores.length; ++i) {
            const store = stores[i]

            if (store.handleAction(action, payload)) {
                handled = true
            }
        }
    }

    function dispatch(action, payload) {
        pending.push({
                         "action": action,
                         "payload": payload
                     })
        timer.start()
    }
}
