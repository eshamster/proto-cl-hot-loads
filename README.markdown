# Proto-Cl-Hot-Loads - A prototype of hot loads in Common Lisp using WebSocket

Proto-Cl-Hot-Loads is a prototype of hot loads in Common Lisp. It is ispired by [Figwheel](https://github.com/bhauman/lein-figwheel) of ClojureScript.

It tries the following simple idea.

When evaluating Common Lisp subset code for client,

1. Compile it to JavaScript using [Parenscript](https://common-lisp.net/project/parenscript/),
2. Send the JS code to browser via WebSocket, and
3. Evaluate it on browser by `eval()`

## Demo

The left of the screen is browser and the right is editor (Emacs + SLIME).
When evaluating Parenscript code in the editor, the result is immediately reflected to the browser without reloading.

![Demo of hot loads](https://raw.githubusercontent.com/wiki/eshamster/proto-cl-hot-loads/images/hot_loads_demo.gif)

## Installation and Usage

Please clone this to where quicklisp (asdf) can find. Then, load it by `ql:quickload` and start server. After that, you can access to http://localhost:5000 .

```lisp
CL-USER> (ql:quickload :proto-cl-hot-loads)
CL-USER> (proto-cl-hot-loads:start :port 5000)
```

After accessing, you can try hot loads using `defvar.hl`, `defun.hl`, `defonce.hl`, and `with-hot-loads` in `src/playground.lisp` (or use the package `proto-cl-hot-loads.defines`).

(Because this project is only a prototype, the interface is not so considered...)

- `defvar.hl`

The `defvar.hl` is similar to `defvar`. For example, when evaluating the following (if you use [Slime](https://github.com/slime/slime), press `C-c C-c` on the definition), `var x = 100;` is evaluated on browser.

```lisp
(defvar.hl x 100)
```

- `defun.hl`

The `defun.hl` is similar to `defun`. For example, when evaluating the following, `function hello(x) { alert("Hello " + x); };` is defined on browser.

```lisp
(defun.hl hello (x)
  (alert (+ "Hello " x)))
```

- `defonce.hl`

The `defonce.hl` is similar to `defonce` of Figwheel (Please refer ["Writing reloadable code" in Figwheel's README](https://github.com/bhauman/lein-figwheel#writing-reloadable-code) for detail). For example, when evaluating the following, "var y = 200;" is evaluated on browser at the first time. But when re-evaluating as, for example, `(defonce.hl y 300)`, `y` is not updated.

```lisp
(defonce.hl y 200)
```

- `with-hot-loads`

The `with-hot-loads` is a basic macro of `defxxx.hl` macros. For example, when evaluating the following, an alert dialog with "Hello 300" is displayed on browser.

```lisp
(with-hot-loads (:label some-label)
  (hello (+ x y)))
```

Finally, the defined symbols (labels) by `with-hot-loads` are output as JavaScript code to `src/_js/main.js` when accessed from browser. 

For example, the following are defined in `src/playground.lisp` in default.

```lisp
(defvar.hl x 888)

(defonce.hl once 100)

(defun.hl my-log (text)
  ((ps:@ console log) text))

(with-hot-loads (:label sample)
  (my-log (+ x ": Hello Hot Loading!!")))
```

So when you access to the server, `src/_js/main.js` is generated as the following and sended to browser.

```javascript
var x = 888;
if (typeof x !== 'undefined') {
    var once = 100;
};
function myLog(text) {
    return console.log(text);
};
myLog(x + ': Hello Hot Loading!!');
```

## Author

* eshamster (hamgoostar@gmail.com)

## Copyright

Copyright (c) 2018 eshamster (hamgoostar@gmail.com)

## License

Licensed under the MIT License.
