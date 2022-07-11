;; triangulate.lsp
;; Delaunay triangulation
(defun eea-delone-triangulate (i1  L   /   A   A1  A2  A3
                               I   I2  L1  L2  L3  LP  MA
                               MI  P   S   TI  TR  X1  X2
                               Y1  Y2
                              )
 ;;*********************************************************
 ;;
 ;; Written by  ElpanovEvgeniy
 ;; 17.10.2008
 ;; Program triangulate an irregular set of 3d points.     
 ;;
 ;;*********************************************************
 (if l
  (progn
   (setq ti (car (_VL-TIMES))
         i  1
         i1 (/ i1 100.)
         i2 0
         l  (vl-sort
             (mapcar
              (function (lambda (p)
                         (list (/ (fix (* (car p) 1000)) 1000.)
                               (/ (fix (* (cadr p) 1000)) 1000.)
                               (caddr p)
                         ) ;_  list
                        ) ;_  lambda
              ) ;_  function
              l
             ) ;_  mapcar
             (function (lambda (a b) (>= (car a) (car b))))
            ) ;_  vl-sort
         x2 (caar l)
         y1 (cadar l)
         y2 y1
   ) ;_  setq
   (while l
    (setq a  (fix (caar l))
          a1 (list (car l))
          l  (cdr l)
    ) ;_  setq
    (while (and l (= (fix (caar l)) a))
     (setq a2 (car l))
     (if (<= (cadr a2) y1)
      (setq y1 (cadr a2))
      (if (> (cadr a2) y2)
       (setq y2 (cadr a2))
      ) ;_  if
     ) ;_  if
     (setq a1 (cons (car l) (vl-remove a2 a1))
           l  (cdr l)
     ) ;_  setq
    ) ;_  while
    (foreach a a1 (setq lp (cons a lp)))
   ) ;_  while
   (setq x1 (caar lp)
         a  (list (/ (+ x1 x2) 2) (/ (+ y1 y2) 2))
         a1 (distance a (list x1 y1))
         ma (+ (car a) a1 a1)
         mi (- (car a) a1)
         s  (list (list ma (cadr a) 0)
                  (list mi (+ (cadr a) a1 a1) 0)
                  (list (- (car a) a1) (- (cadr a) a1 a1) 0)
            ) ;_  list
         l  (list (cons x2 (cons a (cons (+ a1 a1) s))))
         ma (1- ma)
         mi (1+ mi)
   ) ;_  setq
   (while lp
    (setq p  (car lp)
          lp (cdr lp)
          l1 nil
    ) ;_  setq
    (while l
     (setq tr (car l)
           l  (cdr l)
     ) ;_  setq
     (cond
      ((< (car tr) (car p)) (setq l2 (cons (cdddr tr) l2)))
      ((< (distance p (cadr tr)) (caddr tr))
       (setq tr (cdddr tr)
             a1 (car tr)
             a2 (cadr tr)
             a3 (caddr tr)
             l1 (cons (list (+ (car a1) (car a2))
                            (+ (cadr a1) (cadr a2))
                            a1
                            a2
                      ) ;_  list
                      (cons (list (+ (car a2) (car a3))
                                  (+ (cadr a2) (cadr a3))
                                  a2
                                  a3
                            ) ;_  list
                            (cons (list (+ (car a3) (car a1))
                                        (+ (cadr a3) (cadr a1))
                                        a3
                                        a1
                                  ) ;_  list
                                  l1
                            ) ;_  cons
                      ) ;_  cons
                ) ;_  cons
       ) ;_  setq
      )
      (t (setq l3 (cons tr l3)))
     ) ;_  cond
    ) ;_  while
    (setq l  l3
          l3 nil
          l1 (vl-sort l1
                      (function (lambda (a b)
                                 (if (= (car a) (car b))
                                  (<= (cadr a) (cadr b))
                                  (< (car a) (car b))
                                 ) ;_  if
                                ) ;_  lambda
                      ) ;_  function
             ) ;_  vl-sort
    ) ;_  setq
    (while l1
     (if (and (= (caar l1) (caadr l1))
              (= (cadar l1) (cadadr l1))
         ) ;_  and
      (setq l1 (cddr l1))
      (setq l  (cons (eea-data-triangle p (cddar l1)) l)
            l1 (cdr l1)
      ) ;_  setq
     ) ;_  if
    ) ;_  while
    (if (and (< (setq i (1- i)) 1) (< i2 100))
     (progn
      (setvar
       "MODEMACRO"
       (strcat
        "     "
        (itoa (setq i2 (1+ i2)))
        " %    "
        (substr (strcat "||||||||||||||||||||||||||||||||||||||||||||||||||"
                        "||||||||||||||||||||||||||||||||||||||||||||||||||"
                ) ;_  strcat
                1
                i2
        ) ;_  substr
        (substr
         "..."
         1
         (- 100 i2)
        ) ;_  substr
       ) ;_  strcat
      ) ;_  setvar
      (setq i i1)
     ) ;_  progn
    ) ;_  if
   ) ;_  while
   (foreach a l (setq l2 (cons (cdddr a) l2)))
   (setq
    l2 (vl-remove-if-not
        (function
         (lambda (a)
          (and (< mi (caadr a) ma) (< mi (caaddr a) ma))
         ) ;_  lambda
        ) ;_  function
        l2
       ) ;_  vl-remove-if
   ) ;_  setq
   (foreach a l2
    (entmake (list (cons 0 "3DFACE")
                   (cons 10 (car a))
                   (cons 11 (car a))
                   (cons 12 (cadr a))
                   (cons 13 (caddr a))
             ) ;_  list
    ) ;_  entmake
   ) ;_  foreach
  ) ;_  progn
 ) ;_  if
 (setvar "MODEMACRO" "")
 (princ (strcat "\n "
                (rtos (/ (- (car (_VL-TIMES)) ti) 1000.) 2 4)
                " secs."
        ) ;_  strcat
 ) ;_  princ
 (princ)
) ;_  defun
(defun eea-data-triangle (P1 l / A A1 P2 P3 P4 S)
 ;;*********************************************************
 ;;
 ;; Written by  ElpanovEvgeniy
 ;; 17.10.2008
 ;; Calculation of the centre of a circle and circle radius 
 ;; for program triangulate
 ;;
 ;; (eea-data-triangle (getpoint)(list(getpoint)(getpoint)))
 ;;*********************************************************
 (setq p2 (car l)
       p3 (cadr l)
       p4 (list (car p3) (cadr p3))
 ) ;_  setq
 (if
  (not
   (zerop
    (setq s (sin (setq a (- (angle p2 p4) (angle p2 p1)))))
   ) ;_  zerop
  ) ;_  not
  (progn (setq a  (polar p4
                         (+ -1.570796326794896 (angle p4 p1) a)
                         (setq a1 (/ (distance p1 p4) s 2.))
                  ) ;_  polar
               a1 (abs a1)
         ) ;_  setq
         (list (+ (car a) a1) a a1 p1 p2 p3)
  ) ;_  progn
 ) ;_  if
) ;_  defun
;; Command "triangulate"
(defun c:triangulate (/ I L S)
 (princ (strcat "\n select points"))
 (if (setq i 0
           s (ssget '((0 . "POINT")))
     ) ;_  setq
  (progn (repeat (sslength s)
          (setq l (cons (cdr (assoc 10 (entget (ssname s i)))) l)
                i (1+ i)
          ) ;_  setq
         ) ;_  repeat
         (eea-delone-triangulate i l)
  ) ;_  progn
 ) ;_  if
) ;_  defun

;|«Visual LISP© Format Options»
(80 1 2 2 T " " 80 60 0 0 0 nil nil nil T)
;*** DO NOT add text below the comment! ***|;
; Interpolate evelation for line

