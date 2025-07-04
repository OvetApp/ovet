create extension if not exists "moddatetime" with schema "extensions";

create extension if not exists "wrappers" with schema "extensions";


create type "public"."enum_household_role" as enum ('owner', 'member');

create type "public"."enum_invitation_status" as enum ('pending', 'accepted', 'not_an_invitation');

create type "public"."language_enum" as enum ('fr', 'en');

create type "public"."medication_class_enum" as enum ('disinfectant', 'radiopharmaceutical', 'human', 'veterinary');

create type "public"."medication_status_enum" as enum ('MARKETED', 'CANCELLED POST MARKET', 'APPROVED', 'CANCELLED PRE MARKET', 'DORMANT');

create type "public"."medication_vet_species_enum" as enum ('CATTLE', 'SWINE (PIGS)', 'GOATS', 'HORSES', 'CATS', 'SHEEP', 'DOGS', 'POULTRY', 'BEES', 'BIRDS', 'WILD/MISCELLANEOUS', 'GENERAL - MISC.', 'RABBITS', 'FINFISH', 'LAMBS', 'MAMMALS(MISCELLANEOUS)', 'LABORATORY ANIMALS', 'CRUSTACEANS');

create type "public"."medication_vet_species_fr_enum" as enum ('Bétails', 'Porcs', 'Chèvres', 'Chevaux', 'Chats', 'Mouton', 'Chiens', 'Volaille', 'Abeilles', 'Oiseaux', 'Sauvage/Divers', 'Général-Misc', 'Lapins', 'Poisson À Nageoires', 'Mammifères (Divers)', 'Animaux de laboratoire', 'Crustacés');

create type "public"."medication_vet_sub_species_enum" as enum ('CALVES', 'LAMB', 'CHICKENS', 'TURKEYS', 'HONEY BEES', 'BEEF CATTLE', 'DAIRY CATTLE', 'COMPANION BIRDS', 'MINK', 'BEEF STEERS', 'BROILER CHICKENS', 'SOWS', 'PIGLETS', 'FOALS', 'COWS-LACTATING', 'COWS', 'MARES', 'EWES', 'BITCHES', 'BEEF HEIFERS', 'REPLACEMENT CHICKENS', 'COWS-NON LACTATING', 'COWS-DRY', 'REPLACEMENT HEIFERS', 'TURKEY POULTS', 'CHICKS', 'FEEDLOT HEIFERS', 'STEERS', 'BULLS', 'RABBITS', 'FEEDER SWINE', 'SALMONIDS', 'GILTS', 'GROWER SWINE', 'FEEDLOT STEERS', 'COMMERCIAL LAYER HENS', 'GROWING TURKEYS', 'FEEDLOT CATTLE', 'DEER', 'KITTENS', 'PUPPIES', 'SALMONID (EGGS)', 'PASTURE HEIFERS', 'PASTURE STEERS', 'FERRETS', 'FEEDLOT CALVES', 'PASTURE CATTLE (NON-LACTATING)', 'LOBSTERS', 'DAIRY COWS', 'DAIRY HEIFERS');

create type "public"."medications_schedule_enum" as enum ('Prescription', 'OTC', 'Schedule D', 'Ethical', 'Schedule C', 'Narcotic (CDSA I)', 'Targeted (CDSA IV)', 'Prescription Recommended', 'Schedule G (CDSA I)', 'Schedule G (CDSA IV)', 'Schedule G (CDSA III)', 'Narcotic (CDSA II)', 'Narcotic');

create type "public"."medications_schedule_fr_enum" as enum ('Prescription', 'En vente libre', 'Annexe D', 'Spécialité médicale', 'Annexe C', 'Stupéfiant (LRCDAS I)', 'Ciblés (LRCDAS IV)', 'Prescription (recommandé)', 'Annexe G (LRCDAS I)', 'Annexe G (LRCDAS IV)', 'Annexe G (LRCDAS III)', 'Stupéfiant (LRCDAS II)', 'Stupéfiant');

create type "public"."patient_status_enum" as enum ('deceased', 'active', 'inactive');

create type "public"."species_enum" as enum ('cat', 'dog');

create table "public"."clinics" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "name" text,
    "updated_at" timestamp with time zone default (now() AT TIME ZONE 'utc'::text),
    "address" text,
    "utc_offset_minutes" integer,
    "google_place_id" text,
    "email" text,
    "phone_number" text
);


alter table "public"."clinics" enable row level security;

create table "public"."clinics_patients" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "clinic_id" uuid,
    "patient_id" uuid,
    "updated_at" timestamp with time zone default (now() AT TIME ZONE 'utc'::text)
);


alter table "public"."clinics_patients" enable row level security;

create table "public"."code_routes" (
    "id" uuid not null default gen_random_uuid(),
    "code" text not null,
    "metadata" jsonb not null
);


alter table "public"."code_routes" enable row level security;

create table "public"."codes_breeds" (
    "species" text not null,
    "language" text not null,
    "content" text[] not null default '{emb,bo}'::text[]
);


alter table "public"."codes_breeds" enable row level security;

create table "public"."codes_immunizations" (
    "metadata" jsonb,
    "id" uuid not null default gen_random_uuid(),
    "code" text not null
);


alter table "public"."codes_immunizations" enable row level security;

create table "public"."codes_medication_ovet" (
    "schedule" medications_schedule_enum[] not null,
    "schedule_fr" medications_schedule_fr_enum[] not null,
    "product_categorization" text,
    "class" text,
    "brand_name" text,
    "class_fr" text,
    "brand_name_fr" text,
    "form" text,
    "form_fr" text,
    "vet_species" medication_vet_species_enum[],
    "vet_sub_species" medication_vet_sub_species_enum[],
    "vet_species_fr" medication_vet_species_fr_enum[],
    "ovet_short" text,
    "ovet_detailed" text,
    "ovet_short_fr" text,
    "ovet_detailed_fr" text,
    "ovet_aliases" text,
    "id" uuid not null default gen_random_uuid(),
    "active_ingredients" jsonb[],
    "drug_identification_number" bigint,
    "ovet_category" text,
    "ovet_category_fr" text,
    "last_updated_at" timestamp with time zone default (now() AT TIME ZONE 'utc'::text)
);


alter table "public"."codes_medication_ovet" enable row level security;

create table "public"."codes_observations" (
    "id" uuid not null default gen_random_uuid(),
    "code" text not null,
    "metadata" jsonb
);


alter table "public"."codes_observations" enable row level security;

create table "public"."encounters" (
    "id" uuid not null default uuid_generate_v4(),
    "patient_id" uuid not null,
    "encounter_date" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "status_code" text not null,
    "class_coding_code" text,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "verification_status" text,
    "encounter_summary" text,
    "clinic_id" uuid,
    "attachments" text[],
    "reason_for_visit" text
);


alter table "public"."encounters" enable row level security;

create table "public"."households" (
    "id" uuid not null default gen_random_uuid(),
    "creator" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
);


alter table "public"."households" enable row level security;

create table "public"."imaging" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "patient_id" uuid default gen_random_uuid(),
    "encounter_id" uuid default gen_random_uuid(),
    "summary" text
);


alter table "public"."imaging" enable row level security;

create table "public"."immunization_recommendations" (
    "id" uuid not null default uuid_generate_v4(),
    "code" text not null,
    "recommendation_date" timestamp with time zone not null,
    "status" text,
    "created_at" timestamp with time zone not null default now(),
    "patient_id" uuid not null,
    "source" text
);


alter table "public"."immunization_recommendations" enable row level security;

create table "public"."immunizations" (
    "id" uuid not null default uuid_generate_v4(),
    "code" text not null,
    "occurrence_date" timestamp with time zone not null,
    "protocol_applied_dose_number" integer not null,
    "protocol_applied_series_doses" integer not null,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "status" text not null,
    "patient_id" uuid not null,
    "encounter_id" uuid,
    "attachments" text[]
);


alter table "public"."immunizations" enable row level security;

create table "public"."invited_users" (
    "id" uuid not null default gen_random_uuid(),
    "invited_at" timestamp with time zone not null default now(),
    "invited_user" uuid,
    "invited_by" uuid,
    "status" text,
    "patient_shared" text[]
);


alter table "public"."invited_users" enable row level security;

create table "public"."lab_results" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "patient_id" uuid not null,
    "encounter_id" uuid,
    "summary" text
);


alter table "public"."lab_results" enable row level security;

create table "public"."medication_requests" (
    "id" uuid not null default uuid_generate_v4(),
    "status" text,
    "patient_id" uuid not null,
    "encounter_id" uuid,
    "dosage_instructions" text,
    "code" text not null,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "route" text,
    "frequency" integer,
    "start_date" timestamp with time zone,
    "end_date" timestamp with time zone,
    "quantity_total" double precision,
    "dose_amount" double precision,
    "quantity_unit" text,
    "interval" text,
    "term" text,
    "duration" integer,
    "attachments" text[],
    "expiration_date" timestamp with time zone,
    "prescription_date" timestamp with time zone,
    "dose_unit" text,
    "interval_gap" integer,
    "interval_gap_unit" text,
    "medication_code_id" uuid,
    "clinic_id" uuid
);


alter table "public"."medication_requests" enable row level security;

create table "public"."observations" (
    "id" uuid not null default uuid_generate_v4(),
    "effective_date" timestamp with time zone default (now() AT TIME ZONE 'utc'::text),
    "code" text not null,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "patient_id" uuid not null,
    "encounter_id" uuid,
    "value_quantity" jsonb,
    "value_string" text,
    "recorder_id" uuid,
    "attachments" text[],
    "value_quantity_value" double precision,
    "value_quantity_unit" text
);


alter table "public"."observations" enable row level security;

create table "public"."patients" (
    "id" uuid not null default uuid_generate_v4(),
    "created_at" timestamp with time zone not null default now(),
    "display_name" text not null,
    "ovet_email" text,
    "status" text not null default 'active'::text,
    "species" species_enum not null default 'dog'::species_enum,
    "breed" text,
    "gender" text,
    "gender_status" text not null,
    "birth_date" timestamp with time zone,
    "photo_url" text,
    "microchip" text,
    "updated_at" timestamp with time zone default (now() AT TIME ZONE 'utc'::text),
    "requested_records_via_email" boolean default false,
    "received_any_records" boolean
);


alter table "public"."patients" enable row level security;

create table "public"."patients_files" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "patient_id" uuid not null default gen_random_uuid(),
    "encounter_id" uuid default gen_random_uuid(),
    "user_id" uuid,
    "immunization_id" uuid,
    "medication_request_id" uuid,
    "file_url" text not null,
    "file_name" text,
    "lab_result_id" uuid,
    "imaging_id" uuid
);


alter table "public"."patients_files" enable row level security;

create table "public"."public_legal" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "termsEn" text,
    "termsFr" text,
    "privacyFr" text,
    "privacyEn" text
);


alter table "public"."public_legal" enable row level security;

create table "public"."recommendations" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "patient_id" uuid not null,
    "recommendation" text not null
);


alter table "public"."recommendations" enable row level security;

create table "public"."survey_responses" (
    "id" uuid not null default uuid_generate_v4(),
    "user_id" uuid not null,
    "survey_version" text not null,
    "responses" jsonb not null,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
);


alter table "public"."survey_responses" enable row level security;

create table "public"."user_household" (
    "user_id" uuid not null,
    "household_id" uuid not null,
    "household_role" enum_household_role not null default 'owner'::enum_household_role,
    "invitation_status" enum_invitation_status not null default 'not_an_invitation'::enum_invitation_status,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text)
);


alter table "public"."user_household" enable row level security;

create table "public"."users" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "email" text not null,
    "unit" text not null default 'metric'::text,
    "language" text not null default 'fr'::text,
    "status" text not null default 'active'::text,
    "person_type" text,
    "phone_number" text,
    "first_name" text,
    "last_name" text,
    "updated_at" timestamp with time zone default (now() AT TIME ZONE 'utc'::text),
    "photo_url" text,
    "terms_accepted_at" timestamp with time zone,
    "city_place_id" character varying(255)
);


alter table "public"."users" enable row level security;

create table "public"."users_patients" (
    "patient_id" uuid not null,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "user_id" uuid not null,
    "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "status" patient_status_enum not null default 'active'::patient_status_enum
);


alter table "public"."users_patients" enable row level security;

CREATE UNIQUE INDEX clinic_patient_unique ON public.clinics_patients USING btree (clinic_id, patient_id);

CREATE UNIQUE INDEX clinics_google_place_id_key ON public.clinics USING btree (google_place_id);

CREATE UNIQUE INDEX clinics_patients_pkey ON public.clinics_patients USING btree (id);

CREATE UNIQUE INDEX clinics_pkey ON public.clinics USING btree (id);

CREATE UNIQUE INDEX codes_breed_pkey ON public.codes_breeds USING btree (species, language);

CREATE UNIQUE INDEX codes_immunizations_key ON public.codes_immunizations USING btree (code);

CREATE UNIQUE INDEX codes_medication_ovet_mp_pkey ON public.codes_medication_ovet USING btree (id);

CREATE UNIQUE INDEX codes_observations_key ON public.codes_observations USING btree (code);

CREATE UNIQUE INDEX codes_observations_pkey ON public.codes_observations USING btree (id);

CREATE UNIQUE INDEX codes_routes_key ON public.code_routes USING btree (code);

CREATE UNIQUE INDEX codes_routes_pkey ON public.code_routes USING btree (id);

CREATE UNIQUE INDEX encounters_pkey ON public.encounters USING btree (id);

CREATE UNIQUE INDEX files_pkey ON public.patients_files USING btree (id);

CREATE UNIQUE INDEX households_pkey ON public.households USING btree (id);

CREATE INDEX idx_onboarding_responses_user_id ON public.survey_responses USING btree (user_id);

CREATE INDEX idx_user_household_household_id ON public.user_household USING btree (household_id);

CREATE INDEX idx_user_household_user_id ON public.user_household USING btree (user_id);

CREATE UNIQUE INDEX imaging_pkey ON public.imaging USING btree (id);

CREATE UNIQUE INDEX immunizations_pkey ON public.immunizations USING btree (id);

CREATE UNIQUE INDEX invited_users_pkey ON public.invited_users USING btree (id);

CREATE UNIQUE INDEX lab_results_pkey ON public.lab_results USING btree (id);

CREATE UNIQUE INDEX medication_requests_pkey ON public.medication_requests USING btree (id);

