(deftemplate Patient
   (slot age)
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
)


(deftemplate Diagnosis
 (slot id (type INTEGER))
 (slot diagnosis (type INTEGER) (range 1 2))
 )


(defrule Menu
(declare (salience 90))
=>
(printout t "Selection 1: Load training set" crlf "Selection 2: Load test set" crlf)
(bind ?response (read))
(if (= ?response 1) then
(open "C:/Users/mariak/heart-data-analysis-expert-system/data/input-training-set.clp" inputfile "r")
(printout t "Training set loaded" crlf crlf)
else
(open "C:/Users/mariak/heart-data-analysis-expert-system/data/input-test-set.clp" inputfile "r")
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

(assert (facts (id ?id) (age ?age) (sex ?sex) (chest_pain_type ?chest_pain_type) (blood_pressure ?blood_pressure)
               (serum_cholestoral ?serum_cholestoral) (blood_sugar_gt_120 ?blood_sugar_gt_120)
               (electrocardio_rslt ?electrocardio_rslt) (max_heart_rate ?max_heart_rate)
               (exercise_angina ?exercise_angina) (oldpeak ?oldpeak) (slope_ST ?slope_ST)
               (vessels_flourosopy ?vessels_flourosopy) (thal ?thal)
         )               
(bind ?id (+ ?id 1))
)
(close inputfile)
)


; thal!=7 and vessels_flourosopy = 3 then 2
(defrule r1
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (test (and (!= ?th 7) (= ?vf 3)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal!=7 και vessels_flourosopy !=3 !=0 and sex!=0 and chest_pain !=4 then 1
(defrule r2
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (Patient (sex ?sex))
   (and (test (!= ?th 7))
        (test (and (!= ?vf 0) (!= ?vf 3) ))
   (and (test (!= ?chp 4))
        (test (= sex 1)))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t "No heart desease diagnosed" crlf))


; thal!=7 και vessels_flourosopy !=3 !=0 and sex!=0 and chest_pain !=4 then 2
(defrule r3
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (Patient (sex ?sex))
   (and (test (!= ?th 7))
        (test (and (!= ?vf 0) (!= ?vf 3) ))
   (and (test (= ?chp 4))
        (test (= sex 1)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal!=7 και vessels_flourosopy !=3 !=0 and sex!=0 and chest_pain !=4 then 1
(defrule r4
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (Patient (sex ?sex))
   (and (test (!= ?th 7))
        (test (and (!= ?vf 0)))
   (and (test (!= ?vf 3))
        (test (= sex 0)))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t "No heart desease diagnosed" crlf))


; thal!=7 and vessels_flourosopy = 3 then 2
(defrule r5
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (test (and (= ?th 7) (= ?vf 3) )
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy != 0 then 2
(defrule r6
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (test (and (= ?th 7) (!= ?vf 0)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy = 0 and slope_ST > 1.0 and exercise_angina !=0 then 2
(defrule r7
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (slope_ST ?slope))
   (Patient (exercise_angina ?exang))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (> ?slope_ST 1.0))
        (test (!= ?exang 0)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy = 0 and slope_ST > 1.0 and exercise_angina=0 then 2
(defrule r8
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (slope_ST ?slope))
   (Patient (exercise_angina ?exang))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (> ?slope_ST 1.0))
        (test (= ?exang 0)))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t "No heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy = 0 and slope_ST > 1.0 and exercise_angina=0 then 2
(defrule r9
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (slope_ST ?slope))
   (Patient (exercise_angina ?exang))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (test (<= ?slope_ST 1.0))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t "No heart desease diagnosed" crlf))


; TEMPORARY
(deffacts Symptoms
   (Patient (age 60) 
            (sex 8) 
            (chest_pain_type 5) 
            (blood_pressure 65) 
            (serum_cholestoral 300)
            (blood_sugar_gt_120 0)
            (electrocardio_rslt 0)
            (max_heart_rate 143)
            (exercise_angina 1)
            (oldpeak 1.2)
            (slope_ST 2)
            (vessels_flourosopy 0)
            (thal 7))) 