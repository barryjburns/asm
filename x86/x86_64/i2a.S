	.global i2a
	.text

#	rdi = buffer
#	rsi = number to convert

i2a:
	cld

	test	%rsi, %rsi		# handle 0
	jz	.Lzero

	xor	%r9, %r9		# initialize return value
	mov	$10, %rcx		# base
	mov	$1, %rax

.Lloop1:
	cmp	%rsi, %rax
	jg	.Lscaled
	mul	%rcx
	jmp	.Lloop1

.Lscaled:
	xor	%rdx, %rdx
	div	%rcx
	mov	%rax, %r10		# r10 = divisor

	mov	%rsi, %rax

.Lloop2:
	xor	%rdx, %rdx
	div	%r10			# divide
	add	$'0', %al		# convert digit to ascii
	stosb				# store digit

	inc	%r9			# update digit count

	mov	%rdx, %r11		# r11 = current value

	cmp	$1, %r10		# if divisor = 1, this is the last digit
	jz	.Lexit

	mov	%r10, %rax		# scale down divisor
	xor	%rdx, %rdx
	div	%rcx
	mov	%rax, %r10

	mov	%r11, %rax		# get ready to do it again
	jmp	.Lloop2

.Lzero:	mov	$'0', %al
	stosb
	mov	$1, %r9
.Lexit:	xor	%rax, %rax
	stosb
	mov	%r9, %rax
	ret


