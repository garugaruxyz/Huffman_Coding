;;; -*- Mode: Lisp -*-

;;; huffman-codes.lisp


;;; he-decode (bits huffman-tree) -> message

(defun he-decode (bits huffman-tree)
  (cond
   ((OR (null bits)  (null huffman-tree))
    (error "Decodifica impossibile"))
   (T (decodifica bits huffman-tree huffman-tree))))

(defun decodifica (bits node hu-tree)
  (cond
   ((not (listp node))
    (error "Decodifica impossibile"))
   ((AND (numberp (rest node)) (not (null bits)))
    (cons (first node) (decodifica bits hu-tree hu-tree)))
   ((numberp (rest node))
    (cons (first node) nil))
   ((null bits)
    (error "Decodifica impossibile"))
   ((= 1 (first bits))
    (decodifica (rest bits) (rest (rest node)) hu-tree))
   ((= 0 (first bits))
    (decodifica (rest bits) (first (rest node)) hu-tree))
   (T (error "Decodifica impossibile"))))


;;; he-encode (message huffman-tree) -> bits

(defun he-encode (message huffman-tree)
  (cond
   ((OR (null message)  (null huffman-tree))
    (error "Codifica impossibile"))
   (T (codifica message (he-generate-symbol-bits-table huffman-tree)))))

(defun codifica (message table)
  (cond
   ((null message) nil)
   (T (append
       (trova (first message) table)
       (codifica (rest message) table)))))

(defun trova (elem table)
  (cond
   ((null table) (error "Codifica impossibile"))
   ((equal elem (first (first table)))
    (rest (first table)))
   (T (trova elem (rest table)))))


;;; he-encode-file (filename huffman-tree) -> bits

(defun he-encode-file (filename huffman-tree)
  (he-encode (lettura filename) huffman-tree))

