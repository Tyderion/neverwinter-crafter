
; Gather Simple Pelts

;task := [ 870, 380]
task := [ 0, 0]
task_offset := [200,140]
todo := [0,0]
search := [0,0]
start := [0, 0]
OK_button := [0, 0]
asset := [0, 0]
person := [0, 0]
leather := [0, 0]
overview := [0, 0]

todo_config := ["gather simple pelts", 0]
person_offset := [0,45]
starting := true

firstrun = true

names := ["task", "task_offset", "todo", "search", "start", "OK_button", "asset", "person", "leather", "overview", "person", "todo_config", "person_offset"]
defaults := ["870,380", "200,140", "1335,435", "1285, 1000", "770, 770", "770,770", "850,390", "980,450", "625,375", "625,260", "0,45", "gather simple pelts,3", "0,45"]
length := 13


configuring := false
current_configuring := 0
offset_config := "horizontal"

Hotkey, F12,, Off

Configure2()
{
  global
  WinActivate, Neverwinter
  name := names[current_configuring]
  MouseGetPos, x, y
  if (name != "task_offset")
  {
    %name%[1] := x
    %name%[2] := y
    MsgBox, % "Successfully configured " . name . " as : " . %name%[1] . "," . %name%[2]
    configuring := false
    ;MsgBox %name%
    If (name == "task")
    {
      ConfigureTaskOffset()
      return
    }
    ;SaveConfig()
    ;TestConfig()
  } else {
    if (offset_config == "horizontal")
    {
      %name%[1] := Abs(task[1] - x)
      offset_config := "vertical"
      ConfigureTaskOffset()
      return
    }
    else if (offset_config == "vertical")
      {
        %name%[2] := Abs(task[2] - y)
      }
    MsgBox, % " New Offset is " . %name%[1] . "," . %name%[2]
  }
    SaveConfig()
    TestConfig()

}

ConfigureTaskOffset()
{
  global task_offset, task, offset_config,current_configuring

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
    current_configuring := 2
    MsgBox, Move,  Please move the mouse to the correct Position and press F12
    Hotkey, F12,, On
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
      configuring := true
      current_configuring = %A_index%
      name := names[current_configuring]
      If (name != "task_offset" && name != "person_offset")
      {
        current_configuring = %A_index%
        MsgBox, % "Please move your mouse to the " . name . " button and then Press F12"
        Hotkey, F12, , On
        return
      }
    }
  }
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

ClickSmooth(target, num_clicks=2)
{
  ;MsgBox % "target: " . target[1] . "," . target[2]
  MouseMove, target[1], target[2], 20
  Loop, %num_clicks%
  {
    Sleep, 100
    Click target[1], target[2]
  }
  return true
}


AskItem()
{
  global todo_config ;todo_string, todo_number
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

  return true
}

Search()
{
  global
  ClickSmooth(leather)
  Sleep, 200
  ClickSmooth(search)
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
      ;MsgBox, % "PersonCoord: " . pcoord[1] . "," . pcoord[2] . " - Person: " . person[1] . "," . person[2]
      ClickSmooth(coord)
      Sleep, 200
      ClickSmooth(todo)
      Sleep, 200
      ClickSmooth(asset)
      Sleep, 200
      ClickSmooth(pcoord)
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
      WinActivate, Neverwinter
      ClickSmooth(overview)
      loopvar := 0
      Loop, %number%
      {
          index := [Floor(Mod(A_Index-1,3)),Floor((A_Index-1)/3)]
          coord := [task[1]+index[1]*task_offset[1],task[2]+index[2]*task_offset[2]]
          ;MsgBox, % "Task: " . task[1] . "," . task[2] . " - Coord: " . coord[1] . "," . coord[2]
          if (ClickSmooth(coord )) {
            ClickSmooth(OK_button , 1)
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



starting := false
LoadConfig()
SaveConfig()

F12::
  Hotkey, F12,, Off
  Configure2()
  return
F10::
  Test()
  return
F9::
  LoadConfig()
  TestConfig()
  return

#IfWinActive, Neverwinter
  F8::
    SaveConfig()
    return


  ^+F4::
    MsgBox, 4, Reset, % "Do you want to reset and reconfigure all the saved values?"
    IfMsgBox Yes
      {
        Reset()
        SaveConfig()
        TestConfig()
      }




  F6::
    BuildItems(todo_number)
    return
  F5::
    AskFinished()
    If (AskItem())
    {

      Search()
      BuildItems(todo_number)

    }

#IfWinActive
RControl & Enter::ShiftAltTab
