; Ideally the volume will be achieved via HTTPs or in some other way which means the window will not be changed 

; - open http://localhost:5500/ - done via Bat , make sure is running (personally I used VSCode extension: Live Server)
; - allow mic - I've decided to let the user do this manually 
; - wait X seconds 
; - store mouse current (proper) position 
; - copy volume text into paste container 
; - read text as number 
; - if volume over 6, move mouse (from proper position) up 
; - if volume over 4 but less than 6, move mouse (from proper position) up 

volume = 0 
getVolume() {
    Click, 575, 758 ; make sure the browser which has get-amplitude.html open is 2nd item in window bar & there is only 1 browser window open & current (non browser) window is full screen 
    Sleep, 300 
    Send, ^a
    tmp = %ClipboardAll% ; save clipboard
    Clipboard := "" ; clear clipboard
    Send, ^c ; simulate Ctrl+C (=selection in clipboard)
    ClipWait, 0, 1 ; wait until clipboard contains data
    volume = %Clipboard% ; save the content of the clipboard
    Clipboard = %tmp% ; restore old content of the clipboard 
    ; MsgBox, vol as _text: %volume% 
    return volume 
} 

moveMouseUp() {
    if (volume >= 4) {
        ; MsgBox, _up %volume%
        MouseMove, PrevX, PrevX + 20 
    } 
    ; return 
}

moveMouse() {
    ; if (volume <= 4) {
        ; MsgBox, _down %volume%
    ;     MouseMove, PrevX, PrevY - 30 ; this may be "inverted"
    ;     return  
    ; } else { ; if (volume >= 4) {
        ; MsgBox, _up %volume%
        MouseMove, PrevX, PrevY + 30 
    ;     return 
    ; } 
}

^!o:: ; ctrl alt o ; will do this Once 
    ; Sleep, 200 
    MouseGetPos, prevX, prevY 
    volume := getVolume() ; note: I used Google Assistant playing metal music at max volume to test 
    ; Sleep, 200 
    ; MouseMove, 575, 758 ; minimizes [Chrome] browser 
    ; Send, ^!m ; kind of a botch ; Click, 575, 758 
    ; Sleep, 220 
    ; MsgBox, chrome should be closed by now 
    ; not entirely comfortable with this logic 
    Sleep, 300 
    Click, 1256, 22 ; minimize [chrome] browser  
    Sleep, 300
    MouseMove, PrevX, PrevY 
    ToolTip, vol: %volume%, 10, 40
    if (volume >= 3) { ; down 
        MouseMove, PrevX, PrevY + 30 
    } 
    if (volume >= 5) { ; up 
        MouseMove, PrevX, PrevY - 30 
    }
    ; moveMouse() 
    return 

^!v:: ; ctrl alt v ; will loop 
    ; while (true) {
    Loop, 15 {
        Send, ^!o 
        Sleep, 5200 
    }
    ; }
    ; Sleep, 200 
    MsgBox, done 
    return 

^!e:: ; ctrl alt e ; will exit 
    Exit
    return 

; ^!m:: ; minmize browser 
;    Click, 575, 758 
;    return 