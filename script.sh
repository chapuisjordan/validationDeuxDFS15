#!/bin/bash

# Variable couleurs
rouge='\033[31m '
cyanclair='\e[1;36m'
neutre='\033[0m'

# Début du programme 
echo -e "${rouge}Nous allons créer une vagrant ! ${cyanclair}";

# Vérification du paquet Virtualbox
virtualbox=$(dpkg -l | grep virtualbox);
touch virtualbox.txt;
echo $virtualbox >> virtualbox.txt;
virtualboxInstall=$(grep -lR "ii" virtualbox.txt);
echo $virtualboxInstall;

# Vérification du paquet Vagrant
vagrant=$(dpkg -l | grep vagrant);
touch vagrant.txt;
echo $vagrant >> vagrant.txt;
vagrantInstall=$(grep -lR "ii" vagrant.txt);
echo $vagrantInstall;

# Création / Eteindre / Allumer Vagrant
select choixVagrant in 'Créer une vagrant' 'Eteindre une vagrant' 'Allumer une vagrant';do
        case $choixVagrant in 
    'Créer une vagrant' ) choixVagrant="vagrantCreate";break;;
    'Eteindre une vagrant' ) choixVagrant="vagrantDown";break;;
    'Allumer une vagrant' ) choixVagrant="vagrantOn";break;;
        esac
done

# Eteindre une vagrant
if [ $choixVagrant == "vagrantDown" ]
    then
        echo "Voici les vagrants et leurs étâts (running/poweroff), entrez l'id de celle que vous-voulez éteindre";
        vagrant global-status;
        read $idDown;
        vagrant halt $idDown;

# Allumer une vagrant
elif [ $choixVagrant == "vagrantOn" ]
    then
        echo "Voici les vagrants et leurs étâts (running/poweroff), entrez l'id de celle que vous-voulez allumer";
        vagrant global-status;
        read $idUp;
        vagrant up $idUp;

#Création d'une vagrant
elif [ $choixVagrant == "vagrantCreate" ]
    then
        # Condition pour savoir si virtualbox est installé
        if [ $virtualboxInstall == "virtualbox.txt" ]
            then
                # Condition pour savoir si vagrant est installé
                if [ $vagrantInstall == "vagrant.txt" ]
                    then
                        echo -e "${rouge}Quelle box voulez-vous ? ${cyanclair}"

                        # "Choix" de la box
                        select choix in 'ubuntu/xenial64' 'ubuntu/xenial64';do
                            case $choix in
                        'ubuntu/xenial64' ) choix="ubuntu/xenial64";break;; 
                        'ubuntu/xenial64' ) choix="ubuntu/xenial64";break;;
                            esac
                        done
                        echo -e "${rouge}Quel nom de dossier local voulez-vous ? ${cyanclair}"
                        read folderLocal;
                        echo -e "${rouge}Quel nom de dossier distant voulez-vous ? ${cyanclair}"
                        read folderDistant;
                        echo -e "${rouge}Vous allez donc créer une vagrant ubuntu/xenial64 avec comme nom de dossier local $folderLocal et comme nom de dossier distant $folderDistant${cyanclair}"
                        echo -e "$folderLocal";
                        vagrant init;   # Création du Vagrantfile
                        sed -i -e 's@base@'$choix'@g' Vagrantfile # Remplacement de la box
                        sed -i -e 's@# config.vm.synced_folder "../data", "/vagrant_data"@config.vm.synced_folder "'$folderLocal'", "'$folderDistant'"@g' Vagrantfile; # Remplacer le fichier local et distant
                        sed -i '35,+1 s/^  #//g' Vagrantfile; # Décommenter la ligne

                        echo -e "${rouge}Voici les vagrants installés sur votre ordinateur : ${cyanclair}"
                        vagrant global-status; # Afficher l'étât des vagrants
                        
                        # Démarrage ou non de la vagrant
                        echo -e "${rouge}Voulez-vous démarrer votre vagrant ? ${cyanclair}";
                        select choixUp in 'Oui' 'Non';do
                                case $choixUp in 
                            'Oui' ) choixUp="vagrantUp";break;;
                            'Non' ) choixUp="noVagrantUp";break;;
                                esac
                        done
                        # Si la vagrant démmare
                        if [ $choixUp == "vagrantUp" ]
                            then
                                vagrant up;
                                # Connexion ou pas à la vagrant
                                echo -e "${rouge}Voulez-vous vous connecter à la vagrant ? ${cyanclair}";
                                select choixConnect in 'Oui' 'Non';do
                                        case $choixConnect in 
                                    'Oui' ) choixConnect="vagrant";break;;
                                    'Non' ) choixConnect="noVagrant";break;;
                                        esac
                                done
                                # Si il y'a connexion à la vagrant
                                if [ $choixConnect == "vagrant" ]
                                    then
                                        vagrant ssh
                                fi        
                        fi
                        # Arrêt du script ou pas
                        echo -e "${rouge}Voulez-vous arrêter le script ? ${cyanclair}";
                        select stopScript in 'Oui' 'Non';do
                                case $stopScript in 
                            'Oui' ) stopScript="yes";break;;
                            'Non' ) stopScript="no";break;;
                                esac
                        done
                        # Si le script est arrété
                        if [ $stopScript == "yes" ]
                            then
                                echo -e "${rouge}Merci d'avoir utilisé mon script ! ${cyanclair}";
                        # Si le script n'est pas arrété
                        elif [ $stopScript == "no" ]
                            then
                                # Confirmation de la suppresion de Vagrantfile et data
                                echo -e "${rouge}Ceci va entrainer la destruction de l'ancienne vagrant, en êtes-vous sûr ?${cyanclair}"
                                select vagrantTrash in 'Oui' 'Non';do
                                        case $vagrantTrash in 
                                    'Oui' ) vagrantTrash="yes";break;;
                                    'Non' ) vagrantTrash="no";break;;
                                        esac
                                done
                                # Si la confirmation est accépté
                                if [ $vagrantTrash == "yes" ]
                                    then
                                        rm Vagrantfile;
                                        rm data;
                                        bash script.sh;
                                # Si la confirmation est réfusé -> Arrêt du script
                                elif [ $vagrantTrash == "no" ]
                                    then
                                        echo -e "${rouge}Merci d'avoir utilisé mon script ! ${cyanclair}";
                                fi
                        fi
                        # Si vagrant n'est pas installé
                elif [ $vagrantInstall != "vagrant.txt" ]
                    then
                        sudo apt-get install vagrant;
                        script.sh;
                fi
                # Si virtualbox n'est pas installé
        elif [ $virtualboxInstall != "virtualbox.txt" ]
            then
                sudo apt-get install virtualbox;
                bash script.sh;
        fi
fi