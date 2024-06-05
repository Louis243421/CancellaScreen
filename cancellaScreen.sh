#!/bin/bash

# Funzione per trovare la posizione dell'ultima 'e' nel nome del file
posizioneUltimaE()
{
    nome=$1
    posizione=0
    # Ciclo attraverso ogni carattere nel nome del file
    for (( i = 0 ; i < ${#nome} ; i++ )) ; do
        # Se il carattere corrente è 'e', aggiorna la posizione
        if [[ ${nome:$i:1} == "e" ]] ; then
            posizione=$i
        fi
    done

    # Restituisci la posizione dell'ultima 'e'
    return $posizione
}        

# Funzione per cancellare i file secondo certe condizioni
cancella()
{    
    local CONT=0
    # Cicla attraverso tutti i file png che contengono "Screenshot" e "alle"
    for file in $2/Screenshot*alle*.png  
    do
        # Elimina gli spazi dal nome del file
        nuovo_nome=`echo $file | sed "s/ //g"`  
        mv "$file" "$nuovo_nome"
        file=$nuovo_nome

        # Se esiste il file regolare (png è regolare a quanto pare)
        if [[ -f $file ]] ; then  
            echo "Trovato file:" $file
            posizioneUltimaE $file
            # Ottieni il codice di uscita della funzione posizioneUltimaE
            orario=${file:($?+1):8}
            echo $orario

            # Estrarre ora, minuti e secondi dall'orario
            oreFile=${orario:0:2}  
            minutiFile=${orario:3:2}
            secondiFile=${orario:6:2}
            let "creazioneFile = $oreFile*3600+$minutiFile*60+$secondiFile"
            echo $creazioneFile

            # Se l'orario di creazione del file è inferiore a 5 minuti fa, elimina il file
            if [[ $creazioneFile -lt $(( $1-300)) ]]; then
                echo "File eliminato:" $file
                rm -f $file
                ((CONT++))
            fi
        fi
    done
    echo "File eliminati:" $CONT
}

# Ottieni l'ora attuale in ore, minuti e secondi
ore=$(date '+%H')
minuti=$(date '+%M')
secondi=$(date '+%S')
echo $ore:$minuti:$secondi

# Calcola l'orario di avvio del programma in secondi
let "avvioProgramma = $ore*3600+$minuti*60+$secondi"
echo $avvioProgramma

# Verifica che il numero di parametri sia corretto
if [[ $# -eq 0 || $# -ge 2 ]]; then
    echo "Il programma accetta solo un parametro"
else
    cancella $avvioProgramma $1
fi
