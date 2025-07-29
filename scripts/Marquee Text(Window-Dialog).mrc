;code by L4roXyL (Hasan Aydeniz - 2008)
;/marquee [dlg|cstm] [dialog-name|custom-name] [item|line] [space-num] [d|t] [marquee-speed] [text]
alias marquee {
  var %ec = echo $colour(info) -ae * /marquee: insufficient parameters. $chr(32) $++ $& 
    Invalid Parameters: /marquee [dlg|cstm] [dialog-name|custom-name] [item|line] [space-num] [d|t] [marquee-speed] [text]
  if (!$regex($1,^(dlg|cstm)$) || !$gettok($1-,7,32)) { %ec | halt }
  var %s = 1,%t = $timer(0),%% = $+(mrqe,$2,-,$3,-*)
  while (%s <= %t) { 
    if ($regex($timer(%s),%%)) { 
      $+(.timer,$timer(%s)) off 
      $iif($regex($1,^dlg$),did -r $2-3,dline $2 $+($3,-,$3)) 
      break
    } 
    inc %s
  }
  var %s = 1
  var %q = $+($iif($regex($5,^t$),$7-),$chr(160),$iif($4 > $len($7-),$str($chr(160),$calc($4 - $len($7-)))),$iif($regex($5,^d$),$7-)) 
  $iif($regex($1,^dlg$),did -a $2-3 %q,rline $2-3 %q) 
  var %& = $len(%q)
  while (%s <= %&) { 
    $+(.timermrqe,$2,-,$3,-,%s) -m 1 $calc($6*%s) $iif($regex($1,^dlg$),did -r $2-3,dline $2 $+($3,-,$3)) $chr(124) $iif($regex($1,^dlg$),did -a $2-3,rline $2-3) $+($right(%q,$iif($regex($5,^t$),-) $+ %s),$left(%q,$iif($regex($5,^d$),-) $+ %s)) $iif(!$calc($len(%q)-%s),$chr(124) marquee $1-) 
    inc %s 
  }
}

;Example
;For dialog: /dlg
;For window: /cstm
alias dlg dialog -m dialog dialog
alias cstm window -c @cstm | window -daClk0 @cstm 0 0 400 50 | marquee cstm @cstm 1 100 d 100 Example..
dialog dialog {
  title "Example"
  size -1 -1 168 14
  option dbu
  text "", 1, 13 3 144 8
}
on *:dialog:dialog:init:*:marquee dlg $dname 1 75 d 100 Example..
