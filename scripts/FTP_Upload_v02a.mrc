;-----------------------------------------------------------------------------------
; FTP upload v0.2a
; l4roxyl code series - 2011,,.
; date: 20/11/2011
; use: /sendfile <d(ialog)|c(ommand)> <address> <username> <password> <directory> <port>
;-----------------------------------------------------------------------------------
;started code

alias -l _input $iif($input($1-,wo,Hata) = $true,,) | dialog -v ftp_ | halt
alias _did $iif($dialog(ftp_),did -ra ftp_ 15,$iif($window(@ftp_upload),aline -c2 $v1 +++)) $1-
alias _len if ($len($1-) >= 20) { return $left($1-,20) $+ .. } | else return $1-
alias _did2 if ($dialog(ftp_)) did - $+ $1 ftp_ 5-9,13,14
alias _file_byte {
  var %_. = $file($1).size
  if (%_. < 1048576) return 9182
  if (%_. > 1048576 && %_. < 3145728) return 18364
  if (%_. > 3145728) return 55092
}
on *:keydown:@ftp_upload:*: {
  if ($keyval = 19) {
    $iif($sock(ftp),sockclose ftp)
    $iif($sock(ftp2),sockclose ftp2)
    $iif($hget(_ftp),hfree _ftp)
    unset %_sfile
    window -c $target
  }
}
on *:load: {
  var %e = echo -ac info +++
  %e FTP Upload v0.2a loaded..
  %e Usage: /sendfile <d(ialog)|c(ommand)> <address> <username> <password> <directory> <port>
  %e Dialog: /sendfile d
  %e Window: /sendfile c <address> <username> <password> <directory> <port>
  %e Sample Window: /sendfile c mircscripting.net username password /public_ftp 21
  linesep 
  %e l4roxyl(Hasan AYDENİZ)
}
on *:close:@ftp_upload: {
  $iif($sock(ftp),sockclose ftp)
  $iif($sock(ftp2),sockclose ftp2)
  $iif($hget(_ftp),hfree _ftp)
  unset %_sfile
}
menu status,menubar {
  FTP Upload v0.2a
  .Run: if ($dialog(ftp_)) return | sendfile d
  .About:echo -aec info +++ l4roxyl(Hasan AYDENİZ)
}
dialog -l ftp_ {
  title "FTP Upload"
  size -1 -1 94 117
  option dbu
  text "FTP Address:", 1, 5 7 34 8
  text "Username:", 2, 5 17 34 8
  text "Password:", 3, 5 27 34 8
  text "Port(21):", 4, 5 37 34 8
  edit "", 5, 41 6 50 10, autohs
  edit "", 6, 41 16 50 10
  edit "", 7, 41 26 50 10, pass
  edit "", 8, 41 36 50 10
  button "Select Send File", 9, 4 47 86 10, flat
  text "", 10, 4 60 86 8, center
  text "Target Folder:", 12, 5 71 34 8
  edit "", 13, 41 70 50 10
  button "Upload", 14, 4 82 86 10, flat
  text "", 15, 4 106 86 8, center
  button "Cancel", 16, 4 94 86 10, flat
}
alias sendfile {
  if (!$1) {
    echo -aec info +++ Err: /sendfile <d(ialog)|c(ommand)> <address> <username> <password> [port]
    return
  }
  if ($sock(ftp)) sockclose ftp
  if ($sock(ftp2)) sockclose ftp2
  if ($1 = d) $iif(!$dialog(ftp_),dialog -mdi ftp_ ftp_,_input Dialog already open.) 
  if ($1 = c) {
    if (!$6) {
      $iif($dialog(_ftp),dialog -c _ftp)
      echo -aec info +++ Err: /sendfile <d(ialog)|c(ommand)> <address> <username> <password> <directory> <port>
      return
    }
    $iif(!$window(@ftp_upload),window -aCldk0 +l @ftp_upload -1 -1 300 300)
    $iif($window(@ftp_upload),clear $v1)
    $iif($dialog(ftp_),dialog -c $v1 $v1)
    %_sfile = $sfile($mircdir,Select the file to send,Select)
    if (!%_sfile) { 
      if ($window(@ftp_upload)) aline -c2 @ftp_upload No file selected to send.
      return
    }
    else {
      sockopen ftp $2 $iif($6,$6,21)
      var %_h = hadd -m _ftp
      %_h _user $3
      %_h _pass $4
      %_h _file $shortfn(%_sfile)
      %_h dir $iif($5,$5,/)
    }
  }
}
on *:dialog:ftp_:*:*: {
  if ($devent = close) {
    $iif($sock(ftp),sockclose ftp)
    $iif($sock(ftp2),sockclose ftp2)
    $iif($hget(_ftp),hfree _ftp)
    unset %_sfile
  }
  if ($devent = init) {
    $iif($window(@ftp_upload),window -c $v1)
    did -a $dname 10 No file selected to send.
    did -a $dname 15 Status: No transfer.
    did -a $dname 8 21
  }
  if ($devent = sclick) {
    if ($did = 16) {
      $iif($sock(ftp),sockclose ftp)
      $iif($sock(ftp2),sockclose ftp2)
      $iif($hget(_ftp),hfree _ftp)
      _did2 b
      dialog -c ftp_ ftp_
    }
    if ($did = 9) {
      %_sfile = $sfile($mircdir,Select the file to send,Select)
      if (!%_sfile) { 
        did -a $dname 10 No file selected to send.
        return
      }
      else did -ra $dname 10 Dosya: $_len($nopath(%_sfile))
    }
    if ($did = 14) {
      if (!$did($dname,5)) _input Enter Address $crlf $+ Sample: mircscripting.net
      if (!$did($dname,6)) _input Enter Usarname
      if (!$did($dname,7)) _input Enter Password
      if (!$did($dname,8)) {
        hadd -m _ftp port 21
        did -a $dname 8 21
      } 
      else {
        if ($did($dname,8) !isnum) _input Port must be digit. $crlf $+ Sample: FTP 21
      }
      if (!$did($dname,13)) _input Select Target Folder $crlf $+ Sample: /www - /public_ftp - Main Directory: /
      if (!%_sfile) _input Select the file to send
      if (%_sfile && $did($dname,5) && $did($dname,6) && $did($dname,7) && $did($dname,8) && $did($dname,13)) {
        $iif($sock(ftp),sockclose ftp)
        $iif($sock(ftp2),sockclose ftp2)
        $iif($hget(_ftp),hfree _ftp)
        hadd -m _ftp _file $shortfn(%_sfile)
        hadd -m _ftp address $did($dname,5)
        hadd -m _ftp _user $did($dname,6)
        hadd -m _ftp _pass $did($dname,7)
        hadd -m _ftp port $did($dname,8)
        hadd -m _ftp dir $did($dname,13)
        sockopen ftp $hget(_ftp,address) $iif($hget(_ftp,port),$v1,21)
        did -ra $dname 15 Status: Connecting..
        _did2 b
      }
    }
  }
}
on *:sockopen:ftp: {
  if ($sockerr) {
    _did Status: Connection failed.
    _did2 e
    return
  }
}
on *:sockread:ftp: {
  if ($sockerr) {
    _did2 e
    _did Connection failed.
    return
  }
  sockread %_data
  while ($sockbr) {
    var %_raw = $token(%_data,1,32)
    if (%_raw = 220) {
      sockwrite -n $sockname user $hget(_ftp,_user)
      _did Username entered.
    }
    if (%_raw = 331) { 
      sockwrite -n $sockname pass $hget(_ftp,_pass)
      _did Password entered, waiting..
    }
    if (%_raw = 230) {
      sockwrite -n $sockname TYPE I
      _did Connection verified.
    }
    if (%_raw = 200) sockwrite -n $sockname PASV
    if (%_raw = 227) {
      _did Passive mode activated.
      var %s = $remove($token(%_data,-1,32),$chr(40),$chr(41))
      var %port = $token(%_data,5,44), %port2 = $token(%_data,6,44)
      var %port3 = $calc((%port * 2^8) + %port2)
      var %s = $replace($token(%s,1-4,44),$chr(44),$chr(46))
      sockopen ftp2 %s %port3
      sockwrite -n $sockname CWD $iif($hget(_ftp,dir),$v1,/)
    }
    if (%_raw = 250) { 
      sockwrite -n $sockname STOR $nopath($longfn($hget(_ftp,_file))) 
      _did Directory Selected: $token(%_data,-1,32)
      if ($window(@ftp_upload)) { 
        aline -c2 $v1 +++ File: $_len($nopath(%_sfile)) / $bytes($file(%_sfile).size).suf
      }
    }
    if (%_raw = 150) {
      _did Data transfer accepted.
      %=t = $ctime
      var %_pos = 0, %file = $hget(_ftp,_file)
      bread %file %_pos $_file_byte(%file) &_file
      sockwrite ftp2 &_file
      hadd -m pos pos $calc(%pos + $bvar(&_file,0))
    }
    if (%_raw = 530) {
      _did Authentication failed.
      _did2 e
      .timer 1 2 _did Disconnected.
    }
    if (%_raw = 226) { 
      _did File uploaded.
      _did Uploaded time: $duration($calc($ctime - %=t),3)
      _did2 e
      $iif($hget(_ftp),hfree $v1)
    }
    if (%_raw = 221) .timer 1 2 _did Exit.
    sockread %_data
  }
  if (%_raw = 550) {
    _did Directory not found.
    _did2 e
    $iif($sock(ftp),sockclose ftp)
    $iif($sock(ftp2),sockclose ftp2)
    _did Disconnected.
  }
}
on *:sockwrite:ftp2:{
  if ($sockerr) {
    _did Transfer failed.
    _did2 e
    return 
  }
  var %_pos = $hget(pos,pos), %_file = $hget(_ftp,_file)
  var %_p1 = $+(%,$round($calc((%_pos * 100)/ $file(%_file).size),1))
  var %_s = $bytes(%_pos,3).suf / $bytes($file(%_file).size,3).suf 
  if ($dialog(ftp_)) did -ra ftp_ 15 Upl.. ( $+ %_p1 $+ ) - %_s
  if ($window(@ftp_upload)) {
    var %l = $line($v1,0) - 1
    rline -c2 $v1 $calc(%l +1) ++++ Upl.. ( $+ %_p1 $+ ) - %_s
  }
  if (%_pos < $file(%_file).size) {
    bread %_file %_pos $_file_byte(%_file) &_file
    sockwrite $sockname &_file
    hadd -m pos pos $calc(%_pos + $bvar(&_file,0))
  }
  else { 
    sockclose $sockname 
    sockwrite -n ftp QUIT 
  }
}
