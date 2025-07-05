import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@workspace/ui/components/card";
import { Button } from "@workspace/ui/components/button";
import { Mail, CheckCircle } from "lucide-react";
import Link from "next/link";

export default function SignUpSuccessPage() {
  return (
    <div className="flex min-h-[calc(100vh-4rem)] w-full items-center justify-center p-6 md:p-10">
      <div className="w-full max-w-sm">
        <Card>
          <CardHeader className="text-center">
            <div className="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-green-100">
              <CheckCircle className="h-8 w-8 text-green-600" />
            </div>
            <CardTitle className="text-2xl">Account Created!</CardTitle>
            <CardDescription>
              We've sent a confirmation email to your inbox
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="rounded-lg bg-blue-50 p-4">
              <div className="flex items-center gap-3">
                <Mail className="h-5 w-5 text-blue-600" />
                <div>
                  <p className="text-sm font-medium text-blue-900">
                    Check your email
                  </p>
                  <p className="text-sm text-blue-700">
                    Click the verification link to activate your account
                  </p>
                </div>
              </div>
            </div>
            <div className="space-y-2">
              <Button asChild className="w-full">
                <Link href="/auth/login">
                  Continue to Sign In
                </Link>
              </Button>
              <Button asChild variant="outline" className="w-full">
                <Link href="/">
                  Back to Home
                </Link>
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}