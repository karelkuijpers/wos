CLASS CLICKYES
	PROTECT uClickYes AS DWORD
	PROTECT wnd AS PTR
	PROTECT res AS DWORD
METHOD Init() CLASS CLICKYES

// Register a message to send
  uClickYes:=RegisterWindowMessage('CLICKYES_SUSPEND_RESUME')

// Find ClickYes Window by classname
  wnd:=FindWindow('EXCLICKYES_WND',NULL)
METHOD Resume() CLASS CLICKYES
	LOCAL res AS DWORD
// Send the message to Resume ClickYes
res:=  SendMessage(wnd, uClickYes, 1, 0)
RETURN
METHOD Suspend() CLASS CLICKYES
	// Send the message to Suspend ClickYes
SendMessage(wnd, uClickYes, 0, 0)
