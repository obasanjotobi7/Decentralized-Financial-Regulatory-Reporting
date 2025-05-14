;; Submission Verification Contract
;; Records timely filing

(define-data-var admin principal tx-sender)

;; Map of verified submissions
(define-map verified-submissions
  { report-id: uint }
  {
    verified: bool,
    verification-time: uint,
    verifier: principal,
    on-time: bool
  }
)

;; Verify a submission
(define-public (verify-submission
                (report-id uint)
                (on-time bool))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (ok (map-set verified-submissions
      { report-id: report-id }
      {
        verified: true,
        verification-time: block-height,
        verifier: tx-sender,
        on-time: on-time
      }
    ))
  )
)

;; Check if a submission is verified
(define-read-only (is-submission-verified (report-id uint))
  (match (map-get? verified-submissions { report-id: report-id })
    submission-data (ok (get verified submission-data))
    (err u2)
  )
)

;; Get submission verification details
(define-read-only (get-verification-details (report-id uint))
  (map-get? verified-submissions { report-id: report-id })
)
