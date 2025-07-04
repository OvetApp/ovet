

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "moddatetime" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "wrappers" WITH SCHEMA "extensions";






CREATE TYPE "public"."enum_household_role" AS ENUM (
    'owner',
    'member'
);


ALTER TYPE "public"."enum_household_role" OWNER TO "postgres";


CREATE TYPE "public"."enum_invitation_status" AS ENUM (
    'pending',
    'accepted',
    'not_an_invitation'
);


ALTER TYPE "public"."enum_invitation_status" OWNER TO "postgres";


CREATE TYPE "public"."language_enum" AS ENUM (
    'fr',
    'en'
);


ALTER TYPE "public"."language_enum" OWNER TO "postgres";


CREATE TYPE "public"."medication_class_enum" AS ENUM (
    'disinfectant',
    'radiopharmaceutical',
    'human',
    'veterinary'
);


ALTER TYPE "public"."medication_class_enum" OWNER TO "postgres";


CREATE TYPE "public"."medication_status_enum" AS ENUM (
    'MARKETED',
    'CANCELLED POST MARKET',
    'APPROVED',
    'CANCELLED PRE MARKET',
    'DORMANT'
);


ALTER TYPE "public"."medication_status_enum" OWNER TO "postgres";


CREATE TYPE "public"."medication_vet_species_enum" AS ENUM (
    'CATTLE',
    'SWINE (PIGS)',
    'GOATS',
    'HORSES',
    'CATS',
    'SHEEP',
    'DOGS',
    'POULTRY',
    'BEES',
    'BIRDS',
    'WILD/MISCELLANEOUS',
    'GENERAL - MISC.',
    'RABBITS',
    'FINFISH',
    'LAMBS',
    'MAMMALS(MISCELLANEOUS)',
    'LABORATORY ANIMALS',
    'CRUSTACEANS'
);


ALTER TYPE "public"."medication_vet_species_enum" OWNER TO "postgres";


CREATE TYPE "public"."medication_vet_species_fr_enum" AS ENUM (
    'Bétails',
    'Porcs',
    'Chèvres',
    'Chevaux',
    'Chats',
    'Mouton',
    'Chiens',
    'Volaille',
    'Abeilles',
    'Oiseaux',
    'Sauvage/Divers',
    'Général-Misc',
    'Lapins',
    'Poisson À Nageoires',
    'Mammifères (Divers)',
    'Animaux de laboratoire',
    'Crustacés'
);


ALTER TYPE "public"."medication_vet_species_fr_enum" OWNER TO "postgres";


CREATE TYPE "public"."medication_vet_sub_species_enum" AS ENUM (
    'CALVES',
    'LAMB',
    'CHICKENS',
    'TURKEYS',
    'HONEY BEES',
    'BEEF CATTLE',
    'DAIRY CATTLE',
    'COMPANION BIRDS',
    'MINK',
    'BEEF STEERS',
    'BROILER CHICKENS',
    'SOWS',
    'PIGLETS',
    'FOALS',
    'COWS-LACTATING',
    'COWS',
    'MARES',
    'EWES',
    'BITCHES',
    'BEEF HEIFERS',
    'REPLACEMENT CHICKENS',
    'COWS-NON LACTATING',
    'COWS-DRY',
    'REPLACEMENT HEIFERS',
    'TURKEY POULTS',
    'CHICKS',
    'FEEDLOT HEIFERS',
    'STEERS',
    'BULLS',
    'RABBITS',
    'FEEDER SWINE',
    'SALMONIDS',
    'GILTS',
    'GROWER SWINE',
    'FEEDLOT STEERS',
    'COMMERCIAL LAYER HENS',
    'GROWING TURKEYS',
    'FEEDLOT CATTLE',
    'DEER',
    'KITTENS',
    'PUPPIES',
    'SALMONID (EGGS)',
    'PASTURE HEIFERS',
    'PASTURE STEERS',
    'FERRETS',
    'FEEDLOT CALVES',
    'PASTURE CATTLE (NON-LACTATING)',
    'LOBSTERS',
    'DAIRY COWS',
    'DAIRY HEIFERS'
);


ALTER TYPE "public"."medication_vet_sub_species_enum" OWNER TO "postgres";


CREATE TYPE "public"."medications_schedule_enum" AS ENUM (
    'Prescription',
    'OTC',
    'Schedule D',
    'Ethical',
    'Schedule C',
    'Narcotic (CDSA I)',
    'Targeted (CDSA IV)',
    'Prescription Recommended',
    'Schedule G (CDSA I)',
    'Schedule G (CDSA IV)',
    'Schedule G (CDSA III)',
    'Narcotic (CDSA II)',
    'Narcotic'
);


ALTER TYPE "public"."medications_schedule_enum" OWNER TO "postgres";


CREATE TYPE "public"."medications_schedule_fr_enum" AS ENUM (
    'Prescription',
    'En vente libre',
    'Annexe D',
    'Spécialité médicale',
    'Annexe C',
    'Stupéfiant (LRCDAS I)',
    'Ciblés (LRCDAS IV)',
    'Prescription (recommandé)',
    'Annexe G (LRCDAS I)',
    'Annexe G (LRCDAS IV)',
    'Annexe G (LRCDAS III)',
    'Stupéfiant (LRCDAS II)',
    'Stupéfiant'
);


ALTER TYPE "public"."medications_schedule_fr_enum" OWNER TO "postgres";


CREATE TYPE "public"."patient_status_enum" AS ENUM (
    'deceased',
    'active',
    'inactive'
);


ALTER TYPE "public"."patient_status_enum" OWNER TO "postgres";


CREATE TYPE "public"."species_enum" AS ENUM (
    'cat',
    'dog'
);


ALTER TYPE "public"."species_enum" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_household_on_user_creation"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    new_household_id uuid;
BEGIN
    -- Create a new household for the new user with the user as the creator
    INSERT INTO public.households (creator, created_at, updated_at) 
    VALUES (NEW.id, now(), now())
    RETURNING id INTO new_household_id;

    -- Link the user to the new household
    -- (db DEFAULT) invitation_status: not_an_invitation(enum), 
    -- (db DEFAULT) household_role: owner(enum), 
    INSERT INTO public.user_household (user_id, household_id)
    -- Default 
    VALUES (NEW.id, new_household_id);

    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."create_household_on_user_creation"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
begin
  insert into public.users (id, email)
  values (new.id, new.email);
  return new;
end;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."clinics" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "name" "text",
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "address" "text",
    "utc_offset_minutes" integer,
    "google_place_id" "text",
    "email" "text",
    "phone_number" "text"
);


ALTER TABLE "public"."clinics" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."encounters" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "patient_id" "uuid" NOT NULL,
    "encounter_date" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "status_code" "text" NOT NULL,
    "class_coding_code" "text",
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "verification_status" "text",
    "encounter_summary" "text",
    "clinic_id" "uuid",
    "attachments" "text"[],
    "reason_for_visit" "text"
);


ALTER TABLE "public"."encounters" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."imaging" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_id" "uuid" DEFAULT "gen_random_uuid"(),
    "encounter_id" "uuid" DEFAULT "gen_random_uuid"(),
    "summary" "text"
);


ALTER TABLE "public"."imaging" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."immunizations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "code" "text" NOT NULL,
    "occurrence_date" timestamp with time zone NOT NULL,
    "protocol_applied_dose_number" integer NOT NULL,
    "protocol_applied_series_doses" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "status" "text" NOT NULL,
    "patient_id" "uuid" NOT NULL,
    "encounter_id" "uuid",
    "attachments" "text"[]
);


ALTER TABLE "public"."immunizations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."lab_results" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_id" "uuid" NOT NULL,
    "encounter_id" "uuid",
    "summary" "text"
);


ALTER TABLE "public"."lab_results" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."medication_requests" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "status" "text",
    "patient_id" "uuid" NOT NULL,
    "encounter_id" "uuid",
    "dosage_instructions" "text",
    "code" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "route" "text",
    "frequency" integer,
    "start_date" timestamp with time zone,
    "end_date" timestamp with time zone,
    "quantity_total" double precision,
    "dose_amount" double precision,
    "quantity_unit" "text",
    "interval" "text",
    "term" "text",
    "duration" integer,
    "attachments" "text"[],
    "expiration_date" timestamp with time zone,
    "prescription_date" timestamp with time zone,
    "dose_unit" "text",
    "interval_gap" integer,
    "interval_gap_unit" "text",
    "medication_code_id" "uuid",
    "clinic_id" "uuid"
);


ALTER TABLE "public"."medication_requests" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."observations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "effective_date" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "code" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "patient_id" "uuid" NOT NULL,
    "encounter_id" "uuid",
    "value_quantity" "jsonb",
    "value_string" "text",
    "recorder_id" "uuid",
    "attachments" "text"[],
    "value_quantity_value" double precision,
    "value_quantity_unit" "text"
);


ALTER TABLE "public"."observations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."patients_files" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "encounter_id" "uuid" DEFAULT "gen_random_uuid"(),
    "user_id" "uuid",
    "immunization_id" "uuid",
    "medication_request_id" "uuid",
    "file_url" "text" NOT NULL,
    "file_name" "text",
    "lab_result_id" "uuid",
    "imaging_id" "uuid"
);


ALTER TABLE "public"."patients_files" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_encounters" AS
 SELECT "e"."id" AS "encounter_id",
    "e"."patient_id",
    "e"."encounter_date",
    "e"."status_code",
    "e"."class_coding_code",
    "e"."created_at",
    "e"."verification_status",
    "e"."encounter_summary",
    "e"."clinic_id",
    "e"."attachments",
    "e"."reason_for_visit",
    "c"."name" AS "clinic_name",
    "c"."address" AS "clinic_address",
        CASE
            WHEN ("count"("i"."encounter_id") > 0) THEN true
            ELSE false
        END AS "has_immunizations",
    "count"(DISTINCT "i"."id") AS "immunizations_count",
        CASE
            WHEN ("count"("m"."encounter_id") > 0) THEN true
            ELSE false
        END AS "has_medications",
    "count"(DISTINCT "m"."id") AS "medications_count",
        CASE
            WHEN ("count"("lr"."encounter_id") > 0) THEN true
            ELSE false
        END AS "has_lab_result",
    "count"(DISTINCT "lr"."id") AS "lab_results_count",
        CASE
            WHEN ("count"("im"."encounter_id") > 0) THEN true
            ELSE false
        END AS "has_imaging",
    "count"(DISTINCT "im"."id") AS "imaging_count",
        CASE
            WHEN ("count"("ob"."encounter_id") > 0) THEN true
            ELSE false
        END AS "has_observations",
    "count"(DISTINCT "ob"."id") AS "observations_count",
    ( SELECT
                CASE
                    WHEN ((("o"."value_quantity" ->> 'value'::"text") IS NULL) OR (("o"."value_quantity" ->> 'value'::"text") = ''::"text")) THEN NULL::"text"
                    WHEN ((("o"."value_quantity" ->> 'unit'::"text") IS NULL) OR (("o"."value_quantity" ->> 'unit'::"text") = ''::"text")) THEN ("o"."value_quantity" ->> 'value'::"text")
                    ELSE ((("o"."value_quantity" ->> 'value'::"text") || ' '::"text") || ("o"."value_quantity" ->> 'unit'::"text"))
                END AS "case"
           FROM "public"."observations" "o"
          WHERE (("o"."encounter_id" = "e"."id") AND ("o"."code" = '27113001'::"text"))
         LIMIT 1) AS "obs_weight_value",
    ( SELECT "count"("pf"."encounter_id") AS "count"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."encounter_id" = "e"."id")) AS "attachments_count"
   FROM (((((("public"."encounters" "e"
     LEFT JOIN "public"."clinics" "c" ON (("e"."clinic_id" = "c"."id")))
     LEFT JOIN "public"."immunizations" "i" ON (("e"."id" = "i"."encounter_id")))
     LEFT JOIN "public"."medication_requests" "m" ON (("e"."id" = "m"."encounter_id")))
     LEFT JOIN "public"."lab_results" "lr" ON (("e"."id" = "lr"."encounter_id")))
     LEFT JOIN "public"."imaging" "im" ON (("e"."id" = "im"."encounter_id")))
     LEFT JOIN "public"."observations" "ob" ON (("e"."id" = "ob"."encounter_id")))
  GROUP BY "e"."id", "e"."patient_id", "e"."encounter_date", "e"."status_code", "e"."class_coding_code", "e"."created_at", "e"."verification_status", "e"."encounter_summary", "e"."clinic_id", "e"."attachments", "e"."reason_for_visit", "c"."name", "c"."address";


