asect 0
mkmove: #r2 = start cell
push r1
push r2
push r3
push r0 
ldi r0, 0
ld r2, r1 #save number of seeds in the cell in r2
st r2, r0 #make zero number of seeds in cell 
ldi r0, 0xf8

if 
cmp r2, r0  #
is mi       #
ldi r3, 0xff# check whose move
else        #
ldi r3, 0xf7#
fi			#

while
	tst r1
stays nz
	inc r2
	ldi r0, 0xf4
	if 
		cmp r2, r3 #check we are not on enemy's mancala
	is nz
		push r3	   #r3 = enemy's mancala
		ldi r3, 0xf8 #save number of empty cell
		if 
		cmp r2, r3   #check we are not in empty cell (nobody field)
		is z
		pop r3
		else
		pop r3    #r3 = enemy's mancala
		ld r2, r0 #r0 = number of seeds from r2
		inc r0    #increase number of seeds
		st r2, r0 #save new number
		dec r1
		fi
	else
		ldi r0, 0xff
		if            #
		cmp r2, r0    #
		is z		  #
		ldi r2, 0xf0  # find cell before player's(bot) first cell
		else 		  #
		inc r2		  #
		fi			  #
	fi
	ldi r0, 0xff
	if 
	cmp r0, r2
	is z
	ldi r2, 0xf0
	fi
wend

ldi r0, 0xff 

if            #there we find player's(bot) mancala
cmp r3, r0	  #
is z          #
ldi r1, 0xf7  #
else          #
ldi r1, 0xff  #
fi

if #check we stop in mancala
cmp r1, r2
is z 
pop r0
pop r3
pop r2
pop r1
ldi r0, 1
else
	ldi r1, 1
	ld r2, r0
	if 
		cmp r0, r1
		is z
		pop r0
		jsr movetomancala
	
	fi
	pop r3
	pop r3
	pop r2
	pop r1
	ldi r0, 0
	fi
br pgret

movetomancala:
xor r2, r0 #find whose mancala
not r0
ldi r1, 0b00001000

if 
and r1, r0 
is pl

	ldi r0, 0xf8 # r0 = player's mancala
	  if             #
	  cmp r0, r2	 #
	  is pl			 #
	  ldi r3, 0xf7	 # find mancala, r3 = mancala cell
	  else 			 #
	  ldi r3, 0xff	 #
	  fi			 #
	ldi r0, 0xff
	move r2, r1 #r1 = number of cell
	  sub r0, r1     #
	  ldi r0, 0xf0   # find oposite cell
	  add r0, r1     #
	ld r1,r0      # r1 = oposite cell's number, r0 = number of seeds
		if
		tst r0    #find opposite cell not empty
		is nz
		push r2   #r2 = start cell
		ld r3, r2 #r2 = number of seeds in mancala
		add r2, r0#r0 = r2 + number of seeds from start cell
		inc r0
		st r3, r0 #save new number of seeds in mancala
		ldi r0, 0
		pop r2    #take start cell
		st r2, r0 #save zero in start cell
		st r1, r0 #and in enemy's cell
		fi
fi	
rts
	
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
