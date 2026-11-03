(module
  ;; MAIN.wasm - FLOP QUADRUPLE 4+16+64=84 on 8038 - KDP KL5UQ4f48673352
  (func $flop (export "flop") (param $event i32) (result i32)
    (if (result i32) (i32.eq (local.get $event) (i32.const 0))
      (then (i32.const 4)) ;; page_view
      (else
        (if (result i32) (i32.eq (local.get $event) (i32.const 1))
          (then (i32.const 16)) ;; fem_run
          (else (i32.const 64)) ;; ximg_view
        )
      )
    )
  )
  (func (export "quadruple") (result i32)
    i32.const 4
    i32.const 16
    i32.add
    i32.const 64
    i32.add
  )
)