CREATE UNIQUE INDEX observations_pkey ON public.observations USING btree (id);

CREATE UNIQUE INDEX onboarding_responses_pkey ON public.survey_responses USING btree (id);

CREATE UNIQUE INDEX patients_pkey ON public.patients USING btree (id);

CREATE UNIQUE INDEX public_legal_pkey ON public.public_legal USING btree (id);

CREATE UNIQUE INDEX recommendations_pkey ON public.immunization_recommendations USING btree (id);

CREATE UNIQUE INDEX recommendations_pkey1 ON public.recommendations USING btree (id);

CREATE UNIQUE INDEX user_household_pkey ON public.user_household USING btree (user_id, household_id);

CREATE INDEX users_city_place_id_idx ON public.users USING btree (city_place_id);

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);

CREATE UNIQUE INDEX users_patients_pkey ON public.users_patients USING btree (patient_id, user_id);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."clinics" add constraint "clinics_pkey" PRIMARY KEY using index "clinics_pkey";

alter table "public"."clinics_patients" add constraint "clinics_patients_pkey" PRIMARY KEY using index "clinics_patients_pkey";

alter table "public"."code_routes" add constraint "codes_routes_pkey" PRIMARY KEY using index "codes_routes_pkey";

alter table "public"."codes_breeds" add constraint "codes_breed_pkey" PRIMARY KEY using index "codes_breed_pkey";

alter table "public"."codes_medication_ovet" add constraint "codes_medication_ovet_mp_pkey" PRIMARY KEY using index "codes_medication_ovet_mp_pkey";

alter table "public"."codes_observations" add constraint "codes_observations_pkey" PRIMARY KEY using index "codes_observations_pkey";

alter table "public"."encounters" add constraint "encounters_pkey" PRIMARY KEY using index "encounters_pkey";

alter table "public"."households" add constraint "households_pkey" PRIMARY KEY using index "households_pkey";

alter table "public"."imaging" add constraint "imaging_pkey" PRIMARY KEY using index "imaging_pkey";

alter table "public"."immunization_recommendations" add constraint "recommendations_pkey" PRIMARY KEY using index "recommendations_pkey";

alter table "public"."immunizations" add constraint "immunizations_pkey" PRIMARY KEY using index "immunizations_pkey";

alter table "public"."invited_users" add constraint "invited_users_pkey" PRIMARY KEY using index "invited_users_pkey";

alter table "public"."lab_results" add constraint "lab_results_pkey" PRIMARY KEY using index "lab_results_pkey";

alter table "public"."medication_requests" add constraint "medication_requests_pkey" PRIMARY KEY using index "medication_requests_pkey";

alter table "public"."observations" add constraint "observations_pkey" PRIMARY KEY using index "observations_pkey";

alter table "public"."patients" add constraint "patients_pkey" PRIMARY KEY using index "patients_pkey";

alter table "public"."patients_files" add constraint "files_pkey" PRIMARY KEY using index "files_pkey";

alter table "public"."public_legal" add constraint "public_legal_pkey" PRIMARY KEY using index "public_legal_pkey";

alter table "public"."recommendations" add constraint "recommendations_pkey1" PRIMARY KEY using index "recommendations_pkey1";

alter table "public"."survey_responses" add constraint "onboarding_responses_pkey" PRIMARY KEY using index "onboarding_responses_pkey";

alter table "public"."user_household" add constraint "user_household_pkey" PRIMARY KEY using index "user_household_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."users_patients" add constraint "users_patients_pkey" PRIMARY KEY using index "users_patients_pkey";

alter table "public"."clinics" add constraint "clinics_google_place_id_key" UNIQUE using index "clinics_google_place_id_key";

alter table "public"."clinics_patients" add constraint "clinic_patient_unique" UNIQUE using index "clinic_patient_unique";

alter table "public"."clinics_patients" add constraint "clinics_patients_clinic_id_fkey" FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."clinics_patients" validate constraint "clinics_patients_clinic_id_fkey";

alter table "public"."clinics_patients" add constraint "clinics_patients_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."clinics_patients" validate constraint "clinics_patients_patient_id_fkey";

alter table "public"."code_routes" add constraint "codes_routes_key" UNIQUE using index "codes_routes_key";

alter table "public"."codes_immunizations" add constraint "codes_immunizations_key" UNIQUE using index "codes_immunizations_key";

alter table "public"."codes_observations" add constraint "codes_observations_key" UNIQUE using index "codes_observations_key";

alter table "public"."encounters" add constraint "encounters_clinic_id_fkey" FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."encounters" validate constraint "encounters_clinic_id_fkey";

alter table "public"."encounters" add constraint "encounters_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE not valid;

alter table "public"."encounters" validate constraint "encounters_patient_id_fkey";

alter table "public"."households" add constraint "households_creator_fkey" FOREIGN KEY (creator) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."households" validate constraint "households_creator_fkey";

alter table "public"."immunization_recommendations" add constraint "immunization_recommendations_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE not valid;

alter table "public"."immunization_recommendations" validate constraint "immunization_recommendations_patient_id_fkey";

alter table "public"."immunizations" add constraint "immunizations_code_fkey" FOREIGN KEY (code) REFERENCES codes_immunizations(code) ON UPDATE CASCADE not valid;

alter table "public"."immunizations" validate constraint "immunizations_code_fkey";

alter table "public"."immunizations" add constraint "immunizations_encounter_id_fkey" FOREIGN KEY (encounter_id) REFERENCES encounters(id) ON DELETE CASCADE not valid;

alter table "public"."immunizations" validate constraint "immunizations_encounter_id_fkey";

alter table "public"."immunizations" add constraint "immunizations_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE not valid;

alter table "public"."immunizations" validate constraint "immunizations_patient_id_fkey";

alter table "public"."invited_users" add constraint "invited_users_invited_by_fkey" FOREIGN KEY (invited_by) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."invited_users" validate constraint "invited_users_invited_by_fkey";

alter table "public"."invited_users" add constraint "invited_users_invited_user_fkey" FOREIGN KEY (invited_user) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."invited_users" validate constraint "invited_users_invited_user_fkey";

