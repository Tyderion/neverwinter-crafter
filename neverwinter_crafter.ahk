task := [ 0, 0]
task_offset := [0,0]
todo := [0,0]
search := [0,0]
start := [0, 0]
OK_button := [0, 0]
asset := [0, 0]
person := [0, 0]
leather := [0, 0]
overview := [0, 0]

todo_config := [0, 0]
person_offset := [0,0]

asset_offset := [110,45]
firstrun = true

Menu, Tray, Icon, Neverwinter_114.ico

names := ["task", "task_offset", "todo", "search", "start", "OK_button", "asset", "person", "leather", "overview",  "todo_config", "person_offset", "asset_offset"]
defaults := ["870,380", "200,140", "1335,435", "1285, 1000", "770, 770", "770,770", "850,390", "980,450", "625,375", "625,260", "gather simple pelts,3", "0,45", "110, 40"]
length := 13


special_names := ["task_offset", "asset_offset", "person_offset", "todo_config"]
special_length := 4



class Preset
{
  name := "A Preset"
  config := []
  config_length := 0

  __New(fromString)
  {
    StringSplit, name_val, fromString, :
    this.name := name_val1
    StringSplit, steps, name_val2, `;
    this.config := []
    Loop, %steps0%
      if (steps%a_index% != "")
      {
        this.config_length++
        conf := []
        StringSplit, conf, steps%a_index%, `,
        this.config[a_index] := {where:conf1,search:conf2,number:conf3}
      }
  }

  toString()
  {
    str := this.name . ":"
    For index, val in this.config
    {
      if (index > 1 && index <= this.config_length)
        str := str . ";"
      str := str . val["where"] . "," . val["search"] . "," . val["number"]
    }
    return str
  }
}

class Configuration
{

  static coord_names := ["task_button",  "continue_button", "search_field", "start_button", "OK_button", "person_button", "leathermaking_button", "overview_button"]

  ;static default_coords := ["870,380",  "1335,435", "1064,253", "1285,998", "751,786", "986,443", "640,369", "357,363"]

