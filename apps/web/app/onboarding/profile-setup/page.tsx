'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@workspace/ui/components/card'
import { Button } from '@workspace/ui/components/button'
import { Input } from '@workspace/ui/components/input'
import { Label } from '@workspace/ui/components/label'
import { Textarea } from '@workspace/ui/components/textarea'
import { ArrowLeft, ArrowRight, User } from 'lucide-react'

export default function ProfileSetupPage() {
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const [username, setUsername] = useState('')
  const [bio, setBio] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()
  const supabase = createClient()

  const handleBack = () => {
    router.push('/onboarding/welcome')
  }

  const handleContinue = async () => {
    setIsLoading(true)
    
    try {
      const fullName = `${firstName} ${lastName}`.trim()
      
      const { error } = await supabase.auth.updateUser({
        data: {
          full_name: fullName,
          first_name: firstName,
          last_name: lastName,
          username: username,
          bio: bio,
          onboarding_completed: false // Will be set to true after preferences
        }
      })

      if (error) {
        console.error('Error updating profile:', error)
        // In a real app, show error toast
      } else {
        router.push('/onboarding/preferences')
      }
    } finally {
      setIsLoading(false)
    }
  }

  const isFormValid = firstName.trim() && lastName.trim() && username.trim()

  return (
    <div className="min-h-svh bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-6">
      <div className="w-full max-w-md">
        <Card className="border-0 shadow-xl">
          <CardHeader className="text-center">
            <div className="flex justify-center mb-4">
              <div className="rounded-full bg-blue-100 p-3">
                <User className="h-12 w-12 text-blue-600" />
              </div>
            </div>
            <CardTitle className="text-2xl">Complete Your Profile</CardTitle>
            <CardDescription>
              Tell us a bit about yourself to personalize your experience
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="firstName">First Name *</Label>
                <Input
                  id="firstName"
                  value={firstName}
                  onChange={(e) => setFirstName(e.target.value)}
                  placeholder="John"
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="lastName">Last Name *</Label>
                <Input
                  id="lastName"
                  value={lastName}
                  onChange={(e) => setLastName(e.target.value)}
                  placeholder="Doe"
                  required
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="username">Username *</Label>
              <Input
                id="username"
                value={username}
                onChange={(e) => setUsername(e.target.value.toLowerCase().replace(/[^a-z0-9_]/g, ''))}
                placeholder="johndoe"
                required
              />
              <p className="text-xs text-muted-foreground">
                Only lowercase letters, numbers, and underscores allowed
              </p>
            </div>

            <div className="space-y-2">
              <Label htmlFor="bio">Bio (optional)</Label>
              <Textarea
                id="bio"
                value={bio}
                onChange={(e) => setBio(e.target.value)}
                placeholder="Tell us a little about yourself..."
                rows={3}
              />
            </div>

            <div className="flex space-x-3 pt-4">
              <Button
                variant="outline"
                onClick={handleBack}
                className="flex-1"
              >
                <ArrowLeft className="mr-2 h-4 w-4" />
                Back
              </Button>
              
              <Button
                onClick={handleContinue}
                disabled={!isFormValid || isLoading}
                className="flex-1"
              >
                {isLoading ? (
                  <>
                    <div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent" />
                    Saving...
                  </>
                ) : (
                  <>
                    Continue
                    <ArrowRight className="ml-2 h-4 w-4" />
                  </>
                )}
              </Button>
            </div>

            <div className="text-center pt-2">
              <p className="text-xs text-muted-foreground">
                Step 2 of 3
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}