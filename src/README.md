# Neo Movies Web

## Google OAuth (NextAuth)

- Add to `.env.local`:
  - `NEXTAUTH_URL=http://localhost:3000`
  - `NEXTAUTH_SECRET=your_nextauth_secret`
  - `GOOGLE_CLIENT_ID=your_google_client_id`
  - `GOOGLE_CLIENT_SECRET=your_google_client_secret`
- Google Cloud OAuth consent screen:
  - Authorized redirect URI: `http://localhost:3000/api/auth/callback/google`
- Login page already includes a "Continue with Google" button.