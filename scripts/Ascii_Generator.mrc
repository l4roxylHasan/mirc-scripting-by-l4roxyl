; code by L4roXyL (Hasan Aydeniz - 2009)
; Usages:
; $ascii(text).ascii: Returns the ASCII codes of the text entered in the text section.
; $ascii(ascivalue ascivalue [.] [..]).value: Converts the ASCII numbers entered in the ascivalue section into text.
; Examples:
; //echo -: $ascii(test).ascii => 100 101 110 101 109 101
; //echo -: $ascii(100 101 110 101 109 101).value => test
;-
alias ascii {
  if ($show && !$prop && !$isid) { echo -eca info * Error: $!ascii(text).ascii ve/ya $!ascii(ascivalue ascivalue [.] [..]).value | return } 
  if ($prop = ascii) return $regsubex($1-,/(.)/g,$chr(32) $asc(\1))
  if ($prop = value) return $regsubex($regsubex($regsubex($regsubex($1-,/(32|160)/g,-),/(\d{1,3})/g,$chr(\1)),/\s/g,),/(-)/g,$chr(32))
}
