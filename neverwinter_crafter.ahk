;Gather Simple Pelts

i := "i"
j := "j"
LeatherI := 625
LeatherJ := 375
OverviewI := 625
OverviewJ := 260
Task1_i := 865
Task1_j := 380
Task2_i := 1065
Task2_j := 380
Task3_i := 1265
Task3_j := 380

todo_wrare_i := 1330
todo_wrare_j := 535
todo_i := 1335
todo_j := 435
search_i := 1060
search_j := 250

OK_i := 720
OK_j := 765
todo_string := "gather simple pelts"
todo_index := 1


steps = 5
; Syntax
; Expressions in MsgBox
;MsgBox % "OK: " . OK_i . ", " . OK_j

ClickSmooth(target_i, target_j)
{
;  MouseGetPos, current_i, current_j
;  MsgBox ClickSmooth
;
;
;  global steps
;  idiff := (target_i-current_i)/steps
;  jdiff := (target_j-current_j)/steps
;  looper := 0
;  Loop, 5
;  {
;    looper := looper+1
;    Random, irand,-10,10
;    Random, jrand, -10,10
;    MouseGetPos, current_i, current_j
;    pos_i := current_i+idiff+irand
;    pos_j := current_j+jdiff+jrand
;    SendEvent {Click %pos_i%, %pos_j%}
;    ;MouseMove, current_i+idiff+irand, current_j+jdiff+jrand, 25
;    ;MsgBox, % "Move Number" . looper
;  }

;
;

;  ;// Do some calculations for the next click instead of just assigning the target.
;  if (abs(current_j-target_j) < abs(jdiff))
;  {
;    jdiff := 0
;  }
;  if (abs(current_i-target_i) < abs(idiff))
;  {
;    idiff := 0
;  };

;  ic := current_i + idiff
;  jc := current_j + jdiff
;  ;MsgBox % "Diff: " . idiff . "," . jdiff . " Current is " . current_i . "," . current_j . "Clicking on " . ic . "," . jc . "And target: " . target_i . "," . target_j
;  ; ic := target_i
;  ; jc := target_j
  ;Sleep, 500/steps
  ;if (abs(jc-target_j) > 10 || abs(ic-target_i) > 10) {
;      return ClickSmooth(target_i, target_j)
;  } else {
;    Click %ic% %jc%
;    idiff := 0
;    jdiff := 0
;    return true
;  }
  MouseMove, target_i, target_j, 25
  return true
}

AskItem()
{
  global todo_string
  MsgBox,3, Producing, % "Do you want to " . todo_string . "?"
  IfMsgBox No
    InputBox, todo_string, Searchstring, What do you want to build (search)?,,,,,,,,simple pelt
    If ErrorLevel
      return false
  IfMsgBox Cancel
    return false
  return true
}

Search()
{
  global search_i, search_j, todo_string
  ClickSmooth(search_i, search_j)
  Send ^a
  Send {raw}%todo_string%
  Send {Enter}
}



^!+F5::

;	IfWinActive, Neverwinter
;	{
    If (AskItem())
    {
      Search()
    }
;    if (ClickSmooth(Task1_i, Task1_j)) {
;       ClickSmooth(OK_i, OK_j );
;    }
;    Sleep, 150
;    ; Task 2
;    if (ClickSmooth(Task2_i, Task2_j)) {
;       ClickSmooth(OK_i, OK_j )
;    }
;    Sleep, 150
;    ; Task 3
;    if (ClickSmooth(Task3_i, Task3_j)) {
;       ClickSmooth(OK_i, OK_j )
;    }
    ;
    ;Sleep, 200
    ;Click %OK_i% %OK_j%
    ;Sleep, 500

    ;MsgBox %   Leatherworking%i% . ","  . Leatherworking%j% . " - " . TaskOne%i% . "," . TaskOne%j%
		;Click %Task1_i% %Task1_j%
		;Sleep, 526
;		MouseMove, 841, 384
;		MouseMove, 769, 749
;   MouseMove, 841, 511
;		MouseMove, 752, 777
;		Click 752 777
;		MouseMove, 851, 546
;		MouseMove, 865, 361
;		Click 867 379
;   Sleep, 584
;		Sleep, 597
;		MouseMove, 867, 379
;		MouseMove, 1155, 411
;		MouseMove, 1293, 430
;		Click 1294 430
;		Sleep, 574
;		MouseMove, 1294, 430
;		MouseMove, 1213, 418
;		MouseMove, 992, 401
;		MouseMove, 906, 390
;		Click 855 387
;		Sleep, 585
;		MouseMove, 855, 387
;		MouseMove, 906, 411
;		MouseMove, 932, 442
;		MouseMove, 886, 442
;		Click 901 443
;		Sleep, 570
;		MouseMove, 901, 443
;		MouseMove, 898, 465
;		MouseMove, 895, 464
;		MouseMove, 883, 428
;		MouseMove, 1037, 697
;		MouseMove, 1292, 1012
;		Click 1319 1003
;		Sleep, 570
;		MouseMove, 1319, 1003
;		MouseMove, 1294, 984
		;Click 1254 958
;	}
