"use client";

import { useEffect, useState } from "react";
import { useRouter, usePathname } from "next/navigation";
import { Loader2 } from "lucide-react";

interface PageTransitionProps {
  children: React.ReactNode;
}

export function PageTransition({ children }: PageTransitionProps) {
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    const handleStart = () => setIsLoading(true);

    // Listen for route changes
    const originalPush = router.push;
    const originalReplace = router.replace;

    router.push = (...args) => {
      handleStart();
      return originalPush.apply(router, args);
    };

    router.replace = (...args) => {
      handleStart();
      return originalReplace.apply(router, args);
    };

    // Clean up on unmount
    return () => {
      router.push = originalPush;
      router.replace = originalReplace;
    };
  }, [router]);

  useEffect(() => {
    setIsLoading(false);
  }, [pathname]);

  if (isLoading) {
    return (
      <div className="fixed inset-0 bg-white/80 backdrop-blur-sm z-50 flex items-center justify-center">
        <div className="flex items-center space-x-2">
          <Loader2 className="h-6 w-6 animate-spin text-primary" />
          <span className="text-sm font-medium">Loading...</span>
        </div>
      </div>
    );
  }

  return <div className="transition-opacity duration-200 ease-in-out">{children}</div>;
}