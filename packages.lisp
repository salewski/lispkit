(defpackage lispkit
  (:use :gtk :gdk :gdk-pixbuf :gobject :cl-xkeysym
        :cl-webkit2 :glib :gio :pango :cairo :common-lisp
        :split-sequence :alexandria)
  (:export #:do-main
           #:main
           #:defjump
           #:lookup-jump
           #:make-browser
           #:make-webview
           #:make-ui-builder
           #:define-key
           #:make-keymap
           #:keymaps
           #:handle-key
           #:defcommand))

;; fix parenscript missing DOM methods in #:ps-dhtml-symbols
;; See https://github.com/vsedach/Parenscript/issues/14
(defpackage #:lispkit.dhtml-missing-methods
  (:documentation "Missing functions used in lispkit source code.")
  (:export
   #:-string
   #:from-char-code
   #:-math
   #:pow
   #:to-upper-case
   #:to-lower-case
   #:style
   #:position
   #:top
   #:left
   #:add-event-listener
   #:key-code
   #:query-selector-all
   #:inner-width
   #:inner-height
   #:get-bounding-client-rect
   #:text-content))

(ps::re-export-symbols '#:lispkit.dhtml-missing-methods '#:ps-dhtml-symbols)

(defpackage lispkit.link-hints
  (:use :parenscript :ps-dhtml-symbols)
  (:shadowing-import-from :common-lisp :length)
  (:shadowing-import-from :ps-dom1-symbols :label :size))
(setf (ps:ps-package-prefix :lispkit.link-hints) "_lispkit_link_hints_")
