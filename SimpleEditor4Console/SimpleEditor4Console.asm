TITLE	12080912 FINAL
	.MODEL	SMALL
	.STACK	64
	.DATA
NEW_FILE_TITLE	DB	' UNTITLED TEXT FILE '	;������ ���� �ؽ�Ʈ
FILE_TITLE	DB	22 DUP (' ')		;���� ���� �ؽ�Ʈ 
FRAME		DB	0C9H, 2 DUP ( 0CDH ), ' EDITOR : ', 66 DUP ( 0CDH ), 0BBH ;������ Ʋ
		DB	22 DUP( 0BAH, 78 DUP (' '), 0BAH ) 
MENU_STR	DB	' ', 0AFH,' Press F1-Menu', 46 DUP(' '),'|ROW:    COL:      ' 
HELP_MENU_STR	DB	?	;���� �ؽ�Ʈ
COUNT_ROW	DB	?
ROW		DB	1	;���� ��
COL		DB	1	;���� ��
LEFT_LIM	EQU	1	;���� �Ѱ�
RIGHT_LIM	EQU	4EH	;������ �Ѱ�
TOP_LIM		EQU	1	;���� �Ѱ�
BTM_LIM		EQU	22	;�Ʒ��� �Ѱ�
ROWLEN		DB	78	;������ ĭ ����
ESC_CHK		DB	0	;ESC�� ���ȴ��� üũ�ϴ� ����
TEXT_AREA	DB	1800 DUP (' '), 0DH, 0AH ; �ؽ�Ʈ ���念��
CALROW		DB	2 DUP (' ')
CALCOL		DB	2 DUP (' ')
;------------------------------------------------
MTOPROW		EQU	08	;�޴������� ���� 
MBOTROW		EQU	14	;�޴������� �Ʒ���
MLEFCOL		EQU	30	;ȭ�鳡���� ������ ĭ��
MATTRIB		DB	?	;�޴� �Ӽ��� ���� ����
MROW		DB	00	;�޴����� ����� ��
MESC_CHK	DB	0
SHADOW	DB	19 DUP (0B1H )	;�޴��� �׸���
MENU		DB	0C9H, 17 DUP ( 0CDH ), 0BBH	;�޴�	
		DB	0BAH, '    Continue     ', 0BAH
		DB	0BAH, '    New  file    ', 0BAH
		DB	0BAH, '    Save file    ', 0BAH
		DB	0BAH, '    Load file    ', 0BAH
		DB	0BAH, '   Exit editor   ', 0BAH
		DB	0C8H, 17 DUP ( 0CDH ), 0BCH
;--------------------------------------------------
SAVEMESS	DB	'Save the data in   C:\','$'	;���̺� �ÿ� ��µ� �޽���
LOADMESS	DB	'Load the data from C:\','$'	;�ε� �ÿ� ��µ� �޽���
FILEMESS	DB	'Enter the file name for Save/Load','$'	;���̺�,�ε�� �����̸� �Է¾ȳ� �޽���
ENDMESS		DB	'<Press any key> Program exiting now...'	;���α׷� ����� ��µ� �޽���
PRESS		DB	'<Press any key>','$'			;Ű �Է� �޽���
ERRORMESS	DB	'File iperation error! ','$'		;���� ������ ������ �߻��� �� 
FILEPATH	DB	'C:\'
INPUTPATH	DB	23 DUP(' '), 00H			;�ƽ�Ű���� ��Ʈ��
FILEHAND	DW	?					;�����ڵ� ���庯��
PARLIST		LABEL	BYTE
MAX_LEN		DB	20
ACT_LEN		DB	?
KB_DATA		DB	21 DUP(' ')
.386 ;-------------------------------------------
	.CODE
A10MAIN	PROC	FAR
	MOV	AX,@DATA
	MOV	DS,AX
	MOV	ES,AX
			
	MOV	AH,00H	;���� ��� ����
	MOV	AL,03H
	INT	10H
			
	MOV	AH,05H	;Ȱ�� ������ ����
	MOV	AL,00H
	INT	10H
A20:
	CALL	B10ALLCLEAR	;��ü ���÷��� �ʱ�ȭ
	CALL	D10FRAME	;������ Ʋ ���(����,����Ű ���� ����)
	
