import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

export default async function HomePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Redirect unauthenticated users to login
  if (!user) {
    redirect("/auth/login");
  }

  // Get user profile data to check if onboarding is complete
  const { data: profile } = await supabase
    .from("profiles")
    .select("first_name, phone_number")
    .eq("id", user.id)
    .single();

  // Check if user has completed onboarding (has first_name AND phone_number)
  const hasFirstName = profile?.first_name && profile.first_name.trim() !== "";
  const hasPhoneNumber = profile?.phone_number && profile.phone_number.trim() !== "";

  if (!hasFirstName || !hasPhoneNumber) {
    redirect("/onboarding");
  }

  // User is authenticated and has completed onboarding
  redirect("/dashboard");
}
