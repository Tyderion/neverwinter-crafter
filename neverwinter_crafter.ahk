Menu, Tray, Icon, Neverwinter_114.ico
presetString := ""
interfaceVisible := false

crafter := new Crafter()
crafter.config.load()
crafter.config.save()
return


; Labels
PresetLabel:
  try
  {
    crafter.doPreset(SubStr(A_ThisHotkey,2))
    Send N
    interfaceVisible := false
  }
  catch e
  {
    if (e.What != "WindowNotFound")
      Send {Backspace}
    ;MsgBox % "Error in " e.What ", which was called at line " e.Line
  }

  return

ConfigurationButtonOK:
  Gui, Configuration:Default
  Gui, Submit
  crafter.config.loadFromString(presetString)
  crafter.config.save()
  ensureActiveWindow()
  return

ConfigurationGuiEscape:
  Gui, Cancel
  ensureActiveWindow()
  return



#IfWinActive ahk_class CrypticWindowClassDX0
  ^F12::
    crafter.config.show()
    return

#IfWinActive

ensureActiveWindow(visible=false)
  {
    If (WinExist("ahk_class CrypticWindowClassDX0"))
    {
      If (WinActive("ahk_class CrypticWindowClassDX0") == 0x0)
      {
        WinActivate ahk_class CrypticWindowClassDX0
        WinWaitActive  ahk_class CrypticWindowClassDX0
      }
      if (visible)
        return true

      Sleep, 50
      ImageSearch, posi, posj,0,0,1920,1200,*24 overview_icon.png

      If ErrorLevel
        Send N
      Sleep, 90
      ImageSearch, posi, posj,0,0,1920,1200,*24 overview_icon.png
      If ErrorLevel
        throw Exception("Overview not visible.", "OverviewNotFound")
      return true
    }
    throw Exception("Neverwinter not running.", "WindowNotFound")
    return false
  }


class Crafter
{
  config := new Configuration()
  current_asset := 1
  click(target, num = 1)
  {
    if (target[1] != "")
    {
      global interfaceVisible := ensureActiveWindow(interfaceVisible)
      MouseMove, target[1], target[2], 20
      Sleep, 100
      if (num == 1)
      {
        Click down
        Sleep, 80
        Click up
      }
      return true
    }
    else
      return false
  }

  search(text, where)
  {
    if (!this.click(where))
      return false

    if (!this.click(this.config.getCoordinate("search")))
      return false
    Send ^a
    Sleep, 100
    Send {raw}%text%
    Sleep, 100
    Send {Enter}
  }

  build(number, category)
  {
    returnvalue := false
    Loop, %number%
    {
      this.click(category)
      cont := this.config.getCoordinate("continue")
      if ErrorLevel
        break
      this.click(cont)
      this.fillAssets(1)
      returnvalue := this.click(this.config.getCoordinate("start"))
    }
    return returnvalue
  }

  fillAssets(num)
  {
    if (num >= 1)
    {
      topleft := [0,0]
      Loop, %num%
      {
        asset_coord := this.config.getCoordinate("asset", topleft)
        this.click(asset_coord)

        this.click(this.config.getCoordinate("person",asset_coord))

        if (A_Index == 1)
          topleft := [0, position[2]+asset_offset[2]]
        else
          topleft := [position[1], topleft[2]]
        this.current_asset := this.current_asset +1

      }
    }
  }


  collect()
  {
    this.click(this.config.getCoordinate("overview"))

    Loop
    {
      get_collect := this.config.getCoordinate("collect")
      If (get_collect[1] == "")
      {
        ;MsgBox Nothing more to collect?
        break
      }
      this.click(get_collect)
      this.click(this.config.getCoordinate("ok"))
      Sleep, 200
    }
  }

  doPreset(num)
  {
    this.config.current_asset := 1
    this.collect()
    return this.config.presets[num].build(crafter)
  }

}

class Preset
{
  name := "A Preset"
  config := []
  config_length := 0
  crafter := ""

  build(crafter)
  {
    this.crafter := crafter
    configuration := crafter.config
    For index, conf in this.config
    {
      category := this.taskCategory(conf)
      crafter.search(conf.search,category )
      crafter.build(conf.number, category)
    }

  }

  taskCategory(conf)
  {
    global interfaceVisible := ensureActiveWindow(interfaceVisible)
    if (InStr(conf.where,"lead"))
      pic := "leadership.png"
    else if (InStr(conf.where,"leath"))
      pic := "leathermaking.png"
    else if (InStr(conf.where,"mail"))
      pic := "mailsmithing.png"
    else if (InStr(conf.where,"plate"))
      pic := "platesmithing.png"
    else if (InStr(conf.where,"tail"))
      pic := "tailoring.png"

    ImageSearch, posi, posj,0,0,1920,1200,*16 %pic%
    If ErrorLevel
      MsgBox % conf.where . " not found"
    return [posi+15, posj+5]
  }

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
  presets := []

  __New(filename = "neverwinter_crafter.ini")
  {
    this["filename"] := filename
  }


  getCoordinate(what, topleft = "default")
  {
    global interfaceVisible := ensureActiveWindow(interfaceVisible)
    if (topleft == "defaults")
    {
      topleft = [0,0]
    }
    if (what == "continue")
      pic := "continue_button.png"
    else if (what == "ok")
      pic := "ok_button.png"
    else if (what == "collect")
      pic := "collect_button.png"
    else if (what == "person")
      pic := "person_button.png"
    else if (what == "overview")
      pic := "overview_icon.png"
    else if (what == "asset")
      pic := "asset_button.png"
    else if (what == "start")
      pic := "start_button_off.png"
    else if (what == "search")
      pic := "search_field.png"
    else
      return ""

    ImageSearch, posi, posj,topleft[1], topleft[2],1920,1200,*16 %pic%
    If ErrorLevel
      {
        if (what == "start")
          ImageSearch, posi, posj,topleft[1], topleft[2],1920,1200,*16 start_button_on.png
        if ErrorLevel
          return ""
      }
    return [posi+15,posj+5]
  }

  save()
  {
    For index, preset in this.presets ; Save presets
      IniWrite,% preset.toString(), % this.filename, Presets, % "preset" . a_index-1
  }

  show()
  {
    str :=  ""
    For index, val in this.presets ; Append each preset-Object
      str := str . "preset" . a_index-1 . "= " . val.toString() . "`n"
    global presetString := str
    Gui, Configuration:New,,Configuration
    Gui, Add, Edit,r8 w700 vpresetString, % presetString
    Gui, Add, Button,, OK
    Gui, Show

  }


  createFHotkey(number)
  {
    hotkey := "F" . number
    Hotkey,% hotkey,PresetLabel
  }

  loadFromString(string)
  {
    this.presets := []
    ; Split the entries at new lines
    StringSplit, presetArray, string, `n
    ; For each entry

    Hotkey, IfWinActive, ahk_class CrypticWindowClassDX0
    Loop, %presetArray0%
    {
      If (presetArray%a_index% != "")
      {
        StringSplit, preset, presetArray%a_index%, =
        this.presets[a_index] := new Preset(preset2)
        if (a_index < 25)
        {
          this.createFHotkey(a_index)
        }
      }
    }
  }

  load(filename = "neverwinter_crafter.ini")
  {
    this["filename"] := filename
    IniRead, value,% filename, Presets
    this.loadFromString(value)
  }
}
