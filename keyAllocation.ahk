#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force  ;このスクリプトが再度呼び出されたらリロードして置き換え
#InstallKeybdHook    ;virtual key/scan code確認用
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
; WSL2, windows terminal上でesc => esc+英語入力(vimでnormal mode遷移時に英語入力に切り替えるため)
vk1C & e::
esc::
  If WinActive("ahk_class ConsoleWindowClass") || WinActive("ahk_exe WindowsTerminal.exe") {
    IME_SET(0)
  }
  Send {Esc}
  return

;変換+w => alt+shift+space(Wox用)
vk1C & w::Send !+{Space}

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

;無変換+数字 => F[数字]
vk1D & 1::
  if WinActive("ahk_class Notepad")
  || WinActive("ahk_class XLMAIN")
  || WinActive("ahk_class Chrome_WidgetWin_1")
  || WinActive("ahk_class TextEditorWindowW166") {
    return
  }
  Send,{Blind}{F1}
  return
vk1D & 2::Send,{Blind}{F2}
vk1D & 3::Send,{Blind}{F3}
vk1D & 4::Send,{Blind}{F4}
vk1D & 5::Send,{Blind}{F5}
vk1D & 6::Send,{Blind}{F6}
vk1D & 7::Send,{Blind}{F7}
vk1D & 8::Send,{Blind}{F8}
vk1D & 9::Send,{Blind}{F9}
vk1D & 0::Send,{Blind}{F10}
vk1D & -::Send,{Blind}{F11}
vk1D & ^::Send,{Blind}{F12}

;メモ帳,excel,chrome,sakuraエディタではF1キー無効化
F1::
  if WinActive("ahk_class Notepad")
  || WinActive("ahk_class XLMAIN")
  || WinActive("ahk_class Chrome_WidgetWin_1")
  || WinActive("ahk_class TextEditorWindowW166") {
    return
  }
  Send {F1}
  return

^#o:: ; Windows + ctrl + o (スクリーンキーボード)を無効化
Return

;Excelでalt+p => ctrl+PageUp
!p::
  if WinActive("ahk_class XLMAIN") {
    Send ^{pgup}
  }
  return
;Excelでalt+: => ctrl+PageDown
!vkBB::
  if WinActive("ahk_class XLMAIN") {
    Send ^{pgdn}
  }
  return
;Excel VBEでctrl+k => 自動構文チェックon/off切り替え
;powershell上でctrl+k => ctrl+End
^k::
  if WinActive("ahk_class wndclass_desked_gsk") {
    Send !t
    Send +o
    Send +k
    Send {Enter}
  } else if WinActive("ahk_exe pwsh.exe") or (WinActive("ahk_exe WindowsTerminal.exe") and WinActive("PowerShell")) {
    Send ^{End}
  } else {
    Send ^k
  }
  return

;powershell上でctrl+a => Home
^a::
  if WinActive("ahk_exe pwsh.exe") or (WinActive("ahk_exe WindowsTerminal.exe") and WinActive("PowerShell")) {
    Send {Home}
  } else {
    Send ^a
  }
  return

;メモ帳で ctrl+w => alt+F4
;桜エディタで ctrl+w => ctrl+F4
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

;eclipseでAlt+h => Alt+左
!h::
  if WinActive("ahk_class SWT_Window0") {
    Send !{Left}
    return
  }
  Send !h
  return
;eclipseでAlt+l => Alt+右
!l::
  if WinActive("ahk_class SWT_Window0") {
    Send !{Right}
    return
  }
  Send !l
  return

;右Win => Alt
vk5C::vkA4

;ctrl+";" => BackSpace
^vkBB::
  if WinActive("ahk_exe EXCEL.EXE") {
    Send ^{vkBB}
    return
  }
  Send {BackSpace}
  return

;chrome上で ctrl+":" => alt+→
^vkBA::
  if WinActive("ahk_exe chrome.exe") {
    Send !{Right}
    return
  }
  Send ^{vkBA}
  return

;chrome上でctrl+"-"による縮小無効化
^vkBD::
  if WinActive("ahk_exe chrome.exe") {
    return
  }
  Send ^{vkBD}
  return

;変換+ctrl+d => Downloadフォルダを開く
vk1C & d::
  if GetKeyState("ctrl", "P") {
    if WinActive("ahk_class CabinetWClass") || WinActive("ahk_class #32770") {
      Send ^l
      path = C:\Users\%A_UserName%\Downloads
      PasteString(path)
      Send {Enter}
    } else {
      Run, C:\Users\%A_UserName%\Downloads
    }
  }
  return

;Explorerでctrl+d => ファイル/フォルダ一覧へフォーカス
;visual studio codeのフォルダを開くダイアログでも動作
^d::
  if WinActive("ahk_class CabinetWClass") {
    ; エクスプローラー
    ControlGet ctrlVisible, Visible,, DirectUIHWND3
    ControlFocus, DirectUIHWND2
    return
  } else if WinActive("ahk_class #32770") {
    ; "フォルダを開く"などのウィンドウ
    ControlFocus, DirectUIHWND2
    return
  }
  Send ^d
  return

