(vl-load-com)
(defun c:dr2e (/ notdelete adoc)
;;;notdelete список неудаляемых словарей
(setq adoc      (vla-get-activedocument (vlax-get-acad-object))
notdelete  '("ACAD_IMAGE_DICT" "ACAD_COLOR" "ACAD_FIELDLIST" "ACAD_GROUP" "ACAD_IMAGE_VARS"
            "ACAD_LAYOUT" "ACAD_MATERIAL" "ACAD_MLEADERSTYLE" "ACAD_MLINESTYLE" "ACAD_PLOTSETTINGS"
            "ACAD_PLOTSTYLENAME" "ACAD_SCALELIST" "ACAD_TABLESTYLE" "ACAD_VISUALSTYLE" "ACAD_WIPEOUT_VARS"
            "ACAD_PDFDEFINITIONS" "ACAD_DWFDEFINITIONS" "ACAD_BACKGROUND" "ACAD_CIP_PREVIOUS_PRODUCT_INFO" "ACAD_COLOR" 
            "ACAD_DETAILVIEWSTYLE" "ACAD_SECTIONVIEWSTYLE" "AcAec" "AcDbVariableDictionary" "AcDsDecomposeData"
            "ADE_QUERY_LIBRARY" "AEC_CLASSIFICATION_SYSTEM_DEFS" "AEC_DISP_REP_CONFIGURATIONS" "AEC_DISP_REP_SETS"
            "AEC_DISP_REPS" "AEC_DISPLAY_PROPS_DEFAULTS" "AEC_PROPERTY_SET_DEFS" "AEC_VARS" "ASE_INDEX_DICTIONARY"
            "Autodesk_MAP"
            )
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
