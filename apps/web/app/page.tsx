import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

export default async function HomePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Redirect authenticated users to protected page
  if (user) {
    redirect("/protected");
  }

  // Show landing page for unauthenticated users
  return (
    <div className="flex min-h-[calc(100vh-4rem)] w-full flex-col items-center justify-center">
      <h1 className="text-4xl font-bold">Welcome to Ovet</h1>
      <p className="mt-4 text-lg text-muted-foreground">Please sign in to continue</p>
    </div>
  );
}
