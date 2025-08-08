"use client";

import { useState } from 'react';
import { useRouter } from 'next/navigation';

export function useUser() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);

  const loginWithGoogle = async () => {
    setLoading(true);
    try {
      // handled via redirect button in UI
    } finally {
      setLoading(false);
    }
  };

  const logout = async () => {
    localStorage.removeItem('token');
    localStorage.removeItem('userName');
    localStorage.removeItem('userEmail');
    router.push('/login');
  };

  return { loading, loginWithGoogle, logout };
}
