#include <Date.au3>
#include <File.au3>
#include <OO_JSON.au3>


HotKeySet("{f4}","quit")
Local Const $sFilePath = @ScriptDir & "\Config.ini"
Local $sSidesyncTitle = IniRead($sFilePath, "Setting", "Title", "Default Value")


Local $x = Int(IniRead($sFilePath, "Setting", "LocationX", "Default Value"))
Local $y = Int(IniRead($sFilePath, "Setting", "LocationY", "Default Value"))
Local $hWnd = WinGetHandle($sSidesyncTitle)
WinActivate($hWnd)
Local $aPos = WinGetPos($hWnd)
Local $iCount = 0
WinMove($hWnd, "", $x, $y, 910, 610)
Dim $aLog, $TotalLine
Local $fileLog = IniRead($sFilePath, "Setting", "SwExportLog", "Default Value")
Local $sOutputLog = IniRead($sFilePath, "Setting", "OutputLog", "Default Value")
$TimeStamp = FileGetTime($fileLog, 0, 1)
_FileReadToArray($fileLog, $aLog)
$TotalLine = $aLog[0]
While 1
   If FileGetTime($fileLog, 0, 1) <> $TimeStamp Then
	  ;LogWrite('$TimeStamp   : ' & $TimeStamp )
	  $TimeStamp = FileGetTime($fileLog, 0, 1)
	  _FileReadToArray($fileLog, $aLog)
	  If IsArray($aLog) Then
		 $newLines = ""
		 For $i = $TotalLine To $aLog[0]
			If StringInStr($aLog[$i], '{"command":"BattleDungeonResult","ret_code":0') Then
			   $newLines &= $aLog[$i]
			EndIf
		 Next
		 $TotalLine = $aLog[0]
		 ;LogWrite('$TotalLine   : ' & $TotalLine )
	  EndIf
	  Local $isKeepThisRune = False
	  If $newLines = "" Then
		 ;LogWrite("Empty Line") ;do nothing
	  Else
		 Local $runeIndx = StringInStr($newLines, '"crate":{"rune"')
		 If $runeIndx > 0 Then
			$oJSON = _OO_JSON_Init()
			Local $jsObj = $oJSON.parse($newLines)
			LogWrite('Rune Star   : ' & $jsObj.reward.crate.rune.class )
			LogWrite('Slot No     : ' & $jsObj.reward.crate.rune.slot_no )
			LogWrite('Rune Set   : ' & MappingRuneClass($jsObj.reward.crate.rune.set_id) )
			LogWrite('Rune Rank   : ' & MappingRuneRank($jsObj.reward.crate.rune.rank) )
			LogWrite('Main Stat   : ' & MappingRuneStat($jsObj.reward.crate.rune.pri_eff.item(0)) & " " & $jsObj.reward.crate.rune.pri_eff.item(1) )
			For $j = 0 To $jsObj.reward.crate.rune.sec_eff.length - 1
			   LogWrite('Sub Stat    : ' & MappingRuneStat($jsObj.reward.crate.rune.sec_eff.item($j).item(0)) & " " & $jsObj.reward.crate.rune.sec_eff.item($j).item(1) )
			   ;Check Spd Rune > 5
			   if $jsObj.reward.crate.rune.sec_eff.item($j).item(0) = "8" And Int($jsObj.reward.crate.rune.rank) >= 4 And Int($jsObj.reward.crate.rune.sec_eff.item($j).item(1)) >= 5 Then
				  $isKeepThisRune = True
				  LogWrite('Pass Check Spd Rune > 5')
			   EndIf
			   ;Check CRate Rune > 6
			   if $jsObj.reward.crate.rune.sec_eff.item($j).item(0) = "9" And Int($jsObj.reward.crate.rune.rank) >= 4 And Int($jsObj.reward.crate.rune.sec_eff.item($j).item(1)) >= 5 Then
				  $isKeepThisRune = True
				  LogWrite('Pass Check CRate Rune > 6')
			   EndIf
			Next
			;Rune 6 Star and Rank Hero or Legendary only
			If Int($jsObj.reward.crate.rune.class) = 6 And Int($jsObj.reward.crate.rune.rank) >= 4 Then
			   ;Check slot 2/4/6 Main stat
			   If $jsObj.reward.crate.rune.slot_no = 2 or $jsObj.reward.crate.rune.slot_no = 4 or $jsObj.reward.crate.rune.slot_no = 6 Then
				  $isKeepThisRune = MainStatCheck($jsObj.reward.crate.rune.pri_eff.item(0))
				  LogWrite('Pass Check slot 2/4/6 Main stat')
			   Else
				  ;Slot 1/3/5
				  $isKeepThisRune = True
				  LogWrite('Slot 1/3/5')
			   EndIf
			EndIf

			LogWrite("Keep this rune? : " & $isKeepThisRune )
			Sleep(9000)
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT,$x+705, $y+143,1,0)
			MouseMove($pos[0],$pos[1],0)
			Sleep(1500)
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT,$x+705, $y+143,1,0)
			MouseMove($pos[0],$pos[1],0)
			Sleep(2000)
			If $isKeepThisRune Then
			   LogWrite("Get this rune")
			   Sleep(500)
			   $pos=MouseGetPos()
			   MouseClick($MOUSE_CLICK_LEFT, $x+577, $y+465,1,0)
			   MouseMove($pos[0],$pos[1],0)
			Else
			   LogWrite("Sell this rune")
			   ;~ Click Ok on center
			   Sleep(500)
			   $pos=MouseGetPos()
			   MouseClick($MOUSE_CLICK_LEFT, $x+434, $y+465,1,0)
			   MouseMove($pos[0],$pos[1],0)
			   ;~ Sale rune
			   Sleep(1000)
			   $pos=MouseGetPos()
			   MouseClick($MOUSE_CLICK_LEFT, $x+434, $y+465,1,0)
			   MouseMove($pos[0],$pos[1],0)
			   ;~ Click On to sale
			   Sleep(1000)
			   $pos=MouseGetPos()
			   MouseClick($MOUSE_CLICK_LEFT, $x+325, $y+370,1,0)
			   MouseMove($pos[0],$pos[1],0)
			EndIf
			Sleep(2000)
			;~ Click Replay
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT, $x+419, $y+336,2,0)
			MouseMove($pos[0],$pos[1],0)
			Sleep(2000)
			RefillEnergy()
			;~ Click Start button
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT, $x+749, 384,1,0)
			MouseMove($pos[0],$pos[1],0)
			Sleep(3000)
		 Else
			LogWrite("Not rune")
			Sleep(9000)
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT,$x+705, $y+143,1,0)
			MouseMove($pos[0],$pos[1],0)
			Sleep(1500)
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT,$x+705, $y+143,1,0)
			MouseMove($pos[0],$pos[1],0)
			;~ Click Ok on center
			Sleep(1500)
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT, $x+455, $y+462,1,0)
			MouseMove($pos[0],$pos[1],0)
			Sleep(2000)
			;~ Click Replay
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT, $x+419, $y+336,2,0)
			MouseMove($pos[0],$pos[1],0)
			Sleep(2000)
			RefillEnergy()
			;~ Click Start button
			$pos=MouseGetPos()
			MouseClick($MOUSE_CLICK_LEFT, $x+749, 384,1,0)
			MouseMove($pos[0],$pos[1],0)
			Sleep(3000)
		 EndIf
	  EndIf


   EndIf
   Sleep(1000)
