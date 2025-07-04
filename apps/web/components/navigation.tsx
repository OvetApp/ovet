"use client";

import { useRouter, usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { Button } from "@workspace/ui/components/button";
import { createClient } from "@/lib/supabase/client";
import { User } from "@supabase/supabase-js";
import { Menu, X, LogOut } from "lucide-react";
import Link from "next/link";

interface NavigationProps {
  user?: User | null;
}

export function Navigation({ user: initialUser }: NavigationProps) {
  const [user, setUser] = useState<User | null>(initialUser || null);
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();
  const pathname = usePathname();

  const supabase = createClient();

  useEffect(() => {
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      setUser(session?.user ?? null);
      if (event === "SIGNED_OUT") {
        router.push("/auth/login");
      }
    });

    return () => subscription.unsubscribe();
  }, [router, supabase.auth]);

  const handleSignOut = async () => {
    setIsLoading(true);
    try {
      await supabase.auth.signOut();
      router.push("/auth/login");
    } catch (error) {
      console.error("Error signing out:", error);
    } finally {
      setIsLoading(false);
      setIsMenuOpen(false);
    }
  };

  const isAuthPage = pathname.startsWith("/auth");
  const isDashboard = pathname.startsWith("/dashboard");

  if (isAuthPage) {
    return (
      <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-sm border-b">
        <div className="container mx-auto px-4 py-3">
          <div className="flex items-center justify-between">
            <Link href="/" className="text-xl font-bold">
              Ovet
            </Link>
            <div className="hidden md:flex items-center space-x-4">
              {pathname !== "/auth/login" && (
                <Link href="/auth/login">
                  <Button variant="ghost" size="sm">
                    Sign In
                  </Button>
                </Link>
              )}
              {pathname !== "/auth/signup" && (
                <Link href="/auth/signup">
                  <Button size="sm">Sign Up</Button>
                </Link>
              )}
            </div>
          </div>
        </div>
      </nav>
    );
  }

  if (user) {
    return (
      <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-sm border-b">
        <div className="container mx-auto px-4 py-3">
          <div className="flex items-center justify-between">
            <Link href="/dashboard" className="text-xl font-bold">
              Ovet
            </Link>
            
            {/* Desktop Navigation */}
            <div className="hidden md:flex items-center space-x-6">
              <Link href="/dashboard" className={`text-sm font-medium transition-colors hover:text-primary ${isDashboard && pathname === "/dashboard" ? "text-primary" : "text-muted-foreground"}`}>
                Dashboard
              </Link>
              <Link href="/dashboard/profile" className={`text-sm font-medium transition-colors hover:text-primary ${pathname === "/dashboard/profile" ? "text-primary" : "text-muted-foreground"}`}>
                Profile
              </Link>
              <Link href="/dashboard/settings" className={`text-sm font-medium transition-colors hover:text-primary ${pathname === "/dashboard/settings" ? "text-primary" : "text-muted-foreground"}`}>
                Settings
              </Link>
              <Button
                variant="ghost"
                size="sm"
                onClick={handleSignOut}
                disabled={isLoading}
                className="text-muted-foreground hover:text-foreground"
              >
                <LogOut className="h-4 w-4 mr-2" />
                {isLoading ? "Signing out..." : "Sign Out"}
              </Button>
            </div>

            {/* Mobile Menu Button */}
            <Button
              variant="ghost"
              size="sm"
              className="md:hidden"
              onClick={() => setIsMenuOpen(!isMenuOpen)}
            >
              {isMenuOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
            </Button>
          </div>

          {/* Mobile Navigation */}
          {isMenuOpen && (
            <div className="md:hidden absolute top-full left-0 right-0 bg-white border-b shadow-lg z-10">
              <div className="container mx-auto px-4 py-4">
                <div className="flex flex-col space-y-3">
                  <Link 
                    href="/dashboard" 
                    className={`text-sm font-medium transition-colors hover:text-primary py-2 px-2 rounded ${isDashboard && pathname === "/dashboard" ? "text-primary bg-primary/10" : "text-muted-foreground"}`}
                    onClick={() => setIsMenuOpen(false)}
                  >
                    Dashboard
                  </Link>
                  <Link 
                    href="/dashboard/profile" 
                    className={`text-sm font-medium transition-colors hover:text-primary py-2 px-2 rounded ${pathname === "/dashboard/profile" ? "text-primary bg-primary/10" : "text-muted-foreground"}`}
                    onClick={() => setIsMenuOpen(false)}
                  >
                    Profile
                  </Link>
                  <Link 
                    href="/dashboard/settings" 
                    className={`text-sm font-medium transition-colors hover:text-primary py-2 px-2 rounded ${pathname === "/dashboard/settings" ? "text-primary bg-primary/10" : "text-muted-foreground"}`}
                    onClick={() => setIsMenuOpen(false)}
                  >
                    Settings
                  </Link>
                  <div className="border-t pt-3 mt-3">
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={handleSignOut}
                      disabled={isLoading}
                      className="justify-start text-muted-foreground hover:text-foreground w-full"
                    >
                      <LogOut className="h-4 w-4 mr-2" />
                      {isLoading ? "Signing out..." : "Sign Out"}
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      </nav>
    );
  }

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-sm border-b">
      <div className="container mx-auto px-4 py-3">
        <div className="flex items-center justify-between">
          <Link href="/" className="text-xl font-bold">
            Ovet
          </Link>
          <div className="flex items-center space-x-4">
            <Link href="/auth/login">
              <Button variant="ghost" size="sm">
                Sign In
              </Button>
            </Link>
            <Link href="/auth/signup">
              <Button size="sm">Sign Up</Button>
            </Link>
          </div>
        </div>
      </div>
    </nav>
  );
}