function permuteString(str) {
    var arr = str.split("")
    var res = permute_xN(arr)

    res.forEach(function(item) {
        console.log(item)
    })
}

function permute_x2(arr) {
    var res = []
    res.push([arr[0], arr[1]])
    if (arr[0] !== arr[1])
        res.push([arr[1], arr[0]])

    return res
}

function permute_x3(arr) {
    var res = []
    var tallyMap = {}

    for (var index = 0; index < 3; index++) {
        var arr_ = arr.slice()
        if (index > 0) arr_.move(index, 0)

        if (!tallyMap[arr_[0]]) tallyMap[arr_[0]] = 1
        else continue

        var str_x2 = arr_.slice(1, arr_.length)
        var res_x2 = permute_x2(str_x2)

        res_x2.forEach(function(element){
            res.push([arr_[0], element[0], element[1]])
        })
    }

    return res
}

function permute_x4(arr) {
    var res = []
    var tallyMap = {}

    for (var index = 0; index < 4; index++) {
        var arr_ = arr.slice()
        if (index > 0) arr_.move(index, 0)

        if (!tallyMap[arr_[0]]) tallyMap[arr_[0]] = 1
        else continue

        var str_x3 = arr_.slice(1, arr_.length)
        var res_x3 = permute_x3(str_x3)

        res_x3.forEach(function(element){
            res.push([arr_[0], element[0], element[1], element[2]])
        })
    }

    for (var key in tallyMap) {
        console.log(key + ": " + tallyMap[key])
    }

    return res
}

function permute_xN(arr) {
    var res = []
    var tallyMap = {}

    if (arr.length <= 2) {
        return permute_x2(arr)
    }

    for (var index = 0; index < arr.length; index++) {
        var arr_ = arr.slice()
        if (index > 0) arr_.move(index, 0)

        if (!tallyMap[arr_[0]]) tallyMap[arr_[0]] = 1
        else continue

        var str_x = arr_.slice(1, arr_.length)
        var res_x = permute_xN(str_x)

        res_x.forEach(function(element){
            var res_ = [arr_[0]]
            for (var x = 1; x < arr.length; x++)
                res_.push(element[x - 1])
            res.push(res_)
        })
    }

    return res
}

function permute_reduce(str) {
    var res = permute_Legacy(str)
    var finalRes = []
    var tallyMap = {}

    for (var index = 0; index < res.length; index++) {
        var item = res[index]
        var str_ = item.join("")
        if (!tallyMap[str_]) {
            tallyMap[str_] = 1
        }
    }

    for (var key in tallyMap) {
        finalRes.push(key.split(""))
    }

    return finalRes
}

/*----------------------------------------------*/
/*------------------| Legacy |------------------*/
/*----------------------------------------------*/

function permute_Legacy(string_) {
    var str = string_.split("")
    var result = permute_Legacy(str)

    result.forEach(function(element) { console.log(element) })
    console.log("Tolal: " + result.length + " entries")
}

function permute_x2Legacy(string_) {
    var res = []
    res.push([string_[0], string_[1]])
    res.push([string_[1], string_[0]])
    return res
}

function permute_Legacy(string_) {
    var res = []

    if (string_.length <= 2) {
        return permute_x2Legacy(string_)
    }

    for (var index = 0; index < string_.length; index++) {
        var arr = string_.slice()

        if (index > 0) arr.move(index, 0)
        var str_x = arr.slice(1, arr.length)
        var res_x = permute_Legacy(str_x)

        res_x.forEach(function(element){
            var res_ = [arr[0]]
            for (var x = 1; x < string_.length; x++)
                res_.push(element[x - 1])
            res.push(res_)
        })
    }

    return res
}

Array.prototype.move = function(from, to) {
    this.splice(to, 0, this.splice(from, 1)[0])
}
