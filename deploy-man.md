## Sur le site AWS

_La région est ici mise sur EU/Paris_

- creation compte AWS
- Création bicket S3 (décocher toutes les otpions mis à part bloquage pour le publique (cocher toutes les cases de ce panneau)) name : _course-s3_
- Service > IAM > Utilisateurs > Ajouter un utilisateur (name : _navylus-s3_)
- cocher _Accès par programmation_ mais pas _Accès à AWS MAnagment console_
- Attacher directement les stratégie > cocher AdministratorAccess
- ne pas ajouter de clef
- cliquer sur _Créer utilisateur_
- télécharger le fichier .csv

## Sur la machine

- mettre ce csv dans le dossier courant
- Télécharger Terraform (terraform.io[https://www.terraform.io/] > Download)
- mettre Terraform dans le dossier courant
- depuis le dossier DataBase lancer dans un terminal _terraform init_
- faire _cd ~/.ssh/_
- créer une clef ssh nomée amazon_pub ( _ssh-keygen_ puis _ssh-add -K ~/.ssh/amazon_pub_)
- retourner dans le dossier courant (dépot git)
- faire _cd live/eu-west-3/Bastion_ faire _terraform apply_
- attendre
- attendre
- faire _cd ../DataBase pui _terraform apply_
- votre application est lancée et accessible depuis l'addresse ip disponible sur le compte amazon ( Service > EC2 > Instance (navbar de gauche) > EC2 GOGIT > IP publique IPv4 (tableau du bas tout à droite ))
- Verifier que l'application tourne bien sur l'id trouvé à l'étape d'avant avec le port 8080 ( X.X.X.X:8080 )


### Le dossier courant réfère à un dossier créer pour stocker tous les fichiers utiles au déploiement
