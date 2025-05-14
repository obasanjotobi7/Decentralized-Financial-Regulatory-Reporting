;; Report Generation Contract
;; Creates standardized documents

(define-data-var admin principal tx-sender)

;; Map of generated reports
(define-map reports
  uint
  {
    institution: principal,
    requirement-id: uint,
    report-hash: (buff 32),
    generation-time: uint
  }
)

;; Counter for report IDs
(define-data-var report-id-counter uint u0)

;; Generate a report
(define-public (generate-report
                (institution principal)
                (requirement-id uint)
                (report-hash (buff 32)))
  (let ((new-id (+ (var-get report-id-counter) u1)))
    (begin
      (asserts! (is-eq tx-sender (var-get admin)) (err u1))
      (var-set report-id-counter new-id)
      (ok (map-set reports new-id
        {
          institution: institution,
          requirement-id: requirement-id,
          report-hash: report-hash,
          generation-time: block-height
        }
      ))
    )
  )
)

;; Get report details
(define-read-only (get-report (report-id uint))
  (map-get? reports report-id)
)

;; Get latest report ID
(define-read-only (get-latest-report-id)
  (var-get report-id-counter)
)
