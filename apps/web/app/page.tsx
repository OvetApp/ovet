import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { Button } from "@workspace/ui/components/button";

async function logoutAction() {
  "use server";
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/auth/login");
}

export default async function LogoutPage() {
  const supabase = await createClient();
  const { data, error } = await supabase.auth.getUser();
  const email = data?.user?.email ?? null;

  return (
    <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
      <div className="flex flex-col items-center space-y-4">
        {email ? (
          <p className="text-sm text-muted-foreground">Signed in as {email}</p>
        ) : (
          <p className="text-sm text-muted-foreground">Not signed in</p>
        )}
        <form action={logoutAction}>
          <Button type="submit">Logout</Button>
        </form>
      </div>
    </div>
  );
}
