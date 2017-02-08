org 0x0000
main:
  ori $29, $0, 0xfffc
  ori $2, $0, 5
  push $2
  j fib

fib:
  pop $3 #input
  beq $0, $3, return
  ori $4, $0, 1
  beq $4, $3, return
  push $3
  j fib_cont

fib_cont:
  addi $5, $3, -1
  push $5
  jal fib
  addi $6, $3, -2
  push $6
  jal fib
  pop $7
  pop $8
  add $27, $7, $8
  push $27
  j fib

return:
  push $3
  halt
  
exit:
  halt
