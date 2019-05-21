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
- créer plusieurs dossier avec le format suivant :
  *live
  *eu-west-3
  *DataBase
  *main.tf

### Le dossier courant réfère à un dossier créer pour stocker tous les fichiers utiles au déploiement
