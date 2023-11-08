pragma Singleton

import QtQuick

QtObject {
    property variant stores: ([])

    function subscribe(store) {
        stores.push(store)
    }

    function dispatch(action, payload) {
        var handled = false

        console.log("dispatching", action, JSON.stringify(payload))

        for (var i = 0; i < stores.length; ++i) {
            const store = stores[i]

            if (store.handleAction(action, payload)) {
                console.log(" - handled by", store)
                handled = true
            }
        }

        if (!handled)
            console.log(" - not dispatched")
    }
}
