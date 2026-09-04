#!/bin/bash
# Version V1
# variable declaration here 
Path=${PWD}  
FactoryLogPath=/var/log/factory.log
OKLast=""
NGLast=""
LastFile=""

echo "--------------------------------------"
echo "Get Last MT log file(csv)"
function Getdir()
{
	for file in $1/*
		do
			if test -f $file
				then
					#echo $file
					filename=$(basename "$file")	
					#echo $filename
					ext="${filename##*.}"
					#echo $ext
					
					if [ "$ext" == "csv" ];
					then	
						if [[ $filename == *"_"* ]]
						then
							arr=(${filename//_/ })
							if [ "${arr[0]}" == "OK" ]
							then
								OKarr=(${OKarr[*]} $file)
							else
								NGarr=(${NGarr[*]} $file)
							fi
						fi
					fi	
			else
				Getdir $file
			fi
		done
		
		
	if [ ${#OKarr[@]} -gt 0 ]
		then
			OKLast=${OKarr[-1]}
	fi
	#echo $OKLast
	
	if [ ${#NGarr[@]} -gt 0 ]
		then
			NGLast=${NGarr[-1]}
	fi
	#echo $NGLast
}

function GetLastFile()
{
	if [ ! "$OKLast" == "" ] && [ ! "$NGLast" == "" ]
		then
			sOKName=$(basename "$OKLast")
			sTmp=(${sOKName//_/ })
			sNum=${sTmp[-1]}
			#echo $sNum
			nTmp=(${sNum//./ })
			nOKNum=${nTmp[0]}
			#echo $nOKNum
		
			sNGName=$(basename "$NGLast")
			sTmp=(${sNGName//_/ })
			sNum=${sTmp[-1]}
			#echo $sNum
			nTmp=(${sNum//./ })
			nNGNum=${nTmp[0]}
			#echo $nNGNum
		
			if [ "$nOKNum" -gt "$nNGNum" ]
				then
					LastFile=${OKLast}
				else
					LastFile=${NGLast}
			fi
	elif [ ! "$OKLast" == "" ] && [ "$NGLast" == "" ]
		then
			LastFile=${OKLast}
	elif [ "$OKLast" == "" ] && [ ! "$NGLast" == "" ]
		then
			LastFile=${NGLast}
	else
		echo "MT Log file not exist!"
		echo "Result: 255 (Fail)."
		exit 255
	fi

	#echo $LastFile
}

function Export()
{
	echo "MT Log path=${LastFile}"
	if [ -f "$FactoryLogPath" ]
		then
			while read line
			do
				echo "[ELAN] $line" >> "$FactoryLogPath"
			done < ${LastFile}
			echo "Export data successfully."
			echo "Result: 0 (Pass)."
			exit 0
	else
		echo "${FactoryLogPath} not exist."
		echo "Result: 255 (Fail)."
		exit 255
	fi
}

Getdir $Path
GetLastFile
Export

