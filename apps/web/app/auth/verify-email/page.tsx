"use client";

import { Suspense, useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@workspace/ui/components/card";
import { Button } from "@workspace/ui/components/button";
import { CheckCircle, XCircle, Loader2 } from "lucide-react";

function VerifyEmailHandler() {
  const [isVerifying, setIsVerifying] = useState(true);
  const [isVerified, setIsVerified] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();
  const searchParams = useSearchParams();
  const supabase = createClient();

  useEffect(() => {
    const verifyEmail = async () => {
      const token = searchParams.get("token");
      const type = searchParams.get("type");

      if (!token || type !== "email") {
        setError("Invalid verification link");
        setIsVerifying(false);
        return;
      }

      try {
        const { error } = await supabase.auth.verifyOtp({
          token_hash: token,
          type: "email",
        });

        if (error) {
          setError(error.message);
        } else {
          setIsVerified(true);
          setTimeout(() => {
            router.push("/onboarding/welcome");
          }, 2000);
        }
      } catch {
        setError("An unexpected error occurred");
      } finally {
        setIsVerifying(false);
      }
    };

    verifyEmail();
  }, [searchParams, router, supabase.auth]);

  return (
    <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
      <div className="w-full max-w-sm">
        <Card>
          <CardHeader className="text-center">
            <CardTitle>Verify Your Email</CardTitle>
            <CardDescription>
              {isVerifying
                ? "Verifying your email address..."
                : isVerified
                  ? "Email verified successfully!"
                  : "Email verification failed"}
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex justify-center">
              {isVerifying && (
                <Loader2 className="h-12 w-12 animate-spin text-muted-foreground" />
              )}
              {!isVerifying && isVerified && (
                <CheckCircle className="h-12 w-12 text-green-600" />
              )}
              {!isVerifying && !isVerified && (
                <XCircle className="h-12 w-12 text-red-600" />
              )}
            </div>

            {error && (
              <div className="text-center text-sm text-red-600">{error}</div>
            )}

            {isVerified && (
              <div className="text-center text-sm text-green-600">
                Redirecting to onboarding...
              </div>
            )}

            {!isVerifying && !isVerified && (
              <div className="space-y-2">
                <Button
                  variant="outline"
                  className="w-full"
                  onClick={() => router.push("/auth/login")}
                >
                  Back to Login
                </Button>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

export default function VerifyEmailPage() {
  return (
    <Suspense
      fallback={
        <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
          <div className="w-full max-w-sm">
            <Card>
              <CardHeader className="text-center">
                <CardTitle>Verify Your Email</CardTitle>
                <CardDescription>Loading...</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex justify-center">
                  <Loader2 className="h-12 w-12 animate-spin text-muted-foreground" />
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      }
    >
      <VerifyEmailHandler />
    </Suspense>
  );
}