WEnd

Func RefillEnergy()
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
EndFunc

Func LogWrite($txt)
   _FileWriteLog($sOutputLog & @MDAY & @MON & @YEAR &".log", $txt)
EndFunc

Func MainStatCheck($input)
  $sMsg = False
   Switch $input
   Case "1"
	  $sMsg = False;'HP flat'
   Case "2"
	  $sMsg = True;'HP%'
   Case "3"
	  $sMsg = False;'ATK flat'
   Case "4"
	  $sMsg = True;'ATK%'
   Case "5"
	  $sMsg = False;'DEF flat'
   Case "6"
	  $sMsg = True;'DEF%'
   Case "8"
	  $sMsg = True;'SPD'
   Case "9"
	  $sMsg = True;'CRate'
   Case "10"
	  $sMsg =  True;'CDmg'
   Case "11"
	  $sMsg =  True;'RES'
   Case "12"
	  $sMsg =  True;'ACC'
   Case Else
	  $sMsg = false
   EndSwitch
   Return $sMsg
EndFunc

Func MappingRuneStat($type)
   $sMsg = ""
   Switch $type
   Case "1"
	  $sMsg = 'HP flat'
   Case "2"
	  $sMsg = 'HP%'
   Case "3"
	  $sMsg = 'ATK flat'
   Case "4"
	  $sMsg = 'ATK%'
   Case "5"
	  $sMsg = 'DEF flat'
   Case "6"
	  $sMsg = 'DEF%'
   Case "8"
	  $sMsg = 'SPD'
   Case "9"
	  $sMsg = 'CRate'
   Case "10"
	  $sMsg =  'CDmg'
   Case "11"
	  $sMsg =  'RES'
   Case "12"
	  $sMsg =  'ACC'
   Case Else
	  $sMsg = ""
   EndSwitch
   Return $sMsg
EndFunc

Func MappingRuneClass($input)
   $sMsg = ""
   Switch $input
   Case "1"
	$sMsg = "Energy"
   Case "2"
	$sMsg = "Guard"
   Case "3"
	$sMsg = "Swift"
   Case "4"
	$sMsg = "Blade"
   Case "5"
	$sMsg = "Rage"
   Case "6"
	$sMsg = "Focus"
   Case "7"
	$sMsg = "Endure"
   Case "8"
	$sMsg = "Fatal"
   Case "10"
	$sMsg =  "Despair"
   Case "11"
	$sMsg =  "Vampire"
   Case "13"
	$sMsg =  "Violent"
   Case "14"
	$sMsg =  "Nemesis"
   Case "15"
	$sMsg =  "Will"
   Case "16"
	$sMsg =  "Shield"
   Case "17"
	$sMsg =  "Revenge"
   Case "18"
	$sMsg =  "Destroy"
   Case "19"
	$sMsg =  "Fight"
   Case "20"
	$sMsg =  "Determination"
   Case "21"
	$sMsg =  "Enhance"
   Case "22"
	$sMsg =  "Accuracy"
   Case "23"
	$sMsg =  "Tolerance"
   Case Else
	  $sMsg = ""
   EndSwitch
   Return $sMsg
EndFunc
Func MappingRuneRank($input)
   $sMsg = ""
   Switch $input
   Case "1"
	$sMsg = "Common"
   Case "2"
	$sMsg = "Magic"
   Case "3"
	$sMsg = "Rare"
   Case "4"
	$sMsg = "Hero"
   Case "5"
	$sMsg = "Legend"
   Case Else
	  $sMsg = ""
   EndSwitch
   Return $sMsg
EndFunc

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
   LogWrite(@ScriptDir & "\" & @MDAY & @MON & @YEAR &".log", "Quit Program")
    Exit
EndFunc
