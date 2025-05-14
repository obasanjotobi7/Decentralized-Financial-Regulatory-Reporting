;; Data Collection Contract
;; Gathers required information

(define-data-var admin principal tx-sender)

;; Map of submitted data
(define-map financial-data
  { institution: principal, requirement-id: uint }
  {
    data-hash: (buff 32),
    submission-time: uint,
    status: (string-ascii 20)
  }
)

;; Submit financial data
(define-public (submit-data
                (requirement-id uint)
                (data-hash (buff 32)))
  (begin
    (ok (map-set financial-data
      { institution: tx-sender, requirement-id: requirement-id }
      {
        data-hash: data-hash,
        submission-time: block-height,
        status: "submitted"
      }
    ))
  )
)

;; Update data status
(define-public (update-data-status
                (institution principal)
                (requirement-id uint)
                (status (string-ascii 20)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (asserts! (is-some (map-get? financial-data { institution: institution, requirement-id: requirement-id })) (err u2))
    (ok (map-set financial-data
      { institution: institution, requirement-id: requirement-id }
      (merge (unwrap-panic (map-get? financial-data { institution: institution, requirement-id: requirement-id }))
        { status: status }
      )
    ))
  )
)

;; Get submitted data
(define-read-only (get-submitted-data (institution principal) (requirement-id uint))
  (map-get? financial-data { institution: institution, requirement-id: requirement-id })
)