A30:	
	MOV	DH,ROW		;Ŀ�� ����
	MOV	DL,COL
	CALL	E10CURSOR	
	
	CALL	G10KEYBRD	;�Է¹ޱ�
				;�Է¹����� �޸𸮿� �ְ�
				;�޸��� ���� ���
	CALL	I10DISCHR

	CMP	ESC_CHK,1	;ESC�� ���ȴ��� Ȯ���Ѵ�(������ ����)
	JE	A90		
	JMP	A30		
	MOV	AH,10H
	INT	16H
A90:				
	MOV	AX,1301H
	MOV	BH,00
	MOV	BL,0F4H
	LEA	BP,ENDMESS
	MOV	CX,38
	MOV	DX,0A14H
	INT	10H
				;���� �޽����� �����
	MOV	AH,10H		;�ƹ�Ű�� ������ ��ũ���� ����
	INT	16H		
	CALL	B10ALLCLEAR
	MOV	AX, 4C00H
	INT	21H
A10MAIN	ENDP
;------------------------------------------------
B10ALLCLEAR	PROC	NEAR
			;���ν����� ȣ���ϸ� ȭ�� ��ü�� ��ũ��
			;ȭ����ü�� ��ũ��(�ؽ�Ʈ ���� �۱���)
	PUSHA
	MOV	AX,0600H
	MOV	BH,4FH
	MOV	CX,0000H
	MOV	DX,184FH
	INT	10H
	POPA
	RET
B10ALLCLEAR	ENDP
;------------------------------------------------
C10CLEAR	PROC	NEAR
;AL�� �����ϸ� ȣ���ϸ� AL����ŭ ȭ�� ��ũ��
;�ؽ�Ʈ �����ȿ����� ��ũ��
	PUSHA
	MOV	AH,06H
	MOV	BH,4FH
	MOV	CX,0101H
	MOV	DX,174EH
	INT	10H
	POPA
	RET
C10CLEAR	ENDP
;------------------------------------------------
D10FRAME	PROC	NEAR
;�������� ��üƲ�� ���
;Ŀ�� ����
	PUSHA
	MOV	DX,0000		
	CALL	E10CURSOR
	
			;�������� �ٱ��� Ʋ�� ���
	MOV	AX,1301H
	MOV	BL,4FH
	LEA	BP,FRAME
	MOV	CX,1920
	MOV	DX,0000H
	INT	10H
			;���ٸ޴�����Ű ���
	MOV	AX,1301H
	MOV	BL,0F4H
	LEA	BP,MENU_STR
	MOV	CX,80
	MOV	DX,1700H
	INT	10H
			;���� ����(Ÿ��Ʋ) ���
	MOV	AX,1301H
	MOV	BL,0F4H
	LEA	BP,NEW_FILE_TITLE
	MOV	CX,20
	MOV	DX,000CH
	INT	10H

	POPA
	RET
D10FRAME	ENDP
;------------------------------------------------
E10CURSOR	PROC	NEAR
;DX�� �����ϰ� ȣ���ϸ� Ŀ���� ��ġ�� ����
	PUSHA
	MOV	AH,02
	MOV	BH,00
	INT	10H
	POPA
	RET
E10CURSOR	ENDP
;------------------------------------------------
F10INPUTCHR	PROC	NEAR
;�ؽ�Ʈ������ ǥ���� �����ͼ��׸�Ʈ TEXT_AREA�� ������ �� �Է�
	PUSHA
	PUSH	AX		;���ϱ⿡�� AX�� ����ϹǷ� ���
	MOV	AX,0000		;AX �ʱ�ȭ
	MOVZX	AX,ROW		;AX = (ROW-1)*78
	DEC	AX
	IMUL	ROWLEN
	MOVZX	BX,COL		;AX = AX + (COL-1)
	ADD	AX,BX
	DEC	AX
	MOV	CX,AX
	
	POP	AX		;����س��� AX�� ����
	LEA	DI,TEXT_AREA	;STOSB�� ���ؼ� TEXT_AREA�� ����
	ADD	DI,CX
	CLD
	STOSB
				;COL���� ����ؼ� COL�� 79������ ���ǰ�
				;79�� �Ѿ�� ROW�� �������� ���� ��Ÿ�����Ѵ�.
	CMP	COL,RIGHT_LIM	;������ ������ �˻��ؼ� ���������̸� ����������
	JB	F10
	CMP	ROW,BTM_LIM	;��������, ������������ ���ڸ��� ���߱����ؼ� �˻�
	JE	F90		;(�������� �ٷθ���)
	INC	ROW
	MOV	COL,01
	JMP	F90	
