;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname PANDEMIC_PROJECT_FINAL) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; This is made by
; Nicholas Christie 0005778687
; Isiah Williamson 5550064370
; Aaron Howington 5550068208
; Jacqueline Chapa 0005441503
; Jeremy Salinas
; Jesus Olmos
; Jesus Urbinagil: 0005703138
; Tony Franco
; Sourced Material: DrRacket
; Citing: CISC 106 Class, Prof Allan Schougaard

(require 2htdp/image)
(require 2htdp/universe)

; A struct where infection-status = string; location-xy = posn; infection-duration = number
; infection-status: from susceptible one can become infectious.
; After infectious one becomes recovered.
(define recovery-period (* 14 24)) ; the time in days it takes to recover 
(define-struct individual (infection-status location-xy infection-duration)) ;Defining a struct with three parameters

(define status-susceptible "susceptible") ;Defining status's to show susceptible, infected, or recovered
(define status-infected "infected") ;Defining status's to show susceptible, infected, or recovered
(define status-recovered "recovered") ;Defining status's to show susceptible, infected, or recovered

(define susceptible-color "yellow") ;Defining status's to show susceptible, infected, or recovered
(define infected-color "red") ;Defining status's to show susceptible, infected, or recovered
(define recovered-color "green") ;Defining status's to show susceptible, infected, or recovered

(define girth 6)
; make a list of individuals to be our population..


(define population ;defining a population
  (list ;by using a list
   (make-individual status-susceptible (make-posn 0 0) 0) ;creating one individual with a susceptible status and given position
   (make-individual status-susceptible (make-posn 240 240) 0)
   (make-individual status-infected (make-posn 230 230) 0) ;creating one individual with an infected status and given position
   (make-individual status-infected (make-posn 250 250) 0)
   (make-individual status-recovered (make-posn 400 400) 0) ;creating one individual with a recovered status and given position
  )
)






; Purpose: Make a funciton that determines the manhattan distance between 2 individuals
; Signature: individual individual -> number
(check-expect (manhattan-distance (make-individual status-susceptible (make-posn 0 1) 0)
                                  (make-individual status-susceptible (make-posn 250 251) 0))
              (+ (abs (- 0 250)) (abs (- 1 251))))
; Code:
(define (manhattan-distance indv-1 indv-2) ; defining a function for the manhatten distance between two individulaes
  (+ (abs (- (posn-x (individual-location-xy indv-1)) ; we are subtracking position x of individual 1 and 2, then taking the absolute form
             ; of that number and adding it to the asbolute value of posn-y of individual 1 and 2, and adding them together to get the distance between them. 
             (posn-x (individual-location-xy indv-2))))
     (abs (- (posn-y (individual-location-xy indv-1))
             (posn-y (individual-location-xy indv-2)))))
)






;Purpose: detect whether two individuals are within a  given radius of eachother
;Signature: Individual Individual -> Boolean
;Examples:
(check-expect (near-indv?
               (make-individual status-susceptible (make-posn 0 0) 0)
               (make-individual status-susceptible (make-posn 250 250) 0)) false)
(check-expect (near-indv?
               (make-individual status-susceptible (make-posn 0 0) 0)
               (make-individual status-susceptible (make-posn 0 0) 0)) true)
;Code:
(define (near-indv? indv-1 indv-2) ; defining a function that uses our manhatten-distance function to compare if two individuals are near each other
  ; and return a true or false based on their distance. 
  (< (manhattan-distance indv-1 indv-2) (* 3 girth)) ; comapring if two times the girth of our individuals is greaterthan the manhatten distance between the two of them.
)





; Purspoe: Detect if a suceptible individual is-near? an infected individual
; Signature: individual individual -> boolean
(check-expect (transmission-possible? (make-individual status-susceptible (make-posn 100 100) 0)
                                      (make-individual status-infected    (make-posn 102 102) 0))
              true)
