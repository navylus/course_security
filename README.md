## Sur le site AWS

_La région est ici mise sur EU/Paris (eu-west-3)_

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

- dans un fichier nommé .env remplisser avec les clefs provenant du csv les variables suivante :
  export AWS*ACCESS_KEY=\_votre access key*
  export AWS*SECRET_KEY=\_votre secret access key*

- executer _source .env_

- Télécharger Terraform ([terraform.io](https://www.terraform.io/) > Download)

- ajouter terraform au path ou alors lancer l'executable en donnant le chemin vers celui ci. (nous réfererons à cela par la commande _terraform \*_)

- Télécharger Packer ([packer.io](https://www.packer.io/downloads.html))

- ajouter packer au path ou alors lancer l'executable en donnant le chemin vers celui ci. (nous réfererons à cela par la commande _packer \*_)

- executer _cd packer_ puis _packer build -var "aws_access_key=$AWS_ACCESS_KEY" -var "aws_secret_key=$AWS_SECRET_KEY" vm.json_


- faire _cd ~/.ssh/_

- créer une clef ssh nomée amazon\-pub ( *ssh-keygen_ puis _ssh-add -K ~/.ssh/amazon_pub*)

- retourner dans le dossier courant (dépot git)

- faire _cd live/eu-west-3/Bastion_ faire _terraform init_ puis _terraform apply_

- attendre


- depuis le dossier DataBase lancer dans un terminal _terraform init_

- faire _cd ../DataBase puis \_terraform apply_

- attendre

- votre application est lancée et accessible depuis l'addresse ip disponible sur le compte amazon ( Service > EC2 > Instance (navbar de gauche) > EC2 GOGIT > IP publique IPv4 (tableau du bas tout à droite ))

- Verifier que l'application tourne bien sur l'ip trouvé à l'étape d'avant avec le port 8080 ( X.X.X.X:8080 )

### Le dossier courant réfère à un dossier créer pour stocker tous les fichiers utiles au déploiement
