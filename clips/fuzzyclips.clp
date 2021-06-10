(deftemplate Patient
   (slot id (type INTEGER))
   (slot sex)
   (slot chest_pain_type)
   (slot serum_cholestoral)
   (slot exercise_angina)
   (slot slope_ST (type NUMBER))
   (slot vessels_flourosopy)
   (slot thal (type NUMBER))
   (slot class)
)

(deftemplate slope_ST_fuzzy
1 3
((small (z 1 1))
(big (s 2 3)))
)

(deftemplate thal_fuzzy
3 7
((low (z 3 6))
(high (s 7 7)))
)
 
(deftemplate Patient_fuzzy
   (slot id (type INTEGER))
   (slot sex)
   (slot chest_pain_type)
   (slot serum_cholestoral)
   (slot exercise_angina)
   (slot slope_ST-fuzzy (type FUZZY-VALUE slope_ST_fuzzy))
   (slot vessels_flourosopy)
   (slot thal-fuzzy (type FUZZY-VALUE thal_fuzzy))
   (slot class)
)


(deftemplate Diagnosis
 (slot id (type INTEGER))
 (slot diagnosis (type INTEGER) (range 1 2))
 (slot realClass (type INTEGER) (range 1 2))

)


(defrule Menu
(declare (salience 90))
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
(bind ?sex(nth$ 2 (explode$ ?x))) 
(bind ?chest_pain_type(nth$ 3 (explode$ ?x))) 
(bind ?exercise_angina(nth$ 9 (explode$ ?x)))
(bind ?slope_ST(nth$ 11 (explode$ ?x)))
(bind ?vessels_flourosopy(nth$ 12 (explode$ ?x)))
(bind ?thal(nth$ 13 (explode$ ?x)))
(bind ?class(nth$ 14 (explode$ ?x)))

(assert (Patient (id ?id) (sex ?sex) (chest_pain_type ?chest_pain_type) 
               (exercise_angina ?exercise_angina)(slope_ST ?slope_ST)
               (vessels_flourosopy ?vessels_flourosopy) (thal ?thal) (class ?class)))              
(bind ?id (+ ?id 1))
)
(close inputfile)
)

(defrule fuzzify-fact
  (declare (salience 65))
  (Patient (id ?id) (sex ?sex) (chest_pain_type ?chest_pain_type) 
               (exercise_angina ?exercise_angina)(slope_ST ?slope_ST)
               (vessels_flourosopy ?vessels_flourosopy) (thal ?thal) (class ?class))
 =>
  (assert (Patient_fuzzy (id ?id) (sex ?sex) (chest_pain_type ?chest_pain_type) 
               (exercise_angina ?exercise_angina)(slope_ST-fuzzy (?slope_ST 0) (?slope_ST 1))
               (vessels_flourosopy ?vessels_flourosopy) (thal-fuzzy (?thal 0) (?thal 1)) (class ?class)))
)

; thal!=7 and vessels_flourosopy = 3 then 2
(defrule r1
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy low) (vessels_flourosopy ?vf) (class ?class))
   (test (= ?vf 3))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 2) (realClass ?class)))
   (retract ?f))
   
 ; thal!=7 και vessels_flourosopy !=3 !=0 and sex=0 and chest_pain !=4 then 1
(defrule r2
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy low) (vessels_flourosopy ?vf) (chest_pain_type ?chp) (sex ?sex) (class ?class))
   (test (<> ?vf 0))
   (test (<> ?vf 3))
   (test (<> ?chp 4))
   (test (= ?sex 0))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 1) (realClass ?class)))
   (retract ?f))


; thal!=7 και vessels_flourosopy !=3 !=0 and sex!=0 and chest_pain =4 then 2
(defrule r3
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy low) (vessels_flourosopy ?vf) (chest_pain_type ?chp) (sex ?sex) (class ?class))
   (test (<> ?vf 0))
   (test (<> ?vf 3))
   (test (= ?chp 4))
   (test (= ?sex 1))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 2) (realClass ?class)))
   (retract ?f))


; thal!=7 και vessels_flourosopy !=3 !=0 and sex=0 then 1
(defrule r4
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy low) (vessels_flourosopy ?vf) (chest_pain_type ?chp) (sex ?sex) (class ?class))
   (test (<> ?vf 0))
   (test (<> ?vf 3))
   (test (= ?sex 0))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 1) (realClass ?class)))
   (retract ?f))


; thal!=7 and vessels_flourosopy = 0 then 1
(defrule r5
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy low) (vessels_flourosopy ?vf) (class ?class))
   (test (= ?vf 0))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 2) (realClass ?class)))
   (retract ?f))


; thal=7 and vessels_flourosopy != 0 then 2
(defrule r6
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy high) (vessels_flourosopy ?vf) (class ?class))
   (test (<> ?vf 0))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 2) (realClass ?class)))
   (retract ?f))


; thal=7 and vessels_flourosopy = 0 and slope_ST > 1.0 and exercise_angina !=0 then 2
(defrule r7
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy high) (vessels_flourosopy ?vf) (slope_ST-fuzzy big) (exercise_angina ?exang) (class ?class))
   (test (= ?vf 0))
   (test (<> ?exang 0))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 2) (realClass ?class)))
   (retract ?f))


; thal=7 and vessels_flourosopy = 0 and slope_ST > 1.0 and exercise_angina=0 then 1
(defrule r8
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy high) (vessels_flourosopy ?vf) (slope_ST-fuzzy big) (exercise_angina ?exang) (class ?class))
   (test (= ?vf 0))
   (test (= ?exang 0))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 1) (realClass ?class)))
   (retract ?f))


; thal=7 and vessels_flourosopy = 0 and slope_ST <=1.0 and exercise_angina=0 then 1
(defrule r9
   (declare (salience 80))
   ?f <- (Patient_fuzzy (id ?id) (thal-fuzzy high) (vessels_flourosopy ?vf) (slope_ST-fuzzy small) (exercise_angina ?exang) (class ?class))
   (test (= ?vf 0))
   =>
   (assert (Diagnosis (id ?id) (diagnosis 1) (realClass ?class)))
   (retract ?f))
   

(defrule metrics
     =>
     (load "C:/Users/man0s/Desktop/heart-data-analysis-expert-system-main/heart-data-analysis-expert-system-main/clips/metrics.clp")
)
