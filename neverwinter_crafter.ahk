;Gather Simple Pelts

i := "i"
j := "j"
leather_i := 625
leather_j := 375
overview_i := 625
overview_j := 260
task1_i := 870
task1_j := 380
task_horizontal_offset := 200
task_vertical_offset := 140

todo_i := 1335
todo_j := 435
search_i := 1060
search_j := 250

start_i := 1285
start_j := 1000

OK_i := 735
OK_j := 770

asset_i := 850
asset_j := 390

person1_i := 980
person1_j := 450
person_vertical_offset := 45
person_horizontal_offset := 0
todo_string := "gather simple pelts"
todo_number := 3


steps = 5
; Syntax
; Expressions in MsgBox
;MsgBox % "OK: " . OK_i . ", " . OK_j

ClickSmooth(target_i, target_j, twice = true)
{
  MouseMove, target_i, target_j, 20
  Sleep, 100
  Click %target_i%, %target_j%
  if (twice == true)
  {
  MouseMove, target_i, target_j, 20
  Sleep, 100
  Click %target_i%, %target_j%

  }
  return true
}

AskItem()
{
  global todo_string, todo_number
  MsgBox,3, Producing, % "Do you want to " . todo_string . "?"
  IfMsgBox Cancel
    return false
  IfMsgBox No
    InputBox, todo_string, Searchstring, What do you want to build (search)?,,,,,,,,simple pelt
    If ErrorLevel
      return false
    InputBox, todo_number, How many?, % "How many times do you want to " . todo_string . "?"
    If ErrorLevel
      return false

  return true
}

Search()
{
  global search_i, search_j, todo_string, leather_i, leather_j
  ClickSmooth(leather_i, leather_j)
  Sleep, 200
  ClickSmooth(search_i, search_j)
  Sleep, 200
  Send ^a
  Sleep, 200
  Send {raw}%todo_string%
  Sleep, 200
  Send {Enter}
}

BuildItems(number)
{
  global overview_i, overview_j, start_i, start_j
  global task1_i, task1_j, task_horizontal_offset, task_vertical_offset,
  global todo_i, todo_j
  global person1_i, person1_j, person_horizontal_offset, person_vertical_offset
  global asset_i, asset_j
  ClickSmooth(overview_i, overview_j)
  loopvar := 0
  Loop, %number%
  {
      i_index:= Floor(Mod(loopvar,3))
      j_index:= Floor(loopvar/3)
      i_coord := task1_i+i_index*task_horizontal_offset
      j_coord := task1_j+j_index*task_vertical_offset
      ClickSmooth(i_coord, j_coord )
      Sleep, 200
      ClickSmooth(todo_i, todo_j )
      Sleep, 200
      ClickSmooth(asset_i, asset_j)
      Sleep, 200
      ClickSmooth(person1_i, person1_j+loopvar*person_vertical_offset)
      Sleep, 200
      ClickSmooth(start_i, start_j)
      loopvar++
    ;MsgBox Loop Once Over
    Sleep, 200
  }
}

AskFinished()
{
  global overview_i, overview_j,task1_i, task1_j, task_horizontal_offset, task_vertical_offset, OK_i, OK_j, number
  MsgBox,4, Finished?, % "Do crafting goods need collecting?"
  IfMsgBox Yes
  {
    InputBox, number, How many are finished?, How many task slots are finished? (only linear possible)
    If ErrorLevel
      return false
    else
    {
      WinActivate, Neverwinter
      ClickSmooth(overview_i, overview_j)
      ;ClickSmooth(overview_i, overview_j)
      loopvar := 0
      Loop, %number%
      {
          i_index:= Floor(Mod(loopvar,3))
          j_index:= Floor(loopvar/3)
          i_coord := task1_i+i_index*task_horizontal_offset
          j_coord := task1_j+j_index*task_vertical_offset
          if (ClickSmooth(i_coord, j_coord )) {
            ClickSmooth(OK_i, OK_j , false)
          }
          ;
          loopvar++
      }
    }
  }
}

F6::
  BuildItems(todo_number)

F5::
  IfWinActive, Neverwinter
  {
    AskFinished()
    If (AskItem())
    {

      Search()
      BuildItems(todo_number)

    }

  }
