#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force	;このスクリプトが再度呼び出されたらリロードして置き換え
#InstallKeybdHook		;virtual key/scan code確認用
#Persistent
#UseHook


#IfWinNotActive, ahk_class Qt5QWindowIcon
;無変換+[hjkl] => 左下上右
;無変換+ctrl+[hjkl] => shift+左下上右

;無変換+h => 左
vk1D & h::
	if GetKeyState("ctrl", "P") {
		Send +{Left}
	} else if GetKeyState("shift", "P") {
		Send ^{Left}
	} else {
		Send {Left}
	}
	return
;無変換+j => 下
vk1D & j::
	if GetKeyState("ctrl", "P") {
		Send +{Down}
	} else if GetKeyState("shift", "P") {
		Send ^{Down}
	} else {
		if WinActive("ahk_class Framework::CFrame") {
			; One Noteで上下キーSendが効かないので代用
			Send ^{Down}
		} else {
			Send {Down}
		}
	}
	return
;無変換+k => 上
vk1D & k::
	If GetKeyState("ctrl", "P") {
		Send +{Up}
	} else if GetKeyState("shift", "P") {
		Send ^{Up}
	} else {
		if WinActive("ahk_class Framework::CFrame") {
			; One Noteで上下キーSendが効かないので代用
			Send ^{Up}
		} else {
			Send {Up}
		}
	}
	return
;無変換+l => 右
vk1D & l::
	If GetKeyState("ctrl", "P") {
		Send +{Right}
	} else if GetKeyState("shift", "P") {
		Send ^{Right}
	} else {
		Send {Right}
	}
	return


;無変換+m => 下に行を挿入
vk1D & m::
	if WinActive("ahk_class SWT_Window0") {
		Send {Esc}
		Send {Esc}
	}
	Send {End}
	Send {Enter}
	return


;無変換+io => Home,End
vk1D & i::
	if GetKeyState("ctrl", "P") {
		Send +{Home}
	} else if GetKeyState("shift", "P") {
		Send ^{Home}
	} else {
		Send {Home}
	}
	return

;無変換+o => End
vk1D & o::
	if GetKeyState("ctrl", "P") {
		Send +{End}
	} else if GetKeyState("shift", "P") {
		Send ^{End}
	} else {
		Send {End}
	}
	return


;無変換+p => PageUp
;無変換+p+ctrl => Shift+PageUp
vk1D & p::
	if GetKeyState("ctrl", "P") {
		Send +{pgup}
	} else if GetKeyState("alt", "P") {
		Send !{pgup}
	} else {
		Send {pgup}
	}
	return
;無変換+{;キー} => PageDown
;無変換+{;キー}+ctrl => Shift+PageDown
vk1D & vkBB::
	if GetKeyState("ctrl", "P") {
		Send +{pgdn}
	} else if GetKeyState("alt", "P") {
		Send !{pgdn}
	} else {
		Send {pgdn}
	}
	return

;変換+e => Esc
vk1C & e::
	Send {Esc}
	return

;アプリケーションキー+[ => page up
;アプリケーションキー+] => page down
;AppsKey+[ => PgUp
AppsKey & vkDB::Send {PgUp}
;AppsKey+] => PgDn
AppsKey & vkDD::Send {PgDn}

;変換+p => PrintScreen
vk1C & p::
	if GetKeyState("alt", "P") {
		Send !{PrintScreen}
	} else {
		Send {PrintScreen}
	}
	return 

;メモ帳,excel,chrome,sakuraエディタではF1キー無効化
;F1=>半角/全角
F1::
	if WinActive("ahk_class Notepad")
	|| WinActive("ahk_class XLMAIN")
	|| WinActive("ahk_class Chrome_WidgetWin_1")
	|| WinActive("ahk_class TextEditorWindowW166") {
		return
	}
	Send {F1}
	return

;Excelでalt+p→ctrl+PageUp
!p::
	if WinActive("ahk_class XLMAIN") {
		Send ^{pgup}
	}
	return
;Excelでalt+:→ctrl+PageDown
!vkBB::
	if WinActive("ahk_class XLMAIN") {
		Send ^{pgdn}
	}
	return
