"use client";

import { cn } from "@workspace/ui/lib/utils";
import { createClient } from "@/lib/supabase/client";
import { Button } from "@workspace/ui/components/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@workspace/ui/components/card'
import { Input } from '@workspace/ui/components/input'
import { Label } from '@workspace/ui/components/label'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useState, useEffect } from 'react'
import { AlertCircle, Loader2, Check, X } from 'lucide-react'

export function SignUpForm({ className, ...props }: React.ComponentPropsWithoutRef<'div'>) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [repeatPassword, setRepeatPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [emailError, setEmailError] = useState<string | null>(null)
  const [passwordError, setPasswordError] = useState<string | null>(null)
  const [repeatPasswordError, setRepeatPasswordError] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()

  useEffect(() => {
    // Clear field-specific errors when user starts typing
    if (email && emailError) setEmailError(null)
    if (password && passwordError) setPasswordError(null)
    if (repeatPassword && repeatPasswordError) setRepeatPasswordError(null)
  }, [email, password, repeatPassword, emailError, passwordError, repeatPasswordError])

  const validateEmail = (email: string) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!email) return 'Email is required'
    if (!emailRegex.test(email)) return 'Please enter a valid email address'
    return null
  }

  const validatePassword = (password: string) => {
    if (!password) return 'Password is required'
    if (password.length < 8) return 'Password must be at least 8 characters'
    if (!/(?=.*[a-z])/.test(password)) return 'Password must contain at least one lowercase letter'
    if (!/(?=.*[A-Z])/.test(password)) return 'Password must contain at least one uppercase letter'
    if (!/(?=.*\d)/.test(password)) return 'Password must contain at least one number'
    return null
  }

  const validateRepeatPassword = (password: string, repeatPassword: string) => {
    if (!repeatPassword) return 'Please confirm your password'
    if (password !== repeatPassword) return 'Passwords do not match'
    return null
  }

  const getPasswordStrength = (password: string) => {
    let score = 0
    if (password.length >= 8) score++
    if (/(?=.*[a-z])/.test(password)) score++
    if (/(?=.*[A-Z])/.test(password)) score++
    if (/(?=.*\d)/.test(password)) score++
    if (/(?=.*[!@#$%^&*])/.test(password)) score++
    return score
  }

  const passwordStrength = getPasswordStrength(password)
  const strengthColors = ['bg-red-500', 'bg-red-400', 'bg-yellow-400', 'bg-green-400', 'bg-green-500']
  const strengthLabels = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong']

  const handleSignUp = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setEmailError(null)
    setPasswordError(null)
    setRepeatPasswordError(null)

    // Validate fields
    const emailValidation = validateEmail(email)
    const passwordValidation = validatePassword(password)
    const repeatPasswordValidation = validateRepeatPassword(password, repeatPassword)

    if (emailValidation) {
      setEmailError(emailValidation)
      return
    }

    if (passwordValidation) {
      setPasswordError(passwordValidation)
      return
    }

    if (repeatPasswordValidation) {
      setRepeatPasswordError(repeatPasswordValidation)
      return
    }

    const supabase = createClient()
    setIsLoading(true)

    try {
      const { error } = await supabase.auth.signUp({
        email: email.trim().toLowerCase(),
        password,
        options: {
          emailRedirectTo: `${window.location.origin}/auth/verify-email`,
        },
      })
      
      if (error) {
        if (error.message.includes('User already registered')) {
          setError('An account with this email already exists. Please sign in instead.')
        } else if (error.message.includes('Password should be')) {
          setError('Password does not meet security requirements. Please choose a stronger password.')
        } else {
          setError(error.message)
        }
        return
      }

      router.push('/auth/sign-up-success')
    } catch (error: unknown) {
      console.error('Sign up error:', error)
      setError('Network error. Please check your connection and try again.')
    } finally {
      setIsLoading(false);
    }
  };

  const isFormValid = email && password && repeatPassword && !emailError && !passwordError && !repeatPasswordError

  return (
    <div className={cn("flex flex-col gap-6", className)} {...props}>
      <Card>
        <CardHeader>
          <CardTitle className="text-2xl">Sign Up</CardTitle>
          <CardDescription>Create a new account to get started</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSignUp} noValidate>
            <div className="flex flex-col gap-6">
              <div className="grid gap-2">
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  name="email"
                  type="email"
                  placeholder="m@example.com"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  onBlur={() => setEmailError(validateEmail(email))}
                  aria-label="Email address"
                  aria-describedby={emailError ? "email-error" : undefined}
                  aria-invalid={!!emailError}
                  autoComplete="email"
                  disabled={isLoading}
                  className={emailError ? "border-red-500 focus-visible:ring-red-500" : ""}
                />
                {emailError && (
                  <p id="email-error" className="text-sm text-red-600 flex items-center gap-1">
                    <AlertCircle className="h-4 w-4" />
                    {emailError}
                  </p>
                )}
              </div>

              <div className="grid gap-2">
                <Label htmlFor="password">Password</Label>
                <Input
                  id="password"
                  name="password"
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  onBlur={() => setPasswordError(validatePassword(password))}
                  aria-label="Password"
                  aria-describedby={passwordError ? "password-error" : "password-strength"}
                  aria-invalid={!!passwordError}
                  autoComplete="new-password"
                  disabled={isLoading}
                  className={passwordError ? "border-red-500 focus-visible:ring-red-500" : ""}
                />
                {password && (
                  <div id="password-strength" className="space-y-2">
                    <div className="flex gap-1">
                      {[1, 2, 3, 4, 5].map((level) => (
                        <div
                          key={level}
                          className={`h-1 flex-1 rounded ${
                            level <= passwordStrength ? strengthColors[passwordStrength - 1] : 'bg-gray-200'
                          }`}
                        />
                      ))}
                    </div>
                    <p className="text-xs text-muted-foreground">
                      Strength: {passwordStrength > 0 ? strengthLabels[passwordStrength - 1] : 'Too weak'}
                    </p>
                  </div>
                )}
                {passwordError && (
                  <p id="password-error" className="text-sm text-red-600 flex items-center gap-1">
                    <AlertCircle className="h-4 w-4" />
                    {passwordError}
                  </p>
                )}
                <div className="text-xs text-muted-foreground space-y-1">
                  <p className="font-medium">Password requirements:</p>
                  <div className="grid grid-cols-1 gap-1">
                    <div className={`flex items-center gap-1 ${password.length >= 8 ? 'text-green-600' : 'text-gray-500'}`}>
                      {password.length >= 8 ? <Check className="h-3 w-3" /> : <X className="h-3 w-3" />}
                      At least 8 characters
                    </div>
                    <div className={`flex items-center gap-1 ${/(?=.*[a-z])/.test(password) ? 'text-green-600' : 'text-gray-500'}`}>
                      {/(?=.*[a-z])/.test(password) ? <Check className="h-3 w-3" /> : <X className="h-3 w-3" />}
                      One lowercase letter
                    </div>
                    <div className={`flex items-center gap-1 ${/(?=.*[A-Z])/.test(password) ? 'text-green-600' : 'text-gray-500'}`}>
                      {/(?=.*[A-Z])/.test(password) ? <Check className="h-3 w-3" /> : <X className="h-3 w-3" />}
                      One uppercase letter
                    </div>
                    <div className={`flex items-center gap-1 ${/(?=.*\d)/.test(password) ? 'text-green-600' : 'text-gray-500'}`}>
                      {/(?=.*\d)/.test(password) ? <Check className="h-3 w-3" /> : <X className="h-3 w-3" />}
                      One number
                    </div>
                  </div>
                </div>
              </div>

              <div className="grid gap-2">
                <Label htmlFor="repeat-password">Confirm Password</Label>
                <Input
                  id="repeat-password"
                  name="confirmPassword"
                  type="password"
                  required
                  value={repeatPassword}
                  onChange={(e) => setRepeatPassword(e.target.value)}
                  onBlur={() => setRepeatPasswordError(validateRepeatPassword(password, repeatPassword))}
                  aria-label="Confirm password"
                  aria-describedby={repeatPasswordError ? "repeat-password-error" : undefined}
                  aria-invalid={!!repeatPasswordError}
                  autoComplete="new-password"
                  disabled={isLoading}
                  className={repeatPasswordError ? "border-red-500 focus-visible:ring-red-500" : ""}
                />
                {repeatPasswordError && (
                  <p id="repeat-password-error" className="text-sm text-red-600 flex items-center gap-1">
                    <AlertCircle className="h-4 w-4" />
                    {repeatPasswordError}
                  </p>
                )}
              </div>

              {error && (
                <div className="rounded-lg bg-red-50 p-3">
                  <p className="text-sm text-red-800 flex items-center gap-2">
                    <AlertCircle className="h-4 w-4" />
                    {error}
                  </p>
                </div>
              )}

              <Button 
                type="submit" 
                className="w-full" 
                disabled={isLoading || !isFormValid}
                aria-describedby={isLoading ? "loading-text" : undefined}
              >
                {isLoading ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    <span id="loading-text">Creating Account...</span>
                  </>
                ) : (
                  'Sign Up'
                )}
              </Button>
            </div>
            <div className="mt-4 text-center text-sm">
              Already have an account?{' '}
              <Link 
                href="/auth/login" 
                className="underline underline-offset-4 hover:text-primary focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 rounded"
                tabIndex={isLoading ? -1 : 0}
              >
                Sign in
              </Link>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}