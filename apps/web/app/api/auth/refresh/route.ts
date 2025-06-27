import { createClient } from '@/lib/supabase/server'
import { NextRequest, NextResponse } from 'next/server'

export async function POST() {
  try {
    const supabase = await createClient()
    
    // Get the current session
    const { data: { session }, error: sessionError } = await supabase.auth.getSession()
    
    if (sessionError || !session) {
      return NextResponse.json(
        { error: 'No active session found' },
        { status: 401 }
      )
    }

    // Refresh the session
    const { data, error } = await supabase.auth.refreshSession()
    
    if (error) {
      return NextResponse.json(
        { error: 'Failed to refresh session' },
        { status: 500 }
      )
    }

    if (!data.session) {
      return NextResponse.json(
        { error: 'Session refresh failed' },
        { status: 401 }
      )
    }

    return NextResponse.json({
      access_token: data.session.access_token,
      refresh_token: data.session.refresh_token,
      expires_at: data.session.expires_at,
      expires_in: data.session.expires_in,
      user: data.session.user
    })
  } catch (error) {
    console.error('Token refresh error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function GET() {
  return NextResponse.json(
    { error: 'Method not allowed' },
    { status: 405 }
  )
}