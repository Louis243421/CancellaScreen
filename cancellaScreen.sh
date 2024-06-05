#!/bin/bash 

posizioneUltimaE()
{
	nome=$1
	posizione=0
	for (( i = 0 ; i < ${#nome} ; i++ )) ; do
		if [[ ${nome:$i:1} == "e" ]] ; then
			posizione=$i

		fi

	done

	return $posizione


}        
cancella()
{    
 	local CONT=0
 	for file in $2/Screenshot*alle*.png  # cicla attraverso tutti i file png che contengono "Screenshot" e "alle"
 	do
 	nuovo_nome=`echo $file | sed "s/ //g"`  # elimina gli spazi dal nome del file
 	mv "$file" "$nuovo_nome"
 	file=$nuovo_nome
 	if [[ -f $file ]] ; then  # se esiste il file regolare  (png è regolare a quanto pare)
 		echo "Trovato file:" $file
 		posizioneUltimaE $file
 		orario=${file:($?+1):8}
 		echo $orario
 		oreFile=${orario:0:2}  # sottostringa che parte da posizione 24 di 2 caratteri (ora di creazione)
 		minutiFile=${orario:3:2}
 		secondiFile=${orario:6:2}
 		let "creazioneFile = $oreFile*3600+$minutiFile*60+$secondiFile"
 		echo $creazioneFile
 		if [[ $creazioneFile -lt $(( $1-300)) ]]; then
 			echo "File eliminato:" $file
 			rm -f $file
 			((CONT++))
 		fi
 	fi
 	done
 	echo "File eliminati:" $CONT

}

ore=$(date '+%H')

minuti=$(date '+%M')

secondi=$(date '+%S')
echo $ore:$minuti:$secondi
let "avvioProgramma = $ore*3600+$minuti*60+$secondi"
echo $avvioProgramma
if [[ $# -eq 0 || $# -ge 2 ]]; then

	echo "Il programma accetta solo un parametro"
else
	cancella $avvioProgramma $1
fi
