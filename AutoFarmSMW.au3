#include <Date.au3>
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>

HotKeySet("{f4}","quit")
Local $x = 1010
Local $y = 0
Local $hWnd = WinGetHandle("Dev3m")
WinActivate($hWnd)
Local $aPos = WinGetPos($hWnd)
Local $iCount = 0
WinMove($hWnd, "", $x, $y, 910, 610)
$ColorVictoryContain = 'F9F'
$ColorButton = 'B88632'
$ColorLose = 'DE1F53'
;~ MsgBox($MB_SYSTEMMODAL, "Show ColorCode", Hex(PixelGetColor(2235, 80), 6), 10)
While 1
   ;~ Click Replay button
   Sleep(500)
   $pos=MouseGetPos()
   MouseClick($MOUSE_CLICK_LEFT, $x+419, $y+336,2,0)
   MouseMove($pos[0],$pos[1],0)
   Sleep(2000)

   ;~ Check not Enough energy
   Local $ColorRefillEn = Hex(PixelGetColor($x+425, $y+357), 6)
   Local $iRefilEn = _StringStartsWith($ColorRefillEn , 'C0')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C1')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C2')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C3')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C4')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C5')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C6')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C7')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C8')
   $iRefilEn += _StringStartsWith($ColorRefillEn , 'C9')

    If $iRefilEn > 0 Then
   ;~ Click Yes for refill energy
	  Sleep(1000)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+385, $y+336,1,0)
	  MouseMove($pos[0],$pos[1],0)
	  Sleep(3000)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+345, $y+279,1,0)
	  MouseMove($pos[0],$pos[1],0)
	  Sleep(2000)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+426, $y+348,1,0)
	  MouseMove($pos[0],$pos[1],0)
	  Sleep(2000)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+450, $y+353,1,0)
	  MouseMove($pos[0],$pos[1],0)
	  Sleep(2000)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+452, $y+486,1,0)
	  MouseMove($pos[0],$pos[1],0)
	  Sleep(2000)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+419, $y+336, 2,0)
	  MouseMove($pos[0],$pos[1],0)
	  Sleep(2000)

   EndIf

   ;~ Click Start button
   $pos=MouseGetPos()
   MouseClick($MOUSE_CLICK_LEFT, $x+749, 384,1,0)
   MouseMove($pos[0],$pos[1],0)
   Sleep(3000)

   ;~ MsgBox($MB_SYSTEMMODAL, "Show ColorCode", Hex(PixelGetColor(2235, 80), 6), 10)
   While 1
	 Local $iPosition = StringInStr(Hex(PixelGetColor($x+441, $y+117), 6) , $ColorVictoryContain)
	 $iPosition += StringInStr(Hex(PixelGetColor($x+437, $y+138), 6) , 'F9B')

	 ;~Local $iLosePos = _StringStartsWith(Hex(PixelGetColor($x+441, $y+117), 6) , 'F0')
	 ;~$iLosePos += _StringStartsWith(Hex(PixelGetColor($x+441, $y+117), 6) , 'F1')
	 ;~$iLosePos += _StringStartsWith(Hex(PixelGetColor($x+441, $y+117), 6) , 'F8')
	 ;~$iLosePos += _StringStartsWith(Hex(PixelGetColor($x+441, $y+117), 6) , 'F9')
	 If $iPosition > 1 Then
		$iCount = $iCount+1
		ExitLoop
	;~ ElseIf $iLosePos> 0  Then
	;~	MouseClick($MOUSE_CLICK_LEFT,$x+667, $y+376)
	;~	Sleep(2000)
	;~	MouseClick($MOUSE_CLICK_LEFT,$x+705, $y+143)
	;~	ExitLoop
	 Else
	   Sleep(3000)
	 EndIf
   WEnd
   $pos=MouseGetPos()
   MouseClick($MOUSE_CLICK_LEFT,$x+705, $y+143,1,0)
   MouseMove($pos[0],$pos[1],0)
   Sleep(1500)
   $pos=MouseGetPos()
   MouseClick($MOUSE_CLICK_LEFT,$x+705, $y+143,1,0)
   MouseMove($pos[0],$pos[1],0)
   Sleep(2000)
   ;~ Check 6 star
   Local $iRune = StringInStr(Hex(PixelGetColor($x+350, $y+215), 6) , 'EF')
   $iRune += StringInStr(Hex(PixelGetColor($x+350, $y+215), 6) , 'EA')
   $iRune += StringInStr(Hex(PixelGetColor($x+350, $y+215), 6) , 'EB')
   $iRune += StringInStr(Hex(PixelGetColor($x+350, $y+215), 6) , 'EC')
   $iRune += StringInStr(Hex(PixelGetColor($x+350, $y+215), 6) , 'ED')
   $iRune += StringInStr(Hex(PixelGetColor($x+350, $y+215), 6) , 'E7')
   If $iRune > 0 Then
   ;~ Keep rune
	  _FileWriteLog(@ScriptDir & "\" & @MDAY & @MON & @YEAR &".log", "6 star rune Loop#" & $iCount) ; Write to the logfile passing the filehandle returned by FileOpen.
	  Sleep(500)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+577, $y+465,1,0)
	  MouseMove($pos[0],$pos[1],0)
   Else
	  _FileWriteLog(@ScriptDir & "\" & @MDAY & @MON & @YEAR &".log", "not six star rune Loop#" & $iCount)
	  ;~ Click Ok on center
	  Sleep(1000)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+434, $y+465,1,0)
	  MouseMove($pos[0],$pos[1],0)
	  ;~ Sale rune
	  Sleep(500)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+434, $y+465,1,0)
	  MouseMove($pos[0],$pos[1],0)
	  ;~ Click On to sale
	  Sleep(1000)
	  $pos=MouseGetPos()
	  MouseClick($MOUSE_CLICK_LEFT, $x+325, $y+370,1,0)
	  MouseMove($pos[0],$pos[1],0)
   EndIf
   Sleep(1500)
WEnd

Func _StringStartsWith($string, $start, $case = 0)
    If StringLen($start) > StringLen($string) Then Return -1
    If $case > 0 Then
        If StringLeft($string, StringLen($start)) == $start Then Return 1
    Else
        If StringLeft($string, StringLen($start)) = $start Then Return 1
    EndIf
    Return 0
 EndFunc   ;==>_StringStartsWith

Func quit()
   _FileWriteLog(@ScriptDir & "\" & @MDAY & @MON & @YEAR &".log", "Quit Program")
    Exit
EndFunc

