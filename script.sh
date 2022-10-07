#!/bin/bash

rejouer=Y;

echo "======== BIENVENUE AU MYSTERIOUS NUMBER ! ========";
echo "--- Le jeu où tu dois deviner le nombre caché ---"

while [ "$rejouer" = "y" ] || [ "$rejouer" = "Y" ]; do

    nbRandom=${RANDOM:0:2};
    nbEssai=1;
    nbEssaiMax=0;
    nbLettre=1;
    index=1;

    echo "";
    echo "Veuillez choisir la difficulté du jeu ";
    echo " • Facile - Tapez 1";
    echo " • Moyen - Tapez 2";
    echo " • Difficile - Tapez 3";
    echo " • Impossible - Tapez 4";
    printf "Quel est votre choix ? : ";
    read difficult;
    echo "";

    #boucle du choix de la difficulté
    while [ ${nbEssaiMax} -eq 0 ]; do
        if [ ${difficult} -eq 1 ]; then #niveau facile
            nbEssaiMax=50;
            echo "MODE FACILE, vous disposez de 50 tentatives pour trouver le nombre mystère";

            else if [ ${difficult} -eq 2 ]; then #niveau moyen
                nbEssaiMax=25;
                echo "MODE MOYEN, vous disposez de 25 tentatives pour trouver le nombre mystère";
            
                else if [ ${difficult} -eq 3 ]; then #niveau difficile
                    nbEssaiMax=15;
                    echo "MODE DIFFICILE, vous disposez de 15 tentatives pour trouver le nombre mystère";

                    else if [ ${difficult} -eq 4 ]; then #niveau impossible
                        nbEssaiMax=5;
                        echo "MODE IMPOSSIBLE, vous disposez de 5 tentatives pour trouver le nombre mystère";

                    else #mauvaise valeur saisie
                        echo "Le choix n'est pas valide ! Choisissez parmi les propositions suivantes : ";
                        echo "  Facile - Tapez 1";
                        echo "  Moyen - Tapez 2";
                        echo "  Difficile - Tapez 3";
                        echo "  Impossible - Tapez 4";
                        printf "Quel est votre choix ? : ";
                        read difficult;
                        echo "";
                    fi
                fi 
            fi
        fi
    done

    printf "Veuillez saisir un nombre entre 1 et 99 : "; 
    read nbPropose;

    #boucle de la partie
    while [ ${nbPropose} -ne ${nbRandom} ] && [ ${nbEssai} -ne ${nbEssaiMax} ]; do
        nbEssai=$((nbEssai+1));
        if [ ${nbPropose} -gt ${nbRandom} ]; then 
            echo "";
            echo "Votre nombre est plus grand que le nombre mystère";
            printf "Veuillez saisir un nombre entre 1 et 99 : "; 
            read nbPropose;
        else 
            echo "";
            echo "Votre nombre est plus petit que le nombre mystère";
            printf "Veuillez saisir un nombre entre 1 et 99 : "; 
            read nbPropose;
        fi
    done

    echo "";

    #si le joueur gagne
    if [ ${nbPropose} -eq ${nbRandom} ]; then
        echo "Bravo ! Vous avez trouvé le nombre mystérieux (${nbRandom}) en ${nbEssai} coups!";
        printf "Veuillez rentrer votre pseudo : ";
        read pseudo;
        echo "";


        #On vérifie que son pseudo ne dépasse pas 15 caractères sinon on le racourci 
        if [ ${#pseudo} -gt 15 ]; then
            pseudo=${pseudo:0:15};
        else
            for (( i=${#pseudo}; i<15; i++ )) #Si il fait moins de 15 caractères on rajout des espaces pour qu'il en fasse 15
            do  
                pseudo="${pseudo} "
            done
        fi
        
        old_IFS=$IFS;  #séparateur par défaut du fichier 
        IFS=$'\n'; 
        for ligne in $(cat ./leaderboard.txt)  
        do  
            if [ ${index} -le 6 ]; then
                echo "${ligne}";
            fi

            ScorePrecedent=${ligne:16}; #Récupération des derniers caractères de la ligne
            if [ "$ScorePrecedent" = "TENTATIVES" ]; then #Pour ne pas avoir d'erreur à cause de la première ligne du fichier txt
                ScorePrecedent=0;
            else if [ ${nbEssai} -le ${ScorePrecedent} ]; then #Execution du code lorsque le nombre d'essai devient plus petit que le score précédent
                    printf "" >> leaderboard.txt;
                    sed -i "${index}i${pseudo}|${nbEssai}" leaderboard.txt; 
                    break; 
                fi
            fi
            if [ ${index} -eq 21 ]; then 
                    sed -i "21d" leaderboard.txt; #Suppression de la ligne 21 du fichier pour éviter d'avoir un fichier encombrant
            fi
            index=$((index+1));
        done  
        IFS=$old_IFS; 

    else #le joueur perd
        echo "Le nombre était ${nbRandom}. Vous n'avez pas eu de chance";
    fi
    printf "Voulez-vous rejouer ? (Y/n) ";
    read rejouer;
done