alter table "public"."lab_results" add constraint "lab_results_encounter_id_fkey" FOREIGN KEY (encounter_id) REFERENCES encounters(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."lab_results" validate constraint "lab_results_encounter_id_fkey";

alter table "public"."lab_results" add constraint "lab_results_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."lab_results" validate constraint "lab_results_patient_id_fkey";

alter table "public"."medication_requests" add constraint "medication_requests_clinic_id_fkey" FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."medication_requests" validate constraint "medication_requests_clinic_id_fkey";

alter table "public"."medication_requests" add constraint "medication_requests_encounter_id_fkey" FOREIGN KEY (encounter_id) REFERENCES encounters(id) ON DELETE CASCADE not valid;

alter table "public"."medication_requests" validate constraint "medication_requests_encounter_id_fkey";

alter table "public"."medication_requests" add constraint "medication_requests_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE not valid;

alter table "public"."medication_requests" validate constraint "medication_requests_patient_id_fkey";

alter table "public"."observations" add constraint "observations_encounter_id_fkey" FOREIGN KEY (encounter_id) REFERENCES encounters(id) ON DELETE CASCADE not valid;

alter table "public"."observations" validate constraint "observations_encounter_id_fkey";

alter table "public"."observations" add constraint "observations_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE not valid;

alter table "public"."observations" validate constraint "observations_patient_id_fkey";

alter table "public"."observations" add constraint "observations_recorder_id_fkey" FOREIGN KEY (recorder_id) REFERENCES users(id) not valid;

alter table "public"."observations" validate constraint "observations_recorder_id_fkey";

alter table "public"."patients_files" add constraint "files_record_id_fkey" FOREIGN KEY (encounter_id) REFERENCES encounters(id) ON DELETE CASCADE not valid;

alter table "public"."patients_files" validate constraint "files_record_id_fkey";

alter table "public"."patients_files" add constraint "patient_files_immunization_id_fkey" FOREIGN KEY (immunization_id) REFERENCES immunizations(id) ON DELETE CASCADE not valid;

alter table "public"."patients_files" validate constraint "patient_files_immunization_id_fkey";

alter table "public"."patients_files" add constraint "patient_files_medication_request_id_fkey" FOREIGN KEY (medication_request_id) REFERENCES medication_requests(id) not valid;

alter table "public"."patients_files" validate constraint "patient_files_medication_request_id_fkey";

alter table "public"."patients_files" add constraint "patients_files_imaging_id_fkey" FOREIGN KEY (imaging_id) REFERENCES imaging(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patients_files" validate constraint "patients_files_imaging_id_fkey";

alter table "public"."patients_files" add constraint "patients_files_lab_result_id_fkey" FOREIGN KEY (lab_result_id) REFERENCES lab_results(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."patients_files" validate constraint "patients_files_lab_result_id_fkey";

alter table "public"."patients_files" add constraint "patients_files_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE not valid;

alter table "public"."patients_files" validate constraint "patients_files_patient_id_fkey";

alter table "public"."patients_files" add constraint "patients_files_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL not valid;

alter table "public"."patients_files" validate constraint "patients_files_user_id_fkey";

alter table "public"."recommendations" add constraint "recommendations_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON UPDATE CASCADE not valid;

alter table "public"."recommendations" validate constraint "recommendations_patient_id_fkey";

alter table "public"."survey_responses" add constraint "onboarding_responses_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."survey_responses" validate constraint "onboarding_responses_user_id_fkey";

alter table "public"."user_household" add constraint "user_household_household_id_fkey" FOREIGN KEY (household_id) REFERENCES households(id) ON DELETE CASCADE not valid;

alter table "public"."user_household" validate constraint "user_household_household_id_fkey";

alter table "public"."user_household" add constraint "user_household_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."user_household" validate constraint "user_household_user_id_fkey";

alter table "public"."users" add constraint "users_email_key" UNIQUE using index "users_email_key";

alter table "public"."users_patients" add constraint "users_patients_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE not valid;

alter table "public"."users_patients" validate constraint "users_patients_patient_id_fkey";

alter table "public"."users_patients" add constraint "users_patients_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."users_patients" validate constraint "users_patients_user_id_fkey";

set check_function_bodies = off;

create or replace view "public"."app_encounters" as  SELECT e.id AS encounter_id,
    e.patient_id,
    e.encounter_date,
    e.status_code,
    e.class_coding_code,
    e.created_at,
    e.verification_status,
    e.encounter_summary,
    e.clinic_id,
    e.attachments,
    e.reason_for_visit,
    c.name AS clinic_name,
    c.address AS clinic_address,
        CASE
            WHEN (count(i.encounter_id) > 0) THEN true
            ELSE false
        END AS has_immunizations,
    count(DISTINCT i.id) AS immunizations_count,
        CASE
            WHEN (count(m.encounter_id) > 0) THEN true
            ELSE false
        END AS has_medications,
    count(DISTINCT m.id) AS medications_count,
        CASE
            WHEN (count(lr.encounter_id) > 0) THEN true
            ELSE false
        END AS has_lab_result,
    count(DISTINCT lr.id) AS lab_results_count,
        CASE
            WHEN (count(im.encounter_id) > 0) THEN true
            ELSE false
        END AS has_imaging,
    count(DISTINCT im.id) AS imaging_count,
        CASE
            WHEN (count(ob.encounter_id) > 0) THEN true
            ELSE false
        END AS has_observations,
    count(DISTINCT ob.id) AS observations_count,
    ( SELECT
                CASE
                    WHEN (((o.value_quantity ->> 'value'::text) IS NULL) OR ((o.value_quantity ->> 'value'::text) = ''::text)) THEN NULL::text
                    WHEN (((o.value_quantity ->> 'unit'::text) IS NULL) OR ((o.value_quantity ->> 'unit'::text) = ''::text)) THEN (o.value_quantity ->> 'value'::text)
                    ELSE (((o.value_quantity ->> 'value'::text) || ' '::text) || (o.value_quantity ->> 'unit'::text))
                END AS "case"
           FROM observations o
          WHERE ((o.encounter_id = e.id) AND (o.code = '27113001'::text))
         LIMIT 1) AS obs_weight_value,
    ( SELECT count(pf.encounter_id) AS count
           FROM patients_files pf
          WHERE (pf.encounter_id = e.id)) AS attachments_count
   FROM ((((((encounters e
     LEFT JOIN clinics c ON ((e.clinic_id = c.id)))
     LEFT JOIN immunizations i ON ((e.id = i.encounter_id)))
     LEFT JOIN medication_requests m ON ((e.id = m.encounter_id)))
     LEFT JOIN lab_results lr ON ((e.id = lr.encounter_id)))
     LEFT JOIN imaging im ON ((e.id = im.encounter_id)))
     LEFT JOIN observations ob ON ((e.id = ob.encounter_id)))
  GROUP BY e.id, e.patient_id, e.encounter_date, e.status_code, e.class_coding_code, e.created_at, e.verification_status, e.encounter_summary, e.clinic_id, e.attachments, e.reason_for_visit, c.name, c.address;


create or replace view "public"."app_health_overview" as  WITH patient_base AS (
         SELECT p.id,
            p.display_name,
            p.birth_date,
            (p.birth_date + '1 year'::interval) AS one_year_birthday
           FROM patients p
        )
 SELECT pb.id AS patient_id,
    pb.display_name,
    pb.birth_date,
    pb.one_year_birthday,
        CASE
            WHEN ((result.ideal_weight_kg IS NULL) OR (NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text) IS NULL)) THEN NULL::text
            ELSE result.ideal_weight_kg
        END AS ideal_weight_kg,
        CASE
            WHEN ((result.ideal_weight_lbs IS NULL) OR (NULLIF(replace(result.ideal_weight_lbs, ' lbs'::text, ''::text), ''::text) IS NULL)) THEN NULL::text
            ELSE result.ideal_weight_lbs
        END AS ideal_weight_lbs,
        CASE
            WHEN ((result.ideal_weight_kg IS NULL) OR (NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text) IS NULL)) THEN NULL::text
            ELSE result.method
        END AS ideal_weight_calc,
        CASE
            WHEN ((obs.observed_weight_kg IS NULL) OR (result.ideal_weight_kg IS NULL) OR (NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text) IS NULL)) THEN NULL::text
            ELSE concat(((round((obs.observed_weight_kg - (NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text))::numeric), 0))::integer)::text, ' kg')
        END AS weight_delta_kg,
        CASE
            WHEN ((obs.observed_weight_lbs IS NULL) OR (result.ideal_weight_lbs IS NULL) OR (NULLIF(replace(result.ideal_weight_lbs, ' lbs'::text, ''::text), ''::text) IS NULL)) THEN NULL::text
            ELSE concat(((round((obs.observed_weight_lbs - (NULLIF(replace(result.ideal_weight_lbs, ' lbs'::text, ''::text), ''::text))::numeric), 0))::integer)::text, ' lbs')
        END AS weight_delta_lbs,
        CASE
            WHEN ((obs.observed_weight_kg IS NULL) OR (result.ideal_weight_kg IS NULL) OR (NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text) IS NULL)) THEN NULL::text
            WHEN (round((obs.observed_weight_kg - (NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text))::numeric), 0) > (0)::numeric) THEN 'over'::text
            WHEN (round((obs.observed_weight_kg - (NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text))::numeric), 0) < (0)::numeric) THEN 'under'::text
            ELSE NULL::text
        END AS delta,
    obs.last_weighted_at,
        CASE
            WHEN (obs.observed_weight_kg IS NULL) THEN NULL::text
            ELSE concat((obs.observed_weight_kg)::text, ' kg')
        END AS last_observed_weight_kg,
        CASE
            WHEN (obs.observed_weight_lbs IS NULL) THEN NULL::text
            ELSE concat((obs.observed_weight_lbs)::text, ' lbs')
        END AS last_observed_weight_lbs,
        CASE
            WHEN (obs.last_weighted_at IS NULL) THEN true
            WHEN ((EXTRACT(year FROM age((CURRENT_DATE)::timestamp with time zone, pb.birth_date)) < (10)::numeric) AND (obs.last_weighted_at <= (CURRENT_DATE - '6 mons'::interval))) THEN true
            WHEN ((EXTRACT(year FROM age((CURRENT_DATE)::timestamp with time zone, pb.birth_date)) >= (10)::numeric) AND (obs.last_weighted_at <= (CURRENT_DATE - '3 mons'::interval))) THEN true
            ELSE false
        END AS reassess_weight,
    obs_stats.min_weight_kg,
    obs_stats.max_weight_kg,
    obs_stats.min_weight_lbs,
    obs_stats.max_weight_lbs,
        CASE
            WHEN ((result.ideal_weight_kg IS NULL) OR (obs_stats.min_weight_kg IS NULL) OR (obs_stats.max_weight_kg IS NULL) OR (NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text) IS NULL)) THEN NULL::numeric
            ELSE round((
            CASE
                WHEN (obs_stats.max_weight_kg = obs_stats.min_weight_kg) THEN 0.5
                ELSE (((NULLIF(replace(result.ideal_weight_kg, ' kg'::text, ''::text), ''::text))::numeric - obs_stats.min_weight_kg) / (obs_stats.max_weight_kg - obs_stats.min_weight_kg))
            END * (50)::numeric), 2)
        END AS ideal_weight_fraction
   FROM (((patient_base pb
     LEFT JOIN LATERAL ( SELECT
                CASE
                    WHEN (NULLIF(replace(t.ideal_weight_kg, ' kg'::text, ''::text), ''::text) IS NULL) THEN NULL::text
                    ELSE t.ideal_weight_kg
                END AS ideal_weight_kg,
                CASE
                    WHEN (NULLIF(replace(t.ideal_weight_lbs, ' lbs'::text, ''::text), ''::text) IS NULL) THEN NULL::text
                    ELSE t.ideal_weight_lbs
                END AS ideal_weight_lbs,
            t.method,
            t.bcs_code
           FROM ( SELECT
                        CASE
                            WHEN (avg(
                            CASE
                                WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN o.value_quantity_value
                                WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN (o.value_quantity_value * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END) IS NULL) THEN NULL::text
                            ELSE concat((round((avg(
                            CASE
                                WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN o.value_quantity_value
                                WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN (o.value_quantity_value * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END))::numeric, 0))::text, ' kg')
                        END AS ideal_weight_kg,
                        CASE
                            WHEN (avg(
                            CASE
                                WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN (o.value_quantity_value * (2.20462)::double precision)
                                WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN o.value_quantity_value
                                ELSE NULL::double precision
                            END) IS NULL) THEN NULL::text
                            ELSE concat((round((avg(
                            CASE
                                WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN (o.value_quantity_value * (2.20462)::double precision)
                                WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN o.value_quantity_value
                                ELSE NULL::double precision
                            END))::numeric, 0))::text, ' lbs')
                        END AS ideal_weight_lbs,
                    'one_year'::text AS method,
                    NULL::text AS bcs_code
                   FROM observations o
                  WHERE ((o.code = '27113001'::text) AND (o.patient_id = pb.id) AND (o.effective_date >= pb.one_year_birthday) AND (o.effective_date <= (pb.birth_date + '1 year 6 mons'::interval)))
                UNION ALL
                ( SELECT
                        CASE
                            WHEN ((lower(w.value_quantity_unit) = 'kg'::text) AND (w.value_quantity_value IS NOT NULL)) THEN concat((round((w.value_quantity_value)::numeric, 1))::text, ' kg')
                            WHEN ((lower(w.value_quantity_unit) = 'lbs'::text) AND (w.value_quantity_value IS NOT NULL)) THEN concat((round(((w.value_quantity_value * (0.45359237)::double precision))::numeric, 1))::text, ' kg')
                            ELSE NULL::text
                        END AS ideal_weight_kg,
                        CASE
                            WHEN ((lower(w.value_quantity_unit) = 'lbs'::text) AND (w.value_quantity_value IS NOT NULL)) THEN concat((round((w.value_quantity_value)::numeric, 1))::text, ' lbs')
                            WHEN ((lower(w.value_quantity_unit) = 'kg'::text) AND (w.value_quantity_value IS NOT NULL)) THEN concat((round(((w.value_quantity_value * (2.20462)::double precision))::numeric, 1))::text, ' lbs')
                            ELSE NULL::text
                        END AS ideal_weight_lbs,
                    '5/9 score'::text AS method,
                    NULL::text AS bcs_code
                   FROM (observations indicator
                     JOIN observations w ON ((indicator.encounter_id = w.encounter_id)))
                  WHERE ((indicator.code = '361971000009100'::text) AND (w.code = '27113001'::text) AND (indicator.patient_id = pb.id) AND (w.patient_id = pb.id))
                  ORDER BY indicator.effective_date
                 LIMIT 1)
                UNION ALL
                ( SELECT
                        CASE
                            WHEN (
                            CASE
                                WHEN ((lower(w.value_quantity_unit) = 'kg'::text) AND (w.value_quantity_value IS NOT NULL)) THEN w.value_quantity_value
                                WHEN ((lower(w.value_quantity_unit) = 'lbs'::text) AND (w.value_quantity_value IS NOT NULL)) THEN (w.value_quantity_value * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END IS NULL) THEN NULL::text
                            ELSE concat((round(((
                            CASE
                                WHEN ((lower(w.value_quantity_unit) = 'kg'::text) AND (w.value_quantity_value IS NOT NULL)) THEN w.value_quantity_value
                                WHEN ((lower(w.value_quantity_unit) = 'lbs'::text) AND (w.value_quantity_value IS NOT NULL)) THEN (w.value_quantity_value * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END)::numeric / ((1)::numeric + (0.1 * ((
                            CASE indicator.code
                                WHEN '361911000009107'::text THEN 1
                                WHEN '361921000009104'::text THEN 2
                                WHEN '361931000009102'::text THEN 3
                                WHEN '361941000009108'::text THEN 4
                                WHEN '361971000009100'::text THEN 5
                                WHEN '361951000009106'::text THEN 6
                                WHEN '361961000009109'::text THEN 7
                                WHEN '361981000009103'::text THEN 8
                                WHEN '361991000009101'::text THEN 9
                                ELSE NULL::integer
                            END - 5))::numeric))), 1))::text, ' kg')
                        END AS ideal_weight_kg,
                        CASE
                            WHEN (
                            CASE
                                WHEN ((lower(w.value_quantity_unit) = 'kg'::text) AND (w.value_quantity_value IS NOT NULL)) THEN w.value_quantity_value
                                WHEN ((lower(w.value_quantity_unit) = 'lbs'::text) AND (w.value_quantity_value IS NOT NULL)) THEN (w.value_quantity_value * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END IS NULL) THEN NULL::text
                            ELSE concat((round((((
                            CASE
                                WHEN ((lower(w.value_quantity_unit) = 'kg'::text) AND (w.value_quantity_value IS NOT NULL)) THEN w.value_quantity_value
                                WHEN ((lower(w.value_quantity_unit) = 'lbs'::text) AND (w.value_quantity_value IS NOT NULL)) THEN (w.value_quantity_value * (0.45359237)::double precision)
                                ELSE NULL::double precision
                            END)::numeric / ((1)::numeric + (0.1 * ((
                            CASE indicator.code
                                WHEN '361911000009107'::text THEN 1
                                WHEN '361921000009104'::text THEN 2
                                WHEN '361931000009102'::text THEN 3
                                WHEN '361941000009108'::text THEN 4
                                WHEN '361971000009100'::text THEN 5
                                WHEN '361951000009106'::text THEN 6
                                WHEN '361961000009109'::text THEN 7
                                WHEN '361981000009103'::text THEN 8
                                WHEN '361991000009101'::text THEN 9
                                ELSE NULL::integer
                            END - 5))::numeric))) * 2.20462), 1))::text, ' lbs')
                        END AS ideal_weight_lbs,
                    'BCS algo'::text AS method,
                    NULL::text AS bcs_code
                   FROM (observations indicator
                     JOIN observations w ON ((indicator.encounter_id = w.encounter_id)))
                  WHERE ((indicator.code = ANY (ARRAY['361911000009107'::text, '361921000009104'::text, '361931000009102'::text, '361941000009108'::text, '361971000009100'::text, '361951000009106'::text, '361961000009109'::text, '361981000009103'::text, '361991000009101'::text])) AND (w.code = '27113001'::text) AND (indicator.patient_id = pb.id) AND (w.patient_id = pb.id))
                  ORDER BY indicator.effective_date DESC
                 LIMIT 1)) t
          ORDER BY
                CASE t.method
                    WHEN 'one_year'::text THEN 1
                    WHEN '5/9 score'::text THEN 2
                    WHEN 'BCS algo'::text THEN 3
                    ELSE 4
                END
         LIMIT 1) result ON (true))
     LEFT JOIN LATERAL ( SELECT
                CASE
                    WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN round((o.value_quantity_value)::numeric, 1)
                    WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN round(((o.value_quantity_value * (0.45359237)::double precision))::numeric, 1)
                    ELSE NULL::numeric
                END AS observed_weight_kg,
                CASE
                    WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN round((o.value_quantity_value)::numeric, 1)
                    WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN round(((o.value_quantity_value * (2.20462)::double precision))::numeric, 1)
                    ELSE NULL::numeric
                END AS observed_weight_lbs,
            o.effective_date AS last_weighted_at
           FROM observations o
          WHERE ((o.code = '27113001'::text) AND (o.patient_id = pb.id))
          ORDER BY o.effective_date DESC
         LIMIT 1) obs ON (true))
     LEFT JOIN LATERAL ( SELECT round(min(
                CASE
                    WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN (o.value_quantity_value)::numeric
                    WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN ((o.value_quantity_value * (0.45359237)::double precision))::numeric
                    ELSE NULL::numeric
                END), 1) AS min_weight_kg,
            round(max(
                CASE
                    WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN (o.value_quantity_value)::numeric
                    WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN ((o.value_quantity_value * (0.45359237)::double precision))::numeric
                    ELSE NULL::numeric
                END), 1) AS max_weight_kg,
            round(min(
                CASE
                    WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN (o.value_quantity_value)::numeric
                    WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN ((o.value_quantity_value * (2.20462)::double precision))::numeric
                    ELSE NULL::numeric
                END), 1) AS min_weight_lbs,
            round(max(
                CASE
                    WHEN ((lower(o.value_quantity_unit) = 'lbs'::text) AND (o.value_quantity_value IS NOT NULL)) THEN (o.value_quantity_value)::numeric
                    WHEN ((lower(o.value_quantity_unit) = 'kg'::text) AND (o.value_quantity_value IS NOT NULL)) THEN ((o.value_quantity_value * (2.20462)::double precision))::numeric
                    ELSE NULL::numeric
                END), 1) AS max_weight_lbs
           FROM observations o
          WHERE ((o.code = '27113001'::text) AND (o.patient_id = pb.id))) obs_stats ON (true));


create or replace view "public"."app_imaging" as  SELECT i.id,
    i.created_at,
    i.patient_id,
    i.encounter_id,
    i.summary,
    e.encounter_date,
    ( SELECT count(pf.imaging_id) AS count
           FROM patients_files pf
          WHERE (pf.imaging_id = i.id)) AS attachments_count,
    ( SELECT pf.file_url
           FROM patients_files pf
          WHERE (pf.encounter_id = i.encounter_id)
          ORDER BY pf.created_at
         LIMIT 1) AS encounter_file_url,
    ( SELECT pf.file_url
           FROM patients_files pf
          WHERE (pf.imaging_id = i.id)
          ORDER BY pf.created_at
         LIMIT 1) AS imaging_file_url
   FROM (imaging i
     LEFT JOIN encounters e ON ((i.encounter_id = e.id)));


create or replace view "public"."app_immunizations" as  SELECT i.id AS immunization_id,
    i.code,
    i.occurrence_date,
    i.protocol_applied_dose_number AS dose_number,
    i.protocol_applied_series_doses AS series_doses,
    i.status,
    i.patient_id,
    i.encounter_id,
    (cim.metadata ->> 'display'::text) AS display,
    (cim.metadata ->> 'displayFR'::text) AS display_fr,
    (cim.metadata ->> 'ovetShort'::text) AS short,
    (cim.metadata ->> 'description'::text) AS description,
    (cim.metadata ->> 'ovetShortFR'::text) AS short_fr,
    (cim.metadata ->> 'ovetDetailed'::text) AS detailed,
    (cim.metadata ->> 'descriptionFR'::text) AS description_fr,
    (cim.metadata ->> 'ovetDetailedFR'::text) AS detailed_fr,
    ( SELECT count(pf.immunization_id) AS count
           FROM patients_files pf
          WHERE (pf.immunization_id = i.id)) AS attachments_count,
    c.name AS clinic_name,
    ( SELECT pf.file_url
           FROM patients_files pf
          WHERE (pf.immunization_id = i.id)
         LIMIT 1) AS vaccine_certificate_file_url,
    ( SELECT pf.file_url
           FROM patients_files pf
          WHERE (pf.encounter_id = i.encounter_id)
         LIMIT 1) AS encounter_file_url,
        CASE
            WHEN (i.occurrence_date = max(i.occurrence_date) OVER (PARTITION BY i.patient_id, i.code)) THEN true
            ELSE false
        END AS is_latest,
    r.recommendation_date AS recommended_renewal_date,
        CASE
            WHEN (r.recommendation_date IS NOT NULL) THEN date_part('day'::text, (r.recommendation_date - now()))
            ELSE NULL::double precision
        END AS days_until_renewal,
        CASE
            WHEN (r.recommendation_date IS NULL) THEN NULL::numeric
            WHEN (now() >= r.recommendation_date) THEN (0)::numeric
            ELSE round(GREATEST((0)::numeric, LEAST((1)::numeric, (EXTRACT(epoch FROM (r.recommendation_date - now())) / NULLIF(EXTRACT(epoch FROM (r.recommendation_date - i.occurrence_date)), (0)::numeric)))), 2)
        END AS renewal_time_fraction,
        CASE
            WHEN (date_part('day'::text, (r.recommendation_date - now())) <= (0)::double precision) THEN concat('booster is ', (((date_part('year'::text, age(now(), r.recommendation_date)) * (12)::double precision) + date_part('month'::text, age(now(), r.recommendation_date))))::integer, ' months overdue')
            WHEN ((date_part('day'::text, (r.recommendation_date - now())) >= (1)::double precision) AND (date_part('day'::text, (r.recommendation_date - now())) <= (90)::double precision)) THEN concat('booster is due in ', (((date_part('year'::text, age(r.recommendation_date, now())) * (12)::double precision) + date_part('month'::text, age(r.recommendation_date, now()))))::integer, ' months')
            ELSE NULL::text
        END AS status_message,
        CASE
            WHEN (date_part('day'::text, (r.recommendation_date - now())) < (0)::double precision) THEN concat((((date_part('year'::text, age(now(), r.recommendation_date)) * (12)::double precision) + date_part('month'::text, age(now(), r.recommendation_date))))::integer, ' mois de retard pour le rappel de vaccin')
            WHEN ((date_part('day'::text, (r.recommendation_date - now())) >= (0)::double precision) AND (date_part('day'::text, (r.recommendation_date - now())) <= (90)::double precision)) THEN concat('Le rappel est dans ', (((date_part('year'::text, age(r.recommendation_date, now())) * (12)::double precision) + date_part('month'::text, age(r.recommendation_date, now()))))::integer, ' mois')
            ELSE NULL::text
        END AS status_message_fr
   FROM ((((immunizations i
     JOIN codes_immunizations cim ON ((i.code = cim.code)))
     LEFT JOIN encounters e ON ((i.encounter_id = e.id)))
     LEFT JOIN clinics c ON ((e.clinic_id = c.id)))
     LEFT JOIN LATERAL ( SELECT r_1.recommendation_date
           FROM immunization_recommendations r_1
          WHERE ((r_1.code = i.code) AND (r_1.patient_id = i.patient_id))
          ORDER BY r_1.recommendation_date DESC
         LIMIT 1) r ON (true));


create or replace view "public"."app_lab_results" as  SELECT lr.id,
    lr.created_at,
    lr.patient_id,
    lr.encounter_id,
    e.encounter_date,
    lr.summary,
    ( SELECT count(pf.lab_result_id) AS count
           FROM patients_files pf
          WHERE (pf.lab_result_id = lr.id)) AS attachments_count,
    ( SELECT pf.file_url
           FROM patients_files pf
          WHERE (pf.encounter_id = lr.encounter_id)
          ORDER BY pf.created_at
         LIMIT 1) AS encounter_file_url,
    ( SELECT pf.file_url
           FROM patients_files pf
          WHERE (pf.lab_result_id = lr.id)
          ORDER BY pf.created_at
         LIMIT 1) AS lab_result_file_url
   FROM (lab_results lr
     LEFT JOIN encounters e ON ((lr.encounter_id = e.id)));


create or replace view "public"."app_medications" as  SELECT mr.id,
    mr.patient_id,
    mr.encounter_id,
        CASE
            WHEN ((mr.start_date IS NOT NULL) AND (mr.end_date < CURRENT_TIMESTAMP)) THEN 'completed'::text
            WHEN ((mr.expiration_date < CURRENT_TIMESTAMP) AND (mr.start_date IS NULL)) THEN 'expired'::text
            WHEN ((mr.start_date IS NOT NULL) AND (mr.end_date > CURRENT_TIMESTAMP)) THEN 'ongoing'::text
            WHEN ((mr.start_date IS NULL) AND (mr.expiration_date > CURRENT_TIMESTAMP)) THEN 'active'::text
            ELSE 'unknown'::text
        END AS status,
        CASE
            WHEN ((mr.start_date IS NOT NULL) AND (mr.end_date > CURRENT_TIMESTAMP)) THEN ((mr.end_date)::date - CURRENT_DATE)
            ELSE NULL::integer
        END AS days_left,
        CASE
            WHEN ((mr.start_date IS NOT NULL) AND (mr.end_date IS NOT NULL) AND (mr.end_date > CURRENT_TIMESTAMP)) THEN round(LEAST((1)::numeric, GREATEST((0)::numeric, (((CURRENT_DATE - (mr.start_date)::date))::numeric / (((mr.end_date)::date - (mr.start_date)::date))::numeric))), 2)
            ELSE NULL::numeric
        END AS progress,
    mr.dosage_instructions,
    mr.code,
    mr.created_at,
    mr.route,
    mr.frequency,
    mr.start_date,
    mr.end_date,
    mr.quantity_total,
    mr.quantity_unit,
    mr.dose_amount,
    mr.dose_unit,
    mr."interval",
    mr.term,
    mr.duration,
    mr.attachments,
    mr.expiration_date,
    mr.prescription_date,
    mr.interval_gap,
    mr.interval_gap_unit,
    cm.drug_identification_number AS mp_code,
    cm.brand_name AS mp_formal_name,
    cm.brand_name_fr AS mp_fr_description,
    NULL::text AS mp_type,
    cm.brand_name AS mp_display_name,
    cm.ovet_category AS ovet_categories,
    cm.ovet_category_fr AS ovet_categories_fr,
    NULL::text AS mp_prescription,
    cm.ovet_short,
    cm.ovet_short_fr,
    cm.ovet_detailed,
    cm.ovet_detailed_fr,
    ( SELECT count(pf.medication_request_id) AS count
           FROM patients_files pf
          WHERE (pf.medication_request_id = mr.id)) AS attachments_count,
    ( SELECT pf.file_url
           FROM patients_files pf
          WHERE (pf.medication_request_id = mr.id)
         LIMIT 1) AS medication_file_url,
    c.name AS clinic_name,
    ( SELECT pf.file_url
           FROM patients_files pf
          WHERE (pf.encounter_id = mr.encounter_id)
          ORDER BY pf.created_at
         LIMIT 1) AS encounter_file_url
   FROM (((medication_requests mr
     JOIN codes_medication_ovet cm ON (((mr.code)::bigint = cm.drug_identification_number)))
     LEFT JOIN encounters e ON ((mr.encounter_id = e.id)))
     LEFT JOIN clinics c ON ((e.clinic_id = c.id)));


create or replace view "public"."app_observations" as  SELECT o.id,
    o.effective_date,
    o.code,
    o.created_at,
    o.patient_id,
    o.encounter_id,
    o.value_quantity,
    o.value_string,
    o.recorder_id,
    o.attachments,
    o.value_quantity_value,
    o.value_quantity_unit,
    (co.metadata ->> 'icon'::text) AS icon,
    (co.metadata ->> 'display'::text) AS display,
    (co.metadata ->> 'displayFR'::text) AS display_fr,
    (co.metadata ->> 'ovetShort'::text) AS ovet_short,
    (co.metadata ->> 'description'::text) AS description,
    (co.metadata ->> 'adminShortFR'::text) AS admin_short_fr,
    (co.metadata ->> 'ovetDetailed'::text) AS ovet_detailed,
    (co.metadata ->> 'descriptionFR'::text) AS description_fr,
    (co.metadata ->> 'valueRequired'::text) AS value_required,
    (co.metadata ->> 'ovetDetailedFR'::text) AS ovet_detailed_fr
   FROM (( SELECT DISTINCT ON (observations.patient_id, observations.code, (date(observations.effective_date))) observations.id,
            observations.effective_date,
            observations.code,
            observations.created_at,
            observations.patient_id,
            observations.encounter_id,
            observations.value_quantity,
            observations.value_string,
            observations.recorder_id,
            observations.attachments,
            observations.value_quantity_value,
            observations.value_quantity_unit
           FROM observations
          ORDER BY observations.patient_id, observations.code, (date(observations.effective_date)), observations.effective_date DESC, observations.created_at DESC) o
     JOIN codes_observations co ON ((o.code = co.code)))
  WHERE (o.code <> '27113001'::text);


create or replace view "public"."app_patient" as  WITH patient_data AS (
         SELECT patients.id,
            patients.display_name,
            patients.status,
            patients.species,
            patients.breed,
            patients.gender,
            patients.gender_status,
            patients.ovet_email,
            patients.birth_date,
            patients.photo_url,
            patients.microchip,
            patients.requested_records_via_email,
            patients.received_any_records,
                CASE
                    WHEN (patients.birth_date IS NULL) THEN NULL::text
                    WHEN (EXTRACT(year FROM age(patients.birth_date)) = (0)::numeric) THEN
                    CASE
                        WHEN (EXTRACT(month FROM age(patients.birth_date)) = (0)::numeric) THEN
                        CASE
                            WHEN ((EXTRACT(day FROM age(patients.birth_date)) / (7)::numeric) = (1)::numeric) THEN '1 week old'::text
                            ELSE concat(floor((EXTRACT(day FROM age(patients.birth_date)) / (7)::numeric)), ' weeks old')
                        END
                        WHEN (EXTRACT(month FROM age(patients.birth_date)) = (1)::numeric) THEN '1 month old'::text
                        ELSE concat(EXTRACT(month FROM age(patients.birth_date)), ' months old')
                    END
                    WHEN (EXTRACT(year FROM age(patients.birth_date)) = (1)::numeric) THEN '1 y.o.'::text
                    ELSE concat((EXTRACT(year FROM age(patients.birth_date)))::integer, ' y.o.')
                END AS age,
                CASE
                    WHEN (patients.birth_date IS NULL) THEN NULL::text
                    WHEN (EXTRACT(year FROM age(patients.birth_date)) = (0)::numeric) THEN
                    CASE
                        WHEN (EXTRACT(month FROM age(patients.birth_date)) = (0)::numeric) THEN
                        CASE
                            WHEN ((EXTRACT(day FROM age(patients.birth_date)) / (7)::numeric) = (1)::numeric) THEN '1 semaine'::text
                            ELSE concat(floor((EXTRACT(day FROM age(patients.birth_date)) / (7)::numeric)), ' semaines')
                        END
                        WHEN (EXTRACT(month FROM age(patients.birth_date)) = (1)::numeric) THEN '1 mois'::text
                        ELSE concat(EXTRACT(month FROM age(patients.birth_date)), ' mois')
                    END
                    WHEN (EXTRACT(year FROM age(patients.birth_date)) = (1)::numeric) THEN '1 an'::text
                    ELSE concat((EXTRACT(year FROM age(patients.birth_date)))::integer, ' ans')
                END AS age_fr
           FROM patients
        )
 SELECT id,
    display_name,
    status,
    species,
        CASE
            WHEN (species = 'dog'::species_enum) THEN 'chien'::text
            WHEN (species = 'cat'::species_enum) THEN 'chat'::text
            ELSE (species)::text
        END AS species_fr,
    breed,
    gender,
        CASE
            WHEN (gender = 'female'::text) THEN 'femelle'::text
            WHEN (gender = 'male'::text) THEN 'mâle'::text
            ELSE gender
        END AS gender_fr,
        CASE
            WHEN ((gender = 'female'::text) AND (gender_status = 'neutered'::text)) THEN 'spayed'::text
            ELSE gender_status
        END AS gender_status,
        CASE
            WHEN ((gender = 'female'::text) AND (gender_status = 'neutered'::text)) THEN 'opérée'::text
            WHEN (gender_status = 'unknown'::text) THEN 'inconnu'::text
            WHEN (gender_status = 'neutered'::text) THEN 'stérilisé'::text
            WHEN (gender_status = 'spayed'::text) THEN 'opérée'::text
            WHEN (gender_status = 'intact'::text) THEN 'fertile'::text
            ELSE NULL::text
        END AS gender_status_fr,
    birth_date,
    photo_url,
    microchip,
        CASE
            WHEN ((display_name IS NOT NULL) AND (status IS NOT NULL) AND (species IS NOT NULL) AND (breed IS NOT NULL) AND (gender IS NOT NULL) AND (gender_status IS NOT NULL) AND (birth_date IS NOT NULL) AND (photo_url IS NOT NULL) AND (microchip IS NOT NULL)) THEN true
            ELSE false
        END AS is_onboarded,
    age,
    age_fr,
        CASE
            WHEN (birth_date IS NULL) THEN NULL::text
            ELSE ( SELECT (upper("left"(sub.x, 1)) || SUBSTRING(sub.x FROM 2))
               FROM ( SELECT concat(
                            CASE
                                WHEN (EXTRACT(year FROM age(pd.birth_date)) >= (1)::numeric) THEN concat((EXTRACT(year FROM age(pd.birth_date)))::integer, 'y',
                                CASE
                                    WHEN (EXTRACT(month FROM age(pd.birth_date)) > (0)::numeric) THEN concat(' ', (EXTRACT(month FROM age(pd.birth_date)))::integer, 'm')
                                    ELSE ''::text
                                END)
                                ELSE concat((EXTRACT(month FROM age(pd.birth_date)))::integer, 'm')
                            END, ' old ', pd.gender,
                            CASE
                                WHEN (pd.species = 'dog'::species_enum) THEN concat(' ', lower(pd.breed))
                                ELSE ''::text
                            END) AS x) sub)
        END AS byline,
        CASE
            WHEN (birth_date IS NULL) THEN NULL::text
            ELSE ( SELECT (upper("left"(sub.x, 1)) || SUBSTRING(sub.x FROM 2))
               FROM ( SELECT
                            CASE
                                WHEN (pd.species = 'dog'::species_enum) THEN concat(lower(pd.breed), ' ',
                                CASE
                                    WHEN (pd.gender = 'female'::text) THEN 'femelle'::text
                                    WHEN (pd.gender = 'male'::text) THEN 'mâle'::text
                                    ELSE pd.gender
                                END, ' de ',
                                CASE
                                    WHEN (EXTRACT(year FROM age(pd.birth_date)) >= (1)::numeric) THEN concat(
                                    CASE
WHEN (EXTRACT(year FROM age(pd.birth_date)) = (1)::numeric) THEN '1 an'::text
ELSE concat((EXTRACT(year FROM age(pd.birth_date)))::integer, ' ans')
                                    END,
                                    CASE
WHEN (EXTRACT(month FROM age(pd.birth_date)) > (0)::numeric) THEN concat(' et ', (EXTRACT(month FROM age(pd.birth_date)))::integer, ' mois')
ELSE ''::text
                                    END)
                                    ELSE
                                    CASE
WHEN (EXTRACT(month FROM age(pd.birth_date)) = (1)::numeric) THEN '1 mois'::text
ELSE concat((EXTRACT(month FROM age(pd.birth_date)))::integer, ' mois')
                                    END
                                END)
                                ELSE concat(
                                CASE
                                    WHEN (pd.gender = 'female'::text) THEN 'femelle'::text
                                    WHEN (pd.gender = 'male'::text) THEN 'mâle'::text
                                    ELSE pd.gender
                                END, ' de ',
                                CASE
                                    WHEN (EXTRACT(year FROM age(pd.birth_date)) >= (1)::numeric) THEN concat(
                                    CASE
WHEN (EXTRACT(year FROM age(pd.birth_date)) = (1)::numeric) THEN '1 an'::text
ELSE concat((EXTRACT(year FROM age(pd.birth_date)))::integer, ' ans')
                                    END,
                                    CASE
WHEN (EXTRACT(month FROM age(pd.birth_date)) > (0)::numeric) THEN concat(' et ', (EXTRACT(month FROM age(pd.birth_date)))::integer, ' mois')
ELSE ''::text
                                    END)
                                    ELSE
                                    CASE
WHEN (EXTRACT(month FROM age(pd.birth_date)) = (1)::numeric) THEN '1 mois'::text
ELSE concat((EXTRACT(month FROM age(pd.birth_date)))::integer, ' mois')
                                    END
                                END)
                            END AS x) sub)
        END AS byline_fr,
    (((( SELECT count(*) AS count
           FROM encounters e
          WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
           FROM immunizations im
          WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
           FROM lab_results lr
          WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
           FROM imaging i
          WHERE (i.patient_id = pd.id))) AS records_count,
    ovet_email,
    requested_records_via_email,
    received_any_records,
        CASE
            WHEN ((requested_records_via_email = true) AND ((received_any_records IS NULL) OR (received_any_records = false)) AND ((((( SELECT count(*) AS count
               FROM encounters e
              WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
               FROM immunizations im
              WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
               FROM lab_results lr
              WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
               FROM imaging i
              WHERE (i.patient_id = pd.id))) = 0)) THEN 2
            WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
               FROM encounters e
              WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
               FROM immunizations im
              WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
               FROM lab_results lr
              WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
               FROM imaging i
              WHERE (i.patient_id = pd.id))) = 0)) THEN 3
            WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
               FROM encounters e
              WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
               FROM immunizations im
              WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
               FROM lab_results lr
              WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
               FROM imaging i
              WHERE (i.patient_id = pd.id))) > 0)) THEN 4
            ELSE 1
        END AS onboarding_step,
        CASE
            WHEN (
            CASE
                WHEN ((requested_records_via_email = true) AND ((received_any_records IS NULL) OR (received_any_records = false)) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 2
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 3
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) > 0)) THEN 4
                ELSE 1
            END = 1) THEN (('Tap here to request '::text || display_name) || '''s records from your clinic.'::text)
            WHEN (
            CASE
                WHEN ((requested_records_via_email = true) AND ((received_any_records IS NULL) OR (received_any_records = false)) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 2
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 3
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) > 0)) THEN 4
                ELSE 1
            END = 2) THEN (('We''re awaiting to receive '::text || display_name) || '''s records from your clinic.'::text)
            WHEN (
            CASE
                WHEN ((requested_records_via_email = true) AND ((received_any_records IS NULL) OR (received_any_records = false)) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 2
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 3
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) > 0)) THEN 4
                ELSE 1
            END = 3) THEN (('We are organizing '::text || display_name) || '''s records. Hang tight, it''s almost ready!'::text)
            ELSE 'You''re all set.'::text
        END AS onboarding_step_text,
        CASE
            WHEN (
            CASE
                WHEN ((requested_records_via_email = true) AND ((received_any_records IS NULL) OR (received_any_records = false)) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 2
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 3
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) > 0)) THEN 4
                ELSE 1
            END = 1) THEN (('Appuyez ici pour demander les dossiers de '::text || display_name) || ' à votre clinique.'::text)
            WHEN (
            CASE
                WHEN ((requested_records_via_email = true) AND ((received_any_records IS NULL) OR (received_any_records = false)) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 2
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 3
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) > 0)) THEN 4
                ELSE 1
            END = 2) THEN (('Nous attendons de recevoir les dossiers de '::text || display_name) || ' de votre clinique.'::text)
            WHEN (
            CASE
                WHEN ((requested_records_via_email = true) AND ((received_any_records IS NULL) OR (received_any_records = false)) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 2
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) = 0)) THEN 3
                WHEN ((requested_records_via_email = true) AND (received_any_records = true) AND ((((( SELECT count(*) AS count
                   FROM encounters e
                  WHERE (e.patient_id = pd.id)) + ( SELECT count(*) AS count
                   FROM immunizations im
                  WHERE (im.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM lab_results lr
                  WHERE (lr.patient_id = pd.id))) + ( SELECT count(*) AS count
                   FROM imaging i
                  WHERE (i.patient_id = pd.id))) > 0)) THEN 4
                ELSE 1
            END = 3) THEN (('Nous organisons les dossiers de '::text || display_name) || '. Tenez bon, c''est presque prêt !'::text)
            ELSE 'Tout est prêt.'::text
        END AS onboarding_step_text_fr
   FROM patient_data pd;


create or replace view "public"."app_records_request" as  SELECT up.user_id,
    up.patient_id,
    ((((((((((((((((('Hi,'::text || '

'::text) || 'I am writing to request the complete medical file (clinic medical records, laboratory results, X-ray images, and any other medical documents, if applicable) for '::text) || p.display_name) || ' '::text) || u.last_name) || '.'::text) || '

'::text) || 'Please forward all documents to the following email address: '::text) || p.ovet_email) || ', with my current email in CC.'::text) || '

'::text) || 'Thank you,'::text) || '

'::text) || u.first_name) || ' '::text) || u.last_name) ||
        CASE
            WHEN (u.phone_number IS NOT NULL) THEN (', '::text || u.phone_number)
            ELSE ''::text
        END) AS request_email,
    ((((((((((((((((('Bonjour,'::text || '

'::text) || 'Par la présente, j''aimerais obtenir le dossier médical complet (dossier médical de la clinique, résultats de laboratoire, images de radiographies, ainsi que tous autres documents médicaux, le cas échéant) pour '::text) || p.display_name) || ' '::text) || u.last_name) || '.'::text) || '

'::text) || 'S''il vous plaît, veuillez me transférer tous les documents à l''adresse courriel suivante : '::text) || p.ovet_email) || ', en mettant mon courriel actuel en CC.'::text) || '

'::text) || 'Je vous remercie,'::text) || '

'::text) || u.first_name) || ' '::text) || u.last_name) ||
        CASE
            WHEN (u.phone_number IS NOT NULL) THEN (', '::text || u.phone_number)
            ELSE ''::text
        END) AS request_email_fr,
    (('Request for '::text || p.display_name) || '''s medical records'::text) AS subject,
    ('Obtention du dossier médical de '::text || p.display_name) AS subject_fr
   FROM ((users_patients up
     JOIN patients p ON ((p.id = up.patient_id)))
     JOIN users u ON ((u.id = up.user_id)));


create or replace view "public"."app_user" as  SELECT id,
    created_at,
    email,
    unit,
    language,
    status,
    person_type,
    phone_number,
    first_name,
    last_name,
    updated_at,
    photo_url,
    ( SELECT json_agg(up.patient_id ORDER BY up.created_at) AS json_agg
           FROM (users_patients up
             JOIN patients p ON ((up.patient_id = p.id)))
          WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))) AS active_patients,
    ( SELECT count(*) AS count
           FROM users_patients up
          WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))) AS active_patient_count,
    ( SELECT COALESCE(bool_and(((p.display_name IS NOT NULL) AND (p.status IS NOT NULL) AND (p.species IS NOT NULL) AND (p.breed IS NOT NULL) AND (p.gender IS NOT NULL) AND (p.gender_status IS NOT NULL) AND (p.birth_date IS NOT NULL) AND (p.photo_url IS NOT NULL) AND (p.microchip IS NOT NULL))), false) AS "coalesce"
           FROM (users_patients up
             JOIN patients p ON ((up.patient_id = p.id)))
          WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))) AS patients_onboarded,
    ( SELECT
                CASE
                    WHEN ((sub.arr IS NULL) OR (cardinality(sub.arr) = 0)) THEN NULL::text
                    WHEN (cardinality(sub.arr) = 1) THEN sub.arr[1]
                    WHEN (cardinality(sub.arr) = 2) THEN ((sub.arr[1] || ' & '::text) || sub.arr[2])
                    ELSE ((array_to_string(sub.arr[1:(array_length(sub.arr, 1) - 1)], ', '::text) || ', and '::text) || sub.arr[array_length(sub.arr, 1)])
                END AS "case"
           FROM ( SELECT array_agg(p.display_name ORDER BY up.created_at) AS arr
                   FROM (users_patients up
                     JOIN patients p ON ((up.patient_id = p.id)))
                  WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))) sub) AS patients_names,
    ( SELECT
                CASE
                    WHEN ((sub.arr IS NULL) OR (cardinality(sub.arr) = 0)) THEN NULL::text
                    WHEN (cardinality(sub.arr) = 1) THEN sub.arr[1]
                    WHEN (cardinality(sub.arr) = 2) THEN ((sub.arr[1] || ' et '::text) || sub.arr[2])
                    ELSE ((array_to_string(sub.arr[1:(cardinality(sub.arr) - 1)], ', '::text) || ' et '::text) || sub.arr[cardinality(sub.arr)])
                END AS "case"
           FROM ( SELECT array_agg(p.display_name ORDER BY up.created_at) AS arr
                   FROM (users_patients up
                     JOIN patients p ON ((up.patient_id = p.id)))
                  WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))) sub) AS patients_names_fr,
    (((COALESCE(( SELECT count(DISTINCT i.id) AS count
           FROM immunizations i
          WHERE (i.patient_id IN ( SELECT up.patient_id
                   FROM users_patients up
                  WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))))), (0)::bigint) + COALESCE(( SELECT count(DISTINCT e.id) AS count
           FROM encounters e
          WHERE (e.patient_id IN ( SELECT up.patient_id
                   FROM users_patients up
                  WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))))), (0)::bigint)) + COALESCE(( SELECT count(DISTINCT lr.id) AS count
           FROM lab_results lr
          WHERE (lr.patient_id IN ( SELECT up.patient_id
                   FROM users_patients up
                  WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))))), (0)::bigint)) + COALESCE(( SELECT count(DISTINCT mr.id) AS count
           FROM medication_requests mr
          WHERE (mr.patient_id IN ( SELECT up.patient_id
                   FROM users_patients up
                  WHERE ((up.user_id = u.id) AND (up.status = 'active'::patient_status_enum))))), (0)::bigint)) AS patients_records_count,
    ( SELECT inviter.first_name
           FROM (invited_users iu
             JOIN users inviter ON ((inviter.id = iu.invited_by)))
          WHERE (iu.invited_user = u.id)
          ORDER BY iu.invited_at DESC
         LIMIT 1) AS inviter_name,
    ( SELECT inviter.email
           FROM (invited_users iu
             JOIN users inviter ON ((inviter.id = iu.invited_by)))
          WHERE (iu.invited_user = u.id)
          ORDER BY iu.invited_at DESC
         LIMIT 1) AS inviter_email
   FROM users u;


