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

; thal=3 and vessels_flourosopy=3 then yes (rule 11)
(defrule r11
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (test (and (= ?th 3) (= ?vf 3)))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))

; thal=3 and vessels_flourosopy=2 and exercise_angina=1 then yes (rule 12)
(defrule r12
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (exercise_angina ?ea))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 1)))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))
   
; thal=3 and vessels_flourosopy=2 and exercise_angina=0 and age>62 then no (rule 13)
(defrule r13
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (exercise_angina ?ea))
   (Patient (age ?ag))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 0))
        (test (< ?ag 62)))
   =>
   (assert (Diagnosis (diagnosis no)))
   (printout t " No heart desease diagnosed" crlf))
   
; thal=3 and vessels_flourosopy=2 and exercise_angina=0 and age<=62 then yes (rule 14)
(defrule r14
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (exercise_angina ?ea))
   (Patient (age ?ag))
   (and (test (= ?th 3))
        (test (= ?vf 2)))
   (and (test (= ?ea 0))
        (test (>= ?ag 62)))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))
   
; thal=3 and vessels_flourosopy=1 and sex=1 and chest_pain_type=4 then yes (rule 15)
(defrule r15
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (sex ?se))
   (Patient (chest_pain_type ?cpt))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 1))
        (test (= ?cpt 4)))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))   

; thal=3 and vessels_flourosopy=1 and sex=1 and chest_pain_type<=3 then 1 (rules 16,17,18)
(defrule r16_17_18
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (sex ?se))
   (Patient (chest_pain_type ?cpt))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 1))
        (test (>= ?cpt 3)))
   =>
   (assert (Diagnosis (diagnosis no)))
   (printout t " No heart desease diagnosed" crlf))    
   
; thal=3 and vessels_flourosopy=1 and sex=0 then no (rule 19)
(defrule r19
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
   (Patient (sex ?se))
   (and (test (= ?th 3))
        (test (= ?vf 1)))
   (and (test (= ?se 0)))
        
   =>
   (assert (Diagnosis (diagnosis no)))
   (printout t " No heart desease diagnosed" crlf))  
   
; thal=3 and vessels_flourosopy=0 and blood_pressure>156 and  age>62 then no (rule 20)
(defrule r20
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
(Patient (blood_pressure ?bp))
   (Patient (age ?ag))
   (and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (< ?bp 156))
        (test (< ?ag 62)))
   =>
   (assert (Diagnosis (diagnosis no)))
   (printout t "No heart desease diagnosed" crlf))
   
; thal=3 and vessels_flourosopy=0 and blood_pressure>156 and  age<=62 then yes (rule 21)
(defrule r21
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
(Patient (blood_pressure ?bp))
   (Patient (age ?ag))
   (and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (< ?bp 156))
        (test (>= ?ag 62)))
   =>
   (assert (Diagnosis (diagnosis yes)))
   (printout t "Heart desease diagnosed" crlf))

; thal=3 and vessels_flourosopy=0 and blood_pressure<=156 then no (rule 22)
(defrule r22
   (Patient (thal ?th))
   (Patient (vessels_flourosopy ?vf))
(Patient (blood_pressure ?bp))
(and (test (= ?th 3))
        (test (= ?vf 0)))
   (and (test (>= ?bp 156)))
        
   =>
   (assert (Diagnosis (diagnosis no)))
   (printout t "No heart desease diagnosed" crlf))
   
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