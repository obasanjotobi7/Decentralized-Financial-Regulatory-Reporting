;; Requirement Tracking Contract
;; Records reporting obligations

(define-data-var admin principal tx-sender)

;; Map of reporting requirements
(define-map reporting-requirements
  uint
  {
    name: (string-ascii 100),
    description: (string-ascii 255),
    deadline: uint,
    active: bool
  }
)

;; Counter for requirement IDs
(define-data-var requirement-id-counter uint u0)

;; Add a new reporting requirement
(define-public (add-requirement
                (name (string-ascii 100))
                (description (string-ascii 255))
                (deadline uint))
  (let ((new-id (+ (var-get requirement-id-counter) u1)))
    (begin
      (asserts! (is-eq tx-sender (var-get admin)) (err u1))
      (var-set requirement-id-counter new-id)
      (ok (map-set reporting-requirements new-id
        {
          name: name,
          description: description,
          deadline: deadline,
          active: true
        }
      ))
    )
  )
)

;; Deactivate a requirement
(define-public (deactivate-requirement (requirement-id uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (asserts! (is-some (map-get? reporting-requirements requirement-id)) (err u2))
    (ok (map-set reporting-requirements requirement-id
      (merge (unwrap-panic (map-get? reporting-requirements requirement-id))
        { active: false }
      )
    ))
  )
)

;; Get requirement details
(define-read-only (get-requirement (requirement-id uint))
  (map-get? reporting-requirements requirement-id)
)

;; Check if a requirement is active
(define-read-only (is-requirement-active (requirement-id uint))
  (match (map-get? reporting-requirements requirement-id)
    requirement-data (ok (get active requirement-data))
    (err u3)
  )
)