ALTER VIEW "public"."app_encounters" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."codes_immunizations" (
    "metadata" "jsonb",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "code" "text" NOT NULL
);


ALTER TABLE "public"."codes_immunizations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."immunization_recommendations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "code" "text" NOT NULL,
    "recommendation_date" timestamp with time zone NOT NULL,
    "status" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_id" "uuid" NOT NULL,
    "source" "text"
);


ALTER TABLE "public"."immunization_recommendations" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_immunizations" AS
 SELECT "i"."id" AS "immunization_id",
    "i"."code",
    "i"."occurrence_date",
    "i"."protocol_applied_dose_number" AS "dose_number",
    "i"."protocol_applied_series_doses" AS "series_doses",
    "i"."status",
    "i"."patient_id",
    "i"."encounter_id",
    ("cim"."metadata" ->> 'display'::"text") AS "display",
    ("cim"."metadata" ->> 'displayFR'::"text") AS "display_fr",
    ("cim"."metadata" ->> 'ovetShort'::"text") AS "short",
    ("cim"."metadata" ->> 'description'::"text") AS "description",
    ("cim"."metadata" ->> 'ovetShortFR'::"text") AS "short_fr",
    ("cim"."metadata" ->> 'ovetDetailed'::"text") AS "detailed",
    ("cim"."metadata" ->> 'descriptionFR'::"text") AS "description_fr",
    ("cim"."metadata" ->> 'ovetDetailedFR'::"text") AS "detailed_fr",
    ( SELECT "count"("pf"."immunization_id") AS "count"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."immunization_id" = "i"."id")) AS "attachments_count",
    "c"."name" AS "clinic_name",
    ( SELECT "pf"."file_url"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."immunization_id" = "i"."id")
         LIMIT 1) AS "vaccine_certificate_file_url",
    ( SELECT "pf"."file_url"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."encounter_id" = "i"."encounter_id")
         LIMIT 1) AS "encounter_file_url",
        CASE
            WHEN ("i"."occurrence_date" = "max"("i"."occurrence_date") OVER (PARTITION BY "i"."patient_id", "i"."code")) THEN true
            ELSE false
        END AS "is_latest",
    "r"."recommendation_date" AS "recommended_renewal_date",
        CASE
            WHEN ("r"."recommendation_date" IS NOT NULL) THEN "date_part"('day'::"text", ("r"."recommendation_date" - "now"()))
            ELSE NULL::double precision
        END AS "days_until_renewal",
        CASE
            WHEN ("r"."recommendation_date" IS NULL) THEN NULL::numeric
            WHEN ("now"() >= "r"."recommendation_date") THEN (0)::numeric
            ELSE "round"(GREATEST((0)::numeric, LEAST((1)::numeric, (EXTRACT(epoch FROM ("r"."recommendation_date" - "now"())) / NULLIF(EXTRACT(epoch FROM ("r"."recommendation_date" - "i"."occurrence_date")), (0)::numeric)))), 2)
        END AS "renewal_time_fraction",
        CASE
            WHEN ("date_part"('day'::"text", ("r"."recommendation_date" - "now"())) <= (0)::double precision) THEN "concat"('booster is ', ((("date_part"('year'::"text", "age"("now"(), "r"."recommendation_date")) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), "r"."recommendation_date"))))::integer, ' months overdue')
            WHEN (("date_part"('day'::"text", ("r"."recommendation_date" - "now"())) >= (1)::double precision) AND ("date_part"('day'::"text", ("r"."recommendation_date" - "now"())) <= (90)::double precision)) THEN "concat"('booster is due in ', ((("date_part"('year'::"text", "age"("r"."recommendation_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("r"."recommendation_date", "now"()))))::integer, ' months')
            ELSE NULL::"text"
        END AS "status_message",
        CASE
            WHEN ("date_part"('day'::"text", ("r"."recommendation_date" - "now"())) < (0)::double precision) THEN "concat"(((("date_part"('year'::"text", "age"("now"(), "r"."recommendation_date")) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), "r"."recommendation_date"))))::integer, ' mois de retard pour le rappel de vaccin')
            WHEN (("date_part"('day'::"text", ("r"."recommendation_date" - "now"())) >= (0)::double precision) AND ("date_part"('day'::"text", ("r"."recommendation_date" - "now"())) <= (90)::double precision)) THEN "concat"('Le rappel est dans ', ((("date_part"('year'::"text", "age"("r"."recommendation_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("r"."recommendation_date", "now"()))))::integer, ' mois')
            ELSE NULL::"text"
        END AS "status_message_fr"
   FROM (((("public"."immunizations" "i"
     JOIN "public"."codes_immunizations" "cim" ON (("i"."code" = "cim"."code")))
     LEFT JOIN "public"."encounters" "e" ON (("i"."encounter_id" = "e"."id")))
     LEFT JOIN "public"."clinics" "c" ON (("e"."clinic_id" = "c"."id")))
     LEFT JOIN LATERAL ( SELECT "r_1"."recommendation_date"
           FROM "public"."immunization_recommendations" "r_1"
          WHERE (("r_1"."code" = "i"."code") AND ("r_1"."patient_id" = "i"."patient_id"))
          ORDER BY "r_1"."recommendation_date" DESC
         LIMIT 1) "r" ON (true));


ALTER VIEW "public"."app_immunizations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."patients" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "display_name" "text" NOT NULL,
    "ovet_email" "text",
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "species" "public"."species_enum" DEFAULT 'dog'::"public"."species_enum" NOT NULL,
    "breed" "text",
    "gender" "text",
    "gender_status" "text" NOT NULL,
    "birth_date" timestamp with time zone,
    "photo_url" "text",
    "microchip" "text",
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "requested_records_via_email" boolean DEFAULT false,
    "received_any_records" boolean
);


ALTER TABLE "public"."patients" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users_patients" (
    "patient_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "user_id" "uuid" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "status" "public"."patient_status_enum" DEFAULT 'active'::"public"."patient_status_enum" NOT NULL
);


ALTER TABLE "public"."users_patients" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_users_patients" AS
 SELECT "up"."patient_id",
    "up"."created_at",
    "up"."user_id",
    "up"."updated_at",
    "up"."status",
    "p"."photo_url" AS "patient_photo_url",
    "p"."created_at" AS "patient_created_at",
    "p"."display_name" AS "patient_display_name"
   FROM ("public"."users_patients" "up"
     JOIN "public"."patients" "p" ON (("p"."id" = "up"."patient_id")));


ALTER VIEW "public"."app_users_patients" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_feed" AS
 WITH "latest_encounters" AS (
         SELECT DISTINCT ON ("app_encounters"."patient_id") "app_encounters"."encounter_id",
            "app_encounters"."patient_id",
            "app_encounters"."encounter_date",
            "app_encounters"."status_code",
            "app_encounters"."class_coding_code",
            "app_encounters"."created_at",
            "app_encounters"."verification_status",
            "app_encounters"."encounter_summary",
            "app_encounters"."clinic_id",
            "app_encounters"."attachments",
            "app_encounters"."reason_for_visit",
            "app_encounters"."clinic_name",
            "app_encounters"."clinic_address",
            "app_encounters"."has_immunizations",
            "app_encounters"."immunizations_count",
            "app_encounters"."has_medications",
            "app_encounters"."medications_count",
            "app_encounters"."has_lab_result",
            "app_encounters"."lab_results_count",
            "app_encounters"."has_imaging",
            "app_encounters"."imaging_count",
            "app_encounters"."has_observations",
            "app_encounters"."observations_count",
            "app_encounters"."obs_weight_value",
            "app_encounters"."attachments_count"
           FROM "public"."app_encounters"
          ORDER BY "app_encounters"."patient_id", "app_encounters"."encounter_date" DESC
        ), "immunizations_feed" AS (
         SELECT DISTINCT ON ("i"."immunization_id") "i"."patient_id",
            "p"."display_name",
            'immunization'::"text" AS "event_type",
            ("i"."immunization_id")::"text" AS "event_id",
                CASE
                    WHEN ("i"."days_until_renewal" <= (0)::double precision) THEN "concat"("p"."display_name", '''s booster for ', "i"."short", ' is ', (((("date_part"('year'::"text", "age"("now"(), "i"."recommended_renewal_date")) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), "i"."recommended_renewal_date"))))::integer)::"text",
                    CASE
                        WHEN (((("date_part"('year'::"text", "age"("now"(), "i"."recommended_renewal_date")) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), "i"."recommended_renewal_date"))))::integer = 1) THEN ' month overdue'::"text"
                        ELSE ' months overdue'::"text"
                    END)
                    WHEN (("i"."days_until_renewal" >= (1)::double precision) AND ("i"."days_until_renewal" <= (90)::double precision)) THEN "concat"("p"."display_name", '''s booster for ', "i"."short",
                    CASE
                        WHEN (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer = 0) THEN ' is due'::"text"
                        ELSE "concat"(' is due in ', (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer)::"text",
                        CASE
                            WHEN (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer = 1) THEN ' month'::"text"
                            ELSE ' months'::"text"
                        END)
                    END)
                    ELSE NULL::"text"
                END AS "message",
                CASE
                    WHEN ("i"."days_until_renewal" < (0)::double precision) THEN "concat"('le rappel de ', "i"."short", ' de ', "p"."display_name", ' est en retard de ', (((("date_part"('year'::"text", "age"("now"(), "i"."recommended_renewal_date")) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), "i"."recommended_renewal_date"))))::integer)::"text", ' mois')
                    WHEN (("i"."days_until_renewal" >= (0)::double precision) AND ("i"."days_until_renewal" <= (90)::double precision)) THEN
                    CASE
                        WHEN (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer = 0) THEN "concat"("p"."display_name", ' est dû pour le rappel de ',
                        CASE
                            WHEN ("i"."code" = '335711000009100'::"text") THEN "i"."short_fr"
                            ELSE ("lower"("substr"("i"."short_fr", 1, 1)) || "substr"("i"."short_fr", 2))
                        END)
                        ELSE "concat"('Le rappel de ',
                        CASE
                            WHEN ("i"."code" = '335711000009100'::"text") THEN "i"."short_fr"
                            ELSE ("lower"("substr"("i"."short_fr", 1, 1)) || "substr"("i"."short_fr", 2))
                        END, ' de ', "p"."display_name", ' est dans ', (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer)::"text", ' mois')
                    END
                    ELSE NULL::"text"
                END AS "message_fr",
                CASE
                    WHEN ("i"."days_until_renewal" <= (0)::double precision) THEN "concat"('Booster for ', "i"."short", ' is ', (((("date_part"('year'::"text", "age"("now"(), "i"."recommended_renewal_date")) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), "i"."recommended_renewal_date"))))::integer)::"text",
                    CASE
                        WHEN (((("date_part"('year'::"text", "age"("now"(), "i"."recommended_renewal_date")) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), "i"."recommended_renewal_date"))))::integer = 1) THEN ' month overdue'::"text"
                        ELSE ' months overdue'::"text"
                    END)
                    WHEN (("i"."days_until_renewal" >= (1)::double precision) AND ("i"."days_until_renewal" <= (90)::double precision)) THEN "concat"('Booster for ', "i"."short",
                    CASE
                        WHEN (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer = 0) THEN ' is due'::"text"
                        ELSE "concat"(' is due in ', (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer)::"text",
                        CASE
                            WHEN (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer = 1) THEN ' month'::"text"
                            ELSE ' months'::"text"
                        END)
                    END)
                    ELSE NULL::"text"
                END AS "message_singular",
                CASE
                    WHEN ("i"."days_until_renewal" < (0)::double precision) THEN "concat"('Le rappel de ',
                    CASE
                        WHEN ("i"."code" = '335711000009100'::"text") THEN "i"."short_fr"
                        ELSE ("lower"("substr"("i"."short_fr", 1, 1)) || "substr"("i"."short_fr", 2))
                    END, ' est en retard de ', (((("date_part"('year'::"text", "age"("now"(), "i"."recommended_renewal_date")) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), "i"."recommended_renewal_date"))))::integer)::"text", ' mois')
                    WHEN (("i"."days_until_renewal" >= (0)::double precision) AND ("i"."days_until_renewal" <= (90)::double precision)) THEN
                    CASE
                        WHEN (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer = 0) THEN "concat"("p"."display_name", ' est dû pour le rappel de ',
                        CASE
                            WHEN ("i"."code" = '335711000009100'::"text") THEN "i"."short_fr"
                            ELSE ("lower"("substr"("i"."short_fr", 1, 1)) || "substr"("i"."short_fr", 2))
                        END)
                        ELSE "concat"('Le rappel de ',
                        CASE
                            WHEN ("i"."code" = '335711000009100'::"text") THEN "i"."short_fr"
                            ELSE ("lower"("substr"("i"."short_fr", 1, 1)) || "substr"("i"."short_fr", 2))
                        END, ' est dans ', (((("date_part"('year'::"text", "age"("i"."recommended_renewal_date", "now"())) * (12)::double precision) + "date_part"('month'::"text", "age"("i"."recommended_renewal_date", "now"()))))::integer)::"text", ' mois')
                    END
                    ELSE NULL::"text"
                END AS "message_singular_fr",
            "i"."occurrence_date" AS "event_date",
            "i"."recommended_renewal_date" AS "event_due_date",
                CASE
                    WHEN "i"."is_latest" THEN 'new'::"text"
                    ELSE 'archived'::"text"
                END AS "status"
           FROM (("public"."app_immunizations" "i"
             JOIN "public"."patients" "p" ON (("i"."patient_id" = "p"."id")))
             JOIN "public"."app_users_patients" "up" ON (("p"."id" = "up"."patient_id")))
          WHERE (("i"."days_until_renewal" IS NOT NULL) AND ("i"."days_until_renewal" <= (90)::double precision))
          ORDER BY "i"."immunization_id", "i"."occurrence_date" DESC
        ), "encounter_feed" AS (
         SELECT DISTINCT ON ("e"."encounter_id") "e"."patient_id",
            "p"."display_name",
            'encounter'::"text" AS "event_type",
            ("e"."encounter_id")::"text" AS "event_id",
            "concat"('Don''t forget to book ', "p"."display_name", '''s annual exam') AS "message",
            "concat"('C''est le temps de booker l''examen annuel de ', "p"."display_name") AS "message_fr",
            "concat"('Don''t forget to book the annual exam') AS "message_singular",
            "concat"('C''est le temps de booker l''examen annuel') AS "message_singular_fr",
            (("e"."encounter_date" + '1 year'::interval) - '90 days'::interval) AS "event_date",
            ("e"."encounter_date" + '1 year'::interval) AS "event_due_date",
            'new'::"text" AS "status"
           FROM (("latest_encounters" "e"
             JOIN "public"."patients" "p" ON (("e"."patient_id" = "p"."id")))
             JOIN "public"."app_users_patients" "up" ON (("p"."id" = "up"."patient_id")))
          WHERE ("now"() < ("e"."encounter_date" + '1 year'::interval))
        ), "encounter_overdue_feed" AS (
         SELECT DISTINCT ON ("e"."encounter_id") "e"."patient_id",
            "p"."display_name",
            'encounter'::"text" AS "event_type",
            ("e"."encounter_id")::"text" AS "event_id",
            "concat"("p"."display_name", '''s annual exam is ', (((("date_part"('year'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval))) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval)))))::integer)::"text",
                CASE ((("date_part"('year'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval))) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval)))))::integer
                    WHEN 1 THEN ' month overdue'::"text"
                    ELSE ' months overdue'::"text"
                END) AS "message",
            "concat"("p"."display_name", ' est en retard de ', (((("date_part"('year'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval))) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval)))))::integer)::"text", ' mois pour son examen annuel') AS "message_fr",
            "concat"('The annual exam is ', (((("date_part"('year'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval))) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval)))))::integer)::"text",
                CASE ((("date_part"('year'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval))) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval)))))::integer
                    WHEN 1 THEN ' month overdue'::"text"
                    ELSE ' months overdue'::"text"
                END) AS "message_singular",
            "concat"('L''examen annuel est en retard de ', (((("date_part"('year'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval))) * (12)::double precision) + "date_part"('month'::"text", "age"("now"(), ("e"."encounter_date" + '1 year'::interval)))))::integer)::"text", ' mois') AS "message_singular_fr",
            ("e"."encounter_date" + '1 year'::interval) AS "event_date",
            ("e"."encounter_date" + '1 year'::interval) AS "event_due_date",
            'new'::"text" AS "status"
           FROM (("latest_encounters" "e"
             JOIN "public"."patients" "p" ON (("e"."patient_id" = "p"."id")))
             JOIN "public"."app_users_patients" "up" ON (("p"."id" = "up"."patient_id")))
          WHERE ("now"() > ("e"."encounter_date" + '1 year'::interval))
        ), "requested_records_feed" AS (
         SELECT "p"."id" AS "patient_id",
            "p"."display_name",
            'request'::"text" AS "event_type",
            ('request-'::"text" || ("p"."id")::"text") AS "event_id",
            (('We''re awaiting to receive '::"text" || "p"."display_name") || '''s records from the clinic.'::"text") AS "message",
            (('Nous attendons de recevoir les dossiers de '::"text" || "p"."display_name") || ' de la clinique.'::"text") AS "message_fr",
            'We''re awaiting to receive the records from the clinic.'::"text" AS "message_singular",
            'Nous attendons de recevoir les dossiers de la clinique.'::"text" AS "message_singular_fr",
            "now"() AS "event_date",
            "now"() AS "event_due_date",
                CASE
                    WHEN ((((( SELECT "count"(*) AS "count"
                       FROM "public"."encounters" "e"
                      WHERE ("e"."patient_id" = "p"."id")) + ( SELECT "count"(*) AS "count"
                       FROM "public"."immunizations" "im"
                      WHERE ("im"."patient_id" = "p"."id"))) + ( SELECT "count"(*) AS "count"
                       FROM "public"."lab_results" "lr"
                      WHERE ("lr"."patient_id" = "p"."id"))) + ( SELECT "count"(*) AS "count"
                       FROM "public"."imaging" "i"
                      WHERE ("i"."patient_id" = "p"."id"))) = 0) THEN 'new'::"text"
                    ELSE 'archived'::"text"
                END AS "status"
           FROM "public"."patients" "p"
          WHERE ("p"."requested_records_via_email" = true)
        )
 SELECT "immunizations_feed"."patient_id",
    "immunizations_feed"."display_name",
    "immunizations_feed"."event_type",
    "immunizations_feed"."event_id",
    "immunizations_feed"."message",
    "immunizations_feed"."message_fr",
    "immunizations_feed"."message_singular",
    "immunizations_feed"."message_singular_fr",
    "immunizations_feed"."event_date",
    "immunizations_feed"."event_due_date",
    "immunizations_feed"."status"
   FROM "immunizations_feed"
UNION
 SELECT "encounter_feed"."patient_id",
    "encounter_feed"."display_name",
    "encounter_feed"."event_type",
    "encounter_feed"."event_id",
    "encounter_feed"."message",
    "encounter_feed"."message_fr",
    "encounter_feed"."message_singular",
    "encounter_feed"."message_singular_fr",
    "encounter_feed"."event_date",
    "encounter_feed"."event_due_date",
    "encounter_feed"."status"
   FROM "encounter_feed"
UNION
 SELECT "encounter_overdue_feed"."patient_id",
    "encounter_overdue_feed"."display_name",
    "encounter_overdue_feed"."event_type",
    "encounter_overdue_feed"."event_id",
    "encounter_overdue_feed"."message",
    "encounter_overdue_feed"."message_fr",
    "encounter_overdue_feed"."message_singular",
    "encounter_overdue_feed"."message_singular_fr",
    "encounter_overdue_feed"."event_date",
    "encounter_overdue_feed"."event_due_date",
    "encounter_overdue_feed"."status"
   FROM "encounter_overdue_feed"
UNION
 SELECT "requested_records_feed"."patient_id",
    "requested_records_feed"."display_name",
    "requested_records_feed"."event_type",
    "requested_records_feed"."event_id",
    "requested_records_feed"."message",
    "requested_records_feed"."message_fr",
    "requested_records_feed"."message_singular",
    "requested_records_feed"."message_singular_fr",
    "requested_records_feed"."event_date",
    "requested_records_feed"."event_due_date",
    "requested_records_feed"."status"
   FROM "requested_records_feed"
  ORDER BY 9 DESC;


ALTER VIEW "public"."app_feed" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_health_overview" AS
 WITH "patient_base" AS (
         SELECT "p"."id",
            "p"."display_name",
            "p"."birth_date",
            ("p"."birth_date" + '1 year'::interval) AS "one_year_birthday"
           FROM "public"."patients" "p"
        )
 SELECT "pb"."id" AS "patient_id",
    "pb"."display_name",
    "pb"."birth_date",
    "pb"."one_year_birthday",
        CASE
            WHEN (("result"."ideal_weight_kg" IS NULL) OR (NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text") IS NULL)) THEN NULL::"text"
            ELSE "result"."ideal_weight_kg"
        END AS "ideal_weight_kg",
        CASE
            WHEN (("result"."ideal_weight_lbs" IS NULL) OR (NULLIF("replace"("result"."ideal_weight_lbs", ' lbs'::"text", ''::"text"), ''::"text") IS NULL)) THEN NULL::"text"
            ELSE "result"."ideal_weight_lbs"
        END AS "ideal_weight_lbs",
        CASE
            WHEN (("result"."ideal_weight_kg" IS NULL) OR (NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text") IS NULL)) THEN NULL::"text"
            ELSE "result"."method"
        END AS "ideal_weight_calc",
        CASE
            WHEN (("obs"."observed_weight_kg" IS NULL) OR ("result"."ideal_weight_kg" IS NULL) OR (NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text") IS NULL)) THEN NULL::"text"
            ELSE "concat"((("round"(("obs"."observed_weight_kg" - (NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text"))::numeric), 0))::integer)::"text", ' kg')
        END AS "weight_delta_kg",
        CASE
            WHEN (("obs"."observed_weight_lbs" IS NULL) OR ("result"."ideal_weight_lbs" IS NULL) OR (NULLIF("replace"("result"."ideal_weight_lbs", ' lbs'::"text", ''::"text"), ''::"text") IS NULL)) THEN NULL::"text"
            ELSE "concat"((("round"(("obs"."observed_weight_lbs" - (NULLIF("replace"("result"."ideal_weight_lbs", ' lbs'::"text", ''::"text"), ''::"text"))::numeric), 0))::integer)::"text", ' lbs')
        END AS "weight_delta_lbs",
        CASE
            WHEN (("obs"."observed_weight_kg" IS NULL) OR ("result"."ideal_weight_kg" IS NULL) OR (NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text") IS NULL)) THEN NULL::"text"
            WHEN ("round"(("obs"."observed_weight_kg" - (NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text"))::numeric), 0) > (0)::numeric) THEN 'over'::"text"
            WHEN ("round"(("obs"."observed_weight_kg" - (NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text"))::numeric), 0) < (0)::numeric) THEN 'under'::"text"
            ELSE NULL::"text"
        END AS "delta",
    "obs"."last_weighted_at",
        CASE
            WHEN ("obs"."observed_weight_kg" IS NULL) THEN NULL::"text"
            ELSE "concat"(("obs"."observed_weight_kg")::"text", ' kg')
        END AS "last_observed_weight_kg",
        CASE
            WHEN ("obs"."observed_weight_lbs" IS NULL) THEN NULL::"text"
            ELSE "concat"(("obs"."observed_weight_lbs")::"text", ' lbs')
        END AS "last_observed_weight_lbs",
        CASE
            WHEN ("obs"."last_weighted_at" IS NULL) THEN true
            WHEN ((EXTRACT(year FROM "age"((CURRENT_DATE)::timestamp with time zone, "pb"."birth_date")) < (10)::numeric) AND ("obs"."last_weighted_at" <= (CURRENT_DATE - '6 mons'::interval))) THEN true
            WHEN ((EXTRACT(year FROM "age"((CURRENT_DATE)::timestamp with time zone, "pb"."birth_date")) >= (10)::numeric) AND ("obs"."last_weighted_at" <= (CURRENT_DATE - '3 mons'::interval))) THEN true
            ELSE false
        END AS "reassess_weight",
    "obs_stats"."min_weight_kg",
    "obs_stats"."max_weight_kg",
    "obs_stats"."min_weight_lbs",
    "obs_stats"."max_weight_lbs",
        CASE
            WHEN (("result"."ideal_weight_kg" IS NULL) OR ("obs_stats"."min_weight_kg" IS NULL) OR ("obs_stats"."max_weight_kg" IS NULL) OR (NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text") IS NULL)) THEN NULL::numeric
            ELSE "round"((
            CASE
                WHEN ("obs_stats"."max_weight_kg" = "obs_stats"."min_weight_kg") THEN 0.5
                ELSE (((NULLIF("replace"("result"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text"))::numeric - "obs_stats"."min_weight_kg") / ("obs_stats"."max_weight_kg" - "obs_stats"."min_weight_kg"))
            END * (50)::numeric), 2)
        END AS "ideal_weight_fraction"
   FROM ((("patient_base" "pb"
     LEFT JOIN LATERAL ( SELECT
                CASE
                    WHEN (NULLIF("replace"("t"."ideal_weight_kg", ' kg'::"text", ''::"text"), ''::"text") IS NULL) THEN NULL::"text"
                    ELSE "t"."ideal_weight_kg"
                END AS "ideal_weight_kg",
                CASE
                    WHEN (NULLIF("replace"("t"."ideal_weight_lbs", ' lbs'::"text", ''::"text"), ''::"text") IS NULL) THEN NULL::"text"
                    ELSE "t"."ideal_weight_lbs"
                END AS "ideal_weight_lbs",
            "t"."method",
            "t"."bcs_code"
           FROM ( SELECT
                        CASE
                            WHEN ("avg"(
                            CASE
                                WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN "o"."value_quantity_value"
                                WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN ("o"."value_quantity_value" * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END) IS NULL) THEN NULL::"text"
                            ELSE "concat"(("round"(("avg"(
                            CASE
                                WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN "o"."value_quantity_value"
                                WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN ("o"."value_quantity_value" * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END))::numeric, 0))::"text", ' kg')
                        END AS "ideal_weight_kg",
                        CASE
                            WHEN ("avg"(
                            CASE
                                WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN ("o"."value_quantity_value" * (2.20462)::double precision)
                                WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN "o"."value_quantity_value"
                                ELSE NULL::double precision
                            END) IS NULL) THEN NULL::"text"
                            ELSE "concat"(("round"(("avg"(
                            CASE
                                WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN ("o"."value_quantity_value" * (2.20462)::double precision)
                                WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN "o"."value_quantity_value"
                                ELSE NULL::double precision
                            END))::numeric, 0))::"text", ' lbs')
                        END AS "ideal_weight_lbs",
                    'one_year'::"text" AS "method",
                    NULL::"text" AS "bcs_code"
                   FROM "public"."observations" "o"
                  WHERE (("o"."code" = '27113001'::"text") AND ("o"."patient_id" = "pb"."id") AND ("o"."effective_date" >= "pb"."one_year_birthday") AND ("o"."effective_date" <= ("pb"."birth_date" + '1 year 6 mons'::interval)))
                UNION ALL
                ( SELECT
                        CASE
                            WHEN (("lower"("w"."value_quantity_unit") = 'kg'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN "concat"(("round"(("w"."value_quantity_value")::numeric, 1))::"text", ' kg')
                            WHEN (("lower"("w"."value_quantity_unit") = 'lbs'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN "concat"(("round"((("w"."value_quantity_value" * (0.45359237)::double precision))::numeric, 1))::"text", ' kg')
                            ELSE NULL::"text"
                        END AS "ideal_weight_kg",
                        CASE
                            WHEN (("lower"("w"."value_quantity_unit") = 'lbs'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN "concat"(("round"(("w"."value_quantity_value")::numeric, 1))::"text", ' lbs')
                            WHEN (("lower"("w"."value_quantity_unit") = 'kg'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN "concat"(("round"((("w"."value_quantity_value" * (2.20462)::double precision))::numeric, 1))::"text", ' lbs')
                            ELSE NULL::"text"
                        END AS "ideal_weight_lbs",
                    '5/9 score'::"text" AS "method",
                    NULL::"text" AS "bcs_code"
                   FROM ("public"."observations" "indicator"
                     JOIN "public"."observations" "w" ON (("indicator"."encounter_id" = "w"."encounter_id")))
                  WHERE (("indicator"."code" = '361971000009100'::"text") AND ("w"."code" = '27113001'::"text") AND ("indicator"."patient_id" = "pb"."id") AND ("w"."patient_id" = "pb"."id"))
                  ORDER BY "indicator"."effective_date"
                 LIMIT 1)
                UNION ALL
                ( SELECT
                        CASE
                            WHEN (
                            CASE
                                WHEN (("lower"("w"."value_quantity_unit") = 'kg'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN "w"."value_quantity_value"
                                WHEN (("lower"("w"."value_quantity_unit") = 'lbs'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN ("w"."value_quantity_value" * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END IS NULL) THEN NULL::"text"
                            ELSE "concat"(("round"(((
                            CASE
                                WHEN (("lower"("w"."value_quantity_unit") = 'kg'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN "w"."value_quantity_value"
                                WHEN (("lower"("w"."value_quantity_unit") = 'lbs'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN ("w"."value_quantity_value" * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END)::numeric / ((1)::numeric + (0.1 * ((
                            CASE "indicator"."code"
                                WHEN '361911000009107'::"text" THEN 1
                                WHEN '361921000009104'::"text" THEN 2
                                WHEN '361931000009102'::"text" THEN 3
                                WHEN '361941000009108'::"text" THEN 4
                                WHEN '361971000009100'::"text" THEN 5
                                WHEN '361951000009106'::"text" THEN 6
                                WHEN '361961000009109'::"text" THEN 7
                                WHEN '361981000009103'::"text" THEN 8
                                WHEN '361991000009101'::"text" THEN 9
                                ELSE NULL::integer
                            END - 5))::numeric))), 1))::"text", ' kg')
                        END AS "ideal_weight_kg",
                        CASE
                            WHEN (
                            CASE
                                WHEN (("lower"("w"."value_quantity_unit") = 'kg'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN "w"."value_quantity_value"
                                WHEN (("lower"("w"."value_quantity_unit") = 'lbs'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN ("w"."value_quantity_value" * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END IS NULL) THEN NULL::"text"
                            ELSE "concat"(("round"((((
                            CASE
                                WHEN (("lower"("w"."value_quantity_unit") = 'kg'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN "w"."value_quantity_value"
                                WHEN (("lower"("w"."value_quantity_unit") = 'lbs'::"text") AND ("w"."value_quantity_value" IS NOT NULL)) THEN ("w"."value_quantity_value" * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END)::numeric / ((1)::numeric + (0.1 * ((
                            CASE "indicator"."code"
                                WHEN '361911000009107'::"text" THEN 1
                                WHEN '361921000009104'::"text" THEN 2
                                WHEN '361931000009102'::"text" THEN 3
                                WHEN '361941000009108'::"text" THEN 4
                                WHEN '361971000009100'::"text" THEN 5
                                WHEN '361951000009106'::"text" THEN 6
                                WHEN '361961000009109'::"text" THEN 7
                                WHEN '361981000009103'::"text" THEN 8
                                WHEN '361991000009101'::"text" THEN 9
                                ELSE NULL::integer
                            END - 5))::numeric))) * 2.20462), 1))::"text", ' lbs')
                        END AS "ideal_weight_lbs",
                    'BCS algo'::"text" AS "method",
                    NULL::"text" AS "bcs_code"
                   FROM ("public"."observations" "indicator"
                     JOIN "public"."observations" "w" ON (("indicator"."encounter_id" = "w"."encounter_id")))
                  WHERE (("indicator"."code" = ANY (ARRAY['361911000009107'::"text", '361921000009104'::"text", '361931000009102'::"text", '361941000009108'::"text", '361971000009100'::"text", '361951000009106'::"text", '361961000009109'::"text", '361981000009103'::"text", '361991000009101'::"text"])) AND ("w"."code" = '27113001'::"text") AND ("indicator"."patient_id" = "pb"."id") AND ("w"."patient_id" = "pb"."id"))
                  ORDER BY "indicator"."effective_date" DESC
                 LIMIT 1)) "t"
          ORDER BY
                CASE "t"."method"
                    WHEN 'one_year'::"text" THEN 1
                    WHEN '5/9 score'::"text" THEN 2
                    WHEN 'BCS algo'::"text" THEN 3
                    ELSE 4
                END
         LIMIT 1) "result" ON (true))
     LEFT JOIN LATERAL ( SELECT
                CASE
                    WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN "round"(("o"."value_quantity_value")::numeric, 1)
                    WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN "round"((("o"."value_quantity_value" * (0.45359237)::double precision))::numeric, 1)
                    ELSE NULL::numeric
                END AS "observed_weight_kg",
                CASE
                    WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN "round"(("o"."value_quantity_value")::numeric, 1)
                    WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN "round"((("o"."value_quantity_value" * (2.20462)::double precision))::numeric, 1)
                    ELSE NULL::numeric
                END AS "observed_weight_lbs",
            "o"."effective_date" AS "last_weighted_at"
           FROM "public"."observations" "o"
          WHERE (("o"."code" = '27113001'::"text") AND ("o"."patient_id" = "pb"."id"))
          ORDER BY "o"."effective_date" DESC
         LIMIT 1) "obs" ON (true))
     LEFT JOIN LATERAL ( SELECT "round"("min"(
                CASE
                    WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN ("o"."value_quantity_value")::numeric
                    WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN (("o"."value_quantity_value" * (0.45359237)::double precision))::numeric
                    ELSE NULL::numeric
                END), 1) AS "min_weight_kg",
            "round"("max"(
                CASE
                    WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN ("o"."value_quantity_value")::numeric
                    WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN (("o"."value_quantity_value" * (0.45359237)::double precision))::numeric
                    ELSE NULL::numeric
                END), 1) AS "max_weight_kg",
            "round"("min"(
                CASE
                    WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN ("o"."value_quantity_value")::numeric
                    WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN (("o"."value_quantity_value" * (2.20462)::double precision))::numeric
                    ELSE NULL::numeric
                END), 1) AS "min_weight_lbs",
            "round"("max"(
                CASE
                    WHEN (("lower"("o"."value_quantity_unit") = 'lbs'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN ("o"."value_quantity_value")::numeric
                    WHEN (("lower"("o"."value_quantity_unit") = 'kg'::"text") AND ("o"."value_quantity_value" IS NOT NULL)) THEN (("o"."value_quantity_value" * (2.20462)::double precision))::numeric
                    ELSE NULL::numeric
                END), 1) AS "max_weight_lbs"
           FROM "public"."observations" "o"
          WHERE (("o"."code" = '27113001'::"text") AND ("o"."patient_id" = "pb"."id"))) "obs_stats" ON (true));


ALTER VIEW "public"."app_health_overview" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_imaging" AS
 SELECT "i"."id",
    "i"."created_at",
    "i"."patient_id",
    "i"."encounter_id",
    "i"."summary",
    "e"."encounter_date",
    ( SELECT "count"("pf"."imaging_id") AS "count"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."imaging_id" = "i"."id")) AS "attachments_count",
    ( SELECT "pf"."file_url"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."encounter_id" = "i"."encounter_id")
          ORDER BY "pf"."created_at"
         LIMIT 1) AS "encounter_file_url",
    ( SELECT "pf"."file_url"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."imaging_id" = "i"."id")
          ORDER BY "pf"."created_at"
         LIMIT 1) AS "imaging_file_url"
   FROM ("public"."imaging" "i"
     LEFT JOIN "public"."encounters" "e" ON (("i"."encounter_id" = "e"."id")));


ALTER VIEW "public"."app_imaging" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_lab_results" AS
 SELECT "lr"."id",
    "lr"."created_at",
    "lr"."patient_id",
    "lr"."encounter_id",
    "e"."encounter_date",
    "lr"."summary",
    ( SELECT "count"("pf"."lab_result_id") AS "count"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."lab_result_id" = "lr"."id")) AS "attachments_count",
    ( SELECT "pf"."file_url"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."encounter_id" = "lr"."encounter_id")
          ORDER BY "pf"."created_at"
         LIMIT 1) AS "encounter_file_url",
    ( SELECT "pf"."file_url"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."lab_result_id" = "lr"."id")
          ORDER BY "pf"."created_at"
         LIMIT 1) AS "lab_result_file_url"
   FROM ("public"."lab_results" "lr"
     LEFT JOIN "public"."encounters" "e" ON (("lr"."encounter_id" = "e"."id")));


ALTER VIEW "public"."app_lab_results" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."codes_medication_ovet" (
    "schedule" "public"."medications_schedule_enum"[] NOT NULL,
    "schedule_fr" "public"."medications_schedule_fr_enum"[] NOT NULL,
    "product_categorization" "text",
    "class" "text",
    "brand_name" "text",
    "class_fr" "text",
    "brand_name_fr" "text",
    "form" "text",
    "form_fr" "text",
    "vet_species" "public"."medication_vet_species_enum"[],
    "vet_sub_species" "public"."medication_vet_sub_species_enum"[],
    "vet_species_fr" "public"."medication_vet_species_fr_enum"[],
    "ovet_short" "text",
    "ovet_detailed" "text",
    "ovet_short_fr" "text",
    "ovet_detailed_fr" "text",
    "ovet_aliases" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "active_ingredients" "jsonb"[],
    "drug_identification_number" bigint,
    "ovet_category" "text",
    "ovet_category_fr" "text",
    "last_updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text")
);


ALTER TABLE "public"."codes_medication_ovet" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_medications" AS
 SELECT "mr"."id",
    "mr"."patient_id",
    "mr"."encounter_id",
        CASE
            WHEN (("mr"."start_date" IS NOT NULL) AND ("mr"."end_date" < CURRENT_TIMESTAMP)) THEN 'completed'::"text"
            WHEN (("mr"."expiration_date" < CURRENT_TIMESTAMP) AND ("mr"."start_date" IS NULL)) THEN 'expired'::"text"
            WHEN (("mr"."start_date" IS NOT NULL) AND ("mr"."end_date" > CURRENT_TIMESTAMP)) THEN 'ongoing'::"text"
            WHEN (("mr"."start_date" IS NULL) AND ("mr"."expiration_date" > CURRENT_TIMESTAMP)) THEN 'active'::"text"
            ELSE 'unknown'::"text"
        END AS "status",
        CASE
            WHEN (("mr"."start_date" IS NOT NULL) AND ("mr"."end_date" > CURRENT_TIMESTAMP)) THEN (("mr"."end_date")::"date" - CURRENT_DATE)
            ELSE NULL::integer
        END AS "days_left",
        CASE
            WHEN (("mr"."start_date" IS NOT NULL) AND ("mr"."end_date" IS NOT NULL) AND ("mr"."end_date" > CURRENT_TIMESTAMP)) THEN "round"(LEAST((1)::numeric, GREATEST((0)::numeric, (((CURRENT_DATE - ("mr"."start_date")::"date"))::numeric / ((("mr"."end_date")::"date" - ("mr"."start_date")::"date"))::numeric))), 2)
            ELSE NULL::numeric
        END AS "progress",
    "mr"."dosage_instructions",
    "mr"."code",
    "mr"."created_at",
    "mr"."route",
    "mr"."frequency",
    "mr"."start_date",
    "mr"."end_date",
    "mr"."quantity_total",
    "mr"."quantity_unit",
    "mr"."dose_amount",
    "mr"."dose_unit",
    "mr"."interval",
    "mr"."term",
    "mr"."duration",
    "mr"."attachments",
    "mr"."expiration_date",
    "mr"."prescription_date",
    "mr"."interval_gap",
    "mr"."interval_gap_unit",
    "cm"."drug_identification_number" AS "mp_code",
    "cm"."brand_name" AS "mp_formal_name",
    "cm"."brand_name_fr" AS "mp_fr_description",
    NULL::"text" AS "mp_type",
    "cm"."brand_name" AS "mp_display_name",
    "cm"."ovet_category" AS "ovet_categories",
    "cm"."ovet_category_fr" AS "ovet_categories_fr",
    NULL::"text" AS "mp_prescription",
    "cm"."ovet_short",
    "cm"."ovet_short_fr",
    "cm"."ovet_detailed",
    "cm"."ovet_detailed_fr",
    ( SELECT "count"("pf"."medication_request_id") AS "count"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."medication_request_id" = "mr"."id")) AS "attachments_count",
    ( SELECT "pf"."file_url"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."medication_request_id" = "mr"."id")
         LIMIT 1) AS "medication_file_url",
    "c"."name" AS "clinic_name",
    ( SELECT "pf"."file_url"
           FROM "public"."patients_files" "pf"
          WHERE ("pf"."encounter_id" = "mr"."encounter_id")
          ORDER BY "pf"."created_at"
         LIMIT 1) AS "encounter_file_url"
   FROM ((("public"."medication_requests" "mr"
     JOIN "public"."codes_medication_ovet" "cm" ON ((("mr"."code")::bigint = "cm"."drug_identification_number")))
     LEFT JOIN "public"."encounters" "e" ON (("mr"."encounter_id" = "e"."id")))
     LEFT JOIN "public"."clinics" "c" ON (("e"."clinic_id" = "c"."id")));


ALTER VIEW "public"."app_medications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."codes_observations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "code" "text" NOT NULL,
    "metadata" "jsonb"
);


ALTER TABLE "public"."codes_observations" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_observations" AS
 SELECT "o"."id",
    "o"."effective_date",
    "o"."code",
    "o"."created_at",
    "o"."patient_id",
    "o"."encounter_id",
    "o"."value_quantity",
    "o"."value_string",
    "o"."recorder_id",
    "o"."attachments",
    "o"."value_quantity_value",
    "o"."value_quantity_unit",
    ("co"."metadata" ->> 'icon'::"text") AS "icon",
    ("co"."metadata" ->> 'display'::"text") AS "display",
    ("co"."metadata" ->> 'displayFR'::"text") AS "display_fr",
    ("co"."metadata" ->> 'ovetShort'::"text") AS "ovet_short",
    ("co"."metadata" ->> 'description'::"text") AS "description",
    ("co"."metadata" ->> 'adminShortFR'::"text") AS "admin_short_fr",
    ("co"."metadata" ->> 'ovetDetailed'::"text") AS "ovet_detailed",
    ("co"."metadata" ->> 'descriptionFR'::"text") AS "description_fr",
    ("co"."metadata" ->> 'valueRequired'::"text") AS "value_required",
    ("co"."metadata" ->> 'ovetDetailedFR'::"text") AS "ovet_detailed_fr"
   FROM (( SELECT DISTINCT ON ("observations"."patient_id", "observations"."code", ("date"("observations"."effective_date"))) "observations"."id",
            "observations"."effective_date",
            "observations"."code",
            "observations"."created_at",
            "observations"."patient_id",
            "observations"."encounter_id",
            "observations"."value_quantity",
            "observations"."value_string",
            "observations"."recorder_id",
            "observations"."attachments",
            "observations"."value_quantity_value",
            "observations"."value_quantity_unit"
           FROM "public"."observations"
          ORDER BY "observations"."patient_id", "observations"."code", ("date"("observations"."effective_date")), "observations"."effective_date" DESC, "observations"."created_at" DESC) "o"
     JOIN "public"."codes_observations" "co" ON (("o"."code" = "co"."code")))
  WHERE ("o"."code" <> '27113001'::"text");


ALTER VIEW "public"."app_observations" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_patient" AS
 WITH "patient_data" AS (
         SELECT "patients"."id",
            "patients"."display_name",
            "patients"."status",
            "patients"."species",
            "patients"."breed",
            "patients"."gender",
            "patients"."gender_status",
            "patients"."ovet_email",
            "patients"."birth_date",
            "patients"."photo_url",
            "patients"."microchip",
            "patients"."requested_records_via_email",
            "patients"."received_any_records",
                CASE
                    WHEN ("patients"."birth_date" IS NULL) THEN NULL::"text"
                    WHEN (EXTRACT(year FROM "age"("patients"."birth_date")) = (0)::numeric) THEN
                    CASE
                        WHEN (EXTRACT(month FROM "age"("patients"."birth_date")) = (0)::numeric) THEN
                        CASE
                            WHEN ((EXTRACT(day FROM "age"("patients"."birth_date")) / (7)::numeric) = (1)::numeric) THEN '1 week old'::"text"
                            ELSE "concat"("floor"((EXTRACT(day FROM "age"("patients"."birth_date")) / (7)::numeric)), ' weeks old')
                        END
                        WHEN (EXTRACT(month FROM "age"("patients"."birth_date")) = (1)::numeric) THEN '1 month old'::"text"
                        ELSE "concat"(EXTRACT(month FROM "age"("patients"."birth_date")), ' months old')
                    END
                    WHEN (EXTRACT(year FROM "age"("patients"."birth_date")) = (1)::numeric) THEN '1 y.o.'::"text"
                    ELSE "concat"((EXTRACT(year FROM "age"("patients"."birth_date")))::integer, ' y.o.')
                END AS "age",
                CASE
                    WHEN ("patients"."birth_date" IS NULL) THEN NULL::"text"
                    WHEN (EXTRACT(year FROM "age"("patients"."birth_date")) = (0)::numeric) THEN
                    CASE
                        WHEN (EXTRACT(month FROM "age"("patients"."birth_date")) = (0)::numeric) THEN
                        CASE
                            WHEN ((EXTRACT(day FROM "age"("patients"."birth_date")) / (7)::numeric) = (1)::numeric) THEN '1 semaine'::"text"
                            ELSE "concat"("floor"((EXTRACT(day FROM "age"("patients"."birth_date")) / (7)::numeric)), ' semaines')
                        END
                        WHEN (EXTRACT(month FROM "age"("patients"."birth_date")) = (1)::numeric) THEN '1 mois'::"text"
                        ELSE "concat"(EXTRACT(month FROM "age"("patients"."birth_date")), ' mois')
                    END
                    WHEN (EXTRACT(year FROM "age"("patients"."birth_date")) = (1)::numeric) THEN '1 an'::"text"
                    ELSE "concat"((EXTRACT(year FROM "age"("patients"."birth_date")))::integer, ' ans')
                END AS "age_fr"
           FROM "public"."patients"
        )
 SELECT "id",
    "display_name",
    "status",
    "species",
        CASE
            WHEN ("species" = 'dog'::"public"."species_enum") THEN 'chien'::"text"
            WHEN ("species" = 'cat'::"public"."species_enum") THEN 'chat'::"text"
            ELSE ("species")::"text"
        END AS "species_fr",
    "breed",
    "gender",
        CASE
            WHEN ("gender" = 'female'::"text") THEN 'femelle'::"text"
            WHEN ("gender" = 'male'::"text") THEN 'mâle'::"text"
            ELSE "gender"
        END AS "gender_fr",
        CASE
            WHEN (("gender" = 'female'::"text") AND ("gender_status" = 'neutered'::"text")) THEN 'spayed'::"text"
            ELSE "gender_status"
        END AS "gender_status",
        CASE
            WHEN (("gender" = 'female'::"text") AND ("gender_status" = 'neutered'::"text")) THEN 'opérée'::"text"
            WHEN ("gender_status" = 'unknown'::"text") THEN 'inconnu'::"text"
            WHEN ("gender_status" = 'neutered'::"text") THEN 'stérilisé'::"text"
            WHEN ("gender_status" = 'spayed'::"text") THEN 'opérée'::"text"
            WHEN ("gender_status" = 'intact'::"text") THEN 'fertile'::"text"
            ELSE NULL::"text"
        END AS "gender_status_fr",
    "birth_date",
    "photo_url",
    "microchip",
        CASE
            WHEN (("display_name" IS NOT NULL) AND ("status" IS NOT NULL) AND ("species" IS NOT NULL) AND ("breed" IS NOT NULL) AND ("gender" IS NOT NULL) AND ("gender_status" IS NOT NULL) AND ("birth_date" IS NOT NULL) AND ("photo_url" IS NOT NULL) AND ("microchip" IS NOT NULL)) THEN true
            ELSE false
        END AS "is_onboarded",
    "age",
    "age_fr",
        CASE
            WHEN ("birth_date" IS NULL) THEN NULL::"text"
            ELSE ( SELECT ("upper"("left"("sub"."x", 1)) || SUBSTRING("sub"."x" FROM 2))
               FROM ( SELECT "concat"(
                            CASE
                                WHEN (EXTRACT(year FROM "age"("pd"."birth_date")) >= (1)::numeric) THEN "concat"((EXTRACT(year FROM "age"("pd"."birth_date")))::integer, 'y',
                                CASE
                                    WHEN (EXTRACT(month FROM "age"("pd"."birth_date")) > (0)::numeric) THEN "concat"(' ', (EXTRACT(month FROM "age"("pd"."birth_date")))::integer, 'm')
                                    ELSE ''::"text"
                                END)
                                ELSE "concat"((EXTRACT(month FROM "age"("pd"."birth_date")))::integer, 'm')
                            END, ' old ', "pd"."gender",
                            CASE
                                WHEN ("pd"."species" = 'dog'::"public"."species_enum") THEN "concat"(' ', "lower"("pd"."breed"))
                                ELSE ''::"text"
                            END) AS "x") "sub")
        END AS "byline",
        CASE
            WHEN ("birth_date" IS NULL) THEN NULL::"text"
            ELSE ( SELECT ("upper"("left"("sub"."x", 1)) || SUBSTRING("sub"."x" FROM 2))
               FROM ( SELECT
                            CASE
                                WHEN ("pd"."species" = 'dog'::"public"."species_enum") THEN "concat"("lower"("pd"."breed"), ' ',
                                CASE
                                    WHEN ("pd"."gender" = 'female'::"text") THEN 'femelle'::"text"
                                    WHEN ("pd"."gender" = 'male'::"text") THEN 'mâle'::"text"
                                    ELSE "pd"."gender"
                                END, ' de ',
                                CASE
                                    WHEN (EXTRACT(year FROM "age"("pd"."birth_date")) >= (1)::numeric) THEN "concat"(
                                    CASE
WHEN (EXTRACT(year FROM "age"("pd"."birth_date")) = (1)::numeric) THEN '1 an'::"text"
ELSE "concat"((EXTRACT(year FROM "age"("pd"."birth_date")))::integer, ' ans')
                                    END,
                                    CASE
WHEN (EXTRACT(month FROM "age"("pd"."birth_date")) > (0)::numeric) THEN "concat"(' et ', (EXTRACT(month FROM "age"("pd"."birth_date")))::integer, ' mois')
ELSE ''::"text"
                                    END)
                                    ELSE
                                    CASE
WHEN (EXTRACT(month FROM "age"("pd"."birth_date")) = (1)::numeric) THEN '1 mois'::"text"
ELSE "concat"((EXTRACT(month FROM "age"("pd"."birth_date")))::integer, ' mois')
                                    END
                                END)
                                ELSE "concat"(
                                CASE
                                    WHEN ("pd"."gender" = 'female'::"text") THEN 'femelle'::"text"
                                    WHEN ("pd"."gender" = 'male'::"text") THEN 'mâle'::"text"
                                    ELSE "pd"."gender"
                                END, ' de ',
                                CASE
                                    WHEN (EXTRACT(year FROM "age"("pd"."birth_date")) >= (1)::numeric) THEN "concat"(
                                    CASE
WHEN (EXTRACT(year FROM "age"("pd"."birth_date")) = (1)::numeric) THEN '1 an'::"text"
ELSE "concat"((EXTRACT(year FROM "age"("pd"."birth_date")))::integer, ' ans')
                                    END,
                                    CASE
WHEN (EXTRACT(month FROM "age"("pd"."birth_date")) > (0)::numeric) THEN "concat"(' et ', (EXTRACT(month FROM "age"("pd"."birth_date")))::integer, ' mois')
ELSE ''::"text"
                                    END)
                                    ELSE
                                    CASE
WHEN (EXTRACT(month FROM "age"("pd"."birth_date")) = (1)::numeric) THEN '1 mois'::"text"
ELSE "concat"((EXTRACT(month FROM "age"("pd"."birth_date")))::integer, ' mois')
                                    END
                                END)
                            END AS "x") "sub")
        END AS "byline_fr",
    (((( SELECT "count"(*) AS "count"
           FROM "public"."encounters" "e"
          WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
           FROM "public"."immunizations" "im"
          WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
           FROM "public"."lab_results" "lr"
          WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
           FROM "public"."imaging" "i"
          WHERE ("i"."patient_id" = "pd"."id"))) AS "records_count",
    "ovet_email",
    "requested_records_via_email",
    "received_any_records",
        CASE
            WHEN (("requested_records_via_email" = true) AND (("received_any_records" IS NULL) OR ("received_any_records" = false)) AND ((((( SELECT "count"(*) AS "count"
               FROM "public"."encounters" "e"
              WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
               FROM "public"."immunizations" "im"
              WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
               FROM "public"."lab_results" "lr"
              WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
               FROM "public"."imaging" "i"
              WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 2
            WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
               FROM "public"."encounters" "e"
              WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
               FROM "public"."immunizations" "im"
              WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
               FROM "public"."lab_results" "lr"
              WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
               FROM "public"."imaging" "i"
              WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 3
            WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
               FROM "public"."encounters" "e"
              WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
               FROM "public"."immunizations" "im"
              WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
               FROM "public"."lab_results" "lr"
              WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
               FROM "public"."imaging" "i"
              WHERE ("i"."patient_id" = "pd"."id"))) > 0)) THEN 4
            ELSE 1
        END AS "onboarding_step",
        CASE
            WHEN (
            CASE
                WHEN (("requested_records_via_email" = true) AND (("received_any_records" IS NULL) OR ("received_any_records" = false)) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 2
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 3
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) > 0)) THEN 4
                ELSE 1
            END = 1) THEN (('Tap here to request '::"text" || "display_name") || '''s records from your clinic.'::"text")
            WHEN (
            CASE
                WHEN (("requested_records_via_email" = true) AND (("received_any_records" IS NULL) OR ("received_any_records" = false)) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 2
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 3
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) > 0)) THEN 4
                ELSE 1
            END = 2) THEN (('We''re awaiting to receive '::"text" || "display_name") || '''s records from your clinic.'::"text")
            WHEN (
            CASE
                WHEN (("requested_records_via_email" = true) AND (("received_any_records" IS NULL) OR ("received_any_records" = false)) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 2
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 3
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) > 0)) THEN 4
                ELSE 1
            END = 3) THEN (('We are organizing '::"text" || "display_name") || '''s records. Hang tight, it''s almost ready!'::"text")
            ELSE 'You''re all set.'::"text"
        END AS "onboarding_step_text",
        CASE
            WHEN (
            CASE
                WHEN (("requested_records_via_email" = true) AND (("received_any_records" IS NULL) OR ("received_any_records" = false)) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 2
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 3
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) > 0)) THEN 4
                ELSE 1
            END = 1) THEN (('Appuyez ici pour demander les dossiers de '::"text" || "display_name") || ' à votre clinique.'::"text")
            WHEN (
            CASE
                WHEN (("requested_records_via_email" = true) AND (("received_any_records" IS NULL) OR ("received_any_records" = false)) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 2
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 3
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) > 0)) THEN 4
                ELSE 1
            END = 2) THEN (('Nous attendons de recevoir les dossiers de '::"text" || "display_name") || ' de votre clinique.'::"text")
            WHEN (
            CASE
                WHEN (("requested_records_via_email" = true) AND (("received_any_records" IS NULL) OR ("received_any_records" = false)) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 2
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) = 0)) THEN 3
                WHEN (("requested_records_via_email" = true) AND ("received_any_records" = true) AND ((((( SELECT "count"(*) AS "count"
                   FROM "public"."encounters" "e"
                  WHERE ("e"."patient_id" = "pd"."id")) + ( SELECT "count"(*) AS "count"
                   FROM "public"."immunizations" "im"
                  WHERE ("im"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."lab_results" "lr"
                  WHERE ("lr"."patient_id" = "pd"."id"))) + ( SELECT "count"(*) AS "count"
                   FROM "public"."imaging" "i"
                  WHERE ("i"."patient_id" = "pd"."id"))) > 0)) THEN 4
                ELSE 1
            END = 3) THEN (('Nous organisons les dossiers de '::"text" || "display_name") || '. Tenez bon, c''est presque prêt !'::"text")
            ELSE 'Tout est prêt.'::"text"
        END AS "onboarding_step_text_fr"
   FROM "patient_data" "pd";


ALTER VIEW "public"."app_patient" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "email" "text" NOT NULL,
    "unit" "text" DEFAULT 'metric'::"text" NOT NULL,
    "language" "text" DEFAULT 'fr'::"text" NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "person_type" "text",
    "phone_number" "text",
    "first_name" "text",
    "last_name" "text",
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "photo_url" "text",
    "terms_accepted_at" timestamp with time zone,
    "city_place_id" character varying(255)
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_records_request" AS
 SELECT "up"."user_id",
    "up"."patient_id",
    ((((((((((((((((('Hi,'::"text" || '

'::"text") || 'I am writing to request the complete medical file (clinic medical records, laboratory results, X-ray images, and any other medical documents, if applicable) for '::"text") || "p"."display_name") || ' '::"text") || "u"."last_name") || '.'::"text") || '

'::"text") || 'Please forward all documents to the following email address: '::"text") || "p"."ovet_email") || ', with my current email in CC.'::"text") || '

'::"text") || 'Thank you,'::"text") || '

'::"text") || "u"."first_name") || ' '::"text") || "u"."last_name") ||
        CASE
            WHEN ("u"."phone_number" IS NOT NULL) THEN (', '::"text" || "u"."phone_number")
            ELSE ''::"text"
        END) AS "request_email",
    ((((((((((((((((('Bonjour,'::"text" || '

'::"text") || 'Par la présente, j''aimerais obtenir le dossier médical complet (dossier médical de la clinique, résultats de laboratoire, images de radiographies, ainsi que tous autres documents médicaux, le cas échéant) pour '::"text") || "p"."display_name") || ' '::"text") || "u"."last_name") || '.'::"text") || '

'::"text") || 'S''il vous plaît, veuillez me transférer tous les documents à l''adresse courriel suivante : '::"text") || "p"."ovet_email") || ', en mettant mon courriel actuel en CC.'::"text") || '

'::"text") || 'Je vous remercie,'::"text") || '

'::"text") || "u"."first_name") || ' '::"text") || "u"."last_name") ||
        CASE
            WHEN ("u"."phone_number" IS NOT NULL) THEN (', '::"text" || "u"."phone_number")
            ELSE ''::"text"
        END) AS "request_email_fr",
    (('Request for '::"text" || "p"."display_name") || '''s medical records'::"text") AS "subject",
    ('Obtention du dossier médical de '::"text" || "p"."display_name") AS "subject_fr"
   FROM (("public"."users_patients" "up"
     JOIN "public"."patients" "p" ON (("p"."id" = "up"."patient_id")))
     JOIN "public"."users" "u" ON (("u"."id" = "up"."user_id")));


ALTER VIEW "public"."app_records_request" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."invited_users" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "invited_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "invited_user" "uuid",
    "invited_by" "uuid",
    "status" "text",
    "patient_shared" "text"[]
);


ALTER TABLE "public"."invited_users" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_user" AS
 SELECT "id",
    "created_at",
    "email",
    "unit",
    "language",
    "status",
    "person_type",
    "phone_number",
    "first_name",
    "last_name",
    "updated_at",
    "photo_url",
    ( SELECT "json_agg"("up"."patient_id" ORDER BY "up"."created_at") AS "json_agg"
           FROM ("public"."users_patients" "up"
             JOIN "public"."patients" "p" ON (("up"."patient_id" = "p"."id")))
          WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))) AS "active_patients",
    ( SELECT "count"(*) AS "count"
           FROM "public"."users_patients" "up"
          WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))) AS "active_patient_count",
    ( SELECT COALESCE("bool_and"((("p"."display_name" IS NOT NULL) AND ("p"."status" IS NOT NULL) AND ("p"."species" IS NOT NULL) AND ("p"."breed" IS NOT NULL) AND ("p"."gender" IS NOT NULL) AND ("p"."gender_status" IS NOT NULL) AND ("p"."birth_date" IS NOT NULL) AND ("p"."photo_url" IS NOT NULL) AND ("p"."microchip" IS NOT NULL))), false) AS "coalesce"
           FROM ("public"."users_patients" "up"
             JOIN "public"."patients" "p" ON (("up"."patient_id" = "p"."id")))
          WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))) AS "patients_onboarded",
    ( SELECT
                CASE
                    WHEN (("sub"."arr" IS NULL) OR ("cardinality"("sub"."arr") = 0)) THEN NULL::"text"
                    WHEN ("cardinality"("sub"."arr") = 1) THEN "sub"."arr"[1]
                    WHEN ("cardinality"("sub"."arr") = 2) THEN (("sub"."arr"[1] || ' & '::"text") || "sub"."arr"[2])
                    ELSE (("array_to_string"("sub"."arr"[1:("array_length"("sub"."arr", 1) - 1)], ', '::"text") || ', and '::"text") || "sub"."arr"["array_length"("sub"."arr", 1)])
                END AS "case"
           FROM ( SELECT "array_agg"("p"."display_name" ORDER BY "up"."created_at") AS "arr"
                   FROM ("public"."users_patients" "up"
                     JOIN "public"."patients" "p" ON (("up"."patient_id" = "p"."id")))
                  WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))) "sub") AS "patients_names",
    ( SELECT
                CASE
                    WHEN (("sub"."arr" IS NULL) OR ("cardinality"("sub"."arr") = 0)) THEN NULL::"text"
                    WHEN ("cardinality"("sub"."arr") = 1) THEN "sub"."arr"[1]
                    WHEN ("cardinality"("sub"."arr") = 2) THEN (("sub"."arr"[1] || ' et '::"text") || "sub"."arr"[2])
                    ELSE (("array_to_string"("sub"."arr"[1:("cardinality"("sub"."arr") - 1)], ', '::"text") || ' et '::"text") || "sub"."arr"["cardinality"("sub"."arr")])
                END AS "case"
           FROM ( SELECT "array_agg"("p"."display_name" ORDER BY "up"."created_at") AS "arr"
                   FROM ("public"."users_patients" "up"
                     JOIN "public"."patients" "p" ON (("up"."patient_id" = "p"."id")))
                  WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))) "sub") AS "patients_names_fr",
    (((COALESCE(( SELECT "count"(DISTINCT "i"."id") AS "count"
           FROM "public"."immunizations" "i"
          WHERE ("i"."patient_id" IN ( SELECT "up"."patient_id"
                   FROM "public"."users_patients" "up"
                  WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))))), (0)::bigint) + COALESCE(( SELECT "count"(DISTINCT "e"."id") AS "count"
           FROM "public"."encounters" "e"
          WHERE ("e"."patient_id" IN ( SELECT "up"."patient_id"
                   FROM "public"."users_patients" "up"
                  WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))))), (0)::bigint)) + COALESCE(( SELECT "count"(DISTINCT "lr"."id") AS "count"
           FROM "public"."lab_results" "lr"
          WHERE ("lr"."patient_id" IN ( SELECT "up"."patient_id"
                   FROM "public"."users_patients" "up"
                  WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))))), (0)::bigint)) + COALESCE(( SELECT "count"(DISTINCT "mr"."id") AS "count"
           FROM "public"."medication_requests" "mr"
          WHERE ("mr"."patient_id" IN ( SELECT "up"."patient_id"
                   FROM "public"."users_patients" "up"
                  WHERE (("up"."user_id" = "u"."id") AND ("up"."status" = 'active'::"public"."patient_status_enum"))))), (0)::bigint)) AS "patients_records_count",
    ( SELECT "inviter"."first_name"
           FROM ("public"."invited_users" "iu"
             JOIN "public"."users" "inviter" ON (("inviter"."id" = "iu"."invited_by")))
          WHERE ("iu"."invited_user" = "u"."id")
          ORDER BY "iu"."invited_at" DESC
         LIMIT 1) AS "inviter_name",
    ( SELECT "inviter"."email"
           FROM ("public"."invited_users" "iu"
             JOIN "public"."users" "inviter" ON (("inviter"."id" = "iu"."invited_by")))
          WHERE ("iu"."invited_user" = "u"."id")
          ORDER BY "iu"."invited_at" DESC
         LIMIT 1) AS "inviter_email"
   FROM "public"."users" "u";


ALTER VIEW "public"."app_user" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."app_weight_values" AS
 SELECT "id" AS "observations_id",
    "patient_id",
    "effective_date",
        CASE
            WHEN ("lower"("value_quantity_unit") = 'kg'::"text") THEN "round"(("value_quantity_value")::numeric, 1)
            WHEN ("lower"("value_quantity_unit") = 'lbs'::"text") THEN "round"((("value_quantity_value" * (0.45359237)::double precision))::numeric, 1)
            ELSE NULL::numeric
        END AS "value_kg",
        CASE
            WHEN ("lower"("value_quantity_unit") = 'lbs'::"text") THEN "round"(("value_quantity_value")::numeric, 1)
            WHEN ("lower"("value_quantity_unit") = 'kg'::"text") THEN "round"((("value_quantity_value" * (2.20462)::double precision))::numeric, 1)
            ELSE NULL::numeric
        END AS "value_lbs"
   FROM "public"."observations" "o"
  WHERE ("code" = '27113001'::"text");


ALTER VIEW "public"."app_weight_values" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."clinics_patients" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "clinic_id" "uuid",
    "patient_id" "uuid",
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text")
);


ALTER TABLE "public"."clinics_patients" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."code_routes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "code" "text" NOT NULL,
    "metadata" "jsonb" NOT NULL
);


ALTER TABLE "public"."code_routes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."codes_breeds" (
    "species" "text" NOT NULL,
    "language" "text" NOT NULL,
    "content" "text"[] DEFAULT '{emb,bo}'::"text"[] NOT NULL
);


ALTER TABLE "public"."codes_breeds" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."households" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "creator" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."households" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."public_legal" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "termsEn" "text",
    "termsFr" "text",
    "privacyFr" "text",
    "privacyEn" "text"
);


ALTER TABLE "public"."public_legal" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."recommendations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_id" "uuid" NOT NULL,
    "recommendation" "text" NOT NULL
);


ALTER TABLE "public"."recommendations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."survey_responses" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "survey_version" "text" NOT NULL,
    "responses" "jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."survey_responses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_household" (
    "user_id" "uuid" NOT NULL,
    "household_id" "uuid" NOT NULL,
    "household_role" "public"."enum_household_role" DEFAULT 'owner'::"public"."enum_household_role" NOT NULL,
    "invitation_status" "public"."enum_invitation_status" DEFAULT 'not_an_invitation'::"public"."enum_invitation_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL
);


ALTER TABLE "public"."user_household" OWNER TO "postgres";


ALTER TABLE ONLY "public"."clinics_patients"
    ADD CONSTRAINT "clinic_patient_unique" UNIQUE ("clinic_id", "patient_id");



ALTER TABLE ONLY "public"."clinics"
    ADD CONSTRAINT "clinics_google_place_id_key" UNIQUE ("google_place_id");



ALTER TABLE ONLY "public"."clinics_patients"
    ADD CONSTRAINT "clinics_patients_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."clinics"
    ADD CONSTRAINT "clinics_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."codes_breeds"
    ADD CONSTRAINT "codes_breed_pkey" PRIMARY KEY ("species", "language");



ALTER TABLE ONLY "public"."codes_immunizations"
    ADD CONSTRAINT "codes_immunizations_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."codes_medication_ovet"
    ADD CONSTRAINT "codes_medication_ovet_mp_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."codes_observations"
    ADD CONSTRAINT "codes_observations_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."codes_observations"
    ADD CONSTRAINT "codes_observations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."code_routes"
    ADD CONSTRAINT "codes_routes_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."code_routes"
    ADD CONSTRAINT "codes_routes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."encounters"
    ADD CONSTRAINT "encounters_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."patients_files"
    ADD CONSTRAINT "files_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."households"
    ADD CONSTRAINT "households_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."imaging"
    ADD CONSTRAINT "imaging_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."immunizations"
    ADD CONSTRAINT "immunizations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."invited_users"
    ADD CONSTRAINT "invited_users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."lab_results"
    ADD CONSTRAINT "lab_results_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."medication_requests"
    ADD CONSTRAINT "medication_requests_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."observations"
    ADD CONSTRAINT "observations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."survey_responses"
    ADD CONSTRAINT "onboarding_responses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."patients"
    ADD CONSTRAINT "patients_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."public_legal"
    ADD CONSTRAINT "public_legal_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."immunization_recommendations"
    ADD CONSTRAINT "recommendations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."recommendations"
    ADD CONSTRAINT "recommendations_pkey1" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_household"
    ADD CONSTRAINT "user_household_pkey" PRIMARY KEY ("user_id", "household_id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users_patients"
    ADD CONSTRAINT "users_patients_pkey" PRIMARY KEY ("patient_id", "user_id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_onboarding_responses_user_id" ON "public"."survey_responses" USING "btree" ("user_id");



CREATE INDEX "idx_user_household_household_id" ON "public"."user_household" USING "btree" ("household_id");



CREATE INDEX "idx_user_household_user_id" ON "public"."user_household" USING "btree" ("user_id");



CREATE INDEX "users_city_place_id_idx" ON "public"."users" USING "btree" ("city_place_id");



CREATE OR REPLACE TRIGGER "handle_updated_at" BEFORE UPDATE ON "public"."codes_medication_ovet" FOR EACH ROW EXECUTE FUNCTION "extensions"."moddatetime"('last_updated_at');



CREATE OR REPLACE TRIGGER "trigger_create_household" AFTER INSERT ON "public"."users" FOR EACH ROW EXECUTE FUNCTION "public"."create_household_on_user_creation"();



ALTER TABLE ONLY "public"."clinics_patients"
    ADD CONSTRAINT "clinics_patients_clinic_id_fkey" FOREIGN KEY ("clinic_id") REFERENCES "public"."clinics"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."clinics_patients"
    ADD CONSTRAINT "clinics_patients_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."encounters"
    ADD CONSTRAINT "encounters_clinic_id_fkey" FOREIGN KEY ("clinic_id") REFERENCES "public"."clinics"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."encounters"
    ADD CONSTRAINT "encounters_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."patients_files"
    ADD CONSTRAINT "files_record_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "public"."encounters"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."households"
    ADD CONSTRAINT "households_creator_fkey" FOREIGN KEY ("creator") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."immunization_recommendations"
    ADD CONSTRAINT "immunization_recommendations_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."immunizations"
    ADD CONSTRAINT "immunizations_code_fkey" FOREIGN KEY ("code") REFERENCES "public"."codes_immunizations"("code") ON UPDATE CASCADE;



ALTER TABLE ONLY "public"."immunizations"
    ADD CONSTRAINT "immunizations_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "public"."encounters"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."immunizations"
    ADD CONSTRAINT "immunizations_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."invited_users"
    ADD CONSTRAINT "invited_users_invited_by_fkey" FOREIGN KEY ("invited_by") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."invited_users"
    ADD CONSTRAINT "invited_users_invited_user_fkey" FOREIGN KEY ("invited_user") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lab_results"
    ADD CONSTRAINT "lab_results_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "public"."encounters"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."lab_results"
    ADD CONSTRAINT "lab_results_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."medication_requests"
    ADD CONSTRAINT "medication_requests_clinic_id_fkey" FOREIGN KEY ("clinic_id") REFERENCES "public"."clinics"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."medication_requests"
    ADD CONSTRAINT "medication_requests_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "public"."encounters"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."medication_requests"
    ADD CONSTRAINT "medication_requests_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."observations"
    ADD CONSTRAINT "observations_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "public"."encounters"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."observations"
    ADD CONSTRAINT "observations_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."observations"
    ADD CONSTRAINT "observations_recorder_id_fkey" FOREIGN KEY ("recorder_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."survey_responses"
    ADD CONSTRAINT "onboarding_responses_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."patients_files"
    ADD CONSTRAINT "patient_files_immunization_id_fkey" FOREIGN KEY ("immunization_id") REFERENCES "public"."immunizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."patients_files"
    ADD CONSTRAINT "patient_files_medication_request_id_fkey" FOREIGN KEY ("medication_request_id") REFERENCES "public"."medication_requests"("id");



ALTER TABLE ONLY "public"."patients_files"
    ADD CONSTRAINT "patients_files_imaging_id_fkey" FOREIGN KEY ("imaging_id") REFERENCES "public"."imaging"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."patients_files"
    ADD CONSTRAINT "patients_files_lab_result_id_fkey" FOREIGN KEY ("lab_result_id") REFERENCES "public"."lab_results"("id") ON UPDATE CASCADE ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."patients_files"
    ADD CONSTRAINT "patients_files_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."patients_files"
    ADD CONSTRAINT "patients_files_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."recommendations"
    ADD CONSTRAINT "recommendations_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON UPDATE CASCADE;



ALTER TABLE ONLY "public"."user_household"
    ADD CONSTRAINT "user_household_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "public"."households"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_household"
    ADD CONSTRAINT "user_household_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users_patients"
    ADD CONSTRAINT "users_patients_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "public"."patients"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users_patients"
    ADD CONSTRAINT "users_patients_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



CREATE POLICY "Authenticated observations can delete observations" ON "public"."observations" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated observations can insert observations" ON "public"."observations" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated observations can select observations" ON "public"."observations" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated observations can update observations" ON "public"."observations" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can delete clinics" ON "public"."clinics" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete clinics_patients" ON "public"."clinics_patients" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete encounters" ON "public"."encounters" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete imaging" ON "public"."imaging" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete immunization_recommendations" ON "public"."immunization_recommendations" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete immunizations" ON "public"."immunizations" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete lab results" ON "public"."lab_results" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete patients" ON "public"."patients" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete patients_files" ON "public"."patients_files" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can delete users_patients" ON "public"."users_patients" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can insert clinics" ON "public"."clinics" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert clinics_patients" ON "public"."clinics_patients" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert encounters" ON "public"."encounters" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert imaging" ON "public"."imaging" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert immunization_recommendations" ON "public"."immunization_recommendations" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert immunizations" ON "public"."immunizations" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert lab results" ON "public"."lab_results" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert patients" ON "public"."patients" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert patients_files" ON "public"."patients_files" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can insert users_patients" ON "public"."users_patients" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authenticated users can select clinics" ON "public"."clinics" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select clinics_patients" ON "public"."clinics_patients" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select encounters" ON "public"."encounters" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select imaging" ON "public"."imaging" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select immunization_recommendations" ON "public"."immunization_recommendations" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select immunizations" ON "public"."immunizations" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select lab results" ON "public"."lab_results" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select medication requests" ON "public"."medication_requests" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select observations" ON "public"."patients_files" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select patients" ON "public"."patients" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can select their own household records" ON "public"."user_household" FOR SELECT TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Authenticated users can select users_patients" ON "public"."users_patients" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can update clinics" ON "public"."clinics" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update clinics_patients" ON "public"."clinics_patients" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update encounters" ON "public"."encounters" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update imaging" ON "public"."imaging" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update immunization_recommendations" ON "public"."immunization_recommendations" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update immunizations" ON "public"."immunizations" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update lab results" ON "public"."lab_results" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update patients" ON "public"."patients" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update patients_files" ON "public"."patients_files" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Authenticated users can update users_patients" ON "public"."users_patients" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."invited_users" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."recommendations" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for specific users" ON "public"."medication_requests" FOR INSERT TO "authenticated" WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = '1c91921b-9087-4b26-b65a-880dc1763f2f'::"uuid"));



CREATE POLICY "Enable read access for all users" ON "public"."code_routes" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."codes_breeds" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."codes_immunizations" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."codes_medication_ovet" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."codes_observations" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."public_legal" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."recommendations" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."survey_responses" FOR SELECT USING (true);



CREATE POLICY "Enable users to view their own data only" ON "public"."users" FOR SELECT TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "id"));



CREATE POLICY "Specific users can delete medication requests" ON "public"."medication_requests" FOR DELETE TO "authenticated" USING ((("auth"."jwt"() ->> 'email'::"text") = ANY (ARRAY['florence@ovet.ca'::"text", 'antoine@ovet.ca'::"text", 'yan@ovet.ca'::"text"])));



CREATE POLICY "Specific users can update medication requests" ON "public"."medication_requests" FOR UPDATE TO "authenticated" USING ((("auth"."jwt"() ->> 'email'::"text") = ANY (ARRAY['florence@ovet.ca'::"text", 'antoine@ovet.ca'::"text", 'yan@ovet.ca'::"text"]))) WITH CHECK ((("auth"."jwt"() ->> 'email'::"text") = ANY (ARRAY['florence@ovet.ca'::"text", 'antoine@ovet.ca'::"text", 'yan@ovet.ca'::"text"])));



ALTER TABLE "public"."clinics" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."clinics_patients" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."code_routes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."codes_breeds" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."codes_immunizations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."codes_medication_ovet" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."codes_observations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."encounters" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."households" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."imaging" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."immunization_recommendations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."immunizations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."invited_users" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."lab_results" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."medication_requests" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."observations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."patients" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."patients_files" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."public_legal" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."recommendations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."survey_responses" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_household" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users_patients" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";





GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";























































































































































































































































































GRANT ALL ON FUNCTION "public"."create_household_on_user_creation"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_household_on_user_creation"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_household_on_user_creation"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";





















GRANT ALL ON TABLE "public"."clinics" TO "anon";
GRANT ALL ON TABLE "public"."clinics" TO "authenticated";
GRANT ALL ON TABLE "public"."clinics" TO "service_role";



GRANT ALL ON TABLE "public"."encounters" TO "anon";
GRANT ALL ON TABLE "public"."encounters" TO "authenticated";
GRANT ALL ON TABLE "public"."encounters" TO "service_role";



GRANT ALL ON TABLE "public"."imaging" TO "anon";
GRANT ALL ON TABLE "public"."imaging" TO "authenticated";
GRANT ALL ON TABLE "public"."imaging" TO "service_role";



GRANT ALL ON TABLE "public"."immunizations" TO "anon";
GRANT ALL ON TABLE "public"."immunizations" TO "authenticated";
GRANT ALL ON TABLE "public"."immunizations" TO "service_role";



GRANT ALL ON TABLE "public"."lab_results" TO "anon";
GRANT ALL ON TABLE "public"."lab_results" TO "authenticated";
GRANT ALL ON TABLE "public"."lab_results" TO "service_role";



GRANT ALL ON TABLE "public"."medication_requests" TO "anon";
GRANT ALL ON TABLE "public"."medication_requests" TO "authenticated";
GRANT ALL ON TABLE "public"."medication_requests" TO "service_role";



GRANT ALL ON TABLE "public"."observations" TO "anon";
GRANT ALL ON TABLE "public"."observations" TO "authenticated";
GRANT ALL ON TABLE "public"."observations" TO "service_role";



GRANT ALL ON TABLE "public"."patients_files" TO "anon";
GRANT ALL ON TABLE "public"."patients_files" TO "authenticated";
GRANT ALL ON TABLE "public"."patients_files" TO "service_role";



GRANT ALL ON TABLE "public"."app_encounters" TO "anon";
GRANT ALL ON TABLE "public"."app_encounters" TO "authenticated";
GRANT ALL ON TABLE "public"."app_encounters" TO "service_role";



GRANT ALL ON TABLE "public"."codes_immunizations" TO "anon";
GRANT ALL ON TABLE "public"."codes_immunizations" TO "authenticated";
GRANT ALL ON TABLE "public"."codes_immunizations" TO "service_role";



GRANT ALL ON TABLE "public"."immunization_recommendations" TO "anon";
GRANT ALL ON TABLE "public"."immunization_recommendations" TO "authenticated";
GRANT ALL ON TABLE "public"."immunization_recommendations" TO "service_role";



GRANT ALL ON TABLE "public"."app_immunizations" TO "anon";
GRANT ALL ON TABLE "public"."app_immunizations" TO "authenticated";
GRANT ALL ON TABLE "public"."app_immunizations" TO "service_role";



GRANT ALL ON TABLE "public"."patients" TO "anon";
GRANT ALL ON TABLE "public"."patients" TO "authenticated";
GRANT ALL ON TABLE "public"."patients" TO "service_role";



GRANT ALL ON TABLE "public"."users_patients" TO "anon";
GRANT ALL ON TABLE "public"."users_patients" TO "authenticated";
GRANT ALL ON TABLE "public"."users_patients" TO "service_role";



GRANT ALL ON TABLE "public"."app_users_patients" TO "anon";
GRANT ALL ON TABLE "public"."app_users_patients" TO "authenticated";
GRANT ALL ON TABLE "public"."app_users_patients" TO "service_role";



GRANT ALL ON TABLE "public"."app_feed" TO "anon";
GRANT ALL ON TABLE "public"."app_feed" TO "authenticated";
GRANT ALL ON TABLE "public"."app_feed" TO "service_role";



GRANT ALL ON TABLE "public"."app_health_overview" TO "anon";
GRANT ALL ON TABLE "public"."app_health_overview" TO "authenticated";
GRANT ALL ON TABLE "public"."app_health_overview" TO "service_role";



GRANT ALL ON TABLE "public"."app_imaging" TO "anon";
GRANT ALL ON TABLE "public"."app_imaging" TO "authenticated";
GRANT ALL ON TABLE "public"."app_imaging" TO "service_role";



GRANT ALL ON TABLE "public"."app_lab_results" TO "anon";
GRANT ALL ON TABLE "public"."app_lab_results" TO "authenticated";
GRANT ALL ON TABLE "public"."app_lab_results" TO "service_role";



GRANT ALL ON TABLE "public"."codes_medication_ovet" TO "anon";
GRANT ALL ON TABLE "public"."codes_medication_ovet" TO "authenticated";
GRANT ALL ON TABLE "public"."codes_medication_ovet" TO "service_role";



GRANT ALL ON TABLE "public"."app_medications" TO "anon";
GRANT ALL ON TABLE "public"."app_medications" TO "authenticated";
GRANT ALL ON TABLE "public"."app_medications" TO "service_role";



GRANT ALL ON TABLE "public"."codes_observations" TO "anon";
GRANT ALL ON TABLE "public"."codes_observations" TO "authenticated";
GRANT ALL ON TABLE "public"."codes_observations" TO "service_role";



GRANT ALL ON TABLE "public"."app_observations" TO "anon";
GRANT ALL ON TABLE "public"."app_observations" TO "authenticated";
GRANT ALL ON TABLE "public"."app_observations" TO "service_role";



GRANT ALL ON TABLE "public"."app_patient" TO "anon";
GRANT ALL ON TABLE "public"."app_patient" TO "authenticated";
GRANT ALL ON TABLE "public"."app_patient" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON TABLE "public"."app_records_request" TO "anon";
GRANT ALL ON TABLE "public"."app_records_request" TO "authenticated";
GRANT ALL ON TABLE "public"."app_records_request" TO "service_role";



GRANT ALL ON TABLE "public"."invited_users" TO "anon";
GRANT ALL ON TABLE "public"."invited_users" TO "authenticated";
GRANT ALL ON TABLE "public"."invited_users" TO "service_role";



GRANT ALL ON TABLE "public"."app_user" TO "anon";
GRANT ALL ON TABLE "public"."app_user" TO "authenticated";
GRANT ALL ON TABLE "public"."app_user" TO "service_role";



GRANT ALL ON TABLE "public"."app_weight_values" TO "anon";
GRANT ALL ON TABLE "public"."app_weight_values" TO "authenticated";
GRANT ALL ON TABLE "public"."app_weight_values" TO "service_role";



GRANT ALL ON TABLE "public"."clinics_patients" TO "anon";
GRANT ALL ON TABLE "public"."clinics_patients" TO "authenticated";
GRANT ALL ON TABLE "public"."clinics_patients" TO "service_role";



GRANT ALL ON TABLE "public"."code_routes" TO "anon";
GRANT ALL ON TABLE "public"."code_routes" TO "authenticated";
GRANT ALL ON TABLE "public"."code_routes" TO "service_role";



GRANT ALL ON TABLE "public"."codes_breeds" TO "anon";
GRANT ALL ON TABLE "public"."codes_breeds" TO "authenticated";
GRANT ALL ON TABLE "public"."codes_breeds" TO "service_role";



GRANT ALL ON TABLE "public"."households" TO "anon";
GRANT ALL ON TABLE "public"."households" TO "authenticated";
GRANT ALL ON TABLE "public"."households" TO "service_role";



GRANT ALL ON TABLE "public"."public_legal" TO "anon";
GRANT ALL ON TABLE "public"."public_legal" TO "authenticated";
GRANT ALL ON TABLE "public"."public_legal" TO "service_role";



GRANT ALL ON TABLE "public"."recommendations" TO "anon";
GRANT ALL ON TABLE "public"."recommendations" TO "authenticated";
GRANT ALL ON TABLE "public"."recommendations" TO "service_role";



GRANT ALL ON TABLE "public"."survey_responses" TO "anon";
GRANT ALL ON TABLE "public"."survey_responses" TO "authenticated";
GRANT ALL ON TABLE "public"."survey_responses" TO "service_role";



GRANT ALL ON TABLE "public"."user_household" TO "anon";
GRANT ALL ON TABLE "public"."user_household" TO "authenticated";
GRANT ALL ON TABLE "public"."user_household" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";






























RESET ALL;

--
-- Dumped schema changes for auth and storage
--

CREATE OR REPLACE TRIGGER "on_auth_user_created" AFTER INSERT ON "auth"."users" FOR EACH ROW EXECUTE FUNCTION "public"."handle_new_user"();



