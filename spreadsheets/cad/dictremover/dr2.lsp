(vl-load-com)
(defun c:dr2 (/ notdelete adoc)
;;;notdelete список неудаляемых словарей
  (setq adoc      (vla-get-activedocument (vlax-get-acad-object))
        notdelete '("ACAD_IMAGE_DICT" "ACAD_IMAGE_VARS")
        ) ;_ end of setq
  (vla-startundomark adoc)
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
  (repeat 3 (vla-purgeall adoc))
  (vla-auditinfo adoc :vlax-true)
  (vla-endundomark adoc)
  (princ)
  ) ;_ end of defun
