asect  0x00

addsp 240

ldi r0, 0xf1
jsr mkmove

halt


mkmove:

push r1
push r2
push r3
push r0
ldi r3, 13##
move r0, r2
st r2, r3 ######
ldi r0, 0
ld r2, r1 #сохраняем колличество семян в ячейке
st r2, r0 #зануляем ячейку откуда взяли семяна
ldi r0, 0xf8

if 
cmp r2, r0
is mi
ldi r3, 0xff
else
ldi r3, 0xf7
fi

while
	tst r1
stays nz
	inc r2
	ldi r0, 0xf4
	if 
		cmp r2, r3#проверяем что мы не на манкале соперника
	is nz
		push r3
		ldi r3, 0xf8
		if 
		cmp r2, r3
		is z
		pop r3
		else
		pop r3
		ld r2, r0#сохраняем значение семян
		inc r0#увеличиваем колличество семян
		st r2, r0#сохраняем новое значение
		dec r1
		fi
		#inc r2
	else
		ldi r0, 0xff
		if 
		cmp r2, r0
		is z
		ldi r2, 0xf0#ячейка памяти перед нашей первой ямкой
		else 
		inc r2
		fi
	fi
	ldi r0, 0xff
	if 
	cmp r0, r2
	is z
	ldi r2, 0xf0
	fi
wend

ldi r0, 0xff
if 
cmp r3, r0
is z
ldi r1, 0xf7
else 
ldi r1, 0xff
fi

if
cmp r1, r2
is z #если остановились в манкале
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
	pop r2
	pop r1
	ldi r0, 0
	fi
rts

movetomancala:
xor r2, r0
not r0
ldi r1, 0b00001000

if
and r1, r0
is pl
	ldi r0, 0xf8
	if
	cmp r0, r2
	is pl
	ldi r3, 0xf7
	else 
	ldi r3, 0xff
	fi
	ldi r0, 0xff
	move r2, r1#в р2 - номер ячейки
	sub r0, r1
	ldi r0, 0xf0
	add r0, r1
	ld r1,r0#в р1 - номер ячейки напротив, р0 - колличество семян
		if
		tst r0
		is nz
		push r2
		ld r3, r2
		add r2, r0
		inc r0
		st r3, r0
		ldi r0, 0
		pop r2
		st r2, r0
		st r1, r0
		fi
fi	
rts

end
		
