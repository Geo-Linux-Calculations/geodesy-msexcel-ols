(defun C:DR ( / notdelete)
 ;;;notdelete список неудаляемых словарей
 (setq notdelete '("ACAD_IMAGE_DICT" "ACAD_IMAGE_VARS"))
    (mapcar
        '(lambda(d)
        (vl-catch-all-apply '(lambda()(if (not(member d notdelete))(dictremove (namedobjdict) d)))))
        (mapcar 'cdr(vl-remove-if-not '(lambda(x)(= (car x) 3))(entget(namedobjdict))))
    )
)
