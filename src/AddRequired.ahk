#SingleInstance force
#Requires Autohotkey v1.1.33+
;--
;@Ahk2Exe-SetVersion 1.0-alpha.2
;@Ahk2Exe-SetProductName addRequired
;@Ahk2Exe-SetDescription Adds requirement to all ahk files in the selected folder recursively
/**
 * ============================================================================ *
 * @Author           :RaptorX                                                   *
 * @Homepage         :                                                          *
 *                                                                              *
 * @Created          :July 26, 2022                                             *
 * @Modified         :July 26, 2022                                             *
 *                                                                              *
 * @Description      :                                                          *
 * -------------------                                                          *
 * Adds requirement to all ahk files in the selected folder recursively         *
 * ============================================================================ *
 * License:                                                                     *
 * Copyright ©2022 RaptorX <GPLv3>                                              *
 *                                                                              *
 * This program is free software: you can redistribute it and/or modify         *
 * it under the terms of the **GNU General Public License** as published by     *
 * the Free Software Foundation, either version 3 of the License, or            *
 * (at your option) any later version.                                          *
 *                                                                              *
 * This program is distributed in the hope that it will be useful,              *
 * but **WITHOUT ANY WARRANTY**; without even the implied warranty of           *
 * **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**.  See the        *
 * **GNU General Public License** for more details.                             *
 *                                                                              *
 * You should have received a copy of the **GNU General Public License**        *
 * along with this program. If not, see:                                        *
 * <http://www.gnu.org/licenses/gpl-3.0.txt>                                    *
 * ============================================================================ *
 */

;{#Includes
 #Include <ScriptObject\ScriptObject>
 global script := {base         : script
                  ,name          : regexreplace(A_ScriptName, "\.\w+")
                  ,version      : "1.0-alpha.2"
                  ,author       : "RaptorX"
                  ,email        : ""
                  ,crtdate      : "July 26, 2022"
                  ,moddate      : "July 26, 2022"
                  ,homepagetext : ""
                  ,homepagelink : ""
                  ,donateLink   : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
                  ,resfolder    : A_ScriptDir "\res"
                  ,iconfile     : A_ScriptDir "\res\sct.ico"
                  ,configfile   : A_ScriptDir "\settings.ini"
                  ,configfolder : A_ScriptDir ""}

;}

try script.Update("https://raw.githubusercontent.com/RaptorX/AddRequired/master/ver"
                 ,"https://github.com/RaptorX/AddRequired/releases/download/latest/AddRequired.zip")
Catch err
	if err.code != 6
		MsgBox % err.msg

FileSelectFolder, wDir, *%A_ScriptDir%
if !wDir
{
	MsgBox, % "No directory selected"
	ExitApp
}

Gui, add, Edit, w200 vRequirement, % "#Requires Autohotkey v1.1.33+"
Gui, add, Button, x+5 w75, % "Okay"
Gui, Show
return

ButtonOkay(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
{
	Loop, Files, %wDir%\*.ahk, FDR
	{
		FileRead, wFile, %A_LoopFileFullPath%
		if InStr(wFile, "#Requires")
		{
			OutputDebug, % "true"
			Continue
		}

		hFile := FileOpen(A_LoopFileFullPath, "w")
		hFile.Seek(0, 0)
		hFile.Write(Requirement "`n" wFile)
		OutputDebug, % "fixed " A_LoopFileName
	}
	ExitApp
}

GuiClose()
{
	ExitApp
}