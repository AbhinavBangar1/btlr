BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "student_profile" ADD COLUMN "githubUsername" text;
ALTER TABLE "student_profile" ADD COLUMN "leetcodeUsername" text;
ALTER TABLE "student_profile" ADD COLUMN "codeforcesUsername" text;
ALTER TABLE "student_profile" ADD COLUMN "linkedinUrl" text;
ALTER TABLE "student_profile" ADD COLUMN "portfolioUrl" text;

--
-- MIGRATION VERSION FOR btlr
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('btlr', '20260129190434943', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129190434943', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
