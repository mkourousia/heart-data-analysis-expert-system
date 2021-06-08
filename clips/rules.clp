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

; thal=6 then 2 (rule 1)
(defrule r1
   (declare (salience 80))
   (Patient (thal ?th))
   (test (= ?th 6))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy>=1 then 2 (rules 2,3,4)
(defrule r2_3_4
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (test (and (= ?th 6) (>= ?vf 1)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak>0.6 then 2 (rule 5)
(defrule r5
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (Patient (oldpeak ?oldp))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (= ?chp 4))
        (test (> ?oldp 0.6)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak<=0.6 and max_heart_rate>163 then 2 (rule 6)
(defrule r6
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (Patient (oldpeak ?oldp))
   (Patient (max_heart_rate ?mhr))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (= ?chp 4))
        (test (<= ?oldp 0.6)))
   (test (> ?mhr 163))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak<=0.6 and max_heart_rate<=163 then 1 (rule 7)
(defrule r7
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (Patient (oldpeak ?oldp))
   (Patient (max_heart_rate ?mhr))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (= ?chp 4))
        (test (<= ?oldp 0.6)))
   (test (<= ?mhr 163))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t "No heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy=0 and chest_pain_type>=1 then 1 (rules 8,9,10)
(defrule r8_9_10
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (test (< ?chp 4))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t "No heart desease diagnosed" crlf))


; thal=3 and vessels_flourosopy=3 then 2 (rule 11)
(defrule r11
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (test (and (= ?th 3) (= ?vf 3)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=3 and vessels_flourosopy=2 and exercise_angina=1 then 2 (rule 12)
(defrule r12
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (exercise_angina ?ea))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 1)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))
   

; thal=3 and vessels_flourosopy=2 and exercise_angina=0 and age>62 then 1 (rule 13)
(defrule r13
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (exercise_angina ?ea))
   (Patient (age ?ag))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 0))
        (test (< ?ag 62)))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t " No heart desease diagnosed" crlf))
   

; thal=3 and vessels_flourosopy=2 and exercise_angina=0 and age<=62 then 2 (rule 14)
(defrule r14
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (exercise_angina ?ea))
   (Patient (age ?ag))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 0))
        (test (>= ?ag 62)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))
   

; thal=3 and vessels_flourosopy=1 and sex=1 and chest_pain_type=4 then 2 (rule 15)
(defrule r15
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (sex ?se))
   (Patient (chest_pain_type ?cpt))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 1))
        (test (= ?cpt 4)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))   


; thal=3 and vessels_flourosopy=1 and sex=1 and chest_pain_type<=3 then 1 (rules 16,17,18)
(defrule r16_17_18
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (sex ?se))
   (Patient (chest_pain_type ?cpt))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 1))
        (test (>= ?cpt 3)))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t " No heart desease diagnosed" crlf))    

   
; thal=3 and vessels_flourosopy=1 and sex=0 then no (rule 19)
(defrule r19
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (sex ?se))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 0)))
        
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t " No heart desease diagnosed" crlf))  
   

; thal=3 and vessels_flourosopy=0 and blood_pressure>156 and  age>62 then 1 (rule 20)
(defrule r20
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
(Patient (blood_pressure ?bp))
   (Patient (age ?ag))
   (and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (< ?bp 156))
        (test (< ?ag 62)))
   =>
   (assert (Diagnosis (diagnosis 1)))
   (printout t "No heart desease diagnosed" crlf))
   

; thal=3 and vessels_flourosopy=0 and blood_pressure>156 and  age<=62 then 2 (rule 21)
(defrule r21
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
(Patient (blood_pressure ?bp))
   (Patient (age ?ag))
   (and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (< ?bp 156))
        (test (>= ?ag 62)))
   =>
   (assert (Diagnosis (diagnosis 2)))
   (printout t "Heart desease diagnosed" crlf))


; thal=3 and vessels_flourosopy=0 and blood_pressure<=156 then 1 (rule 22)
(defrule r22
   (declare (salience 80))
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
(Patient (blood_pressure ?bp))
(and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (>= ?bp 156)))
        
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