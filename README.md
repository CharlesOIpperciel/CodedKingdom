# Royaumes Codés 🪄🧙‍♂️

## Description
**Royaumes Codés** est un jeu vidéo éducatif développé dans le cadre du cours IFT592 à la Faculté des Sciences, Département d'Informatique. Le projet consiste à créer un jeu d'aventure magique avec le moteur Godot, où les joueurs apprennent la programmation en écrivant du code pour avancer dans le jeu.

## Objectifs
- **Créer un Jeu Éducatif Engageant** : Développer un jeu où les joueurs apprennent la programmation à travers des défis.
- **Intégrer l’Interprétation de Code** : Permettre l'écriture et l'exécution de code pour résoudre des puzzles.
- **Garantir une Expérience Fluide** : Assurer une gestion efficace des erreurs et des retours clairs aux joueurs.
- **Faciliter l'Apprentissage** : Concevoir des défis progressifs pour enseigner les concepts de programmation.
- **Documenter le Développement** : Maintenir une documentation complète sur les fonctionnalités et les défis.
- **Évaluer et Améliorer** : Réfléchir aux compétences acquises pour améliorer le jeu et les méthodes d’enseignement.

## Fonctionnalités Clés
- **Mécanismes de Jeu Basés sur la Programmation** : Résolution de puzzles et combats en utilisant des concepts de programmation.
- **Gestion Dynamique des Erreurs** : Feedback clair sur les erreurs de code.
- **Défis Progressifs** : Enseignement intuitif des concepts de programmation.

## Cloner le Dépôt
**Assurez-vous d'avoir configuré vos clés SSH avec votre compte GitLab pour accéder au dépôt.**

Pour cloner ce dépôt via SSH, utilisez la commande suivante :

```bash
git@github.com:CharlesOIpperciel/CodedKingdom.git
```
## F.A.Q

### **Why is the project all messed up on my Godot?**
You **MUST** use **Godot 3.5.3** to ensure everything works correctly. Using a different version may cause unexpected issues.

# Guide pour faire un release de ton jeu Godot avec une lib Python

Tu veux faire un release de ton jeu Godot avec une lib Python et tu ne sais pas comment? Pas de panique, voici les étapes!

---

### 1. Télécharger les templates d'export
- Va dans **Editor > Manage Export Templates > Download & Install**.

---

### 2. Configurer l'exportation
- Va dans **Project > Export**.
- Décoche l'option **Action > Modify Resources**, sinon ça risque de causer des erreurs.

---

### 3. Exporter le projet
- Choisis l'option **PCK/Zip**.
- Exporte dans un **dossier vide**.

---

### 4. Préparer les fichiers
- Ouvre le dossier vide où tu as exporté le projet.
- Ouvre également ton projet Godot.

---

### 5. Ajouter les fichiers addons
- Copie le dossier `addons` de ton projet Godot dans le dossier où tu as exporté.
- Vérifie que le fichier exporté **ne contient pas déjà** de dossier `addons`.

---

### 6. Ajouter le fichier exécutable
- Va dans **%APPDATA%\Godot\templates\\** (sur Linux, cherche l'emplacement équivalent).
- Trouve et copie le fichier `windows_64_release.exe`.
- Colle-le dans le dossier exporté.

---

### 7. Ajouter les ressources spécifiques
- Va dans **\codedkingdoms\Assets** et copie les dossiers suivants dans le dossier exporté :
  - `Text`
  - `Music`

---

### 8. Tester le release
- Lance le fichier `.exe` via un terminal **CMD** pour voir les erreurs éventuelles.

---

### Et voilà! 🎉
Ton release est prêt. Bonne chance avec ton jeu!


## Contributeurs
- Charles-Olivier Ipperciel
- Alexandre Desfossés
- Nicolas Bellavance
- Maxime Girard Hivon
