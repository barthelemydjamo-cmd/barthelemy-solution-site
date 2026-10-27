# Barthélémy Djamo — Solutions Technologiques

## Contenu
- `index.html` : vitrine publique avec accueil, espace de travail, adresses, activités/produits, applications de contact et confidentialité.
- `admin.html` : tableau de bord privé pour ajouter, modifier, masquer ou supprimer les produits/services.
- `style.css` : design responsive pour téléphone et ordinateur.
- `config.js` : configuration Supabase à compléter.
- `supabase-setup.sql` : tables et politiques de sécurité (RLS).

## Important : publication et modification privée
Un fichier HTML seul ne peut pas fournir une authentification réellement sécurisée. Cette version utilise Supabase Auth + Row Level Security pour que la modification des produits soit réservée au compte propriétaire autorisé. La vitrine publique peut être hébergée gratuitement sur GitHub Pages, mais les contenus administrables en ligne nécessitent la configuration Supabase ci-dessous.

## Configuration requise
1. Créez un projet sur Supabase.
2. Dans **Project Settings / API**, copiez l'URL du projet et la clé `anon`/`publishable`.
3. Collez ces valeurs dans `config.js`. N'utilisez jamais la clé `service_role`.
4. Dans **Authentication / Users**, créez un utilisateur avec votre adresse e-mail et un mot de passe fort. Désactivez l'inscription publique si elle est activée.
5. Dans **SQL Editor**, exécutez tout le contenu de `supabase-setup.sql`.
6. Dans SQL Editor, exécutez ensuite cette instruction en remplaçant l'adresse par celle de votre compte :
   ```sql
   insert into public.site_admins (user_id, email)
   select id, email from auth.users
   where lower(email) = lower('VOTRE_EMAIL_PROPRIETAIRE');
   ```
   Vérifiez que la ligne a bien été créée. Ne partagez jamais votre mot de passe.
7. Dans les paramètres d'authentification Supabase, configurez les URL du site et de redirection pour votre futur domaine GitHub Pages.
8. Publiez `index.html`, `admin.html`, `style.css` et `config.js` à la racine d'un dépôt GitHub public séparé. Activez **Settings → Pages → Deploy from a branch → main / root**.
9. Votre URL prévue, si le dépôt s'appelle `barthelemydjamo-solutions`, sera :
   `https://barthelemydjamo-cmd.github.io/barthelemydjamo-solutions/`
   Cette adresse n'est pas active tant que le dépôt et GitHub Pages ne sont pas créés et publiés.
10. Ouvrez `admin.html` depuis le site publié, connectez-vous avec votre compte propriétaire et gérez vos produits.

## Sécurité
- Le site ne contient aucun mot de passe codé en dur.
- Les règles RLS protègent les opérations d'ajout, de modification et de suppression.
- La clé `anon`/`publishable` est prévue pour être utilisée côté navigateur avec RLS activée.
- Ne mettez jamais une clé `service_role`, un mot de passe ou une donnée confidentielle dans un fichier public.
- Testez les règles de sécurité avant d'ajouter des informations sensibles.
