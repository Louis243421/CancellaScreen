#!/bin/bash 
        
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
 		oreFile=${file:24:2}  # sottostringa che parte da posizione 24 di 2 caratteri (ora di creazione)
 		minutiFile=${file:27:2}
 		secondiFile=${file:30:2}
 		let "creazioneFile = $oreFile*3600+$minutiFile*60+$secondiFile"
 		if [[ $creazioneFile -ge $(( $1-300)) ]]; then
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
if [[$# -eq 0 || $# -ge 2]]; then

	echo "Il programma accetta solo un parametro"
else
	cancella $avvioProgramma $1
fi