(check-expect (transmission-possible? (make-individual status-susceptible (make-posn 100 100) 0)
                                      (make-individual status-susceptible (make-posn 102 102) 0))
              false)
(check-expect (transmission-possible? (make-individual status-infected  (make-posn 100 100) 0)
                                      (make-individual status-recovered (make-posn 102 102) 0))
              false)
; Code:
(define (transmission-possible? indv-1 indv-2) ; Defining our function that returns a boolean if its possible to transmite between these
  ; two individuals 
  (and (near-indv? indv-1 indv-2) ; using our near function, we see if first the two individuals are near each other,and evaluates to true 
       (or ; will evaluate to true once one of the below expressions is true.
        (and (string=? (individual-infection-status indv-1) status-infected) ; compairing if the indiv infection status of the first indiv is equal to infected
             (string=? (individual-infection-status indv-2) status-susceptible))  ; compairing if the indiv infection status of the first indiv is equal to susceptiable
        ;                                                                        if both of these are true, then we return true, otherwise we move onto the next and
        (and (string=? (individual-infection-status indv-1) status-susceptible)  ; compairing if the indiv infection status of the first indiv is equal to susceptiable
             (string=? (individual-infection-status indv-2) status-infected))))) ; compairing if the indiv infection status of the first indiv is equal to infected, and
                                                                                 ; if both are true we return true, otherwise false. 




; Purpose: change an individual's status based on current status and nearby individuals
; Signature: List(population) individual -> individual
(check-expect (transmit (list)
                        (make-individual status-susceptible (make-posn 100 100) 0))
              (make-individual status-susceptible (make-posn 100 100) 0))

(check-expect (transmit (list (make-individual status-infected (make-posn 100 100) 0))
                        (make-individual status-susceptible (make-posn 101 102) 0))
              (make-individual status-infected (make-posn 101 102) 0))

(check-expect (transmit (list (make-individual status-infected (make-posn 105 106) 0))
                        (make-individual status-recovered (make-posn 105 106) 0))
              (make-individual status-recovered (make-posn 105 106) 0))
; Code:
(define (transmit pop indv) ; defining a function that will change indiv status based on nearby pop. 
  (cond
    ((empty? pop) indv) ; conditional statnemtn, if our population is empty, then we return our indidual because they can't be infected.
    ((transmission-possible? (first pop) indv) ; othewise we check if trasmission is possible between the first individual of our population and the individual.
     (make-individual status-infected (individual-location-xy indv) 0)) ; if the above evaluates to true we make a new individual with the infected status
                                                                        ; at the same location of the input individual
    (else (transmit (rest pop) indv))))                                 ; otherwise we recursively go through the rest of the population until its empty. 




; Purpose: transmit on a population basis
; Signature: List(population) -> List(population)
(check-expect (transmit-population (list)) (list))
(check-expect (transmit-population
               (list (make-individual status-infected (make-posn 20 20) 0)))
              (list (make-individual status-infected (make-posn 20 20) 0)))

(check-expect (transmit-population
               (list (make-individual status-infected (make-posn 20 20) 0)
                     (make-individual status-susceptible (make-posn 20 20) 0)))
              (list (make-individual status-infected (make-posn 20 20) 0)
                    (make-individual status-infected (make-posn 20 20) 0)))

(check-expect (transmit-population
               (list (make-individual status-susceptible (make-posn 20 20) 0)
                     (make-individual status-infected (make-posn 20 20) 0)))
              (list (make-individual status-infected (make-posn 20 20) 0)
                    (make-individual status-infected (make-posn 20 20) 0)))


; Code:
(define (transmit-population-recursive full-pop pop) ; creating a recursive function that transmits to full population from a population
  (cond
    ((empty? pop) (list)) ; conditional, if our population is empty, we return an empty list
    (else (append (list (transmit full-pop (first pop))) ; else we append/combine a list comprised of our transmit expression to the full-population
                  ; with the recursive function of transmitting to the rest of our population, and then output that list. 
                  (transmit-population-recursive full-pop (rest pop)))
          )))

