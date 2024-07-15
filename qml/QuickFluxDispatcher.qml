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

        if (next.scheduled) {
            const now = new Date()
            const delta = next.scheduled.getTime() - now.getTime()
            if (delta > 0) {
                if (pending.length === 0) {
                    timer.interval = delta + 1
                }

                pending.push(next)
                return
            }
        }

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

    function addMilliseconds(date, milliseconds) {
        date.setMilliseconds(date.getMilliseconds() + milliseconds)
        return date
    }

    function dispatch(action, payload, timeout = 0) {
        if (timeout >= 0) {
            let scheduled = null
            if (timeout > 0)
                scheduled = addMilliseconds(new Date(), timeout)

            pending.push({
                             "action": action,
                             "payload": payload,
                             "scheduled": scheduled
                         })

            if (!timer.running) {
                timer.interval = timeout + 1
                timer.start()
            } else {
                timer.interval = Math.min(timer.interval, timeout) + 1
            }
        } else {
            _dispatch(action, payload)
        }
    }
}
