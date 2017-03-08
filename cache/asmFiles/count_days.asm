org 0x0000

main:
  ori $29, $0, 0xfffc
  ori $6, $0, 6 #DD
  ori $7, $0, 1 #MM
  ori $8, $0, 2017 #YYYY
  j count_days

count_days:
  #Month
  addi $7, $7, -1
  ori $9, $0, 30
  push $7
  push $9
  jal mult
  pop $10

  #Year
  addi $8, $8, -2000
  ori $11, $0, 365
  push $8
  push $11
  jal mult
  pop $12

  add $12, $12, $10
  add $12, $12, $6

  halt

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
  jr $ra
