;;
;; AutoHotkey Version: 2.x
;; Language:       English
;; Platform:       WinNT
;; Author:         WuJunyu <vistar_w@hotmail.com>

;; Script Function:
;; Provides an Emacs-like keybinding emulation mode that can be toggled
;; on and off using the CapsLock key.



;;
;; Init
;;
#NoEnv

SendMode Input
SetWorkingDir %A_ScriptDir% ;; 设置初始目录一致

enabledIcon := "vwiss-emacs-32.ico"
disabledIcon := "vwiss-emacs-disable-32.ico"

IsEmacsMode := true
IsMarkMode := false
IsReMapping := false

#Include vwiss-emacs-func.ahk

SetEmacsMode(true)
SetMarkMode(false)


;; 匹配按键
#If !FilterModes()


   ;; Emacs mode toggle
   $!F1::
   ToggleEmacsMode()
   return

   ;; Mark mode toggle
   $^Space::
   Mark()
   return

   ;; Cancel Command
   $^g::
   Quit()
   return

   ;; Character navigation
   $^p::
   $^q::
   PreviousLine("^p")
   return
   $^n::NextLine("^n")
   return
   $^f::
   ForwardChar("^f")
   return
   $^b::
   BackwardChar("^b")
   return


   ;; Word Navigation
   $!f::
   ForwardWord("!f")
   return
   $!b::
   BackwardWord("!b")
   return

   ;; Navigation
   $^a::
   BeginOfCodeOrLine("^a")
   return
   $^e::
   EndOfCodeOrLine("^e")
   return

   ;; Page Navigation
   $^v::
   ScrollUp("^v")
   return
   $!v::
   ScrollDown("!v")
   return
   $!<::
   BeginOfBuffer("!<")
   return
   $!>::
   EndOfBuffer("!>")
   return

   ;; Undo
   $^/::
   Undo("^/")
   return

   ;; Close Tab
   $^+w::
   CloseTab("^+w")
   return

   ;; Killing and Deleting
   $^d::
   DeleteForward("^d")
   return
   $!d::
   KillWord("!d")
   return

   $^k::
   KillLine("^k")
   return

   $!w::
   KillRingSave("!w")
   return

   $^y::
   Yank("^y")
   return
   $^r::
   Recovery("^r")
   return
   $^w::
   KillRegion("^w")
   return

   ;; Search
   $^s::
   ISearch("^s")
   return
   ; $^s::KeyMapping("^s","{F3}") ;find
   ; $^r::KeyMapping("^r","{Shift}+{F3}") ;reverse

   ;; Window Display
   $^!x::
   MaximizeFrame("")
   return

   $^!s::
   RecoveryFrame("")
   return

   $~^z::
   return

   ;; Save or Kill or all select ...
   $^x::
   Suspend, On  ; 挂起热键
   Critical  ; 防止被其他线程中断

   SetMarkMode(false)

   Input, SubKeyInput, L1 M  ; 等待用户输入 L1：限制输入字符长度 M：转译 Ctrl-A ~ Ctrl-z

   SubKey := TransformSubKey(SubKeyInput)

   if(Subkey == "^g") {

	   CancelCommand("")
	   return
   }

   if(SubKey == "^s") {

	   SaveBuffer("^x^s")
   } else if(SubKey == "^c"){

	   ExitProcess("^x^c")
   } else if(SubKey == "h") {

	   MarkWholeBuffer("^x+h")
   } else {

	   Send, "^x"
   }

   Suspend, Off
   return