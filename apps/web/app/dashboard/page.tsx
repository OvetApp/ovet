import { createClient } from "@/lib/supabase/server";

export default async function DashboardPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const isNewUser = user
    ? new Date().getTime() - new Date(user.created_at).getTime() <
      24 * 60 * 60 * 1000
    : false;

  return (
    <div>
      <h1>Dashboard</h1>
      <h2>user.mail: {user?.email}</h2>
      <h2>auth.user.email: {user?.identities?.at(0)?.identity_data?.email}</h2>
      <h2>auth.user.id: {user?.identities?.at(0)?.user_id}</h2>
      <h3>{isNewUser ? "Onboarding completed!" : "Onboarding TO BE DONE!."}</h3>
    </div>
  );
}
