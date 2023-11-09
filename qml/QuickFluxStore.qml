import QtQuick

QtObject {
    property var actionsRegex: new RegExp("(*)")

    function handleAction(action, payload) {
        console.log("actionsRegex", actionsRegex)
        const match = action.match(actionsRegex)
        // @disable-check M126
        if (match == null) {
            console.log("not match")
            return false
        }

        console.log("match", JSON.stringify(match))

        var functionNameParts = []
        for (var i = 1; ; ++i) {
            const m = match[i]
            console.log("m", m)
            // @disable-check M126
            if (m == null)
                break
            functionNameParts.push(m)
        }

        console.log("functionNameParts", JSON.stringify(functionNameParts))

        if (functionNameParts.length === 0)
            functionNameParts.push("handle")

        const functionName = functionNameParts.join("_")
        console.log("functionName", JSON.stringify(functionName))
        const func = this[functionName]

        if (typeof func !== "function") {
            console.log("not implemented ", functionName)
            return false
        }

        console.log("calling")
        func(payload)
        console.log("called")
        return true
    }

    Component.onCompleted: {
        QuickFluxDispatcher.subscribe(this)
    }
}
