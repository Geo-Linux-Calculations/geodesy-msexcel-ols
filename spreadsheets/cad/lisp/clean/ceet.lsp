; Clean/Erase empty text

(defun c:cet (/ ss count i delete_count)
  (setq ss (ssget "x" '((0 . "TEXT,MTEXT"))))
  (setq i 0)
  (setq delete_count 0)
  (if (and ss (setq count (sslength ss)))
    (mapcar
      '(lambda (ent)
      (progn
        (if
          (and
            (= (vl-string-trim " " (cdr (assoc 1 (entget ent)))) "")
            (entdel ent)
          ) ;_ and
            (setq delete_count (1+ delete_count))
        ) ;_ if
        (setq i (1+ i))
        (setvar
          "modemacro"
          (strcat "Performed " (itoa (fix (/ (* i 100) count))) "%")
        ) ;_ setvar
      )) ;_ lambda
      (mapcar 'cadr (ssnamex ss))
    ) ;_ mapcar
  ) ;_ if
  (setvar "modemacro" "")
  (princ
    (strcat " Removed empty texts " (itoa delete_count))
  ) ;_ princ
  (princ)
) ;_ defun

(defun c:eet ()
  (vl-cmdf "_.erase"
    (cond ((ssget "_X"
      '((0 . "TEXT,MTEXT") (-4 . "<NOT") (1 . "*[~\040]*") (-4 . "NOT>"))))
        (t "_non")
    )
    ""
  )
  (princ)
)
