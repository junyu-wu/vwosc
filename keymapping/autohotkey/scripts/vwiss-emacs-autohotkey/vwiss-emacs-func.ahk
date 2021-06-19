;;
;; AutoHotkey Version: 2.x
;; Language:       English
;; Platform:       WinNT
;; Author:         WuJunyu <vistar_w@hotmail.com>

;; Script Function:
;; Provides an Emacs-like keybinding emulation mode that can be toggled
;; on and off using the CapsLock key.



;;
;; Filter
;;
FilterModes() {

	;; Disable Emacs Keys for the following programs:
	; GroupAdd, NotActiveGroup, ahk_class mintty ;, ahk_exe foo.exe, etc..
	if WinActive("ahk_class Emacs") {

		return true
	}

	return IsEmacsMode
}

FilterApps(ByRef curKey, ByRef toKey, ByRef toSubKey){

	if WinActive("ahk_class MozillaUIWindowClass"){

        if(curKey = "^s")
            toKey = ^f

        if(emacskey = "^r")
            toKey = ^f
        }

    if WinActive("ahk_class Chrome_WidgetWin_1"){

        if(curKey = "^s")
            toKey = ^f

        if(curKey = "^r")
			toKey = {SHIFTDOWN}{F3}{SHIFTUP}

		if(curKey = "^w")
			toKey = ^w
	}

	return 1
}


