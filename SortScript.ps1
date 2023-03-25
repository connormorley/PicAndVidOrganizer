[reflection.assembly]::loadfile( "C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll") 

$des_path = "C:\Users\example\Pictures\My pictures archive\$sortDatePath"
$target_path = "C:\Users\example\Pictures\to_sort"

#$date = Get-Date ($_.LastWriteTime)
#$new_folder_name = $_.LastWriteTime.Date.ToString('yyyy') + "\" + $_.LastWriteTime.Date.ToString('MM')
#Global variables
$counter = 0
$FileTypesToOrganize = @("*.jpg","*.jpeg","*.mp4","*.png","*.mov","*.m4v","*.gif","*.bmp","*.3gp")


function getImageDateTaken($file){
    try
    {
	$tempbitmap=New-Object -TypeName system.drawing.bitmap -ArgumentList $file.fullname
	$date=$tempbitmap.GetPropertyItem(36867).value[0..9]
	$arYear = [Char]$date[0],[Char]$date[1],[Char]$date[2],[Char]$date[3]
        $arMonth = [Char]$date[5],[Char]$date[6]
        $arDay = [Char]$date[8],[Char]$date[9]
        $strYear = [String]::Join("",$arYear)
        $strMonth = [String]::Join("",$arMonth) 
        $strDay = [String]::Join("",$arDay)
        $DateTaken = $strYear + "-" + $strMonth + "-" + $strDay
	$new_folder_name= $strYear + "\" + $strMonth
	Write-Host "Date Taken sort"
        Remove-Variable tempbitmap
        return $new_folder_name
    }
    catch [System.Management.Automation.MethodInvocationException]
    {
        write-host "ERROR DURING PICTURE TAKEN EXTRACTION FOR FILE $file"
	write-host "ACQUIRING DEFAULT MODIFIED DATE"
	$temp_date = GetDefaultModifiedDate($file)
        return $temp_date
    }
}

function getVideoMediaCreated($file){
    try
    {
        $Shell = New-Object -ComObject Shell.Application
        $Folder = $Shell.Namespace($File.DirectoryName)
        $result = $folder.GetDetailsOf($folder.ParseName($file.name),208)
        $new_folder_name= $result.substring(9,4) + "\" + $result.substring(5,2)
        Write-Host "Media Created sort"
        return $new_folder_name
    }
    catch {
        write-host "ERROR DURING MEDIA CREATED EXTRACTION FOR FILE $file"
	write-host "ACQUIRING DEFAULT MODIFIE DATE"
	$temp_date = GetDefaultModifiedDate($file)
        return $temp_date
    }
}

function GetCreationDate($File) {
	switch ($File.Extension) { 
        ".jpg" { $CreationDate = getImageDateTaken($File) } 
	".jpeg" {$CreationDate = getImageDateTaken($File)}
	".bmp" {$CreationDate = GetDefaultModifiedDate($File)} 
	".png" {$CreationDate = getImageDateTaken($File)}
	".gif" {$CreationDate = GetDefaultModifiedDate($File)}
        ".mp4" {$CreationDate = getVideoMediaCreated($File)}
        ".mov" {$CreationDate = getVideoMediaCreated($File)}
        ".3gp" {$CreationDate = getVideoMediaCreated($File)}
        ".m4v" {$CreationDate = getVideoMediaCreated($File)}
    }
	return $CreationDate
}

function GetDefaultModifiedDate($File) {
	try {
		$date = Get-Date ($File.LastWriteTime)
		$new_folder_name = $File.LastWriteTime.Date.ToString('yyyy') + "\" + $File.LastWriteTime.Date.ToString('MM')
		return $new_folder_name
	}
	catch {
		return $null
	}
}

function getFilesToOrganise(){
    return @(Get-ChildItem $target_path -Recurse -Include $FileTypesToOrganize)
}



Write-host "


"
Write-host "Start Organising!"
$toSort = getFilesToOrganise
foreach ($file in $toSort) {
    $counter++
    Write-Host "File number: $counter - File name: $file"
    $sortDatePath = GetCreationDate($file)
    if ($sortDatePath -eq $null)
    {
        continue
    }
	if (test-path $des_path)
	{
		$full_path = $des_path + "\" + $file.name
	if (test-path $full_path -PathType leaf)
	{
		write-host "FILE NOT COPIED"
		write-host ""
	}
	else 
	{
        	$removeErrors = @()
		xcopy /Y /Q $file.fullname $des_path
        	#remove-item $file.fullname -ErrorAction SilentlyContinue -ErrorVariable removeErrors -Force
        	write-host ""
	}
	}
	else
	{
		new-item -ItemType directory -Path $des_path
		xcopy /Y /Q $file.fullname $des_path
        	#remove-item $file.fullname -ErrorAction SilentlyContinue -ErrorVariable removeErrors -Force
        	write-host ""
	}
}

write-host "
***************************************
FINISHED
***************************************
"
