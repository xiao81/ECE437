org 0x0000

main:
  ori $29, $0, 0xfffc
  ori $6, $0, 3
  ori $7, $0, 2
  push $6
  push $7
  j mult

mult:
  pop $2 #base value
  pop $3 #count
  ori $4, $0, 0 #result
mult_loop:
  beq $3, $0, exit
  add $4, $4, $2
  addi $3, $3, -1
  j mult_loop
exit:
  push $4
  halt


  
