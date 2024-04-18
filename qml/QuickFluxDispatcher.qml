pragma Singleton

import QtQuick

QtObject {
    property variant stores: ([])

    function subscribe(store) {
        unsubscribe(store)
        stores.push(store)
    }

    function unsubscribe(store) {
        stores = stores.filter(function (e) {
            return (e !== store)
        })
    }

    function dispatch(action, payload) {
        var handled = false


        for (var i = 0; i < stores.length; ++i) {
            const store = stores[i]

            if (store.handleAction(action, payload)) {
                handled = true
            }
        }

    }
}
