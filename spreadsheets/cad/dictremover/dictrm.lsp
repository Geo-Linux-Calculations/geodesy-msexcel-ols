(vl-load-com)
(defun c:dictrm (/ adoc)
  (vla-startundomark
    (setq adoc (vla-get-activedocument (vlax-get-acad-object)))
    ) ;_ end of vla-startundomark
  (mapcar
    '(lambda (d)
       (vl-catch-all-apply
         '(lambda ()
            (if (and (not (wcmatch (strcase d) "ACAD_*"))
                     (not (wcmatch d "AcDb*"))
                     ) ;_ end of and
              (dictremove (namedobjdict) d)
              ) ;_ end of if
            ) ;_ end of lambda
         ) ;_ end of vl-catch-all-apply
       ) ;_ end of lambda
    (mapcar 'cdr
            (vl-remove-if-not
              '(lambda (x) (= (car x) 3))
              (entget (namedobjdict))
              ) ;_ end of vl-remove-if-not
            ) ;_ end of mapcar
    ) ;_ end of mapcar
  (repeat 3 (vla-purgeall adoc))
  (vla-auditinfo adoc :vlax-true)
  (vla-endundomark adoc)
  (princ)
  ) ;_ end of defun
