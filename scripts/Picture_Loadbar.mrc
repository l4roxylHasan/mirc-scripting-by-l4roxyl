;- code by L4roXyL (Hasan AYDENİZ - 2006)
;- A simple code I wrote using a picture window.
;- Features (Usage):
;- You can define the title name.
;- There are 6 theme options available.
;- You can add a minimum of 1 and a maximum of 5 texts.
;- You can define the loading speed (in MS format).
;- Note: For the text you enter in the Title-name section, you should use a hyphen ("-") instead of a space.
;- Usage:
;- /loadbar [title-name] [red|blue|green|grey|yellow|orange] [load speed] [loadtext1+loadtext2+3../max 5 loadtext])
;- Example:
;- /loadbar Title-name.(title) grey 20 First text+Second text+Third text+Fourth text+Fifth text

alias loadbar {
  var %echo = (/loadbar [title-name] [red|blue|green|grey|yellow|orange] [load speed] [loadtext1+loadtext2+3../max 5 loadtext]) 
  if ($regex($1-,/\s/g) < 3) { echo $color(info) -e */loadbar: Hatalı veya eksik kullanım. %echo | halt }
  $iif($window(@loadbar),window -c @loadbar) 
  unset %load 
  clr $2 
  set %fill $hget($2,fill) 
  set %rect $hget($2,rect) 
  set %ptitle $hget($2,title) 
  set %clr $2
  window -aCpdhBk0 +d @loadbar 0 0 220 65 
  window -a @loadbar 
  drawfill -r @loadbar %fill %fill 0 0 
  drawrect -r @loadbar %rect 2 0 0 220 65 0 0 220 17 7 37 206 22 
  drawrect -rf @loadbar %ptitle 1 2 2 216 13
  drawtext -rbo @loadbar %fill %ptitle Arial 9 5 3 $ll($regsubex($1,/-/g,$chr(32))) 
  drawtext -rb @loadbar %fill %ptitle Arial 9 202 2 = x
  .timerload -m 200 $3 inc %load $(|) drawrect -rf @loadbar %ptitle 1 10 40 $!(%load,2) 16 $(|) drawtext -rbo @loadbar %rect %fill Arial 9 7 22 $!+(Load,$chr(40),%,$round($calc($(%load,2) /2),0),$chr(41)) $(|) txt %clr $4-
}
alias -l clr {
  if ($regex(red,$1)) { 
    hadd -m red fill $rgb(169,14,21) 
    hadd -m red rect $rgb(43,0,14) 
    hadd -m red title $rgb(60,0,13) 
  }
  if ($regex(blue,$1)) { 
    hadd -m blue fill $rgb(30,72,240) 
    hadd -m blue rect $rgb(5,20,78) 
    hadd -m blue title $rgb(9,33,132) 
  }
  if ($regex(green,$1)) { 
    hadd -m green fill $rgb(0,200,0) 
    hadd -m green rect $rgb(0,35,0) 
    hadd -m green title $rgb(0,60,0) 
  }
  if ($regex(grey,$1)) { 
    hadd -m grey fill $rgb(85,85,85) 
    hadd -m grey rect $rgb(25,25,25) 
    hadd -m grey title $rgb(50,50,50) 
  }
  if ($regex(yellow,$1)) { 
    hadd -m yellow fill $rgb(255,255,0) 
    hadd -m yellow rect $rgb(85,85,0) 
    hadd -m yellow title $rgb(105,105,0) 
  }
  if ($regex(orange,$1)) { 
    hadd -m orange fill $rgb(255,128,0) 
    hadd -m orange rect $rgb(66,33,0) 
    hadd -m orange title $rgb(128,64,0) 
  } 
}
alias -l ll var %t = $iif($len($1-) >= 29,$+($left($1-,28),..),$1-) | var %tt = $regsubex(%t,/(?<=^)(.)/g,$upper(\1)) | return %tt
alias -l mse if ($mouse.x >= $gettok($1,1,45) && $mouse.x < $gettok($1,2,45)) && ($mouse.y >= $gettok($1,3,45) && $mouse.y < $gettok($1,4,45)) return $true 
alias -l txt {
  var %:- = $timer(load).reps
  if ($regex(%:-,^190$)) { 
    drawrect -rf @loadbar %fill 1 62 20 148 15 
    set -e %t1 $gettok($2-,1,43) 
    drawtext -rb @loadbar %rect %fill Arial 9 62 22 $ll(%t1) 
  }
  if ($regex(%:-,^140$)) { 
    drawrect -rf @loadbar %fill 1 62 20 148 15 
    set -e %t2 $iif(!$gettok($2-,2,43),%t1,$gettok($2-,2,43)) 
    drawtext -rb @loadbar %rect %fill Arial 9 62 22 $ll(%t2) 
  }
  if ($regex(%:-,^90$)) { 
    drawrect -rf @loadbar %fill 1 62 20 148 15 
    set -e %t3 $iif(!$gettok($2-,3,43),%t2,$gettok($2-,3,43)) 
    drawtext -rb @loadbar %rect %fill Arial 9 62 22 $ll(%t3) 
  }
  if ($regex(%:-,^50$)) { 
    drawrect -rf @loadbar %fill 1 62 20 148 15 
    set -e %t4 $iif(!$gettok($2-,4,43),%t3,$gettok($2-,4,43)) 
    drawtext -rb @loadbar %rect %fill Arial 9 62 22 $ll(%t4) 
  }
  if ($regex(%:-,^10$)) { 
    drawrect -rf @loadbar %fill 1 62 20 148 15 
    set -e %t5 $iif(!$gettok($2-,5,43),%t4,$gettok($2-,5,43)) 
    drawtext -rb @loadbar %rect %fill Arial 9 62 22 $ll(%t5) 
  }
  if ($regex(%:-,^0$)) .timer 1 1 drawtext -rbo @loadbar %rect %fill Arial 9 7 22 $+(Loaded.,$str($chr(160),30)) $(|) unset %t1 %t2 %t3 %t4 %t5 $(|) .timercls 1 3 window -c @loadbar
}
on *:close:@loadbar:$iif($timer(cls),.timercls off)
menu @loadbar {
  sclick:$iif($mse(202-207-4-9),window -n @loadbar) | if ($mse(209-216-4-11)) window -c @loadbar | .timerload off 
  mouse: { 
    $iif($mse(202-207-4-9),drawtext -rbo @loadbar $rgb(255,255,255) %ptitle Arial 10 202 2 =,drawtext -rb @loadbar %fill %ptitle Arial 9 202 2 = $+(x,$chr(160))) 
    $iif($mse(209-216-4-11),drawtext -rbo @loadbar $rgb(255,255,255) %ptitle Arial 10 210 2 x)
  }
}
