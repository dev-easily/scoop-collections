# $fileList = Get-ChildItem $PWD *_install_*.ps1| where{!$_.PSIsContainer}
# foreach($file in $fileList) {
#     .\"$file"
# }

.\01_install_sdk.ps1
.\02_install_ide.ps1
.\03_install_office.ps1
.\04_install_tools.ps1
.\05_install_games.ps1
.\06_install_video_audio.ps1

Pause