F10:
	INC	COL
F90:
	POPA
	RET
F10INPUTCHR	ENDP
;------------------------------------------------
G10KEYBRD	PROC	NEAR
;Ű����κ��� �Է����޾Ƶ鿩�� �׿� �´� ����� �����ϴ�
;���ν����� ȣ���Ѵ�
	PUSHA
	MOV	AH,10H	
	INT	16H	;�Է��� �޾Ƶ��δ�
	CMP	AL,00H	;�޾Ƶ��� ���ڰ� ���ĺ����� �˻��ϴ� ����
	JE	G20
	CMP	AL,0E0H
	JE	G20
	CMP	AL,0DH
	JE	G20
	CMP	AL,08H
	JE	G40
	CMP	AL,1BH
	JE	G70
	CALL	F10INPUTCHR	;���ĺ��϶��� �ؽ�Ʈ������ ���ڻ���
	JMP	G90
G20:			;������ ȭ��ǥ
	CMP	AH,4DH
	JNE	G30
	CALL	H10RTARRW
	JMP	G90
G30:			;���� ȭ��ǥ
	CMP	AH,4BH
	JNE	G33
	CALL	H20LFARRW
	JMP	G90
G33:			;�Ʒ��� ȭ��ǥ
	CMP	AH,50H
	JNE	G36
	CALL	H40DWNARRW
	JMP	G90
G36:			;���� ȭ��ǥ
	CMP	AH,48H
	JNE	G39
	CALL	H30UPARRW
	JMP	G90
G39:			;����
	CMP	AH,1CH
	JNE	G40
	CALL	H80ENTER
	JMP	G90
G40:			;�齺���̽�
	CMP	AH,0EH
	JNE	G45	
	CALL	H90BACKSP
	JMP	G90
G45:			;����Ʈ	
	CMP	AH,53H
	JNE	G50
	CALL	H70DELETE
	JMP	G90
G50:			;Ȩ
	CMP	AH,47H
	JNE	G60
	CALL	H100HOME
	JMP	G90
G60:			;����
	CMP	AH,4FH
	JNE	G65
	CALL	H110END
	MOV	ROW,24
	JMP	G90
G65:			;F1-�޴�
	CMP	AH,3BH
	JNE	G70
	CALL	CAMENU
	JMP	G90
G70:			;ESC-����
	CMP	AH,01H
	JNE	G90
	MOV	ESC_CHK,1
G90:	
	POPA
	RET
G10KEYBRD	ENDP
;------------------------------------------------
H10RTARRW	PROC	NEAR
;������ ȭ��ǥ�� ���� ������ ������
	PUSHA
	CMP	COL, RIGHT_LIM	;������ ���ΰ��� ���� �˻�
	JAE	H11	;���̸� �Ʒ��� ùĭ���� Ŀ���̵�
	INC	COL		
	JMP	H19
H11:	
	CMP	ROW,BTM_LIM	;�Ǹ��������� ����ó��
	JE	H19		;�ٷ� ����
	CALL	H40DWNARRW
	CALL	H50FLINE
H19:	
	POPA
	RET
H10RTARRW	ENDP
;------------------------------------------------
H20LFARRW	PROC	NEAR
;���� ȭ��ǥ�� ���� ������ ������
	PUSHA
	CMP	COL, LEFT_LIM ;���� ���ΰ��� ���� �˻�
	JBE	H21	;���̸� ���� ������ĭ���� Ŀ���̵�
	DEC	COL
	JMP	H29
H21:	
	CMP	ROW,TOP_LIM	;�����ٿ��� ����ó��
	JE	H29		;�ٷ� ����
	CALL	H30UPARRW
	CALL	H60ELINE
H29:
	POPA
	RET
