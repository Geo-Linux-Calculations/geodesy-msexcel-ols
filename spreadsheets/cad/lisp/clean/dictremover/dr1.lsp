(defun c:dr1 (/ notdelete)
;;;notdelete список неудаляемых словарей
  (setq notdelete '("ACAD_IMAGE_DICT" "ACAD_IMAGE_VARS"))
  (vl-cmdf "_.undo" "_begin")
  (mapcar
    '(lambda (d)
       (vl-catch-all-apply '(lambda ()
                              (if (not (member d notdelete))
                                (dictremove (namedobjdict) d)
                                ) ;_ end of if
                              ) ;_ end of lambda
                           ) ;_ end of vl-catch-all-apply
       ) ;_ end of lambda
    (mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 3)) (entget (namedobjdict))))
    ) ;_ end of mapcar
  (repeat 3 (vl-cmdf "_.-purge" "_a" "*" "_n"))
  (vl-cmdf "_.audit" "_y")
  (vl-cmdf "_.undo" "_end")
  (princ)
  ) ;_ end of defun