create or replace view "public"."app_users_patients" as  SELECT up.patient_id,
    up.created_at,
    up.user_id,
    up.updated_at,
    up.status,
    p.photo_url AS patient_photo_url,
    p.created_at AS patient_created_at,
    p.display_name AS patient_display_name
   FROM (users_patients up
     JOIN patients p ON ((p.id = up.patient_id)));


create or replace view "public"."app_weight_values" as  SELECT id AS observations_id,
    patient_id,
    effective_date,
        CASE
            WHEN (lower(value_quantity_unit) = 'kg'::text) THEN round((value_quantity_value)::numeric, 1)
            WHEN (lower(value_quantity_unit) = 'lbs'::text) THEN round(((value_quantity_value * (0.45359237)::double precision))::numeric, 1)
            ELSE NULL::numeric
        END AS value_kg,
        CASE
            WHEN (lower(value_quantity_unit) = 'lbs'::text) THEN round((value_quantity_value)::numeric, 1)
            WHEN (lower(value_quantity_unit) = 'kg'::text) THEN round(((value_quantity_value * (2.20462)::double precision))::numeric, 1)
            ELSE NULL::numeric
        END AS value_lbs
   FROM observations o
  WHERE (code = '27113001'::text);


CREATE OR REPLACE FUNCTION public.create_household_on_user_creation()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.users (id, email)
  values (new.id, new.email);
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

