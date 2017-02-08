org 0x0000

main:
  ori $29, $0, 0xfffc
  ori $6, $0, 3
  ori $7, $0, 2
  ori $8, $0, 3
  ori $10, $0, 1
  push $6
  push $7
  push $8
  push $10
  j mult_procedure

mult_procedure:
  ori $9, $0, 0xfff8
  beq $29, $9, exit
  j mult

mult:
  pop $2 #base value
  pop $3 #count
  ori $4, $0, 0 #result

mult_loop:
  beq $3, $0, return
  add $4, $4, $2
  addi $3, $3, -1
  j mult_loop

return:
  push $4
  j mult_procedure

exit:
  halt
