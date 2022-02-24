#+q::Send !{F4}
return

;to maximise a window 
#m::
WinGet MX, MinMax, A
	
	 If(MX=0)
		WinMaximize, A
	
return
 
#+m::
WinGet MX, MinMax, A
	
	 If(MX!= -1)
		WinMinimize, A
return	

#BackSpace::
send, {Home}
send,{Shift}+{End}
send,{BackSpace}
return

#j::
send,#{Down}
return

#k::
send,#{Up}
return

#h::
send, #{Left}
return

#l::
send,#{Right}
return

!j::
send,!{Down}
return

!k::
send,!{Up}
return

!h::
send, !{Left}
return

!l::
send,!{Right}
return


!+j::
send,!+{Down}
return

!+k::
send,!+{Up}
return

!+h::
send, !+{Left}
return

!+l::
send,!+{Right}
return




