#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; macro hotkeys
#If WinActive("Minecraft*") && WinActive("ahk_exe javaw.exe")
{
   U::
   Reset()
   Setup()
   Move()
   return

   ^J::
   ResetUsingLan()
   return

   ^P::
   Widen()
   return

   ^L::
   Tallen()
   return
}

#If WinExist("Minecraft") && WinExist("ahk_exe javaw.exe")
{
   F5::Reload
}