;変換+c => Chrome起動
vk1C & c::
  If FileExist("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") {
    Run , C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
  } else {
    Run , C:\Program Files\Google\Chrome\Application\chrome.exe
  }
  return

;変換+t => Windows Terminal起動
vk1C & t::
  Run , C:\Users\%A_UserName%\AppData\Local\Microsoft\WindowsApps\wt.exe
  return

;変換+i => ctrl+win+左 (左の仮想ディスプレイへ移動)
vk1c & i::Send ^#{Left}
;変換+o => ctrl+win+右 (右の仮想ディスプレイへ移動)
vk1c & o::Send ^#{Right}

;変換+ctrl+s => systemのプロパティ
vk1C & s::
  if GetKeyState("ctrl", "P") {
    Send #{Pause}
  }
  return

;無変換+s => shift+F10(右クリック)
vk1D & s::Send +{F10}

;変換+j => win+上
vk1C & j::Send #{Up}
;変換+m => win+下
vk1C & m::Send #{Down}

;変換+space => スクリプトリロード
vk1C & vk20::Reload

;ctrl+vで張り付け(cygwin用)
;パスをコピペする時に \  =>  / に変換して貼り付け
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

;ctrl+shift+vでパスを変換して張り付け(Windows Terminal用)
#If WinActive("ahk_exe WindowsTerminal.exe")
^+v::
  sendStr := Clipboard
  num := RegExMatch(sendStr, "^[a-zA-Z]:\\")
  if(num = 1) {
    out = "$(wslpath "%sendStr%")"
    PasteString(out)
  } else {
    PasteString(sendStr)
  }
  return
#IfWinActive

;ctrl+vで張り付け(コマンドプロンプト用)
#If WinActive("ahk_exe cmd.exe")
^v::
  Send !{Space}ep  ;貼り付け
  return
#IfWinActive

;-------------------------------------------------------------------;
; Returns the maximum or minimum value for any number of inputs
; i.e. Max(5,4,7,10) will return 10
;-------------------------------------------------------------------;
Min(params*)
{
  r := params[1]
  for index, param in params
    if (param < r)
      r := param
  return r
}
Max(params*)
{
  r := params[1]
  for index, param in params
    if (param > r)
      r := param
  return r
}

;-------------------------------------------------------------------;
; WindowsKey+Ctrl+Up / WindowsKey+Ctrl+Down
; Resizes window to half the screen height and moves it to the top
; or bottom of whichever screen has the largest overlap.
; By default, the window retains its horizontal (x) position and
; width.  To change this, uncomment the WinMaximize line.
;-------------------------------------------------------------------;
UpDownSnap(Direction)
{
  WinGetPos, x, y, w, h, a, , ,
  SysGet , Count, MonitorCount
  refArea := 0
  if (x < 0) {
    x := 0
  }
  if (y < 0) {
    y := 0
  }
  Loop, %count%
  {
    SysGet, m, MonitorWorkArea, %A_Index%
    xo := Max(0, Min(x + w, mRight) - Max(x, mLeft))
    yo := Max(0, Min(y + h, mBottom) - Max(y, mTop))
    area := xo * yo
    if (area > refArea)
    {
      monTop := mTop
      monBottom := mBottom
      monLeft := mLeft
      monRight := mRight
      refArea := area
    }
  }

  ; If the refArea is still equal to 0, the window does
  ; not overlap with any monitors. Wat?
  if (refArea > 0)
  {
    if (direction = 1)
      newY := monTop
    Else
      newY := (monBottom - monTop) / 2 + monTop

    ; chromeではウィンドウ下と左右に-12pxのマージンがあるのでその分増やして設定
    If WinActive("ahk_exe chrome.exe") {
      WinMove , A, , monLeft-12, newY, (monRight - monLeft)+24, (monBottom - monTop) / 2 + 12
      return
    }

    WinMove , A, , monLeft, newY, (monRight - monLeft), (monBottom - monTop) / 2
  }
}
^#Up::UpDownSnap(1)
^#Down::UpDownSnap(0)

;;;;;;bootcamp対応;;;;;;

;無変換+e => 英語
vk1D & e::
  IME_SET(0)
  return

;変換+l => 日本語
vk1C & l::
  ; chrome上でうまく動かない場合があるので応急措置
  IME_SET(0)

  IME_SET(1)
  return

;IME_SET(0) -> 英数
;IME_SET(1) -> かな
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
        , UInt, 0x0283 ;Message : WM_IME_CONTROL
        , Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
        , Int, SetSts) ;lParam  : 0 or 1
}

;無変換+d => delete
vk1D & d::
  Send {Delete}
  return

;無変換+q => alt+F4
;alt+F2  => alt+F4
vk1D & q::
!F2::
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
  } else if WinActive("ahk_exe WindowsTerminal.exe") {
    Send +^v
  } else {
    Send ^v
  }
  Sleep,125
  Clipboard := Backup
}