H20LFARRW	ENDP
;------------------------------------------------
H30UPARRW	PROC	NEAR
;���� ȭ��ǥ�� ���� ������ ������
	CMP	ROW, TOP_LIM
	JE	H39
H31:
	DEC	ROW
H39:
	RET
H30UPARRW	ENDP
;------------------------------------------------
H40DWNARRW	PROC	NEAR
;�Ʒ��� ȭ��ǥ�� ���� ������ ������
	CMP	ROW, BTM_LIM
	JE	H49
H41:
	INC	ROW
H49:
	RET
H40DWNARRW	ENDP
;------------------------------------------------
H50FLINE	PROC	NEAR

;���� �Ǿ����� Ŀ�� �̵�
	MOV	COL, LEFT_LIM
	CALL	E10CURSOR
	RET
H50FLINE	ENDP
;------------------------------------------------
H60ELINE	PROC	NEAR
;���� �ǵڷ� Ŀ�� �̵�
	MOV	COL, RIGHT_LIM
	CALL	E10CURSOR
	RET
H60ELINE	ENDP
;------------------------------------------------
H70DELETE	PROC	NEAR
;Ŀ�� �ڿ� �ִ� �ѹ��ڸ� ����� ���
	PUSHA
	MOV	AX,0000		;AX �ʱ�ȭ
	MOVZX	AX,ROW		;AX = (ROW-1)*78
	DEC	AX
	IMUL	AX,78

	MOVZX	BX,COL		;AX = AX + (COL-1)
	ADD	AX,BX
	DEC	AX
	MOV	BX,AX
	MOV	CX,1794
	SUB	CX,AX

	LEA	DI, [TEXT_AREA+BX]	;�ѹ��ھ� �ݺ��ؼ� �����
	LEA	SI, [TEXT_AREA+BX+1]
	REP	MOVSB
	POPA
	RET
H70DELETE	ENDP
;------------------------------------------------
H80ENTER	PROC	NEAR
;�������� ���ͱ��
	PUSHA
	CMP	ROW,BTM_LIM	;�������ٿ��� �Ѿ���ʰ� ����ó��
	JE	H89		;���������̸� �Ѿ��
	MOV	COL,1
	INC	ROW
H89:
	POPA
	RET
H80ENTER	ENDP
;------------------------------------------------
H90BACKSP	PROC	NEAR
;�齺���̽��� ���
;�齺���̽��� COL�� ���ҽ�Ű�� ����Ʈ�� ȣ���ϹǷν� ����
	CMP	ROW,TOP_LIM	;�� ù�̰�
	JNE	H91	
	CMP	COL,LEFT_LIM	;�� ùĭ�̸� ����ó��
	JE	H99
H91:	
	JE	H99
	CALL	H20LFARRW
	CALL	H70DELETE	;����Ʈ ȣ��
H99:
	RET
H90BACKSP	ENDP
;------------------------------------------------
H100HOME	PROC	NEAR\
;ȨŰ�� ����� �Ѵ�
;�ؽ�Ʈ������ ù��,ùĭ���� Ŀ�� �̵�
	MOV	ROW,1
	MOV	COL,1
	RET
H100HOME	ENDP
;------------------------------------------------
H110END	PROC	NEAR
;����Ű�� ����� �Ѵ�.
;�ؽ�Ʈ������ ��������,���������� Ŀ�� �̵�
	MOV	ROW,22
	MOV	COL,77
	RET
H110END	ENDP
;------------------------------------------------
I10DISCHR	PROC	NEAR
;TEXT_AREA�� �ִ� ��� ���ڸ� ����Ѵ�.
;���Ҿ� �ϴ��� �޴�����Ű ���� ROW,COL�� ����Ѵ�.
	PUSHA
	MOV	DX,0101H
	CALL	E10CURSOR
			;ù��°�� ���
	MOV	AX,1301H
	MOV	BL,4FH
	LEA	BP,TEXT_AREA
	MOV	CX,78
	MOV	DX,0101H
	PUSHA
	INT	10H
	POPA
	MOV	COUNT_ROW,21
			;�ι�° �ٺ��ʹ�
			;������ ���� �ݺ��ؼ� ���� ���, ���
