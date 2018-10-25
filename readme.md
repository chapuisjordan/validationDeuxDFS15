#Validation Linux

### Problème rencontrées 
<p>1er problème --> Comment vérifier que le paquet est bien installé ? (RESOLU)</p>
<p>2ème problème --> HEUREUSEMENT déjà rencontré avant et passé pas mal de temps dessus...
TGCM -> effacer recopier la ligne (if pour se connecter à la vagrant)</p>
<p>3ème problème --> Retour d'erreur (sed: -e expression #1, char 3:unterminated `s' command) mais la commande fonctionne quand même
, les datas sont bien remplacés dans Vagrantfile.</p>

### Ajout d'options
<p>-Si le user ne veut pas up la vagrant il a le choix de quitter le script ou de le redémarrer.</p>
<p>  ->->S'il décide de le redémarrer une confirmation est demandé car l'ancien Vagrantfile et le data sont delete.<p>
<p>-Si le user ne veut pas se connecter à la vagrant il a le choix de quitter le script ou de le redémarrer.</p>
<p>-Pour la vérification des paquets : </p>
<ul>
<li>->Je stock dans une var une commande qui permet de me renvoyer des datas sur le paquet en fcontion de s'il est installé ou pas.</li>
<li>->Je veux récupérer seulement un de ces datas donc j'écris cette var dans un fichier texte.</li>
<li>->Je vérifie seulement cette data dans le fichier texte (ii) qui me confirme ou pas si le paquet est déjà installé.</li>
<li>->Je stock la réponse dans une var.</li>
</ul>
<p>-L'interaction avec la vagrant est faite dès le départ car j'avais déjà commencé à la créer quand j'ai sû qu'il fallait l'intégrer au moment de la connexion.</p>