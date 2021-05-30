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
   (slot class))

(deftemplate Diagnosis
   (slot diagnosis))

; thal=6 then yes (rule 1)
(defrule r1
   (Patient (thal ?th))
   (test (= ?th 6))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))

; thal=7 and vessels_flourosopy>=1 then yes (rules 2,3,4)
(defrule r2_3_4
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (test (and (= ?th 6) (>= ?vf 1)))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak>0.6 then yes (rule 5)
(defrule r5
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (Patient (oldpeak ?oldp))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (and (test (= ?chp 4))
        (test (> ?oldp 0.6)))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak<=0.6 and max_heart_rate>163 then yes (rule 6)
(defrule r6
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
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))


; thal=7 and vessels_flourosopy=0 and chest_pain_type=4 and oldpeak<=0.6 and max_heart_rate<=163 then no (rule 7)
(defrule r7
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
   (assert (Diagnosis (diagnosis no)))
   (printout t "No heart desease diagnosed" crlf))

; thal=7 and vessels_flourosopy=0 and chest_pain_type>=1 then 1 (rules 8,9,10)
(defrule r8_9_10
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (chest_pain_type ?chp))
   (and (test (= ?th 7))
        (test (= ?vf 0)))
   (test (< ?chp 4))
   =>
   (assert (Diagnosis (diagnosis no)))
   (printout t "No heart desease diagnosed" crlf))


(deffacts Symptoms
   (Patient (age 51) 
            (sex 1) 
            (chest_pain_type 3) 
            (blood_pressure 100) 
            (serum_cholestoral 222)
            (blood_sugar_gt_120 0)
            (electrocardio_rslt 0)
            (max_heart_rate 143)
            (exercise_angina 1)
            (oldpeak 1.2)
            (slope_ST 2)
            (vessels_flourosopy 0)
            (thal 3)))

