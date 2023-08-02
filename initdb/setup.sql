create user "Implem.Pleasanter_Owner" with password '<Any Owner password>';
create schema authorization "Implem.Pleasanter_Owner";
create user "Implem.Pleasanter_User" with password '<Any User password>';
create schema authorization "Implem.Pleasanter_User";
create database "Implem.Pleasanter" with owner "Implem.Pleasanter_Owner";
\c "Implem.Pleasanter";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
