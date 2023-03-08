[ORG 0x00]          ; 코드의 시작 어드레스를 0x00으로 설정
[BITS 16]           ; 이하의 코드는 16비트 코드로 설정

SECTION .text           ; text 섹션(세그먼트)을 정의

jmp 0x07C0:START        ; cs 레지스터에 0x07C0을 복사하면서 START Label로 이동

START:
    mov ax, 0x07C0      ; BootLoader의 시작 Addr(0x07C0)을 세그먼트 레지스터 값으로 변환
    mov ds, ax          ; ds 레지스터에 설정
    mov ax, 0xB800      ; ax 레지스터에 0xB800 복사
    mov es, ax          ; es 레지스터에 ax의 값 복사

    mov si, 0           ; si 레지스터(문자열 원본 인덱스 레지스터)를 초기화

.SCREENLOOP:                        ; 화면 지우는 Loop
    mov byte [ es:si ], 0           ; 비디오 메모리의 문자가 위치하는 Addr에
                                    ; 0을 복사하여 문자를 삭제
    mov byte [ es:si + 1 ], 0x0A    ; 비디오 메모리의 속성이 위치하는 Addr에
                                    ; 0x0a(검은 바탕에 밝은 녹색)을 복사

    add si, 2                       ; 문자와 속성을 설정한 뒤 다음 위치로 이동(Addr+2)

    cmp si, 80 * 25 * 2     ; 화면의 전체 크기는 80X25
                            ; 출력한 문자 수를 비교하는 si 레지스터와 비교
    jl .SCREENLOOP          ; si 레지스터가 80 * 25 * 2보다 작다면 아직 지우지 못한
                            ; 영역이 있으므로 .SCREENLOOP(화면 지우기)로 이동
    mov si, 0                ; si 레지스터(문자열 원본 인덱스 레지스터)를 초기화
    mov di, 0               ; di 레지스터(문자열 대상 인덱스 레지스터)를 초기화

.MESSAGELOOP:
    mov cl, byte [ si + MESSAGE1 ]  ; MESSAGE1의 Addr에서 si 레지스터 값만큼
                                    ; 더한 위치의 문자를 cl 레지스터에 복사
                                    ; cl 레지스터는 cx 레지스터의 하위 1byte를 의미
                                    ; 문자열은 1byte면 충분하므로 cx 레지스터의 하위 1byte만 사용
    cmp cl, 0           ; 복사된 문자와 0을 비교
    je .MESSAGEEND      ; 복사한 문자의 값이 0이면 문자열이 종료되었음을
                        ; 의미하므로 .MESSAGEEND로 이동하여 문자 출력 종료
    
    mov byte [ es:di ], cl  ; 0이 아니라면 비디오 메모리 Addr 0xb800:di에 문자를 출력

    add si, 1           ; si 레지스터에 1을 더하여 다음 문자열로 이동
    add di, 2           ; di 레지스터에 2를 더하여 비디오 메모리의 다음 문자 위치로 이동
                        ; 비디오 메모리는 (문자, 속성)의 쌍으로 구성되므로 문자만 출력하려면
                        ; 2를 더해야 함

    jmp .MESSAGELOOP    ; 메세지 출력 루프로 이동하여 다음 문자를 출력

.MESSAGEEND:
    jmp $               ; 현재 위치에서 무한 루프 수행

MESSAGE1:   db 'MINT64 OS Boot Loader Start!', 0    ; 출력할 메세지 정의
                                                    ; 마지막 문자는 0으로 설정하여 .MESSAGELOOP에서
                                                    ; 문자열이 종료되었음을 알 수 있도록 함

times 510 - ( $ - $$ )      db      0x00    ; $: 현재 라인의 어드레스
                                            ; $$: 현재 섹션(.text)의 시작 어드레스
                                            ; $ - $$: 현재 섹션을 기준으로 하는 오프셋
                                            ; 510 - ( $ - $$ ): 현재부터 어드레스 510까지
                                            ; db 0x00: 1바이트를 선언하고 값은 0x00
                                            ; time: 반복 수행
                                            ; 현재 위치에서 어드레스 510까지 0x00으로 채움

db 0x55             ; 1바이트를 선언하고 값은 0x55
db 0xAA             ; 1바이트를 선언하고 값은 0xAA
                    ; 어드레스 511, 512에 0x55, 0xAA를 써서 부트 섹터로 표기함