(define (transmit-population pop) ; simplified version of the above
  (transmit-population-recursive pop pop)) ; that uses our recursive function, for the input population, then recursively again twice. 





;Purpose: return an individual as an image.
;Signature: individual -> image
;Examples:
(check-expect (display-individual (make-individual status-susceptible (make-posn 100 100) 0))
              (circle girth "solid" susceptible-color))
(check-expect (display-individual (make-individual status-infected (make-posn 200 200) 0))
              (circle girth "solid" infected-color))
(check-expect (display-individual (make-individual status-recovered (make-posn 400 400) 0))
              (circle girth "solid" recovered-color))

;Stub:
;(define  (display-individual ind) "NO")

;Code:
(define  (display-individual ind) ; creating a function display-individual with a parameter of ind
  (cond ;using a string for this so that there is an option for susceptible, individual, and recovered
    [(string=? (individual-infection-status ind) status-susceptible)
     (circle girth "solid" susceptible-color)] ; we are comparing if the status of the individual is equal to susceptiable,and if it is we try a the corosponding circle representing them
    [(string=? (individual-infection-status ind) status-infected) ; we are comparing if the status of the individual is equal to infected,
                                               ; and if it is we try a the corosponding circle representing them
     (circle girth "solid" infected-color)]
    [else (circle girth "solid" recovered-color)] ; otherwise if they aren't susceptiable or infected they must be recovered, so we draw the recovered color. 
    )
  )

(define background-size 300) ;defining the size of our background (interface)
(define background (square background-size "solid" "black")) ;giving the background some color

(define (no-susceptible? indv)
  (if (string=? status-susceptible (individual-infection-status indv))
      false
      true
      ))


;Purpose: Fold Time Counter Into Background
;Signature: Time->Image
;Example:
(check-expect (display-background-time 0 0) (underlay/align "right" "top" (underlay/align "left" "top" background (time-display 0)) (sus-display 0)))

;Code:
(define (display-background-time t n-of-s) ;creating a function displa-bakcground-time that will use a parameter of t for time
  (underlay/align "right" "top"  (underlay/align  "left" "top" background (time-display t)) (sus-display n-of-s))
  )  ;this time counter will be on the top left corner of the background



;Purpose: create a function that will display the population and time onto the background
;Signaure: list number -> image
;Examples:
(check-expect (display-population (list) 0 0) (display-background-time 0 0))
(check-expect (display-population (list (make-individual status-susceptible (make-posn 100 200) 0)) 0 1)
              (place-image (display-individual
                             (make-individual status-susceptible (make-posn 100 200) 0))
                            100 200 (display-background-time 0 1))
              ) 

;Code:
(define (display-population pop t s-pop) ;defining a function display-population with a parameter of time and population
  (if (empty? pop) ;if the population is empty that just run the display-background-time funciton
      (display-background-time t s-pop) ;this was definined above to just show the time on the background
      (place-image (display-individual (first pop)) ;else you are going to use place image
                   (posn-x (individual-location-xy (first pop))) ;to place all the individuals
                   (posn-y (individual-location-xy (first pop))) ;using posn-x and posn-y
                   (display-population (rest pop) t s-pop) ;while also overlaying the time
                   )
      )
  )




; Purpose- A Function That Takes Time And Makes An Image
; Signature: Number->Image
; Examples:
(check-expect (time-display 0) (text (number->string 0) 30 "white"))
(check-expect (time-display 5) (text (number->string 5) 30 "white"))

;Code:
(define (time-display t) ;defining a function that is known as time-display
  (text (number->string t) 30 "white")) ;taking the time and turning into a displayable string

(define (sus-display n-of-s)
  (text (number->string n-of-s) 30 "blue"))






