;;;------------------------------->DDCLEAR-DUPS<-----------------------------------;;;
;;;                          Removing duplicate objects                            ;;;
;;;                           CLDUPS.lsp Version 1.00                              ;;;
;;; The file contains the following commands:                                      ;;;
;;; CLEAR-DUPS: Removing duplicate drawing objects. Command line interface.        ;;;
;;; Built on the original Andrzej Gumula code                                      ;;;
;;;--------------------------------------------------------------------------------;;;

;;;Clear duplicates      (c)2001, Andrzej Gumula

;;;Changed: Protasov G.N.
;;;Date of change: 10.12.2007
;;;G-TOOLS! 

;;Main function
(DEFUN CLEAR-DUPS-MAIN (/  lista new one elem temp old znacznik dxfl
   DXF COMPLEX CHECK CORRECT)
   (DEFUN DXF (a) (CDR (ASSOC a (ENTGET one))));DEFUN

   (DEFUN COMPLEX ()
      (WHILE (NOT (WCMATCH (DXF 0) "*END*"))
         (SETQ one (ENTNEXT one)
            elem (APPEND elem (LIST one)))
         (CHECK)
         );WHILE
      );DEFUN

   (DEFUN CHECK (/ x)
      (FOREACH x (ENTGET one)
         (IF (NOT (MEMBER (CAR x) dxfl))
            (SETQ temp (CONS (CORRECT X) temp))
            );IF
         );FOREACH
      );DEFUN

   (DEFUN CORRECT  (a)
      (COND ((= (TYPE (CDR a)) 'list)
            (CONS (CAR a) (MAPCAR '(LAMBDA (x) (ATOF (RTOS x 2 8))) (CDR a)))
            )
         ((MEMBER (TYPE (CDR a)) (LIST 'INT 'REAL))
            (CONS (CAR a) (MAPCAR '(LAMBDA (x) (ATOF (RTOS x 2 8))) (LIST (CDR a)))))
         (t a)
         );COND
      );DEFUN

   (SETQ lista nil
      new nil
      one nil
      temp nil
      dxfl '(-2 -1 5 100)
      old (SSGET "_X")
      );SETQ
   (IF *clrdlayflag (SETQ dxfl (APPEND dxfl '(8))))
   (IF *clrdcolflag (SETQ dxfl (APPEND dxfl '(62))))
   (IF *clrdltflag (SETQ dxfl (APPEND dxfl '(6))))
   (COND
      (old
         (COMMAND "_.-layer" "_u" "*" "")
         (PRINC "\nClean up the drawing. ")
         (PRINC "\nPlease wait... \n")
         (WHILE 
            (COND (one (SETQ one (ENTNEXT one)))
               (t (SETQ one (ENTNEXT)))
               );COND
            (SETQ elem (APPEND elem (LIST one)))
            (CHECK)
            (IF (OR (AND (= (DXF 0) "INSERT") (= (DXF 66) '1)) (= (DXF 0) "POLYLINE"))
               (COMPLEX));IF
            (IF (MEMBER temp lista)
               (FOREACH x elem (ENTDEL x)));IF
            (SETQ lista (CONS temp lista)
               temp  nil
               elem  nil);SETQ
            (COND 
               (znacznik (SETQ znacznik nil) (PRINC "\r\\"))
               (t (SETQ znacznik (PRINC "\r/")))
               );COND
            );WHILE
         (PRINC (STRCAT "\nNumber of elements before cleaning - " (ITOA (SSLENGTH old))))
         (PRINC
            (STRCAT "\nNumber of elements after cleaning - " (ITOA (SSLENGTH (SSGET "_X")))))
         );COND 1
      (t (PRINC "\nFound empty items. "))
      );COND
   );DEFUN

;;Duplicate removal function. Command line interface
;;Global variables:
;;*clrdlayflag *clrdcolflag *clrdltflag
(DEFUN CLEAR-DUPS (/ ans cmdecho-save error-save)
   (SETQ cmdecho-save (GETVAR "CMDECHO"))
   (SETVAR "CMDECHO" 0)
   (COMMAND "_.undo" "_begin")
   (DEFUN *error* (msg)
      (IF  error-save (SETQ *error* error-save))
      (IF msg (PRINC "\nFunction execution interrupted "))
      (SETVAR "CMDECHO" cmdecho-save)
      (PRINC)
      );DEFUN
   (INITGET "Yes No")
   (SETQ ans (GETKWORD "\nDelete objects on different layers? (Yes/Nо) <N>: ")
      *clrdlayflag (= ans "Yes"));SETQ
   (INITGET "Yes No")
   (SETQ ans (GETKWORD "\nDelete objects with different colors? (Yes/Nо) <N>: ")
      *clrdcolflag (= ans "Yes"));SETQ
   (INITGET "Yes No")
   (SETQ ans (GETKWORD "\nDelete objects with different linetypes? (Yes/Nо) <N>: ")
      *clrdltflag (= ans "Yes"));SETQ
   (CLEAR-DUPS-MAIN)
   (COMMAND "_.undo" "_end")
   (SETQ *error* error-save)
   (SETVAR "cmdecho" cmdecho-save)
   (PRINC)
   );DEFUN

(IF (OR (NULL C:CLEAR-DUPS)
      (NOT (LISTP C:CLEAR-DUPS))
      );OR
   (DEFUN C:CLEAR-DUPS ()
      (CLEAR-DUPS)
      );DEFUN
   );IF
(PRINC "\nClDups.lsp loaded ... ")
(PRINC "\nAdded command CLEAR-DUPS...")
(PRINC)
