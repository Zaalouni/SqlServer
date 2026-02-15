# SqlServer — Contexte rapide IA

## Quoi
Collection de 26 scripts T-SQL utilitaires pour DBA SQL Server, organises en 5 dossiers thematiques. Compatibles SQL Server 2016+.

## Structure
| Dossier | Scripts | Theme |
|---------|---------|-------|
| index-management/ | 7 | Index manquants, fragmentation, doublons, inutilises |
| backup-monitoring/ | 5 | Historique backup, progression restore, alertes |
| performance/ | 6 | Requetes couteuses, waits, blocages, TempDB |
| audit-security/ | 4 | Logins, permissions, tentatives echouees, roles |
| database-inventory/ | 4 | Tailles DB, tables, infos instance |

## Conventions
- Header/footer identique sur chaque fichier (auteur, URL, description)
- Nommage : DB_Description_En_PascalCase.sql
- Commentaires en anglais dans le SQL
- Pas de USE database en dur sauf quand necessaire (context-dependent)
- DMVs sys.dm_* pour les donnees dynamiques

## Auteur
- Zaalouni — github.com/Zaalouni/SqlServer
- Site : aws-senior.com
