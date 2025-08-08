import { AuthOptions } from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';
import GoogleProvider from 'next-auth/providers/google';
import { User } from '@/models';
import { connectDB } from './db';

export const authOptions: AuthOptions = {
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID as string,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET as string,
    }),
    CredentialsProvider({
      id: 'credentials',
      name: 'Credentials',
      credentials: {
        email: { label: 'Email', type: 'text' },
        password: { label: 'Password', type: 'password' },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          throw new Error('Необходимо указать email и пароль');
        }

        await connectDB();

        const user = await User.findOne({ email: credentials.email });
        if (!user) {
          throw new Error('Пользователь не найден');
        }

        const isValid = await user.comparePassword(credentials.password);
        if (!isValid) {
          throw new Error('Неверный пароль');
        }

        if (!user.isVerified) {
          throw new Error('Email не подтвержден');
        }

        return {
          id: user._id.toString(),
          email: user.email,
          isAdmin: user.isAdmin,
        } as any;
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user, account, profile }) {
      if (user) {
        token.id = (user as any).id;
        token.email = (user as any).email;
        token.isAdmin = (user as any).isAdmin;
      }
      // When signing in with Google, ensure token fields exist
      if (account?.provider === 'google') {
        token.email = token.email || (profile as any)?.email;
      }
      return token;
    },
    async session({ session, token }) {
      if (token) {
        (session.user as any).id = token.id as string;
        session.user.email = token.email as string;
        (session.user as any).isAdmin = (token as any).isAdmin as boolean;
      }
      return session;
    },
  },
  pages: {
    signIn: '/login',
  },
  session: {
    strategy: 'jwt',
    maxAge: 30 * 24 * 60 * 60,
  },
};

// Расширяем типы для NextAuth
declare module 'next-auth' {
  interface User {
    id: string;
    email: string;
    isAdmin: boolean;
  }

  interface Session {
    user: User;
  }
}

declare module 'next-auth/jwt' {
  interface JWT {
    id: string;
    email: string;
    isAdmin: boolean;
  }
}
