asect 0
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
	   while        ## this cycle finds remainder of the division
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
	ld r1, r2 #r2 = number of seeds in current cell
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
			if  ## check there is zero in destination cell
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
##initialization for the loop
ldi r0, 0xf9
ldi r2, 6
ldi r3, -50
push r0

while
 	tst r2 ##while we are not on the mancala
stays nz
	ld r0, r1
	if
		tst r1 ##check for an empty (zero) cell 
	is z
		inc r0
		dec r2
		continue
	fi
	sub r2, r1
	if 
		tst r1 ##if all seeds will remain on the computer's side, break the loop
	is z
		pop r1 ##we don't need the adress from stack anymore, so we just clear it somewhere
		pop r3
		pop r2
		pop r1
		br pgret
	fi
	if 
		cmp r1, r3 ##if the current move let more seeds remain on the computer's side, update the adress (stored on stack) 
	is gt
		move r1, r3
		pop r1
		push r0
	fi
	inc r0
	dec r2
wend
pop r0	## if the full loop was executed, take the adress to r0 from stack
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
