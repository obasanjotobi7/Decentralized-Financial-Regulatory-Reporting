;; Institution Verification Contract
;; Validates and registers financial entities

(define-data-var admin principal tx-sender)

;; Map of verified institutions
(define-map verified-institutions
  principal
  {
    name: (string-ascii 100),
    verified: bool,
    verification-date: uint
  }
)

;; Register a new institution
(define-public (register-institution (name (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (ok (map-set verified-institutions tx-sender
      {
        name: name,
        verified: false,
        verification-date: u0
      }
    ))
  )
)

;; Verify an institution
(define-public (verify-institution (institution principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (asserts! (is-some (map-get? verified-institutions institution)) (err u2))
    (ok (map-set verified-institutions institution
      (merge (unwrap-panic (map-get? verified-institutions institution))
        {
          verified: true,
          verification-date: block-height
        }
      )
    ))
  )
)

;; Check if an institution is verified
(define-read-only (is-verified (institution principal))
  (match (map-get? verified-institutions institution)
    institution-data (ok (get verified institution-data))
    (err u3)
  )
)

;; Get institution details
(define-read-only (get-institution-details (institution principal))
  (map-get? verified-institutions institution)
)
