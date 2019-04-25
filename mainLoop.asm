asect 0
ldi r0,4
ldi r1,0
push r1
push r0
push r0
push r0
push r0
push r0
push r0
push r1

push r1
push r0
push r0
push r0
push r0
push r0
push r0
push r1

loop:
ldi r0,0xf0
plturn:
ld r0,r2
tst r2
bz plturn
ldi r3,0b11110000
or r3,r2

ldi r0,0
ldi r1,1 # mkmove
jsr pgcall
tst r0
bnz plturn

npcturn:
ldi r0,0
ldi r1,2 # Strategy call
jsr pgcall
move r0,r2
ldi r0,0
ldi r1,1 # mkmove
jsr pgcall
tst r0
bnz npcturn
br loop


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