;Signature: list(population) number(time)
(define-struct world (population time susceptible)) ;defining a new struct in this case a new world that has poopulation and time
(define start-world (make-world population 0 0));starting the world with a population of 0




;Purpose: Make function for movement of population
;Signature: list->list
;Example:
(check-expect (move-population (list)) (list))
;(check-expect (move-population (list (make-individual
;                                    status-susceptible
;                                    (make-posn 200 300)
;                                    0)))
;              (list (make-individual
;                     status-susceptible
;                     (make-posn 201 301)
;                     0)))


;Code:
(define (move-population lst) ;doing what we did above for the individual but now for the whole population
  (transmit-population (map individual-movement lst))) ;we will now be using a list to handle the entire population as items in the list
             




;Purpose: Create a function that will display the world
;Signature: world->image
;Example:
(check-expect (display-world start-world) (display-population (world-population start-world) (world-time start-world) (world-susceptible start-world)))

;Code:
(define (display-world wrld) ;defining a function that will display the world
  (display-population (world-population wrld) (world-time wrld) (world-susceptible wrld) ;this function will grab the world population and the world time from the struct and then run that
                      )
  )





;Purpose: Creating a new world per tick
;Signature: world->world
;Example:
;(check-expect (tick-handler start-world) (make-world population 1))

;Code:
(define (tick-handler wrld) ;defining our tick handler to be used below with big bang
  (make-world (move-population (recovering-pop (world-population wrld)))
              (+ 1 (world-time wrld)) (- (length (world-population wrld))(length (filter no-susceptible? (world-population wrld)))))
  )





;Purpose: Create a brownian movement
;Signature: Posn -> Posn
;Examples:
(check-expect (posn? (random-direction (make-posn 1 1))) true)
;Code:
(define (random-direction ind-posn)
  (let
     ((random-number (random 5))) ; we are binding random-number to random of 5 to be used later in  the expression
   (cond
     ((= 0 random-number) (make-posn (posn-x ind-posn) (modulo (- (posn-y ind-posn) 1) background-size))) ; if 0 = our random number, then we make a new
      ; position for our individual.
     ((= 1 random-number) (make-posn (modulo (+ 1 (posn-x ind-posn)) background-size) (posn-y ind-posn)))
     ((= 2 random-number) (make-posn (posn-x ind-posn) (modulo (+ 1 (posn-y ind-posn)) background-size)))
     ((= 3 random-number) (make-posn (modulo (- (posn-x ind-posn) 1) background-size) (posn-y ind-posn)))
     (else ind-posn)   
     )
   )
  )

;Purpose: Make Function For Movement Of An Individual
;Signature: Individual->Individual
;Example:
;(check-expect (individual-movement (make-individual
                                   ; status-susceptible
                                   ; (make-posn 200 300)
                                   ;  0))
                                   ; (make-individual
                                   ;  status-susceptible
                                   ;  (make-posn 201 301)
                                   ;  0))
;Code:
(define (individual-movement indv) ;defining a for the movement of one individual
  (make-individual ;will be making this individual status of susceptible
   (individual-infection-status indv) ;then will be moving it by adding 1 to the posn-x and posn-y of individual
   (random-direction (individual-location-xy indv)) 
   (individual-infection-duration indv)))
                                    
;Purpose: update status to recover for idividuals that have been infected for 14 days
;signature: individual->individual
;Examples:
(check-expect (recovering (make-individual status-infected (make-posn 0 0) recovery-period))
              (make-individual status-recovered (make-posn 0 0) 0))
(check-expect (recovering (make-individual status-infected (make-posn 0 0) 13))
              (make-individual status-infected (make-posn 0 0) 14))
(check-expect (recovering (make-individual status-recovered (make-posn 0 0) 0))
              (make-individual status-recovered (make-posn 0 0) 0))

