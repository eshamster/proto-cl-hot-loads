let ws_socket = new WebSocket('ws://' + window.location.host + '/ws')

ws_socket.onmessage = function (e) {
    // TODO: Decode unicode
    document.getElementById("js-code").value = e.data;
    eval(e.data);
}

function send_ps_code() {
    ws_socket.send(document.getElementById("ps-code").value);
}