I20:	
	ADD	BP,78
	ADD	DX,0100H
	PUSHA
	INT	10H
	POPA
	CMP	COUNT_ROW,0
	DEC	COUNT_ROW
	JNE	I20

	CALL	J10ROWCOL

	POPA
	RET
I10DISCHR	ENDP
;------------------------------------------------
J10ROWCOL	PROC	NEAR
	PUSHA
	MOV	AL,ROW		;ROW ����� ���� AL�� ROW�� ����
	MOV	CL,0	
	CMP	AL,0AH		;ROW > 10�ΰ� �˻�
	JB	J20
J15:			
	SUB	AL,0AH		;ROW�� 10�̻��϶�
	INC	CL		;AL�� 10�� ����(AL�� 1�ڸ��� ��Ÿ��)
	CMP	AL,0AH		;CL�� ���� (CL�� 2�ڸ��� ��Ÿ��)
	JAE	J15
J20:	
	ADD	AL,30H	
	MOV	CALROW+1,AL	;CALROW+1�� 1�ڸ���
	ADD	CL,30H		;CALROW�� 2�ڸ���
	MOV	CALROW,CL
	
	MOV	AL,COL		;COL ����� ���� AL�� ROW����
	MOV	CL,0		;������� ROW�� ����
	CMP	AL,0AH
	JB	J30
J25:
	SUB	AL,0AH
	INC	CL
	CMP	AL,0AH
	JAE	J25
J30:
	ADD	AL,30H
	MOV	CALCOL+1,AL
	ADD	CL,30H
	MOV	CALCOL,CL

	MOV	AX,1301H	;CALROW,CALCOL ���
	MOV	BX,00F4H
	LEA	BP,CALROW
	MOV	CX,2
	MOV	DH,23
	MOV	DL,68
	PUSHA			;�������ͼ����� ��Ȱ���ϱ�����
	INT	10H		;PUSHA,POPA
	POPA			
	LEA	BP,CALCOL	;BP�� COL�ּ� �Է�
	MOV	DL,76
	INT	10H		;COL�� ���

	POPA
	RET
J10ROWCOL	ENDP
;-------------------------------------------------
CAMENU		PROC	NEAR
		PUSHA
CA20:		CALL	M10MENU		;�޴�ȭ���� ȭ�鿡 ����ϴ� ���ν��� ȣ��
		MOV	MROW, MTOPROW+1	;�޴��� ó�� �׸��� ����Ű���� ����
		MOV	MATTRIB, 40H	;�Ӽ��� �����Ͽ� �ش� �׸��� �� ����
		CALL	MDISPLY		
		CALL	M10INPUT	;�� Ű�Է��� ���� ���ν��� ȣ��
		CMP	MESC_CHK, 1	;�޴� ���� üũ
		JNE	CA20
		POPA

		CALL	I10DISCHR	;'ESC'Ű�� �޴��� ��������� ���

		MOV	ROW, 1		;ù�� ùĭ�� Ŀ�� ����
		MOV	COL, 1		
		CALL	E10CURSOR	
		RET	
CAMENU		ENDP
;--------------------------------------------------------------------
M10MENU		PROC	NEAR
;�޴� ȭ�� ��� ���ν���
		PUSHA
		MOV	AX, 1301H	;�׸��� ���
		MOV	BX, 0040H	
		LEA	BP, SHADOW	
		MOV	CX, 19		
		MOV	DH, MTOPROW+1	;�޴��� ���� �Ʒ�
		MOV	DL, MLEFCOL+1	;���������� ��ĭ ���� ���
MM20:		
		PUSHA
		INT	10H
		POPA
		INC	DH
		CMP	DH, MBOTROW+2	;�޴��� �Ʒ��ٱ��� �׸��ڰ� ��µƴ��� Ȯ��
		JNE	MM20

		MOV	MATTRIB, 0F0H	;�޴��� ���
		MOV	AX, 1300H	
		MOVZX	BX, MATTRIB	
		LEA	BP, MENU	
		MOV	CX, 19		
		MOV	DH, MTOPROW	;�޴��� ���� ����
		MOV	DL, MLEFCOL	;���� ���� ĭ

