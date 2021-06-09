(defglobal
   ?*TP* = 0 
   ?*FN* = 0 
   ?*FP* = 0 
   ?*TN* = 0 )


(defrule TP
(Diagnosis (id ?id) (diagnosis 1) (realClass 1))
=>
(bind ?*TP* (+ ?*TP* 1)))


(defrule FN
(Diagnosis (id ?id) (diagnosis ~1) (realClass 1))
=>
(bind ?*FN* (+ ?*FN* 1)))


(defrule FP
(Diagnosis (id ?id) (diagnosis 1) (realClass ~1))
=>
(bind ?*FP* (+ ?*FP* 1)))


(defrule TN
(Diagnosis (id ?id) (diagnosis ~1) (realClass ~1))
=>
(bind ?*TN* (+ ?*TN* 1)))


(defrule results 
   (declare (salience -1))
   =>
   (bind ?Precision (/ ?*TP* (+ ?*TP* ?*FP*)))
   (bind ?Recall (/ ?*TP* (+ ?*TP* ?*FN*)))
   (bind ?F_Measure (/ (* 2 (* ?Precision ?Recall) ) (+ ?Precision ?Recall)))
   (printout t "Precision: " ?Precision crlf)
   (printout t "Recall: " ?Recall crlf)
   (printout t "F-Measure: " ?F_Measure crlf)
)



