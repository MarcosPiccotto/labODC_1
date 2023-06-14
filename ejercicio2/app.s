	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGHT,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

    .equ FONDO_1,   0xfd 
    .equ FONDO_2,   0x663c

    .equ COLORPJ_1,   0xaa 
    .equ COLORPJ_2,   0xffd6

    .equ KEY_W, 0b00000010
    .equ KEY_A, 0b00000100
    .equ KEY_S, 0b00001000
    .equ KEY_D, 0b00010000
    .equ KEY_SPACE, 0b00100000

	.globl main

//---------------------------CUADRADO------------------//
FunctionCuadrado:
    add x14, x2, x15 // x14 = PosY + Alto
	mov x21 , SCREEN_HEIGHT
    cmp x21, x14 
    b.lt parseX2_1
    cmp x2, 0
	b.lt parseX2_2
	b continue1

parseX2_1:
	mov x2, SCREEN_HEIGHT
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

//-------------------------------triangulos------------//
FunctionTrianguloV:
    mov x14, x24
loopYTV:
    mov x13, x23
loopXTV:
    mul x11, x14, x12
    add x11, x11, x13 // x11 = x +( y * 640)
    lsl x11, x11, 2 // x11 = 4* (x +( y * 640))
    add x11, x0, x11

    stur w10,[x11]
    add x13, x13, 1
    add x11, x23, x26 //ANCHO
    sub x11, x13, x11 // x13 = 0, 1, 2, ... 
    cmp x11, 0 
    bge exitXTV
    b loopXTV
exitXTV:
    add x14, x14, 1
    add x23, x23, 1
    sub x26, x26, 2
    add x11, x24, x27 //ALTO
    sub x11, x14, x11
    cmp x11, 0
    bge exitTV
    b loopYTV
exitTV:
    ret

FunctionTrianguloA:
    mov x14, x24
loopYTA:
    mov x13, x23
loopXTA:
    mul x11, x14, x12
    add x11, x11, x13 // x11 = x +( y * 640)
    lsl x11, x11, 2 // x11 = 4* (x +( y * 640))
    add x11, x0, x11

    stur w10,[x11]
    add x13, x13, 1
    add x11, x23, x26 //ANCHO
    sub x11, x13, x11 // x13 = 0, 1, 2, ... 
    cmp x11, 0 
    bge exitXTA
    b loopXTA
exitXTA:
    add x14, x14, 1
    sub x23, x23, 1
    add x26, x26, 2
    add x11, x24, x27 //ALTO
    sub x11, x14, x11
    cmp x11, 0
    bge exitTA
    b loopYTA
exitTA:
    ret
//---------------------------Fondo------------------//
FunctionFondo:
        mov x18, SCREEN_HEIGHT         // Y Size
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
//---------------------------Main------------------//
main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20

    // Configuracion GPIO
    mov x9, GPIO_BASE
    str wzr, [x9, GPIO_GPFSEL0]

    // Fondo
    movz x10, FONDO_1, lsl 16
    movk x10, FONDO_2, lsl 00
	bl FunctionFondo

    

    mov x25, 0
    // PosX, y PoxY Iniciales
    mov x2, 100
	mov x1, 200

    movz x10, COLORPJ_1, lsl 16
    movk x10, COLORPJ_2, lsl 00
    mov x16, 50 //Ancho
    mov x15, 50 //Alto
    bl FunctionCuadrado

//---------------------------Loop------------------//
InfLoop:
    

    //--------deteccion de movimiento--------//
    
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

    //---------------Lentes----------//
    //x25=flag
    ldr w10, [x9, GPIO_GPLEV0]
    and w11, w10, KEY_SPACE
    cmp w11, KEY_SPACE
    beq ActivateGlasses

    cmp x25, 1
    beq PutGlasses    
    
    b InfLoop
//---------------------------W-A-S-D-Barra Espaciadora-----------------//
MoveDown:
    add x2, x2, 1
	movz x10, FONDO_1, lsl 16
    movk x10, FONDO_2, lsl 00
    bl FunctionFondo

    movz x10, COLORPJ_1, lsl 16
    movk x10, COLORPJ_2, lsl 00
    mov x16, 50 //Ancho
    mov x15, 50 //Alto
    bl FunctionCuadrado
    b InfLoop

MoveRigth:
    add x1, x1, 1
	movz x10, FONDO_1, lsl 16
    movk x10, FONDO_2, lsl 00
    bl FunctionFondo

    movz x10, COLORPJ_1, lsl 16
    movk x10, COLORPJ_2, lsl 00
    mov x16, 50 //Ancho
    mov x15, 50 //Alto
    bl FunctionCuadrado
    b InfLoop

MoveUp:
    sub x2, x2, 1
	movz x10, FONDO_1, lsl 16
    movk x10, FONDO_2, lsl 00
	bl FunctionFondo

    movz x10, COLORPJ_1, lsl 16
    movk x10, COLORPJ_2, lsl 00
    mov x16, 50 //Ancho
    mov x15, 50 //Alto
    bl FunctionCuadrado
    b InfLoop

MoveLeft:
    sub x1, x1, 1
	movz x10, FONDO_1, lsl 16
    movk x10, FONDO_2, lsl 00
	bl FunctionFondo

    movz x10, COLORPJ_1, lsl 16
    movk x10, COLORPJ_2, lsl 00
    mov x16, 50 //Ancho
    mov x15, 50 //Alto
    bl FunctionCuadrado
    b InfLoop

ActivateGlasses:
    
    mov x26, 1
    eor x25, x25, x26 // Realiza una operación XOR exclusiva con x26 (1)
    b InfLoop

PutGlasses:
    // x23 = x, x24 = y,
    mov x23, x1 
    sub x23, x23, 5
    mov x24, x2
    add x24, x24, 10
    mov x26, 45
    mov x27, 23
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl FunctionTrianguloV

    mov x23, x1 
    add x23, x23, 12
    mov x24, x2
    add x24, x24, 10
    mov x26, 45
    mov x27, 23
    movz x10, 0x01, lsl 16
    movk x10, 0x0101, lsl 00
    bl FunctionTrianguloV

    mov x23, x1 
    add x23, x23, 2
    mov x24, x2
    sub x24, x24, 16
    mov x26, 45
    mov x27, 23  
    movz x10, 0xca, lsl 16
    movk x10, 0xb2bd, lsl 00
    bl FunctionTrianguloA

    b InfLoop