MM30:		PUSHA			;�ݺ��ؼ� �޴������� ���
		INT	10H
		POPA
		ADD	BP, 19		
		INC	DH
		CMP	DH, MBOTROW+1	;�޴��� �� ��µƴ��� Ȯ��
		JNE	MM30
		POPA
		RET
M10MENU		ENDP
;--------------------------------------------------------------------
M10INPUT	PROC	NEAR
;�޴����� �� Ű�� �Է¹޾� �����ϴ� ���ν���
MC20:		MOV	AH, 10H
		INT	16H		;Ű�� �Է¹���
		CMP	AH, 50H		;�Ʒ��� �������� ����Ű���� Ȯ��
		JE	MC30
		CMP	AH, 48H		;���� �ö󰡴� ����Ű���� Ȯ��
		JE	MC40
		CMP	AL, 0DH		;'ENTER'Ű���� Ȯ��
		JE	MC90
		CMP	AL, 1BH		; ESC-����
		JE	MC00
		JMP	MC20

MC30:		MOV	MATTRIB, 0F0H	;�Ӽ�����
		CALL	MDISPLY
		INC	MROW		;���� �Ʒ��� �̵�
		CMP	MROW, MBOTROW-1 ;�޴� ���� �Ʒ��� ���
		JBE	MC50
		MOV	MROW, MTOPROW+1 ;�޴��� ���� �ö󰡵��� ����
		JMP	MC50
MC40:		MOV	MATTRIB, 0F0H	;�Ӽ�����
		CALL	MDISPLY
		DEC	MROW		;���� ���� ������ ����
		CMP	MROW, MTOPROW+1	;�޴��� ���� ���� ���
		JAE	MC50
		MOV	MROW, MBOTROW-1	;�޴��� ���� �Ʒ��� ���������� ����
MC50:		MOV	MATTRIB, 40H	;�ش� �׸��� �� ����
		CALL	MDISPLY		
		JMP	MC20

MC90:		CMP	AH, 1CH		;'ENTER'Ű�� ��� ����
		JNE	MC00		

		CMP	MROW, MTOPROW+1	; 1��° �޴� - ���ư���
		JNE	MC01	
		JMP	MC00		; �޴� ����
MC01:		CMP	MROW, MTOPROW+2	; 2��° �޴� - ������
		JNE	MC02
		CALL	NEWFILE		; ȭ��&�ؽ�Ʈ���� �ʱ�ȭ
		JMP	MC00
MC02:		CMP	MROW, MTOPROW+3	; 3��° �޴� - ��������
		JNE	MC03
		CALL	SAVEFILE	;�������� ���ν��� ȣ��
		JMP	MC00	
MC03:		CMP	MROW, MTOPROW+4	; 4��° �޴� - ���Ϸε�
		JNE	MC04
		CALL	LOADFILE	;���Ϸε� ���ν��� ȣ��
		JMP	MC00
MC04:		CMP	MROW, MTOPROW+5	; 5��° �޴� - ����
		JNE	MC00
		MOV	ESC_CHK, 01	;���α׷��� �����ų ���� ����
MC00:		MOV	MESC_CHK, 01	;�޴� ȭ�� �����ų ���� ����
		RET
M10INPUT	ENDP
;�޴� ȭ�鿡�� �ش� �׸��� ���� �����ǵ��� �ϴ� ���ν���
;--------------------------------------------------------------------
MDISPLY		PROC	NEAR
		PUSHA
		MOVZX	AX, MROW	;�޴��� ���� ���� �޾Ƽ�
		SUB	AX, MTOPROW	;�� �׸��� ��Ȯ�� 
		IMUL	AX, 19		;����Ű���� ���
		LEA	SI, MENU+1	
		ADD	SI, AX

		MOV	AX, 1300H
		MOVZX	BX, MATTRIB	;�ش� �׸��� ���� ����
		MOV	BP, SI
		MOV	CX, 17
		MOV	DH, MROW
		MOV	DL, MLEFCOL+1	;ùĭ���� �޴������� ũ�����
		INT	10H		;���� ���� ��Ŵ
		POPA
		RET
