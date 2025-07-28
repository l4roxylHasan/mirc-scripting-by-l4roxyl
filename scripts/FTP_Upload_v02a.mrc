;Description:
;The code does not operate using the /write system, which is widely known and commonly used in Turkey (often considered the only way by rote). Instead, it functions entirely through socket connections, FTP Raw Commands, and FTP passive mode operations. You can upload any file you wish to any FTP server you have authorization for. I've also provided two different usage methods for those interested: users can either run the code via a dialog-table or by directly entering commands through a custom-window. Within the code, I utilized the Binary files file handling system (though it could also be done with file handling). Additionally, the file to be uploaded is divided into 3 parts for transfer based on its size. In short, when uploading both low-sized and high-sized files, there will be no speed issues.
;Additional Note:
When uploading a file in the custom window, close the window or press the Pause/Break key to terminate the process.
Usage:
/sendfile <d(ialog)|c(ommand)> <address> <username> <password> <directory> <port>
For Dialog: /sendfile d
For Window: /sendfile c <address> <username> <password> <directory> <port>
Window Example: /sendfile c mircscripting.net my_username my_password /www 21
