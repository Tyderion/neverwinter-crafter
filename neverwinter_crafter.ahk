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
todo_i := 320
todo_j := 435

OK_i := 720
OK_j := 765

; Syntax
; Expressions in MsgBox
;MsgBox % "OK: " . OK_i . ", " . OK_j

ClickSmooth(target_i, target_j)
{
  MouseGetPos, current_i, current_j
  ic := 0
  jc := 0
  ;// Do some calculations for the next click instead of just assigning the target.
  ic := target_i
  jc := target_j
  Sleep, 1000
  Click %ic% %jc%
  if (ic != target_i && jc != target_i) {
      return ClickSmooth(target_i, target_j)
  } else {
    return true
  }

}

F5::

;	IfWinActive, Neverwinter
;	{
		Click  %OverviewI% %OverviewJ%
    ; Click task 1
    if (ClickSmooth(Task1_i, Task1_j)) {
       ClickSmooth(OK_i, OK_j )

    }
    Sleep, 150
    ; Task 2
    if (ClickSmooth(Task2_i, Task2_j)) {
       ClickSmooth(OK_i, OK_j )
    }
    Sleep, 150
    ; Task 3
    if (ClickSmooth(Task3_i, Task3_j)) {
       ClickSmooth(OK_i, OK_j )
    }
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