create or replace view "public"."app_feed" as  WITH latest_encounters AS (
         SELECT DISTINCT ON (app_encounters.patient_id) app_encounters.encounter_id,
            app_encounters.patient_id,
            app_encounters.encounter_date,
            app_encounters.status_code,
            app_encounters.class_coding_code,
            app_encounters.created_at,
            app_encounters.verification_status,
            app_encounters.encounter_summary,
            app_encounters.clinic_id,
            app_encounters.attachments,
            app_encounters.reason_for_visit,
            app_encounters.clinic_name,
            app_encounters.clinic_address,
            app_encounters.has_immunizations,
            app_encounters.immunizations_count,
            app_encounters.has_medications,
            app_encounters.medications_count,
            app_encounters.has_lab_result,
            app_encounters.lab_results_count,
            app_encounters.has_imaging,
            app_encounters.imaging_count,
            app_encounters.has_observations,
            app_encounters.observations_count,
            app_encounters.obs_weight_value,
            app_encounters.attachments_count
           FROM app_encounters
          ORDER BY app_encounters.patient_id, app_encounters.encounter_date DESC
        ), immunizations_feed AS (
         SELECT DISTINCT ON (i.immunization_id) i.patient_id,
            p.display_name,
            'immunization'::text AS event_type,
            (i.immunization_id)::text AS event_id,
                CASE
                    WHEN (i.days_until_renewal <= (0)::double precision) THEN concat(p.display_name, '''s booster for ', i.short, ' is ', ((((date_part('year'::text, age(now(), i.recommended_renewal_date)) * (12)::double precision) + date_part('month'::text, age(now(), i.recommended_renewal_date))))::integer)::text,
                    CASE
                        WHEN ((((date_part('year'::text, age(now(), i.recommended_renewal_date)) * (12)::double precision) + date_part('month'::text, age(now(), i.recommended_renewal_date))))::integer = 1) THEN ' month overdue'::text
                        ELSE ' months overdue'::text
                    END)
                    WHEN ((i.days_until_renewal >= (1)::double precision) AND (i.days_until_renewal <= (90)::double precision)) THEN concat(p.display_name, '''s booster for ', i.short,
                    CASE
                        WHEN ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer = 0) THEN ' is due'::text
                        ELSE concat(' is due in ', ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer)::text,
                        CASE
                            WHEN ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer = 1) THEN ' month'::text
                            ELSE ' months'::text
                        END)
                    END)
                    ELSE NULL::text
                END AS message,
                CASE
                    WHEN (i.days_until_renewal < (0)::double precision) THEN concat('le rappel de ', i.short, ' de ', p.display_name, ' est en retard de ', ((((date_part('year'::text, age(now(), i.recommended_renewal_date)) * (12)::double precision) + date_part('month'::text, age(now(), i.recommended_renewal_date))))::integer)::text, ' mois')
                    WHEN ((i.days_until_renewal >= (0)::double precision) AND (i.days_until_renewal <= (90)::double precision)) THEN
                    CASE
                        WHEN ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer = 0) THEN concat(p.display_name, ' est dû pour le rappel de ',
                        CASE
                            WHEN (i.code = '335711000009100'::text) THEN i.short_fr
                            ELSE (lower(substr(i.short_fr, 1, 1)) || substr(i.short_fr, 2))
                        END)
                        ELSE concat('Le rappel de ',
                        CASE
                            WHEN (i.code = '335711000009100'::text) THEN i.short_fr
                            ELSE (lower(substr(i.short_fr, 1, 1)) || substr(i.short_fr, 2))
                        END, ' de ', p.display_name, ' est dans ', ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer)::text, ' mois')
                    END
                    ELSE NULL::text
                END AS message_fr,
                CASE
                    WHEN (i.days_until_renewal <= (0)::double precision) THEN concat('Booster for ', i.short, ' is ', ((((date_part('year'::text, age(now(), i.recommended_renewal_date)) * (12)::double precision) + date_part('month'::text, age(now(), i.recommended_renewal_date))))::integer)::text,
                    CASE
                        WHEN ((((date_part('year'::text, age(now(), i.recommended_renewal_date)) * (12)::double precision) + date_part('month'::text, age(now(), i.recommended_renewal_date))))::integer = 1) THEN ' month overdue'::text
                        ELSE ' months overdue'::text
                    END)
                    WHEN ((i.days_until_renewal >= (1)::double precision) AND (i.days_until_renewal <= (90)::double precision)) THEN concat('Booster for ', i.short,
                    CASE
                        WHEN ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer = 0) THEN ' is due'::text
                        ELSE concat(' is due in ', ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer)::text,
                        CASE
                            WHEN ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer = 1) THEN ' month'::text
                            ELSE ' months'::text
                        END)
                    END)
                    ELSE NULL::text
                END AS message_singular,
                CASE
                    WHEN (i.days_until_renewal < (0)::double precision) THEN concat('Le rappel de ',
                    CASE
                        WHEN (i.code = '335711000009100'::text) THEN i.short_fr
                        ELSE (lower(substr(i.short_fr, 1, 1)) || substr(i.short_fr, 2))
                    END, ' est en retard de ', ((((date_part('year'::text, age(now(), i.recommended_renewal_date)) * (12)::double precision) + date_part('month'::text, age(now(), i.recommended_renewal_date))))::integer)::text, ' mois')
                    WHEN ((i.days_until_renewal >= (0)::double precision) AND (i.days_until_renewal <= (90)::double precision)) THEN
                    CASE
                        WHEN ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer = 0) THEN concat(p.display_name, ' est dû pour le rappel de ',
                        CASE
                            WHEN (i.code = '335711000009100'::text) THEN i.short_fr
                            ELSE (lower(substr(i.short_fr, 1, 1)) || substr(i.short_fr, 2))
                        END)
                        ELSE concat('Le rappel de ',
                        CASE
                            WHEN (i.code = '335711000009100'::text) THEN i.short_fr
                            ELSE (lower(substr(i.short_fr, 1, 1)) || substr(i.short_fr, 2))
                        END, ' est dans ', ((((date_part('year'::text, age(i.recommended_renewal_date, now())) * (12)::double precision) + date_part('month'::text, age(i.recommended_renewal_date, now()))))::integer)::text, ' mois')
                    END
                    ELSE NULL::text
                END AS message_singular_fr,
            i.occurrence_date AS event_date,
            i.recommended_renewal_date AS event_due_date,
                CASE
                    WHEN i.is_latest THEN 'new'::text
                    ELSE 'archived'::text
                END AS status
           FROM ((app_immunizations i
             JOIN patients p ON ((i.patient_id = p.id)))
             JOIN app_users_patients up ON ((p.id = up.patient_id)))
          WHERE ((i.days_until_renewal IS NOT NULL) AND (i.days_until_renewal <= (90)::double precision))
          ORDER BY i.immunization_id, i.occurrence_date DESC
        ), encounter_feed AS (
         SELECT DISTINCT ON (e.encounter_id) e.patient_id,
            p.display_name,
            'encounter'::text AS event_type,
            (e.encounter_id)::text AS event_id,
            concat('Don''t forget to book ', p.display_name, '''s annual exam') AS message,
            concat('C''est le temps de booker l''examen annuel de ', p.display_name) AS message_fr,
            concat('Don''t forget to book the annual exam') AS message_singular,
            concat('C''est le temps de booker l''examen annuel') AS message_singular_fr,
            ((e.encounter_date + '1 year'::interval) - '90 days'::interval) AS event_date,
            (e.encounter_date + '1 year'::interval) AS event_due_date,
            'new'::text AS status
           FROM ((latest_encounters e
             JOIN patients p ON ((e.patient_id = p.id)))
             JOIN app_users_patients up ON ((p.id = up.patient_id)))
          WHERE (now() < (e.encounter_date + '1 year'::interval))
        ), encounter_overdue_feed AS (
         SELECT DISTINCT ON (e.encounter_id) e.patient_id,
            p.display_name,
            'encounter'::text AS event_type,
            (e.encounter_id)::text AS event_id,
            concat(p.display_name, '''s annual exam is ', ((((date_part('year'::text, age(now(), (e.encounter_date + '1 year'::interval))) * (12)::double precision) + date_part('month'::text, age(now(), (e.encounter_date + '1 year'::interval)))))::integer)::text,
                CASE (((date_part('year'::text, age(now(), (e.encounter_date + '1 year'::interval))) * (12)::double precision) + date_part('month'::text, age(now(), (e.encounter_date + '1 year'::interval)))))::integer
                    WHEN 1 THEN ' month overdue'::text
                    ELSE ' months overdue'::text
                END) AS message,
            concat(p.display_name, ' est en retard de ', ((((date_part('year'::text, age(now(), (e.encounter_date + '1 year'::interval))) * (12)::double precision) + date_part('month'::text, age(now(), (e.encounter_date + '1 year'::interval)))))::integer)::text, ' mois pour son examen annuel') AS message_fr,
            concat('The annual exam is ', ((((date_part('year'::text, age(now(), (e.encounter_date + '1 year'::interval))) * (12)::double precision) + date_part('month'::text, age(now(), (e.encounter_date + '1 year'::interval)))))::integer)::text,
                CASE (((date_part('year'::text, age(now(), (e.encounter_date + '1 year'::interval))) * (12)::double precision) + date_part('month'::text, age(now(), (e.encounter_date + '1 year'::interval)))))::integer
                    WHEN 1 THEN ' month overdue'::text
                    ELSE ' months overdue'::text
                END) AS message_singular,
            concat('L''examen annuel est en retard de ', ((((date_part('year'::text, age(now(), (e.encounter_date + '1 year'::interval))) * (12)::double precision) + date_part('month'::text, age(now(), (e.encounter_date + '1 year'::interval)))))::integer)::text, ' mois') AS message_singular_fr,
            (e.encounter_date + '1 year'::interval) AS event_date,
            (e.encounter_date + '1 year'::interval) AS event_due_date,
            'new'::text AS status
           FROM ((latest_encounters e
             JOIN patients p ON ((e.patient_id = p.id)))
             JOIN app_users_patients up ON ((p.id = up.patient_id)))
          WHERE (now() > (e.encounter_date + '1 year'::interval))
        ), requested_records_feed AS (
         SELECT p.id AS patient_id,
            p.display_name,
            'request'::text AS event_type,
            ('request-'::text || (p.id)::text) AS event_id,
            (('We''re awaiting to receive '::text || p.display_name) || '''s records from the clinic.'::text) AS message,
            (('Nous attendons de recevoir les dossiers de '::text || p.display_name) || ' de la clinique.'::text) AS message_fr,
            'We''re awaiting to receive the records from the clinic.'::text AS message_singular,
            'Nous attendons de recevoir les dossiers de la clinique.'::text AS message_singular_fr,
            now() AS event_date,
            now() AS event_due_date,
                CASE
                    WHEN ((((( SELECT count(*) AS count
                       FROM encounters e
                      WHERE (e.patient_id = p.id)) + ( SELECT count(*) AS count
                       FROM immunizations im
                      WHERE (im.patient_id = p.id))) + ( SELECT count(*) AS count
                       FROM lab_results lr
                      WHERE (lr.patient_id = p.id))) + ( SELECT count(*) AS count
                       FROM imaging i
                      WHERE (i.patient_id = p.id))) = 0) THEN 'new'::text
                    ELSE 'archived'::text
                END AS status
           FROM patients p
          WHERE (p.requested_records_via_email = true)
        )
 SELECT immunizations_feed.patient_id,
    immunizations_feed.display_name,
    immunizations_feed.event_type,
    immunizations_feed.event_id,
    immunizations_feed.message,
    immunizations_feed.message_fr,
    immunizations_feed.message_singular,
    immunizations_feed.message_singular_fr,
    immunizations_feed.event_date,
    immunizations_feed.event_due_date,
    immunizations_feed.status
   FROM immunizations_feed
UNION
 SELECT encounter_feed.patient_id,
    encounter_feed.display_name,
    encounter_feed.event_type,
    encounter_feed.event_id,
    encounter_feed.message,
    encounter_feed.message_fr,
    encounter_feed.message_singular,
    encounter_feed.message_singular_fr,
    encounter_feed.event_date,
    encounter_feed.event_due_date,
    encounter_feed.status
   FROM encounter_feed
UNION
 SELECT encounter_overdue_feed.patient_id,
    encounter_overdue_feed.display_name,
    encounter_overdue_feed.event_type,
    encounter_overdue_feed.event_id,
    encounter_overdue_feed.message,
    encounter_overdue_feed.message_fr,
    encounter_overdue_feed.message_singular,
    encounter_overdue_feed.message_singular_fr,
    encounter_overdue_feed.event_date,
    encounter_overdue_feed.event_due_date,
    encounter_overdue_feed.status
   FROM encounter_overdue_feed
UNION
 SELECT requested_records_feed.patient_id,
    requested_records_feed.display_name,
    requested_records_feed.event_type,
    requested_records_feed.event_id,
    requested_records_feed.message,
    requested_records_feed.message_fr,
    requested_records_feed.message_singular,
    requested_records_feed.message_singular_fr,
    requested_records_feed.event_date,
    requested_records_feed.event_due_date,
    requested_records_feed.status
   FROM requested_records_feed
  ORDER BY 9 DESC;


grant delete on table "public"."clinics" to "anon";

grant insert on table "public"."clinics" to "anon";

grant references on table "public"."clinics" to "anon";

grant select on table "public"."clinics" to "anon";

grant trigger on table "public"."clinics" to "anon";

grant truncate on table "public"."clinics" to "anon";

grant update on table "public"."clinics" to "anon";

grant insert on table "public"."clinics" to "authenticated";

grant references on table "public"."clinics" to "authenticated";

grant select on table "public"."clinics" to "authenticated";

grant trigger on table "public"."clinics" to "authenticated";

grant truncate on table "public"."clinics" to "authenticated";

grant update on table "public"."clinics" to "authenticated";

grant delete on table "public"."clinics" to "service_role";

grant insert on table "public"."clinics" to "service_role";

grant references on table "public"."clinics" to "service_role";

grant select on table "public"."clinics" to "service_role";

grant trigger on table "public"."clinics" to "service_role";

grant truncate on table "public"."clinics" to "service_role";

grant update on table "public"."clinics" to "service_role";

grant delete on table "public"."clinics_patients" to "anon";

grant insert on table "public"."clinics_patients" to "anon";

grant references on table "public"."clinics_patients" to "anon";

grant select on table "public"."clinics_patients" to "anon";

grant trigger on table "public"."clinics_patients" to "anon";

grant truncate on table "public"."clinics_patients" to "anon";

grant update on table "public"."clinics_patients" to "anon";

grant delete on table "public"."clinics_patients" to "authenticated";

grant insert on table "public"."clinics_patients" to "authenticated";

grant references on table "public"."clinics_patients" to "authenticated";

grant select on table "public"."clinics_patients" to "authenticated";

grant trigger on table "public"."clinics_patients" to "authenticated";

grant truncate on table "public"."clinics_patients" to "authenticated";

grant update on table "public"."clinics_patients" to "authenticated";

grant delete on table "public"."clinics_patients" to "service_role";

grant insert on table "public"."clinics_patients" to "service_role";

grant references on table "public"."clinics_patients" to "service_role";

grant select on table "public"."clinics_patients" to "service_role";

grant trigger on table "public"."clinics_patients" to "service_role";

grant truncate on table "public"."clinics_patients" to "service_role";

grant update on table "public"."clinics_patients" to "service_role";

grant delete on table "public"."code_routes" to "anon";

grant insert on table "public"."code_routes" to "anon";

grant references on table "public"."code_routes" to "anon";

grant select on table "public"."code_routes" to "anon";

grant trigger on table "public"."code_routes" to "anon";

grant truncate on table "public"."code_routes" to "anon";

grant update on table "public"."code_routes" to "anon";

grant delete on table "public"."code_routes" to "authenticated";

grant insert on table "public"."code_routes" to "authenticated";

grant references on table "public"."code_routes" to "authenticated";

grant select on table "public"."code_routes" to "authenticated";

grant trigger on table "public"."code_routes" to "authenticated";

grant truncate on table "public"."code_routes" to "authenticated";

grant update on table "public"."code_routes" to "authenticated";

grant delete on table "public"."code_routes" to "service_role";

grant insert on table "public"."code_routes" to "service_role";

grant references on table "public"."code_routes" to "service_role";

grant select on table "public"."code_routes" to "service_role";

grant trigger on table "public"."code_routes" to "service_role";

grant truncate on table "public"."code_routes" to "service_role";

grant update on table "public"."code_routes" to "service_role";

grant delete on table "public"."codes_breeds" to "anon";

grant insert on table "public"."codes_breeds" to "anon";

grant references on table "public"."codes_breeds" to "anon";

grant select on table "public"."codes_breeds" to "anon";

grant trigger on table "public"."codes_breeds" to "anon";

grant truncate on table "public"."codes_breeds" to "anon";

grant update on table "public"."codes_breeds" to "anon";

grant delete on table "public"."codes_breeds" to "authenticated";

grant insert on table "public"."codes_breeds" to "authenticated";

grant references on table "public"."codes_breeds" to "authenticated";

grant select on table "public"."codes_breeds" to "authenticated";

grant trigger on table "public"."codes_breeds" to "authenticated";

grant truncate on table "public"."codes_breeds" to "authenticated";

grant update on table "public"."codes_breeds" to "authenticated";

grant delete on table "public"."codes_breeds" to "service_role";

grant insert on table "public"."codes_breeds" to "service_role";

grant references on table "public"."codes_breeds" to "service_role";

grant select on table "public"."codes_breeds" to "service_role";

grant trigger on table "public"."codes_breeds" to "service_role";

grant truncate on table "public"."codes_breeds" to "service_role";

grant update on table "public"."codes_breeds" to "service_role";

grant delete on table "public"."codes_immunizations" to "anon";

grant insert on table "public"."codes_immunizations" to "anon";

grant references on table "public"."codes_immunizations" to "anon";

grant select on table "public"."codes_immunizations" to "anon";

grant trigger on table "public"."codes_immunizations" to "anon";

grant truncate on table "public"."codes_immunizations" to "anon";

grant update on table "public"."codes_immunizations" to "anon";

grant delete on table "public"."codes_immunizations" to "authenticated";

grant insert on table "public"."codes_immunizations" to "authenticated";

grant references on table "public"."codes_immunizations" to "authenticated";

grant select on table "public"."codes_immunizations" to "authenticated";

grant trigger on table "public"."codes_immunizations" to "authenticated";

grant truncate on table "public"."codes_immunizations" to "authenticated";

grant update on table "public"."codes_immunizations" to "authenticated";

grant delete on table "public"."codes_immunizations" to "service_role";

grant insert on table "public"."codes_immunizations" to "service_role";

grant references on table "public"."codes_immunizations" to "service_role";

grant select on table "public"."codes_immunizations" to "service_role";

grant trigger on table "public"."codes_immunizations" to "service_role";

grant truncate on table "public"."codes_immunizations" to "service_role";

grant update on table "public"."codes_immunizations" to "service_role";

grant delete on table "public"."codes_medication_ovet" to "anon";

grant insert on table "public"."codes_medication_ovet" to "anon";

grant references on table "public"."codes_medication_ovet" to "anon";

grant select on table "public"."codes_medication_ovet" to "anon";

grant trigger on table "public"."codes_medication_ovet" to "anon";

grant truncate on table "public"."codes_medication_ovet" to "anon";

grant update on table "public"."codes_medication_ovet" to "anon";

grant delete on table "public"."codes_medication_ovet" to "authenticated";

grant insert on table "public"."codes_medication_ovet" to "authenticated";

grant references on table "public"."codes_medication_ovet" to "authenticated";

grant select on table "public"."codes_medication_ovet" to "authenticated";

grant trigger on table "public"."codes_medication_ovet" to "authenticated";

grant truncate on table "public"."codes_medication_ovet" to "authenticated";

grant update on table "public"."codes_medication_ovet" to "authenticated";

grant delete on table "public"."codes_medication_ovet" to "service_role";

grant insert on table "public"."codes_medication_ovet" to "service_role";

grant references on table "public"."codes_medication_ovet" to "service_role";

grant select on table "public"."codes_medication_ovet" to "service_role";

grant trigger on table "public"."codes_medication_ovet" to "service_role";

grant truncate on table "public"."codes_medication_ovet" to "service_role";

grant update on table "public"."codes_medication_ovet" to "service_role";

grant delete on table "public"."codes_observations" to "anon";

grant insert on table "public"."codes_observations" to "anon";

grant references on table "public"."codes_observations" to "anon";

grant select on table "public"."codes_observations" to "anon";

grant trigger on table "public"."codes_observations" to "anon";

grant truncate on table "public"."codes_observations" to "anon";

grant update on table "public"."codes_observations" to "anon";

grant delete on table "public"."codes_observations" to "authenticated";

grant insert on table "public"."codes_observations" to "authenticated";

grant references on table "public"."codes_observations" to "authenticated";

grant select on table "public"."codes_observations" to "authenticated";

grant trigger on table "public"."codes_observations" to "authenticated";

grant truncate on table "public"."codes_observations" to "authenticated";

grant update on table "public"."codes_observations" to "authenticated";

grant delete on table "public"."codes_observations" to "service_role";

grant insert on table "public"."codes_observations" to "service_role";

grant references on table "public"."codes_observations" to "service_role";

grant select on table "public"."codes_observations" to "service_role";

grant trigger on table "public"."codes_observations" to "service_role";

grant truncate on table "public"."codes_observations" to "service_role";

grant update on table "public"."codes_observations" to "service_role";

grant delete on table "public"."encounters" to "anon";

grant insert on table "public"."encounters" to "anon";

grant references on table "public"."encounters" to "anon";

grant select on table "public"."encounters" to "anon";

grant trigger on table "public"."encounters" to "anon";

grant truncate on table "public"."encounters" to "anon";

grant update on table "public"."encounters" to "anon";

grant delete on table "public"."encounters" to "authenticated";

grant insert on table "public"."encounters" to "authenticated";

grant references on table "public"."encounters" to "authenticated";

grant select on table "public"."encounters" to "authenticated";

grant trigger on table "public"."encounters" to "authenticated";

grant truncate on table "public"."encounters" to "authenticated";

grant update on table "public"."encounters" to "authenticated";

grant delete on table "public"."encounters" to "service_role";

grant insert on table "public"."encounters" to "service_role";

grant references on table "public"."encounters" to "service_role";

grant select on table "public"."encounters" to "service_role";

grant trigger on table "public"."encounters" to "service_role";

grant truncate on table "public"."encounters" to "service_role";

grant update on table "public"."encounters" to "service_role";

grant delete on table "public"."households" to "anon";

grant insert on table "public"."households" to "anon";

grant references on table "public"."households" to "anon";

grant select on table "public"."households" to "anon";

grant trigger on table "public"."households" to "anon";

grant truncate on table "public"."households" to "anon";

grant update on table "public"."households" to "anon";

grant delete on table "public"."households" to "authenticated";

grant insert on table "public"."households" to "authenticated";

grant references on table "public"."households" to "authenticated";

grant select on table "public"."households" to "authenticated";

grant trigger on table "public"."households" to "authenticated";

grant truncate on table "public"."households" to "authenticated";

grant update on table "public"."households" to "authenticated";

grant delete on table "public"."households" to "service_role";

grant insert on table "public"."households" to "service_role";

grant references on table "public"."households" to "service_role";

grant select on table "public"."households" to "service_role";

grant trigger on table "public"."households" to "service_role";

grant truncate on table "public"."households" to "service_role";

grant update on table "public"."households" to "service_role";

grant delete on table "public"."imaging" to "anon";

grant insert on table "public"."imaging" to "anon";

grant references on table "public"."imaging" to "anon";

grant select on table "public"."imaging" to "anon";

grant trigger on table "public"."imaging" to "anon";

grant truncate on table "public"."imaging" to "anon";

grant update on table "public"."imaging" to "anon";

grant delete on table "public"."imaging" to "authenticated";

grant insert on table "public"."imaging" to "authenticated";

grant references on table "public"."imaging" to "authenticated";

grant select on table "public"."imaging" to "authenticated";

grant trigger on table "public"."imaging" to "authenticated";

grant truncate on table "public"."imaging" to "authenticated";

grant update on table "public"."imaging" to "authenticated";

grant delete on table "public"."imaging" to "service_role";

grant insert on table "public"."imaging" to "service_role";

grant references on table "public"."imaging" to "service_role";

grant select on table "public"."imaging" to "service_role";

grant trigger on table "public"."imaging" to "service_role";

grant truncate on table "public"."imaging" to "service_role";

grant update on table "public"."imaging" to "service_role";

grant delete on table "public"."immunization_recommendations" to "anon";

grant insert on table "public"."immunization_recommendations" to "anon";

grant references on table "public"."immunization_recommendations" to "anon";

grant select on table "public"."immunization_recommendations" to "anon";

grant trigger on table "public"."immunization_recommendations" to "anon";

grant truncate on table "public"."immunization_recommendations" to "anon";

grant update on table "public"."immunization_recommendations" to "anon";

grant delete on table "public"."immunization_recommendations" to "authenticated";

grant insert on table "public"."immunization_recommendations" to "authenticated";

grant references on table "public"."immunization_recommendations" to "authenticated";

grant select on table "public"."immunization_recommendations" to "authenticated";

grant trigger on table "public"."immunization_recommendations" to "authenticated";

grant truncate on table "public"."immunization_recommendations" to "authenticated";

grant update on table "public"."immunization_recommendations" to "authenticated";

grant delete on table "public"."immunization_recommendations" to "service_role";

grant insert on table "public"."immunization_recommendations" to "service_role";

grant references on table "public"."immunization_recommendations" to "service_role";

grant select on table "public"."immunization_recommendations" to "service_role";

grant trigger on table "public"."immunization_recommendations" to "service_role";

grant truncate on table "public"."immunization_recommendations" to "service_role";

grant update on table "public"."immunization_recommendations" to "service_role";

grant delete on table "public"."immunizations" to "anon";

grant insert on table "public"."immunizations" to "anon";

grant references on table "public"."immunizations" to "anon";

grant select on table "public"."immunizations" to "anon";

grant trigger on table "public"."immunizations" to "anon";

grant truncate on table "public"."immunizations" to "anon";

grant update on table "public"."immunizations" to "anon";

grant delete on table "public"."immunizations" to "authenticated";

grant insert on table "public"."immunizations" to "authenticated";

grant references on table "public"."immunizations" to "authenticated";

grant select on table "public"."immunizations" to "authenticated";

grant trigger on table "public"."immunizations" to "authenticated";

grant truncate on table "public"."immunizations" to "authenticated";

grant update on table "public"."immunizations" to "authenticated";

grant delete on table "public"."immunizations" to "service_role";

grant insert on table "public"."immunizations" to "service_role";

grant references on table "public"."immunizations" to "service_role";

grant select on table "public"."immunizations" to "service_role";

grant trigger on table "public"."immunizations" to "service_role";

grant truncate on table "public"."immunizations" to "service_role";

grant update on table "public"."immunizations" to "service_role";

grant delete on table "public"."invited_users" to "anon";

grant insert on table "public"."invited_users" to "anon";

grant references on table "public"."invited_users" to "anon";

grant select on table "public"."invited_users" to "anon";

grant trigger on table "public"."invited_users" to "anon";

grant truncate on table "public"."invited_users" to "anon";

grant update on table "public"."invited_users" to "anon";

grant delete on table "public"."invited_users" to "authenticated";

grant insert on table "public"."invited_users" to "authenticated";

grant references on table "public"."invited_users" to "authenticated";

grant select on table "public"."invited_users" to "authenticated";

grant trigger on table "public"."invited_users" to "authenticated";

grant truncate on table "public"."invited_users" to "authenticated";

grant update on table "public"."invited_users" to "authenticated";

grant delete on table "public"."invited_users" to "service_role";

grant insert on table "public"."invited_users" to "service_role";

grant references on table "public"."invited_users" to "service_role";

grant select on table "public"."invited_users" to "service_role";

grant trigger on table "public"."invited_users" to "service_role";

grant truncate on table "public"."invited_users" to "service_role";

grant update on table "public"."invited_users" to "service_role";

grant delete on table "public"."lab_results" to "anon";

grant insert on table "public"."lab_results" to "anon";

grant references on table "public"."lab_results" to "anon";

grant select on table "public"."lab_results" to "anon";

grant trigger on table "public"."lab_results" to "anon";

grant truncate on table "public"."lab_results" to "anon";

grant update on table "public"."lab_results" to "anon";

grant delete on table "public"."lab_results" to "authenticated";

grant insert on table "public"."lab_results" to "authenticated";

grant references on table "public"."lab_results" to "authenticated";

grant select on table "public"."lab_results" to "authenticated";

grant trigger on table "public"."lab_results" to "authenticated";

grant truncate on table "public"."lab_results" to "authenticated";

grant update on table "public"."lab_results" to "authenticated";

grant delete on table "public"."lab_results" to "service_role";

grant insert on table "public"."lab_results" to "service_role";

grant references on table "public"."lab_results" to "service_role";

grant select on table "public"."lab_results" to "service_role";

grant trigger on table "public"."lab_results" to "service_role";

grant truncate on table "public"."lab_results" to "service_role";

grant update on table "public"."lab_results" to "service_role";

grant delete on table "public"."medication_requests" to "anon";

grant insert on table "public"."medication_requests" to "anon";

grant references on table "public"."medication_requests" to "anon";

grant select on table "public"."medication_requests" to "anon";

grant trigger on table "public"."medication_requests" to "anon";

grant truncate on table "public"."medication_requests" to "anon";

grant update on table "public"."medication_requests" to "anon";

grant delete on table "public"."medication_requests" to "authenticated";

grant insert on table "public"."medication_requests" to "authenticated";

grant references on table "public"."medication_requests" to "authenticated";

grant select on table "public"."medication_requests" to "authenticated";

grant trigger on table "public"."medication_requests" to "authenticated";

grant truncate on table "public"."medication_requests" to "authenticated";

grant update on table "public"."medication_requests" to "authenticated";

grant delete on table "public"."medication_requests" to "service_role";

grant insert on table "public"."medication_requests" to "service_role";

grant references on table "public"."medication_requests" to "service_role";

grant select on table "public"."medication_requests" to "service_role";

grant trigger on table "public"."medication_requests" to "service_role";

grant truncate on table "public"."medication_requests" to "service_role";

grant update on table "public"."medication_requests" to "service_role";

grant delete on table "public"."observations" to "anon";

grant insert on table "public"."observations" to "anon";

grant references on table "public"."observations" to "anon";

grant select on table "public"."observations" to "anon";

grant trigger on table "public"."observations" to "anon";

grant truncate on table "public"."observations" to "anon";

grant update on table "public"."observations" to "anon";

grant delete on table "public"."observations" to "authenticated";

grant insert on table "public"."observations" to "authenticated";

grant references on table "public"."observations" to "authenticated";

grant select on table "public"."observations" to "authenticated";

grant trigger on table "public"."observations" to "authenticated";

grant truncate on table "public"."observations" to "authenticated";

grant update on table "public"."observations" to "authenticated";

grant delete on table "public"."observations" to "service_role";

grant insert on table "public"."observations" to "service_role";

grant references on table "public"."observations" to "service_role";

grant select on table "public"."observations" to "service_role";

grant trigger on table "public"."observations" to "service_role";

grant truncate on table "public"."observations" to "service_role";

grant update on table "public"."observations" to "service_role";

grant delete on table "public"."patients" to "anon";

grant insert on table "public"."patients" to "anon";

grant references on table "public"."patients" to "anon";

grant select on table "public"."patients" to "anon";

grant trigger on table "public"."patients" to "anon";

grant truncate on table "public"."patients" to "anon";

grant update on table "public"."patients" to "anon";

grant delete on table "public"."patients" to "authenticated";

grant insert on table "public"."patients" to "authenticated";

grant references on table "public"."patients" to "authenticated";

grant select on table "public"."patients" to "authenticated";

grant trigger on table "public"."patients" to "authenticated";

grant truncate on table "public"."patients" to "authenticated";

grant update on table "public"."patients" to "authenticated";

grant delete on table "public"."patients" to "service_role";

grant insert on table "public"."patients" to "service_role";

grant references on table "public"."patients" to "service_role";

grant select on table "public"."patients" to "service_role";

grant trigger on table "public"."patients" to "service_role";

grant truncate on table "public"."patients" to "service_role";

grant update on table "public"."patients" to "service_role";

grant delete on table "public"."patients_files" to "anon";

grant insert on table "public"."patients_files" to "anon";

grant references on table "public"."patients_files" to "anon";

grant select on table "public"."patients_files" to "anon";

grant trigger on table "public"."patients_files" to "anon";

grant truncate on table "public"."patients_files" to "anon";

grant update on table "public"."patients_files" to "anon";

grant delete on table "public"."patients_files" to "authenticated";

grant insert on table "public"."patients_files" to "authenticated";

grant references on table "public"."patients_files" to "authenticated";

grant select on table "public"."patients_files" to "authenticated";

grant trigger on table "public"."patients_files" to "authenticated";

grant truncate on table "public"."patients_files" to "authenticated";

grant update on table "public"."patients_files" to "authenticated";

grant delete on table "public"."patients_files" to "service_role";

grant insert on table "public"."patients_files" to "service_role";

grant references on table "public"."patients_files" to "service_role";

grant select on table "public"."patients_files" to "service_role";

grant trigger on table "public"."patients_files" to "service_role";

grant truncate on table "public"."patients_files" to "service_role";

grant update on table "public"."patients_files" to "service_role";

grant delete on table "public"."public_legal" to "anon";

grant insert on table "public"."public_legal" to "anon";

grant references on table "public"."public_legal" to "anon";

grant select on table "public"."public_legal" to "anon";

grant trigger on table "public"."public_legal" to "anon";

grant truncate on table "public"."public_legal" to "anon";

grant update on table "public"."public_legal" to "anon";

grant delete on table "public"."public_legal" to "authenticated";

grant insert on table "public"."public_legal" to "authenticated";

grant references on table "public"."public_legal" to "authenticated";

grant select on table "public"."public_legal" to "authenticated";

grant trigger on table "public"."public_legal" to "authenticated";

grant truncate on table "public"."public_legal" to "authenticated";

grant update on table "public"."public_legal" to "authenticated";

grant delete on table "public"."public_legal" to "service_role";

grant insert on table "public"."public_legal" to "service_role";

grant references on table "public"."public_legal" to "service_role";

grant select on table "public"."public_legal" to "service_role";

grant trigger on table "public"."public_legal" to "service_role";

grant truncate on table "public"."public_legal" to "service_role";

grant update on table "public"."public_legal" to "service_role";

grant delete on table "public"."recommendations" to "anon";

grant insert on table "public"."recommendations" to "anon";

grant references on table "public"."recommendations" to "anon";

grant select on table "public"."recommendations" to "anon";

grant trigger on table "public"."recommendations" to "anon";

grant truncate on table "public"."recommendations" to "anon";

grant update on table "public"."recommendations" to "anon";

grant delete on table "public"."recommendations" to "authenticated";

grant insert on table "public"."recommendations" to "authenticated";

grant references on table "public"."recommendations" to "authenticated";

grant select on table "public"."recommendations" to "authenticated";

grant trigger on table "public"."recommendations" to "authenticated";

grant truncate on table "public"."recommendations" to "authenticated";

grant update on table "public"."recommendations" to "authenticated";

grant delete on table "public"."recommendations" to "service_role";

grant insert on table "public"."recommendations" to "service_role";

grant references on table "public"."recommendations" to "service_role";

grant select on table "public"."recommendations" to "service_role";

grant trigger on table "public"."recommendations" to "service_role";

grant truncate on table "public"."recommendations" to "service_role";

grant update on table "public"."recommendations" to "service_role";

grant delete on table "public"."survey_responses" to "anon";

grant insert on table "public"."survey_responses" to "anon";

grant references on table "public"."survey_responses" to "anon";

grant select on table "public"."survey_responses" to "anon";

grant trigger on table "public"."survey_responses" to "anon";

grant truncate on table "public"."survey_responses" to "anon";

grant update on table "public"."survey_responses" to "anon";

grant delete on table "public"."survey_responses" to "authenticated";

grant insert on table "public"."survey_responses" to "authenticated";

grant references on table "public"."survey_responses" to "authenticated";

grant select on table "public"."survey_responses" to "authenticated";

grant trigger on table "public"."survey_responses" to "authenticated";

grant truncate on table "public"."survey_responses" to "authenticated";

grant update on table "public"."survey_responses" to "authenticated";

grant delete on table "public"."survey_responses" to "service_role";

grant insert on table "public"."survey_responses" to "service_role";

grant references on table "public"."survey_responses" to "service_role";

grant select on table "public"."survey_responses" to "service_role";

grant trigger on table "public"."survey_responses" to "service_role";

grant truncate on table "public"."survey_responses" to "service_role";

grant update on table "public"."survey_responses" to "service_role";

grant delete on table "public"."user_household" to "anon";

grant insert on table "public"."user_household" to "anon";

grant references on table "public"."user_household" to "anon";

grant select on table "public"."user_household" to "anon";

grant trigger on table "public"."user_household" to "anon";

grant truncate on table "public"."user_household" to "anon";

grant update on table "public"."user_household" to "anon";

grant delete on table "public"."user_household" to "authenticated";

grant insert on table "public"."user_household" to "authenticated";

grant references on table "public"."user_household" to "authenticated";

grant select on table "public"."user_household" to "authenticated";

grant trigger on table "public"."user_household" to "authenticated";

grant truncate on table "public"."user_household" to "authenticated";

grant update on table "public"."user_household" to "authenticated";

grant delete on table "public"."user_household" to "service_role";

grant insert on table "public"."user_household" to "service_role";

grant references on table "public"."user_household" to "service_role";

grant select on table "public"."user_household" to "service_role";

grant trigger on table "public"."user_household" to "service_role";

grant truncate on table "public"."user_household" to "service_role";

grant update on table "public"."user_household" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";

grant delete on table "public"."users_patients" to "anon";

grant insert on table "public"."users_patients" to "anon";

grant references on table "public"."users_patients" to "anon";

grant select on table "public"."users_patients" to "anon";

grant trigger on table "public"."users_patients" to "anon";

grant truncate on table "public"."users_patients" to "anon";

grant update on table "public"."users_patients" to "anon";

grant delete on table "public"."users_patients" to "authenticated";

grant insert on table "public"."users_patients" to "authenticated";

grant references on table "public"."users_patients" to "authenticated";

grant select on table "public"."users_patients" to "authenticated";

grant trigger on table "public"."users_patients" to "authenticated";

grant truncate on table "public"."users_patients" to "authenticated";

grant update on table "public"."users_patients" to "authenticated";

grant delete on table "public"."users_patients" to "service_role";

grant insert on table "public"."users_patients" to "service_role";

grant references on table "public"."users_patients" to "service_role";

grant select on table "public"."users_patients" to "service_role";

grant trigger on table "public"."users_patients" to "service_role";

grant truncate on table "public"."users_patients" to "service_role";

grant update on table "public"."users_patients" to "service_role";

create policy "Authenticated users can delete clinics"
on "public"."clinics"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert clinics"
on "public"."clinics"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select clinics"
on "public"."clinics"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update clinics"
on "public"."clinics"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Authenticated users can delete clinics_patients"
on "public"."clinics_patients"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert clinics_patients"
on "public"."clinics_patients"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select clinics_patients"
on "public"."clinics_patients"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update clinics_patients"
on "public"."clinics_patients"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Enable read access for all users"
on "public"."code_routes"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."codes_breeds"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."codes_immunizations"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."codes_medication_ovet"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."codes_observations"
as permissive
for select
to public
using (true);


create policy "Authenticated users can delete encounters"
on "public"."encounters"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert encounters"
on "public"."encounters"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select encounters"
on "public"."encounters"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update encounters"
on "public"."encounters"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Authenticated users can delete imaging"
on "public"."imaging"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert imaging"
on "public"."imaging"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select imaging"
on "public"."imaging"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update imaging"
on "public"."imaging"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Authenticated users can delete immunization_recommendations"
on "public"."immunization_recommendations"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert immunization_recommendations"
on "public"."immunization_recommendations"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select immunization_recommendations"
on "public"."immunization_recommendations"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update immunization_recommendations"
on "public"."immunization_recommendations"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Authenticated users can delete immunizations"
on "public"."immunizations"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert immunizations"
on "public"."immunizations"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select immunizations"
on "public"."immunizations"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update immunizations"
on "public"."immunizations"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Enable insert for authenticated users only"
on "public"."invited_users"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can delete lab results"
on "public"."lab_results"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert lab results"
on "public"."lab_results"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select lab results"
on "public"."lab_results"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update lab results"
on "public"."lab_results"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Authenticated users can select medication requests"
on "public"."medication_requests"
as permissive
for select
to authenticated
using (true);


create policy "Enable insert for specific users"
on "public"."medication_requests"
as permissive
for insert
to authenticated
with check ((( SELECT auth.uid() AS uid) = '1c91921b-9087-4b26-b65a-880dc1763f2f'::uuid));


create policy "Specific users can delete medication requests"
on "public"."medication_requests"
as permissive
for delete
to authenticated
using (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['florence@ovet.ca'::text, 'antoine@ovet.ca'::text, 'yan@ovet.ca'::text])));


create policy "Specific users can update medication requests"
on "public"."medication_requests"
as permissive
for update
to authenticated
using (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['florence@ovet.ca'::text, 'antoine@ovet.ca'::text, 'yan@ovet.ca'::text])))
with check (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['florence@ovet.ca'::text, 'antoine@ovet.ca'::text, 'yan@ovet.ca'::text])));


create policy "Authenticated observations can delete observations"
on "public"."observations"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated observations can insert observations"
on "public"."observations"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated observations can select observations"
on "public"."observations"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated observations can update observations"
on "public"."observations"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Authenticated users can delete patients"
on "public"."patients"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert patients"
on "public"."patients"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select patients"
on "public"."patients"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update patients"
on "public"."patients"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Authenticated users can delete patients_files"
on "public"."patients_files"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert patients_files"
on "public"."patients_files"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select observations"
on "public"."patients_files"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update patients_files"
on "public"."patients_files"
as permissive
for update
to authenticated
using (true)
with check (true);


create policy "Enable read access for all users"
on "public"."public_legal"
as permissive
for select
to public
using (true);


create policy "Enable insert for authenticated users only"
on "public"."recommendations"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."recommendations"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."survey_responses"
as permissive
for select
to public
using (true);


create policy "Authenticated users can select their own household records"
on "public"."user_household"
as permissive
for select
to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));


create policy "Enable users to view their own data only"
on "public"."users"
as permissive
for select
to authenticated
using ((( SELECT auth.uid() AS uid) = id));


create policy "Authenticated users can delete users_patients"
on "public"."users_patients"
as permissive
for delete
to authenticated
using (true);


create policy "Authenticated users can insert users_patients"
on "public"."users_patients"
as permissive
for insert
to authenticated
with check (true);


create policy "Authenticated users can select users_patients"
on "public"."users_patients"
as permissive
for select
to authenticated
using (true);


create policy "Authenticated users can update users_patients"
on "public"."users_patients"
as permissive
for update
to authenticated
using (true)
with check (true);


CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.codes_medication_ovet FOR EACH ROW EXECUTE FUNCTION moddatetime('last_updated_at');

CREATE TRIGGER trigger_create_household AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION create_household_on_user_creation();


