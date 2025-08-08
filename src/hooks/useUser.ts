"use client";

import { useState } from 'react';
import { signIn, signOut, useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';

export function useUser() {
  const router = useRouter();
  const { data: session } = useSession();
  const [loading, setLoading] = useState(false);

  const loginWithGoogle = async () => {
    setLoading(true);
    try {
      await signIn('google', { callbackUrl: '/' });
    } finally {
      setLoading(false);
    }
  };

  const logout = async () => {
    await signOut({ callbackUrl: '/login' });
  };

  return { session, loading, loginWithGoogle, logout };
}
