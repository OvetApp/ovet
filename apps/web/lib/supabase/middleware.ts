import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({
    request,
  });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          );
          supabaseResponse = NextResponse.next({
            request,
          });
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          );
        },
      },
    }
  );

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const url = request.nextUrl.clone();
  const pathname = request.nextUrl.pathname;

  // Define route patterns
  const authRoutes = [
    "/auth/login",
    "/auth/signup",
    "/auth/forgot-password",
    "/auth/reset-password",
    "/auth/verify-email",
    "/auth/error",
    "/auth/callback",
  ];
  const publicRoutes = ["/", ...authRoutes];
  const protectedRoutes = ["/dashboard", "/onboarding", "/protected"];
  const logoutRoute = "/auth/logout";

  // Handle logout
  if (pathname === logoutRoute) {
    url.pathname = "/auth/login";
    const response = NextResponse.redirect(url);
    supabaseResponse.cookies.getAll().forEach((cookie) => {
      response.cookies.set(cookie.name, cookie.value, cookie);
    });
    return response;
  }

  // Check if current path is an auth route that should redirect when authenticated
  const isAuthPageThatShouldRedirect =
    pathname === "/auth/login" || 
    pathname === "/auth/signup" || 
    pathname === "/auth/forgot-password";

  // Check if current path is a protected route
  const isProtectedRoute = protectedRoutes.some((route) =>
    pathname.startsWith(route)
  );

  // Check if current path is a public route
  const isPublicRoute = publicRoutes.some(
    (route) => pathname === route || pathname.startsWith(route)
  );

  if (user) {
    // User is authenticated
    if (isAuthPageThatShouldRedirect) {
      // Redirect authenticated users away from login/signup/forgot-password pages
      url.pathname = "/dashboard";
      const response = NextResponse.redirect(url);
      supabaseResponse.cookies.getAll().forEach((cookie) => {
        response.cookies.set(cookie.name, cookie.value, cookie);
      });
      return response;
    }

    // Check if user has completed onboarding for protected routes
    if (isProtectedRoute && !pathname.startsWith("/onboarding")) {
      // For now, assume onboarding is complete - this would be enhanced with user profile checks
      // TODO: Add onboarding completion check from user profile
    }
  } else {
    // User is not authenticated
    if (!isPublicRoute) {
      // Store the original URL to redirect back after login
      url.pathname = "/auth/login";
      url.searchParams.set("returnUrl", pathname);
      const response = NextResponse.redirect(url);
      supabaseResponse.cookies.getAll().forEach((cookie) => {
        response.cookies.set(cookie.name, cookie.value, cookie);
      });
      return response;
    }
  }

  return supabaseResponse;
}