MDISPLY		ENDP
;--------------------------------------------------------------------
NEWFILE		PROC	NEAR
;�ؽ�Ʈ ������ �ʱ�ȭ �Ͽ� �������� ���� ���
		PUSHA
		MOV	AL,' '		;�ؽ�Ʈ������ ��������
		LEA	DI,TEXT_AREA	;���鹮�ڷ� �ʱ�ȭ
		MOV	CX,1800
		REP	STOSB
				;���� ����(Ÿ��Ʋ) ���
		MOV	AX,1301H
		MOV	BL,0F4H
		LEA	BP,NEW_FILE_TITLE
		MOV	CX,20
		MOV	DX,000CH
		INT	10H
		POPA
		RET		
NEWFILE		ENDP
;--------------------------------------------------------------------
SAVEFILE	PROC	NEAR
;������ ���̺� �ϴ� ���ν���
;�ؽ�Ʈ������ �����͸� �ؽ�Ʈ ������ �����Ѵ�.
		MOV	DH, 16		;�ȳ� �޽�������� ���� Ŀ������
		MOV	DL, 22		
		CALL	E10CURSOR
		MOV	AH, 09
		LEA	DX, FILEMESS	;�ȳ� �޽���
		INT	21H

		MOV	DH, 17		;�޽��� ����� ���� Ŀ�� ����
		MOV	DL, 17		
		CALL	E10CURSOR	
		MOV	AH, 09
		LEA	DX, SAVEMESS	;������ ���������� ����Ǿ��� ��
		INT	21H		;ȭ�鿡 ���� �޽����� ���
		
		CALL	PATH_INPUT	;���ϸ��� �Է¹޴� ���ν��� ȣ��

		CALL	FILECREATE	;���� ����
		JC	SERROR		;���� �߻���
		MOV	AH, 40H		;���Ͽ� ���ڵ� ��� 
		MOV	BX, FILEHAND	;���� �ڵ� ����
		MOV	CX, 1794	;���ڵ��� ��ü����
		LEA	DX, TEXT_AREA	;������ ���ڵ�
		INT	21H
		JC	SERROR
		CALL	FILECLOSE	;���� �ݱ�

		MOV	DH, 18		;�ƹ�Ű�� �������� �ϴ� �޽��� ��� 
		MOV	DL, 33
		CALL	E10CURSOR
		MOV	AH, 09
		LEA	DX, PRESS	
		INT	21H		

		MOV	AH, 10H		;Ű �Է�
		INT	16H
		RET
SERROR:		CALL	ERROR		;�����߻��� ���� ���ν�ó ȣ��
		RET
SAVEFILE	ENDP
;--------------------------------------------------------------------
LOADFILE	PROC	NEAR
;����� �۾��� �ҷ����� ���ν���
;������ִ� �ؽ�Ʈ������ �о�鿩��
�����Ϳ������� �����ϰ� ����Ѵ�.

		MOV	DH, 16		;�ȳ� �޽�������� ���� Ŀ������
		MOV	DL, 22	
		CALL	E10CURSOR
		MOV	AH, 09
		LEA	DX, FILEMESS	;�ȳ� �޽���
		INT	21H

		MOV	DH, 17		;������ ���������� �ε�Ǿ��� ��
		MOV	DL, 17		;ȭ�鿡 ���� �޽����� ���
		CALL	E10CURSOR
		MOV	AH, 09
		LEA	DX, LOADMESS		
		INT	21H

		CALL	PATH_INPUT	;���ϸ��� �Է¹޴� ���ν��� ȣ��

		CALL	FILEOPEN	;���� ����
		JC	LERROR		;���� �߻���
		MOV	AH, 3FH		;���� �б�
		MOV	BX, FILEHAND	;���� �ڵ� ����
		MOV	CX, 1800	;���ڵ��� ��ü ����
		LEA	DX, TEXT_AREA	;���ڵ尡 ������ ���ڿ�
		INT	21H
		JC	LERROR	
		CALL	FILECLOSE	;���� �ݱ�

		MOV	DH, 18		;�ƹ�Ű�� �������� �ϴ� �޽��� ���
		MOV	DL, 33
		CALL	E10CURSOR
		MOV	AH, 09
		LEA	DX, PRESS	
		INT	21H

		MOV	AH, 10H		;Ű �Է�
		INT	16H

		RET
LERROR:		CALL	ERROR		;�����߻��� ���� ���ν��� ȣ��
		RET
