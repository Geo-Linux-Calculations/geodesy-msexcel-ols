;;; Point with manual elevation input
(defun c:pointh (/ pt1 h2)
    (setq pt1 (getpoint "\nSelect point: "))
    (setq h2 (getdist "\nElevation: "))
    (command 
      "_POINT" 
      (list
        (car pt1)
        (cadr pt1)
        h2 ; (caddr pt1)
      )
    )
    (princ)
)
