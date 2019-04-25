if ('undefined' === typeof x) {
    var x = 888;
};
if (typeof x !== 'undefined') {
    if ('undefined' === typeof once) {
        var once = 100;
    };
};
function myLog(text) {
    __PS_MV_REG = [];
    return console.log(text);
};
myLog(x + ': Hello Hot Loading!!');
