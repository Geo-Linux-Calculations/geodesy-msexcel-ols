; Text of Z for points

(defun c:otm ( / H SSET lay osm npoint n ent pxy pz)
 (if(and
   (setq sset (ssget '((0 . "POINT"))))
   (setq h (getreal "\tText height?\t\t")))
  (mapcar(function(lambda (x)
    (entmake(list '(0 . "text")
     (assoc 10 (entget x))(cons 40 h)
     (cons 1 (rtos (cadddr (assoc 10 (entget x))) 2 3))
    ))
   ))
   (vl-remove-if (function listp)
    (mapcar (function cadr) (ssnamex sset))
   )
  )
 )
 (princ)
)