(defun lettura (fn)
  (let ((message (coerce (reading fn) 'list)))
    (riduci message (- (length message) (righe message)))))

(defun reading (fn)
  (with-open-file (in fn
		      :direction :input
		      :if-does-not-exist :error)
		  (cond
		   ((not (null in))
		    (let ((string (make-string (file-length in))))
		       (read-sequence string in) string)))))

(defun righe (message)
  (cond
   ((null message) 0)
   ((equal (first message) #\Newline)
    (+ 1 (righe (rest message))))
   (T (+ 0 (righe (rest message))))))

(defun riduci (message l)
  (unless (OR (null message) (= l 0))
    (cons (first message) (riduci (rest message) (- l 1)))))


;;; he-generate-huffman-tree (symbols-n-weights) -> huffman-tree

(defun he-generate-huffman-tree (symbols-n-weights)
  (let ((newsym (unify symbols-n-weights (minori symbols-n-weights))))
    (cond
     ((null (rest newsym )) (first newsym))
     (T (he-generate-huffman-tree newsym)))))


(defun unify (lista sostituto)
  (cond
   ((OR (null lista) (null sostituto)) (error "unify failed"))
   (T (sostituisci lista sostituto))))

(defun sostituisci (lista sostituto)
  (let ((min1 (first sostituto))(min2 (rest sostituto)))
    (cond
     ((null lista) (error "sostituisci failed"))
     ((equal (first lista) min1)
      (cons (new-node min1 min2) (remove min2 (rest lista))))
     ((equal (first lista) min2)
      (cons (new-node min2 min1) (remove min1 (rest lista))))
     (T (cons (first lista) (sostituisci (rest lista) sostituto))))))

(defun minori (lista)
  (cons
   (minore1 (car lista) (rest lista))
   (minore2 (minore1 (car lista) (rest lista)) (car lista) (rest lista))))

(defun new-node (min1 min2)
  (cond
   ((AND (numberp (rest min1)) (numberp (rest min2)))
    (cons
     (cons
      (cons (first min1) (first min2))
      (+ (rest min1) (rest min2)))
     (cons min1 min2)))
   ((numberp (rest min1))
    (cons
     (cons
      (cons (first min1) (first (first min2)))
      (+ (rest min1) (rest (first min2))))
     (cons min1 min2)))
   ((numberp (rest min2))
    (cons
     (cons
      (cons (first (first min1)) (first min2))
      (+ (rest (first min1)) (rest min2)))
     (cons min1 min2)))
   (T (cons
       (cons
        (cons (first (first min1)) (first (first min2)))
        (+ (rest (first min1)) (rest (first min2))))
       (cons min1 min2)))))

(defun minore1 (min1 lista)
  (cond
   ((null min1) (error "min null"))
   ((null lista) min1)
   ((AND (numberp (rest min1)) (numberp (rest (car lista))))
    (cond
     ((equal (rest min1) 1) min1)
     ((< (rest (car lista)) (rest min1))
      (minore1 (car lista) (rest lista)))
     (T (minore1 min1 (rest lista)))))
   ((numberp (rest min1))
    (cond
     ((equal (rest min1) 1) min1)
     ((< (rest (car (car lista))) (rest min1))
      (minore1 (car lista) (rest lista)))
     (T (minore1 min1 (rest lista)))))
   ((equal (rest (car min1)) 1) min1)
   ((numberp (rest (car lista)))
    (if (< (rest (car lista)) (rest (car min1)))
        (minore1 (car lista) (rest lista))
      (minore1 min1 (rest lista))))
   ((< (rest (car (car lista))) (rest (car min1)))
    (minore1 (car lista) (rest lista)))
   (T (minore1 min1 (rest lista)))))

(defun minore2 (min1 min2 lista)
  (cond
   ((OR (null min1) (null min2)) (error "min null"))
   ((null lista)
    (if (equal min1 min2)
        (error "min2 not found")
      min2))
   ((equal min1 (car lista))
    (minore2 min1 min2 (rest lista)))
   ((equal min1 min2)
    (minore2 min1 (car lista) (rest lista)))
   ((AND (numberp (rest min2)) (numberp (rest (car lista))))
    (cond
     ((equal (rest (car lista)) 1) (car lista))
     ((equal (rest min2) 1) min2)
     ((< (rest (car lista)) (rest min2))
      (minore2 min1 (car lista) (rest lista)))
     (T (minore2 min1 min2 (rest lista)))))
   ((numberp (rest min2))
    (cond
     ((equal (rest (car (car lista))) 1 ) (car lista))
     ((equal (rest min2) 1) min2)
     ((< (rest (car (car lista))) (rest min2))
      (minore2 min1 (car lista) (rest lista)))
     (T (minore2 min1 min2 (rest lista)))))
   ((equal (rest (car min2)) 1) min2)
   ((numberp (rest (car lista)))
    (cond
     ((equal (rest (car lista)) 1 ) (car lista))
     ((equal (rest (car min2)) 1) min2)
     ((< (rest (car lista)) (rest (car min2)))
      (minore2 min1 (car lista) (rest lista)))
     (T (minore2 min1 min2 (rest lista)))))
   ((< (rest (car (car lista))) (rest (car min2)))
    (minore2 min1 (car lista) (rest lista)))
   (T (minore2 min1 min2 (rest lista)))))


;;; he-generate-symbol-bits-table (huffman-tree) -> symbol-bits-table

(defun he-generate-symbol-bits-table (huffman-tree)
  (if (OR (null huffman-tree)(not (listp huffman-tree)))
      (error "not value huffmann tree")
    (append
     (bits-table (first (rest huffman-tree)) (list 0))
     (bits-table (rest (rest huffman-tree)) (list 1)))))

(defun bits-table (node bits)
  (cond
   ((OR (null node) (null bits)) (error "not valid value"))
   ((numberp (rest node))
    (list (cons (first node) bits)))
   (T (append
       (bits-table (first (rest node)) (append bits (list 0)))
       (bits-table (rest (rest node)) (append bits (list 1)))))))


;;; he-print-huffman-tree (huffman-tree &optional (indent-level 0)) -> nil

(defun he-print (huffman-tree &optional (indent-level 0))
  (cond
   ((= indent-level 0)
    (format t (coerce (print-no-indent huffman-tree) 'string)))
   (T (format t (coerce (print-indent huffman-tree) 'string)))))

(defun print-no-indent (huffman-tree)
  (if (numberp (rest huffman-tree))
      (coerce (write-to-string huffman-tree) 'list)
    (append
     (print-no-indent (first (rest huffman-tree)))
     (list #\NewLine)
     (coerce (write-to-string (first huffman-tree)) 'list)
     (list #\NewLine)
     (print-no-indent (rest (rest huffman-tree))))))

(defun print-indent (huffman-tree &optional tab)
  (if (numberp (rest huffman-tree))
      (append tab
              (coerce (write-to-string huffman-tree) 'list))
    (append
     (print-indent (first (rest huffman-tree)) (append tab (list #\Tab)))
     (list #\NewLine)
     tab (coerce (write-to-string (first huffman-tree)) 'list)
     (list #\NewLine)
     (print-indent (rest (rest huffman-tree)) (append tab (list #\Tab))))))

;;; end of file - huffman-codes.lisp