;;
;; Func
;;
;; 设置模式状态
SetEmacsMode(toActive) {

	; global IsEmacsMode
    local iconFile := toActive ? enabledIcon : disabledIcon
    local state := toActive ? "ON" : "OFF"

    IsEmacsMode := toActive

    ;TrayTip, Emacs Everywhere, Emacs mode is %state%, 10, 1
    Menu, Tray, Icon, %iconFile%,
    Menu, Tray, Tip, Vwiss Emacs AutoHotKey`nEmacs mode is %state%

    Send {Shift Up}
}

;; 按键转换
KeyMapping(Key, toKey, toSubKey="") {

    global IsEmacsMode
    global IsMarkMode

    ;; 如果是 Mark 模式，模拟 Shift
	if(IsMarkMode){

        toKey := "+" . toKey
	}

	if(IsEmacsMode) {

		FilterState := FilterApps(Key, toKey, toSubKey)

		if(Key == "" OR FilterState == -1) {

			OutputDebug, "Key is null or Filter error"

			return
		} else if(FilterState == 1) {

			OutputDebug, KeyMapping : %Key% to %toKey%

			Send, %toKey%

			if(toSubKey <> "") {

				OutputDebug, "toSubKey is not null, toSubKey is: " %toSubKey%

				Send, %Key%
			}
		}
	} else {

		OutputDebug, Dont't Mapping

		Send, %Key%
	}

	OutputDebug, "KeyMapping DONE"

    return
}

;; 获取按键重新映射状态
GetRemapping() {

	global IsRemapping

	return IsRemapping
}

;; 设置按键重新映射状态
SetRemapping(state) {

	global IsRemapping

	IsRemapping := state

	OutputDebug, "Remapping is: " %state%
}

;; 快捷键函数
;; 模式开关
EmacsMode(toActive) {

	global IsEmacsMode

	IsEmacsMode := toActive
}

;; 切换模式
ToggleEmacsMode() {
	if(IsMarkMode){

	   SetEmacsMode(false)
	   SetMarkMode(false)
   }else{

	   SetEmacsMode(true)
	   SetMarkMode(false)
   }
}

;; 获取Mark状态
GetMarkModeContent() {

   Clipboard =
   ; Send, ^c ; simulate Ctrl+C
   ClipWait 0.1

   selected := Clipboard

   return selected
}

;; 设置Mark状态
SetMarkMode(toActive) {

    global IsMarkMode

    IsMarkMode := toActive

    OutputDebug, "SELECT MODE: " %toActive%
}

Mark() {

	SetMarkMode(true)
	return
}

TransformSubKey(curInput) {
	; Input, SubKeyInput, L1 M  ; 等待用户输入 L1：限制输入字符长度 M：转译 Ctrl-A ~ Ctrl-z
	; Transform, AsciiCode, Asc, %SubKeyInput% ;; 转换 Subkey 的 Ascii 值
	Transform, AsciiCode, Asc, %curInput%

	;; 转换 Ctrl + a ~ z 的 Ascii 值 并重新赋值为 ^ + a ~ z
	if(AsciiCode <= 26){

		AsciiCode += 96

		Transform, CtrlLetter, Chr, %AsciiCode%

		SubKey = ^%CtrlLetter%
	} else {

		SubKey = %curInput%
	}

	return SubKey
}

;; 取消当前命令
Quit() {

	global IsMarkMode

	if(!IsMarkMode){

	   IfWinActive ahk_class MUSHYBAR
	   {
         Send, !{F4}
	   }
   } else {

	   SetMarkMode(false)
   }

   OutputDebug, "ESC"
   Send, {Esc}

   return
}

ForwardChar(curKey) {

	KeyMapping(curKey, "{Right}")
	return
}

ForwardWord(curKey) {

	KeyMapping(curKey, "^{Right}")
	return
}

BackwardChar(curKey) {

	KeyMapping(curKey, "{Left}")
	return
}

BackwardWord(curKey) {

	KeyMapping(curKey, "^{Left}")
	return
}

PreviousLine(curKey) {

	KeyMapping(curKey, "{Up}")
	return
}

NextLine(curKey) {

	KeyMapping(curKey, "{Down}")
	return
}

BeginOfCodeOrLine(curKey) {

	KeyMapping(curKey, "{Home}")
	return
}

EndOfCodeOrLine(curKey) {

	KeyMapping(curKey, "{End}")
	return
}

ScrollUp(curKey) {

	KeyMapping(curKey, "{PgDn}")
	return
}

ScrollDown(curKey) {

	KeyMapping(curKey, "{PgUp}")
	return
}

BeginOfBuffer(curKey) {

	KeyMapping(curKey, "^{Home}")
	return
}

EndOfBuffer(curKey) {

	KeyMapping(curKey, "^{End}")
	return
}

Undo(curKey) {

	KeyMapping(curKey, "^z")
	return
}

DeleteForward(curKey) {

	SetMarkMode(false)
	KeyMapping(curKey,"{Delete}")
	return
}

KillWord(curKey) {

	SetMarkMode(true)
	Send, ^+{Right}
	Send, {Delete}
	SetMarkMode(false)
	return
}

KillLine(curKey) {

	SetMarkMode(false)

	selection := GetMarkModeContent()

	if(selection <> ""){

		; Send, ^x
		KeyMapping(curKey, "^x")
	}
	else{

		Send, +{End}
		Send, ^x
	}

	return
}

KillRingSave(curKey) {

	KeyMapping(curKey, "^c")
	SetMarkMode(false)
	return
}

KillRegion(curKey) {

	KeyMapping(curKey, "^x")
	SetMarkMode(false)
	return
}

Yank(curKey) {

	KeyMapping(curKey, "^v")
	return
}

Recovery(curKey) {

	KeyMapping(curKey, "^y")
	return
}

ISearch(curKey) {

	KeyMapping(curKey, "^f")
	return
}

ISearchForward(curKey) {

	KeyMapping(curKey, "{F3}")
	return
}

ISearchBackwrard(curKey) {

	KeyMapping(curKey, "+{F3}")
	return
}

CancelCommand(curKey) {

	; Suspend, Off
	return
}

MaximizeFrame(curKey) {

	WinMaximize, A
	return
}

MinimizeFrame(curKey) {

	WinMinimize, A
	return
}

RecoveryFrame(curKey) {

	WinRestore, A
	return
}

SaveBuffer(curKey) {

	KeyMapping(curKey, "^s")
	return
}

ExitProcess(curKey) {

	KeyMapping(curKey, "!{F4}")
	return
}

MarkWholeBuffer(curKey) {

	KeyMapping(curKey, "^a")
	return
}

CloseTab(curKey) {

	KeyMapping(curKey, "^w")
	return
}
