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
((small (1 1) (2 0))
(big (2 0) (3 1)))
)

(deftemplate thal_fuzzy
3 7
((normal (3 1) (6 0))
(increased (6 0) (7 1)))
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
 (slot predicted_class (type INTEGER) (range 1 2))
 (slot real_class (type INTEGER) (range 1 2))
 (slot nr(type INTEGER) (range 1 22))
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
   ?f <- (Patient_fuzzy (id ?id) (vessels_flourosopy ?vf) (class ?class))
   (test (= ?vf 3))
   =>
   (assert (Diagnosis (id ?id) (predicted_class 2) (real_class ?class) (nr 1)))
   (retract ?f))
