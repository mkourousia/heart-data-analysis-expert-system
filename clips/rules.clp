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

(defrule r1
   (Patient (thal ?th))
   (test (= ?th 6))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout "Heart desease diagnosed" crlf))

(defrule r2
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (test (and (= ?th 6) (>= ?vf 1)))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))


(deffacts Symptoms
   (Patient (age 62) 
            (sex 0) 
            (chest_pain_type 3) 
            (blood_pressure 130) 
            (serum_cholestoral 263)
            (blood_sugar_gt_120 0)
            (electrocardio_rslt 0)
            (max_heart_rate 97)
            (exercise_angina 0)
            (oldpeak 1.2)
            (slope_ST 2)
            (vessels_flourosopy 1)
            (thal 7)))