;code:
(define (recovering indv)
  (cond
    ((and
      (string=? (individual-infection-status indv) status-infected)
      (= (individual-infection-duration indv) recovery-period))
      (make-individual status-recovered
                      (make-posn (posn-x (individual-location-xy indv))
                                 (posn-y (individual-location-xy indv)))
                      0))
    ((and
      (string=? (individual-infection-status indv) status-infected)
      (< (individual-infection-duration indv) recovery-period))
      (make-individual status-infected
                             (make-posn (posn-x (individual-location-xy indv))
                                        (posn-y (individual-location-xy indv)))
                             (add1 (individual-infection-duration indv))))
    (else
     indv))) 

;Purpose: update the infection duration and infection status of the population
;Signature: list(population)-> list
;Examples:
(check-expect (recovering-pop (list)) (list))
(check-expect (recovering-pop (list (make-individual status-susceptible (make-posn 0 0) 0))) (list (make-individual status-susceptible (make-posn 0 0) 0)))
(check-expect (recovering-pop (list (make-individual status-infected (make-posn 0 0) 2))) (list (make-individual status-infected (make-posn 0 0) 3)))
(check-expect (recovering-pop (list (make-individual status-infected (make-posn 0 0) recovery-period))) (list (make-individual status-recovered (make-posn 0 0) 0)))

;Code:
(define (recovering-pop pop)
  (map recovering pop))     

; Purpose: Create a susceptible ind in a random location
; Signature: Number -> Individual
; Examples:
(check-expect (individual? (make-susceptible 3)) true)

; Code:
(define (make-susceptible dummy)
  (make-individual status-susceptible
                   (make-posn (random background-size)
                              (random background-size)) 0))

;Purpose: create a list of susceptable individuals in random locations 
;Signature: number->list
;Examples:
(check-expect (length (random-sus 3)) 3)
(check-expect (individual? (first (random-sus 3))) true)
(check-expect (individual-infection-status (first (random-sus 3))) status-susceptible)

;Code:
(define (random-sus n)
  (build-list n make-susceptible)
  )



(define world2 (make-world
               (append (list (make-individual status-infected
               (make-posn (random background-size)
               (random background-size)) 0))
               (random-sus 200)) 1 0))
  

; Purpose: Returns true if a person is infected
; Signature: Individual -> Boolean
; Examples:
(check-expect (infected? (make-individual status-infected (make-posn 0 0) 0)) true)
(check-expect (infected? (make-individual status-susceptible (make-posn 0 0) 0)) false)
(check-expect (infected? (make-individual status-recovered (make-posn 0 0) 0)) false)

; Code:
(define (infected? indv)
  (string=? status-infected (individual-infection-status indv)))

; Purpose: Return true if there are no more susceptible individuals
; Signature: Individual -> Boolean
; Examples:
(check-expect (no-susceptible? (make-individual status-recovered (make-posn (random background-size) (random background-size)) 0)) true)
(check-expect (no-susceptible? (make-individual status-infected (make-posn (random background-size) (random background-size)) 0)) true)
(check-expect (no-susceptible? (make-individual status-susceptible (make-posn (random background-size) (random background-size)) 0)) false)

; Code:

; Purpose: Return true if no more infections can take place
; Signature: World -> Boolean
; Examples:
(check-expect (last-infection? (make-world (random-sus 10) 0 10)) true)
(check-expect (last-infection? world2) false)
(check-expect (last-infection? (make-world (make-list 10 (make-individual status-recovered (make-posn (random background-size) (random background-size)) 0)) 0 0)) true)

;Code:
(define (last-infection? wrld)
 (or
  (empty? (filter infected? (world-population wrld)))
  (= (length (filter infected? (world-population wrld))) (length (world-population wrld)))
  (= (length (filter no-susceptible? (world-population wrld))) (length (world-population wrld)))
  )
  )



(big-bang world2
  (on-draw display-world)
  (on-tick tick-handler 1/24)
  (stop-when last-infection?))
             