;Excel VBEでctrl+k→自動構文チェックon/off切り替え
^k::
	if WinActive("ahk_class wndclass_desked_gsk") {
		Send !t
		Send +o
		Send +k
		Send {Enter}
	} else {
		Send ^k
	}
	return

;メモ帳で ctrl+w=>alt+F4
;桜エディタで ctrl+w=>ctrl+F4
^w::
	if WinActive("ahk_class Notepad") {
		Send !{F4}
		return
	} else if WinActive("ahk_class TextEditorWindowW166") {
		Send ^{F4}
		return
	} else if WinActive("ahk_class TextEditorWindowW142") {
		Send ^{F4}
		return
	}
	Send ^w
	return
	
;eclipseでAlt+h=>Alt+左
!h::
	if WinActive("ahk_class SWT_Window0") {
		Send !{Left}
	}
	return
;eclipseでAlt+l=>Alt+右
!l::
	if WinActive("ahk_class SWT_Window0") {
		Send !{Right}
	}
	return

;右Win→Alt
vk5C::vkA4

;chrome上でctrl+("+" or "-")による拡大無効化
#If WinActive("ahk_class Chrome_WidgetWin_1")
^vkBB::
	return
^vkBD::
	return
#IfWinActive

;無変換+変換→alt+shift+space(Wox用)
vk1D & vk1C::
	Send !+{Space}
	return

;変換+g→Downloadフォルダ
vk1C & g::
	if WinActive("ahk_class CabinetWClass") {
		Send ^l
		path = C:\Users\%A_UserName%\Downloads
		PasteString(path)
		Send {Enter}
	} else {
		Run, C:\Users\%A_UserName%\Downloads
	}
	return

;変換+c→(Win+shift+2)Chrome
vk1C & c::
	Send #+2
	return

;変換+s→systemのプロパティ
vk1C & s::
	if GetKeyState("ctrl", "P") {
		Send #{Pause}
	}
	return

;変換+space=>スクリプトリロード
vk1C & vk20::Reload

;ctrl+vで張り付け(cygwin用)
;パスをコピペする時に \ → / に変換して貼り付け
#If WinActive("ahk_class mintty")
^v::
	sendStr := Clipboard
	num := RegExMatch(sendStr, "[a-zA-Z]:\\")
	if(num = 1) {
		StringReplace, out, sendStr, \, /, All
		out := """" . out . """"
		PasteString(out)
	} else {
		PasteString(sendStr)
	}
	return
#IfWinActive

;ctrl+vで貼り付け(bash on Ubuntu on Windows)
#If WinActive("ahk_exe bash.exe")
^v::
	SendInput {Raw}%clipboard%
	return

#IfWinActive

;ctrl+vで張り付け(コマンドプロンプト用)
#If WinActive("ahk_exe cmd.exe")
^v::
	Send !{Space}ep	;貼り付け
	return
;無変換+ctrl+i
vk1D & i::
	if GetKeyState("ctrl", "P") {
		MsgBox "testset"
		Send +{Ins}
	}
	return
#IfWinActive

;;;;;;bootcamp対応;;;;;;

;無変換+e→英語
vk1D & e::
	IME_SET(0)
	return

;変換+l→日本語
vk1C & l::
	IME_SET(1)
	return

; IME_SET(0) -> 英数
; IME_SET(1) -> かな
IME_SET(SetSts, WinTitle="A") {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if (WinActive(WinTitle)) {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")    ;    DWORD    cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }
    return DllCall("SendMessage"
        , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
        , UInt, 0x0283  ;Message : WM_IME_CONTROL
        ,     Int, 0x006      ;wParam  : IMC_SETOPENSTATUS
        ,     Int, SetSts) ;lParam  : 0 or 1
}

;無変換+d→delete
vk1D & d::
	Send {Delete}
	return

;無変換+q→alt+F4
vk1D & q::
	Send !{F4}
	return

;;;;;;util関数;;;;;;
;文字列張り付け用関数
PasteString(String) {
	Backup := ClipboardAll
	Clipboard := String
	Sleep,125
	If WinActive("ahk_class mintty") {
		Send +{Insert}
	} else {
		Send ^v
	}
	Sleep,125
	Clipboard := Backup
}
