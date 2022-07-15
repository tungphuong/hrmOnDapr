CREATE TABLE IF NOT EXISTS public.activity_audits
(
    "Id" SERIAL NOT NULL,
    "ActBy" varchar(50) NOT NULL,
    "IP" varchar(20) NULL,
    "Browser" varchar(200) NULL,
    CONSTRAINT activity_audit_pkey PRIMARY KEY ("Id")
)