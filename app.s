	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

    .equ KEY_W, 0b00000010
    .equ KEY_A, 0b00000100
    .equ KEY_S, 0b00001000
    .equ KEY_D, 0b00010000
    .equ KEY_SPACE, 0b00100000

	.globl main

	FunctionCuadrado:

    add x14, x2, x15 // x14 = PosY + 
	mov x21 , SCREEN_HEIGH
    cmp x21, x14 
    b.lt parseX2_1
    cmp x2, 0
	b.lt parseX2_2
	b continue1

parseX2_1:
	mov x2, SCREEN_HEIGH
	sub x2, x2, x16
	b continue1

parseX2_2:
	mov x2, 0
	b continue1

continue1:
	mov x14, x2
loopY:
	mov x13, x1

loopX:
	mul x11, x14, x12
	add x11, x11, x13 // x11 = x +( y * 640)
	lsl x11, x11, 2 // x11 = 4* (x +( y * 640))
	add x11, x0, x11
	
	stur w10,[x11]
	add x13, x13, 1
	add x11, x1, x16 //ANCHO
	sub x11, x13, x11 // x13 = 0, 1, 2, ... , 199 
	cmp x11, 0 
	bge exitX
	b loopX
exitX:
	add x14, x14, 1
	add x11, x2, x15 //ALTO
	sub x11, x14, x11
	cmp x11, 0
	bge exit
	b loopY
exit:
	ret

FunctionFondo:
        mov x18, SCREEN_HEIGH         // Y Size
    loop1:
        mov x19, SCREEN_WIDTH         // X Size
    loop0:
        stur w10,[x0]  // Colorear el pixel N
        add x0,x0,4    // Siguiente pixel
        sub x19,x19,1    // Decrementar contador X
        cbnz x19,loop0  // Si no terminó la fila, salto
        sub x18,x18,1    // Decrementar contador Y
        cbnz x18,loop1  // Si no es la última fila, salto

        mov x0, x20 // Guarda la dirección base del framebuffer en x0
        mov x12, 640 //Salto de cada cordenada Y
    ret

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	// Ejemplo de uso de gpios
    
    // Atención: se utilizan registros w porque la documentación de broadcom
    // indica que los registros que estamos leyendo y escribiendo son de 32 bits

    // Setea gpios 0 - 9 como lectura
    

    //---------------------------------------------------------------
    // Infinite Loop
    mov x9, GPIO_BASE
    str wzr, [x9, GPIO_GPFSEL0]

    movz x10, 0x00, lsl 16
    movk x10, 0x1AFD, lsl 00
	bl FunctionFondo

    mov x2, 0
	mov x1, 200

InfLoop:
    movz x10, 0xFF, lsl 16
    movk x10, 0xFFFF, lsl 00
    mov x16, 50 //Ancho
    mov x15, 50 //Alto
    bl FunctionCuadrado

    ldr w10, [x9, GPIO_GPLEV0]
    and w11, w10, KEY_S
    cmp w11, KEY_S
    beq MoveDown

    ldr w10, [x9, GPIO_GPLEV0]
    and w11, w10, KEY_D
    cmp w11, KEY_D
    beq MoveRigth

	ldr w10, [x9, GPIO_GPLEV0]
    and w11, w10, KEY_W
    cmp w11, KEY_W
    beq MoveUp

	ldr w10, [x9, GPIO_GPLEV0]
    and w11, w10, KEY_A
    cmp w11, KEY_A
    beq MoveLeft

    b InfLoop

MoveDown:
    add x2, x2, 1
	movz x10, 0x00, lsl 16
    movk x10, 0x1AFD, lsl 00
    bl FunctionFondo
    b InfLoop

MoveRigth:
    add x1, x1, 1
	movz x10, 0x00, lsl 16
    movk x10, 0x1AFD, lsl 00
    bl FunctionFondo
    b InfLoop

MoveUp:
    sub x2, x2, 1
	movz x10, 0x00, lsl 16
    movk x10, 0x1AFD, lsl 00
	bl FunctionFondo
    b InfLoop

MoveLeft:
    sub x1, x1, 1
	movz x10, 0x00, lsl 16
    movk x10, 0x1AFD, lsl 00
	bl FunctionFondo
    b InfLoop


