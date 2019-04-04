asect 0
addsp 240
ldi r0, Strategy
ldi r1,0xC1
jsr pgcall
halt

Strategy:

push r1
push r2
push r3

ldi r1, 0xf9  # r1 = address of current cell
ldi r0, 0xff  # r1 = address of mancala

while
	cmp r0, r1  #check we are not on mancala
stays nz
	ld r1, r2   # r2 = number of seeds in r1
	ldi r3, 13
	   while        ## this cycle find remainder of the division
		cmp r2, r3  #
	   stays pl     #
		sub r3, r2  #
		not r2      #
	   wend         #
	add r1, r2   # r2 = address of end after move ( correct only if move and on bot's field)
	if 
		cmp r2, r0 # 
	is z           #
		move r1, r0#
		pop r3     #
		pop r2     # if our move stop on mancala this is right move
		pop r1     # and we stop subroutine
		br pgret   #
	fi             #
	inc r1
wend

 ## part 2

ldi r1, 0xf9
ldi r0, 0xff
while
	cmp r0, r1
stays nz
	ld r1, r2 #r2 = number of seeds in current sell
	if 
	tst r2 	## check there is no zero in current cell
	is nz
	ldi r3, 13
	if          #
	cmp r3, r2  # check we don't have a loops 
	is pl       #
	add r1, r2#r2 = address of destination cell
	if 
	cmp r0, r2 ## check we stop in our field
	is pl
		ld r2, r3 #r3 = number of seeds in destination cell
		if
		tst r3 ## check there is zero in cell
		is z
			push r1
			ldi r1, 0xf0 #
			sub r0, r2   # r3 = numlber of seeds in opposite cell
			add r1, r2   # r2 = address of opposite cell
			ld r2, r3    #
			if  ## check there is zero in destination sell
			tst r3
			is nz
			pop r0
			pop r3
			pop r2
			pop r1
			br pgret
		fi
		pop r1
		fi
		fi	
			
	fi
	fi
	inc r1
wend	


##part 3
#initialization and check for the first cell
ldi r0, 0
ldi r1, 0
ldi r2, 0
ldi r3, 0
ldi r0, 0xf9
ld r0, r1
ldi r2, 6
sub r2, r1
move r1, r3
	
while     #
cmp r1, r2#
stays z   #
dec r2    #find not empty cell
inc r0    #
ld r0, r1 #
sub r2, r1#
wend
move r1, r3
push r0
	#the loop checks whether all seeds remain on the computer's side
while
	tst r1 #if yes, this cell is chosen, the loop is over
stays lt
	
	if
		cmp r1, r3 #if no, we check which cell allows to keep the most of seeds
	is gt
		move r1, r3
		pop r1 	#update the adress if needed (stored on stack)
		push r0
	fi
	dec r2 
	if	#if it's the sixth cell, break the loop
			tst r2
		is z
			pop r0
			pop r3
			pop r2
			pop r1
			br pgret
		fi
	inc r0 #move to the next cell
	ld r0, r1
	sub r2, r1		
	while      #
	cmp r1, r2 #
	stays z    #
	if         #
	tst r2     #
	is z       #
	break      # move to fill cell
	fi         # where if condition check we didn't come on mancala
	dec r2     #
	inc r0     #
	ld r0, r1  #
	sub r2, r1 #
	wend       #
wend
if 
tst r2
is nz
pop r1
else 
pop r0
fi
pop r3
pop r2
pop r1
br pgret

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