LOADFILE	ENDP
;--------------------------------------------------------------------
FILECREATE	PROC	NEAR
;������ �����Ͽ� �����ڵ��� �����ϴ� ���ν���
		MOV	AH, 3CH		
		MOV	CX, 00
		LEA	DX, FILEPATH	;������ ��� ����
		INT	21H
		MOV	FILEHAND, AX	;������ ������ �����ڵ� ����
		RET
FILECREATE	ENDP
;--------------------------------------------------------------------
FILECLOSE	PROC	NEAR
;���� ������ �ݴ� ���ν���
		MOV	AH, 3EH
		MOV	BX, FILEHAND	;���� �ڵ� ����
		INT	21H
		JC	CLERROR		
		RET
CLERROR:	CALL	ERROR		;�����߻��� ���� ���ν��� ȣ��
		RET
FILECLOSE	ENDP
;--------------------------------------------------------------------
FILEOPEN	PROC	NEAR
;������ ��� �����ڵ��� �����ϴ� ���ν���
		MOV	AH, 3DH
		MOV	AL, 02		;�б�/���Ⱑ �ǵ��� ����
		LEA	DX, FILEPATH	;���� ��� ����
		INT	21H
		MOV	FILEHAND, AX	;�����ڵ� ����
		RET
FILEOPEN	ENDP
;--------------------------------------------------------------------
PATH_INPUT	PROC	NEAR
		PUSHA
		
		MOV	DH,17		;��ڽ��� ����ϱ� ���� Ŀ������
		MOV	DL,40
		CALL	E10CURSOR
		
		MOV	AH,09H		;��ڽ� ���(AH 09, INT10)
		MOV	AL,' '
		MOV	BH,00
		MOV	BL,0F4H
		MOV	CX,20
		INT	10H

		MOV	DH,17		;���ϸ� �Է��� �ޱ����� Ŀ�� ����
		MOV	DL,40
		CALL	E10CURSOR
		
		MOV	AH,0AH		;���ϸ��� �Է¹���
		LEA	DX,PARLIST	;�Ķ󸮽�Ʈ�� ���ؼ�
		INT	21H
		
		CLD
		LEA	SI,KB_DATA	;MOVSB�� ���ؼ� ���ϸ�����
		LEA	DI,INPUTPATH	;�Է¹��� ���� ����
		MOVZX	CX,ACT_LEN
		REP	MOVSB
		MOV	AL,'.'		;�����н� + Ȯ����.txt�� ����ֱ� ����
		STOSB			;AL�� ���� �ְ� STOSB�� ��
		MOV	AL,'t'
		STOSB
		MOV	AL,'x'
		STOSB
		MOV	AL,'t'
		STOSB
		MOV	AL,00H
		STOSB
		
		MOV	DX,000CH	;������ ���� ������ ���� Ŀ������
		CALL	E10CURSOR
		MOV	AX,09CDH	;������ ���� ����
		MOV	BX,004FH
		MOV	CX,20
		INT	10H
		
		MOV	AL,' '
		LEA	DI,FILE_TITLE
		MOV	CX,22
		REP	STOSB

		LEA	DI,FILE_TITLE+1	;�Է¹��� ���ڸ� ��������� ���� �̵�
		LEA	SI,KB_DATA	
		MOVZX	CX,ACT_LEN	;�̵��ݺ��� ACT_LEN��ŭ
		REP	MOVSB		
		
		MOV	AX,1301H
		MOV	BX,00F4H	
		MOVZX	CX,ACT_LEN
		ADD	CX,2
		LEA	BP,FILE_TITLE
		MOV	DX,000CH
		PUSHA
		INT	10H
		POPA

		POPA
		RET
PATH_INPUT	ENDP
;--------------------------------------------------------------------
ERROR		PROC	NEAR
;�����߻��� �����޽����� ȭ�鿡 ����ϴ� ���ν���
		PUSHA
		MOV	AH,09
		MOV	DH, 6
		MOV	DL, 30
		CALL	E10CURSOR
		MOV	AH, 09
		LEA	DX, ERRORMESS	;ȭ�鿡 �����޽����� ���
		INT	21H

		POPA
		RET
ERROR		ENDP
	END	A10MAIN
;------------------------------------------------