  static offset_names := ["task_offset", "person_offset", "job_offset"]
  ;static default_offsets :=[] "200,140", "0,45", "110, 40"]

  static other_names := ["preset"]

  __New(filename = "neverwinter_crafter_new.ini")
  {
    this["filename"] := filename
    For index, value in Configuration.coord_names
      this[value] := [0,0]
    For index, value in Configuration.offset_names
      this[value] := [0,0]
    For index, value in Configuration.other_names
      if (value = "presets")
        this[value] := []
  }

  save()
  {

    For key, value in this ; Save Coordinates
      If RegExMatch(key, "button|field|offset")
        IniWrite, % value[1] . "," . value[2], % this.filename, MainConfig, % key

    For index, preset in this.presets ; Save presets
      IniWrite,% preset.toString(), % this.filename, Presets, % "preset" . a_index-1
  }

  showConfig()
  {
    str := ""
    For key, value in this ; Append the coordinates
      If RegExMatch(key, "button|field|offset")
        str := str . key . "=" . value[1] . "," . value[2] . "`n"

    For index, val in this.presets ; Append each preset-Object
      str := str . "preset" . a_index-1 . "= " . val.toString() . "`n"

    MsgBox % str
  }

  load(filename = "neverwinter_crafter_new.ini")
  {
    this["filename"] := filename
    For index, key in Configuration.coord_names
    {
      IniRead, value, % filename, MainConfig, % key
      StringSplit, test, value , `, ,
      this[key] := [test1, test2]
    }

    For index, key in Configuration.offset_names
    {
      IniRead, value,% filename, MainConfig,% key
      StringSplit, test, value , `, ,
      this[key] := [test1, test2]
    }

    For index, key in Configuration.other_names
    {
      if InStr(key, "preset")
      {
        ; Grab all entries under the Presets Section
        IniRead, value,% filename, Presets
        ; Split the entries at new lines
        StringSplit, presetArray, value, `n
        this["presets"] := []
        ; For each entry
        Loop, %presetArray0%
        {
            StringSplit, preset, presetArray%a_index%, =
            this.presets[a_index] := new Preset(preset2)
        }
      }
    }

  }

}

test := new Configuration()
test.showConfig()
test.load()
test.showConfig()
test.save()
;For index, value in Configuration.coord_names
;{
  ;MsgBox % "outside: " . value . "=" . test[value][1] . "," . test[value][2]
;}



configuring := [["task", "absolute"], ["task_offset", "relative"]]
current_configuring := 0
offset_config := "horizontal"

Hotkey, F12,, Off

ResetChoice := ""

str := ""
Loop, %length%
{
  name := names[A_Index]
  If (name != "person_offset" && name != "asset_offset" && name != "task_offset" && name != "todo_config")
  {
    str := str . names[A_Index]
    if (A_Index < length)
    {
      str := str . "|"
    }
  }
}

Gui, Add, Text,, Plese select the coordinates you want to reset.
Gui, Add, DropDownList, vResetChoice Sort Choose1, %str%
Gui, Add, Button, Default, OK
str = ""



LoadConfig()
SaveConfig()
return

; Labels and stuff
ButtonOK:
  Gui, Submit
  MsgBox %ResetChoice%
  %ResetChoice% := [0,0]
  TestConfig()
  return ; End TEH Label

GuiEscape:
  Gui, Cancel
  return

EnsureActiveWindow()
{
  If (WinExist("ahk_class CrypticWindowClassDX0"))
  {
    If (!WinActive("ahk_class CrypticWindowClassDX0"))
    {
      WinActivate ahk_class CrypticWindowClassDX0
      WinWaitActive  ahk_class CrypticWindowClassDX0
    }
  }
}

Configure2()
{
  global
  EnsureActiveWindow()
  name := names[current_configuring]
  MouseGetPos, x, y

  if (name != "task_offset" && name != "person_offset" && name != "asset_offset")
  {
    %name%[1] := x
    %name%[2] := y
    MsgBox, % "Successfully configured " . name ;. " as : " . %name%[1] . "," . %name%[2]
    If (name == "task")
    {
      ConfigureTaskOffset()
      return
    }
    If (name == "person")
    {
      offset_config := "vertical"
      ConfigurePersonOffset()
      return
    }
    ;SaveConfig()
    ;TestConfig()
  } else {
    if (name == "person_offset")
    {
      var := "person"
    } else
    {
      var := "task"
    }
    if (offset_config == "horizontal")
    {
      %name%[1] := Abs(%var%[1] - x)
      offset_config := "vertical"
      ConfigureTaskOffset()
      return
    }
    else if (offset_config == "vertical")
      {
        if (name == "person_offset")
        {
          %name%[1] := 0
        }
        %name%[2] := Abs(%var%[2] - y)
      }
    MsgBox, % " Successfully configured " . var " Offset"
  }
    SaveConfig()
    TestConfig()

}

ConfigureTaskOffset()
{
  global task_offset, task, offset_config

  MsgBox, % "Moving mouse to the location of the task button"
  ClickSmooth(task,0)
  MsgBox, % "Moving mouse to the projected location of the next " . offset_config . " task button"
  if (offset_config == "horizontal" )
    task_two := [task[1]+task_offset[1], task[2]]
  else if (offset_config == "vertical")
    task_two := [task[1], task[2]+task_offset[2]]
  ClickSmooth(task_two,0)
  MsgBox, 4, Correct? , Is the mouse on the same position (relative to the button) as on the first task?
  IfMsgBox No
    {
      current_configuring := 2
      MsgBox, Move,  Please move the mouse to the correct Position and press F12
      Hotkey, F12,, On
    }
}
ConfigurePersonOffset()
{
  global person_offset, person, offset_config

  MsgBox, % "Moving mouse to the location of the first Person button"
  ClickSmooth(person,0)
  MsgBox, % "Moving mouse to the projected location of the next " . offset_config . " person button"
  if (offset_config == "vertical")
    task_two := [person[1], person[2]+person_offset[2]]
  ClickSmooth(task_two,0)
  MsgBox, 4, Correct? , Is the mouse on the same position (relative to the button) as on the first task?
  IfMsgBox No
    {
      current_configuring := 13
      MsgBox, Move,  Please move the mouse to the correct Position and press F12
      Hotkey, F12,, On
    }
}


Reset()
{
  global
  task := [ 0, 0]
  todo := [0,0]
  search := [0,0]
  start := [0, 0]
  OK_button := [0, 0]
  asset := [0, 0]
  person := [0, 0]
  leather := [0, 0]
  overview := [0, 0]

  todo_config := ["gather simple pelts", 0]
  task_offset := [200,140]
  person_offset := [0,45]
}

TestConfig()
{
  global
  Loop, %length%
  {
    name := names[A_Index]
    value := %name%[1] . "," %name%[2]
    ;MsgBox, % name . ": " . value
    If (%name%[1] == "ERROR" or value == "0,0")
    {
      current_configuring = %A_index%
      name := names[current_configuring]
        If (name == "todo_config")
      {
        InputBox, search, Searchstring, % "What should be build (== searched) ?"
        todo_config[1] := search
        InputBox, search, How many, % "How many should be built?"
        todo_config[2] := search
      }
      else If (name != "task_offset" && name != "person_offset")
      {
        current_configuring = %A_index%
        MsgBox, % "Please move your mouse to the " . name . " button and then Press F12"
        Hotkey, F12, , On
        return false
      }
    }
  }
  SaveConfig()
  ;return true
}

LoadConfig()
{
  global
  Loop, %length%
  {
    name := names[A_Index]
    IniRead, value,  neverwinter_crafter.ini, MainConfig, %  name ;, % defaults[A_Index]
    ;MsgBox, % name . ": " . value
    StringSplit, test, value , `, ,
    %name%[1] := test1
    %name%[2] := test2
  }

  IniRead, firstrun, neverwinter_crafter.ini, MainConfig, firstrun
  firstrun := firstrun == "false" ? false : true
  If (firstrun)
  {
    MsgBox, % "Press F5 with an open crafting window to craft."
  }
}


Test()
{
  global
    str := "Configuration:`n"
    Loop, %length%
    {
      name := names[A_Index]
      str := str . "  " . name . ": " . %name%[1] . "," . %name%[2] . "`n"
    }
    MsgBox %str%
}
SaveConfig()
{
  global
  Loop, %length%
  {
    name := names[A_Index]
    value := %name%[1] . "," . %name%[2]
    IniWrite, % value, neverwinter_crafter.ini, MainConfig, %name%
  }
  IniWrite, false, neverwinter_crafter.ini, MainConfig, firstrun
}

ClickSmooth(target, num = 1)
{
  MouseMove, target[1], target[2], 20
  if (num == 1)
  {
    Click down
    Sleep, 100
    Click up
  }
  return true
}


AskItem()
{
  global todo_config ;todo_string, todo_number
  EnsureActiveWindow()
  MsgBox,3, Producing, % "Do you want to " . todo_config[1] . "?"
  IfMsgBox Cancel
    return false
  IfMsgBox No
    InputBox, val , % "Searchstring", % "What do you want to build (search)?",,,,,,,,% todo_config[1]
    If ErrorLevel
      return false
    todo_config[1] := val
    InputBox, val,% "How many?", % "How many times do you want to " . todo_config[1] . "?"
    If ErrorLevel
      return false
    todo_config[2] := val
    If (todo_config[2] < 1)
      return false

  SaveConfig()
  return true
}

Search()
{
  global
  ClickSmooth(leather)
  Sleep, 200
  ClickSmooth(search)
  MsgBox, % "Clicked on search"
  Sleep, 200
  Send ^a
  Sleep, 200
  val := todo_config[1]
  Send {raw}%val%
  Sleep, 200
  Send {Enter}
}

BuildItems(number)
{
  global
  ClickSmooth(overview)
  MsgBox Wait
  Loop, %number%
  {
      local index := [Floor(Mod(A_Index-1,3)),Floor((A_Index-1)/3)]
      local coord = [0,0]
      coord[1] := task[1]+index[1]*task_offset[1]
      coord[2] := task[2]+index[2]*task_offset[2]
      local pcoord = [0,0]
      pcoord[1] := person[1]
      pcoord[2] := person[2]+(A_Index-1)*person_offset[2]

      ;MsgBox, % "Task: " . task[1] . "," . task[2] . " - Coord: " . coord[1] . "," . coord[2]
      MsgBox, % "PersonCoord: " . pcoord[1] . "," . pcoord[2] . " - Person: " . person[1] . "," . person[2]
      ClickSmooth(coord)
      Sleep, 200
      ClickSmooth(todo)
      Sleep, 200
      FillAssets(1)
      ;ClickSmooth(asset)
      ;Sleep, 200
      ;ClickSmooth(pcoord)
      Sleep, 200
      ClickSmooth(start)
      loopvar++
    Sleep, 200
  }
}

AskFinished()
{
  global overview,task, task_offset, OK_button, number
  MsgBox,4, % "Finished?", % "Do crafting goods need collecting?"
  IfMsgBox Yes
  {
    InputBox, number, % "How many are finished?", % "How many task slots are finished? (only linear possible)"
    If ErrorLevel
      return false
    else
    {
      EnsureActiveWindow()
      ClickSmooth(overview)
      loopvar := 0
      Loop, %number%
      {
          index := [Floor(Mod(A_Index-1,3)),Floor((A_Index-1)/3)]
          coord := [task[1]+index[1]*task_offset[1],task[2]+index[2]*task_offset[2]]
          ;MsgBox, % "Task: " . task[1] . "," . task[2] . " - Coord: " . coord[1] . "," . coord[2]
          if (ClickSmooth(coord )) {
            ClickSmooth(OK_button)
          }
          ;
          loopvar++
      }
    }
  }
}

TestOutputVar(ByRef output,input = 1)
{
  output := input*3
}


TestClicks() {
  global
  Loop, 10
  {
    ClickSmooth(overview)
    Sleep, 150
    ClickSmooth(leather)
    Sleep, 150
  }
}


SearchAsset(topleft)
{
  ImageSearch, posi, posj,topleft[1],topleft[2],1920,1200,*16 asset_button.png
  array := [posi+15, posj+5]
  return array
}
FillAssets(num)
{
  global asset_offset
  ;MsgBox, % asset_offset
  if (num < 1)
    {
      return
  }
  topleft := [0,0]

  Loop, %num%
  {
    EnsureActiveWindow()
    position := SearchAsset(topleft)
    ;MsgBox, % "position = " . position[1] . "," . position[2] . "Offset = " . asset_offset[1] . "," . asset_offset[2]

    ClickSmooth(position,1)
    ClickSmooth([ position[1]+asset_offset[1], position[2]+asset_offset[2]], 1)

    if (A_Index == 1)
      topleft := [0, position[2]+asset_offset[2]]
    else
      topleft := [position[1], topleft[2]]

    ClickSmooth(topleft,1)
    MsgBox, "At Topleft"

  }



}



F12::
  Hotkey, F12,, Off
  Configure2()
  return
F10::
  ;SearchAsset([0,0])
  FillAssets(4)
  return
F9::
  Gui, Show,,Reset Coordinate
  return
;
;F7::
;  WinActivate ahk_class CrypticWindowClassDX0
;  return

#IfWinActive ahk_class CrypticWindowClassDX0
;  F8::
;    SaveConfig()
;    return
;
;
;  F9::
;    TestClicks()
;    return

  ^+F4::
    MsgBox, 4, Reset, % "Do you want to reset and reconfigure all the saved values?"
    IfMsgBox Yes
      {
        Reset()
        SaveConfig()
        TestConfig()
      }


  ;F4::
    ;BuildItems(todo_config[2])

;  F6::
;    AskItem()
;    Search()
;    return
  F5::
    If (TestConfig()) {
      AskFinished()
      EnsureActiveWindow()
      ;MsgBox, % WinActive("ahk_class CrypticWindowClassDX0")
      If (AskItem())
      {

        Search()
        MsgBox % todo_config[2]
        BuildItems(todo_config[2])

      }
    }

#IfWinActive
RControl & Enter::ShiftAltTab
