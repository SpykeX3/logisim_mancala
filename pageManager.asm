#asect 0
#ldi r0,func
#ldi r1,0xC1
#ldi r2,3
#ldi r3,4
#jsr pgcall
#halt
#func:
#add r0,r1
#sub r2, r3
#br pgret

asect 229 # 256-len
pgcall:# PC = r0, page number = r1
push r2 # save r2,r3
push r3
ldi r2, 0
ld r2, r3 # r3 = caller page number
st r2, r1 # 
move r3,r1
pop r3 # restore r3,r2
pop r2
push r1 # push caller page number
push r0 # PC = r0
rts
pgret:
push r1
push r2
addsp 2
pop r1
addsp -3
ldi r2, 0
st r2, r1
pop r2
pop r1
addsp 1
rts
end


