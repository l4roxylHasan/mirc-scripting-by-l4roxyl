;- code by L4roXyL (Hasan AYDENİZ - 2007)
;- Usage:
;- /userh <#channel> <username>
;- Description:
;- This code allows you to view the message history of a specified user in a specified channel.
alias userh {
  if (!$regex($1,^#+) || !$2) { 
    echo $color(info text) -e * /userh: Invalid Parameters: /userh <#channel> <user> 
    returnex 
  }
  var %1 = 1,%2 = $line($1,0)
  var %n = $regsubex($2,/(\[|\]|\^|\||\\)/g,$+(\,\1)\s) 
  while (%1 <= %2) { 
    if ($regex($gettok($line($1,%1),1,32),$+(<?,%n,>)) || $regex($gettok($line($1,%1),2,32),$+(<?,%n,>))) { 
      inc %c $len($line($1,%1)) 
      inc %cc 
      win $1 $2 $line($1,%1) 
    } 
    inc %1 
  } 
  if $window(@-) { 
    aline @- - 
    aline @- Total Send Line: %cc - Total byte: %c 
    unset %c %cc 
    return 
  }
  echo $color(info text) -ate $1 channel, for $2 nickname not log.
}
alias -l win { 
  if !$window(@-) { 
    window -aCdlk0 +l @- 
    aline @- - For $2 nickname $1 channel log: 
    aline @- - 
    titlebar @- $2 Log.
  } 
  aline -p @- $3-
}
