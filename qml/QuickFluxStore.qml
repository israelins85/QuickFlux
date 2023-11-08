import QtQuick

QtObject {
    property var actionsRegex: new RegExp("(*)")

    function handleAction(action, payload) {
        const match = action.match(actionsRegex)
        // @disable-check M126
        if (match == null) {
            return false
        }

        var functionNameParts = []
        for (var i = 1; ; ++i) {
            const m = match[i]
            // @disable-check M126
            if (m == null)
                break
            functionNameParts.push(m)
        }

        if (functionNameParts.length === 0)
            functionNameParts.push("handle")

        const functionName = functionNameParts.join("_")
        const func = this[functionName]

        // @disable-check M126
        if (func == null) {
            console.log("not implemented ", functionName)
            return false
        }

        func(payload)
        return true
    }

    Component.onCompleted: {
        QuickFluxDispatcher.subscribe(this)
    }
}
