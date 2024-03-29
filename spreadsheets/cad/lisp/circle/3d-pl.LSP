;;; ��������� 3d-��������� �� ���� ������ � �� ���������
;;; drawing a 3d polyline by three points in their plane
;;; http://geodesist.ru/members/1958.30261/
;;; 14 July 2022
(defun c:3d-pl (/ p1 p2 p3 ent lst)
 (setq dym  (getvar "DYNMODE")
       clay (getvar "clayer")
       ccol (getvar "cecolor")
 )
 (setvar "DYNMODE" 1)
 (entmake (list '(0 . "LAYER")
                '(100 . "AcDbSymbolTableRecord")
                '(100 . "AcDbLayerTableRecord")
                '(70 . 0)
                (cons 62 4)
                (cons 2 "3D-polyline")
          )
 )
 (setvar "clayer" "3D-polyline")
 (command "_ucs" "_w")
 (setq p1 (getpoint "Circle point #1: "))
 (setq p2 (getpoint "Circle point #2: "))
 (setq p3 (getpoint "Circle point #3: "))
 (command "_ucs" "_3p" p1 p2 p3)
 (command "_circle" "_3p" (trans p1 0 1) (trans p2 0 1) (trans p3 0 1))
 (setq ent (entlast))
 (command "_ucs" "_p")
 (command "_.divide" ent 10); 10 - ����� ������ (number of vertices)
 (entdel ent)
 (setq ss_pt (ssget "_X" (list (cons 0 "POINT") (cons 8 "3D-polyline")))
       lst   nil
 )
 (repeat (setq i (sslength ss_pt))
  (setq pnt (cdr (assoc 10 (setq pt (entget (ssname ss_pt (setq i (1- i)))))))
        lst (cons pnt lst)
  )
 )
 (entmakex
  (list (cons 0 "POLYLINE") (cons 100 "AcDb3dPolyline") '(10 0 0 0) (cons 70 9))
 )
 (mapcar '(lambda (pt / tmp)
           (entmakex
            (list (cons 0 "VERTEX") (cons 100 "AcDb3dPolyline") (cons 10 pt) (cons 70 32))
           )
          )
         lst
 )
 (entmakex (list (cons 0 "SEQEND")))
 (vl-cmdf "_erase" ss_pt "")
 (setvar "DYNMODE" dym)
 (setvar "clayer" clay)
 (setvar "cecolor" ccol)
)
 ;|�Visual LISP� Format Options�
(100 1 2 2 nil " " 80 60 0 0 0 nil nil nil T)
;*** �� ���������� ����� ��� �������������! ***|;
