import QtQml
import QtQuick

QtObject {
    id: root

    property var actionsRegex: new RegExp("(*)")
    default property list<QtObject> data

    function insert(index, item) {
        __data = __qmlListPropertyInsert(__data, index, item)
    }

    function remove(index) {
        var removeItem = __data[index]
        __qmlListPropertyRemove(__data, index)
        return removeItem
    }

    /*! \internal */
    function __qmlListPropertyInsert(qmllistproperty, index, item) {
        if (index > qmllistproperty.length)
            return qmllistproperty

        var qmllistproperty_ = []
        var length = qmllistproperty.length + 1
        var flag = false

        // insert ?
        for (var iter = 0; iter < length; iter++) {
            if (iter === index) {
                qmllistproperty_.push(item)
                flag = true
            } else {
                if (flag) {
                    qmllistproperty_.push(qmllistproperty[iter - 1])
                } else {
                    qmllistproperty_.push(qmllistproperty[iter])
                }
            }
        }

        return qmllistproperty_
    }

    /*! \internal */
    function __qmlListPropertyRemove(qmllistproperty, index) {
        if (index > qmllistproperty.length - 1)
            return qmllistproperty

        var qmllistproperty_ = []
        for (var iter in qmllistproperty) {
            if (iter === index) {
                continue
            } else {
                qmllistproperty_.push(qmllistproperty[iter])
            }
        }
        return qmllistproperty_
    }

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

    Component.onDestruction: {
        QuickFluxDispatcher.unsubscribe(this)
    }
}
