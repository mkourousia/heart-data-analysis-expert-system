(deftemplate Patient
   (slot id (type INTEGER))
   (slot age (type NUMBER))
   (slot sex)
   (slot chest_pain_type)
   (slot blood_pressure)
   (slot serum_cholestoral)
   (slot blood_sugar_gt_120)
   (slot electrocardio_rslt)
   (slot max_heart_rate)
   (slot exercise_angina)
   (slot oldpeak)
   (slot slope_ST)
   (slot vessels_flourosopy)
   (slot thal)
   (slot class))
   
(deftemplate age_fuzzy
29 77
((young (z 29 35))
(old (s 35 77)))
)

(deftemplate oldpeak_fuzzy
0 6.2
((small (z 0 3.6))
(big (s 3.6 6.2)))
)
 
(deftemplate Patient_fuzzy
   (slot id (type INTEGER))
   (slot age-fuzzy (type FUZZY-VALUE age_fuzzy))
   (slot sex)
   (slot chest_pain_type)
   (slot blood_pressure)
   (slot serum_cholestoral)
   (slot blood_sugar_gt_120)
   (slot electrocardio_rslt)
   (slot max_heart_rate)
   (slot exercise_angina)
   (slot oldpeak-fuzzy (type FUZZY-VALUE oldpeak_fuzzy))
   (slot slope_ST)
   (slot vessels_flourosopy)
   (slot thal)
   (slot class))

(defrule Menu
(declare (salience 70))
=>
(printout t "Selection 1: Load training set" crlf "Selection 2: Load test set" crlf)
(bind ?response (read))
(if (= ?response 1) then
(open "C:/Users/man0s/Desktop/heart-data-analysis-expert-system-main/heart-data-analysis-expert-system-main/data/input-training-set.clp" inputfile "r")
(printout t "Training set loaded" crlf crlf)
else
(open "C:/Users/man0s/Desktop/heart-data-analysis-expert-system-main/heart-data-analysis-expert-system-main/data/input-test-set.clp" inputfile "r")
(printout t "Test set loaded" crlf crlf)
)

(bind ?id 1)
(while (stringp(bind ?x(readline inputfile)))
do
(bind ?age(nth$ 1 (explode$ ?x))) 
(bind ?sex(nth$ 2 (explode$ ?x))) 
(bind ?chest_pain_type(nth$ 3 (explode$ ?x))) 
(bind ?blood_pressure(nth$ 4 (explode$ ?x))) 
(bind ?serum_cholestoral(nth$ 5 (explode$ ?x))) 
(bind ?blood_sugar_gt_120(nth$ 6 (explode$ ?x))) 
(bind ?electrocardio_rslt(nth$ 7 (explode$ ?x)))
(bind ?max_heart_rate(nth$ 8 (explode$ ?x))) 
(bind ?exercise_angina(nth$ 9 (explode$ ?x)))
(bind ?oldpeak(nth$ 10 (explode$ ?x)))
(bind ?slope_ST(nth$ 11 (explode$ ?x)))
(bind ?vessels_flourosopy(nth$ 12 (explode$ ?x)))
(bind ?thal(nth$ 13 (explode$ ?x)))
(bind ?class(nth$ 14 (explode$ ?x)))

(assert (Patient (id ?id) (age ?age) (sex ?sex)(chest_pain_type ?chest_pain_type)(blood_pressure ?blood_pressure)
               (serum_cholestoral ?serum_cholestoral)(blood_sugar_gt_120 ?blood_sugar_gt_120)
               (electrocardio_rslt ?electrocardio_rslt)(max_heart_rate ?max_heart_rate)
               (exercise_angina ?exercise_angina)(oldpeak ?oldpeak)(slope_ST ?slope_ST)
               (vessels_flourosopy ?vessels_flourosopy)(thal ?thal)
               (class ?class)))               
(bind ?id (+ ?id 1))
)
(close inputfile)
)


(deftemplate result
 (slot id (type INTEGER))
 (slot predicted_class (type INTEGER) (range 1 2))
 (slot real_class (type INTEGER) (range 1 2))
 (slot nr(type INTEGER) (range 1 22))
 )

; thal=6 then yes (rule 1)
(defrule r1
?f <- (Patient_fuzzy (id ?id) (thal ?th) (class ?class))
   (test (= ?th 6))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 1)))
   (retract ?f)
)

; thal=7 and vessels_flourosopy>=1 then yes (rules 2,3,4)
(defrule r2_3_4
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (class ?class))
   (test (and (= ?th 6) (>= ?vf 1)))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 2)))
   (retract ?f)
)

; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak>0.6 then yes (rule 5)
(defrule r5
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (chest_pain_type ?chp) (oldpeak-fuzzy small or big) (class ?class))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (= ?chp 4)))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 5)))
   (retract ?f)
)

; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak<=0.6 and max_heart_rate>163 then yes (rule 6)
(defrule r6
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (chest_pain_type ?chp) (oldpeak-fuzzy small) (max_heart_rate ?mhr) (class ?class))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (= ?chp 4)))
   (test (> ?mhr 163))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 6)))
   (retract ?f)
)

; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak<=0.6 and max_heart_rate<=163 then no (rule 7)
(defrule r7
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (chest_pain_type ?chp) (oldpeak-fuzzy small) (max_heart_rate ?mhr) (class ?class))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (= ?chp 4)))
   (test (<= ?mhr 163))
   =>
   (assert (result (id ?id) (predicted_class 1) (real_class ?class) (nr 7)))
   (retract ?f)
)

; thal=7 and vessels_flourosopy=0 and chest_pain_type>=1 then 1 (rules 8,9,10)
(defrule r8_9_10
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (chest_pain_type ?chp) (class ?class))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (test (< ?chp 4))
   =>
   (assert (result (id ?id) (predicted_class 1) (real_class ?class) (nr 8)))
   (retract ?f)
)

; thal=3 and vessels_flourosopy=3 then yes (rule 11)
(defrule r11
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (class ?class))
   (test (and (= ?th 3) (= ?vf 3)))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 11)))
   (retract ?f)
)

; thal=3 and vessels_flourosopy=2 and exercise_angina=1 then yes (rule 12)
(defrule r12
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (exercise_angina ?ea) (class ?class))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 1)))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 12)))
   (retract ?f)
)  

; thal=3 and vessels_flourosopy=2 and exercise_angina=0 and age>62 then no (rule 13)
(defrule r13
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (exercise_angina ?ea) (age-fuzzy young or old) (class ?class))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 0)))
   =>
   (assert (result (id ?id) (predicted_class 1) (real_class ?class) (nr 13)))
   (retract ?f)
)
  
; thal=3 and vessels_flourosopy=2 and exercise_angina=0 and age<=62 then yes (rule 14)
(defrule r14
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (exercise_angina ?ea) (age-fuzzy old) (class ?class))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 0)))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 14)))
   (retract ?f)
)   

; thal=3 and vessels_flourosopy=1 and sex=1 and chest_pain_type=4 then yes (rule 15)
(defrule r15
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (sex ?se) (chest_pain_type ?cpt) (class ?class))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 1))
        (test (= ?cpt 4)))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 15)))
   (retract ?f)   
)

; thal=3 and vessels_flourosopy=1 and sex=1 and chest_pain_type<=3 then 1 (rules 16,17,18)
(defrule r16_17_18
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (sex ?se) (chest_pain_type ?cpt) (class ?class))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 1))
        (test (>= ?cpt 3)))
   =>
   (assert (result (id ?id) (predicted_class 1) (real_class ?class) (nr 16)))
   (retract ?f)
)
   
; thal=3 and vessels_flourosopy=1 and sex=0 then no (rule 19)
(defrule r19
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (sex ?se) (class ?class))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 0)))
        
   =>
   (assert (result (id ?id) (predicted_class 1) (real_class ?class) (nr 19)))
   (retract ?f)
)  

; thal=3 and vessels_flourosopy=0 and blood_pressure>156 and  age>62 then no (rule 20)
(defrule r20
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (blood_pressure ?bp) (age-fuzzy young or old) (class ?class))
   (and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (< ?bp 156)))
   =>
   (assert (result (id ?id) (predicted_class 1) (real_class ?class) (nr 20)))
   (retract ?f)
)  

; thal=3 and vessels_flourosopy=0 and blood_pressure>156 and  age<=62 then yes (rule 21)
(defrule r21
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (blood_pressure ?bp) (age-fuzzy old)(class ?class))
   (and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (< ?bp 156)))
   =>
   (assert (result (id ?id) (predicted_class 2) (real_class ?class) (nr 21)))
   (retract ?f)
)

; thal=3 and vessels_flourosopy=0 and blood_pressure<=156 then no (rule 22)
(defrule r22
?f <- (Patient_fuzzy (id ?id) (thal ?th) (vessels_flourosopy ?vf) (blood_pressure ?bp) (class ?class))
(and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (>= ?bp 156)))
        
   =>
   (assert (result (id ?id) (predicted_class 1) (real_class ?class) (nr 22)))
   (retract ?f)
)
