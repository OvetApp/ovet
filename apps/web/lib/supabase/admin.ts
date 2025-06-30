import { createClient } from '@supabase/supabase-js'

if (!process.env.NEXT_PUBLIC_SUPABASE_URL) {
  throw new Error('Missing env.NEXT_PUBLIC_SUPABASE_URL')
}

if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
  throw new Error('Missing env.SUPABASE_SERVICE_ROLE_KEY')
}

export const adminClient = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  }
)

export async function getAllUsers() {
  const { data, error } = await adminClient.auth.admin.listUsers()
  
  if (error) {
    throw new Error(`Failed to fetch users: ${error.message}`)
  }
  
  return data
}

export async function getUserById(userId: string) {
  const { data, error } = await adminClient.auth.admin.getUserById(userId)
  
  if (error) {
    throw new Error(`Failed to fetch user: ${error.message}`)
  }
  
  return data
}

export async function getUserByEmail(email: string) {
  const { data, error } = await adminClient
    .from('auth.users')
    .select('*')
    .eq('email', email)
    .single()
  
  if (error) {
    throw new Error(`Failed to fetch user by email: ${error.message}`)
  }
  
  return data
}